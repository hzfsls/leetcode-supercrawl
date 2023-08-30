


typedef struct {

} HitCounter;


HitCounter* hitCounterCreate() {

}

void hitCounterHit(HitCounter* obj, int timestamp) {

}

int hitCounterGetHits(HitCounter* obj, int timestamp) {

}

void hitCounterFree(HitCounter* obj) {

}

/**
 * Your HitCounter struct will be instantiated and called as such:
 * HitCounter* obj = hitCounterCreate();
 * hitCounterHit(obj, timestamp);
 
 * int param_2 = hitCounterGetHits(obj, timestamp);
 
 * hitCounterFree(obj);
*/