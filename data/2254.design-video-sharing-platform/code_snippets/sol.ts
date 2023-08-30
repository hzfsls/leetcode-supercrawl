class VideoSharingPlatform {
    constructor() {

    }

    upload(video: string): number {

    }

    remove(videoId: number): void {

    }

    watch(videoId: number, startMinute: number, endMinute: number): string {

    }

    like(videoId: number): void {

    }

    dislike(videoId: number): void {

    }

    getLikesAndDislikes(videoId: number): number[] {

    }

    getViews(videoId: number): number {

    }
}

/**
 * Your VideoSharingPlatform object will be instantiated and called as such:
 * var obj = new VideoSharingPlatform()
 * var param_1 = obj.upload(video)
 * obj.remove(videoId)
 * var param_3 = obj.watch(videoId,startMinute,endMinute)
 * obj.like(videoId)
 * obj.dislike(videoId)
 * var param_6 = obj.getLikesAndDislikes(videoId)
 * var param_7 = obj.getViews(videoId)
 */