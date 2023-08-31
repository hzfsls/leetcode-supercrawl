## [1845.座位预约管理系统 中文官方题解](https://leetcode.cn/problems/seat-reservation-manager/solutions/100000/zuo-wei-yu-yue-guan-li-xi-tong-by-leetco-wj45)

#### 方法一：最小堆（优先队列）

**提示 $1$**

考虑 $\textit{reserve}$ 与 $\textit{unreserve}$ 方法对应的需求。什么样的数据结构能够在较好的时间复杂度下支持这些操作？

**思路与算法**

根据 **提示 $1$**，假设我们使用数据结构 $\textit{available}$ 来维护所有可以预约的座位，我们需要分析 $\textit{reserve}$ 与 $\textit{unreserve}$ 的具体需求：

- 对于 $\textit{reserve}$ 方法，我们需要弹出并返回 $\textit{available}$ 中的最小元素；

- 对于 $\textit{unreserve}$ 方法，我们需要将 $\textit{seatNumber}$ 添加至 $\textit{available}$ 中。

因此我们可以使用二叉堆实现的优先队列作为 $\textit{available}$。对于一个最小堆，可以在 $O(\log n)$ 的时间复杂度内完成单次「添加元素」与「弹出最小值」的操作。

需要注意的是，$\texttt{Python}$ 的二叉堆默认为最小堆，但 $\texttt{C++}$ 的二叉堆默认为最大堆。

**代码**

```C++ [sol1-C++]
class SeatManager {
public:
    vector<int> available;

    SeatManager(int n) {
        for (int i = 1; i <= n; ++i){
            available.push_back(i);
        }
    }
    
    int reserve() {
        pop_heap(available.begin(), available.end(), greater<int>());
        int tmp = available.back();
        available.pop_back();
        return tmp;
    }
    
    void unreserve(int seatNumber) {
        available.push_back(seatNumber);
        push_heap(available.begin(), available.end(), greater<int>());
    }
};
```


```Python [sol1-Python3]
from heapq import heappush, heappop

class SeatManager:

    def __init__(self, n: int):
        self.available = list(range(1, n + 1))

    def reserve(self) -> int:
        return heappop(self.available)

    def unreserve(self, seatNumber: int) -> None:
        heappush(self.available, seatNumber)

```


**复杂度分析**

- 时间复杂度：$O(n + (q_1 + q_2)\log n)$，其中 $n$ 为座位的数量，$q_1$ 为 $\textit{reserve}$ 操作的次数，$q_2$ 为 $\textit{unreserve}$ 的次数。初始化的时间复杂度为 $O(n)$，二叉堆实现的优先队列单次添加元素与弹出最小值操作的复杂度均为 $O(\log n)$。

- 空间复杂度：$O(n)$，二叉堆的空间开销。