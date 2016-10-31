cdef class Cat:
    cpdef name(self):
        return 'cat'
    cpdef friendWith(self):
        cdef Dog dog = Dog()
        return dog.name()

