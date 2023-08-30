/**
 * @param {Function} fn
 * @return {Function}
 */
var curry = function(fn) {
    
    return function curried(...args) {

    };
};

/**
 * function sum(a, b) { return a + b; }
 * const csum = curry(sum);
 * csum(1)(2) // 3
 */