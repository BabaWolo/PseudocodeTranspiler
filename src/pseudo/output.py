from classes.linkedlist import LinkedList

def minimum(A):
  min = A[0]
  for i in range(1, len(A), 1):
    if min > A[i]:
      min = A[i]
  return min
print(minimum([0, 1, 2]))
def listInsert(L, x):
  x.next = L.head
  if L.head != 0:
    L.head.prev = x
  L.head = x
  x.prev = 0
  return x
list = LinkedList([1, 2, 3, 4, 5])
print(listInsert(list, LinkedList([6])).head.key)

