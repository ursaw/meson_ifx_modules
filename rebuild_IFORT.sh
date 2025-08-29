#!/bin/bash

# to be able to run inside a docker container
## git config --global --add safe.directory /extern

# somehow the PATH is not set correctly inside the container
export  PATH="/opt/meson:$PATH"

export FC=ifort

builddir=builddir-${FC}
rm -rf ${builddir}

meson  --buildtype=plain     ${builddir}
ninja -v     -C  ${builddir} 

# execute the program
./${builddir}/nested_modules
