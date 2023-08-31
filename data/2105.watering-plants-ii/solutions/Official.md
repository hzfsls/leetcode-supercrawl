## [2105.给植物浇水 II 中文官方题解](https://leetcode.cn/problems/watering-plants-ii/solutions/100000/gei-zhi-wu-jiao-shui-ii-by-leetcode-solu-5cki)
#### 方法一：模拟

**思路与算法**

我们可以模拟 $\textit{Alice}$ 与 $\textit{Bob}$ 浇水的过程，并在模拟的过程中统计重新灌满水罐的次数。

我们用 $\textit{pos}_a, \textit{pos}_b$ 分别表示 $\textit{Alice}$ 与 $\textit{Bob}$ 当前所在植物的下标，并用 $\textit{val}_a, \textit{val}_b$ 分别表示两人水罐中的剩余水量。我们用 $n$ 表示植物的数量，当模拟开始时，$\textit{Alice}$ 与 $\textit{Bob}$ 的位置满足 $\textit{pos}_a = 0, \textit{pos}_b = n - 1$；剩余水量满足 $\textit{val}_a = \textit{capacity}_a, \textit{val}_b = \textit{capacity}_b$。

当 $\textit{Alice}$ 与 $\textit{Bob}$ **相遇前**的每一个时刻，我们需要模拟两人对当前位置植物浇水的过程。以 $\textit{Alice}$ 为例，我们比较当前剩余水量 $\textit{val}_a$ 与植物所需水量 $\textit{plants}[\textit{pos}_a]$ 的大小，此时会有两种情况：

- 如果剩余水量大于等于植物所需水量，即 $\textit{val}_a \ge \textit{plants}[\textit{pos}_a]$，此时不需要重新灌满水罐，浇水后剩余水量变为 $\textit{val}_a - \textit{plants}[\textit{pos}_a]$；

- 如果剩余水量小于等于植物所需水量，即 $\textit{val}_a < \textit{plants}[\textit{pos}_a]$，此时需要先重新灌满水罐，**我们需要将重新灌满水罐的次数加上 $1$**，浇水后剩余水量等于水罐容积减去植物所需水量，即 $\textit{capacity}_a - \textit{plants}[\textit{pos}_a]$。

在浇水操作后，我们需要将 $\textit{Alice}$ 与 $\textit{Bob}$ 分别移动至下一株植物的位置，即 $\textit{pos}_a$ 变为 $\textit{pos}_a + 1$， $\textit{pos}_b$ 变为 $\textit{pos}_b - 1$。

当 $\textit{Alice}$ 与 $\textit{Bob}$ **相遇后**，此时根据 $n$ 的奇偶性会有两种情况：

- $n$ 为偶数，相遇后两人所在位置都被浇过水，因此无需任何操作；

- $n$ 为奇数，两人位置重合，且该位置植物未被浇水，此时需要先比较两人的剩余水量，再进行上文的浇水操作并维护重新灌满次数：如果 $\textit{val}_a \ge \textit{val}_b$，则 $\textit{Alice}$ 浇水，反之则 $\textit{Bob}$ 浇水。

事实上，对于可能的最后一步操作，我们只需要判断是否需要重新灌满水罐并维护对应次数即可。

模拟结束后，我们返回统计的重新灌满水罐次数作为答案。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumRefill(vector<int>& plants, int capacityA, int capacityB) {
        int res = 0;   // 灌满水罐次数
        int n = plants.size();   // 两人位置
        int posa = 0, posb = n - 1;   // 两人剩余水量
        int vala = capacityA, valb = capacityB;
        // 模拟相遇前的浇水过程
        while (posa < posb) {
            if (vala < plants[posa]) {
                ++res;
                vala = capacityA - plants[posa];
            }
            else {
                vala -= plants[posa];
            }
            ++posa;
            if (valb < plants[posb]) {
                ++res;
                valb = capacityB - plants[posb];
            }
            else {
                valb -= plants[posb];
            }
            --posb;
        }
        // 模拟相遇后可能的浇水过程
        if (posa == posb) {
            if (vala >= valb && vala < plants[posa]) {
                ++res;
            }
            if (vala < valb && valb < plants[posb]) {
                ++res;
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def minimumRefill(self, plants: List[int], capacityA: int, capacityB: int) -> int:
        res = 0   # 灌满水罐次数
        n = len(plants)
        posa, posb = 0, n - 1   # 两人位置
        vala, valb = capacityA, capacityB   # 两人剩余水量
        # 模拟相遇前的浇水过程
        while posa < posb:
            if vala < plants[posa]:
                res += 1
                vala = capacityA - plants[posa]
            else:
                vala -= plants[posa]
            posa += 1
            if valb < plants[posb]:
                res += 1
                valb = capacityB - plants[posb]
            else:
                valb -= plants[posb]
            posb -= 1
        # 模拟相遇后可能的浇水过程
        if posa == posb:
            if vala >= valb and vala < plants[posa]:
                res += 1
            elif vala < valb and valb < plants[posb]:
                res += 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{plants}$ 的长度。模拟浇水过程并统计重新灌满水罐次数的时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。