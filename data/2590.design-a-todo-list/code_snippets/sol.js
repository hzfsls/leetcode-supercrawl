
var TodoList = function() {

};

/** 
 * @param {number} userId 
 * @param {string} taskDescription 
 * @param {number} dueDate 
 * @param {string[]} tags
 * @return {number}
 */
TodoList.prototype.addTask = function(userId, taskDescription, dueDate, tags) {

};

/** 
 * @param {number} userId
 * @return {string[]}
 */
TodoList.prototype.getAllTasks = function(userId) {

};

/** 
 * @param {number} userId 
 * @param {string} tag
 * @return {string[]}
 */
TodoList.prototype.getTasksForTag = function(userId, tag) {

};

/** 
 * @param {number} userId 
 * @param {number} taskId
 * @return {void}
 */
TodoList.prototype.completeTask = function(userId, taskId) {

};

/**
 * Your TodoList object will be instantiated and called as such:
 * var obj = new TodoList()
 * var param_1 = obj.addTask(userId,taskDescription,dueDate,tags)
 * var param_2 = obj.getAllTasks(userId)
 * var param_3 = obj.getTasksForTag(userId,tag)
 * obj.completeTask(userId,taskId)
 */