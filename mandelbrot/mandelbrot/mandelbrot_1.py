import math
import numpy as np
from matplotlib import pyplot as pl
import time



def mandelbrot1 (xstart, xslutt, ystart,yslutt, steg, n):
	x = np.linspace(xstart,xslutt,num=steg, endpoint=True)
	y = np.linspace(ystart,yslutt,num=steg, endpoint=True)
	#[f1,f2] = np.meshgrid[x,y]
	f1,f2,nr = 0,0,0

	matrix = np.zeros(shape=(len(x),len(y)))

	t1 = time.time()
	for i in range(len(y)):
		#print("i: ", i)
		for j in range(len(x)):
			#print("j: ", j)
			nr = 0
			f1 = 0
			f2 = 0
			dis = 0
			while nr < n:
				#print("nr: ", nr)
				[f1,f2,dis] = [(f1*f1) - (f2*f2) + x[j], 2*f1*f2 + y[i], math.sqrt((f1*f1)+(f2*f2))]

				if dis>2:
					matrix[i,j] = nr
					break
				nr+=1

			matrix[i,j] = nr

	t2 = time.time()

	print("Time: ", t2-t1)


	#print(matrix)
	#pl.contourf(x,y,matrix)
	#pl.colorbar()
	pl.imshow(matrix)
	pl.show()











# r = (-3, 3, -3, 3) #(x start, x slutt, y start, y slutt)

# w, h = r[1]-r[0], r[3]-r[2]

# x = [i for i in range(r[0], r[1])]
# y = [i for i in range(r[2], r[3])]

# matrix = [[0 for i in range(len(x))] for j in range(len(y))]

# #print(matrix)

# #f(z) = (z(n-1))^2 + c,  z(a,b), c(c,d)
# #f(z) = a^2-b^2+c, 2ab+d

# a = 0
# b = 0
# i = -1
# j = 0

# for c in x:
# 	i += 1
# 	j = -1
# 	#print("c: ", c)
# 	#print("i: ", i)
# 	for d in y:
# 		j+=1
# 		#print("d: ", d)
# 		#print("j: ", j)
# 		a = 0
# 		b = 0
# 		f = [a, b]
# 		flist = []
# 		inf = True
# 		count = 0
# 		while inf:
# 			for fn in flist:
# 				if f == fn or math.sqrt((a*a)+(b*b)) > 2 or count >100:
# 					if f == fn:
# 						matrix[j][i] = count
# 					if math.sqrt((a*a)+(b*b)) > 2:
# 						#print(i,j)
# 						matrix[j][i] = 0
# 					inf = False
# 					break

# 			flist = [copy.deepcopy(f)] + flist
# 			f[0] = (a*a)-(b*b)+c
# 			f[1] = 2*a*b+d
# 			count += 1
# 			#print("f(z): ", f)
# 			a = f[0]
# 			b = f[1]


# #pl.imshow(matrix)
# pl.contourf(x,y, matrix)
# pl.colorbar()
# pl.show()
# print("Yeah")