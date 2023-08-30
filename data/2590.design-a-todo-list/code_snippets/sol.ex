defmodule TodoList do
  @spec init_() :: any
  def init_() do

  end

  @spec add_task(user_id :: integer, task_description :: String.t, due_date :: integer, tags :: [String.t]) :: integer
  def add_task(user_id, task_description, due_date, tags) do

  end

  @spec get_all_tasks(user_id :: integer) :: [String.t]
  def get_all_tasks(user_id) do

  end

  @spec get_tasks_for_tag(user_id :: integer, tag :: String.t) :: [String.t]
  def get_tasks_for_tag(user_id, tag) do

  end

  @spec complete_task(user_id :: integer, task_id :: integer) :: any
  def complete_task(user_id, task_id) do

  end
end

# Your functions will be called as such:
# TodoList.init_()
# param_1 = TodoList.add_task(user_id, task_description, due_date, tags)
# param_2 = TodoList.get_all_tasks(user_id)
# param_3 = TodoList.get_tasks_for_tag(user_id, tag)
# TodoList.complete_task(user_id, task_id)

# TodoList.init_ will be called before every test case, in which you can do some necessary initializations.