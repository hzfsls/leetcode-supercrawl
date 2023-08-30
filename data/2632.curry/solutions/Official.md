[TOC]

## 解决方案

---

 ### 概述

 Currying(柯里化)是一种强大的函数式编程技术，将接受多个参数的函数转换为一系列函数。它允许你通过允许函数参数的部分应用来创建灵活和可复用的代码。在这篇文章中，我们将讨论柯里化在 JavaScript 中的概念和实现。

 示例：
 比如我们有一个函数 sum，它接受三个参数并返回它们的总和：

 ```JavaScript [solution]
 function sum(a, b, c) {
  return a + b + c;
}
 ```

 ```TypeScript [solution]
 function sum(a: number, b: number, c: number): number {
  return a + b + c;
}
 ```

 我们可以创建这个函数的柯里化版本，curriedSum。现在，我们可以用各种方式调用 curriedSum，所有这些方式都应该返回与原始 sum 函数相同的结果：

```JavaScript [solution]
const curriedSum = curry(sum);

console.log(curriedSum(1)(2)(3)); // 输出: 6
console.log(curriedSum(1, 2)(3)); // 输出: 6
console.log(curriedSum(1)(2, 3)); // 输出: 6
console.log(curriedSum(1, 2, 3)); // 输出: 6
console.log(curriedSum()()(1, 2, 3)); // 输出: 6
```

```TypeScript [solution]
const curriedSum = curry(sum);

console.log(curriedSum(1)(2)(3)); // 输出: 6
console.log(curriedSum(1, 2)(3)); // 输出: 6
console.log(curriedSum(1)(2, 3)); // 输出: 6
console.log(curriedSum(1, 2, 3)); // 输出: 6
console.log(curriedSum()()(1, 2, 3)); // 输出: 6
```

 在 JavaScript 中使用柯里化有几个实际的应用，可以帮助提高代码的可读性、可维护性和可复用性。以下是柯里化的一些实际用途：

 1. 可复用的实用函数：柯里化可以帮助创建可复用的实用函数，这些函数可以很容易的定制化去适应特定的用途。柯里化允许你创建一个返回具有部分应用参数的另一个函数的函数。在这种情况下，我们有一个接受两个参数a和b的柯里化加法函数。当你用一个参数调用加法函数时，它返回一个新的函数，这个新函数接受第二个参数b，并将其与最初提供的a相加。

下面是更详细的说明示例：

 ```JavaScript [solution]
 const add = a => b => a + b;

// 通过值 5 调用柯里化的 'add' 函数，新建一个函数 'add5'。
// 返回的函数将接受单个参数 'b' 并将其加到 5。
const add5 = add(5);

// 现在，当我们用一个值(例如，3)调用 'add5' 时，它会在输入值上加 5，结果是 8。
const result = add5(3); // 8

 ```

 ```TypeScript [solution]
 const add = (a: number) => (b: number): number => a + b;

// 通过值 5 调用柯里化的 'add' 函数，新建一个函数 'add5'。
// 返回的函数将接受单个参数 'b' 并将其加到 5。
const add5 = add(5);

// 现在，当我们用一个值(例如，3)调用 'add5' 时，它会在输入值上加 5，结果是 8。
const result: number = add5(3); // 8
 ```

 2. 事件处理：在事件驱动编程中，柯里化可以用来创建具有特定配置的事件处理器，同时让核心事件处理函数保持通用。

 ```JavaScript [solution]
 const handleClick = buttonId => event => {
   console.log(`Button ${buttonId} clicked`, event);
};

const button1Handler = handleClick(1);
document.getElementById(""button1"").addEventListener(""click"", button1Handler);
 ```

 ```TypeScript [solution]
 type EventHandler = (event: Event) => void;

const handleClick = (buttonId: number): EventHandler => (event: Event) => {
   console.log(`Button ${buttonId} clicked`, event);
};

const button1Handler: EventHandler = handleClick(1);
document.getElementById(""button1"")?.addEventListener(""click"", button1Handler);
 ```

 3. 定制 API 调用：柯里化可以帮助基于通用 API 调用函数创建更具体的 API 调用。

```JavaScript [solution]
  const apiCall = baseUrl => endpoint => params =>
        fetch(`${baseUrl}${endpoint}`, { ...params });

const myApiCall = apiCall(""https://my-api.com"");
const getUser = myApiCall(""/users"");
const updateUser = myApiCall(""/users/update"");

// 用法:
getUser({ userId: 1 });
updateUser({ userId: 1, name: ""John Doe"" });

```

