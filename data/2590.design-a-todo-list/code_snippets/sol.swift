
class TodoList {

    init() {

    }
    
    func addTask(_ userId: Int, _ taskDescription: String, _ dueDate: Int, _ tags: [String]) -> Int {

    }
    
    func getAllTasks(_ userId: Int) -> [String] {

    }
    
    func getTasksForTag(_ userId: Int, _ tag: String) -> [String] {

    }
    
    func completeTask(_ userId: Int, _ taskId: Int) {

    }
}

/**
 * Your TodoList object will be instantiated and called as such:
 * let obj = TodoList()
 * let ret_1: Int = obj.addTask(userId, taskDescription, dueDate, tags)
 * let ret_2: [String] = obj.getAllTasks(userId)
 * let ret_3: [String] = obj.getTasksForTag(userId, tag)
 * obj.completeTask(userId, taskId)
 */