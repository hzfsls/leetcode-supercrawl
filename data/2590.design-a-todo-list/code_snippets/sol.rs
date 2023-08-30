struct TodoList {

}


/**
 * `&self` means the method takes an immutable reference.
 * If you need a mutable reference, change it to `&mut self` instead.
 */
impl TodoList {

    fn new() -> Self {

    }
    
    fn add_task(&self, user_id: i32, task_description: String, due_date: i32, tags: Vec<String>) -> i32 {

    }
    
    fn get_all_tasks(&self, user_id: i32) -> Vec<String> {

    }
    
    fn get_tasks_for_tag(&self, user_id: i32, tag: String) -> Vec<String> {

    }
    
    fn complete_task(&self, user_id: i32, task_id: i32) {

    }
}

/**
 * Your TodoList object will be instantiated and called as such:
 * let obj = TodoList::new();
 * let ret_1: i32 = obj.add_task(userId, taskDescription, dueDate, tags);
 * let ret_2: Vec<String> = obj.get_all_tasks(userId);
 * let ret_3: Vec<String> = obj.get_tasks_for_tag(userId, tag);
 * obj.complete_task(userId, taskId);
 */