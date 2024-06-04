#!/bin/bash

echo "initpackage uzxipcf uzxipcf_lmodel.dat `pwd` \nexit" | xspec
echo "lmod uzxipcf . \nexit" | xspec

rm -f *~ *.o *FunctionMap.* lpack_* *.mod Makefile
