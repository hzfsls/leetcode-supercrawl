class VideoSharingPlatform
    def initialize()

    end


=begin
    :type video: String
    :rtype: Integer
=end
    def upload(video)

    end


=begin
    :type video_id: Integer
    :rtype: Void
=end
    def remove(video_id)

    end


=begin
    :type video_id: Integer
    :type start_minute: Integer
    :type end_minute: Integer
    :rtype: String
=end
    def watch(video_id, start_minute, end_minute)

    end


=begin
    :type video_id: Integer
    :rtype: Void
=end
    def like(video_id)

    end


=begin
    :type video_id: Integer
    :rtype: Void
=end
    def dislike(video_id)

    end


=begin
    :type video_id: Integer
    :rtype: Integer[]
=end
    def get_likes_and_dislikes(video_id)

    end


=begin
    :type video_id: Integer
    :rtype: Integer
=end
    def get_views(video_id)

    end


end

# Your VideoSharingPlatform object will be instantiated and called as such:
# obj = VideoSharingPlatform.new()
# param_1 = obj.upload(video)
# obj.remove(video_id)
# param_3 = obj.watch(video_id, start_minute, end_minute)
# obj.like(video_id)
# obj.dislike(video_id)
# param_6 = obj.get_likes_and_dislikes(video_id)
# param_7 = obj.get_views(video_id)