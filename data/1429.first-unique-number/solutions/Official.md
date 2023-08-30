[TOC]
 ## 解决方法

---
 #### 方法 1：暴力法
 **简述**  
对于该问题，最简单的解决方法是创建队列，然后搜索其中第一个唯一的数。
 我们通过遍历队列的元素（从最旧的开始）。对于每一个元素，我们再次遍历队列，计算它出现的次数。如果它只出现一次，我们会停下并返回它。如果没有出现一次的项目，那么我们返回 `-1`。
 **算法**
 我们不必实现计数方法；可以使用 Java 的 `Collections.frequency(...)`，在 Python 中用 `.count(...)`。

```Java [slu1]
class FirstUnique {

  private Queue<Integer> queue = new ArrayDeque<>();
  
  public FirstUnique(int[] nums) {
    for (int num : nums) {
      queue.add(num);
    }
  }
    
  public int showFirstUnique() {
    for (int num : queue) {
      int count = Collections.frequency(queue, num);
      if (count == 1) {
        return num;
      }
    }
    return -1;
  }
    
  public void add(int value) {
    queue.add(value);    
```

```Python3 [slu1]
from collections import deque

class FirstUnique:
    def __init__(self, nums: List[int]):
        self._queue = deque(nums)

    def showFirstUnique(self):
        for item in self._queue:
            if self._queue.count(item) == 1:
                return item
        return -1

    def add(self, value):
        self._queue.append(value)
```



 **复杂度分析**
 令 $K$ 为传递到构造函数的初始数组的长度。 令 $N$ 为目前添加到队列中的总元素数量（包括通过构造添加的元素）。

 - 时间复杂度：
    - **构造**：$O(K)$。
    我们创建传入的数字的一份新副本；创建花费为 $O(K)$ 时间。
    - **add()**：$O(1)$。
    我们对队列进行一次追加操作；该操作花费为 $O(1)$。
    - **showFirstUnique()**：$O(N^2)$。
    计算给定元素在队列中出现的次数花费为 $O(N)$。这对于我们使用的库函数也是真的。
    在最糟糕的情况下，我们在找到唯一的数字之前需要搜索整个队列。每次花费 $O(N)$，这给我们一个 $O(N^2)$ 的花费。
    
 - 空间复杂度：$O(N)$。
    - 使用的内存仅为在队列中的项目的总数。
     
     

