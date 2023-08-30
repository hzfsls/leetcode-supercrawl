struct Leaderboard {

}


/**
 * `&self` means the method takes an immutable reference.
 * If you need a mutable reference, change it to `&mut self` instead.
 */
impl Leaderboard {

    fn new() -> Self {

    }
    
    fn add_score(&self, player_id: i32, score: i32) {

    }
    
    fn top(&self, k: i32) -> i32 {

    }
    
    fn reset(&self, player_id: i32) {

    }
}

/**
 * Your Leaderboard object will be instantiated and called as such:
 * let obj = Leaderboard::new();
 * obj.add_score(playerId, score);
 * let ret_2: i32 = obj.top(K);
 * obj.reset(playerId);
 */