## [2700.两个对象之间的差异 中文官方题解](https://leetcode.cn/problems/differences-between-two-objects/solutions/100000/liang-ge-dui-xiang-zhi-jian-de-chai-yi-b-kofx)

[TOC] 

 ## 解决方案  

---

 ### 概述 

 本题要求你找出两个深度嵌套对象之间的差异。输出也应该是一个深度嵌套的对象，其中每个叶节点是一个差异数组 `[val1, val2]`。这个寻差算法应该只包括差异，而不包括添加或删除键值。 

 举一个具体的期望的寻差算法的输出例子： 

 ```js
  const object1 = {  ""x"": 5,  ""y"": 6,  ""array"": [1, 2, 3, 4] } 
  const object2 = {  ""x"": 6,  ""z"": 7,  ""array"": [1,2, {}] } 
  const diff = objDiff(object1, object2); 
  console.log (diff); /* {  ""x"": [5, 6],  ""array"": {  ""2"": [3, {}]  } } */ 
 ```

 解决方案中需要注意的几点：

  - `""x""` 从 `5` 变为 `6`。
  - `""y""` 在解决方案中不存在，因为在 `object2` 中没有这个键。
  - `""z""`在解决方案中不存在，因为在`object1`中没有这个键。
  - `array[0]`和`array[1]`在解决方案中不存在，因为它们没有改变。
  - `array[2]`从`3`修改为`{}`。注意结果包含一个包含索引`""2""`的对象，而不是数组。这是为了有效地表示大型数组中的小差异。
  - `object2.array`中不存在第4个索引，因此它不是结果的一部分。 

 ### 对象间查找差异的用途 

 #### 可视化 

 假设你有一个代表应用程序所有或部分状态的大型对象，你正在尝试通过查看用户执行的不同操作影响状态的哪些部分来更好地理解代码。 

 相比手动探索用户操作前后的两个JSON文件，更好的方式是用算法准确显示改变的部分。 

 Redux 是一个基于行为影响大型、 不可变状态对象的核心原则的流行状态管理库。它流行的一个原因是它能清楚地显示给定操作影响了什么。[Redux DevTools](https://github.com/reduxjs/redux-devtools) 是一个用于可视化这个信息的流行工具，它提供了一个 JSON 差异工具作为核心功能。 

 #### 高效地存储文件的历史版本。 

 假设你想要在某个应用中实现持久的自动保存功能，这个应用在核心上修改了一个大型JavaScript对象。最简单的方式是每次用户执行操作时，将每个对象的副本保存在一个文件中。然后，当用户想要恢复到早期版本时，他们只需选择文件并加载它。然而，这是低效的。大量的数据只是从一个文件复制到另一个文件。一个更节省存储空间的解决方案是只存储文件之间的差异。这需要一些处理来通过应用更新来创建所需的文件，但是它会占用更小的存储空间。 

---

 #### 方法: 递归解决方案 

 首先我们需要考虑递归解决方案的 ***基本情况***。需要考虑以下几种情况。 
 1. 如果`obj1 === obj2`，没有差异。我们让没有差异用空对象`{}`表示。这样的表示方式为何方便将会在后面解释。从现在开始的所有代码都可以假设这两个值不是`===`。
 2. 如果二者之一的值为 `null`，返回`[obj1, obj2]`。这是一个重要的检查，因为`typeof null`是`""object""`。最简单的方式是立即排除这种边缘情况。
 3. 如果二者之一的`typeof`值不是`""object""`，返回`[obj1, obj2]`。注意，数组和对象都是`""object""`类型。
 4. 如果一个值是数组而另一个值是对象，返回 `[obj1, obj2]`。通过这样的代码`Array.isArray(obj1) !== Array.isArray(obj2)`检查这个条件。这个条件是必要的，因为这个问题将数组视为与对象不比较的。 

 解决了基本情况，我们可以做出假设我们有两个可比较的对象。 

 下一步是对 ***同时*** 存在于两个对象中的键值进行迭代。这最容易通过一个 `for...in` 循环和一个 if 语句来实现，检查键值是否也属于另一个对象。注意当在数组上应用 `for...in` 循环时，它会产生数组的索引。 

 对于这些键值，我们通过递归调用来计算两个子对象的差异。但关键是，我们只应该在差异不是 `{}` 的情况下将这个差异附加到结果对象上。基于问题的需求，我们想要排除 `{}`，因为这是不必要的信息。注意我们选择在基本情况中将相同的基元表示为 `{}`，因为这种表示方式与相同的对象/数组的输出匹配，使它们易于通过一个条件过滤出来。 
 比较一个对象是否为空的简单方法是 `Object.keys(obj).length === 0`。还要注意，差异数组的 `Object.keys()` 总是 `[""0"", ""1""]`。因为长度是 `2`，所以这些差异数组正确地不会被过滤掉。 

 ```JavaScript [slu1]
 function objDiff(obj1, obj2) {
    if (obj1 === obj2) return {};
    if (obj1 === null || obj2 === null) return [obj1, obj2];
    if (typeof obj1 !== 'object' || typeof obj2 !== 'object') return [obj1, obj2];
    if (Array.isArray(obj1) !== Array.isArray(obj2)) return [obj1, obj2];

    const returnObject = {};
    for (const key in obj1) {
        if (key in obj2) {
            const subDiff = objDiff(obj1[key], obj2[key]);
            if (Object.keys(subDiff).length > 0) {
                returnObject[key] = subDiff;
            }
        }
    }
    return returnObject;
}
 ```

 ```TypeScript [slu1]
 function objDiff(obj1: any, obj2: any): any {
    if (obj1 === obj2) return {};
    if (obj1 === null || obj2 === null) return [obj1, obj2];
    if (typeof obj1 !== 'object' || typeof obj2 !== 'object') return [obj1, obj2];
    if (Array.isArray(obj1) !== Array.isArray(obj2)) return [obj1, obj2];

    const returnObject = {};
    for (const key in obj1) {
        if (key in obj2) {
            const subDiff = objDiff(obj1[key], obj2[key]);
            if (Object.keys(subDiff).length > 0) {
                returnObject[key] = subDiff;
            }
        }
    }
    return returnObject;
}
 ```

 ### 复杂度分析

 **时间复杂度：** 

 * 给定`N`代表两个对象中的键值的总和，时间复杂度为`O(N)`。 
 * 每个键值遍历一次。

 **空间复杂度：** 

 * 额外的空间复杂度为`O(D)`，其中 `D`是最大递归深度。
 * 包含返回对象所占的空间，空间复杂度为`O(N + D)`。 

---