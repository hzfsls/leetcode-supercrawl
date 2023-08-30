


typedef struct {
    
} SQL;


SQL* sQLCreate(char ** names, int namesSize, int* columns, int columnsSize) {
    
}

void sQLInsertRow(SQL* obj, char * name, char ** row, int rowSize) {
  
}

void sQLDeleteRow(SQL* obj, char * name, int rowId) {
  
}

char * sQLSelectCell(SQL* obj, char * name, int rowId, int columnId) {
  
}

void sQLFree(SQL* obj) {
    
}

/**
 * Your SQL struct will be instantiated and called as such:
 * SQL* obj = sQLCreate(names, namesSize, columns, columnsSize);
 * sQLInsertRow(obj, name, row, rowSize);
 
 * sQLDeleteRow(obj, name, rowId);
 
 * char * param_3 = sQLSelectCell(obj, name, rowId, columnId);
 
 * sQLFree(obj);
*/