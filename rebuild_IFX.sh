#!/bin/bash

# to be able to run inside a docker container
git config --global --add safe.directory /extern

export FC=ifx

builddir=builddir-${FC}-`date +"%s" `
rm -rfv ${builddir}
 
sleep 1

meson setup            ${builddir}  
sleep 1
meson compile -v    -C ${builddir} 
#ninja -v            -C ${builddir} 

# execute the program
./${builddir}/nested_modules

