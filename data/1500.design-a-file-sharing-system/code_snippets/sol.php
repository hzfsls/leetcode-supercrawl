class FileSharing {
    /**
     * @param Integer $m
     */
    function __construct($m) {

    }

    /**
     * @param Integer[] $ownedChunks
     * @return Integer
     */
    function join($ownedChunks) {

    }

    /**
     * @param Integer $userID
     * @return NULL
     */
    function leave($userID) {

    }

    /**
     * @param Integer $userID
     * @param Integer $chunkID
     * @return Integer[]
     */
    function request($userID, $chunkID) {

    }
}

/**
 * Your FileSharing object will be instantiated and called as such:
 * $obj = FileSharing($m);
 * $ret_1 = $obj->join($ownedChunks);
 * $obj->leave($userID);
 * $ret_3 = $obj->request($userID, $chunkID);
 */