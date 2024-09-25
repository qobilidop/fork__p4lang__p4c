#ifndef P4MLIR_DIALECT_P4HIR_P4HIR_TYPES_TD
#define P4MLIR_DIALECT_P4HIR_P4HIR_TYPES_TD

include "mlir/IR/AttrTypeBase.td"

include "p4mlir/Dialect/P4HIR/P4HIR_Dialect.td"

//===----------------------------------------------------------------------===//
// P4HIR type definitions.
//===----------------------------------------------------------------------===//

class P4HIR_Type<string name, string typeMnemonic, list<Trait> traits = []>
    : TypeDef<P4HIR_Dialect, name, traits> {
  let mnemonic = typeMnemonic;
}

def P4HIR_Bit : P4HIR_Type<"Bit", "bit"> {
  let summary = "fixed width unsigned integer type";
  let description = [{
    The `p4hir.bit` type represents a P4 `bit` type.

    For example, `p4hir.bit<32>` represents `bit<32>` in P4.
  }];
  let parameters = (ins "int":$width);
  let assemblyFormat = "`<` $width `>`";
}

#endif // P4MLIR_DIALECT_P4HIR_P4HIR_TYPES_TD
