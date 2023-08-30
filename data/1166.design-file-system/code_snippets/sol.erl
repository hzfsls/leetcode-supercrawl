-spec file_system_init_() -> any().
file_system_init_() ->
  .

-spec file_system_create_path(Path :: unicode:unicode_binary(), Value :: integer()) -> boolean().
file_system_create_path(Path, Value) ->
  .

-spec file_system_get(Path :: unicode:unicode_binary()) -> integer().
file_system_get(Path) ->
  .


%% Your functions will be called as such:
%% file_system_init_(),
%% Param_1 = file_system_create_path(Path, Value),
%% Param_2 = file_system_get(Path),

%% file_system_init_ will be called before every test case, in which you can do some necessary initializations.