class VideoSharingPlatform {
    /**
     */
    function __construct() {

    }

    /**
     * @param String $video
     * @return Integer
     */
    function upload($video) {

    }

    /**
     * @param Integer $videoId
     * @return NULL
     */
    function remove($videoId) {

    }

    /**
     * @param Integer $videoId
     * @param Integer $startMinute
     * @param Integer $endMinute
     * @return String
     */
    function watch($videoId, $startMinute, $endMinute) {

    }

    /**
     * @param Integer $videoId
     * @return NULL
     */
    function like($videoId) {

    }

    /**
     * @param Integer $videoId
     * @return NULL
     */
    function dislike($videoId) {

    }

    /**
     * @param Integer $videoId
     * @return Integer[]
     */
    function getLikesAndDislikes($videoId) {

    }

    /**
     * @param Integer $videoId
     * @return Integer
     */
    function getViews($videoId) {

    }
}

/**
 * Your VideoSharingPlatform object will be instantiated and called as such:
 * $obj = VideoSharingPlatform();
 * $ret_1 = $obj->upload($video);
 * $obj->remove($videoId);
 * $ret_3 = $obj->watch($videoId, $startMinute, $endMinute);
 * $obj->like($videoId);
 * $obj->dislike($videoId);
 * $ret_6 = $obj->getLikesAndDislikes($videoId);
 * $ret_7 = $obj->getViews($videoId);
 */