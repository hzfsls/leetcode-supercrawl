class FileSharing:

    def __init__(self, m: int):


    def join(self, ownedChunks: List[int]) -> int:


    def leave(self, userID: int) -> None:


    def request(self, userID: int, chunkID: int) -> List[int]:



# Your FileSharing object will be instantiated and called as such:
# obj = FileSharing(m)
# param_1 = obj.join(ownedChunks)
# obj.leave(userID)
# param_3 = obj.request(userID,chunkID)