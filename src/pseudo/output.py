from classes.binarytree import BinaryTree
from classes.linkedlist import LinkedList
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
  x.next = L.head
  if L.head != 0:
    L.head.prev = x
  L.head = x
  x.prev = 0
  return x

A = []
B = []
C = []
D = {}
list = LinkedList([1, 2, 3, 4, 5])
print(listInsert(list, LinkedList([6])).head.key)

def treeSearch(x, k):
  if x == None or k == x.key:
    return x
  if k < x.key:
    return treeSearch(x.left, k)
  else:
    return treeSearch(x.right, k)
tree = BinaryTree([5, 2, 8])
print(treeSearch(tree.root, 2))

def Test():
  return (1, 2, 3)

(e, f, g) = Test()
print(f)
e, f = f, e
print(e)
print(f)
str = "Hello World"
print(str)

