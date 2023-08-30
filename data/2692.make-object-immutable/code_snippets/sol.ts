type Obj = Array<any> | Record<any, any>;

function makeImmutable(obj: Obj): Obj {

};

/**
 * const obj = makeImmutable({x: 5});
 * obj.x = 6; // throws "Error Modifying x"
 */