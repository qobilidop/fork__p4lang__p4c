// RUN: p4mlir-opt %s | p4mlir-opt | FileCheck %s

module {

    // CHECK-LABEL: func @max(%{{.*}}: !p4hir.bit<32>, %{{.*}}: !p4hir.bit<32>) -> !p4hir.bit<32>
    func.func @max(%arg0: !p4hir.bit<32>, %arg1: !p4hir.bit<32>) -> !p4hir.bit<32> {
        // CHECK: %{{.*}} = p4hir.cmp grt, %{{.*}}, %{{.*}} : !p4hir.bit<32>
        %0 = p4hir.cmp grt, %arg0, %arg1 : !p4hir.bit<32>
        %1 = scf.if %0 -> !p4hir.bit<32> {
            scf.yield %arg0 : !p4hir.bit<32>
        } else {
            scf.yield %arg1 : !p4hir.bit<32>
        }
        func.return %1 : !p4hir.bit<32>
    }

}
