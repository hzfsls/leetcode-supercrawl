%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec find_closest_leaf(Root :: #tree_node{} | null, K :: integer()) -> integer().
find_closest_leaf(Root, K) ->
  .