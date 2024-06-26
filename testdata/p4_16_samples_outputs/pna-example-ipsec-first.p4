#include <core.p4>
#include <dpdk/pna.p4>
#include <pna/v0_5/types_metadata.p4>
#include <pna/v0_5/blocks.p4>

header ethernet_t {
    bit<48> dst_addr;
    bit<48> src_addr;
    bit<16> ether_type;
}

header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<6>  dscp;
    bit<2>  ecn;
    bit<16> total_length;
    bit<16> identification;
    bit<3>  flags;
    bit<13> fragment_offset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> header_checksum;
    bit<32> src_addr;
    bit<32> dst_addr;
}

header esp_t {
    bit<32> spi;
    bit<32> seq;
}

struct headers_t {
    ethernet_t ethernet;
    ipv4_t     ipv4;
    esp_t      esp;
}

struct metadata_t {
    bit<32> next_hop_id;
    bool    bypass;
}

ipsec_accelerator() ipsec;
parser MainParserImpl(packet_in pkt, out headers_t hdrs, inout metadata_t meta, in pna_main_parser_input_metadata_t istd) {
    bool from_ipsec;
    ipsec_status status;
    state start {
        from_ipsec = ipsec.from_ipsec(status);
        transition select(from_ipsec) {
            true: parse_ipv4;
            default: parse_ethernet;
        }
    }
    state parse_ethernet {
        pkt.extract<ethernet_t>(hdrs.ethernet);
        transition select(hdrs.ethernet.ether_type) {
            16w0x800: parse_ipv4;
            default: accept;
        }
    }
    state parse_ipv4 {
        pkt.extract<ipv4_t>(hdrs.ipv4);
        transition select(hdrs.ipv4.protocol) {
            8w0x32: parse_esp;
            default: accept;
        }
    }
    state parse_esp {
        pkt.extract<esp_t>(hdrs.esp);
        transition accept;
    }
}

control PreControlImpl(in headers_t hdr, inout metadata_t meta, in pna_pre_input_metadata_t istd, inout pna_pre_output_metadata_t ostd) {
    apply {
    }
}

control MainControlImpl(inout headers_t hdrs, inout metadata_t meta, in pna_main_input_metadata_t istd, inout pna_main_output_metadata_t ostd) {
    action ipsec_enable(bit<32> sa_index) {
        ipsec.enable();
        ipsec.set_sa_index<bit<32>>(sa_index);
        hdrs.ethernet.setInvalid();
    }
    action ipsec_bypass() {
        meta.bypass = true;
        ipsec.disable();
    }
    action drop() {
        drop_packet();
    }
    table inbound_table {
        key = {
            hdrs.ipv4.src_addr: exact @name("hdrs.ipv4.src_addr");
            hdrs.ipv4.dst_addr: exact @name("hdrs.ipv4.dst_addr");
            hdrs.esp.spi      : exact @name("hdrs.esp.spi");
        }
        actions = {
            ipsec_enable();
            ipsec_bypass();
            drop();
        }
        const default_action = drop();
    }
    table outbound_table {
        key = {
            hdrs.ipv4.src_addr: exact @name("hdrs.ipv4.src_addr");
            hdrs.ipv4.dst_addr: exact @name("hdrs.ipv4.dst_addr");
        }
        actions = {
            ipsec_enable();
            ipsec_bypass();
            drop();
        }
        default_action = ipsec_bypass();
    }
    action next_hop_id_set(bit<32> next_hop_id) {
        meta.next_hop_id = next_hop_id;
    }
    table routing_table {
        key = {
            hdrs.ipv4.dst_addr: lpm @name("hdrs.ipv4.dst_addr");
        }
        actions = {
            next_hop_id_set();
            drop();
        }
        default_action = next_hop_id_set(32w0);
    }
    action next_hop_set(bit<48> dst_addr, bit<48> src_addr, bit<16> ether_type, bit<32> port_id) {
        hdrs.ethernet.setValid();
        hdrs.ethernet.dst_addr = dst_addr;
        hdrs.ethernet.src_addr = src_addr;
        hdrs.ethernet.ether_type = ether_type;
        send_to_port((PortId_t)port_id);
    }
    table next_hop_table {
        key = {
            meta.next_hop_id: exact @name("meta.next_hop_id");
        }
        actions = {
            next_hop_set();
            drop();
        }
        default_action = drop();
    }
    apply {
        if (istd.direction == PNA_Direction_t.NET_TO_HOST) {
            ipsec_status status;
            if (ipsec.from_ipsec(status)) {
                if (status == ipsec_status.IPSEC_SUCCESS) {
                    routing_table.apply();
                    next_hop_table.apply();
                } else {
                    drop_packet();
                }
            } else if (hdrs.ipv4.isValid()) {
                if (hdrs.esp.isValid()) {
                    inbound_table.apply();
                    if (meta.bypass) {
                        routing_table.apply();
                        next_hop_table.apply();
                    }
                } else {
                    routing_table.apply();
                    next_hop_table.apply();
                }
            } else {
                drop_packet();
            }
        } else {
            ipsec_status status;
            if (ipsec.from_ipsec(status)) {
                if (status == ipsec_status.IPSEC_SUCCESS) {
                    routing_table.apply();
                    next_hop_table.apply();
                } else {
                    drop_packet();
                }
            } else if (hdrs.ipv4.isValid()) {
                outbound_table.apply();
            } else {
                drop_packet();
            }
        }
    }
}

control MainDeparserImpl(packet_out pkt, in headers_t hdrs, in metadata_t meta, in pna_main_output_metadata_t ostd) {
    apply {
        pkt.emit<ethernet_t>(hdrs.ethernet);
        pkt.emit<ipv4_t>(hdrs.ipv4);
        pkt.emit<esp_t>(hdrs.esp);
    }
}

PNA_NIC<headers_t, metadata_t, headers_t, metadata_t>(MainParserImpl(), PreControlImpl(), MainControlImpl(), MainDeparserImpl()) main;
