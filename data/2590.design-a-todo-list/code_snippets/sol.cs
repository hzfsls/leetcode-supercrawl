public class TodoList {

    public TodoList() {

    }
    
    public int AddTask(int userId, string taskDescription, int dueDate, IList<string> tags) {

    }
    
    public IList<string> GetAllTasks(int userId) {

    }
    
    public IList<string> GetTasksForTag(int userId, string tag) {

    }
    
    public void CompleteTask(int userId, int taskId) {

    }
}

/**
 * Your TodoList object will be instantiated and called as such:
 * TodoList obj = new TodoList();
 * int param_1 = obj.AddTask(userId,taskDescription,dueDate,tags);
 * IList<string> param_2 = obj.GetAllTasks(userId);
 * IList<string> param_3 = obj.GetTasksForTag(userId,tag);
 * obj.CompleteTask(userId,taskId);
 */