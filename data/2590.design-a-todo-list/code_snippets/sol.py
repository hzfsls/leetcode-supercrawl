class TodoList:

    def __init__(self):


    def addTask(self, userId: int, taskDescription: str, dueDate: int, tags: List[str]) -> int:


    def getAllTasks(self, userId: int) -> List[str]:


    def getTasksForTag(self, userId: int, tag: str) -> List[str]:


    def completeTask(self, userId: int, taskId: int) -> None:



# Your TodoList object will be instantiated and called as such:
# obj = TodoList()
# param_1 = obj.addTask(userId,taskDescription,dueDate,tags)
# param_2 = obj.getAllTasks(userId)
# param_3 = obj.getTasksForTag(userId,tag)
# obj.completeTask(userId,taskId)