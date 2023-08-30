type InputObj = Record<any, any> | Array<any>;

class ImmutableHelper {
    constructor(obj: InputObj) {
        
    }
    
    produce(mutator: (obj: InputObj) => void) {
        
    }
}

/**
 * const originalObj = {"x": 5};
 * const mutator = new ImmutableHelper(originalObj);
 * const newObj = mutator.produce((proxy) => {
 *   proxy.x = proxy.x + 1;
 * });
 * console.log(originalObj); // {"x: 5"}
 * console.log(newObj); // {"x": 6}
 */