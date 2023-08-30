%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec equal_to_descendants(Root :: #tree_node{} | null) -> integer().
equal_to_descendants(Root) ->
  .