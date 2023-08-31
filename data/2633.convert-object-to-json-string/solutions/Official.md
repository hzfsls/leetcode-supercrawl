## [2633.将对象转换为 JSON 字符串 中文官方题解](https://leetcode.cn/problems/convert-object-to-json-string/solutions/100000/jiang-dui-xiang-zhuan-huan-wei-json-zi-f-7zcb)

## 概述

 问题要求我们将一个对象转换为有效的JSON字符串表示。我们得到的对象可能包含字符串、整数、数组、对象、布尔值和null值。我们需要将这个对象转换为JSON字符串，而不使用内置的`JSON.stringify`方法。生成的字符串应该有与`Object.keys()`返回的相同的键顺序，且不应该包含额外的空格。 

 有效的JSON字符串遵循以下一些规则: 

* 所有属性名（键）必须被双引号包围。 
*  字符串值必须被双引号包围。 
*  数字值可以不用引号写。 
*  布尔值和null值使用关键字`true`、`false`和`null`，不加引号表示。 
*  数组用方括号`[]`包围，并且数组内的值用逗号分隔。 
*  对象用花括号`{}`包围，对象内的键值对用逗号分隔。键和值之间用冒号`:`分隔。 

例如:  
```json
{
"name": "Phantom",
"age": 20,
"hobbies": ["chess", "sitting_idle""],
"address": {
    "street": "123 Main St",
    "city": "Mumbattan"
},
"active": true,
"score": null
} 
```

注意: JSON 格式不允许尾部有多余的逗号，所以在构造 JSON 字符串表示时，一定要移除任何不必要的逗号。

---

 ## 用例 

* **API 数据序列化：** 在构建和 API 交互的 web 应用时，需要把对象转换为 JSON 字符串，然后把它们作为数据通过 **HTTP** 请求发送。这样才能为数据进行正确的序列化，并以 API 所理解的格式进行传输。  
```js  
// 创建在 HTTP 请求中作为数据发送的对象
const data = { name: 'Racoon', age: 9, email: 'racoon@example.com' };

// 将对象转换为 JSON 字符串
const jsonData = JSON.stringify(data);
// jsonData: '{""name"":""Racoon"",""age"":9,""email"":""racoon@example.com""}'

// 发送一个以 JSON 数据作为请求体的 POST 请求
fetch('https://api.example.com/users', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: jsonData
})
  .then(response => response.json())
  .then(responseData => {
    // 处理从服务器接收到的响应数据
    console.log(responseData);
  })
  .catch(error => {
    // 处理请求期间发生的任何错误
    console.error(error);
  }); 
```
 * **本地存储：** 在 web 开发中，**localStorage** 或 **sessionStorage** 接口通常用于在浏览器本地存储数据。由于这些接口只接受字符串值，所以转换对象为 JSON 字符串是必要的，用于存储复杂的数据结构并在后续中使用它们。  
```js 
const user = { name: 'RocketRacoon', id: 8913, isAdmin: false };
const jsonUser = JSON.stringify(user);
localStorage.setItem('user', jsonUser);

// 从本地存储中检索用户并将其解析回对象
const storedUser = localStorage.getItem('user');
const parsedUser = JSON.parse(storedUser);
console.log(parsedUser.name); // Output: ""RocketRacoon""
```
 * **记录：** 在记录数据或生成日志文件时，转换对象为JSON字符串可提供一个规整且易读的格式用于存储日志。它使得日志数据的分析、搜索和处理变得容易。
```js 
const logData = { timestamp: new Date(), level: 'info', message: 'User logged in' };
const jsonLogData = JSON.stringify(logData);

// 将 jsonLogData 存储在日志文件中，或者将其发送到日志服务
// ...
```
 * **配置文件** JSON 通常用于各种应用程序中的配置文件。将对象转换为 JSON 字符串可以方便地存储和检索配置设置，从而支持应用程序行为的自定义和灵活性。
 ```js
const config = { apiUrl: 'https://api.example.com', maxRetries: 3, timeout: 5000 };
const jsonConfig = JSON.stringify(config);

// 将 jsonConfig 保存到配置文件中
// ...
 ```
