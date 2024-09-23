#!/usr/bin/env bash
#
# Reference:
# - https://mlir.llvm.org/getting_started/
# - https://github.com/llvm/llvm-project/tree/main/mlir/examples/standalone

set -ex

# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )  # p4c/tools
P4C_REPO_DIR=$( cd ${SCRIPT_DIR}/.. &> /dev/null && pwd )

LLVM_REPO_DIR=${P4C_REPO_DIR}/third_party/llvm-project
LLVM_BUILD_DIR=${LLVM_REPO_DIR}/build
LLVM_INSTALL_DIR=${P4C_REPO_DIR}/mlir/install

mkdir -p $LLVM_BUILD_DIR
cd $LLVM_BUILD_DIR

cmake -G Ninja ../llvm \
   -DCMAKE_INSTALL_PREFIX=$LLVM_INSTALL_DIR \
   -DLLVM_ENABLE_PROJECTS=mlir \
   -DLLVM_BUILD_EXAMPLES=OFF \
   -DLLVM_TARGETS_TO_BUILD="Native" \
   -DCMAKE_BUILD_TYPE=Release \
   -DLLVM_ENABLE_ASSERTIONS=ON \
   -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_ENABLE_LLD=ON \
   -DLLVM_CCACHE_BUILD=ON \
   -DLLVM_INSTALL_UTILS=ON

# cmake --build . --target check-mlir
ninja
ninja check-mlir
ninja install
