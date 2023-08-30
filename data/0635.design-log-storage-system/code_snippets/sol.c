


typedef struct {
    
} LogSystem;


LogSystem* logSystemCreate() {
    
}

void logSystemPut(LogSystem* obj, int id, char * timestamp) {
  
}

int* logSystemRetrieve(LogSystem* obj, char * start, char * end, char * granularity, int* retSize) {
  
}

void logSystemFree(LogSystem* obj) {
    
}

/**
 * Your LogSystem struct will be instantiated and called as such:
 * LogSystem* obj = logSystemCreate();
 * logSystemPut(obj, id, timestamp);
 
 * int* param_2 = logSystemRetrieve(obj, start, end, granularity, retSize);
 
 * logSystemFree(obj);
*/