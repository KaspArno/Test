from unittest import TestCase

import mandelbrot

class TestJoke(TestCase):
    def test_is_string(self):
        s = mandelbrot.joke()
        self.assertTrue(isinstance(s, basestring))