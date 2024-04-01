class Node:
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None
        self.p = None

class BinaryTree:
    def __init__(self, elements):
        self.root = None
        if elements:
            self.root = self.build_tree(elements, 0)

    def build_tree(self, elements, index, p = None):
        # Recursively builds a tree from a list of elements
        if index < len(elements) and elements[index] is not None:
            node = Node(elements[index])
            node.p = p
            node.left = self.build_tree(elements, 2 * index + 1, node)
            node.right = self.build_tree(elements, 2 * index + 2, node)
            return node
        return None