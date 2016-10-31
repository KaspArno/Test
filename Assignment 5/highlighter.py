import sys
import re

def color(text, code=5):
    """
    Prints a piece of text in a fancy way. What fancy means depends on the 
    keyword argument code. Some possibilities are:
     0;1: bold text
     0;3: italics
     0;4: underline
     0;5: blinking text (only sane default)
     0;7: "inverted" text
    0;92: green
    0;93: yellow
    0;94: blue
    0;95: pink
    Though this is not done here, it is possible to combine
    these to get lovely things like flashing yellow text.
    """
    
    start_code = "\033[{}m".format("0;94")
    end_code = "\033[0m"
    
    return (start_code + text + end_code)




syntaxFile = open(sys.argv[1])
themeFile = open(sys.argv[2])
sourceFile = open(sys.argv[3])

syntaxDict = {}
for line in syntaxFile:
    values = line.split()
    syntaxDict[values[1]] = values[0]

themeDict = {}
for line in themeFile:
    values = line.split()
    themeDict[values[0][0:-1]] = values[1]

for line in sourceFile:
    for key, value in syntaxDict.items():
        regex = value[0:-1]
        theme = themeDict[key]
        coloringWords = re.findall(regex , line)
        for word in coloringWords:
            substituted_text = re.sub(regex, color(word), line)
        #print(regex)
        #print(line)
        print(substituted_text)
    #print(line)