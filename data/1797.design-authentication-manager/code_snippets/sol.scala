class AuthenticationManager(_timeToLive: Int) {

    def generate(tokenId: String, currentTime: Int) {
        
    }

    def renew(tokenId: String, currentTime: Int) {
        
    }

    def countUnexpiredTokens(currentTime: Int): Int = {
        
    }

}

/**
 * Your AuthenticationManager object will be instantiated and called as such:
 * var obj = new AuthenticationManager(timeToLive)
 * obj.generate(tokenId,currentTime)
 * obj.renew(tokenId,currentTime)
 * var param_3 = obj.countUnexpiredTokens(currentTime)
 */