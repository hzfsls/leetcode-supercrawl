%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec max_ancestor_diff(Root :: #tree_node{} | null) -> integer().
max_ancestor_diff(Root) ->
  .