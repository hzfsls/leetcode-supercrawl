-spec sql_init_(Names :: [unicode:unicode_binary()], Columns :: [integer()]) -> any().
sql_init_(Names, Columns) ->
  .

-spec sql_insert_row(Name :: unicode:unicode_binary(), Row :: [unicode:unicode_binary()]) -> any().
sql_insert_row(Name, Row) ->
  .

-spec sql_delete_row(Name :: unicode:unicode_binary(), RowId :: integer()) -> any().
sql_delete_row(Name, RowId) ->
  .

-spec sql_select_cell(Name :: unicode:unicode_binary(), RowId :: integer(), ColumnId :: integer()) -> unicode:unicode_binary().
sql_select_cell(Name, RowId, ColumnId) ->
  .


%% Your functions will be called as such:
%% sql_init_(Names, Columns),
%% sql_insert_row(Name, Row),
%% sql_delete_row(Name, RowId),
%% Param_3 = sql_select_cell(Name, RowId, ColumnId),

%% sql_init_ will be called before every test case, in which you can do some necessary initializations.