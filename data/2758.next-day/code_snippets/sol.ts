declare global {
    interface Date {
        nextDay(): string;
    }
}

Date.prototype.nextDay = function(){
 
}

/**
 * const date = new Date("2014-06-20");
 * date.nextDay(); // "2014-06-21"
 */