---

## 方法 1：使用类 JSON 字符串的连接方法 

### 简述 

我们可以通过遍历对象的属性，根据其类型处理每个值，并将字符串连接起来，手动构建一个有效的 JSON 字符串表示。 

### 算法步骤

* 首先，我们需要检查输入对象是否为 `null`，是的话则返回字符串 `null`。这是因为在 JavaScript 中，`typeof null` 返回的是 `object`。 
* 接下来，我们通过 `Array.isArray()` 方法检查对象是否为数组。它接受一个参数，并在该参数为数组时返回 true。  
* 如果它是一个数组，对每一个元素迭代并递归地调用 `jsonStringify` 函数，以处理数组内部的嵌套对象或数组。  
*  每个元素的结果 JSON 字符串表示储存在元素数组中。  
* 最后，我们使用 `join()` 方法以逗号 `(',')` 把元素连接起来，并通过方括号 `('[]')` 来表示JSON中的数组。 
*  现在，如果对象不是数组而是一个带有键值对的对象，它将使用 `Object.keys()` 遍历对象的键。  
*  对于每一个键，我们递归调用 `jsonStringify` 函数对应值，并将结果的 JSON 字符串表示存储在 `keyValuePairs` 数组中。  
*  `keyValuePairs` 数组包含表示每个键值对的字符串。  
*  最后，键值对使用 `join()` 方法以逗号 `(',')` 连接起来，并用花括号包围以在 JSON 中表示对象。 
*  如果对象是字符串，我们将用双引号包围字符串值以在 JSON 中正确表示它。 
*  对于其他类型的值（数值，布尔值），它们被用 `String()` 函数转换为字符串。 
*  最后返回结果的 JSON 字符串表示。 

### 代码实现

```JavaScript [slu1]
/**
 * @param {any} object
 * @return {string}
 */
var jsonStringify = function(object) {
  if (object === null) {
    return 'null';
  }

  if (Array.isArray(object)) {
    const elements = object.map((element) => jsonStringify(element));
    return `[${elements.join(',')}]`;
  }

  if (typeof object === 'object') {
    const keys = Object.keys(object);
    const keyValuePairs = keys.map((key) => `""${key}"":${jsonStringify(object[key])}`);
    return `{${keyValuePairs.join(',')}}`;
  }

  if (typeof object === 'string') {
    return `""${object}""`;
  }

  return String(object);
};
```
```TypeScript [slu1]
function jsonStringify(object: any): string {
  if (object === null) {
    return 'null';
  }

  if (Array.isArray(object)) {
    const elements = object.map((element: any) => jsonStringify(element));
    return `[${elements.join(',')}]`;
  }

  if (typeof object === 'object') {
    const keys = Object.keys(object);
    const keyValuePairs = keys.map((key: string) => `""${key}"":${jsonStringify(object[key])}`);
    return `{${keyValuePairs.join(',')}}`;
  }

  if (typeof object === 'string') {
    return `""${object}""`;
  }

  return String(object);
}
```

 ### 复杂性分析: 

**时间复杂度:** 

- 在最坏的情况中，当对象有嵌套结构时，如嵌套对象或数组，时间复杂度为 `O(n)`，其中 `n` 表示对象中元素的总数。 
- 对于嵌套值会进行递归调用，但总的迭代次数仍与输入对象的大小成正比。 


**空间复杂度:** 

- 在最坏的情况下，空间复杂度也为 `O(n)`，其中n是对象中元素的总数。 
- 每一个递归层级为新数组（`elements` 和 `keyValuePairs`）创建了储存中间JSON字符串表示的空间。 
- 因此，随着递归深度和对象中元素数量的增长，需要的空间线性增长。 

---

 ## 方法 2：使用 Switch Case 

### 简述 

我们可以使用与早先说明的相同的思路，但我们使用 `switch case` 语句取代 `if-else` 语句。 

 ### 算法步骤  

