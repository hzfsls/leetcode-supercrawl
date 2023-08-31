## [1752.检查数组是否经排序和轮转得到 中文官方题解](https://leetcode.cn/problems/check-if-array-is-sorted-and-rotated/solutions/100000/jian-cha-shu-zu-shi-fou-jing-pai-xu-he-l-cbqk)
#### 方法一：直接遍历

**思路与算法**

按照题意可以知道 $\textit{nums}$ 的源数组 $\textit{source}$ 中的所有元素都按非递减顺序排列，假设数组的长度为 $n$，假设当数组向右轮转 $x$ 个位置，令 $x = x \mod n$，根据置换公式 $\textit{source}[i] = \textit{nums}[(i + x) \mod n]$ 可以知道：
$$
\textit{nums}[0,\cdots,x-1] = \textit{source}[n-x,\cdots,n-1] \\
\textit{nums}[x,\cdots,n-1] = \textit{source}[0,\cdots,n-x-1] \\
$$

+ 当 $x = 0$ 时，则意味着数组 $\textit{nums}$ 本身为非递减顺序排列，$\textit{nums}$ 与原数组相同，此时我们只需要判断 $\textit{nums}$ 是否为非递减顺序排列；

+ 当 $x > 0$ 时，则意味着数组 $\textit{nums}$ 分为了两部分，$\textit{nums}[0,\cdots,x-1],\textit{nums}[x,\cdots,n-1]$，需进行分类检测；

对于 $x > 0$ 时，根据题意可以知道对于原始数组 $\textit{source}$ 一定满足当 $i \le j$ 时，则 $\textit{source}[i] \le \textit{source}[j]$，由此我们可以推出：
+ 当 $0 < i < x$ 时，则一定满足 $\textit{nums}[i-1] \le \textit{nums}[i]$；
+ 当 $x < i < n$ 时，则一定满足 $\textit{nums}[i-1] \le \textit{nums}[i]$；
+ 当 $x \le i < n$ 时，由于 $\textit{source}[n-x-1] \le \textit{source}[n-x]$，则一定满足 $\textit{nums}[i] \le \textit{nums}[n-1] \le \textit{nums}[0]$；
   - 当满足 $\textit{source}[n-1] = \textit{source}[0]$ 时，则意味着整个数组均为相等，从任意处轮转数组均保持不变；
   - 当满足 $\textit{source}[n-1] > \textit{source}[0]$ 时，此时 $\textit{source}[n-1],\textit{source}[0]$ 对应的元素为 $\textit{nums}[x-1],\textit{nums}[x]$，此时一定满足 $\textit{nums}[x-1] > \textit{nums}[x]$，则此时找到第一个索引 $i$ 满足 $\textit{nums}[i] < \textit{nums}[i - 1]$ 时，$\textit{nums}[i-1],\textit{nums}[i]$ 对应着源数组中的 $\textit{source}[n-1],\textit{source}[0]$；

根据上述推理，我们检测过程如下：
+ 首先检测数组是否非递减排序，如果满足非递减排序则直接返回 $\text{true}$；
+ 如果数组不满足非递减排序，则找到第一个 $i$ 满足 $\textit{nums}[i] < \textit{nums}[i - 1]$，然后分别检测子数组 $\textit{nums}[0,\cdots,i-1],\textit{nums}[i,\cdots,n-1]$ 是否都满足非递减排序；
+ 如果两个子数组都满足非递减排序，还需检测 $\textit{nums}[i,\cdots,n-1]$ 中的元素是否都满足小于等于 $\textit{nums}[0]$，实际我们只需检测 $\textit{nums}[n-1]$ 是否满足小于等于 $\textit{nums}[0]$ 即可；

根据上述描述的检测过程进行检测即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def check(self, nums: List[int]) -> bool:
        n = len(nums)
        x = 0
        for i in range(1, n):
            if nums[i] < nums[i - 1]:
                x = i
                break
        if x == 0:
            return True
        for i in range(x + 1, n):
            if nums[i] < nums[i - 1]:
                return False
        return nums[0] >= nums[-1]
```

```C++ [sol1-C++]
class Solution {
public:
    bool check(vector<int>& nums) {
        int n = nums.size(), x = 0;
        for (int i = 1; i < n; ++i) {
            if (nums[i] < nums[i - 1]) {
                x = i;
                break;
            }
        }
        if (x == 0) {
            return true;
        }
        for (int i = x + 1; i < n; ++i) {
            if (nums[i] < nums[i - 1]) {
                return false;
            }
        }
        return nums[0] >= nums[n - 1];
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean check(int[] nums) {
        int n = nums.length, x = 0;
        for (int i = 1; i < n; ++i) {
            if (nums[i] < nums[i - 1]) {
                x = i;
                break;
            }
        }
        if (x == 0) {
            return true;
        }
        for (int i = x + 1; i < n; ++i) {
            if (nums[i] < nums[i - 1]) {
                return false;
            }
        }
        return nums[0] >= nums[n - 1];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool Check(int[] nums) {
        int n = nums.Length, x = 0;
        for (int i = 1; i < n; ++i) {
            if (nums[i] < nums[i - 1]) {
                x = i;
                break;
            }
        }
        if (x == 0) {
            return true;
        }
        for (int i = x + 1; i < n; ++i) {
            if (nums[i] < nums[i - 1]) {
                return false;
            }
        }
        return nums[0] >= nums[n - 1];
    }
}
```

```C [sol1-C]
bool check(int* nums, int numsSize) {
    int x = 0;
    for (int i = 1; i < numsSize; ++i) {
        if (nums[i] < nums[i - 1]) {
            x = i;
            break;
        }
    }
    if (x == 0) {
        return true;
    }
    for (int i = x + 1; i < numsSize; ++i) {
        if (nums[i] < nums[i - 1]) {
            return false;
        }
    }
    return nums[0] >= nums[numsSize - 1];
}
```

```JavaScript [sol1-JavaScript]
var check = function(nums) {
    let n = nums.length, x = 0;
    for (let i = 1; i < n; ++i) {
        if (nums[i] < nums[i - 1]) {
            x = i;
            break;
        }
    }
    if (x === 0) {
        return true;
    }
    for (let i = x + 1; i < n; ++i) {
        if (nums[i] < nums[i - 1]) {
            return false;
        }
    }
    return nums[0] >= nums[n - 1];
};
```

```go [sol1-Golang]
func check(nums []int) bool {
    n := len(nums)
    x := 0
    for i := 1; i < n; i++ {
        if nums[i] < nums[i-1] {
            x = i
            break
        }
    }
    if x == 0 {
        return true
    }
    for i := x + 1; i < n; i++ {
        if nums[i] < nums[i-1] {
            return false
        }
    }
    return nums[0] >= nums[n-1]
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示数组的长度。我们只需遍历一遍数组即可。

- 空间复杂度：$O(1)$。遍历过程中不需要额外的空间。