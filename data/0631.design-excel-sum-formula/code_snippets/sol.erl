-spec excel_init_(Height :: integer(), Width :: char()) -> any().
excel_init_(Height, Width) ->
  .

-spec excel_set(Row :: integer(), Column :: char(), Val :: integer()) -> any().
excel_set(Row, Column, Val) ->
  .

-spec excel_get(Row :: integer(), Column :: char()) -> integer().
excel_get(Row, Column) ->
  .

-spec excel_sum(Row :: integer(), Column :: char(), Numbers :: [unicode:unicode_binary()]) -> integer().
excel_sum(Row, Column, Numbers) ->
  .


%% Your functions will be called as such:
%% excel_init_(Height, Width),
%% excel_set(Row, Column, Val),
%% Param_2 = excel_get(Row, Column),
%% Param_3 = excel_sum(Row, Column, Numbers),

%% excel_init_ will be called before every test case, in which you can do some necessary initializations.