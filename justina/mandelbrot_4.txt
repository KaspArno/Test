#include "mandelbrot_4.h"
#include <math.h>

void create_list(double min, double max, double spacing, int size, double *arr){
	for (int i = 0; i<=size; i++){
		arr[i] = min + i * spacing;
	}
}

void mandelbrot(int iterNr, int lx, double *xcoor,int ly,double *ycoor, int m, double *steps){
	int nIndex = 0;
	
	for(int i = 0; i<ly; i++){
		for(int j = 0; j<lx; j++){
			double c_real = xcoor[j];
			double c_imag = ycoor[i];
			double z_imag = 0.0;
			double z_real = 0.0;
			double idx= 0.0;
			double z_real_temp = 0.0;
	
			while (idx < iterNr) {
				z_real_temp = z_real;
				z_real = z_real*z_real - z_imag*z_imag + c_real;
				z_imag = 2*z_real_temp*z_imag + c_imag;
				idx ++;
				if (z_real*z_real + z_imag*z_imag >= 4.0 ){
					steps[nIndex] = idx;
					break;
				}
			}
			if (z_real*z_real + z_imag*z_imag < 4.0 ){
				steps[nIndex] = NAN;
			}
			nIndex ++;			
		}
	}
}
