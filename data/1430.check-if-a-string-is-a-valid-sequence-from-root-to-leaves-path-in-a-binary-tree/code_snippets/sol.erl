%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec is_valid_sequence(Root :: #tree_node{} | null, Arr :: [integer()]) -> boolean().
is_valid_sequence(Root, Arr) ->
  .