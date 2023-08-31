## [414.第三大的数 中文官方题解](https://leetcode.cn/problems/third-maximum-number/solutions/100000/di-san-da-de-shu-by-leetcode-solution-h3sp)

#### 方法一：排序

将数组从大到小排序后，从头开始遍历数组，通过判断相邻元素是否不同，来统计不同元素的个数。如果能找到三个不同的元素，就返回第三大的元素，否则返回最大的元素。

```Python [sol1-Python3]
class Solution:
    def thirdMax(self, nums: List[int]) -> int:
        nums.sort(reverse=True)
        diff = 1
        for i in range(1, len(nums)):
            if nums[i] != nums[i - 1]:
                diff += 1
                if diff == 3:  # 此时 nums[i] 就是第三大的数
                    return nums[i]
        return nums[0]
```

```C++ [sol1-C++]
class Solution {
public:
    int thirdMax(vector<int> &nums) {
        sort(nums.begin(), nums.end(), greater<>());
        for (int i = 1, diff = 1; i < nums.size(); ++i) {
            if (nums[i] != nums[i - 1] && ++diff == 3) { // 此时 nums[i] 就是第三大的数
                return nums[i];
            }
        }
        return nums[0];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int thirdMax(int[] nums) {
        Arrays.sort(nums);
        reverse(nums);
        for (int i = 1, diff = 1; i < nums.length; ++i) {
            if (nums[i] != nums[i - 1] && ++diff == 3) { // 此时 nums[i] 就是第三大的数
                return nums[i];
            }
        }
        return nums[0];
    }

    public void reverse(int[] nums) {
        int left = 0, right = nums.length - 1;
        while (left < right) {
            int temp = nums[left];
            nums[left] = nums[right];
            nums[right] = temp;
            left++;
            right--;
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ThirdMax(int[] nums) {
        Array.Sort(nums);
        Array.Reverse(nums);
        for (int i = 1, diff = 1; i < nums.Length; ++i) {
            if (nums[i] != nums[i - 1] && ++diff == 3) { // 此时 nums[i] 就是第三大的数
                return nums[i];
            }
        }
        return nums[0];
    }
}
```

```go [sol1-Golang]
func thirdMax(nums []int) int {
    sort.Sort(sort.Reverse(sort.IntSlice(nums)))
    for i, diff := 1, 1; i < len(nums); i++ {
        if nums[i] != nums[i-1] {
            diff++
            if diff == 3 { // 此时 nums[i] 就是第三大的数
                return nums[i]
            }
        }
    }
    return nums[0]
}
```

```JavaScript [sol1-JavaScript]
var thirdMax = function(nums) {
    nums.sort((a, b) => a - b);
    nums.reverse();
    for (let i = 1, diff = 1; i < nums.length; ++i) {
        if (nums[i] !== nums[i - 1] && ++diff === 3) { // 此时 nums[i] 就是第三大的数
            return nums[i];
        }
    }
    return nums[0];
};
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。排序需要 $O(n\log n)$ 的时间。

- 空间复杂度：$O(\log n)$。排序需要的栈空间为 $O(\log n)$。

#### 方法二：有序集合

我们可以遍历数组，同时用一个有序集合来维护数组中前三大的数。具体做法是每遍历一个数，就将其插入有序集合，若有序集合的大小超过 $3$，就删除集合中的最小元素。这样可以保证有序集合的大小至多为 $3$，且遍历结束后，若有序集合的大小为 $3$，其最小值就是数组中第三大的数；若有序集合的大小不足 $3$，那么就返回有序集合中的最大值。

```Python [sol2-Python3]
from sortedcontainers import SortedList

class Solution:
    def thirdMax(self, nums: List[int]) -> int:
        s = SortedList()
        for num in nums:
            if num not in s:
                s.add(num)
                if len(s) > 3:
                    s.pop(0)
        return s[0] if len(s) == 3 else s[-1]
