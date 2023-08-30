class SQL:

    def __init__(self, names: List[str], columns: List[int]):


    def insertRow(self, name: str, row: List[str]) -> None:


    def deleteRow(self, name: str, rowId: int) -> None:


    def selectCell(self, name: str, rowId: int, columnId: int) -> str:



# Your SQL object will be instantiated and called as such:
# obj = SQL(names, columns)
# obj.insertRow(name,row)
# obj.deleteRow(name,rowId)
# param_3 = obj.selectCell(name,rowId,columnId)