%module mandelbrot_4
%{
#define SWIG_FILE_WITH_INIT
#include "mandelbrot_4.h"
%}

%include "numpy.i"
%init %{
import_array();
%}

%include "typemaps.i"
%apply (int DIM1, double* ARGOUT_ARRAY1) {(int size, double *arr)};
%apply (int DIM1, double* IN_ARRAY1) {(int lx, double *xcoor), (int ly, double *ycoor)};
%apply (int DIM1, double* ARGOUT_ARRAY1) {(int m,double *steps)};
%include "mandelbrot_4.h"
