## [1375.二进制字符串前缀一致的次数 中文官方题解](https://leetcode.cn/problems/number-of-times-binary-string-is-prefix-aligned/solutions/100000/er-jin-zhi-zi-fu-chuan-qian-zhui-yi-zhi-6qjol)
#### 方法一：记录翻转位置的最大值

**思路与算法**

在第 $i$ 次翻转之后，我们希望 $[1, i]$ 内的所有位都是 $1$，这等价于「前 $i$ 次翻转中下标的最大值等于 $i$」。

因此，我们对数组 $\textit{flip}$ 进行遍历，同时记录翻转下标的最大值。当遍历到位置 $i$ 时，如果最大值恰好等于 $i$，那么答案加 $1$。

需要注意数组的下标是从 $0$ 开始的，因此在实际的代码编写中，判断的值为 $i+1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numTimesAllBlue(vector<int>& flips) {
        int n = flips.size();
        int ans = 0, right = 0;
        for (int i = 0; i < n; ++i) {
            right = max(right, flips[i]);
            if (right == i + 1) {
                ++ans;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numTimesAllBlue(int[] flips) {
        int n = flips.length;
        int ans = 0, right = 0;
        for (int i = 0; i < n; ++i) {
            right = Math.max(right, flips[i]);
            if (right == i + 1) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumTimesAllBlue(int[] flips) {
        int n = flips.Length;
        int ans = 0, right = 0;
        for (int i = 0; i < n; ++i) {
            right = Math.Max(right, flips[i]);
            if (right == i + 1) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numTimesAllBlue(self, flips: List[int]) -> int:
        ans = right = 0
        for i, flip in enumerate(flips):
            right = max(right, flips[i])
            if right == i + 1:
                ans += 1
        return ans
```

```Golang [sol1-Golang]
func numTimesAllBlue(flips []int) int {
    n, ans, right := len(flips), 0, 0
    for i := 0; i < n; i++ {
        if flips[i] > right {
            right = flips[i]
        }
        if right == i + 1 {
            ans++
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var numTimesAllBlue = function(flips) {
    const n = flips.length;
    let ans = 0, right = 0;
    for (let i = 0; i < n; ++i) {
        right = Math.max(right, flips[i]);
        if (right === i + 1) {
            ++ans;
        }
    }
    return ans;
};
```

```C [sol1-C]
int numTimesAllBlue(int* flips, int flipsSize) {
    int n = flipsSize;
    int ans = 0, right = 0;
    for (int i = 0; i < n; ++i) {
        right = fmax(right, flips[i]);
        if (right == i + 1) {
            ++ans;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{flips}$ 的长度。

- 空间复杂度：$O(1)$。