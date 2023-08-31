## [1898.可移除字符的最大数目 中文官方题解](https://leetcode.cn/problems/maximum-number-of-removable-characters/solutions/100000/ke-yi-chu-zi-fu-de-zui-da-shu-mu-by-leet-9ve9)
#### 方法一：二分查找转化为判定问题

**提示 $1$**

如果移除 $\textit{removable}$ 中的前 $k + 1$ 个下标后 $p$ 依旧是 $s$ 的子序列，那么移除前 $k$ 个下标后依旧成立。

**提示 $1$ 解释**

假设移除前 $k$ 个下标后的字符串为 $s_k$，那么 $s_k$ 可以通过对 $s_{k+1}$ 添加一个字符得到，亦即 $s_{k+1}$ 是 $s_k$ 的子序列。那么如果 $p$ 是 $s_{k+1}$ 的子序列，则它一定也是 $s_k$ 的子序列。

**思路与算法**

根据 **提示 $1$**，$p$ 是否为 $s_k$ 子序列这个**判定问题**如果对于某个 $k$ 成立，那么它对于 $[0, k]$ 闭区间内的所有整数均成立。这也就说明这个判定问题对于 $k$ 具有**二值性**。因此我们可以通过二分查找确定使得该判定问题成立的**最大**的 $k$。

对于移除 $k$ 个下标时的判定问题，我们引入辅助函数 $\textit{check}(k)$ 来判断。

在辅助函数 $\textit{check}(k)$ 中，我们可以用数组 $\textit{state}$ 来维护 $s$ 中的每个字符是否被删除，其中 $1$ 代表未删除，$0$ 代表已删除。我们将 $\textit{state}$ 的所有元素初始化为 $1$，随后遍历 $\textit{removable}$ 中的前 $k$ 个元素并将下标对应的状态置为 $0$。

而判断 $p$ 是否为 $s_k$ 的子序列，我们可以用双指针的方法从左至右贪心匹配两个子序列的相同字符。在遍历到 $s[i]$ 时，我们需要在 $\textit{state}$ 中检查该字符是否被删除以决定是否应当尝试匹配。对于相关方法的细节与正确性证明，读者可以参考[「392. 判断子序列」的官方题解](https://leetcode-cn.com/problems/is-subsequence/solution/pan-duan-zi-xu-lie-by-leetcode-solution/)。

最终，我们将判定问题的答案作为 $\textit{check}(k)$ 的返回值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximumRemovals(string s, string p, vector<int>& removable) {
        int ns = s.size();
        int np = p.size();
        int n = removable.size();
        // 辅助函数，用来判断移除 k 个下标后 p 是否是 s_k 的子序列
        auto check = [&](int k) -> bool {
            vector<int> state(ns, 1);   // s 中每个字符的状态
            for (int i = 0; i < k; ++i){
                state[removable[i]] = 0;
            }
            // 匹配 s_k 与 p 
            int j = 0;
            for (int i = 0; i < ns; ++i){
                // s[i] 未被删除且与 p[j] 相等时，匹配成功，增加 j
                if (state[i] && s[i] == p[j]){
                    ++j;
                    if (j == np){
                        return true;
                    }
                }
            }
            return false;
        };

        // 二分查找
        int l = 0;
        int r = n + 1;
        while (l < r){
            int mid = l + (r - l) / 2;
            if (check(mid)){
                l = mid + 1;
            }
            else{
                r = mid;
            }
        }
        return l - 1;

    }
};
```

```Python [sol1-Python3]
class Solution:
    def maximumRemovals(self, s: str, p: str, removable: List[int]) -> int:
        ns, np = len(s), len(p)
        n = len(removable)
        # 辅助函数，用来判断移除 k 个下标后 p 是否是 s_k 的子序列
        def check(k: int) -> bool:
            state = [True] * ns   # s 中每个字符的状态
            for i in range(k):
                state[removable[i]] = False
            # 匹配 s_k 与 p 
            j = 0
            for i in range(ns):
                # s[i] 未被删除且与 p[j] 相等时，匹配成功，增加 j
                if state[i] and s[i] == p[j]:
                    j += 1
                    if j == np:
                        return True
            return False
        
        # 二分查找
        l, r = 0, n + 1
        while l < r:
            mid = l + (r - l) // 2
            if check(mid):
                l = mid + 1
            else:
                r = mid
        return l - 1
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 为 $s$ 的长度。我们需要进行 $O(\log n)$ 次二分查找，每次二分查找中，判断是否为子序列的时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，即为二分查找时 $\textit{state}$ 数组的空间开销。