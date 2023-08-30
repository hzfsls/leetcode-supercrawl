%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec count_great_enough_nodes(Root :: #tree_node{} | null, K :: integer()) -> integer().
count_great_enough_nodes(Root, K) ->
  .