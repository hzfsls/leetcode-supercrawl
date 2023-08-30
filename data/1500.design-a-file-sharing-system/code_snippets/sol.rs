struct FileSharing {

}


/**
 * `&self` means the method takes an immutable reference.
 * If you need a mutable reference, change it to `&mut self` instead.
 */
impl FileSharing {

    fn new(m: i32) -> Self {

    }
    
    fn join(&self, owned_chunks: Vec<i32>) -> i32 {

    }
    
    fn leave(&self, user_id: i32) {

    }
    
    fn request(&self, user_id: i32, chunk_id: i32) -> Vec<i32> {

    }
}

/**
 * Your FileSharing object will be instantiated and called as such:
 * let obj = FileSharing::new(m);
 * let ret_1: i32 = obj.join(ownedChunks);
 * obj.leave(userID);
 * let ret_3: Vec<i32> = obj.request(userID, chunkID);
 */