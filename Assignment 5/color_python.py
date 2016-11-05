import re
from matplotlib import pyplot as pyplot

def test(something):
	#Dette skal være en veldig bra funksjone
	for i in range(10):
		print(i) # teller fra en til 10, eller fra 0 til 10?

string = "Farger er Pent!!"
while True:
	if len(string) < 2:
		break
	else:
		string = string[0:len(string)-1]
	print(string)


print("Fin")