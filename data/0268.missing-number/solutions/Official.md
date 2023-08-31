## [268.丢失的数字 中文官方题解](https://leetcode.cn/problems/missing-number/solutions/100000/diu-shi-de-shu-zi-by-leetcode-solution-naow)
#### 方法一：排序

将数组排序之后，即可根据数组中每个下标处的元素是否和下标相等，得到丢失的数字。

由于数组的长度是 $n$，因此下标范围是 $[0, n-1]$。假设缺失的数字是 $k$，分别考虑以下两种情况：

- 当 $0 \le k < n$ 时，对任意 $0 \le i < k$，都有 $\textit{nums}[i]=i$，由于 $k$ 缺失，因此 $\textit{nums}[k]=k+1$，$k$ 是第一个满足下标和元素不相等的下标；

- 当 $k = n$ 时，$0$ 到 $n-1$ 都没有缺失，因此对任意 $0 \le i < n$，都有 $\textit{nums}[i]=i$。

根据上述两种情况，可以得到如下方法得到丢失的数字：

1. 从左到右遍历数组 $\textit{nums}$，如果存在 $0 \le i < n$ 使得 $\textit{nums}[i] \ne i$，则缺失的数字是满足 $\textit{nums}[i] \ne i$ 的最小的 $i$；

2. 如果对任意 $0 \le i < n$，都有 $\textit{nums}[i]=i$，则缺失的数字是 $n$。

```Java [sol1-Java]
class Solution {
    public int missingNumber(int[] nums) {
        Arrays.sort(nums);
        int n = nums.length;
        for (int i = 0; i < n; i++) {
            if (nums[i] != i) {
                return i;
            }
        }
        return n;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MissingNumber(int[] nums) {
        Array.Sort(nums);
        int n = nums.Length;
        for (int i = 0; i < n; i++) {
            if (nums[i] != i) {
                return i;
            }
        }
        return n;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int missingNumber(vector<int>& nums) {
        sort(nums.begin(),nums.end());
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            if (nums[i] != i) {
                return i;
            }
        }
        return n;
    }
};
```

```JavaScript [sol1-JavaScript]
var missingNumber = function(nums) {
    nums.sort((a, b) => a - b);
    const n = nums.length;
    for (let i = 0; i < n; i++) {
        if (nums[i] !== i) {
            return i;
        }
    }
    return n;
};
```

```TypeScript [sol1-TypeScript]
function missingNumber(nums: number[]): number {
    nums.sort((a, b) => a - b);
    const n: number = nums.length;
    for (let i = 0; i < n; i++) {
        if (nums[i] !== i) {
            return i;
        }
    }
    return n;
};
```

```go [sol1-Golang]
func missingNumber(nums []int) int {
    sort.Ints(nums)
    for i, num := range nums {
        if num != i {
            return i
        }
    }
    return len(nums)
}
```

