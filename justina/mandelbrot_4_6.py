import time
import numpy
import matplotlib.pyplot as plt

numpy.seterr(all='ignore') # Set how floating-point errors are handled: ignore all

class Error_outside(Exception):
	def __init__(self, value):
		self.value = value
	def __str__(self):
		return repr(self.value)
		
# ------------ function mandelbrotSet------------------
def compute_mandelbrot(xmin, xmax, ymin, ymax, Nx, Ny, max_escape_time=1000, plot_filename=None):
	# skriv documentation
	try:
		# initialize a grid	
		xcoor = numpy.linspace(xmin, xmax, num=Nx) 
		ycoor = numpy.linspace(ymin, ymax, num=Ny)
           
		x, y = numpy.meshgrid(xcoor,ycoor) # real and imaginary axis of c
		c = x+y*1j
		z = numpy.zeros_like(c)
		steps = numpy.zeros((numpy.size(ycoor),numpy.size(xcoor))) # number of steps to get over 2
		mask = ( c<2 )
		if not mask.any(): # if everything in the mask is true
			raise Error_outside([xmin,xmax,ymin,ymax])

		for i in range(max_escape_time):
			z[mask] = z[mask]**2 + c[mask]
			steps[z>2] = i # save how many steps it took to get over 2 based on the current step

		steps[ z < 2 ] = numpy.nan # mask all the values which did not get over 2

		# plot
		if plot_filename is not None:
			plt.axes(axisbg='black') # add black background
			plt.hold(True) # equivalent of hold on in plt
			plt.imshow(steps,cmap = 'rainbow',vmin=0, vmax=max_escape_time, extent=[min(xcoor), max(xcoor), min(ycoor), max(ycoor)])
			plt.colorbar() # add colorbar
			plt.savefig(plot_filename + '.png') # save figure in png
			plt.title('Mandelbrot set')
			plt.show() # show figure

		return steps
	except Error_outside as e:
		print('Area: [' + str(e.value[0]) + ',' + str(e.value[1]) + '] x [' + str(e.value[2]) +
		 ',' + str(e.value[3]) + '] is outside of Mandelbrot set')
		raise

 
