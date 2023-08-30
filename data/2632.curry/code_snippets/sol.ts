function curry(fn: Function): Function {
    
    return function curried(...args) {

    };
};

/**
 * function sum(a, b) { return a + b; }
 * const csum = curry(sum);
 * csum(1)(2) // 3
 */