#All import must be fully qualified starting at the codeRootPackage
from codeRootFolder.cythonAnimal.dog cimport Dog

cdef class Cat:
    cpdef name(self)
    cpdef friendWith(self)