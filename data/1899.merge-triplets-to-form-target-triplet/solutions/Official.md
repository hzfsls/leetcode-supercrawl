## [1899.合并若干三元组以形成目标三元组 中文官方题解](https://leetcode.cn/problems/merge-triplets-to-form-target-triplet/solutions/100000/he-bing-ruo-gan-san-yuan-zu-yi-xing-chen-8ypf)

#### 方法一：合并尽可能多的三元组

**提示 $1$**

设数组 $\textit{triplets}$ 的长度为 $n$。

题目等价于让我们选择若干个下标 $i_1, i_2, \cdots, i_k$，且 $i_1 < i_2 < \cdots < i_k \leq n$，使得：

$$
\begin{cases}
x = \max \{ a_{i_1}, a_{i_2}, \cdots, a_{i_k} \} \\
y = \max \{ b_{i_1}, b_{i_2}, \cdots, b_{i_k} \} \\
z = \max \{ c_{i_1}, c_{i_2}, \cdots, c_{i_k} \}
\end{cases}
$$

这里的正确性在于，我们每次执行的操作是选择两个三元组每一个位置中的较大值，因此：

- 同一个下标对应的三元组选择多次是没有意义的，每个三元组会被选择 $0$ 或 $1$ 次；

- 选择三元组的顺序也是可以任意交换的。

**提示 $2$**

对于任意一个三元组 $(a_i, b_i, c_i)$：

- 如果 $a_i > x$ 或者 $b_i > y$ 或者 $c_i > z$，那么选择该三元组是不合理的；
- 否则，一定有 $a_i \leq x$ 并且 $b_i \leq y$ 并且 $c_i \leq z$。由于所有的操作都是 $\max$ 操作，因此选择这个三元组并没有什么坏处，它不会让我们原本得到 $(a_i, b_i, c_i)$ 的某种可行选择变得不可行，因为：

    $$
    \big( \max\{x, a_i\}, \max\{y, b_i\}, \max\{z, c_i\} \big) = (x, y, z)
    $$

    是显然成立的。

**思路与算法**

根据提示 $2$，我们只需要遍历所有的三元组，如果 $a_i \leq x$ 并且 $b_i \leq y$ 并且 $c_i \leq z$，那么我们就选择该三元组。

设 $a, b, c$ 分别是我们选择的所有三元组 $a_i, b_i, c_i$ 中的最大值。在遍历结束后，如果有：

$$
(a, b, c) = (x, y, z)
$$

则返回 $\text{true}$，否则返回 $\text{false}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool mergeTriplets(vector<vector<int>>& triplets, vector<int>& target) {
        int x = target[0], y = target[1], z = target[2];
        int a = 0, b = 0, c = 0;

        for (const auto& triplet: triplets) {
            int ai = triplet[0], bi = triplet[1], ci = triplet[2];
            if (ai <= x && bi <= y && ci <= z) {
                tie(a, b, c) = tuple{max(a, ai), max(b, bi), max(c, ci)};
            }
        }

        return tie(a, b, c) == tie(x, y, z);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def mergeTriplets(self, triplets: List[List[int]], target: List[int]) -> bool:
        x, y, z = target
        a, b, c = 0, 0, 0
        
        for ai, bi, ci in triplets:
            if ai <= x and bi <= y and ci <= z:
                a, b, c = max(a, ai), max(b, bi), max(c, ci)
        
        return (a, b, c) == (x, y, z)
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{triples}$ 的长度。

- 空间复杂度：$O(1)$。