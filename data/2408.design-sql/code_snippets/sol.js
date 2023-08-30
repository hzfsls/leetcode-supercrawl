/**
 * @param {string[]} names
 * @param {number[]} columns
 */
var SQL = function(names, columns) {

};

/** 
 * @param {string} name 
 * @param {string[]} row
 * @return {void}
 */
SQL.prototype.insertRow = function(name, row) {

};

/** 
 * @param {string} name 
 * @param {number} rowId
 * @return {void}
 */
SQL.prototype.deleteRow = function(name, rowId) {

};

/** 
 * @param {string} name 
 * @param {number} rowId 
 * @param {number} columnId
 * @return {string}
 */
SQL.prototype.selectCell = function(name, rowId, columnId) {

};

/**
 * Your SQL object will be instantiated and called as such:
 * var obj = new SQL(names, columns)
 * obj.insertRow(name,row)
 * obj.deleteRow(name,rowId)
 * var param_3 = obj.selectCell(name,rowId,columnId)
 */