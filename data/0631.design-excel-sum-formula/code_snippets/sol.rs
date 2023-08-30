struct Excel {

}


/**
 * `&self` means the method takes an immutable reference.
 * If you need a mutable reference, change it to `&mut self` instead.
 */
impl Excel {

    fn new(height: i32, width: char) -> Self {

    }
    
    fn set(&self, row: i32, column: char, val: i32) {

    }
    
    fn get(&self, row: i32, column: char) -> i32 {

    }
    
    fn sum(&self, row: i32, column: char, numbers: Vec<String>) -> i32 {

    }
}

/**
 * Your Excel object will be instantiated and called as such:
 * let obj = Excel::new(height, width);
 * obj.set(row, column, val);
 * let ret_2: i32 = obj.get(row, column);
 * let ret_3: i32 = obj.sum(row, column, numbers);
 */