```TypeScript [solution]
  type ApiCall = (endpoint: string) => (params: any) => Promise<Response>;

const apiCall = (baseUrl: string): ApiCall => (endpoint: string) => (params: any) =>
        fetch(`${baseUrl}${endpoint}`, { ...params });

const myApiCall: ApiCall = apiCall(""https://my-api.com"");
const getUser = myApiCall(""/users"");
const updateUser = myApiCall(""/users/update"");

// 用法:
getUser({ userId: 1 });
updateUser({ userId: 1, name: ""John Doe"" });
```

 4. 高阶函数和函数组合：柯里化可以创建高阶函数，这些函数可以组合成更复杂的功能。

 ```JavaScript [solution]
 const compose = (f, g) => x => f(g(x));

const double = x => x * 2;
const square = x => x * x;

const doubleThenSquare = compose(square, double);

const result = doubleThenSquare(5); // (5 * 2)^2 = 100

 ```

 ```TypeScript [solution]
 type ComposeFn = <T>(f: (x: T) => T, g: (x: T) => T) => (x: T) => T;

const compose: ComposeFn = (f, g) => x => f(g(x));

const double = (x: number): number => x * 2;
const square = (x: number): number => x * x;

const doubleThenSquare = compose(square, double);

const result: number = doubleThenSquare(5); // (5 * 2)^2 = 100
 ```

柯里化是函数式编程中的一个有价值的概念，允许你编写更灵活和可重用的代码。掌握柯里化将帮助你为许多编程问题创建更清晰、更有效的解决方案

---

### 方法 1：使用递归函数调用的柯里化

#### 概述 

 问题要求我们将给定的函数转换为柯里化版本。一个柯里化函数是一个接受参数少于或等于原函数的函数，返回另一个柯里化函数或者原函数应该返回的相同值

 这可以通过一种递归方法来实现，每次都返回一个新的函数，当与原函数相比调用它的参数少于原函数时。这将持续，直到已经收集了足够数量的参数。此时，可以调用原始函数。

#### 算法步骤

1. `curry` 函数以一个函数(`fn`)为其参数，这个函数最终会接受柯里化的参数被执行。 
2. 它返回一个新的函数(`curried`),此函数负责积累传递给它的参数，直到达到所需的参数数量。此函数充当闭包，在每个步骤中记住积累的参数。
3. `curried` 使用剩余参数语法 `(...args)` 来定义，以接受变量数量的参数，在每个步骤中都允许部分应用。
4. 在 `curried` 内部，执行一个检查，以查看累积的参数是否足够。如果传递的参数数量(`args.length`)大于或等于原函数的长度(`fn.length`)，那么所有所需的参数都已经提供了。这是我们的基础情况。
5. 如果足够参数检查通过，那么用""扩展""语法(`...args`) 调用 `fn` 去通过传递所有收集好的参数，并返回结果。
6. 如果传递的参数数量不够，那么返回一个匿名函数，该匿名函数也使用 `...nextArgs` 的""剩余""参数语法。这允许继续积累参数。
7. 当匿名函数被调用时，它再次调用 `curried`，这次使用来自 `args` 和 `nextArgs` 的累积参数。这确保了参数的正确顺序和一起的合并。
8. 积累参数和调用 `curried` 的过程会在必要的参数数量满足后继续。这允许在任意组合的调用中应用参数的灵活性。
9. 一旦必要的参数数量满足，原始函数(`fn`)会调用所有积累的参数，提供与直接调用这些参数的原始函数相同的结果

#### 实现

 ```JavaScript [slu1]
 var curry = function(fn) {
   return function curried(...args) {
      if(args.length >= fn.length) {
         return fn(...args);
      }

      return (...nextArgs) => curried(...args, ...nextArgs);
   };
};
 ```

 ```TypeScript [slu1]
 function curry(fn: Function): Function {
   return function curried(...args: any[]): any {
      if (args.length >= fn.length) {
         return fn(...args);
      }

      return (...nextArgs: any[]): any => curried(...args, ...nextArgs);
   }
};
 ```

 #### 复杂度分析

 设 N 是原始函数中参数的数量。
 时间复杂度：O(N)。该算法创建了一串与参数数量呈比例的函数链。
 空间复杂度：O(N)。该算法使用内存存储中间函数和参数，这些内存用量会随着原始函数中参数数量的增加而增加。

---

 ### 方法 2：使用内建的 `bind` 方法的柯里化

 #### 概述

 总体的思路与方法 1 相同。虽然测试用例并不需要，但在这种方法中，我们还要处理在生产就绪解决方案的编写中需要注意的 'this' 上下文的情况。使用 bind 方法可以使代码非常简洁，因为它将一些复杂度抽象化了。
 bind 方法在这种场景中特别有用，因为它创建一个与被柯里化函数具有相同函数体，并指定了 'this' 上下文的新函数。在我们的柯里化实现中，我们使用 bind 创建一个具有积累参数和与原始被柯里化函数相同的 'this' 上下文的新函数。这允许我们在保持 'this' 上下文在多次调用中不变的同时跟踪收集的参数。bind 方法使代码简洁易读，因为它实质上抽象了编写全新函数的需要。
 简单来说，bind 方法创建了一个新函数，我们返回这个新函数。在这个情况下，它创建了一个几近于 `(...nextArgs) => curried(...args, ...nextArgs)` 的函数，但是它的 'this' 上下文是确定的。需要注意的是，由 bind 创建的函数也接受传入参数，这一点我们通过在方法 1 中的 '...nextArgs' 部分实现。

#### 算法步骤

