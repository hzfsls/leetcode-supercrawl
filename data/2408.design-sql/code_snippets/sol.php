class SQL {
    /**
     * @param String[] $names
     * @param Integer[] $columns
     */
    function __construct($names, $columns) {

    }

    /**
     * @param String $name
     * @param String[] $row
     * @return NULL
     */
    function insertRow($name, $row) {

    }

    /**
     * @param String $name
     * @param Integer $rowId
     * @return NULL
     */
    function deleteRow($name, $rowId) {

    }

    /**
     * @param String $name
     * @param Integer $rowId
     * @param Integer $columnId
     * @return String
     */
    function selectCell($name, $rowId, $columnId) {

    }
}

/**
 * Your SQL object will be instantiated and called as such:
 * $obj = SQL($names, $columns);
 * $obj->insertRow($name, $row);
 * $obj->deleteRow($name, $rowId);
 * $ret_3 = $obj->selectCell($name, $rowId, $columnId);
 */