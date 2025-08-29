# meson with IFX using modules only occassionally working

We want and need to switch our fortran project with appr. 6000 .f90 and .for file from intel ifort to ifx. Our meson setup works for years with ifort. 
We cant compile our project, because modules are not resolved for depencies.

Having the most simple example can only compiled with meson/ninja and IFX occassionally, while the ifort setup dont show any issues.
The repo https://github.com/ursaw/meson_ifx_modules is containig a full example incl. a Dockerfile containing IFX and meson.

Why is the build system not compiling reproducible results, or is handling the  reference

## build system

|Intel fortran             |   Meson  |    ninja  |   compiled files       |
|  ------                  |   -----  |    -----  |    -----               |
|IFORT 2021.10.0 20230609  |   0.53.2 |    1.10.0 |    [6/6]               |
|IFX 2025.2.0 20250605     |   1.9    |    1.13.1 |    [3/6]               |

## code

### Types.f90

```fortran
module Types
  integer , parameter :: mypara = 42
end module Types
```

### ex_sub.f90  (example subroutine)

```fortran
module ex_sub
    use Types
    implicit none
 contains

subroutine exsub_print
    implicit none   

    print *, 'Hello from ex_sub!', mypara

end subroutine exsub_print

end module ex_sub
```

## Compile from command line inside docker image

```sh
docker build  -t meson-ifx  --file Dockerfile-ifx .

docker run --rm -i -t --volume $(dirname $(pwd)):/extern -w/extern meson-ifx:latest rebuild_IFX.sh
```

and ifort

```shell
docker build  -t meson-ifort  --file Dockerfile-ifort .

docker run --rm -i -t --volume $(dirname $(pwd))/meson-nested-modules:/extern -w/extern meson-ifort:latest rebuild_IFORT.sh
```

### output IFX

```txt
The Meson build system
Version: 1.9.0
Source dir: /extern
Build dir: /extern/builddir-ifx-1756388656
Build type: native build
Project name: NestedModule
Project version: 0.0.1
Fortran compiler for the host machine: ifx (intel-llvm 2025.2.0 "ifx (IFX) 2025.2.0 20250605")
Fortran linker for the host machine: ifx ld.bfd 2.38
Host machine cpu family: x86_64
Host machine cpu: x86_64
Build targets in project: 1

Found ninja-1.13.1 at /opt/meson/ninja
INFO: autodetecting backend as ninja
INFO: calculating backend command to run: /opt/meson/ninja -C /extern/builddir-ifx-1756388656 -v
ninja: Entering directory `/extern/builddir-ifx-1756388656'
[1/6] /opt/meson/meson --internal depscan  nested_modules.p/depscan.json nested_modules.p/nested_modules.dat
[2/6] /opt/meson/meson --internal depaccumulate nested_modules.p/depscan.dd nested_modules.p/depscan.json
[3/6] ifx -Inested_modules.p -I. -I.. -D_FILE_OFFSET_BITS=64 -warn general -warn truncated_source -O0 -g -traceback -module nested_modules.p -o nested_modules.p/main_prg_Source_ex_sub.f90.o -c ../main_prg/Source/ex_sub.f90
FAILED: [code=1] nested_modules.p/main_prg_Source_ex_sub.f90.o nested_modules.p/ex_sub.mod 
ifx -Inested_modules.p -I. -I.. -D_FILE_OFFSET_BITS=64 -warn general -warn truncated_source -O0 -g -traceback -module nested_modules.p -o nested_modules.p/main_prg_Source_ex_sub.f90.o -c ../main_prg/Source/ex_sub.f90
../main_prg/Source/ex_sub.f90(2): error #7002: Error in opening the compiled module file.  Check INCLUDE paths.   [TYPES]
    use Types
--------^
../main_prg/Source/ex_sub.f90(9): error #6404: This name does not have a type, and must have an explicit type.   [MYPARA]
    print *, 'Hello from ex_sub!', mypara
-----------------------------------^
compilation aborted for ../main_prg/Source/ex_sub.f90 (code 1)
[4/6] ifx -Inested_modules.p -I. -I.. -D_FILE_OFFSET_BITS=64 -warn general -warn truncated_source -O0 -g -traceback -module nested_modules.p -o nested_modules.p/main_prg_Source_Types.f90.o -c ../main_prg/Source/Types.f90
ninja: build stopped: subcommand failed.
```
