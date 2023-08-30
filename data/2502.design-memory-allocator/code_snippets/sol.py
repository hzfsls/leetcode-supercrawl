class Allocator:

    def __init__(self, n: int):


    def allocate(self, size: int, mID: int) -> int:


    def free(self, mID: int) -> int:



# Your Allocator object will be instantiated and called as such:
# obj = Allocator(n)
# param_1 = obj.allocate(size,mID)
# param_2 = obj.free(mID)