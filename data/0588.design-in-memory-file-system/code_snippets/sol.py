class FileSystem:

    def __init__(self):


    def ls(self, path: str) -> List[str]:


    def mkdir(self, path: str) -> None:


    def addContentToFile(self, filePath: str, content: str) -> None:


    def readContentFromFile(self, filePath: str) -> str:



# Your FileSystem object will be instantiated and called as such:
# obj = FileSystem()
# param_1 = obj.ls(path)
# obj.mkdir(path)
# obj.addContentToFile(filePath,content)
# param_4 = obj.readContentFromFile(filePath)