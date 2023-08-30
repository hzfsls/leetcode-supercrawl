%% Definition for singly-linked list.
%%
%% -record(list_node, {val = 0 :: integer(),
%%                     next = null :: 'null' | #list_node{}}).

-spec sort_linked_list(Head :: #list_node{} | null) -> #list_node{} | null.
sort_linked_list(Head) ->
  .