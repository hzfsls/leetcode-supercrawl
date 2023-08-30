type F = (...args: any[]) => void

function throttle(fn: F, t: number): F {
  return function (...args) {

  }
};

/**
 * const throttled = throttle(console.log, 100);
 * throttled("log"); // logged immediately.
 * throttled("log"); // logged at t=100ms.
 */