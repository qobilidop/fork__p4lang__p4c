#!/usr/bin/env bash
#
# Reference:
# - https://github.com/llvm/llvm-project/tree/main/mlir/examples/standalone

set -ex

# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )  # p4c/tools
P4C_REPO_DIR=$( cd ${SCRIPT_DIR}/.. &> /dev/null && pwd )

LLVM_REPO_DIR=${P4C_REPO_DIR}/third_party/llvm-project
LLVM_BUILD_DIR=${LLVM_REPO_DIR}/build
LLVM_INSTALL_DIR=${P4C_REPO_DIR}/mlir/install

P4MLIR_DIR=${P4C_REPO_DIR}/mlir

mkdir -p $P4MLIR_DIR/build
cd $P4MLIR_DIR/build

cmake -G Ninja .. \
  -DCMAKE_INSTALL_PREFIX=$LLVM_INSTALL_DIR \
  -DMLIR_DIR=$LLVM_INSTALL_DIR/lib/cmake/mlir \
  -DLLVM_EXTERNAL_LIT=$LLVM_BUILD_DIR/bin/llvm-lit

ninja
ninja check-p4mlir
ninja install
