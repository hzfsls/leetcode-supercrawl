%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec closest_k_values(Root :: #tree_node{} | null, Target :: float(), K :: integer()) -> [integer()].
closest_k_values(Root, Target, K) ->
  .