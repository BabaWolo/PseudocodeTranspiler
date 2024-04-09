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
  raise ValueError('""""""""""""""""""""""')

A = []
B = []
C = []
D = {}
list = LinkedList([1, 2, 3, 4, 5])
A = [1, 2, 5, 3, 7, 8, 3, 1000]
A.sort()
print(listInsert(list, LinkedList([6])).head.key)
def Test():
  return (1, 2, 3)

(e, f, g) = Test()
print(f)

