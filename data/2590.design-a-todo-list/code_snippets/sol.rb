class TodoList
    def initialize()

    end


=begin
    :type user_id: Integer
    :type task_description: String
    :type due_date: Integer
    :type tags: String[]
    :rtype: Integer
=end
    def add_task(user_id, task_description, due_date, tags)

    end


=begin
    :type user_id: Integer
    :rtype: String[]
=end
    def get_all_tasks(user_id)

    end


=begin
    :type user_id: Integer
    :type tag: String
    :rtype: String[]
=end
    def get_tasks_for_tag(user_id, tag)

    end


=begin
    :type user_id: Integer
    :type task_id: Integer
    :rtype: Void
=end
    def complete_task(user_id, task_id)

    end


end

# Your TodoList object will be instantiated and called as such:
# obj = TodoList.new()
# param_1 = obj.add_task(user_id, task_description, due_date, tags)
# param_2 = obj.get_all_tasks(user_id)
# param_3 = obj.get_tasks_for_tag(user_id, tag)
# obj.complete_task(user_id, task_id)