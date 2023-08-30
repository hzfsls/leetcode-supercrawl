%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec bst_to_gst(Root :: #tree_node{} | null) -> #tree_node{} | null.
bst_to_gst(Root) ->
  .