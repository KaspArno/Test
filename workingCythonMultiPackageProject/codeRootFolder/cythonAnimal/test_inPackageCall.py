#All import must be fully qualified starting at the codeRootPackage
from codeRootFolder.cythonAnimal.cat import Cat
from codeRootFolder.cythonAnimal.dog import Dog

cat = Cat()
dog = Dog()

print cat.name() + ' is friend with ' + cat.friendWith()
print dog.name() + ' is friend with ' + dog.friendWith()