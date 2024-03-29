import math

def minimum(A):
  min = A[1]
  for i in range(2, len(A), 1):
    if min > A[i]:
      min = A[i]
  return min
x = 3.2
print(minimum([2, 3, 1, 5, 7]))


