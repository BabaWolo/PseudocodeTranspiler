class PseudoLibrary:
    class Node:
        def __init__(self, key):
            self.key = key
            self.left = None
            self.right = None
            self.p = None

        def __str__(self):
            return str(self.key)

    class BinaryTree:
        def __init__(self, elements):
            self.root = None
            if elements:
                self.root = self.build_tree(elements, 0)

        def build_tree(self, elements, index, p = None):
            # Recursively builds a tree from a list of elements
            if index < len(elements) and elements[index] is not None:
                node = PseudoLibrary.Node(elements[index])
                node.p = p
                node.left = self.build_tree(elements, 2 * index + 1, node)
                node.right = self.build_tree(elements, 2 * index + 2, node)
                return node
            return None
        
    class LinkedList:
        def __init__(self, list, head=None):
            self.head = head if head else self
            self.next = PseudoLibrary.LinkedList(list[1:], self.head) if len(list) > 1 else None
            self.prev = None
            self.key = list[0]
            if self.next:
                self.next.prev = self
        
        def __str__(self):
            return str(self.key)
        

    def key(object):
        objectType = type(object)
        if objectType == PseudoLibrary.Node:
            return object.key
        elif objectType == PseudoLibrary.LinkedList:
            return object.key
        else:
            return object.key

    def head(object):
        objectType = type(object)
        if objectType == PseudoLibrary.Node:
            return object.head
        elif objectType == list:
            return object[0]
        else:
            return object.head
    
