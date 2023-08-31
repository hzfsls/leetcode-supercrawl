## [2274.不含特殊楼层的最大连续楼层数 中文官方题解](https://leetcode.cn/problems/maximum-consecutive-floors-without-special-floors/solutions/100000/bu-han-te-shu-lou-ceng-de-zui-da-lian-xu-ktg1)

#### 方法一：排序

**思路与算法**

如果我们将给定的数组 $\textit{special}$ 按照升序排序，那么相邻两个元素之间的楼层就都不是特殊楼层。如果相邻的两个元素分别为 $x, y$，那么非特殊楼层的数量即为 $y-x-1$。

但这样会忽略最开始和结束的非特殊楼层，因此我们可以在排序前将 $\textit{bottom}-1$ 和 $\textit{top}+1$ 也放入数组中，一起进行排序。这样一来，所有 $y-x-1$ 中的最大值即为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxConsecutive(int bottom, int top, vector<int>& special) {
        special.push_back(bottom - 1);
        special.push_back(top + 1);
        sort(special.begin(), special.end());

        int n = special.size();
        int ans = 0;
        for (int i = 0; i < n - 1; ++i) {
            ans = max(ans, special[i + 1] - special[i] - 1);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxConsecutive(self, bottom: int, top: int, special: List[int]) -> int:
        special.extend([bottom - 1, top + 1])
        special.sort()
        
        n = len(special)
        ans = 0
        for i in range(n - 1):
            ans = max(ans, special[i + 1] - special[i] - 1)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{special}$ 的长度。

- 空间复杂度：$O(\log n)$，即为排序需要使用的栈空间。