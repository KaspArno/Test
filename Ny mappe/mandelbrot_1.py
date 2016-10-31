import matplotlib.pyplot as plt
import numpy


def f (c, z, i):
	"""computes the escape number for a given c and z with i being the result (tail recursion)"""
	x = z[0]
	y = z[1]
	a = c[0]
	b = c[1]
	
	u = x*x - y*y +a
	v = 2*x*y + b
	
	if u*u + v*v > 4:
		return i
	elif i == 1000:	# I get a Recursion Error with 1000, so I put the highest number without that error
		return 1010
	else:
		return f(c, (u,v), i+1)
	

def Mandelbrot1(rectangle, xN, yN, filename, color):
	"""generates the Mandelbrot picture of the given rectangle"""
	x_min = rectangle[0]
	x_max = rectangle[1]
	y_min = rectangle[2]
	y_max = rectangle[3]
	
	rx = (x_max - x_min) / (xN - 1) # computing the stepsize of the intervall per pixel
	ry = (y_max - y_min) / (yN - 1)
	
	myArray = numpy.zeros(shape=(yN, xN))
	
	i = 0
	j = 0
	# Looping through the matrix and assigning the escape values
	while x_min < x_max:
		while y_min < y_max:
			number = f((x_min,y_min), (0,0), 0)
			myArray[j][i] = number
			y_min = y_min + ry
			j += 1
		x_min = x_min + rx 
		i += 1
		y_min = rectangle[2]
		j = 0

	plt.imshow(myArray, cmap = color)
	plt.savefig(filename)
	
Mandelbrot1((0, 0.5, 0, 0.5), 1000, 1000, 'Mandelbrot1.jpg', 'inferno_r')