1. curry 函数将一个函数(fn)作为它的参数。这就是最终会被执行的那个对柯里化参数操作的函数。 
2. 它返回一个新的函数(curried)，这个新函数负责聚集到达它的参数，直到参数数量达到所需为止。这个函数作用类似一个闭包，在每个步骤中记住那些被积累的参数。
3. curried 是通过 '...' 参数语法 (...argus) 进行定义的，这样来接收可变数目的参数，在每个步骤中都允许部分应用。
4. 在 curried 的内部进行一个检查，查看积累的参数是否足够。如果传递的参数数目 (args.length) 大于或等于原始函数的元数 (fn. length) ，那么所有所需的参数都已被提供。这就是我们的基本情况。
5. 如果满足足够参数的检查要求，那么就用 apply 方法去调用 fn， 以正确的 this 上下文和所有被收集的参数来传递，然后返回结果。值得注意的是，与此上下文有关的场景并未真正被自动化的裁判进行测试。
6. 如果传递的参数数目不足，那么就返回由 bind 方法所创建的新函数。这样做允许对参数的进一步累积同时也保留 this 上下文。bind 方法创建了一个新函数，这个新函数类似于在 方法1中我们返回的那个函数，它的功能基本上等同于 `(...nextArgs) => curried.apply(this, ...args)`。
7. 积累参数和调用 curried 的过程会持续，直到所需参数的数量被满足。这样做嘛，就实现了在任意组合的调用中灵活应用参数。
8. 一旦所需参数数目满足，那么原始函数(fn)就可以被调用，同时所有被积累的参数也一并被调用，然后提供与那些像直接调用那些参数的底层函数一样的结果

#### 实现

 ```JavaScript [slu2]
 var curry = function (fn) {
  return function curried(...args) {
    if (args.length >= fn.length) {
      return fn.apply(this, args);
    }

    return curried.bind(this, ...args);
  };
};
 ```

 ```TypeScript [slu2]
 function curry(fn: Function): Function {
    return function curried(...args: any[]): any {
        if (args.length >= fn.length) {
            return fn.apply(this, args);
        }

        return curried.bind(this, ...args);
    };
}
 ```

 #### 复杂度分析

 设 N 是原始函数中的参数数目。
 时间复杂度： O(N) 。该算法创建了一串函数的链条，它们的深度与参数数目相成比例。
 空间复杂度： O(N) 。该算法使用内存来储存中间函数和参数，内存使用量随着原始函数中参数数目的增加而增加。

### 其他考量

#### 部分应用 vs 柯里化 

部分应用和柯里化是函数式编程中紧密相关的概念，但它们服务于不同的目的。事实上，可以把柯里化被认为部分应用的一种类型。

 部分应用：
 部分应用指的是解决函数的一些参数，生成一个新函数，这个新函数的剩余参数数目较少。它允许你从已有的函数中创建新的函数，通过预设定一些参数。这可能会让代码更模块化和可复用。
 例如，假设我们有一个接受三个参数的函数： 

 ```JavaScript 
 function sum(a, b, c) {  return a + b + c; }
 ```

 我们可以创建一个部分应用的函数，固定第一个参数为1: 

 ```JavaScript 
 function partialSum(b, c) {  return sum(1, b, c); }
 ```

 现在，当我们调用 partialSum 时，我们只需要提供剩余两个参数： 

 ```JavaScript 
 console.log(partialSum(2, 3)); // 输出: 6
 ```

 部分应用处理固定一定数量的参数，从而创建具有较少剩余参数的新函数。 这使其对于创建更通用函数的专门版本非常有用。
 另一方面，柯里化则会将一个函数分解为一系列函数，每个函数只接受一个参数（或可能更多）。这允许你一次传递一个参数，并根据中间结果创建新的函数。
 虽然这两种技术都可以有助于使代码更模块化和可重用，它们的特定用例和实现方法是不同的。柯里化更着重于创建一个函数链，而部分应用则是关于固定参数以创建更专门的函数。

#### curry 的不同实现 

值得注意的是，curry 高阶函数有许多不同的实现方式，其行为可能有很大的差异  

 本问题介绍了 curry 的最常见的行为之一。另一个常见的行为是一个不接受预先定义的参数数量的 curry 函数（函数没有预先定义的长度，例如 const getSum = (...args) => args.reduce((a, b) => a + b, 0); 当用户不传入参数时调用。我们可以轻松修改上面的一种方法来实现这一点:

 ```JavaScript
 var curry = function (fn) {
  return function curried(...args) {
    if (args.length === 0) {
      return fn(...args);
    }

    return (...nextArgs) => {
      if (nextArgs.length === 0) {
        return fn(...args);
      }

      return curried(...args, ...nextArgs);
    };
  };
};
 ```

 ```TypeScript
 function curry(fn: Function): Function {
    return function curried(...args: any[]): any {
        if (args.length === 0) {
            return fn(...args);
        }

        return (...nextArgs: any[]): any => {
            if (nextArgs.length === 0) {
                return fn(...args);
            }

            return curried(...args, ...nextArgs);
        };
    };
}
 ```

 与面试官明确我们被要求实现的版本总是很重要的。