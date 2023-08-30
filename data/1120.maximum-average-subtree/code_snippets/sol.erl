%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec maximum_average_subtree(Root :: #tree_node{} | null) -> float().
maximum_average_subtree(Root) ->
  .