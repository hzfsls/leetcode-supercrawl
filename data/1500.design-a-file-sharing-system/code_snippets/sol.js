/**
 * @param {number} m
 */
var FileSharing = function(m) {

};

/** 
 * @param {number[]} ownedChunks
 * @return {number}
 */
FileSharing.prototype.join = function(ownedChunks) {

};

/** 
 * @param {number} userID
 * @return {void}
 */
FileSharing.prototype.leave = function(userID) {

};

/** 
 * @param {number} userID 
 * @param {number} chunkID
 * @return {number[]}
 */
FileSharing.prototype.request = function(userID, chunkID) {

};

/**
 * Your FileSharing object will be instantiated and called as such:
 * var obj = new FileSharing(m)
 * var param_1 = obj.join(ownedChunks)
 * obj.leave(userID)
 * var param_3 = obj.request(userID,chunkID)
 */