#!/bin/bash

CWD=`pwd`

export COMPILER_ID=Intel
export CC=mpicc
export CXX=mpicxx
export FC=mpif90
export FFTW_PATH=${CWD}/dependencies/fftw-3.3.4
export DECOMP_PATH=${CWD}/dependencies/2decomp_fft
export VTK_IO_PATH=${CWD}/dependencies/Lib_VTK_IO/build
export HDF5_PATH=${CWD}/dependencies/hdf5-1.8.18
