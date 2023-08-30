type Fn = (...args) => any

declare global {
    interface Function {
      bindPolyfill(obj: Record<any, any>): Fn;
    }
}

Function.prototype.bindPolyfill = function(obj) {
    
}