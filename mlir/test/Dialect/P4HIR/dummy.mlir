// RUN: p4mlir-opt %s | p4mlir-opt | FileCheck %s

module {
    // CHECK-LABEL: func @bar()
    func.func @bar() {
        %0 = arith.constant 1 : i32
        // CHECK: %{{.*}} = p4hir.foo %{{.*}} : i32
        %res = p4hir.foo %0 : i32
        return
    }

    // CHECK-LABEL: func @p4hir_bit_type(%arg0: !p4hir.bit<32>)
    func.func @p4hir_bit_type(%arg0: !p4hir.bit<32>) {
        return
    }
}
