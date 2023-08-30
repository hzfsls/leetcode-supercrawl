type SQL struct {

}


func Constructor(names []string, columns []int) SQL {

}


func (this *SQL) InsertRow(name string, row []string)  {

}


func (this *SQL) DeleteRow(name string, rowId int)  {

}


func (this *SQL) SelectCell(name string, rowId int, columnId int) string {

}


/**
 * Your SQL object will be instantiated and called as such:
 * obj := Constructor(names, columns);
 * obj.InsertRow(name,row);
 * obj.DeleteRow(name,rowId);
 * param_3 := obj.SelectCell(name,rowId,columnId);
 */