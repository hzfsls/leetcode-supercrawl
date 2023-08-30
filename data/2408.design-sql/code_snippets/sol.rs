struct SQL {

}


/**
 * `&self` means the method takes an immutable reference.
 * If you need a mutable reference, change it to `&mut self` instead.
 */
impl SQL {

    fn new(names: Vec<String>, columns: Vec<i32>) -> Self {

    }
    
    fn insert_row(&self, name: String, row: Vec<String>) {

    }
    
    fn delete_row(&self, name: String, row_id: i32) {

    }
    
    fn select_cell(&self, name: String, row_id: i32, column_id: i32) -> String {

    }
}

/**
 * Your SQL object will be instantiated and called as such:
 * let obj = SQL::new(names, columns);
 * obj.insert_row(name, row);
 * obj.delete_row(name, rowId);
 * let ret_3: String = obj.select_cell(name, rowId, columnId);
 */