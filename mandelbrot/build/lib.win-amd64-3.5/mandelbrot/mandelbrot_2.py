import math
import copy
from matplotlib import pyplot as pl
import numpy as np
import time
np.seterr(invalid='ignore')


def mandelbrot2 (xstart, xslutt, ystart, yslutt, steg, iterations):
	x = np.linspace(xstart, xslutt, num=steg) #X koordinater
	y = np.linspace(ystart, yslutt, num=steg) #Y koordinater
	[c,d] = np.meshgrid(x,y)
	n = iterations

	z0 = np.zeros(shape=(len(x),len(y)))
	f1, f2 = c, d #f1 er Reele verdien, f2 er complexe
	f = [c,d]

	matrix = z0
	moreThanTwo = z0


	t1 = time.time()
	for i in range(n):
		#print(i)
		f1l,f2l = f1, f2

		[f1,f2,dis] = [((np.power(f1, 2))-(np.power(f2, 2))+c), (2*f1*f2+d), (np.sqrt(np.power(f1,2)+(np.power(f2,2))))]

		matrix[dis>2] = i
		dis[dis>2] = float('NaN')
		f1[np.isnan(dis)] = float('NaN')
		f2[np.isnan(dis)] = float('NaN')

	t2 = time.time()
	print("Time: ", t2-t1)


	matrix[~np.isnan(dis)] = n
	#print(matrix)

	#pl.contourf(x,y, matrix)
	pl.imshow(matrix)
	pl.show()


