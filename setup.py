from distutils.core import setup, Extension

name = "hw"      # name of the module
version = "1.0"  # the module's version number

setup(name=name, version=version,
      ext_modules=[Extension(name='_hw', 
      # SWIG requires an underscore as a prefix for the module name
             sources=["hw.i", "src/hw.c"],
             include_dirs=['src'])
    ])