* 我们在 `jsonStringify` 函数中使用 switch 语句来根据他们的 typeof 处理不同类型的值。 
* 对于'object'的情况，它使用 `Array.isArray(object)` 检查对象是否是数组。  
* 如果它是一个数组，它使用 `map()` 方法，对每个元素递归地调用 `jsonStringify`。  
* 然后用逗号连接生成的表示各元素的字符串数组，并用方括号包围以形成 JSON 数组表示。  
* 返回最终的字符串表示。  
* 如果它不是数组，而是一个非空对象，它使用 `Object.keys(object)` 获取对象的键。  
* 然后，它根据每个键进行映射，将键值对格式化为 `""""<key>"""": <value>""""`。  
* 用逗号连接键值对，并用花括号包围，以创建 JSON 对象表示。  
* 返回最终的字符串表示。  
* 如果对象为 `null`，则返回字符串 `""""null""""`。 
* 对于布尔值、数字和字符串的值类型，它们被直接转换成各自的字符串表示。 
* 对于任何其他的值类型，它返回一个空字符串。 

### 代码实现

 ```JavaScript [slu2]
/**
 * @param {any} object
 * @return {string}
 */
var jsonStringify = function(object) {
  switch (typeof object) {
    case 'object':
      if (Array.isArray(object)) {
        const elements = object.map((element) => jsonStringify(element));
        return `[${elements.join(',')}]`;
      } else if (object) {
        const keys = Object.keys(object);
        const keyValuePairs = keys.map((key) => `""${key}"":${jsonStringify(object[key])}`);
        return `{${keyValuePairs.join(',')}}`;
      } else {
        return 'null';
      }
    case 'boolean':
    case 'number':
      return `${object}`;
    case 'string':
      return `""${object}""`;
    default:
      return '';
  }
};
 ```

```TypeScript [slu2]

function jsonStringify(object) {
  switch (typeof object) {
    case 'object':
      if (Array.isArray(object)) {
        const elements = object.map((element) => jsonStringify(element));
        return `[${elements.join(',')}]`;
      } else if (object) {
        const keys = Object.keys(object);
        const keyValuePairs = keys.map((key) => `""${key}"":${jsonStringify(object[key])}`);
        return `{${keyValuePairs.join(',')}}`;
      } else {
        return 'null';
      }
    case 'boolean':
    case 'number':
      return `${object}`;
    case 'string':
      return `""${object}""`;
    default:
      return '';
  }
}
```

### 复杂性分析: 

 **时间复杂度：** 

* 在最坏的情况中，当对象有嵌套结构时，如嵌套对象或数组，时间复杂度为 `O(n)`，其中 `n` 表示对象中元素的总数。 
* 对于嵌套值，会进行递归调用，但总的迭代次数仍与输入对象的大小成正比。 

 **空间复杂度：** 

* 在最坏的情况下，空间复杂度也为 `O(n)`，其中 n 是对象中元素的总数。 
*  对于每层嵌套，都有新数组（`elements` 和 `keyValuePairs`）创建用于储存中间的 JSON 字符串表示。 
*  因此，所需的空间随着嵌套层数和对象元素数量的增长线性增长。 

---

## 方法 3：使用三元操作符 

### 简述

我们可以使用**三元操作符**来完成我们可以使用 **if-else** 和 **switch case** 语句完成的相同功能。 

### 算法步骤

