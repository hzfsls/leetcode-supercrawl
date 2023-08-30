


typedef struct {
    
} Excel;


Excel* excelCreate(int height, char width) {
    
}

void excelSet(Excel* obj, int row, char column, int val) {
  
}

int excelGet(Excel* obj, int row, char column) {
  
}

int excelSum(Excel* obj, int row, char column, char ** numbers, int numbersSize) {
  
}

void excelFree(Excel* obj) {
    
}

/**
 * Your Excel struct will be instantiated and called as such:
 * Excel* obj = excelCreate(height, width);
 * excelSet(obj, row, column, val);
 
 * int param_2 = excelGet(obj, row, column);
 
 * int param_3 = excelSum(obj, row, column, numbers, numbersSize);
 
 * excelFree(obj);
*/