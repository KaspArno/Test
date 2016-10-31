#!/usr/bin/env python

import sys
import glob

myfiles = sys.argv[1]

myfiles = glob.glob(myfiles)

for f in myfiles:
	lines = 0
	words = 0
	char = 0

	try: 
		infile = open(f, 'r')

		for fileline in infile:
			lines += 1
			words += len(fileline.split())
			char += len(fileline)
		print(lines, " " , words, " ", char, " ", f)

	except IsADirectoryError as e:
		print(f, ": Not a file")

	except Exception as e:
		print(e)
