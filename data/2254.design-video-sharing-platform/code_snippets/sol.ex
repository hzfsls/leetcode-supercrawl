defmodule VideoSharingPlatform do
  @spec init_() :: any
  def init_() do

  end

  @spec upload(video :: String.t) :: integer
  def upload(video) do

  end

  @spec remove(video_id :: integer) :: any
  def remove(video_id) do

  end

  @spec watch(video_id :: integer, start_minute :: integer, end_minute :: integer) :: String.t
  def watch(video_id, start_minute, end_minute) do

  end

  @spec like(video_id :: integer) :: any
  def like(video_id) do

  end

  @spec dislike(video_id :: integer) :: any
  def dislike(video_id) do

  end

  @spec get_likes_and_dislikes(video_id :: integer) :: [integer]
  def get_likes_and_dislikes(video_id) do

  end

  @spec get_views(video_id :: integer) :: integer
  def get_views(video_id) do

  end
end

# Your functions will be called as such:
# VideoSharingPlatform.init_()
# param_1 = VideoSharingPlatform.upload(video)
# VideoSharingPlatform.remove(video_id)
# param_3 = VideoSharingPlatform.watch(video_id, start_minute, end_minute)
# VideoSharingPlatform.like(video_id)
# VideoSharingPlatform.dislike(video_id)
# param_6 = VideoSharingPlatform.get_likes_and_dislikes(video_id)
# param_7 = VideoSharingPlatform.get_views(video_id)

# VideoSharingPlatform.init_ will be called before every test case, in which you can do some necessary initializations.