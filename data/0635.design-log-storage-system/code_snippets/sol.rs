struct LogSystem {

}


/**
 * `&self` means the method takes an immutable reference.
 * If you need a mutable reference, change it to `&mut self` instead.
 */
impl LogSystem {

    fn new() -> Self {

    }
    
    fn put(&self, id: i32, timestamp: String) {

    }
    
    fn retrieve(&self, start: String, end: String, granularity: String) -> Vec<i32> {

    }
}

/**
 * Your LogSystem object will be instantiated and called as such:
 * let obj = LogSystem::new();
 * obj.put(id, timestamp);
 * let ret_2: Vec<i32> = obj.retrieve(start, end, granularity);
 */