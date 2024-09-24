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

def P4HIR_CustomType : P4HIR_Type<"Custom", "custom"> {
    let summary = "P4HIR custom type";
    let description = "Custom type in p4hir dialect";
    let parameters = (ins StringRefParameter<"the custom value">:$value);
    let assemblyFormat = "`<` $value `>`";
}

#endif // P4MLIR_DIALECT_P4HIR_P4HIR_TYPES_TD
