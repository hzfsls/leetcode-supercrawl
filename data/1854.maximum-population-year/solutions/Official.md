## [1854.人口最多的年份 中文官方题解](https://leetcode.cn/problems/maximum-population-year/solutions/100000/ren-kou-zui-duo-de-nian-fen-by-leetcode-5m7r4)

#### 方法一：差分数组

**提示 $1$**

遍历每个人的出生与死亡年份，并维护每一年的人口**变化量**。

**提示 $1$ 解释**

首先，每个人对于人口数量的影响是独立的，因此我们可以独立地考虑每个人对人口数量的影响。

其次，每个人只在他的出生与死亡年份对人口数量有所影响，而这个影响体现在人口数量的变化量上。

最后，在给定人口初值与每一年人口变化量的基础上，我们可以将对应的变化量求和得到每一年的人口数量，进而得到人口最多的年份。

这种考虑数量「变化量」的方法也被称为「差分」方法，而对应的数组叫做「差分数组」。而将变化量转换为对应数量的过程正是求解「前缀和」的方法，因此「差分」也是「前缀和」的逆运算。如果读者不熟悉「差分数组」及其相关用法，可以在解决本题的同时尝试以下题目：

- [370. 区间加法](https://leetcode-cn.com/problems/range-addition/)

- [1094. 拼车](https://leetcode-cn.com/problems/car-pooling/)

- [1109. 航班预订统计](https://leetcode-cn.com/problems/corporate-flight-bookings/)


**思路与算法**

我们用 $\textit{delta}$ 数组维护每一年的人口变化量。由于题目中起始年份为 $1950$，我们希望数组的起始下标对应起始年份，并且年份与数组下标一一对应，因此我们需要引入起始年份与数组起始下标之差 $\textit{offset} = 1950$，使得下标 $i$ 对应 $i + \textit{offset}$ 年。

在遍历 $\textit{logs}$ 的时候，我们需要将每个人出生年份对应的变化量加上 $1$，同时将死亡年份对应的变化量减去 $1$。

最终我们可以遍历 $\textit{delta}$ 求出每一年的人口数量并维护最大值和对应的最小下标。下标为 $i$ 对应年份的人口数量即为初始人口数量 $0$ 加上 $[0, i]$ **闭区间**的人口变化量之和。在找到最小下标后，我们需要加上对应的 $\textit{offset}$ 转回对应的年份。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int offset = 1950;   // 起始年份与起始下标之差
    
public:
    int maximumPopulation(vector<vector<int>>& logs) {
        vector<int> delta(101, 0);   // 变化量
        for (auto&& log: logs) {
            ++delta[log[0]-offset];
            --delta[log[1]-offset];
        }
        int mx = 0;   // 人口数量最大值
        int res = 0;   // 最大值对应的最小下标
        int curr = 0;   // 每一年的人口数量
        // 前缀和
        for (int i = 0; i < 101; ++i){
            curr += delta[i];
            if (curr > mx){
                mx = curr;
                res = i;
            }
        }
        return res + offset;   // 转回对应的年份
    }
};
```


```Python [sol1-Python3]
class Solution:
    def maximumPopulation(self, logs: List[List[int]]) -> int:
        delta = [0] * 101   # 变化量
        offset = 1950   # 起始年份与起始下标之差
        for b, d in logs:
            delta[b-offset] += 1
            delta[d-offset] -= 1
        mx = 0   # 人口数量最大值
        res = 0   # 最大值对应的最小下标
        curr = 0   # 每一年的人口数量
        # 前缀和
        for i in range(101):
            curr += delta[i]
            if curr > mx:
                mx = curr
                res = i
        return res + offset   # 转回对应的年份
```

**复杂度分析**

- 时间复杂度：$O(m + n)$，其中 $m$ 为 $\textit{logs}$ 的长度，$n$ 为年份的跨度。建立变化量数组的时间复杂度为 $O(n)$，维护变化量数组的时间复杂度为 $O(m)$，遍历维护最大值的时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，即为变化量数组的空间开销。