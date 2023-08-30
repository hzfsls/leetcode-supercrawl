type F = (...p: any[]) => any

function debounce(fn: F, t: number): F {
    return function(...args) {
        
    }
};

/**
 * const log = debounce(console.log, 100);
 * log('Hello'); // cancelled
 * log('Hello'); // cancelled
 * log('Hello'); // Logged at t=100ms
 */