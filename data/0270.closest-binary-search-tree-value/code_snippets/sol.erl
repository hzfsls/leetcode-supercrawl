%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec closest_value(Root :: #tree_node{} | null, Target :: float()) -> integer().
closest_value(Root, Target) ->
  .