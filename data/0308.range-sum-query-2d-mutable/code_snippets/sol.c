


typedef struct {

} NumMatrix;


NumMatrix* numMatrixCreate(int** matrix, int matrixSize, int* matrixColSize) {

}

void numMatrixUpdate(NumMatrix* obj, int row, int col, int val) {

}

int numMatrixSumRegion(NumMatrix* obj, int row1, int col1, int row2, int col2) {

}

void numMatrixFree(NumMatrix* obj) {

}

/**
 * Your NumMatrix struct will be instantiated and called as such:
 * NumMatrix* obj = numMatrixCreate(matrix, matrixSize, matrixColSize);
 * numMatrixUpdate(obj, row, col, val);
 
 * int param_2 = numMatrixSumRegion(obj, row1, col1, row2, col2);
 
 * numMatrixFree(obj);
*/