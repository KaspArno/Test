/* file: hw.i */
%module hw
%{
/* Everything in this block will be copied in the wrapper file. We include the C header file necessary to compile the interface
*/
#include "src/hw.h"
%}

/* list functions to be interfaced: */
void hw1(double r1, double r2, double *s);
void hw2(double r1, double r2);