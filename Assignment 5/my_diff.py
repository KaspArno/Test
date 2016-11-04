import sys
import re

original_file = open(sys.argv[1])
modified_file = open(sys.argv[2])

original_text = original_file.read()
modified_text = modified_file.read()

regex = r".+?"
i = len(original_text)
text = original_text[:i]


print(re.search(text + regex, modified_text))

while re.search(text + regex, modified_text) == None:
    i -= 1
    text = original_text[:i]
    
    #print(i)
    #print(text)
    #print(re.search(text + regex, modified_text))

text = original_text[:i+1]
print(text)

text = re.sub(r"(^)", r"0 \1", text, flags=re.M)

print(text)

print(i)

remaining = original_text[i+1:]

print(remaining)

test = re.search(r".*\n", remaining)
print(test)





# for orig, modi in zip(original_file, modified_file):
#     if orig == modi:
#         print("true")
#         print("0 ", orig)
#     else:
#         print("false")
#         temp = orig
#         temp = temp.replace('\n', '')
#         print(temp)
#         if re.match(temp, modi):
#             print("+ ", orig)
#         else:
#             print("- ", orig)