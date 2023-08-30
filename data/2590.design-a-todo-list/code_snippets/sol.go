type TodoList struct {

}


func Constructor() TodoList {

}


func (this *TodoList) AddTask(userId int, taskDescription string, dueDate int, tags []string) int {

}


func (this *TodoList) GetAllTasks(userId int) []string {

}


func (this *TodoList) GetTasksForTag(userId int, tag string) []string {

}


func (this *TodoList) CompleteTask(userId int, taskId int)  {

}


/**
 * Your TodoList object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.AddTask(userId,taskDescription,dueDate,tags);
 * param_2 := obj.GetAllTasks(userId);
 * param_3 := obj.GetTasksForTag(userId,tag);
 * obj.CompleteTask(userId,taskId);
 */