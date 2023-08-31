## [2676.节流 中文官方题解](https://leetcode.cn/problems/throttle/solutions/100000/jie-liu-by-leetcode-solution-cqvu)
[TOC]

 ## 解决方案 

---

 ### 概述

 这个问题要求你实现 ***限流*** 高阶函数。限流的一句话描述是它应尽可能频繁地调用提供的回调，但不应超过 `t` 毫秒的频率。这意味着它应在被调用的限流函数调用时立即用相同的参数调用提供的回调。然后， 在 `t` 毫秒后，我们应检查限流函数是否再次被调用。如果是，我们应用最后知道的参数调用提供的函数。如果没有，我们等待它再次被调用。

 给出限流在实际中的一个具体示例:

 ```js 
const start = Date.now();
function log(id) {
  console.log(id, Date.now() - start);
}

setTimeout(() => log(1), 10); // logs: 1, 10
setTimeout(() => log(2), 15); // logs: 2, 15
setTimeout(() => log(3), 20); // logs: 3, 20
setTimeout(() => log(4), 60); // logs: 4, 60
setTimeout(() => log(5), 70); // logs: 5, 70
 ```

 正如预期的，`log` 函数按照 `setTimeout` 指定的延迟被调用。
 然而，如果我们限流 `log` 函数:

 ```js 
const start = Date.now();
function log(id) {
  console.log(id, Date.now() - start);
}
const throttledLog = throttle(log, 20);

setTimeout(() => throttledLog(1), 10); // logs: 1, 10
setTimeout(() => throttledLog(2), 15); // cancelled
setTimeout(() => throttledLog(3), 20); // logs: 3, 30
setTimeout(() => throttledLog(4), 60); // logs: 4, 60
setTimeout(() => throttledLog(5), 70); // logs: 5, 80
 ```

 在上面的例子中，`log` 在 `t=10ms` 时立即被调用，因为那是第一次调用 `throttledLog` 的时候。在 `t=15ms` 的调用被 `t=20ms` 的调用取消。在 `t=20ms` 的调用被延迟到 `t=10+20=30ms` 。与第一次调用类似， `t=60ms` 时的调用立即被求值，因为之前没有近期的调用。并且在 `t=70ms` 时的调用也被延迟了 `10ms`。

 #### 限流的使用场景

 当你想尽快执行一个操作，但也想保证该操作的执行频率有一个限制时，可以使用限流。

 一个使用场景可能很简单，就像当用户点击一个按钮时下载数据。你不希望用户首次点击按钮时有任何延迟(为什么防抖不适合)。但是，如果你的用户决定开始连续点击按钮，你也不希望尝试下载几十份副本。对下载函数加上几秒钟的限流就可以优雅地达到期望的结果。

 以下是更直观地理解何时使用防抖和何时使用限流的一种简单方法:

 - 防抖防止不必要的事件产生延迟(例如，每输入一个字符都重新渲染大批量的搜索结果)。这是通过在用户完成交互后才执行代码来实现的。 
 -  限流阻止代码被调用的频率超过基础设施/应用程序可以处理的频率(例如用户试图连续点击下载)。这是通过保证一些代码被调用的频率有一个限制来实现的。对大多数网络请求应用限流通常无害，只要`t`相当小。

---

 #### 方法 1: 递归 setTimeout 调用

 解决这个问题的一个好方法是认为代码可以处于两种状态：***循环*** 和 ***等待***。如果代码处在 ***等待*** 状态，那么最近没有任何函数调用，应该在被调用的限流函数调用时立即调用提供的回调。一旦发生这种情况，代码进入 ***循环*** 状态。现在，代码应该用最后知道的参数每 `t` 毫秒执行一次提供的回调。一旦在一个完整的循环中没有调用限流函数，它就会回到 ***等待*** 状态。
 在下面的代码中，`timeoutInProgress` 的存在表示代码是否处在 ***循环*** 状态。如果代码处在 ***循环*** 状态，`argsToProcess` 只被设置为最近的`args`。如果代码处在 ***等待*** 状态，`fn` 立即被调用并创建一个递归循环。
 在这个递归循环中，它首先检查从最后一次循环执行以来是否有任何函数调用。如果没有，代码回到 ***等待*** 状态。否则，用最后知道的参数执行 `fn`，`argsToProcess` 被设置为 `null`，并用延迟递归调用 `timeoutFunction`。

 ```JavaScript [slu1]
var throttle = function(fn, t) {
  let timeoutInProgress = null;
  let argsToProcess = null;
  
  const timeoutFunction = () => {
    if (argsToProcess === null) {
      timeoutInProgress = null; // 进入等待阶段
    } else {
      fn(...argsToProcess);
      argsToProcess = null;
      timeoutInProgress = setTimeout(timeoutFunction, t);
    }
  };

  return function throttled(...args) {
    if (timeoutInProgress) {
      argsToProcess = args;
    } else {
      fn(...args); // 进入循环阶段
      timeoutInProgress = setTimeout(timeoutFunction, t);
    }
  }
};
 ```

