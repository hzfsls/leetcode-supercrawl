#### 方法一：计算每个人需要的时间

**思路与算法**

为了计算第 $k$ 个人买完票所需的时间，我们可以首先计算在这个过程中**每个人**买票所需要的时间，再对这些时间求和得到答案。

我们可以对每个人的下标 $i$ 分类讨论：

- 如果这个人初始在第 $k$ 个人的前方，或者这个人恰好为第 $k$ 个人，即 $i \le k$，此时在第 $k$ 个人买完票之前他**最多可以**购买 $\textit{tickets}[k]$ 张。考虑到他想要购买的票数，那么他买票所需时间即为 $\min(\textit{tickets}[k], \textit{tickets}[i])$；

- 如果这个人初始在第 $k$ 个人的后方，即 $i > k$，此时在第 $k$ 个人买完票之前他**最多可以**购买 $\textit{tickets}[k] - 1$ 张。考虑到他想要购买的票数，那么他买票所需时间即为 $\min(\textit{tickets}[k] - 1, \textit{tickets}[i])$。

我们遍历每个人的下标，按照上述方式计算并维护每个人买票所需时间之和，即可得到第 $k$ 个人买完票所需的时间，我们返回该值作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int timeRequiredToBuy(vector<int>& tickets, int k) {
        int n = tickets.size();
        int res = 0;
        for (int i = 0; i < n; ++i){
            // 遍历计算每个人所需时间
            if (i <= k){
                res += min(tickets[i], tickets[k]);
            }
            else{
                res += min(tickets[i], tickets[k] - 1);
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def timeRequiredToBuy(self, tickets: List[int], k: int) -> int:
        n = len(tickets)
        res = 0
        for i in range(n):
            # 遍历计算每个人所需时间
            if i <= k:
                res += min(tickets[i], tickets[k])
            else:
                res += min(tickets[i], tickets[k] - 1)
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{tickets}$ 的长度。即为遍历数组计算买票所需总时间的时间复杂度。

- 空间复杂度：$O(1)$。