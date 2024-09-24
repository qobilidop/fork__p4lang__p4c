# P4MLIR

P4MLIR is an experimental [P4C](https://github.com/p4lang/p4c) subproject aiming to bridge the P4C ecosystem and the [MLIR](https://mlir.llvm.org/) ecosystem.

## Development environment setup

1. Install LLVM/MLIR dependencies according to the [instructions](https://mlir.llvm.org/getting_started/).

2. Check out P4C repo:

```
$ git clone --recursive git@github.com:p4lang/p4c.git
```

3. Build MLIR:

```
$ cd p4c
$ ./tools/build-mlir.sh
```

4. Build P4MLIR:

```
$ cd p4c
$ ./tools/build-p4mlir.sh
```
