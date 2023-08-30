class TodoList {
public:
    TodoList() {

    }
    
    int addTask(int userId, string taskDescription, int dueDate, vector<string> tags) {

    }
    
    vector<string> getAllTasks(int userId) {

    }
    
    vector<string> getTasksForTag(int userId, string tag) {

    }
    
    void completeTask(int userId, int taskId) {

    }
};

/**
 * Your TodoList object will be instantiated and called as such:
 * TodoList* obj = new TodoList();
 * int param_1 = obj->addTask(userId,taskDescription,dueDate,tags);
 * vector<string> param_2 = obj->getAllTasks(userId);
 * vector<string> param_3 = obj->getTasksForTag(userId,tag);
 * obj->completeTask(userId,taskId);
 */