/**
 * @param {Function} callback
 * @param {Context} context
 */
Array.prototype.forEach = function(callback, context) {

}


/**
 *  const arr = [1,2,3];
 *  const callback = (val, i, arr) => arr[i] = val * 2;
 *  const context = {"context":true};
 *
 *  arr.forEach(callback, context)  
 *
 *  console.log(arr) // [2,4,6]
 */