%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec largest_bst_subtree(Root :: #tree_node{} | null) -> integer().
largest_bst_subtree(Root) ->
  .