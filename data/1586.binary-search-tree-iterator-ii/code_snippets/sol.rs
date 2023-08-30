// Definition for a binary tree node.
// #[derive(Debug, PartialEq, Eq)]
// pub struct TreeNode {
//   pub val: i32,
//   pub left: Option<Rc<RefCell<TreeNode>>>,
//   pub right: Option<Rc<RefCell<TreeNode>>>,
// }
//
// impl TreeNode {
//   #[inline]
//   pub fn new(val: i32) -> Self {
//     TreeNode {
//       val,
//       left: None,
//       right: None
//     }
//   }
// }
struct BSTIterator {

}


/**
 * `&self` means the method takes an immutable reference.
 * If you need a mutable reference, change it to `&mut self` instead.
 */
impl BSTIterator {

    fn new(root: Option<Rc<RefCell<TreeNode>>>) -> Self {

    }
    
    fn has_next(&self) -> bool {

    }
    
    fn next(&self) -> i32 {

    }
    
    fn has_prev(&self) -> bool {

    }
    
    fn prev(&self) -> i32 {

    }
}

/**
 * Your BSTIterator object will be instantiated and called as such:
 * let obj = BSTIterator::new(root);
 * let ret_1: bool = obj.has_next();
 * let ret_2: i32 = obj.next();
 * let ret_3: bool = obj.has_prev();
 * let ret_4: i32 = obj.prev();
 */