## [2121.相同元素的间隔之和 中文官方题解](https://leetcode.cn/problems/intervals-between-identical-elements/solutions/100000/xiang-tong-yuan-su-de-jian-ge-zhi-he-by-8r26b)

#### 方法一：数学

**思路与算法**

每个元素与相同数值元素间隔之和的一种方法是遍历 $\textit{arr}$ 数组，判断每个元素是否与 $\textit{arr}[i]$ 相等，并统计间隔之和。但对于每一个元素，统计的时间复杂度均为 $O(n)$，整体时间复杂度为 $O(n^2)$，不符合题目要求。因此我们需要对统计的过程进行优化。

我们用 $\textit{res}$ 数组来维护每个元素与相同数值元素间隔之和。对于数组 $\textit{arr}$ 的第 $i$ 个元素，它与相同数值元素的间隔之和 $\textit{res}[i]$ 为：

$$
\textit{res}[i] = \sum_{j,\ \textit{arr}[j] = \textit{arr}[i]} |i - j|.
$$

我们可以将这些满足 $\textit{arr}[j] = \textit{arr}[i]$ 的下标 $j$ 按照相对于 $i$ 的大小分成两部分，同时将绝对值展开：

$$
\textit{res}[i] = \sum_{j > i,\ \textit{arr}[j] = \textit{arr}[i]} (j - i) + \sum_{j < i,\ \textit{arr}[j] = \textit{arr}[i]} (i - j).
$$

我们不妨设这些下标 $j$ 中小于 $i$ 的有 $n_1$ 个，大于 $i$ 的有 $n_2$ 个，那么我们可以对上式进一步展开：

$$
\begin{aligned}
\textit{res}[i] &= \sum_{j > i,\ \textit{arr}[j] = \textit{arr}[i]} j - n_2 i + n_1 i - \sum_{j < i,\ \textit{arr}[j] = \textit{arr}[i]} j  \\
&= (n_1 - n_2) i  + \sum_{j > i,\ \textit{arr}[j] = \textit{arr}[i]} j - \sum_{j < i,\ \textit{arr}[j] = \textit{arr}[i]} j.
\end{aligned}
$$

我们可以通过降低计算 $n_1, n_2$ 与两个 $j$ 的求和式的时间复杂度以满足时间复杂度的要求。

一种方法是**整体计算**每个 $\textit{res}[i]$ 对应项的数值。

考虑**正向**遍历 $\textit{arr}$ 数组，在遍历的时候利用哈希表维护每个数值迄今为止的**出现次数**和**下标之和**，这样就可以在 $O(n)$ 的时间内计算出每个 $i$ 对应的 $n_1$（即出现次数）与 $\sum_{j < i,\ \textit{arr}[j] = \textit{arr}[i]} j$（即下标之和）。同理，如果我们**反向**遍历 $\textit{arr}$ 数组，也可以在 $O(n)$ 的时间内计算出每个 $i$ 对应的 $n_2$（即出现次数）与 $\sum_{j > i,\ \textit{arr}[j] = \textit{arr}[i]} j$（即下标之和）。那么我们便可以在 $O(n)$ 的时间内计算出所有的 $\textit{res}[i]$。

我们将 $\textit{res}$ 数组的初值均设为 $0$，并对 $\textit{arr}$ 数组进行两次遍历。在每次遍历时**分别维护**以数值为键，**出现次数**为值的哈希表 $\textit{cnt}$ 以及以数值为键，**下标之和**为值的哈希表 $\textit{total}$。具体地：

- 在**正向遍历**到下标 $i$ 时，我们将 $\textit{res}[i]$ 加上 $\textit{cnt}[\textit{arr}[i]] \times i - \textit{total}[\textit{arr}[i]]$，即为 $n_1 i - \sum_{j < i,\ \textit{arr}[j] = \textit{arr}[i]} j$；

- 在**反向遍历**到下标 $i$ 时，我们将 $\textit{res}[i]$ 加上 $\textit{total}[\textit{arr}[i]] - \textit{cnt}[\textit{arr}[i]] \times i$，即为 $\sum_{j > i,\ \textit{arr}[j] = \textit{arr}[i]} j - n_2 i$。

两次遍历完成后，$\textit{res}$ 数组即为 $\textit{arr}$ 中每个元素与相同数值元素间隔之和。我们返回该数组作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<long long> getDistances(vector<int>& arr) {
        int n = arr.size();
        vector<long long> res(n);   // 每个元素与相同元素间隔之和
        unordered_map<int, long long> total;   // 每个数值出现下标之和
        unordered_map<int, int> cnt;   // 每个数值出现次数
        // 正向遍历并更新两个哈希表以及间隔之和数组
        for (int i = 0; i < n; ++i) {
            int val = arr[i];
            if (cnt.count(val)) {
                res[i] += (long long)i * cnt[val] - total[val];
            }
            total[val] += i;
            ++cnt[val];
        }
        // 清空哈希表，反向遍历并更新两个哈希表以及间隔之和数组
        total.clear();
        cnt.clear();
        for (int i = n - 1; i >= 0; --i) {
            int val = arr[i];
            if (cnt.count(val)) {
                res[i] += total[val] - (long long)i * cnt[val];
            }
            total[val] += i;
            ++cnt[val];
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def getDistances(self, arr: List[int]) -> List[int]:
        n = len(arr)
        res = [0] * n   # 每个元素与相同元素间隔之和
        total = defaultdict(int)   # 每个数值出现下标之和
        cnt = defaultdict(int)   # 每个数值出现次数
        # 正向遍历并更新两个哈希表以及间隔之和数组
        for i in range(n):
            val = arr[i]
            if val in cnt:
                res[i] += i * cnt[val] - total[val]
            total[val] += i
            cnt[val] += 1
        # 清空哈希表，反向遍历并更新两个哈希表以及间隔之和数组
        total.clear()
        cnt.clear()
        for i in range(n - 1, -1, -1):
            val = arr[i]
            if val in cnt:
                res[i] += total[val] - i * cnt[val] 
            total[val] += i
            cnt[val] += 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{arr}$ 的长度。即为两次遍历维护哈希表与间隔之和数组的时间复杂度。

- 空间复杂度：$O(n)$，即为遍历时维护出现次数与下标之和的两个哈希表的空间开销。