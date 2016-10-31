cdef class Dog:
    cpdef name(self):
        return 'dog'
    cpdef friendWith(self):
        cdef Cat cat = Cat()
        return cat.name()
    