```TypeScript [slu1]
type F = (...args: any[]) => void

function throttle(fn: F, t: number): F {
  let timeoutInProgress = null;
  let argsToProcess = null;
  
  const timeoutFunction = () => {
    if (argsToProcess === null) {
      timeoutInProgress = null; // 进入等待阶段
    } else {
      fn(...argsToProcess);
      argsToProcess = null;
      timeoutInProgress = setTimeout(timeoutFunction, t);
    }
  };

  return function throttled(...args) {
    if (timeoutInProgress) {
      argsToProcess = args;
    } else {
      fn(...args); // 进入循环阶段
      timeoutInProgress = setTimeout(timeoutFunction, t);
    }
  }
};
```

---

 #### 方法 2: setInterval + clearInterval

 方法 1 的逻辑很好地使用了 `setInterval` 代替 `setTimeout`。为了实现 ***循环*** 阶段，我们可以用一个间隔来替代递归调用。
 使用 `setInterval` 需要做以下改变。

 - ***循环*** 阶段是用 `setInterval` 而不是 `setTimeout` 来启动的。
 - 在间隔内不需要递归函数调用。`setInterval`负责这个。
 - 只设置`intervalInProgress`为`null`不能恢复到 ***等待*** 阶段。我们还必须通过调用 `clearInterval(intervalInProgress)` 来停止循环。否则，它将一直下去。

 ```JavaScript [slu2]
var throttle = function(fn, t) {
  let intervalInProgress = null;
  let argsToProcess = null;
  
  const intervalFunction = () => {
    if (argsToProcess === null) {
      clearInterval(intervalInProgress);
      intervalInProgress = null; // 进入等待阶段
    } else {
      fn(...argsToProcess);
      argsToProcess = null;
    }
  };

  return function throttled(...args) {
    if (intervalInProgress) {
      argsToProcess = args;
    } else {
      fn(...args); /// 进入循环阶段
      intervalInProgress = setInterval(intervalFunction, t);
    }
  }
};
 ```

```TypeScript [slu2]
type F = (...args: any[]) => void

function throttle(fn: F, t: number): F {
  let intervalInProgress = null;
  let argsToProcess = null;
  
  const intervalFunction = () => {
    if (argsToProcess === null) {
      clearInterval(intervalInProgress);
      intervalInProgress = null; // 进入循环阶段
    } else {
      fn(...argsToProcess);
      argsToProcess = null;
    }
  };

  return function throttled(...args) {
    if (intervalInProgress) {
      argsToProcess = args;
    } else {
      fn(...args); // 进入循环阶段
      intervalInProgress = setInterval(intervalFunction, t);
    }
  }
};
```

 #### 方法 3: 记录下次调用函数的时间

 我们可以记录一个变量 `nextTimeToCallFn` 代表我们应该下次调用 `fn` 的时间。

 每次调用被限流的函数，我们都应该创建一个新的超时，使得它在 `nextTimeToCallFn` 时被执行。为了达到这个结果，传递给 `setTimeout` 的延迟的公式简单地是 `nextTimeToCallFn - Date.now()`。注意，如果 `fn` 在一段时间内没有被调用，延迟会变成负数。在那种情况下，我们应该立即调用 `fn`(延迟是 0)。
 每次调用 `fn` 时，我们应该设置 `nextTimeToCallFn` 为 `Date.now() + t`。
 另外，在创建新的超时之前，我们需要清除现有的超时(如果存在)。这样，在任何给定的时间，最多只有一个超时在运行。

 ```JavaScript [slu3]
var throttle = function(fn, t) {
  let timeout = null;
  let nextTimeToCallFn = 0;
  return function(...args) {
    const delay = Math.max(0, nextTimeToCallFn - Date.now());
    clearTimeout(timeout);
    timeout = setTimeout(() => { 
      fn(...args);
      nextTimeToCallFn = Date.now() + t;
    }, delay);
  }
};
 ```

```TypeScript [slu3]
type F = (...args: any[]) => void

function throttle(fn: F, t: number): F {
  let timeout = null;
  let nextTimeToCallFn = 0;
  return function(...args) {
    const delay = Math.max(0, nextTimeToCallFn - Date.now());
    clearTimeout(timeout);
    timeout = setTimeout(() => { 
      fn(...args);
      nextTimeToCallFn = Date.now() + t;
    }, delay);
  }
};
```

---