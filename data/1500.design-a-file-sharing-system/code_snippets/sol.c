


typedef struct {

} FileSharing;


FileSharing* fileSharingCreate(int m) {

}

int fileSharingJoin(FileSharing* obj, int* ownedChunks, int ownedChunksSize) {

}

void fileSharingLeave(FileSharing* obj, int userID) {

}

int* fileSharingRequest(FileSharing* obj, int userID, int chunkID, int* retSize) {

}

void fileSharingFree(FileSharing* obj) {

}

/**
 * Your FileSharing struct will be instantiated and called as such:
 * FileSharing* obj = fileSharingCreate(m);
 * int param_1 = fileSharingJoin(obj, ownedChunks, ownedChunksSize);
 
 * fileSharingLeave(obj, userID);
 
 * int* param_3 = fileSharingRequest(obj, userID, chunkID, retSize);
 
 * fileSharingFree(obj);
*/