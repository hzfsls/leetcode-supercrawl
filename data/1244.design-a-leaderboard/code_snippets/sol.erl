-spec leaderboard_init_() -> any().
leaderboard_init_() ->
  .

-spec leaderboard_add_score(PlayerId :: integer(), Score :: integer()) -> any().
leaderboard_add_score(PlayerId, Score) ->
  .

-spec leaderboard_top(K :: integer()) -> integer().
leaderboard_top(K) ->
  .

-spec leaderboard_reset(PlayerId :: integer()) -> any().
leaderboard_reset(PlayerId) ->
  .


%% Your functions will be called as such:
%% leaderboard_init_(),
%% leaderboard_add_score(PlayerId, Score),
%% Param_2 = leaderboard_top(K),
%% leaderboard_reset(PlayerId),

%% leaderboard_init_ will be called before every test case, in which you can do some necessary initializations.