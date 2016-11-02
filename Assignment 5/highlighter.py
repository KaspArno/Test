import sys
import re

def color(text, code="94"):
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
    
    start_code = "\033[{}m".format(code)
    end_code = "\033[0m"
    
    return (start_code + text + end_code)

def num_groups(regex):
    return len(re.compile(regex).groups())


syntax_file = open(sys.argv[1])
theme_file = open(sys.argv[2])
source_file = open(sys.argv[3])

syntax_dict = {}
for line in syntax_file:
    values = line.split()
    syntax_dict[values[1]] = values[0]

theme_dict = {}
for line in theme_file:
    values = line.split()
    theme_dict[values[0][0:-1]] = values[1]

for line in source_file:
    for (key, value) in syntax_dict.items():
        regex = value[0:-1]
        regex = r"" + regex
        #print(regex)
        theme = theme_dict[key]
        coloring_words = re.findall(regex , line)
        #print(coloring_words)
        #print (regex)
        #print (line)
        for word in coloring_words:
            regex_out = r"" + color(word, theme)
            regex_out = regex_out + "\1"
            line = line.replace(word, color(word, theme))
    print(line)