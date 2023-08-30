### 📺 视频题解  
![41. 缺失的第一个正数.mp4](cac80bf0-8440-4325-94bb-b9f729db7dde)

### 📖 文字题解
#### 前言

如果本题没有额外的时空复杂度要求，那么就很容易实现：

- 我们可以将数组所有的数放入哈希表，随后从 $1$ 开始依次枚举正整数，并判断其是否在哈希表中；

- 我们可以从 $1$ 开始依次枚举正整数，并遍历数组，判断其是否在数组中。

如果数组的长度为 $N$，那么第一种做法的时间复杂度为 $O(N)$，空间复杂度为 $O(N)$；第二种做法的时间复杂度为 $O(N^2)$，空间复杂度为 $O(1)$。但它们都不满足时间复杂度为 $O(N)$ 且空间复杂度为 $O(1)$。

「真正」满足时间复杂度为 $O(N)$ 且空间复杂度为 $O(1)$ 的算法是不存在的，但是我们可以退而求其次：利用给定数组中的空间来存储一些状态。也就是说，如果题目给定的数组是**不可修改**的，那么就不存在满足时空复杂度要求的算法；但如果我们可以修改给定的数组，那么是存在满足要求的算法的。

#### 方法一：哈希表

对于「前言」中提到的第一种做法：

> 我们可以将数组所有的数放入哈希表，随后从 $1$ 开始依次枚举正整数，并判断其是否在哈希表中。

仔细想一想，我们为什么要使用哈希表？这是因为哈希表是一个可以支持快速查找的数据结构：给定一个元素，我们可以在 $O(1)$ 的时间查找该元素是否在哈希表中。因此，我们可以考虑将给定的数组设计成哈希表的「替代产品」。

实际上，对于一个长度为 $N$ 的数组，其中没有出现的最小正整数只能在 $[1, N+1]$ 中。这是因为如果 $[1, N]$ 都出现了，那么答案是 $N+1$，否则答案是 $[1, N]$ 中没有出现的最小正整数。这样一来，**我们将所有在 $[1, N]$** 范围内的数放入哈希表，也可以得到最终的答案。而给定的数组恰好长度为 $N$，这让我们有了一种将数组设计成哈希表的思路：

> 我们对数组进行遍历，对于遍历到的数 $x$，如果它在 $[1, N]$ 的范围内，那么就将数组中的第 $x-1$ 个位置（注意：数组下标从 $0$ 开始）打上「标记」。在遍历结束之后，如果所有的位置都被打上了标记，那么答案是 $N+1$，否则答案是最小的没有打上标记的位置加 $1$。

那么如何设计这个「标记」呢？由于数组中的数没有任何限制，因此这并不是一件容易的事情。但我们可以继续利用上面的提到的性质：由于我们只在意 $[1, N]$ 中的数，因此我们可以先对数组进行遍历，把不在 $[1, N]$ 范围内的数修改成任意一个大于 $N$ 的数（例如 $N+1$）。这样一来，**数组中的所有数就都是正数了**，因此我们就可以将「标记」表示为「负号」。算法的流程如下：

- 我们将数组中所有小于等于 $0$ 的数修改为 $N+1$；

- 我们遍历数组中的每一个数 $x$，它可能已经被打了标记，因此原本对应的数为 $|x|$，其中 $|\,|$ 为绝对值符号。如果 $|x| \in [1, N]$，那么我们给数组中的第 $|x| - 1$ 个位置的数添加一个负号。注意如果它已经有负号，不需要重复添加；

- 在遍历完成之后，如果数组中的每一个数都是负数，那么答案是 $N+1$，否则答案是第一个正数的位置加 $1$。

