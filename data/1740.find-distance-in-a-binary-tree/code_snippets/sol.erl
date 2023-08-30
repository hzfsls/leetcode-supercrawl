%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec find_distance(Root :: #tree_node{} | null, P :: integer(), Q :: integer()) -> integer().
find_distance(Root, P, Q) ->
  .