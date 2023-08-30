%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec is_valid_bst(Root :: #tree_node{} | null) -> boolean().
is_valid_bst(Root) ->
  .