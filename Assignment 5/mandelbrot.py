import math
from matplotlib import pyplot as pl
import numpy as np
import time
import mandelbrot
import argparse

"""An interface for mandelbrot. Let's you choose between mandelbrot 1 2 and 3 (python, numpy, cython), a colormap and a save file name"""


parser = argparse.ArgumentParser(description="Calculate Mandelbrot within given coordinates")
group = parser.add_mutually_exclusive_group()
group.add_argument("-m1", "--mandelbrot1", action="store_true")
group.add_argument("-m2", "--mandelbrot2", action="store_true")
group.add_argument("-m3", "--mandelbrot3", action="store_true")
parser.add_argument("xstart", type=float, help="Starting coordinates in x direction (Real)")
parser.add_argument("xend", type=float, help="ending coordinates in x direction (Real)")
parser.add_argument("ystart", type=float, help="Starting coordinates in y direction (Complex)")
parser.add_argument("yend", type=float, help="ending coordinates in y direction (Complex)")
parser.add_argument("step", type=int, help="number of steps between start and end")
#parser.add_argument("n", type=int, help="number of times to iterrate")
#parser.add_argument("fname", type=str, nargs='?', help="File name you want the mandelbrot to be saved as")
parser.add_argument("-c", "--color", type=str, nargs=1, help="wanted colormap: 1: flag_r, 2: viridis, 3: jet, 4: seismic, 5: terrain")
#parser.add_argument("color", type=int, nargs='?', help="wanted colormap: 1: flag_r, 2: viridis, 3: jet, 4: seismic, 5: terrain")
parser.add_argument("-s", "--save", type=str, nargs=1, help="Write down file you want mandelbrot to be saved as")
args = parser.parse_args()


if args.mandelbrot1:
    t1 = time.time()
    matrix = mandelbrot.mandelbrot1(args.xstart,args.xend,args.ystart,args.yend,args.step)
    t2 = time.time()
elif args.mandelbrot2:
    t1 = time.time()
    matrix = mandelbrot.mandelbrot2(args.xstart,args.xend,args.ystart,args.yend,args.step)
    t2 = time.time()
elif args.mandelbrot3:
    t1 = time.time()
    matrix = mandelbrot.mandelbrot3(args.xstart,args.xend,args.ystart,args.yend,args.step)
    t2 = time.time()
else:
    t1 = time.time()
    matrix = mandelbrot.mandelbrot2(args.xstart,args.xend,args.ystart,args.yend,args.step)
    t2 = time.time()

print()
print("Time: ", t2-t1)
if args.color:
	if args.color[0] == 1:
		color = 'flag_r'
	elif args.color[0] == 2:
		color = 'viridis'
	elif args.color[0] == 3:
		color = 'jet'
	elif args.color[0] == 4:
		color = 'plasma'
	elif args.color[0] == 5:
		color = 'nipy_spectral'
else:
	color = 'flag_r'

pl.imshow(matrix, cmap = color)
if args.save:
	pl.savefig(args.save[0])

pl.show()


