## [2064.分配给商店的最多商品的最小值 中文官方题解](https://leetcode.cn/problems/minimized-maximum-of-products-distributed-to-any-store/solutions/100000/fen-pei-gei-shang-dian-de-zui-duo-shang-g0nc2)
#### 方法一：二分查找

**提示 $1$**

随着分配给商店的最多商品数增加，至少需要的商店数会减小。

**思路与算法**

根据 **提示 $1$**，我们可以用二分的方法寻找在遵守规则的情况下，分配给商店的最多商品数的**最小值**。

由于商品数一定非零，因此二分的下界为 $1$；同时由于一间商店至多只能有一种商品，因此二分的上界为 $\textit{quantities}$ 数组的最大值。在二分查找的每一步中，我们需要解决一个**判定问题**，即：

> 当分配给商店的最多商品数为 $x$ 时，能否根据规则将所有商品分配完？

对于上述的判定问题，我们可以计算出按规则分配完所有商品**最少需要的商店数量**。对于某种数量为 $q$ 的商品，所需要的最少商店数量为 

$$
\left\lceil \frac{q}{x} \right\rceil,
$$

其中 $\lceil \dots \rceil$ 为向上取整。同理，分配完所有商品最少需要的商店数量即为：

$$
\sum_i \left\lceil \frac{q_i}{x} \right\rceil,
$$

其中 $q_i$ 为 $\textit{quantities}$ 数组中下标为 $i$ 的元素，即第 $i$ 种商品的数目。如果该数量小于等于 $n$，那么根据题意，一定存在至少一种分法将所有商品按规则分配完（注意有的商店可以分配 $0$ 件商品）；反之，如果该数量大于 $n$，那么一定不存在分配完成的方法。

我们用函数 $\textit{check}(x)$ 来计算上述的判定问题，当该问题为真是返回 $\texttt{true}$，反之返回 $\texttt{false}$。同时，我们利用二分查找来确定使得判定问题为真的最小的 $x$，并返回该值作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimizedMaximum(int n, vector<int>& quantities) {
        // 判定问题
        auto check = [&](int x) -> bool{
            // 计算所需商店数量的最小值，并与商店数量进行比较
            int cnt = 0;
            for (int q: quantities){
                cnt += (q - 1) / x + 1; 
            }
            return cnt <= n;
        };
        
        int l = 1, r = *max_element(quantities.begin(), quantities.end()) + 1;
        // 二分查找寻找最小的使得判定问题为真的 x
        while (l < r){
            int mid = l + (r - l) / 2;
            if (check(mid)){
                r = mid;
            }
            else{
                l = mid + 1;
            }
        }
        return l;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def minimizedMaximum(self, n: int, quantities: List[int]) -> int:
        # 判定问题
        def check(x: int) -> bool:
            # 计算所需商店数量的最小值，并与商店数量进行比较
            cnt = 0
            for q in quantities:
                cnt += (q - 1) // x + 1
            return cnt <= n
        
        l, r = 1, max(quantities) + 1
        # 二分查找寻找最小的使得判定问题为真的 x
        while l < r:
            mid = l + (r - l) // 2
            if check(mid):
                r = mid
            else:
                l = mid + 1
        return l
```


**复杂度分析**

- 时间复杂度：$O(m\log \max_i q_i)$，其中 $m$ 为 $\textit{quantities}$ 的长度， $\max_i q_i$ 为 $\textit{quantities}$ 中元素的最大值。每一次二分查找都需要 $O(m)$ 的时间计算需要的商店数的最小值。

- 空间复杂度：$O(1)$。