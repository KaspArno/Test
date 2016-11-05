import sys

#Gatering text from files, splitting them into lines to avoid \n
with open(sys.argv[1]) as f:
    orig = f.read().splitlines()

with open(sys.argv[2]) as f:
    modi = f.read().splitlines() 

i,j = 0,0 #initiating iteration

while i < len(orig) and j < len(modi): #loops troug both textfiles, cheking for modirations

    if orig[i] == modi[j]:
        print("0 "+ orig[i])
        i += 1
        j += 1
    else:
        found = False
        found2 = False
        for k in range(j, len(modi)): #Cheking to see if the line have been moved futher down
            if orig[i] == modi[k]:
                found = True
                break
            for l in range(i, len(orig)): #Cheking whter the lines exist, to know if they are additions
                #print("k: ", k, "l: ", l)
                if modi[k] == orig[l]:
                    found2 = True
                    break
            if found2:
                break

        if found: #If the line is found, add all other as addtitoin lines
            for k in range(j, len(modi)):
                if orig[i] == modi[k]:
                    print("0 " + orig[i])
                    i += 1
                    j += 1
                    break
                else:
                    print("+ " + modi[k])
                    j += 1
        else: #If the line is not found
            print("- " + orig[i])
            i += 1

if i < len(orig): #if the original text have more line, show them as delited
    for k in range(i,len(orig)):
        print("- " + orig[k])
if j < len(modi): #if the modified file have more lines, show them as added

    for k in range(j, len(modi)):
        print("+ " + modi[k])
