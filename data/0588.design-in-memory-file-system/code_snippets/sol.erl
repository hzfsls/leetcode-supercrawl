-spec file_system_init_() -> any().
file_system_init_() ->
  .

-spec file_system_ls(Path :: unicode:unicode_binary()) -> [unicode:unicode_binary()].
file_system_ls(Path) ->
  .

-spec file_system_mkdir(Path :: unicode:unicode_binary()) -> any().
file_system_mkdir(Path) ->
  .

-spec file_system_add_content_to_file(FilePath :: unicode:unicode_binary(), Content :: unicode:unicode_binary()) -> any().
file_system_add_content_to_file(FilePath, Content) ->
  .

-spec file_system_read_content_from_file(FilePath :: unicode:unicode_binary()) -> unicode:unicode_binary().
file_system_read_content_from_file(FilePath) ->
  .


%% Your functions will be called as such:
%% file_system_init_(),
%% Param_1 = file_system_ls(Path),
%% file_system_mkdir(Path),
%% file_system_add_content_to_file(FilePath, Content),
%% Param_4 = file_system_read_content_from_file(FilePath),

%% file_system_init_ will be called before every test case, in which you can do some necessary initializations.