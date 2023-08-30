[TOC] 

 ## 解决方案

---

 ### 概览 

 这个问题要求你编写一个函数，管理一个 promise 池，使得在给定时间内并行运行的代码量低于某个阈值。

 #### Promise 池的使用场景 

 假设你有一个长文件列表需要下载，而你只能一个接一个地下载它们。如果你同时请求所有文件（使用 `Promise.all`）的话，可能会发生几个不好的情况：

 1. 环境可能会因为检测到处理的请求太多而取消请求。
 2. 在重载情况下，数据库可能会变得无响应。
 3. 过多的网络流量会导致优先级更高的请求被延迟。
 4. 应用程序在尝试同时处理所有数据时可能变得无响应。

 一种替代的做法是一次处理一个文件： 

 ```js
 for (const filename of files) {  
    await download(filename); 
 } 
 ```

 然而，这种方法很慢，没有利用并行化。

 最优的方法是确定一个合理的并发请求的数量限制，并使用一个 ***promise 池***。使用这个问题中提出的实现，它会看起来像这样：

 ```js
 const files = [""data.json"", ""data2.json"", ""data3.json""]; 
 // 内嵌双箭头函数，因为我们希望创建函数 
 // 但是我们希望在稍后执行它们 
 const functions = files.map(filename => () => download(filename)); 

 const POOL_LIMIT = 2; 
 await promisePool(functions, POOL_LIMIT); 
 ```

 你可以在这里查看实现 promise 池的流行的 JavaScript 包 [这里](https://www.npmjs.com/package/@supercharge/promise-pool) 和 [这里](https://www.npmjs.com/package/es6-promise-pool)。 

 #### 方法 1：递归辅助函数 

 我们可以跟踪函数数组 (`functionIndex`) 中的当前索引和正在执行的 promise 的当前数量 (`inProgressCount`)。我们定义一个递归函数 `helper`，它让我们能够异步执行代码。所有这些代码都包含在返回的 promise 的回调中。

 1. 每次我们执行一个新的函数，我们都会增加 `functionIndex`，并且我们会增加 `inProgressCount`。
 2. 每次一个 promise 解决，我们都会减少 `inProgressCount`，并且在 `inProgressCount < n` 和还有剩余需要执行的函数时重复步骤 1
 3. 如果在任何时刻，`functionIndex == functions.length` 和 `inProgressCount == 0`，我们都可以完成并应该解决返回的 promise。 

 ```JavaScript [slu1]
 var promisePool = async function(functions, n) {
    return new Promise((resolve) => {
        let inProgressCount = 0;
        let functionIndex = 0;
        function helper() {
            if (functionIndex >= functions.length) {
                if (inProgressCount === 0) resolve();
                return;
            }

            while (inProgressCount < n && functionIndex < functions.length) {
                inProgressCount++;
                const promise = functions[functionIndex]();
                functionIndex++;
                promise.then(() => {
                    inProgressCount--;
                    helper();
                });
            }
        }
        helper();
    });
};
 ```

 ```TypeScript [slu1]
type F = () => Promise<any>;

async function promisePool(functions: F[], n: number): Promise<any> {
    return new Promise((resolve) => {
        let inProgressCount = 0;
        let functionIndex = 0;
        function helper() {
            if (functionIndex >= functions.length) {
                if (inProgressCount === 0) resolve(0);
                return;
            }

            while (inProgressCount < n && functionIndex < functions.length) {
                inProgressCount++;
                const promise = functions[functionIndex]();
                functionIndex++;
                promise.then(() => {
                    inProgressCount--;
                    helper();
                });
            }
        }
        helper();
    });
};
 ```

---

 #### 方法 2：异步/等待 + Promise.all() + Array.shift() 
 我们可以使用 async/await 语法大大简化方法 1 的代码。

 我们可以定义一个递归函数 `evaluateNext`，它：

 1. 如果没有要执行的函数，立即返回（基本情况）。
 2. 从函数列表中删除第一个函数（使用 `Array.shift`）。
 3. 执行同一个第一个函数，并等待它完成。
 4. 递归调用自己并等待自己完成。这样，只要有任何函数完成，队列中的下一个函数就会被处理。

 如果我们只执行这段代码一次，它是无法工作的（除非 `n = 1`），因为它会按序一个接一个地执行每个函数。我们需要最初并行执行 `evaluateNext` `n` 次来实现所需的 promise 池大小。我们可以用 `for` 循环来做这个，但那会使得我们难以知道所有 `n` 个 promise 何时都已解决。相反，我们使用 `await Promise.all` 来并行执行 `n` 个 promise 并等待它们完成。 

 再说明一点，你可能会想知道为什么我们在最初创建 promises 时不能简单地写 `Array(n).map(evaluateNext)`。这是因为 `Array(n)` 创建了一个包含 `empty` 值的数组，这个数组不能被映射过。`.fill()` 会添加可以被映射的 ""真实"" 的 `undefined` 值。 

 再另外说明一下，一般来说，在函数中改变参数并不是好的做法，因为函数的使用者可能不希望这样。在一个真实的实现中，你可能会希望最初就克隆数组，比如 `functions = [...functions];`。 

```JavaScript [slu2]
var promisePool = async function(functions, n) {
    async function evaluateNext() {
        if (functions.length === 0) return;
        const fn = functions.shift();
        await fn();
        await evaluateNext();
    }
    const nPromises = Array(n).fill().map(evaluateNext);
    await Promise.all(nPromises);
};
```

---

 #### 方法 3：2 行代码解决方案 
 我们可以修改方法二的一般想法，并用一些语法花样使它变得非常短。

 - 代替用 `Array.shift` 移除数组的第一个元素的做法，我们可以将变量 `n` 当作当前的索引使用。 
 - 代替用 `if` 语句检查是否还有函数要执行的做法，我们可以在函数调用时使用 ***可选链接*** (`functions[n++]?.()`)。这种语法会在 `functions[n++]` 是 `null` 或 `undefined` 时立即返回 `undefined`。没有这种语法，就会抛出一个错误。
 - 举例说明，我们可以使用 promise 链式调用 (`.then(evaluateNext)`)，而不是在不同的行中使用 `await`。 
 - 在最初并行执行前 `n` 个 promise 时，我们需要写 `functions.slice(0, n).map(f => f().then(evaluateNext))` 而不是简单地写 `functions.slice(0, n).map(evaluateNext)`。那样，第 `n` 个 promise 就会在辅助函数外部立即执行，这样我们就可以正确地使用 `n` 作为索引变量。 

 ```JavaScript [slu3]
 var promisePool = async function(functions, n) {
    const evaluateNext = () => functions[n++]?.().then(evaluateNext);
    return Promise.all(functions.slice(0, n).map(f => f().then(evaluateNext)));
};
 ```

 ```TypeScript [slu3]
 type F = () => Promise<any>;

async function promisePool(functions: F[], n: number): Promise<any> {
    const evaluateNext = () => functions[n++]?.().then(evaluateNext);
    return Promise.all(functions.slice(0, n).map(f => f().then(evaluateNext)));
};
 ```

---