```Python [sol1-Python3]
class Solution:
    def missingNumber(self, nums: List[int]) -> int:
        nums.sort()
        for i, num in enumerate(nums):
            if num != i:
                return i
        return len(nums)
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。排序的时间复杂度是 $O(n \log n)$，遍历数组寻找丢失的数字的时间复杂度是 $O(n)$，因此总时间复杂度是 $O(n \log n)$。

- 空间复杂度：$O(\log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。空间复杂度主要取决于排序的递归调用栈空间。

#### 方法二：哈希集合

使用哈希集合，可以将时间复杂度降低到 $O(n)$。

首先遍历数组 $\textit{nums}$，将数组中的每个元素加入哈希集合，然后依次检查从 $0$ 到 $n$ 的每个整数是否在哈希集合中，不在哈希集合中的数字即为丢失的数字。由于哈希集合的每次添加元素和查找元素的时间复杂度都是 $O(1)$，因此总时间复杂度是 $O(n)$。

```Java [sol2-Java]
class Solution {
    public int missingNumber(int[] nums) {
        Set<Integer> set = new HashSet<Integer>();
        int n = nums.length;
        for (int i = 0; i < n; i++) {
            set.add(nums[i]);
        }
        int missing = -1;
        for (int i = 0; i <= n; i++) {
            if (!set.contains(i)) {
                missing = i;
                break;
            }
        }
        return missing;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MissingNumber(int[] nums) {
        ISet<int> set = new HashSet<int>();
        int n = nums.Length;
        for (int i = 0; i < n; i++) {
            set.Add(nums[i]);
        }
        int missing = -1;
        for (int i = 0; i <= n; i++) {
            if (!set.Contains(i)) {
                missing = i;
                break;
            }
        }
        return missing;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int missingNumber(vector<int>& nums) {
        unordered_set<int> set;
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            set.insert(nums[i]);
        }
        int missing = -1;
        for (int i = 0; i <= n; i++) {
            if (!set.count(i)) {
                missing = i;
                break;
            }
        }
        return missing;
    }
};
```

```JavaScript [sol2-JavaScript]
var missingNumber = function(nums) {
    const set = new Set();
    const n = nums.length;
    for (let i = 0; i < n; i++) {
        set.add(nums[i]);
    }
    let missing = -1;
    for (let i = 0; i <= n; i++) {
        if (!set.has(i)) {
            missing = i;
            break;
        }
    }
    return missing;
};
```

```TypeScript [sol2-TypeScript]
function missingNumber(nums: number[]): number {
    const set = new Set();
    const n: number = nums.length;
    for (let i = 0; i < n; i++) {
        set.add(nums[i]);
    }
    let missing: number = -1;
    for (let i = 0; i <= n; i++) {
        if (!set.has(i)) {
            missing = i;
            break;
        }
    }
    return missing;
};
```

```go [sol2-Golang]
func missingNumber(nums []int) int {
    has := map[int]bool{}
    for _, v := range nums {
        has[v] = true
    }
    for i := 0; ; i++ {
        if !has[i] {
            return i
        }
    }
}
```

```Python [sol2-Python3]
class Solution:
    def missingNumber(self, nums: List[int]) -> int:
        s = set(nums)
        for i in range(len(nums) + 1):
            if i not in s:
                return i
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。遍历数组 $\textit{nums}$ 将元素加入哈希集合的时间复杂度是 $O(n)$，遍历从 $0$ 到 $n$ 的每个整数并判断是否在哈希集合中的时间复杂度也是 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。哈希集合中需要存储 $n$ 个整数。

#### 方法三：位运算

数组 $\textit{nums}$ 中有 $n$ 个数，在这 $n$ 个数的后面添加从 $0$ 到 $n$ 的每个整数，则添加了 $n+1$ 个整数，共有 $2n+1$ 个整数。

在 $2n+1$ 个整数中，丢失的数字只在后面 $n+1$ 个整数中出现一次，其余的数字在前面 $n$ 个整数中（即数组中）和后面 $n+1$ 个整数中各出现一次，即其余的数字都出现了两次。

根据出现的次数的奇偶性，可以使用按位异或运算得到丢失的数字。按位异或运算 $\oplus$ 满足交换律和结合律，且对任意整数 $x$ 都满足 $x \oplus x = 0$ 和 $x \oplus 0 = x$。

由于上述 $2n+1$ 个整数中，丢失的数字出现了一次，其余的数字都出现了两次，因此对上述 $2n+1$ 个整数进行按位异或运算，结果即为丢失的数字。

```Java [sol3-Java]
class Solution {
    public int missingNumber(int[] nums) {
        int xor = 0;
        int n = nums.length;
        for (int i = 0; i < n; i++) {
            xor ^= nums[i];
        }
        for (int i = 0; i <= n; i++) {
            xor ^= i;
        }
        return xor;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int MissingNumber(int[] nums) {
        int xor = 0;
        int n = nums.Length;
        for (int i = 0; i < n; i++) {
            xor ^= nums[i];
        }
        for (int i = 0; i <= n; i++) {
            xor ^= i;
        }
        return xor;
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    int missingNumber(vector<int>& nums) {
        int res = 0;
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            res ^= nums[i];
        }
        for (int i = 0; i <= n; i++) {
            res ^= i;
        }
        return res;
    }
};
```

```JavaScript [sol3-JavaScript]
var missingNumber = function(nums) {
    let xor = 0;
    const n = nums.length;
    for (let i = 0; i < nums.length; i++) {
        xor ^= nums[i];
    }
    for (let i = 0; i <= n; i++) {
        xor ^= i;
    }
    return xor;
};
```

```TypeScript [sol3-TypeScript]
var missingNumber = function(nums) {
    let xor: number = 0;
    const n: number = nums.length;
    for (let i = 0; i < nums.length; i++) {
        xor ^= nums[i];
    }
    for (let i = 0; i <= n; i++) {
        xor ^= i;
    }
    return xor;
};
```

```go [sol3-Golang]
func missingNumber(nums []int) (xor int) {
    for i, num := range nums {
        xor ^= i ^ num
    }
    return xor ^ len(nums)
}
```

```Python [sol3-Python3]
class Solution:
    def missingNumber(self, nums: List[int]) -> int:
        xor = 0
        for i, num in enumerate(nums):
            xor ^= i ^ num
        return xor ^ len(nums)
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要对 $2n+1$ 个数字计算按位异或的结果。

- 空间复杂度：$O(1)$。

#### 方法四：数学

将从 $0$ 到 $n$ 的全部整数之和记为 $\textit{total}$，根据高斯求和公式，有：

$$
\textit{total} = \sum_{i=1}^n = \dfrac{n(n+1)}{2}
$$

将数组 $\textit{nums}$ 的元素之和记为 $\textit{arrSum}$，则 $\textit{arrSum}$ 比 $\textit{total}$ 少了丢失的一个数字，因此丢失的数字即为 $\textit{total}$ 与 $\textit{arrSum}$ 之差。

```Java [sol4-Java]
class Solution {
    public int missingNumber(int[] nums) {
        int n = nums.length;
        int total = n * (n + 1) / 2;
        int arrSum = 0;
        for (int i = 0; i < n; i++) {
            arrSum += nums[i];
        }
        return total - arrSum;
    }
}
```

```C# [sol4-C#]
public class Solution {
    public int MissingNumber(int[] nums) {
        int n = nums.Length;
        int total = n * (n + 1) / 2;
        int arrSum = 0;
        for (int i = 0; i < n; i++) {
            arrSum += nums[i];
        }
        return total - arrSum;
    }
}
```

```C++ [sol4-C++]
class Solution {
public:
    int missingNumber(vector<int>& nums) {
        int n = nums.size();
        int total = n * (n + 1) / 2;
        int arrSum = 0;
        for (int i = 0; i < n; i++) {
            arrSum += nums[i];
        }
        return total - arrSum;
    }
};
```

```JavaScript [sol4-JavaScript]
var missingNumber = function(nums) {
    const n = nums.length;
    let total = Math.floor(n * (n + 1) / 2);
    let arrSum = 0;
    for (let i = 0; i < n; i++) {
        arrSum += nums[i];
    }
    return total - arrSum;
};
```

```TypeScript [sol4-TypeScript]
var missingNumber = function(nums) {
    const n: number = nums.length;
    let total: number = Math.floor(n * (n + 1) / 2);
    let arrSum: number = 0;
    for (let i = 0; i < n; i++) {
        arrSum += nums[i];
    }
    return total - arrSum;
};
```

```go [sol4-Golang]
func missingNumber(nums []int) int {
    n := len(nums)
    total := n * (n + 1) / 2
    arrSum := 0
    for _, num := range nums {
        arrSum += num
    }
    return total - arrSum
}
```

```Python [sol4-Python3]
class Solution:
    def missingNumber(self, nums: List[int]) -> int:
        n = len(nums)
        total = n * (n + 1) // 2
        arrSum = sum(nums)
        return total - arrSum
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要 $O(1)$ 的时间计算从 $0$ 到 $n$ 的全部整数之和以及需要 $O(n)$ 的时间计算数组 $\textit{nums}$ 的元素之和。

- 空间复杂度：$O(1)$。