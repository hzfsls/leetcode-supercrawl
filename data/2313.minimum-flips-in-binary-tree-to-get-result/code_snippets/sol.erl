%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec minimum_flips(Root :: #tree_node{} | null, Result :: boolean()) -> integer().
minimum_flips(Root, Result) ->
  .