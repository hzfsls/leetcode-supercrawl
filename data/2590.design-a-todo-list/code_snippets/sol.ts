class TodoList {
    constructor() {

    }

    addTask(userId: number, taskDescription: string, dueDate: number, tags: string[]): number {

    }

    getAllTasks(userId: number): string[] {

    }

    getTasksForTag(userId: number, tag: string): string[] {

    }

    completeTask(userId: number, taskId: number): void {

    }
}

/**
 * Your TodoList object will be instantiated and called as such:
 * var obj = new TodoList()
 * var param_1 = obj.addTask(userId,taskDescription,dueDate,tags)
 * var param_2 = obj.getAllTasks(userId)
 * var param_3 = obj.getTasksForTag(userId,tag)
 * obj.completeTask(userId,taskId)
 */