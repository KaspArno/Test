from distutils.core import setup, Extension
import numpy
import os

name = "mandelbrot_4"      # name of the module
version = "1.0"  # the module's version number

setup(name=name, version=version, ext_modules=[Extension(name='_mandelbrot_4', sources=["mandelbrot_4.i", "mandelbrot_4.c"],include_dirs=[numpy.get_include(),'.'] ) ] )
     
