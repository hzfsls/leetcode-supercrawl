typedef struct {
    int n;
} FooBar;

FooBar* fooBarCreate(int n) {
    FooBar* obj = (FooBar*) malloc(sizeof(FooBar));
    obj->n = n;
    return obj;
}

void foo(FooBar* obj) {
    
    for (int i = 0; i < obj->n; i++) {
        
        // printFoo() outputs "foo". Do not change or remove this line.
        printFoo();
    }
}

void bar(FooBar* obj) {
    
    for (int i = 0; i < obj->n; i++) {
        
        // printBar() outputs "bar". Do not change or remove this line.
        printBar();
    }
}

void fooBarFree(FooBar* obj) {
    
}