type FileSystem struct {

}


func Constructor() FileSystem {

}


func (this *FileSystem) Ls(path string) []string {

}


func (this *FileSystem) Mkdir(path string)  {

}


func (this *FileSystem) AddContentToFile(filePath string, content string)  {

}


func (this *FileSystem) ReadContentFromFile(filePath string) string {

}


/**
 * Your FileSystem object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.Ls(path);
 * obj.Mkdir(path);
 * obj.AddContentToFile(filePath,content);
 * param_4 := obj.ReadContentFromFile(filePath);
 */