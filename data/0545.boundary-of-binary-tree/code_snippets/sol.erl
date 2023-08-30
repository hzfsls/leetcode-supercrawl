%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec boundary_of_binary_tree(Root :: #tree_node{} | null) -> [integer()].
boundary_of_binary_tree(Root) ->
  .