


typedef struct {

} Leaderboard;


Leaderboard* leaderboardCreate() {

}

void leaderboardAddScore(Leaderboard* obj, int playerId, int score) {

}

int leaderboardTop(Leaderboard* obj, int K) {

}

void leaderboardReset(Leaderboard* obj, int playerId) {

}

void leaderboardFree(Leaderboard* obj) {

}

/**
 * Your Leaderboard struct will be instantiated and called as such:
 * Leaderboard* obj = leaderboardCreate();
 * leaderboardAddScore(obj, playerId, score);
 
 * int param_2 = leaderboardTop(obj, K);
 
 * leaderboardReset(obj, playerId);
 
 * leaderboardFree(obj);
*/