
class VideoSharingPlatform {

    init() {

    }
    
    func upload(_ video: String) -> Int {

    }
    
    func remove(_ videoId: Int) {

    }
    
    func watch(_ videoId: Int, _ startMinute: Int, _ endMinute: Int) -> String {

    }
    
    func like(_ videoId: Int) {

    }
    
    func dislike(_ videoId: Int) {

    }
    
    func getLikesAndDislikes(_ videoId: Int) -> [Int] {

    }
    
    func getViews(_ videoId: Int) -> Int {

    }
}

/**
 * Your VideoSharingPlatform object will be instantiated and called as such:
 * let obj = VideoSharingPlatform()
 * let ret_1: Int = obj.upload(video)
 * obj.remove(videoId)
 * let ret_3: String = obj.watch(videoId, startMinute, endMinute)
 * obj.like(videoId)
 * obj.dislike(videoId)
 * let ret_6: [Int] = obj.getLikesAndDislikes(videoId)
 * let ret_7: Int = obj.getViews(videoId)
 */