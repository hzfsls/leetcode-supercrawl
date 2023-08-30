-spec todo_list_init_() -> any().
todo_list_init_() ->
  .

-spec todo_list_add_task(UserId :: integer(), TaskDescription :: unicode:unicode_binary(), DueDate :: integer(), Tags :: [unicode:unicode_binary()]) -> integer().
todo_list_add_task(UserId, TaskDescription, DueDate, Tags) ->
  .

-spec todo_list_get_all_tasks(UserId :: integer()) -> [unicode:unicode_binary()].
todo_list_get_all_tasks(UserId) ->
  .

-spec todo_list_get_tasks_for_tag(UserId :: integer(), Tag :: unicode:unicode_binary()) -> [unicode:unicode_binary()].
todo_list_get_tasks_for_tag(UserId, Tag) ->
  .

-spec todo_list_complete_task(UserId :: integer(), TaskId :: integer()) -> any().
todo_list_complete_task(UserId, TaskId) ->
  .


%% Your functions will be called as such:
%% todo_list_init_(),
%% Param_1 = todo_list_add_task(UserId, TaskDescription, DueDate, Tags),
%% Param_2 = todo_list_get_all_tasks(UserId),
%% Param_3 = todo_list_get_tasks_for_tag(UserId, Tag),
%% todo_list_complete_task(UserId, TaskId),

%% todo_list_init_ will be called before every test case, in which you can do some necessary initializations.