```

```C++ [sol2-C++]
class Solution {
public:
    int thirdMax(vector<int> &nums) {
        set<int> s;
        for (int num : nums) {
            s.insert(num);
            if (s.size() > 3) {
                s.erase(s.begin());
            }
        }
        return s.size() == 3 ? *s.begin() : *s.rbegin();
    }
};
```

```Java [sol2-Java]
class Solution {
    public int thirdMax(int[] nums) {
        TreeSet<Integer> s = new TreeSet<Integer>();
        for (int num : nums) {
            s.add(num);
            if (s.size() > 3) {
                s.remove(s.first());
            }
        }
        return s.size() == 3 ? s.first() : s.last();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ThirdMax(int[] nums) {
        SortedSet<int> s = new SortedSet<int>();
        foreach (int num in nums) {
            s.Add(num);
            if (s.Count > 3) {
                s.Remove(s.Min);
            }
        }
        return s.Count == 3 ? s.Min : s.Max;
    }
}
```

```go [sol2-Golang]
func thirdMax(nums []int) int {
    t := redblacktree.NewWithIntComparator()
    for _, num := range nums {
        t.Put(num, nil)
        if t.Size() > 3 {
            t.Remove(t.Left().Key)
        }
    }
    if t.Size() == 3 {
        return t.Left().Key.(int)
    }
    return t.Right().Key.(int)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。由于有序集合的大小至多为 $3$，插入和删除的时间复杂度可以视作是 $O(1)$ 的，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。

#### 方法三：一次遍历

我们可以遍历数组，并用三个变量 $a$、$b$ 和 $c$ 来维护数组中的最大值、次大值和第三大值，以模拟方法二中的插入和删除操作。为方便编程实现，我们将其均初始化为小于数组最小值的元素，视作「无穷小」，比如 $-2^{63}$ 等。

遍历数组，对于数组中的元素 $\textit{num}$：

- 若 $\textit{num}>a$，我们将 $c$ 替换为 $b$，$b$ 替换为 $a$，$a$ 替换为 $\textit{num}$，这模拟了将 $\textit{num}$ 插入有序集合，并删除有序集合中的最小值的过程；
- 若 $a>\textit{num}>b$，类似地，我们将 $c$ 替换为 $b$，$b$ 替换为 $\textit{num}$，$a$ 保持不变；
- 若 $b>\textit{num}>c$，类似地，我们将 $c$ 替换为 $\textit{num}$，$a$ 和 $b$ 保持不变；
- 其余情况不做处理。

遍历结束后，若 $c$ 仍然为 $-2^{63}$，则说明数组中不存在三个或三个以上的不同元素，即第三大的数不存在，返回 $a$，否则返回 $c$。

```Python [sol3-Python3]
class Solution:
    def thirdMax(self, nums: List[int]) -> int:
        a, b, c = float('-inf'), float('-inf'), float('-inf')
        for num in nums:
            if num > a:
                a, b, c = num, a, b
            elif a > num > b:
                b, c = num, b
            elif b > num > c:
                c = num
        return a if c == float('-inf') else c
```

```C++ [sol3-C++]
class Solution {
public:
    int thirdMax(vector<int> &nums) {
        long a = LONG_MIN, b = LONG_MIN, c = LONG_MIN;
        for (long num : nums) {
            if (num > a) {
                c = b;
                b = a;
                a = num;
            } else if (a > num && num > b) {
                c = b;
                b = num;
            } else if (b > num && num > c) {
                c = num;
            }
        }
        return c == LONG_MIN ? a : c;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int thirdMax(int[] nums) {
        long a = Long.MIN_VALUE, b = Long.MIN_VALUE, c = Long.MIN_VALUE;
        for (long num : nums) {
            if (num > a) {
                c = b;
                b = a;
                a = num;
            } else if (a > num && num > b) {
                c = b;
                b = num;
            } else if (b > num && num > c) {
                c = num;
            }
        }
        return c == Long.MIN_VALUE ? (int) a : (int) c;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int ThirdMax(int[] nums) {
        long a = long.MinValue, b = long.MinValue, c = long.MinValue;
        foreach (long num in nums) {
            if (num > a) {
                c = b;
                b = a;
                a = num;
            } else if (a > num && num > b) {
                c = b;
                b = num;
            } else if (b > num && num > c) {
                c = num;
            }
        }
        return c == long.MinValue ? (int) a : (int) c;
    }
}
```

```go [sol3-Golang]
func thirdMax(nums []int) int {
    a, b, c := math.MinInt64, math.MinInt64, math.MinInt64
    for _, num := range nums {
        if num > a {
            a, b, c = num, a, b
        } else if a > num && num > b {
            b, c = num, b
        } else if b > num && num > c {
            c = num
        }
    }
    if c == math.MinInt64 {
        return a
    }
    return c
}
```

```JavaScript [sol3-JavaScript]
var thirdMax = function(nums) {
    let a = -Number.MAX_VALUE, b = -Number.MAX_VALUE, c = -Number.MAX_VALUE;
    for (const num of nums) {
        if (num > a) {
            c = b;
            b = a;
            a = num;
        } else if (a > num && num > b) {
            c = b;
            b = num;
        } else if (b > num && num > c) {
            c = num;
        }
    }
    return c === -Number.MAX_VALUE ? a : c;
};
```

另一种不依赖元素范围的做法是，将 $a$、$b$ 和 $c$ 初始化为空指针或空对象，视作「无穷小」，并在比较大小前先判断是否为空指针或空对象。遍历结束后，若 $c$ 为空，则说明第三大的数不存在，返回 $a$，否则返回 $c$。

```Python [sol4-Python3]
class Solution:
    def thirdMax(self, nums: List[int]) -> int:
        a, b, c = None, None, None
        for num in nums:
            if a is None or num > a:
                a, b, c = num, a, b
            elif a > num and (b is None or num > b):
                b, c = num, b
            elif b is not None and b > num and (c is None or num > c):
                c = num
        return a if c is None else c
```

```C++ [sol4-C++]
class Solution {
public:
    int thirdMax(vector<int> &nums) {
        int *a = nullptr, *b = nullptr, *c = nullptr;
        for (int &num : nums) {
            if (a == nullptr || num > *a) {
                c = b;
                b = a;
                a = &num;
            } else if (*a > num && (b == nullptr || num > *b)) {
                c = b;
                b = &num;
            } else if (b != nullptr && *b > num && (c == nullptr || num > *c)) {
                c = &num;
            }
        }
        return c == nullptr ? *a : *c;
    }
};
```

```Java [sol4-Java]
class Solution {
    public int thirdMax(int[] nums) {
        Integer a = null, b = null, c = null;
        for (int num : nums) {
            if (a == null || num > a) {
                c = b;
                b = a;
                a = num;
            } else if (a > num && (b == null || num > b)) {
                c = b;
                b = num;
            } else if (b != null && b > num && (c == null || num > c)) {
                c = num;
            }
        }
        return c == null ? a : c;
    }
}
```

```C# [sol4-C#]
public class Solution {
    public int ThirdMax(int[] nums) {
        int? a = null, b = null, c = null;
        foreach (int num in nums) {
            if (a == null || num > a) {
                c = b;
                b = a;
                a = num;
            } else if (a > num && (b == null || num > b)) {
                c = b;
                b = num;
            } else if (b != null && b > num && (c == null || num > c)) {
                c = num;
            }
        }
        return c == null ? (int) a : (int) c;
    }
}
```

```go [sol4-Golang]
func thirdMax(nums []int) int {
    var a, b, c *int
    for _, num := range nums {
        num := num
        if a == nil || num > *a {
            a, b, c = &num, a, b
        } else if *a > num && (b == nil || num > *b) {
            b, c = &num, b
        } else if b != nil && *b > num && (c == nil || num > *c) {
            c = &num
        }
    }
    if c == nil {
        return *a
    }
    return *c
}
```

```JavaScript [sol4-JavaScript]
var thirdMax = function(nums) {
    let a = null, b = null, c = null;
    for (const num of nums) {
        if (a === null || num > a) {
            c = b;
            b = a;
            a = num;
        } else if (a > num && (b === null || num > b)) {
            c = b;
            b = num;
        } else if (b !== null && b > num && (c === null || num > c)) {
            c = num;
        }
    }
    return c === null ? a : c;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。