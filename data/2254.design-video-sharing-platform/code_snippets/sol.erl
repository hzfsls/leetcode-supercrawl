-spec video_sharing_platform_init_() -> any().
video_sharing_platform_init_() ->
  .

-spec video_sharing_platform_upload(Video :: unicode:unicode_binary()) -> integer().
video_sharing_platform_upload(Video) ->
  .

-spec video_sharing_platform_remove(VideoId :: integer()) -> any().
video_sharing_platform_remove(VideoId) ->
  .

-spec video_sharing_platform_watch(VideoId :: integer(), StartMinute :: integer(), EndMinute :: integer()) -> unicode:unicode_binary().
video_sharing_platform_watch(VideoId, StartMinute, EndMinute) ->
  .

-spec video_sharing_platform_like(VideoId :: integer()) -> any().
video_sharing_platform_like(VideoId) ->
  .

-spec video_sharing_platform_dislike(VideoId :: integer()) -> any().
video_sharing_platform_dislike(VideoId) ->
  .

-spec video_sharing_platform_get_likes_and_dislikes(VideoId :: integer()) -> [integer()].
video_sharing_platform_get_likes_and_dislikes(VideoId) ->
  .

-spec video_sharing_platform_get_views(VideoId :: integer()) -> integer().
video_sharing_platform_get_views(VideoId) ->
  .


%% Your functions will be called as such:
%% video_sharing_platform_init_(),
%% Param_1 = video_sharing_platform_upload(Video),
%% video_sharing_platform_remove(VideoId),
%% Param_3 = video_sharing_platform_watch(VideoId, StartMinute, EndMinute),
%% video_sharing_platform_like(VideoId),
%% video_sharing_platform_dislike(VideoId),
%% Param_6 = video_sharing_platform_get_likes_and_dislikes(VideoId),
%% Param_7 = video_sharing_platform_get_views(VideoId),

%% video_sharing_platform_init_ will be called before every test case, in which you can do some necessary initializations.