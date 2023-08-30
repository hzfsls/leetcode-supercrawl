type FileSharing struct {

}


func Constructor(m int) FileSharing {

}


func (this *FileSharing) Join(ownedChunks []int) int {

}


func (this *FileSharing) Leave(userID int)  {

}


func (this *FileSharing) Request(userID int, chunkID int) []int {

}


/**
 * Your FileSharing object will be instantiated and called as such:
 * obj := Constructor(m);
 * param_1 := obj.Join(ownedChunks);
 * obj.Leave(userID);
 * param_3 := obj.Request(userID,chunkID);
 */