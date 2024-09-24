#ifndef P4MLIR_DIALECT_P4HIR_P4HIR_DIALECT_TD
#define P4MLIR_DIALECT_P4HIR_P4HIR_DIALECT_TD

include "mlir/IR/OpBase.td"

//===----------------------------------------------------------------------===//
// P4HIR dialect definition.
//===----------------------------------------------------------------------===//

def P4HIR_Dialect : Dialect {
    let name = "p4hir";
    let summary = "P4 high-level IR.";
    let description = [{
        This dialect is an example of an out-of-tree MLIR dialect designed to
        illustrate the basic setup required to develop MLIR-based tools without
        working inside of the LLVM source tree.
    }];
    let cppNamespace = "::P4::P4MLIR::P4HIR";

    let useDefaultTypePrinterParser = 1;
    let extraClassDeclaration = [{
        void registerTypes();
    }];
}

#endif // P4MLIR_DIALECT_P4HIR_P4HIR_DIALECT_TD
