struct FileSystem {

}


/**
 * `&self` means the method takes an immutable reference.
 * If you need a mutable reference, change it to `&mut self` instead.
 */
impl FileSystem {

    fn new() -> Self {

    }
    
    fn ls(&self, path: String) -> Vec<String> {

    }
    
    fn mkdir(&self, path: String) {

    }
    
    fn add_content_to_file(&self, file_path: String, content: String) {

    }
    
    fn read_content_from_file(&self, file_path: String) -> String {

    }
}

/**
 * Your FileSystem object will be instantiated and called as such:
 * let obj = FileSystem::new();
 * let ret_1: Vec<String> = obj.ls(path);
 * obj.mkdir(path);
 * obj.add_content_to_file(filePath, content);
 * let ret_4: String = obj.read_content_from_file(filePath);
 */