![fig1](https://assets.leetcode-cn.com/solution-static/41/41_fig1.png){:width="600"}

```C++ [sol1-C++]
class Solution {
public:
    int firstMissingPositive(vector<int>& nums) {
        int n = nums.size();
        for (int& num: nums) {
            if (num <= 0) {
                num = n + 1;
            }
        }
        for (int i = 0; i < n; ++i) {
            int num = abs(nums[i]);
            if (num <= n) {
                nums[num - 1] = -abs(nums[num - 1]);
            }
        }
        for (int i = 0; i < n; ++i) {
            if (nums[i] > 0) {
                return i + 1;
            }
        }
        return n + 1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int firstMissingPositive(int[] nums) {
        int n = nums.length;
        for (int i = 0; i < n; ++i) {
            if (nums[i] <= 0) {
                nums[i] = n + 1;
            }
        }
        for (int i = 0; i < n; ++i) {
            int num = Math.abs(nums[i]);
            if (num <= n) {
                nums[num - 1] = -Math.abs(nums[num - 1]);
            }
        }
        for (int i = 0; i < n; ++i) {
            if (nums[i] > 0) {
                return i + 1;
            }
        }
        return n + 1;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def firstMissingPositive(self, nums: List[int]) -> int:
        n = len(nums)
        for i in range(n):
            if nums[i] <= 0:
                nums[i] = n + 1
        
        for i in range(n):
            num = abs(nums[i])
            if num <= n:
                nums[num - 1] = -abs(nums[num - 1])
        
        for i in range(n):
            if nums[i] > 0:
                return i + 1
        
        return n + 1
```

```C [sol1-C]
int firstMissingPositive(int* nums, int numsSize) {
    for (int i = 0; i < numsSize; ++i) {
        if (nums[i] <= 0) {
            nums[i] = numsSize + 1;
        }
    }
    for (int i = 0; i < numsSize; ++i) {
        int num = abs(nums[i]);
        if (num <= numsSize) {
            nums[num - 1] = -abs(nums[num - 1]);
        }
    }
    for (int i = 0; i < numsSize; ++i) {
        if (nums[i] > 0) {
            return i + 1;
        }
    }
    return numsSize + 1;
}
```

```golang [sol1-Golang]
func firstMissingPositive(nums []int) int {
    n := len(nums)
    for i := 0; i < n; i++ {
        if nums[i] <= 0 {
            nums[i] = n + 1
        }
    }
    for i := 0; i < n; i++ {
        num := abs(nums[i])
        if num <= n {
            fmt.Println(num-1)
            nums[num - 1] = -abs(nums[num - 1])
        }
    }
    for i := 0; i < n; i++ {
        if nums[i] > 0 {
            return i + 1
        }
    }
    return n + 1
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组的长度。

- 空间复杂度：$O(1)$。

#### 方法二：置换

除了打标记以外，我们还可以使用置换的方法，将给定的数组「恢复」成下面的形式：

> 如果数组中包含 $x \in [1, N]$，那么恢复后，数组的第 $x - 1$ 个元素为 $x$。

在恢复后，数组应当有 `[1, 2, ..., N]` 的形式，但其中有若干个位置上的数是错误的，每一个错误的位置就代表了一个缺失的正数。以题目中的示例二 `[3, 4, -1, 1]` 为例，恢复后的数组应当为 `[1, -1, 3, 4]`，我们就可以知道缺失的数为 $2$。

那么我们如何将数组进行恢复呢？我们可以对数组进行一次遍历，对于遍历到的数 $x = \textit{nums}[i]$，如果 $x \in [1, N]$，我们就知道 $x$ 应当出现在数组中的 $x - 1$ 的位置，因此交换 $\textit{nums}[i]$ 和 $\textit{nums}[x - 1]$，这样 $x$ 就出现在了正确的位置。在完成交换后，新的 $\textit{nums}[i]$ 可能还在 $[1, N]$ 的范围内，我们需要继续进行交换操作，直到 $x \notin [1, N]$。

注意到上面的方法可能会陷入死循环。如果 $\textit{nums}[i]$ 恰好与 $\textit{nums}[x - 1]$ 相等，那么就会无限交换下去。此时我们有 $\textit{nums}[i] = x = \textit{nums}[x - 1]$，说明 $x$ 已经出现在了正确的位置。因此我们可以跳出循环，开始遍历下一个数。

由于每次的交换操作都会使得某一个数交换到正确的位置，因此交换的次数最多为 $N$，整个方法的时间复杂度为 $O(N)$。

```C++ [sol2-C++]
class Solution {
public:
    int firstMissingPositive(vector<int>& nums) {
        int n = nums.size();
        for (int i = 0; i < n; ++i) {
            while (nums[i] > 0 && nums[i] <= n && nums[nums[i] - 1] != nums[i]) {
                swap(nums[nums[i] - 1], nums[i]);
            }
        }
        for (int i = 0; i < n; ++i) {
            if (nums[i] != i + 1) {
                return i + 1;
            }
        }
        return n + 1;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int firstMissingPositive(int[] nums) {
        int n = nums.length;
        for (int i = 0; i < n; ++i) {
            while (nums[i] > 0 && nums[i] <= n && nums[nums[i] - 1] != nums[i]) {
                int temp = nums[nums[i] - 1];
                nums[nums[i] - 1] = nums[i];
                nums[i] = temp;
            }
        }
        for (int i = 0; i < n; ++i) {
            if (nums[i] != i + 1) {
                return i + 1;
            }
        }
        return n + 1;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def firstMissingPositive(self, nums: List[int]) -> int:
        n = len(nums)
        for i in range(n):
            while 1 <= nums[i] <= n and nums[nums[i] - 1] != nums[i]:
                nums[nums[i] - 1], nums[i] = nums[i], nums[nums[i] - 1]
        for i in range(n):
            if nums[i] != i + 1:
                return i + 1
        return n + 1
```

```C [sol2-C]
int firstMissingPositive(int* nums, int numsSize) {
    for (int i = 0; i < numsSize; ++i) {
        while (nums[i] > 0 && nums[i] <= numsSize &&
               nums[nums[i] - 1] != nums[i]) {
            int t = nums[nums[i] - 1];
            nums[nums[i] - 1] = nums[i], nums[i] = t;
        }
    }
    for (int i = 0; i < numsSize; ++i) {
        if (nums[i] != i + 1) {
            return i + 1;
        }
    }
    return numsSize + 1;
}
```

```golang [sol2-Golang]
func firstMissingPositive(nums []int) int {
    n := len(nums)
    for i := 0; i < n; i++ {
        for nums[i] > 0 && nums[i] <= n && nums[nums[i]-1] != nums[i] {
            nums[nums[i]-1], nums[i] = nums[i], nums[nums[i]-1]
        }
    }
    for i := 0; i < n; i++ {
        if nums[i] != i + 1 {
            return i + 1
        }
    }
    return n + 1
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组的长度。

- 空间复杂度：$O(1)$。