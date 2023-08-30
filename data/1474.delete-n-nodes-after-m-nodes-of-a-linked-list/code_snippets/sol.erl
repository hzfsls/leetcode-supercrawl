%% Definition for singly-linked list.
%%
%% -record(list_node, {val = 0 :: integer(),
%%                     next = null :: 'null' | #list_node{}}).

-spec delete_nodes(Head :: #list_node{} | null, M :: integer(), N :: integer()) -> #list_node{} | null.
delete_nodes(Head, M, N) ->
  .