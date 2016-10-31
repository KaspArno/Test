# setup file is in setup_4.py
# FIRST: Compile with: python setup_4.py build_ext 
# SECOND: Install in the current directory: python setup_4.py install --install-platlib=.

import matplotlib.pyplot as plt
import mandelbrot_4
import numpy
import time

def mandelbrotSet_4(xmin, xmax, dx, ymin, ymax, dy, iterNr, output_file):
	"""Function renders and saves a figure with Mandelbrot set.

	Keyword arguments:
	xmin -- start of real axis
	xmax -- end of real axis
	dx -- spacing of the real axis
	ymin -- start of imaginary axix
	ymax -- end of imaginary axis
	dy -- spacing of the imaginary axis
	iterNr -- numer of iterations for a single value in a grid
	output_file -- output name for the figure with Mandelbrot set
	"""
	# initialize a grid	
	t0 = time.time() # time the initialization
	
	lx = int( (xmax-xmin)/dx + 1 );
	ly = int( (ymax - ymin)/dy + 1 );
	xcoor = mandelbrot_4.create_list(xmin, xmax, dx, lx)
	ycoor = mandelbrot_4.create_list(ymin, ymax, dy, ly)

	t1 = time.time()
	print('GRID INITIALIZATION: Runtime with SWIG: ' + repr(t1-t0) + ' seconds')

	# calculate values 	
	t2 = time.time() # time the calculation time
	
	steps = mandelbrot_4.mandelbrot(iterNr, xcoor,ycoor,lx*ly)
	steps = steps.reshape((ly,lx))

	t3 = time.time()	
	print('CALCULATING VALUES: Runtime with SWIG: ' + repr(t3-t2) + ' seconds')

	# plot
	plt.axes(axisbg='black') # add black background
	plt.hold(True) # equivalent of hold on in plt
	plt.imshow(steps,cmap = 'rainbow',vmin=0, vmax=iterNr, extent=[min(xcoor), max(xcoor), min(ycoor), max(ycoor)])
	plt.colorbar() # add colorbar
	plt.savefig(output_file + '.png') # save figure in png
	plt.title('Mandelbrot set')
	plt.show() # show figure


if __name__ == "__main__":
	mandelbrotSet_4(-2.05, 0.45, 0.01, -1.2, 1.2, 0.01, 1000, 'mandelbrotSet')
