struct VideoSharingPlatform {

}


/**
 * `&self` means the method takes an immutable reference.
 * If you need a mutable reference, change it to `&mut self` instead.
 */
impl VideoSharingPlatform {

    fn new() -> Self {

    }
    
    fn upload(&self, video: String) -> i32 {

    }
    
    fn remove(&self, video_id: i32) {

    }
    
    fn watch(&self, video_id: i32, start_minute: i32, end_minute: i32) -> String {

    }
    
    fn like(&self, video_id: i32) {

    }
    
    fn dislike(&self, video_id: i32) {

    }
    
    fn get_likes_and_dislikes(&self, video_id: i32) -> Vec<i32> {

    }
    
    fn get_views(&self, video_id: i32) -> i32 {

    }
}

/**
 * Your VideoSharingPlatform object will be instantiated and called as such:
 * let obj = VideoSharingPlatform::new();
 * let ret_1: i32 = obj.upload(video);
 * obj.remove(videoId);
 * let ret_3: String = obj.watch(videoId, startMinute, endMinute);
 * obj.like(videoId);
 * obj.dislike(videoId);
 * let ret_6: Vec<i32> = obj.get_likes_and_dislikes(videoId);
 * let ret_7: i32 = obj.get_views(videoId);
 */