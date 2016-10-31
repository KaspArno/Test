# run the script with: pytest test_mandelbrot.py

import mandelbrot_6
import pytest

def test_outside():
	with pytest.raises( mandelbrot_6.Error_outside ):
		mandelbrot_6.compute_mandelbrot(3, 4, 3, 4, 100, 100, max_escape_time=0, plot_filename=None)

def test_inside():
	try:
		mandelbrot_6.compute_mandelbrot(-0.2, 0.2, -0.2, 0.2, 100, 100, max_escape_time=0, plot_filename=None)
	except mandelbrot_6.Error_outside:
		pytest.fail("Failed")

		
