#All import must be fully qualified starting at the codeRootPackage
from codeRootFolder.cythonAnimal.cat cimport Cat

cdef class Dog:
    cpdef name(self)
    cpdef friendWith(self)