
var VideoSharingPlatform = function() {

};

/** 
 * @param {string} video
 * @return {number}
 */
VideoSharingPlatform.prototype.upload = function(video) {

};

/** 
 * @param {number} videoId
 * @return {void}
 */
VideoSharingPlatform.prototype.remove = function(videoId) {

};

/** 
 * @param {number} videoId 
 * @param {number} startMinute 
 * @param {number} endMinute
 * @return {string}
 */
VideoSharingPlatform.prototype.watch = function(videoId, startMinute, endMinute) {

};

/** 
 * @param {number} videoId
 * @return {void}
 */
VideoSharingPlatform.prototype.like = function(videoId) {

};

/** 
 * @param {number} videoId
 * @return {void}
 */
VideoSharingPlatform.prototype.dislike = function(videoId) {

};

/** 
 * @param {number} videoId
 * @return {number[]}
 */
VideoSharingPlatform.prototype.getLikesAndDislikes = function(videoId) {

};

/** 
 * @param {number} videoId
 * @return {number}
 */
VideoSharingPlatform.prototype.getViews = function(videoId) {

};

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