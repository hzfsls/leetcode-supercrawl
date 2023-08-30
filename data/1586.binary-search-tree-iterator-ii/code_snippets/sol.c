/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */



typedef struct {

} BSTIterator;


BSTIterator* bSTIteratorCreate(struct TreeNode* root) {

}

bool bSTIteratorHasNext(BSTIterator* obj) {

}

int bSTIteratorNext(BSTIterator* obj) {

}

bool bSTIteratorHasPrev(BSTIterator* obj) {

}

int bSTIteratorPrev(BSTIterator* obj) {

}

void bSTIteratorFree(BSTIterator* obj) {

}

/**
 * Your BSTIterator struct will be instantiated and called as such:
 * BSTIterator* obj = bSTIteratorCreate(root);
 * bool param_1 = bSTIteratorHasNext(obj);
 
 * int param_2 = bSTIteratorNext(obj);
 
 * bool param_3 = bSTIteratorHasPrev(obj);
 
 * int param_4 = bSTIteratorPrev(obj);
 
 * bSTIteratorFree(obj);
*/