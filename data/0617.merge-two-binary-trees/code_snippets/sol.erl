%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec merge_trees(Root1 :: #tree_node{} | null, Root2 :: #tree_node{} | null) -> #tree_node{} | null.
merge_trees(Root1, Root2) ->
  .