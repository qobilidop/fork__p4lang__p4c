#ifndef P4MLIR_DIALECT_P4HIR_P4HIR_ENUMS_TD
#define P4MLIR_DIALECT_P4HIR_P4HIR_ENUMS_TD

include "mlir/IR/EnumAttr.td"

let cppNamespace = "::P4::P4MLIR::P4HIR" in {

//===----------------------------------------------------------------------===//
// P4HIR enum definitions.
//===----------------------------------------------------------------------===//

def P4HIR_CmpPredicateEqu : I32EnumAttrCase<"equ", 0>;
def P4HIR_CmpPredicateNeq : I32EnumAttrCase<"neq", 1>;
def P4HIR_CmpPredicateLss : I32EnumAttrCase<"lss", 2>;
def P4HIR_CmpPredicateLeq : I32EnumAttrCase<"leq", 3>;
def P4HIR_CmpPredicateGrt : I32EnumAttrCase<"grt", 4>;
def P4HIR_CmpPredicateGeq : I32EnumAttrCase<"geq", 5>;

def P4HIR_CmpPredicate : I32EnumAttr<
    "CmpPredicate",
    "comparison operation predicate",
    [
        P4HIR_CmpPredicateEqu,
        P4HIR_CmpPredicateNeq,
        P4HIR_CmpPredicateLss,
        P4HIR_CmpPredicateLeq,
        P4HIR_CmpPredicateGrt,
        P4HIR_CmpPredicateGeq,
    ]
>;

}

#endif // P4MLIR_DIALECT_P4HIR_P4HIR_ENUMS_TD
