async function promiseAll<T>(functions: (() => Promise<T>)[]): Promise<T[]> {

};

/**
 * const promise = promiseAll([() => new Promise(res => res(42))])
 * promise.then(console.log); // [42]
 */