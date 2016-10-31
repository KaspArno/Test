from matplotlib import pyplot as pl

matrix = [(1,2,3), (2,3,1), (3,2,1)]

pl.imshow(matrix)
pl.show()

pl.contourf(matrix)
pl.show()