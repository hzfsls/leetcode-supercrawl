class TodoList() {

    fun addTask(userId: Int, taskDescription: String, dueDate: Int, tags: List<String>): Int {

    }

    fun getAllTasks(userId: Int): List<String> {

    }

    fun getTasksForTag(userId: Int, tag: String): List<String> {

    }

    fun completeTask(userId: Int, taskId: Int) {

    }

}

/**
 * Your TodoList object will be instantiated and called as such:
 * var obj = TodoList()
 * var param_1 = obj.addTask(userId,taskDescription,dueDate,tags)
 * var param_2 = obj.getAllTasks(userId)
 * var param_3 = obj.getTasksForTag(userId,tag)
 * obj.completeTask(userId,taskId)
 */