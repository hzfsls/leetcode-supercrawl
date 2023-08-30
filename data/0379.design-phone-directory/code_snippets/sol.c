


typedef struct {

} PhoneDirectory;


PhoneDirectory* phoneDirectoryCreate(int maxNumbers) {

}

int phoneDirectoryGet(PhoneDirectory* obj) {

}

bool phoneDirectoryCheck(PhoneDirectory* obj, int number) {

}

void phoneDirectoryRelease(PhoneDirectory* obj, int number) {

}

void phoneDirectoryFree(PhoneDirectory* obj) {

}

/**
 * Your PhoneDirectory struct will be instantiated and called as such:
 * PhoneDirectory* obj = phoneDirectoryCreate(maxNumbers);
 * int param_1 = phoneDirectoryGet(obj);
 
 * bool param_2 = phoneDirectoryCheck(obj, number);
 
 * phoneDirectoryRelease(obj, number);
 
 * phoneDirectoryFree(obj);
*/