def minimum(A):
  min = A[1]
  for i in range(2, len(A), 1):
    if min > A[i]:
      min = A[i]
  return min
print(minimum([2, 3, 1, 5, 7]))
def test(A):
  for i in range(0, len(A), 1):
    A[i] = 0
  return A
print(test([1, 2, 3, 4]))