---
 #### 方法 2：使用队列和哈希表
 **简述**
 当面对一个像这样的*数据结构设计*问题时，一个好的策略是从简单开始，然后找出哪里效率低。
 在方案 1 中，我们执行了大量的计数操作；每次调用 `showFirstUnique()` 时，最糟糕的情况下，需要进行 $N$ 次计数操作。每次计数的成本为 $O(N)$，这是昂贵的！这些计数也是重复的，因此应该是我们优化的重点。
 在决定是否返回一个特定数字时，我们只需要知道那个数字是否*唯一*。换句话说，我们只想知道它是 "一次" 还是 "多次" 出现。由于无法从 `FirstUnique` 数据结构中*删除*数字，我们知道一旦一个特定数字被添加第二次，那个数字将*永远不再是唯一的*。
 因此，为了计算出一个数字在队列中出现的次数，我们可以保持一个数字到布尔值的 `HashMap`，对于已添加的每一个数字，我们在这里存储*这个数字是否唯一*这个问题的答案。我们称其为 `isUnique`。然后，当 `FirstUnique.add(number)` 被调用时，有以下三种情况：
    1. 这个特定数字之前从未见过。在 `isUnique` 中添加它，其值为 `true`。同时，将其添加到队列中。
        2. 这个特定数字已经被 `isUnique` 看到过，其值为 `true`。这意味着该数字在之前是唯一的(目前在队列中)，但新添加后它不再是。将其值更新为 `false`。不将其添加到队列中。
        3. 这个特定数字已经被 `isUnique` 看到过，其值为 `false`。这意味着它已经被看到两次了。我们不需要做任何事情，也不应该把它加入队列。
             然后，`showFirstUnique()` 只需在 `isUnique` 中查找所需的信息，而无需进行 "计数" 操作。
              以下动画展示了到目前为止的工作流程。

 <![image.png](https://pic.leetcode.cn/1692157548-tUSQkp-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157559-wTfqRL-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157562-zoFXav-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157564-OWeVTs-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157568-zYaANW-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157571-SXxqBy-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157573-xqUJVZ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157576-UWvkCg-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157578-GYXAaf-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157581-YirSRF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157583-uKYkGa-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157588-dpSyLS-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157585-wykViI-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157592-nKfMKX-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157594-kmHLCq-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157597-raQHTG-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157600-JUEcGf-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157603-clbxyB-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157606-wWzlEw-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157609-yCZHDW-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157612-xEKCqe-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157615-eQXJQw-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157618-hhgoul-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157622-oxktbk-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692157625-EtaNjb-image.png){:width=400}>

 这是一个良好的开始。然而，你可能在观察动画时注意到另一个效率不高的地方： 每次调用 `showFirstUnique()` 时都需要跳过队首的 `7`。但是，一旦添加了第二个 `7`，这个 `7` 就不再是唯一的，所以它将再也不会是对 `showFirstUnique()` 的一次调用的答案了（记住，这个队列没有删除操作）。因此，没有理由留它在队列中。

---
 - 我们不需要再次考虑这个元素，所以我们应该移除它。
 但是，我们应该在哪里实际进行队列中的这些移除操作呢？在 `showFirstUnique()` 中，还是在 `add()` 中？
 - 如果在 `add()` 方法中进行移除操作，我们需要进行 $O(N)$ 的队列搜索来找到数字，然后*可能*需要在队列中移除它，(如果你的编程语言支持队列中的删除操作！)。
 - 如果在 `showFirstUnique()` 方法中进行删除，在找到一个唯一的数字并返回之前，我们可能需要进行大量的删除。然而，它将会在所有对数据结构的调用中更快，因为我们不需要找到不唯一的数字，就像在 `add()` 中一样。我们将在时间复杂度部分进一步讨论这个问题。

因此，我们的最佳选择是在 `showFirstUnique()` 方法中进行删除。
 尽管如此，我们仍应该把数字的值保持为 `false` 在 `isUnique` 中。如前所述，一个数字永远不会 "成为" 唯一的。
 以下是展示完整算法的动画。

 <![image.png](https://pic.leetcode.cn/1692158449-KwAATi-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158452-OXWxMa-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158454-noBlWJ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158456-uRLKnE-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158458-cbRLqZ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158461-FfHEnd-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158463-JLShYG-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158465-AlArhG-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158467-ATJEDd-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158470-etYrHf-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158474-pgjASk-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158477-TCAlNo-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158479-zhbEwe-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158481-rTTiRB-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158484-DSHVtn-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158486-GNyvWI-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158490-zXOeMN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158493-zJuaju-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692158496-FVsdLH-image.png){:width=400}>



 **算法**

 ```Java [solution]
class FirstUnique {

  private Queue<Integer> queue = new ArrayDeque<>();
  private Map<Integer, Boolean> isUnique = new HashMap<>();

  public FirstUnique(int[] nums) {
    for (int num : nums) {
      // 注意，我们调用了 FirstUnique 的 add 方法; 而不是 queue。
      this.add(num);
    }
  }

  public int showFirstUnique() {
    // 我们需要在开始时 “清理” 队列中的所有非唯一的队列。
    // 注意，如果一个值在队列中，那么它也在 isUnique 中，因为 add() 的实现保证了这一点。
    while (!queue.isEmpty() && !isUnique.get(queue.peek())) {
      queue.remove();
    }
    // 检查队列中是否还有剩余值。可能没有什么独特之处。
    if (!queue.isEmpty()) {
      return queue.peek(); // 我们并不真正地 “移除” 这个值。
    }
    return -1;
  }

  public void add(int value) {
    // 情况 1:我们需要将数字添加到队列中，并将其标记为唯一。
    if (!isUnique.containsKey(value)) {
      isUnique.put(value, true);
      queue.add(value);
    // 情况 2 和 3:我们需要将数字标记为不再唯一。
    } else {
      isUnique.put(value, false);
    }
  }
}
 ```
```Python3 [solution]
from collections import deque

class FirstUnique:

    def __init__(self, nums: List[int]):
        self._queue = deque(nums)
        self._is_unique = {}
        for num in nums:
            # 注意，我们调用了 FirstUnique 的 add 方法; 而不是 queue。
            self.add(num)
        
    def showFirstUnique(self) -> int:
        # 我们需要在开始时 “清理” 队列中的所有非唯一的队列。
        # 注意，如果一个值在队列中，那么它也在 isUnique 中，因为 add() 的实现保证了这一点。
        while self._queue and not self._is_unique[self._queue[0]]:
            self._queue.popleft()
        # 检查队列中是否还有剩余值。可能没有什么独特之处。
        if self._queue:
            return self._queue[0] # We don't want to actually *remove* the value.
        return -1
        
    def add(self, value: int) -> None:
        # 情况 1:我们需要将数字添加到队列中，并将其标记为唯一。
        if value not in self._is_unique:
            self._is_unique[value] = True
            self._queue.append(value)
        # 情况 2 和 3:我们需要将数字标记为不再唯一。
        else:
            self._is_unique[value] = False
```


 **复杂度分析**
 令 $K$ 为传递到构造函数的初始数组的长度。
 令 $N$ 为目前添加到队列中的总项目数量（包括通过构造器添加的项目）。
 - 时间复杂度：
    - **构造器**：$O(K)$。
    对于每一个传给构造函数的 $K$ 个数字，我们都调用`add()`。如下文所确定，每次调用`add()`的成本为 $O(1)$。因此，对于构造器中添加的 $K$ 个数字，总成本为 $K \cdot O(1) = O(K)$.
    - **add()**：$O(1)$。
    我们对队列进行一次追加操作；该操作花费为$O(1)$。
    - **showFirstUnique()**：$O(1)$（分摊）。
    对于本实现，`showFirstUnique()`方法需要遍历队列，直到找到一个唯一的数字。对于每个遇到的唯一数字，它将其移除。从队列中移除项目的成本为 $O(1)$。 我们需要执行的总移除操作数量与 `add()` 的调用次数成正比，因为每一次 `add()` 最多对应一个最终必须进行的移除操作。然后当我们找到一个唯一的数字时，返回它的操作花费为 $O(1)$。
    因为$O(1)$移除操作的数量与 `add()` 方法的调用次数成正比，我们可以说时间复杂度*在所有对 `add()` 和 `showFirstUnique()` 的调用中分摊*，得出总体时间复杂度为 $O(1)$（分摊）。
 - 空间复杂度：$O(N)$。
    - 总计的条目数就保存在队列中。
     <br/>

---
 #### 方法 3：对于队列使用 LinkedHashSet，并使用唯一状态哈希表
 **简述**
 尽管分摊时间为 $O(1)$ 总比非分摊时间为更高复杂度的 $O(N)$ 好，但非分摊的 $O(1)$ 会更好。分摊时间复杂度的缺点是，虽然*平均*每次方法调用的时间是 "好的"，但某些调用可能会很慢。想象一下，如果每一百万次的谷歌搜索需要 `1,000,000 ms`，而其他所有次数都需要 `1 ms`。平均时间为 `2 ms`，理论上听起来称得上是 "很好" ！*然而*，每一百万人中等待 *16分钟* 以获取搜索结果的那个人肯定不会对谷歌很满意！（如果每次搜索操作都需要 `5 ms` 可能会产生更少的负面新闻……）
 有没有去掉我们在方法 2 中设计的数据结构上的弯路，使得我们可以有更好的方法？
 为了做到这一点，我们需要使每种 "移除" 与其相应的 `add()` 在一起发生；而不是在未来的某次对 `showFirstUnique()` 的调用中。这是我们能避免有大量的 "等待" 移除操作的唯一方法。虽然我们之前已经认定这是过于困难的，但这能不能自行？

 - 在 `add()` 方法中进行移除操作的问题在于，它会导致最差情况下的 $O(N)$ 的队列搜索，可能会再次是 $O(N)$ 从队列中进行移除 （如果你可以的话！）。
 - 在 `showFirstUnique()` 方法中进行移除，我们可能需要进行大量的删除，才能找到一个返回的唯一的数字。然而，它将为所有对数据结构的调用提供更快速，因为我们不需要找到不唯一的数字，就像我们在 `add()` 中所做的那样。
 从队列中进行实际的*移除*操作的 $O(1)$ 并不难；我们只需要使用基于 `LinkedList` 的队列实现，而非基于 `Array` 的实现。
  然而，搜索 `LinkedList` 来找到值仍然是 $O(N)$ 的。唯一支持 $O(1)$ 时间搜索的数据结构是哈希集和哈希映射。但是它们并没有维护输入的顺序；我们并不是在打转吗？
  在这里我们可以使用另一个并不那么知名的数据结构：[LinkedHashSet](https://docs.oracle.com/en/java/javase/13/docs/api/java.base/java/util/LinkedHashSet.html)。在 Python 中，我们可以使用 [OrderedDict](https://docs.python.org/3.8/library/collections.html#collections.OrderedDict) 来实现相同的功能。如果你没听过它，读解决方案之前可以先看一下。你能看出它是如何解决我们的问题的吗？
  `LinkedHashSet` 是 `HashSet` 与 `LinkedList` 的混合体。像 `HashSet` 一样，可以在 $O(1)$ 时间内找到、更新、添加和移除项目。此外，它在这些项目之间建立*链接*以跟踪它们被添加的顺序。当从 `LinkedHashSet` 中移除一个项目时，这些链接将被更新，以指向前一个和下一个，就像在一个普通的链表中一样。
  本质上， `LinkedHashSet` 是一种*队列*，支持从中间进行 $O(1)$ 的移除操作！ 这正是我们需要解决问题的东西。我们现在可以在 `add()` 方法中进行移除，并且知道其为 $O(1)$。



**算法**

 ```Java [solution]
class FirstUnique {
  
  private Set<Integer> setQueue = new LinkedHashSet<>();
  private Map<Integer, Boolean> isUnique = new HashMap<>();
  
  public FirstUnique(int[] nums) {
    for (int num : nums) {
      this.add(num);
    }
  }
    
  public int showFirstUnique() {
    // 如果队列包含值，我们需要从队列中获取第一个值。
    // 我们可以创建一个迭代器，获取它的第一项。
    if (!setQueue.isEmpty()) {
       return setQueue.iterator().next();
    }
    return -1;
  }
    
  public void add(int value) {
    // 情况 1:该值未在数据结构中。
    // 应该添加。
    if (!isUnique.containsKey(value)) {
      isUnique.put(value, true);
      setQueue.add(value);
    // 案例 2:这个值已经出现过一次，所以现在变成了非唯一。它应该被移除。
    } else if (isUnique.get(value)) {
      isUnique.put(value, false);
      setQueue.remove(value);
    }
  }
}
 ```
```Python3 [solution]
# 在 Python 中，我们需要使用 OrderedDict 类。
# 我们可以通过将值设置为 None 来将其作为 Set 使用。

from collections import OrderedDict

class FirstUnique:

    def __init__(self, nums: List[int]):
        self._queue = OrderedDict()
        self._is_unique = {}
        for num in nums:
            # 注意，我们调用了 FirstUnique 的 add 方法;不在队列中。
            self.add(num)
        
    def showFirstUnique(self) -> int:
        # 检查队列中是否还有剩余值。可能没有什么独特之处。
        if self._queue:
            # 我们并不想真正“移除”这个值。
            # 由于 OrderedDict 没有“get first”方法，我们可以获取第一个值的方法是创建一个迭代器，然后从中获取“下一个”值。
            # 注意这是 O(1)
            return next(iter(self._queue))
        return -1
        
    def add(self, value: int) -> None:
        # 情况 1:我们需要将数字添加到队列中，并将其标记为唯一。
        if value not in self._is_unique:
            self._is_unique[value] = True
            self._queue[value] = None
        # 情况 2:我们需要将值标记为不再唯一，然后从队列中删除它。
        elif self._is_unique[value]:
            self._is_unique[value] = False
            self._queue.pop(value)
        # 情况 3:我们不需要做任何事情;该号码已从队列中删除
```


 **复杂性分析**
 令 $K$ 为传递到构造函数的初始数组的长度。
 令 $N$ 为目前添加到队列中的总项目数量（包括通过构造器添加的项目）。
 - 时间复杂度：
    - **构造器**：$O(K)$
    对于每一个传给构造函数的 $K$ 个数字，我们都调用 `add()`。如下文所确定，每次调用 `add()` 的成本为 $O(1)$。 因此，对于构造器中添加的 $K$ 个数字，总成本为 $K \cdot O(1) = O(K)$。
    - **add()**：$O(1)$
    和之前一样，当`add()`被调用时，我们执行一系列的 $O(1)$ 操作。此外，我们还从队列中移除了数字（如果它是唯一的，但现在没有了）。由于队列是作为 `LinkedHashSet` 来实现的，移除的成本为 $O(1)$。
    因此，对于`add()`我们得到 $O(1)$ 的时间复杂度。
    - **showFirstUnique()**：$O(1)$。
    这次的 `showFirstUnique()` 实现很直接。它仅检查队列是否包含任何项目，如果存在，它返回第一个（不移除）。这个操作的成本为 $O(1)$。
 - 空间复杂度：$O(N)$。
    每个数字最多存储一次在`LinkedHashSet`中，而且最多一次在`HashMap`中。因此，我们得到总体的空间复杂度为 $O(N)$。
     <br/>