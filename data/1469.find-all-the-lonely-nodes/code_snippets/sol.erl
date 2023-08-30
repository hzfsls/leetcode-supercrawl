%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec get_lonely_nodes(Root :: #tree_node{} | null) -> [integer()].
get_lonely_nodes(Root) ->
  .