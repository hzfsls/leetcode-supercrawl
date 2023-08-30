


typedef struct {
    
} TodoList;


TodoList* todoListCreate() {
    
}

int todoListAddTask(TodoList* obj, int userId, char * taskDescription, int dueDate, char ** tags, int tagsSize) {
  
}

char ** todoListGetAllTasks(TodoList* obj, int userId, int* retSize) {
  
}

char ** todoListGetTasksForTag(TodoList* obj, int userId, char * tag, int* retSize) {
  
}

void todoListCompleteTask(TodoList* obj, int userId, int taskId) {
  
}

void todoListFree(TodoList* obj) {
    
}

/**
 * Your TodoList struct will be instantiated and called as such:
 * TodoList* obj = todoListCreate();
 * int param_1 = todoListAddTask(obj, userId, taskDescription, dueDate, tags, tagsSize);
 
 * char ** param_2 = todoListGetAllTasks(obj, userId, retSize);
 
 * char ** param_3 = todoListGetTasksForTag(obj, userId, tag, retSize);
 
 * todoListCompleteTask(obj, userId, taskId);
 
 * todoListFree(obj);
*/