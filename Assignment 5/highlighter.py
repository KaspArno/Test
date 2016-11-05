import sys
import re
from ast import literal_eval

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

color_start_reg = re.compile(r"\\x1b\[0;\d{1,2}m")
color_end_reg = re.compile(r"\\x1b\[0m")

color_start = color_start_reg.search(repr(text_in_file))
color_end = color_end_reg.search(repr(text_in_file))


#print(repr(text_in_file))

print(color_start.span(), color_start.group())
print(color_end.span(), color_end.group())
print(color_start.span()[1])
print(color_end.span()[0])
print(repr(text_in_file[7:13]))
print(repr(text_in_file[color_start.span()[1]-4:color_end.span()[0]-4]))

s = repr(text_in_file)
regex = re.compile(r'\\x1b\[0;\d{1,2}m')
it = re.finditer(regex, s)



test = 0
cleaning = True
while cleaning:
    print(test)
    test += 1
    found_one = False
    for match_start, match_end in zip(color_start_reg.finditer(s), color_end_reg.finditer(s)):
        #print("test = 0")
        for inside in color_start_reg.finditer(s[match_start.span()[1]:match_end.span()[0]]):
            test = 0
            s = s[:match_end.span()[1]] + match_start.group() + s[match_end.span()[1]:]
            print("Found one", match_start.span(), inside.span())
            print(s[match_start.span()[1]:match_end.span()[1]])
            print(match_start.group())
            print(s[match_start.span()[1]:match_end.span()[1]+10])
            found_one = True
            break
        if found_one:
            break
    if not found_one:
        cleaning = False

#print(literal_eval(s))

# color_start_loc = []
# for match in color_start_reg.finditer(s):
#     print (match.group())
#     color_start_loc.append(match.span())


#print(repr(text_in_file[color_start.span()[1]:color_end.span()[0]]))

# while color_start != None:
#     if color_start_reg.search(repr(text_in_file[color_start.span()[1]-4:color_end.span()[0]-4])) == None:
#         color_start = color_start_reg.search(repr(text_in_file[color_end.span()[1]:]))
#         color_end = color_end_reg.search(repr(text_in_file[color_end.span()[1]:]))
#         print(repr(text_in_file[color_start.span()[1]-4:color_end.span()[0]-4]))
#         print(color_start.span())
#         color_start = None


#print(repr(text_in_file))

def test():
    return False # Function functo test program func(arg) dette burde være kommentert