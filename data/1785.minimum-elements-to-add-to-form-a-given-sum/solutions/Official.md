## [1785.构成特定和需要添加的最少元素 中文官方题解](https://leetcode.cn/problems/minimum-elements-to-add-to-form-a-given-sum/solutions/100000/gou-cheng-te-ding-he-xu-yao-tian-jia-de-m3gnt)
#### 方法一：上取整

**思路与算法**

我们用 $\textit{sum}$ 表示 $\textit{nums}$ 中所有元素的和，用 $\textit{diff} = |\textit{sum} - \textit{goal}|$ 表示「当前总和」与「目标总和」的差距。

由于添加的元素所需要满足的范围是关于 $0$ 对称的，所以当 $\textit{sum} \gt \textit{goal}$ 时添加负数的情况可以被当做 $\textit{sum} \lt \textit{goal}$ 时添加正数来处理。

接下来计算需要使用多少个不超过 $\textit{limit}$ 的数字来凑齐 $\textit{diff}$，分两种情况：

1. 若 $\textit{limit}$ 整除 $\textit{diff}$，答案是 $\Big\lfloor \dfrac{\textit{diff}}{\textit{limit}} \Big\rfloor$。
2. 若 $\textit{limit}$ 不整除 $\textit{diff}$，答案是 $\Big\lfloor \dfrac{\textit{diff}}{\textit{limit}} \Big\rfloor + 1$。

以上两种情况可以使用一个表达式来计算：$\Big\lfloor \dfrac{\textit{diff} + \textit{limit} - 1}{\textit{limit}} \Big\rfloor$。

**代码**

```Python [sol1-Python3]
class Solution:
    def minElements(self, nums: List[int], limit: int, goal: int) -> int:
        return (abs(sum(nums) - goal) + limit - 1) // limit
```

```C++ [sol1-C++]
class Solution {
public:
    int minElements(vector<int>& nums, int limit, int goal) {
        long long sum = 0;
        for (auto x : nums) {
            sum += x;
        }
        long long diff = abs(sum - goal);
        return (diff + limit - 1) / limit;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minElements(int[] nums, int limit, int goal) {
        long sum = 0;
        for (int x : nums) {
            sum += x;
        }
        long diff = Math.abs(sum - goal);
        return (int) ((diff + limit - 1) / limit);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinElements(int[] nums, int limit, int goal) {
        long sum = 0;
        foreach (int x in nums) {
            sum += x;
        }
        long diff = Math.Abs(sum - goal);
        return (int) ((diff + limit - 1) / limit);
    }
}
```

```go [sol1-Golang]
func minElements(nums []int, limit, goal int) int {
    sum := 0
    for _, x := range nums {
        sum += x
    }
    diff := abs(sum - goal)
    return (diff + limit - 1) / limit
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```JavaScript [sol1-JavaScript]
var minElements = function(nums, limit, goal) {
    const sum = _.sum(nums);
    const diff = Math.abs(sum - goal);
    return Math.abs(Math.floor((diff + limit - 1) / limit));
};
```

```C [sol1-C]
int minElements(int* nums, int numsSize, int limit, int goal) {
    long long sum = 0;
    for (int i = 0; i < numsSize; i++) {
        sum += nums[i];
    }
    long long diff = labs(sum - goal);
    return (diff + limit - 1) / limit;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。整个过程只需要遍历一次 $\textit{nums}$。

- 空间复杂度：$O(1)$。只使用到常数个变量。