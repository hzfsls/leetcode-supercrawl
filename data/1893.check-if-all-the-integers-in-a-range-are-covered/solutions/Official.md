## [1893.检查是否区域内所有整数都被覆盖 中文官方题解](https://leetcode.cn/problems/check-if-all-the-integers-in-a-range-are-covered/solutions/100000/jian-cha-shi-fou-qu-yu-nei-suo-you-zheng-5hib)
#### 方法一：差分数组

**思路与算法**

为了判断某个区域内所有整数都被覆盖，我们需要对每个整数 $x$ 计算覆盖该整数的区间数量，记作 $\textit{cnt}_x$。

朴素的做法是，遍历 $\textit{ranges}$ 中的所有区间 $[l, r]$，将区间内每个整数的 $\textit{cnt}$ 值加上 $1$。遍历结束后，检查 $[\textit{left},\textit{right}]$ 内的每个整数的 $\textit{cnt}$ 值是否均大于 $0$，是则返回 $\texttt{true}$，否则返回 $\texttt{false}$。

记 $\textit{ranges}$ 的长度为 $n$，需要计算的区间范围为 $l$，则上述做法的时间复杂度为 $O(n\cdot l)$。

下面介绍复杂度为 $O(n + l)$ 的做法。我们可以用差分数组 $\textit{diff}$ 维护**相邻两个整数**的被覆盖区间数量**变化量**，其中 $\textit{diff}[i]$ 对应覆盖整数 $i$ 的区间数量相对于覆盖 $i - 1$ 的区间数量变化量。这样，当遍历到闭区间 $[l, r]$ 时，$l$ 相对于 $l - 1$ 被覆盖区间数量多 $1$，$r + 1$ 相对于 $r$ 被覆盖区间数量少 $1$。对应到差分数组上，我们需要将 $\textit{diff}[l]$ 加上 $1$，并将 $\textit{diff}[r + 1]$ 减去 $1$。

在维护完差分数组 $\textit{diff}$ 后，我们遍历 $\textit{diff}$ 求**前缀和**得出覆盖每个整数的区间数量。下标 $i$ 对应的被覆盖区间数量即为初始数量 $0$ 加上 $[1, i]$ **闭区间**的变化量之和。在计算被覆盖区间数量的同时，我们可以一并判断 $[\textit{left}, \textit{right}]$ 闭区间内的所有整数是否都被覆盖。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool isCovered(vector<vector<int>>& ranges, int left, int right) {
        vector<int> diff(52, 0);   // 差分数组
        for (auto&& range: ranges) {
            ++diff[range[0]];
            --diff[range[1]+1];
        }
        // 前缀和
        int curr = 0;
        for (int i = 1; i <= 50; ++i) {
            curr += diff[i];
            if (i >= left && i <= right && curr <= 0) {
                return false;
            }
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isCovered(int[][] ranges, int left, int right) {
        int[] diff = new int[52];   // 差分数组
        for (int[] range : ranges) {
            ++diff[range[0]];
            --diff[range[1] + 1];
        }
        // 前缀和
        int curr = 0;
        for (int i = 1; i <= 50; ++i) {
            curr += diff[i];
            if (i >= left && i <= right && curr <= 0) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsCovered(int[][] ranges, int left, int right) {
        int[] diff = new int[52];   // 差分数组
        foreach (int[] range in ranges) {
            ++diff[range[0]];
            --diff[range[1] + 1];
        }
        // 前缀和
        int curr = 0;
        for (int i = 1; i <= 50; ++i) {
            curr += diff[i];
            if (i >= left && i <= right && curr <= 0) {
                return false;
            }
        }
        return true;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isCovered(self, ranges: List[List[int]], left: int, right: int) -> bool:
        diff = [0] * 52   # 差分数组
        for l, r in ranges:
            diff[l] += 1
            diff[r+1] -= 1
        # 前缀和
        curr = 0
        for i in range(1, 51):
            curr += diff[i]
            if left <= i <= right and curr <= 0:
                return False
        return True
```

```JavaScript [sol1-JavaScript]
var isCovered = function(ranges, left, right) {
    const diff = new Array(52).fill(0); // 差分数组
    for (const [l, r] of ranges) {
        diff[l]++;
        diff[r + 1]--;
    }
    // 前缀和
    let curr = 0;
    for (let i = 1; i < 51; i++) {
        curr += diff[i];
        if (left <= i && i <= right && curr <= 0) {
            return false;
        }
    }
    return true;
};
```

```go [sol1-Golang]
func isCovered(ranges [][]int, left, right int) bool {
    diff := [52]int{} // 差分数组
    for _, r := range ranges {
        diff[r[0]]++
        diff[r[1]+1]--
    }
    cnt := 0 // 前缀和
    for i := 1; i <= 50; i++ {
        cnt += diff[i]
        if cnt <= 0 && left <= i && i <= right {
            return false
        }
    }
    return true
}
```

```C [sol1-C]
bool isCovered(int** ranges, int rangesSize, int* rangesColSize, int left, int right) {
    int diff[52];  // 差分数组
    memset(diff, 0, sizeof(diff));
    for (int i = 0; i < rangesSize; i++) {
        ++diff[ranges[i][0]];
        --diff[ranges[i][1] + 1];
    }
    // 前缀和
    int curr = 0;
    for (int i = 1; i <= 50; ++i) {
        curr += diff[i];
        if (i >= left && i <= right && curr <= 0) {
            return false;
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n + l)$，其中 $n$ 为 $\textit{ranges}$ 的长度，$l$ 为 $\textit{diff}$ 的长度。初始化 $\textit{diff}$ 数组的时间复杂度为 $O(l)$，遍历 $\textit{ranges}$ 更新差分数组的时间复杂度为 $O(n)$，求解前缀和并判断是否完全覆盖的时间复杂度为 $O(l)$。

- 空间复杂度：$O(l)$，即为 $\textit{diff}$ 的长度。