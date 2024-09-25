#include "mlir/IR/MLIRContext.h"
#include "mlir/InitAllDialects.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Support/FileUtilities.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"

#include "p4mlir/Dialect/P4HIR/P4HIR_Dialect.h"

int main(int argc, char **argv) {
  mlir::registerAllPasses();

  mlir::DialectRegistry registry;
  registry.insert<P4::P4MLIR::P4HIR::P4HIRDialect,
                  mlir::func::FuncDialect,
                  mlir::scf::SCFDialect>();

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "P4HIR optimizer driver\n", registry));
}
