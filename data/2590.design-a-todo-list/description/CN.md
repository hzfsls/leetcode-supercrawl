## [2590.设计一个待办事项清单](https://leetcode.cn/problems/design-a-todo-list/)
<p>设计一个待办事项清单，用户可以添加 <strong>任务</strong> ，标记任务为 <strong>完成状态</strong> ，或获取待办任务列表。用户还可以为任务添加 <strong>标签</strong> ，并可以按照特定标签筛选任务。</p>

<p>实现 <code>TodoList</code> 类：</p>

<ul>
	<li><code>TodoList()</code> 初始化对象。</li>
	<li><code>int addTask(int userId, String taskDescription, int dueDate, List&lt;String&gt; tags)</code> 为用户 ID 为 <code>userId</code> 的用户添加一个任务，该任务的到期日期为 <code>dueDate</code>&nbsp;，附带了一个标签列表 <code>tags</code>&nbsp;。返回值为任务的 ID 。该 ID 从 <code>1</code> 开始，<strong>依次</strong> 递增。即，第一个任务的ID应为 <code>1</code> ，第二个任务的 ID 应为 <code>2</code> ，以此类推。</li>
	<li><code>List&lt;String&gt; getAllTasks(int userId)</code> 返回未标记为完成状态的 ID 为 <code>userId</code> 的用户的所有任务列表，按照到期日期排序。如果用户没有未完成的任务，则应返回一个空列表。</li>
	<li><code>List&lt;String&gt; getTasksForTag(int userId, String tag)</code> 返回 ID 为 <code>userId</code> 的用户未标记为完成状态且具有 <code>tag</code> 标签之一的所有任务列表，按照到期日期排序。如果不存在此类任务，则返回一个空列表。</li>
	<li><code>void completeTask(int userId, int taskId)</code> 仅在任务存在且 ID 为 <code>userId</code> 的用户拥有此任务且它是未完成状态时，将 ID 为 <code>taskId</code> 的任务标记为已完成状态。</li>
</ul>

<p>&nbsp;</p>

<p><strong class="example">示例 1 ：</strong></p>

<pre>
<strong>输入</strong>
["TodoList", "addTask", "addTask", "getAllTasks", "getAllTasks", "addTask", "getTasksForTag", "completeTask", "completeTask", "getTasksForTag", "getAllTasks"]
[[], [1, "Task1", 50, []], [1, "Task2", 100, ["P1"]], [1], [5], [1, "Task3", 30, ["P1"]], [1, "P1"], [5, 1], [1, 2], [1, "P1"], [1]]
<strong>输出</strong>
[null, 1, 2, ["Task1", "Task2"], [], 3, ["Task3", "Task2"], null, null, ["Task3"], ["Task3", "Task1"]]

<strong>解释</strong>
TodoList todoList = new TodoList(); 
todoList.addTask(1, "Task1", 50, []); // 返回1。为ID为1的用户添加一个新任务。 
todoList.addTask(1, "Task2", 100, ["P1"]); // 返回2。为ID为1的用户添加另一个任务，并给它添加标签“P1”。 
todoList.getAllTasks(1); // 返回["Task1", "Task2"]。用户1目前有两个未完成的任务。 
todoList.getAllTasks(5); // 返回[]。用户5目前没有任务。 
todoList.addTask(1, "Task3", 30, ["P1"]); // 返回3。为ID为1的用户添加另一个任务，并给它添加标签“P1”。 
todoList.getTasksForTag(1, "P1"); // 返回["Task3", "Task2"]。返回ID为1的用户未完成的带有“P1”标签的任务。 
todoList.completeTask(5, 1); // 不做任何操作，因为任务1不属于用户5。 
todoList.completeTask(1, 2); // 将任务2标记为已完成。 
todoList.getTasksForTag(1, "P1"); // 返回["Task3"]。返回ID为1的用户未完成的带有“P1”标签的任务。 
                                  // 注意，现在不包括 “Task2” ，因为它已经被标记为已完成。 
todoList.getAllTasks(1); // 返回["Task3", "Task1"]。用户1现在有两个未完成的任务。

</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= userId, taskId, dueDate &lt;= 100</code></li>
	<li><code>0 &lt;= tags.length &lt;= 100</code></li>
	<li><code>1 &lt;= taskDescription.length &lt;= 50</code></li>
	<li><code>1 &lt;= tags[i].length, tag.length &lt;= 20</code></li>
	<li>所有的&nbsp;<code>dueDate</code> 值都是唯一的。</li>
	<li>所有字符串都由小写和大写英文字母和数字组成。</li>
	<li>每个方法最多被调用 <code>100</code> 次。</li>
</ul>
