#ifndef P4MLIR_DIALECT_P4HIR_P4HIR_OPS_TD
#define P4MLIR_DIALECT_P4HIR_P4HIR_OPS_TD

include "mlir/IR/OpBase.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

include "p4mlir/Dialect/P4HIR/P4HIR_Dialect.td"
include "p4mlir/Dialect/P4HIR/P4HIR_Enums.td"
include "p4mlir/Dialect/P4HIR/P4HIR_Types.td"

//===----------------------------------------------------------------------===//
// Base P4HIR operation definition.
//===----------------------------------------------------------------------===//

class P4HIR_Op<string mnemonic, list<Trait> traits = []> :
        Op<P4HIR_Dialect, mnemonic, traits>;

//===----------------------------------------------------------------------===//
// P4HIR operation definitions.
//===----------------------------------------------------------------------===//

def P4HIR_CmpOp : P4HIR_Op<"cmp", [Pure, SameTypeOperands]> {
    let summary = "comparison operation";
    let description = [{
        The `p4hir.cmp` operation is a generic comparison for any P4HIR
        comparable types.

        Example:

        ```mlir
        %r = p4hir.cmp equ, %a, %b : p4hir.bit<32>
        ```
    }];

    let arguments = (ins
        P4HIR_CmpPredicate:$predicate,
        P4HIR_ComparableType:$lhs, P4HIR_ComparableType:$rhs);
    let results = (outs I1:$result);

    let assemblyFormat = "$predicate `,` $lhs `,` $rhs attr-dict `:` type($lhs)";
} 

#endif // P4MLIR_DIALECT_P4HIR_P4HIR_OPS_TD
