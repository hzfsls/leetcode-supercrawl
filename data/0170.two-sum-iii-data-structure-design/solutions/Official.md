## [170.两数之和 III - 数据结构设计 中文官方题解](https://leetcode.cn/problems/two-sum-iii-data-structure-design/solutions/100000/liang-shu-zhi-he-iii-shu-ju-jie-gou-she-ss73t)

[TOC]

## 解决方案

---

 #### 方法 1：排序列表

 **概述**

 首先，问题的描述对时间和空间复杂度的要求并不是很清楚。但让我们把这个问题看成是挑战的一部分或者设计的自由。我们可以通过试错来找出每个函数所需要的复杂度。

 这是 LeetCode 上第一个编程问题 [两数之和](https://leetcode.cn/problems/two-sum/) 的延伸问题之一，在那个问题中，我们被要求从一个 **列表** 中返回两个数字的索引，这两个数字的和为给定值。
 >我们从原问题中得到启示，通过在 _list_ 中存储所有传入的数字。

 给定一个列表，解决两数之和问题的一种方法被称为 **双指针**，我们通过 _两个指针_ 从两个方向迭代列表，两个指针彼此接近。

 ![image.png](https://pic.leetcode.cn/1692173471-WhDwWM-image.png){:width=600}

 >然而，双指针迭代解决方案的其中一个前提条件是输入列表应该是 **_已排序的_**。

 所以，问题来了：

- 我们应该在 `add(number)` 函数中通过插入新数字来保持列表的有序性吗？
- 或者我们应该在调用 `find(value)` 时进行排序吗？

我们将在算法部分解答上述两个问题。

**算法步骤**
 让我们首先给出从 _已排序的_ 列表中找到 two-sum 解决方案的双指针算法：

- 我们初始化 **两个指针** `low` 和 `high`，它们指向列表的头元素和尾元素。
- 我们通过两个指针开始 **循环** 迭代列表。这个循环将在我们找到 two-sum 解决方案或两个指针相遇时终止。
- 在循环中，每一步中，我们会根据不同的条件移动一个指针：
  - 如果当前指针指向的元素之和 **_小于_** 期望值，那么我们应该尝试增加这个和以达到期望值，即我们应该将 `low` 指针向前移动以得到一个更大的值。
  - 同样，如果当前指针指向的元素之和 **_大于_** 期望值，那么我们就应该试着通过移动 `high` 指针来减少这个和。
  - 如果和恰好等于期望值，那么我们可以直接使用函数的 **early return**。
- 如果循环在两个指针相遇的情况下终止，那么我们可以确定没有解决方案。

 ```Java [slu1]
 import java.util.Collections;

class TwoSum {
  private ArrayList<Integer> nums;
  private boolean is_sorted;

  /** 在这里初始化你的数据结构。 */
  public TwoSum() {
    this.nums = new ArrayList<Integer>();
    this.is_sorted = false;
  }

  /** 将数字添加到内部数据结构中。 */
  public void add(int number) {
    this.nums.add(number);
    this.is_sorted = false;
  }

  /** 查看是否存在任何一对数字，其总和等于该值。 */
  public boolean find(int value) {
    if (!this.is_sorted) {
      Collections.sort(this.nums);
      this.is_sorted = true;
    }
    int low = 0, high = this.nums.size() - 1;
    while (low < high) {
      int twosum = this.nums.get(low) + this.nums.get(high);
      if (twosum < value)
        low += 1;
      else if (twosum > value)
        high -= 1;
      else
        return true;
    }
    return false;
  }
}
 ```

 ```Python3 [slu1]
 class TwoSum(object):

    def __init__(self):
        """"""
        在这里初始化你的数据结构。
        """"""
        self.nums = []
        self.is_sorted = False


    def add(self, number):
        """"""
        将数字添加到内部数据结构中。
        :type number: int
        :rtype: None
        """"""
        # 在保持升序的同时插入。
        # for index, num in enumerate(self.nums):
        #     if number <= num:
        #         self.nums.insert(index, number)
        #         return
        ## 大于任何数字
        #self.nums.append(number)

        self.nums.append(number)
        self.is_sorted = False
    

    def find(self, value):
        """"""
        查看是否存在任何一对数字，其总和等于该值。
        :type value: int
        :rtype: bool
        """"""
        if not self.is_sorted:
            self.nums.sort()
            self.is_sorted = True

        low, high = 0, len(self.nums)-1
        while low < high:
            currSum = self.nums[low] + self.nums[high]
            if currSum < value:
                low += 1
            elif currSum > value:
                high -= 1
            else: # currSum == value
                return True
        
        return False
 ```

我们会发现，`add(number)` 函数将被频繁调用，而 `find(value)` 将不被那么频繁调用。

这样的使用模式下，意味着我们应该减少 `add(number)` 函数的时间消耗，因而我们是在 `find(value)` 对列表进行排序，而不是在 `add(number)`。

在哪个函数进行排序，都是可行的，只是对应该使用模式下在 `add(number)` 下进行排序就不是最佳的方案了。

并且，我们在 `find(value)` 中是按需排序，也就是当列表更新时，才进行排序。

 **复杂度分析**

 - 时间复杂度：
    - 对于 `add(number)` 函数：$\mathcal{O}(1)$，因为我们只是将元素追加到列表中。
    - 对于 `find(value)` 函数：$\mathcal{O}(N \cdot \log(N))$。在最坏的情况下，我们需要首先对列表进行排序，这通常需要 $\mathcal{O}(N \cdot \log(N))$ 的时间复杂度。然后，再在最坏的情况下，我们需要遍历整个列表，这需要 $\mathcal{O}(N)$ 的时间复杂度。因此，函数的整体时间复杂度取决于 $\mathcal{O}(N \cdot \log(N))$ 的排序操作，这个操作的复杂度大于后面的迭代部分。
 - 空间复杂度：数据结构的整体空间复杂度为 $\mathcal{O}(N)$，其中 $N$ 是添加的总的 _数字个数_。

---

 #### 方法 2：已排序的哈希表

 **概述**

 作为原问题 [两数之和](https://leetcode.cn/problems/two-sum/) 的另一种解决方案，我们可以通过使用 _已排序的哈希表_ 来索引每个数字。
 >给定一个期望的和 `S`，对于每个数字 `a`，我们只需要验证是否存在一个补数（`S-a`）在表中。
 > 如我们所知，已排序的哈希表这种数据结构能为我们提供快速的 _查找_ 以及 _插入_ 操作，这很好地满足了上述的需求。

 **算法**

 - 首先，我们在我们的数据结构中初始化一个 _已排序的哈希表_ 。
 - 对于 `add(number)` 函数，我们根据 _number_ 为键和 _number_ 的频率为值构建一个频率已排序的哈希表。
 - 对于 `find(value)` 函数，然后我们迭代已排序的哈希表的键。对于每个键（`number`），我们检查是否存在一个补数（`value - number`）在表中。如果存在，我们就可以终止循环并返回结果。
 - 在一个特殊的情况下，数字和它的补数相等，我们需要检查是否存在 _至少_ 两个 _number_ 在表中。
 我们在下面的图中说明了这种算法。
 ![image.png](https://pic.leetcode.cn/1693279450-mZxIDD-image.png){:width=600}

 ```Java [slu2]
 import java.util.HashMap;

class TwoSum {
  private HashMap<Integer, Integer> num_counts;

  /** 在这里初始化你的数据结构。 */
  public TwoSum() {
    this.num_counts = new HashMap<Integer, Integer>();
  }

  /** 将数字添加到内部数据结构中。 */
  public void add(int number) {
    if (this.num_counts.containsKey(number))
      this.num_counts.replace(number, this.num_counts.get(number) + 1);
    else
      this.num_counts.put(number, 1);
  }

  /** 查看是否存在任何一对数字，其总和等于该值。 */
  public boolean find(int value) {
    for (Map.Entry<Integer, Integer> entry : this.num_counts.entrySet()) {
      int complement = value - entry.getKey();
      if (complement != entry.getKey()) {
        if (this.num_counts.containsKey(complement))
          return true;
      } else {
        if (entry.getValue() > 1)
          return true;
      }
    }
    return false;
  }
}
 ```

 ```Python3 [slu2]
 import java.util.HashMap;

class TwoSum {
  private HashMap<Integer, Integer> num_counts;

  /** 在这里初始化你的数据结构。 */
  public TwoSum() {
    this.num_counts = new HashMap<Integer, Integer>();
  }

  /** 将数字添加到内部数据结构中。 */
  public void add(int number) {
    if (this.num_counts.containsKey(number))
      this.num_counts.replace(number, this.num_counts.get(number) + 1);
    else
      this.num_counts.put(number, 1);
  }

  /** 查看是否存在任何一对数字，其总和等于该值。 */
  public boolean find(int value) {
    for (Map.Entry<Integer, Integer> entry : this.num_counts.entrySet()) {
      int complement = value - entry.getKey();
      if (complement != entry.getKey()) {
        if (this.num_counts.containsKey(complement))
          return true;
      } else {
        if (entry.getValue() > 1)
          return true;
      }
    }
    return false;
  }
}
 ```

 **复杂度分析**

- 时间复杂度：
  - 对于 `add(number)` 函数：$\mathcal{O}(1)$，因为更新一个哈希表的条目只需要常量时间。
  - 对于 `find(value)` 函数：$\mathcal{O}(N)$，其中 $N$ 是所有 **不同** _数字_ 的总数。在最坏的情况下，我们将遍历整个表。
- 空间复杂度：$\mathcal{O}(N)$，其中 $N$ 是我们在使用数据结构过程中会看到的所有 **不同** _数字的总数_。