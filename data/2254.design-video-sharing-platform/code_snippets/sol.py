class VideoSharingPlatform:

    def __init__(self):


    def upload(self, video: str) -> int:


    def remove(self, videoId: int) -> None:


    def watch(self, videoId: int, startMinute: int, endMinute: int) -> str:


    def like(self, videoId: int) -> None:


    def dislike(self, videoId: int) -> None:


    def getLikesAndDislikes(self, videoId: int) -> List[int]:


    def getViews(self, videoId: int) -> int:



# Your VideoSharingPlatform object will be instantiated and called as such:
# obj = VideoSharingPlatform()
# param_1 = obj.upload(video)
# obj.remove(videoId)
# param_3 = obj.watch(videoId,startMinute,endMinute)
# obj.like(videoId)
# obj.dislike(videoId)
# param_6 = obj.getLikesAndDislikes(videoId)
# param_7 = obj.getViews(videoId)