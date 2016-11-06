import sys
import re
from ast import literal_eval

def cleaning(key, text): #a function to clean up longer text like comments and strings
    regex = r"" + syntax_dict[key]
    regex = regex[1:-2]
    theme = theme_dict[key]
    text2 = open(sys.argv[3]).read() #Creates a clean string withoyt any coloring
    clean = re.findall(regex, text2)
    dirty = re.findall(regex, text)
    for c,d in zip(clean, dirty):
        text = text.replace(d, "\033[{}m".format(theme) + c + "\033[0m") #replaces all longer text with a text consisting of only 1 color, this is to ensure the color stays on for the entire text, and not canseld by another color
    return text

syntax_file = open(sys.argv[1]) #Getting regex syntax file
theme_file = open(sys.argv[2]) #Getting theme file
source_file = open(sys.argv[3]) #Getting source file


syntax_dict = {}
for line in syntax_file: #add all regex syntax in a dictionary, key = what to find, value = regex
    values = line.split()
    syntax_dict[values[1]] = values[0]

theme_dict = {}
for line in theme_file: #add all theme codes in a dictionary, key = what to color, value = code
    values = line.split()
    theme_dict[values[0][0:-1]] = values[1]

text_in_file = source_file.read()
for (key, value) in syntax_dict.items(): #iterates trou every syntax and color according to theme
    regex = value[1:-2]
    regex = r"" + regex
    theme = theme_dict[key]
    coloring_words = re.findall(regex , text_in_file, flags=re.MULTILINE)

    text_in_file = re.sub(regex,"\033[{}m".format(theme) +  '\g<0>' +  "\033[0m", text_in_file, ) #inserts color codes before text and removes color codes after text


try:
    text_in_file = cleaning("string", text_in_file) #cleaning strings
    text_in_file = cleaning("comment", text_in_file) #clanings comensts (comments must be cleand after strins, as comments overwrites strnigs)
except:
    test = 0


print(text_in_file)

