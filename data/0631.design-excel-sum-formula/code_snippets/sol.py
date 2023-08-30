class Excel:

    def __init__(self, height: int, width: str):


    def set(self, row: int, column: str, val: int) -> None:


    def get(self, row: int, column: str) -> int:


    def sum(self, row: int, column: str, numbers: List[str]) -> int:



# Your Excel object will be instantiated and called as such:
# obj = Excel(height, width)
# obj.set(row,column,val)
# param_2 = obj.get(row,column)
# param_3 = obj.sum(row,column,numbers)