* 如果 `object` 的类型为 `string`，那么它就是一个基本的字符串值。在这种情况下，我们使用双引号 `("""""""")` 包围字符串并返回它。 
* 如果 `object` 是 `null` 或者它的类型不是 `object`，那么它就是一个基本的值（数字、布尔等）或者是 `null`。在这两种情况下，我们都直接返回 `object`。 
*  如果 `object` 是数组，那么我们使用 `reduce()` 方法在数组中对每一个元素进行迭代，并对每一个元素递归调用 `jsonStringify()` 函数。  
*  累加器 `(acc)` 以一个空字符串 `('')` 开始。  
*  对于数组中的每一个元素 `(x)`，我们将累积的字符串 `(acc)` 和调用 `jsonStringify(x)` 的结果连起来，然后跟着一个逗号 `(,)`。  
*  使用 `slice(0, -1)` 方法从累积的字符串中移除末尾的逗号。  
*  结果的字符串用方括号 `([])` 包围起来，形成 JSON 数组表示。 
*  如果 `object` 是对象，那么我们使用 `reduce()` 方法和 `Object.entries()` 对对象的键值对进行迭代。  
*  累加器 `(acc)` 以一个空字符串 `('')` 开始。  
*  对于对象中的每一个键值对 `(x)`，我们把累积的字符串 `(acc)` 和递归调用 `jsonStringify(x[0])`（用于键）和 `jsonStringify(x[1])`（用于值）的结果连接起来，中间以冒号 `(:)` 分隔，然后跟着一个逗号 `(,)`。  
*  使用 `slice(0, -1)` 方法从累积的字符串中移除末尾的逗号。  
*  结果的字符串用花括号 `({})` 包围起来，形成 JSON 对象表示。 

### 代码实现

```TypeScript [slu2]
function jsonStringify(object) {
    return typeof object === 'string' ? '""' + object + '""' :
        object === null || typeof object !== 'object' ? object :
        Array.isArray(object) ? '[' + object.reduce((acc, x) => acc + jsonStringify(x) + ',', '').slice(0, -1) + ']' :
        '{' + Object.entries(object).reduce((acc, x) => acc + jsonStringify(x[0]) + ':' + jsonStringify(x[1]) + ',', '').slice(0, -1) + '}';
};
```

```JavaScript [slu2]
/**
 * @param {any} object
 * @return {string}
 */
var jsonStringify = function(object) {
    return typeof object === 'string' ? '""' + object + '""' :
        object === null || typeof object !== 'object' ? object :
        Array.isArray(object) ? '[' + object.reduce((acc, x) => acc + jsonStringify(x) + ',', '').slice(0, -1) + ']' :
        '{' + Object.entries(object).reduce((acc, x) => acc + jsonStringify(x[0]) + ':' + jsonStringify(x[1]) + ',', '').slice(0, -1) + '}';
};
```

 ### 复杂性分析： 

**时间复杂度：** 

- 在最坏的情况下，当对象有深度嵌套的结构时，时间复杂度可看作为 `O(n)`，其中 n 是对象的元素总数。  

**空间复杂度：** 

- 在最坏的情况下，如果对象有深度嵌套的结构，空间复杂度可看作为 `O(d)`，其中 d 是递归的最大深度。 

---

 ## 面试提示

* 你需要将一个对象转换为一个 JSON 字符串表示， `JSON.stringify()` 的目的是什么？  
* 将一个对象转换为一个 JSON 字符串表示允许你序列化对象，并通过网络或存储在一个文件中发送它。  
* JavaScript 中的 `JSON.stringify()` 方法的目的是它将 JavaScript 对象转换为一个 JSON 字符串表示。 
* 当将一个对象转换为一个 JSON 字符串表示时，需要考虑什么样的潜在挑战或边缘情况？  
*  正确处理字符串值中的特殊字符或转义序列以确保有效的 JSON 语法。  
*  处理不可序列化的值，如函数或未定义，并决定如何在 JSON 字符串中表示它们。因为当你把一个 JSON 字符串反序列化成一个对象时，如果你使用了不可 JSON 序列化的结构（如函数或未定义），它们在结果对象中将不会被保存。建议使用 JSON 可序列化的结构以确保精准的序列化和反序列化过程。  
*  保留数字值的精度，特别是处理大数或浮点值时。  
*  处理稀疏数组并决定是否将缺失元素表示为 null 或从 JSON 字符串中完全排除。   
*  当将一个对象转换为一个 JSON 字符串表示时，你如何处理循环引用或循环依赖？  
*  循环引用发生在对象结构中存在一个循环，导致在转换时发生无限递归。为了处理循环引用，你可以使用一个集合或图来跟踪访问过的对象，以确保在递归过程中不回访问一个对象。  
*  如果检测到一个循环引用，你可以处理它，通过用占位符值表示引用，或者从最终的 JSON 字符串中省略循环引用。