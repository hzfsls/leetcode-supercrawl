%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec upside_down_binary_tree(Root :: #tree_node{} | null) -> #tree_node{} | null.
upside_down_binary_tree(Root) ->
  .