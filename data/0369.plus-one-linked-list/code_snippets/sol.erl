%% Definition for singly-linked list.
%%
%% -record(list_node, {val = 0 :: integer(),
%%                     next = null :: 'null' | #list_node{}}).

-spec plus_one(Head :: #list_node{} | null) -> #list_node{} | null.
plus_one(Head) ->
  .