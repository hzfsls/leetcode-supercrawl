class TodoList {
    /**
     */
    function __construct() {

    }

    /**
     * @param Integer $userId
     * @param String $taskDescription
     * @param Integer $dueDate
     * @param String[] $tags
     * @return Integer
     */
    function addTask($userId, $taskDescription, $dueDate, $tags) {

    }

    /**
     * @param Integer $userId
     * @return String[]
     */
    function getAllTasks($userId) {

    }

    /**
     * @param Integer $userId
     * @param String $tag
     * @return String[]
     */
    function getTasksForTag($userId, $tag) {

    }

    /**
     * @param Integer $userId
     * @param Integer $taskId
     * @return NULL
     */
    function completeTask($userId, $taskId) {

    }
}

/**
 * Your TodoList object will be instantiated and called as such:
 * $obj = TodoList();
 * $ret_1 = $obj->addTask($userId, $taskDescription, $dueDate, $tags);
 * $ret_2 = $obj->getAllTasks($userId);
 * $ret_3 = $obj->getTasksForTag($userId, $tag);
 * $obj->completeTask($userId, $taskId);
 */