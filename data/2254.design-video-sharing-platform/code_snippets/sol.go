type VideoSharingPlatform struct {

}


func Constructor() VideoSharingPlatform {

}


func (this *VideoSharingPlatform) Upload(video string) int {

}


func (this *VideoSharingPlatform) Remove(videoId int)  {

}


func (this *VideoSharingPlatform) Watch(videoId int, startMinute int, endMinute int) string {

}


func (this *VideoSharingPlatform) Like(videoId int)  {

}


func (this *VideoSharingPlatform) Dislike(videoId int)  {

}


func (this *VideoSharingPlatform) GetLikesAndDislikes(videoId int) []int {

}


func (this *VideoSharingPlatform) GetViews(videoId int) int {

}


/**
 * Your VideoSharingPlatform object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.Upload(video);
 * obj.Remove(videoId);
 * param_3 := obj.Watch(videoId,startMinute,endMinute);
 * obj.Like(videoId);
 * obj.Dislike(videoId);
 * param_6 := obj.GetLikesAndDislikes(videoId);
 * param_7 := obj.GetViews(videoId);
 */