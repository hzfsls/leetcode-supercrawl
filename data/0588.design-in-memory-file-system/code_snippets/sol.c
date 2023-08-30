


typedef struct {
    
} FileSystem;


FileSystem* fileSystemCreate() {
    
}

char ** fileSystemLs(FileSystem* obj, char * path, int* retSize) {
  
}

void fileSystemMkdir(FileSystem* obj, char * path) {
  
}

void fileSystemAddContentToFile(FileSystem* obj, char * filePath, char * content) {
  
}

char * fileSystemReadContentFromFile(FileSystem* obj, char * filePath) {
  
}

void fileSystemFree(FileSystem* obj) {
    
}

/**
 * Your FileSystem struct will be instantiated and called as such:
 * FileSystem* obj = fileSystemCreate();
 * char ** param_1 = fileSystemLs(obj, path, retSize);
 
 * fileSystemMkdir(obj, path);
 
 * fileSystemAddContentToFile(obj, filePath, content);
 
 * char * param_4 = fileSystemReadContentFromFile(obj, filePath);
 
 * fileSystemFree(obj);
*/