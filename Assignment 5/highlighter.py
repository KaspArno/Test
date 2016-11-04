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
    
    return ('\x1b[32m' + text + end_code)

def num_groups(regex):
    return len(re.compile(regex).groups())



syntax_file = open(sys.argv[1]) #Getting regex syntax file
theme_file = open(sys.argv[2]) #Getting theme file
source_file = open(sys.argv[3]) #Getting source file

color_end = r"(?:\s*\()(?!.*\\033\[0m)"
#color_start = "\033[{}m".format(code)
color_start = r"(\\x1b\[\d+m)(.*)"

syntax_dict = {}
for line in syntax_file:
    values = line.split()
    syntax_dict[values[1]] = values[0]

theme_dict = {}
for line in theme_file:
    values = line.split()
    theme_dict[values[0][0:-1]] = values[1]

text_in_file = source_file.read()
for (key, value) in syntax_dict.items():
    regex = value[0:-1]
    regex = r"" + regex
    theme = theme_dict[key]
    coloring_words = re.findall(regex , text_in_file, flags=re.MULTILINE)

    text_in_file = re.sub(regex,"\033[{}m".format(theme) +  '\g<0>' +  "\033[0m", text_in_file, )

print(text_in_file)

def test():
    return False # Function to test program