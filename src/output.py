import random
from pseudolibrary import PseudoLibrary
import math

def minimum(A):
  min = A[0]
  for i in range(1, len(A), 1):
    if min > A[i]:
      min = A[i]
  return min

print(minimum([0, 1, 2]))
x = 1
while True:
  x = x + 1
  if x < 5:
    continue
  if not x < 10:
    break

while True:
  x = x + 1
  if x == 15:
    break

print(x)
y = -3.4
print(math.floor(-y))
def listInsert(L, x):
  x.next = PseudoLibrary.head(L)
  if PseudoLibrary.head(L) != 0:
    PseudoLibrary.head(L).prev = x
  L.head = x
  x.prev = 0
  return x

A = []
B = []
C = []
D = {}
list = PseudoLibrary.LinkedList([1, 2, 3, 4, 5])
A = [1, 2, 5, 3, 7, 8, 3, 1000]
A.sort()
print(PseudoLibrary.key(PseudoLibrary.head(listInsert(list, PseudoLibrary.LinkedList([6])))))
print(PseudoLibrary.head([1]))
def treeSearch(x, k):
  if x == None or k == PseudoLibrary.key(x):
    return x
  if k < PseudoLibrary.key(x):
    return treeSearch(PseudoLibrary.left(x), k)
  else:
    return treeSearch(PseudoLibrary.right(x), k)

tree = PseudoLibrary.BinaryTree([3, 1, 5])
print(treeSearch(PseudoLibrary.root(tree), 2))
def Test():
  return (1, 2, 3)

(e, f, g) = Test()
print(f)
e, f = f, e
print(e)
print(f)
str = "Hello World"
print(str)
random.randint(0, 5)

