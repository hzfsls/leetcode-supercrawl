declare global {
    interface String {
        replicate(times: number): string;
    }
}

String.prototype.replicate = function(times: number) {
    
}