%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec min_camera_cover(Root :: #tree_node{} | null) -> integer().
min_camera_cover(Root) ->
  .