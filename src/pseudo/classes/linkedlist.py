class LinkedList:
    def __init__(self, list, head=None):
        self.head = head if head else self
        self.next = LinkedList(list[1:], self.head) if len(list) > 1 else None
        self.prev = None
        self.key = list[0]
        if self.next:
            self.next.prev = self