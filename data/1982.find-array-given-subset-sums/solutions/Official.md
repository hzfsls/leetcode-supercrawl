## [1982.从子集的和还原数组 中文官方题解](https://leetcode.cn/problems/find-array-given-subset-sums/solutions/100000/cong-zi-ji-de-he-huan-yuan-shu-zu-by-lee-aj8o)
#### 方法一：每次还原一个数

**提示 $1$**

对于 $n$ 个数构成的长度为 $2^n$ 的子集和数组 $\textit{sums}$，设 $\textit{sums}$ 中的最小值为 $x$，次小值为 $y$（$x$ 和 $y$ 可以相等），那么 $x-y$ 和 $y-x$ 二者中至少有一个数出现在这 $n$ 个数中。

**提示 $1$ 解释**

显然，$\textit{sums}$ 中的最小值 $x$ 等于这 $n$ 个数中所有负数之和。如果没有负数，$x = 0$。

那么次小值 $y$ 应该等于哪些数之和呢？我们可以知道次小值应该是下面两种情况中的一种：

- 在最小值的基础上，额外选择了一个最小的非负数；

- 在最小值的基础上，移除了一个最大的负数。

其正确性可以使用反证法证明：

> 假设次小值的构成选择了 $p$ 个负数，以及 $q$ 个非负数。如果 $q=0$，说明我们只选择了负数，由于最小值时选择了所有负数，那么次小值一定是移除一个最大的负数。如果 $q>0$，那么 $p$ 一定等于 $n$ 个数中负数的个数（因为选择的负数越多，总和越小），此时 $q$ 一定等于 $1$（因为选择的非负数越多，总和越大），并且选择的这个非负数是 $n$ 个数中最小的非负数。

对于第一种「选择非负数」的情况，这个数的值即为 $y-x$；对于第二种「移除负数」的情况，这个数的值即为 $x-y$。因此 $x-y$ 和 $y-x$ 二者中至少有一个数出现在这 $n$ 个数中。

**提示 $2$**

记 $d = y - x$。

我们可以将这 $2^n$ 个子集和分成两部分 $S$ 和 $T$，每一部分的长度均为 $2^{n-1}$，并且对于任意一个在 $S$ 中出现的子集和 $x_0$，在 $T$ 中一定出现了 $x_0 + d$；同时对于任意一个在 $T$ 中出现的子集和 $y_0$，在 $S$ 中一定出现了 $y_0 - d$。

**提示 $2$ 解释**

对于第一种「选择非负数」的情况，这个数的值即为 $d$。我们考虑两种不同类型的子集和：

- 第一种类型的子集和不包含 $d$，那么我们需要在剩余的 $n-1$ 个数中进行选择，一共有 $2^{n-1}$ 种选择方法，对应的 $2^{n-1}$ 个子集和的集合记为 $S$；

- 第二种类型的子集和包含 $d$，除了 $d$ 以外，我们同样需要在剩余的 $n-1$ 个数中进行选择，一共有 $2^{n-1}$ 种选择方法，对应 $2^{n-1}$ 个子集和的集合记为 $T$。由于 $T$ 中的每个子集和相当于在 $S$ 中选择了一个子集和再加上 $d$，因此是满足提示 $2$ 的。

对于第二种「移除负数」的情况，这个数的值即为 $-d$，讨论是类似的：

- 第一种类型的子集和包含 $-d$，对应的 $2^{n-1}$ 个子集和的集合记为 $S$；

- 第二种类型的子集和不包含 $-d$，对应的 $2^{n-1}$ 个子集和的集合记为 $T$。由于 $T$ 中的每个子集和相当于在 $S$ 中选择了一个子集和再减去 $-d$，因此同样是满足提示 $2$ 的。

对于给定的 $2^n$ 个子集和，要想在实际的代码中得到 $S$ 和 $T$，我们可以将子集和进行升序排序，随后选择最小的子集和 $x_0$ 放入 $S$，那么 $T$ 中就对应着有一个子集和 $x_0 + d$。我们使用双指针或哈希表等数据结构将这两个子集和移除，总计进行 $2^{n-1}$ 次选择即可得到 $S$ 和 $T$。

**思路与算法**

根据提示 $1$ 和提示 $2$，我们就可以设计出还原数组的算法了。

对于 $n$ 个数构成的长度为 $2^n$ 的子集和数组 $\textit{sums}$，设 $\textit{sums}$ 中的最小值为 $x$，次小值为 $y$。记 $d = y - x$，我们使用提示 $2$ 中的方法将 $\textit{sums}$ 分成两个长度为 $2^{n-1}$ 的数组 $S$ 和 $T$。

由于我们并不知道子集和中包含的是 $d$ 还是 $-d$，因此我们需要对 $S$ 和 $T$ 分别进行尝试：

- 如果子集和中包含 $d$，那么 $S$ 中是除了 $d$ 以外的 $n-1$ 个数的子集和，因此我们递归地求解 $(n-1, S)$ 这一子问题；

- 如果子集和中包含 $-d$，那么 $T$ 中是除了 $-d$ 以外的 $n-1$ 个数的子集和，因此我们递归地求解 $(n-1, T)$ 这一子问题。

当我们递归到 $n=1$ 时，$\textit{sums}$ 中包含两个整数，其中一个必然为 $0$，另一个就是我们剩下的最后一个数。如果 $\textit{sums}$ 满足该要求，说明我们递归求解该问题成功，否则失败。

这样做的时间复杂度是多少呢？我们可以列出时间复杂度的递推式。设 $T(n)$ 表示数组长度为 $2^n$ 时需要的时间复杂度，我们需要递归求解两个子问题，每个子问题的时间复杂度为 $T(n-1)$。我们可以提前将数组排好序，这样使用双指针得到 $S$ 和 $T$ 的时间复杂度为 $O(2^n)$，并且 $S$ 和 $T$ 也相应地保持有序。因此有：

$$
\begin{cases}
T(n) = 2 \cdot T(n-1) + O(2^n) \\
T(1) = O(1)
\end{cases}
$$

根据主定理可以得到 $T(n) = O(n \cdot 2^n)$。

初始时将数组 $\textit{sums}$ 进行排序的时间复杂度也为 $O(n \cdot 2^n)$，因此总时间复杂度即为 $O(n \cdot 2^n)$。


**代码**

```C++ [sol1-C++]
class Solution {
private:
    // n 个数构成程度为 2^n 的子集和数组 sums
    // 返回值为空表示无解，否则表示有解
    vector<int> dfs(int n, vector<int>& sums) {
        // 递归到 n=1 时，数组中必然一个为 0，另一个为剩下的最后一个数
        // 如果满足该要求，返回剩下的最后一个数，否则返回表示无解的空数组
        if (n == 1) {
            if (sums[0] == 0) {
                return {sums[1]};
            }
            if (sums[1] == 0) {
                return {sums[0]};
            }
            return {};
        }

        int d = sums[1] - sums[0];
        // 双指针构造 s 和 t
        int left = 0, right = 0;
        vector<int> s, t;
        // 记录每个子集和是否选过
        vector<int> used(1 << n);
        while (true) {
            // left 指针找到最小的未被选择过的子集和
            while (left < (1 << n) && used[left]) {
                ++left;
            }
            if (left == (1 << n)) {
                break;
            }
            s.push_back(sums[left]);
            used[left] = true;
            // right 指针找到 sums[left] + d
            while (used[right] || sums[right] != sums[left] + d) {
                ++right;
            }
            t.push_back(sums[right]);
            used[right] = true;
        }

        // 尝试包含 d 并递归求解 (n-1, s)
        vector<int> ans = dfs(n - 1, s);
        if (!ans.empty()) {
            ans.push_back(d);
            return ans;
        }
        // 尝试包含 -d 并递归求解 (n-1, t)
        ans = dfs(n - 1, t);
        if (!ans.empty()) {
            ans.push_back(-d);
            return ans;
        }
        // 无解返回空数组
        return {};
    }

public:
    vector<int> recoverArray(int n, vector<int>& sums) {
        // 提前将数组排好序
        sort(sums.begin(), sums.end());
        return dfs(n, sums);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def recoverArray(self, n: int, sums):
        # n 个数构成程度为 2^n 的子集和数组 sums
        # 返回值为空表示无解，否则表示有解
        def dfs(n: int, sums: List[int]) -> List[int]:
            # 递归到 n=1 时，数组中必然一个为 0，另一个为剩下的最后一个数
            # 如果满足该要求，返回剩下的最后一个数，否则返回表示无解的空数组
            if n == 1:
                if sums[0] == 0:
                    return [sums[1]]
                if sums[1] == 0:
                    return [sums[0]]
                return []

            d = sums[1] - sums[0]
            # 双指针构造 s 和 t
            left = right = 0
            s, t = list(), list()
            # 记录每个子集和是否选过
            used = set()
            while True:
                # left 指针找到最小的未被选择过的子集和
                while left < (1 << n) and left in used:
                    left += 1
                if left == (1 << n):
                    break
                s.append(sums[left])
                used.add(left)
                # right 指针找到 sums[left] + d
                while right in used or sums[right] != sums[left] + d:
                    right += 1
                t.append(sums[right])
                used.add(right)

            # 尝试包含 d 并递归求解 (n-1, s)
            ans = dfs(n - 1, s)
            if ans:
                return ans + [d]

            # 尝试包含 -d 并递归求解 (n-1, t)
            ans = dfs(n - 1, t)
            if ans:
                return ans + [-d]
            
            # 无解返回空数组
            return []
        
        # 提前将数组排好序
        sums.sort()
        return dfs(n, sums)
```

**复杂度分析**

- 时间复杂度：$O(n \cdot 2^n)$。

- 空间复杂度：$O(2^n)$。空间复杂度可以通过递推式 $S(n) = S(n-1) + O(2^n)$ 得到。

#### 方法二：根据性质选择 $S$ 或 $T$

**思路与算法**

在方法一中，有一步非常重要的决策是：

> 由于我们并不知道子集和中包含的是 $d$ 还是 $-d$，因此我们需要对 $S$ 和 $T$ 分别进行尝试：
>
> - 如果子集和中包含 $d$，那么 $S$ 中是除了 $d$ 以外的 $n-1$ 个数的子集和，因此我们递归地求解 $(n-1, S)$ 这一子问题；
>
> - 如果子集和中包含 $-d$，那么 $T$ 中是除了 $-d$ 以外的 $n-1$ 个数的子集和，因此我们递归地求解 $(n-1, T)$ 这一子问题。

如果我们能够直接确定子集和中包含的是 $d$ 还是 $-d$，就可以省去两路递归的过程了。

本质上来说，确定是 $d$ 还是 $-d$，实际上就是要找出到底 $S$ 和 $T$ 中的哪一个是剩余的 $n-1$ 个数的子集和。我们知道的是，这个子集和一定是包含 $0$ 值的（因为我们可以不选择任何元素），而另一个子集和不一定包含 $0$ 值，因为我们必须选择 $d$ 或 $-d$。

因此，如果 $S$ 和 $T$ 中只有一个集合包含 $0$ 值，我们就能直接确定其就是剩余的 $n-1$ 个数的子集和。如果其为 $S$，原数组中就包含 $d$；如果其为 $T$，原数组中就包含 $-d$。

那么如果 $S$ 和 $T$ 均包含 $0$ 值，我们应该如何进行选择呢？实际上，我们可以选择任意一个，这也是可以证明的：

- 我们规定当 $S$ 和 $T$ 均包含 $0$ 值时，我们一定选择 $S$，并将 $d$ 放入原数组中；

- 如果原数组确实是包含 $d$ 的，那么我们「猜对了」，就不会有任何问题；

- 如果原数组不包含 $d$，那么一定包含 $-d$。此时，$S$ 表示剩余的 $n-1$ 个数的子集和加上 $-d$，但 $S$ 中又有 $0$ 值，因此原数组中一定存在若干个我们还未还原的元素，记为 $o_0, o_1, \cdots, o_{k-1}$，使得：

    $$
    o_0 + o_1 + \cdots + o_{k-1} + o_k = 0
    $$

    成立。这里多出的 $o_k$ 就代表 $-d$。由于这 $k+1$ 个元素之和为 $0$，那么我们将它们全部取相反数，记 $o'_i = -o_i$，那么所有 $o'_i$ 的和仍然为 $0$，并且对于任意的子集和，如果其包含的在 $o_0, \cdots, o_k$ 内的元素的下标集合为 $A$：

    $$
    \sum_{i \in A} o_i = a
    $$

    那么在新的 $o'_0, \cdots, o'_k$ 中，我们只要选择下标的补集 $A' = \{0, 1, \cdots, k\} \backslash A$，那么：

    $$
    \sum_{i \in A'} o'_i = 0 - \sum_{i \in A} o'_i = 0 - (-a) = a
    $$

    这样一来，$o_0, \cdots, o_k$ 在子集和中的选择与 $o'_0, \cdots, o'_k$「一一对应」，即原数组中包含 $o_0, \cdots, o_k$ 与包含 $o'_0, \cdots, o'_k$ 是等价的。而 $o'_k = d$，因此我们一定可以选择 $d$。

证明完成后，我们就可以省去递归的步骤了。因为我们每次都可以根据 $0$ 的位置，确定地选择一个子集和，因此可以将方法一中的递归改写成迭代，使得代码更加直观。同时，这一步的时间复杂度也降低为 $O(2^n)$，可以使用主定理通过递推式：

$$
\begin{cases}
T(n) = T(n-1) + O(2^n) \\
T(1) = O(1)
\end{cases}
$$

求得。但由于排序仍然需要 $O(n \cdot 2^n)$ 的时间，因此算法的总时间复杂度仍然为 $O(n \cdot 2^n)$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<int> recoverArray(int n, vector<int>& sums) {
        // 提前将数组排好序
        sort(sums.begin(), sums.end());

        vector<int> ans;
        for (int i = n; i >= 2; --i) {
            int d = sums[1] - sums[0];
            // 双指针构造 s 和 t
            int left = 0, right = 0;
            vector<int> s, t;
            // 记录每个子集和是否选过
            vector<int> used(1 << i);
            while (true) {
                // left 指针找到最小的未被选择过的子集和
                while (left < (1 << i) && used[left]) {
                    ++left;
                }
                if (left == (1 << i)) {
                    break;
                }
                s.push_back(sums[left]);
                used[left] = true;
                // right 指针找到 sums[left] + d
                while (used[right] || sums[right] != sums[left] + d) {
                    ++right;
                }
                t.push_back(sums[right]);
                used[right] = true;
            }
            if (find(s.begin(), s.end(), 0) != s.end()) {
                // 包含 d 并求解 (n-1, s)
                ans.push_back(d);
                sums = move(s);
            }
            else {
                // 包含 -d 并求解 (n-1, t)
                ans.push_back(-d);
                sums = move(t);
            }
        }
        // 迭代到 n=1 时，数组中必然一个为 0，另一个为剩下的最后一个数
        ans.push_back(sums[0] + sums[1]);
        return ans;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def recoverArray(self, n: int, sums):
        # 提前将数组排好序
        sums.sort()

        ans = list()
        for i in range(n, 1, -1):
            d = sums[1] - sums[0]
            # 双指针构造 s 和 t
            left = right = 0
            s, t = list(), list()
            # 记录每个子集和是否选过
            used = set()
            while True:
                # left 指针找到最小的未被选择过的子集和
                while left < (1 << i) and left in used:
                    left += 1
                if left == (1 << i):
                    break
                s.append(sums[left])
                used.add(left)
                # right 指针找到 sums[left] + d
                while right in used or sums[right] != sums[left] + d:
                    right += 1
                t.append(sums[right])
                used.add(right)

            if 0 in s:
                # 包含 d 并求解 (n-1, s)
                ans.append(d)
                sums = s
            else:
                # 包含 -d 并求解 (n-1, t)
                ans.append(-d)
                sums = t

        # 迭代到 n=1 时，数组中必然一个为 0，另一个为剩下的最后一个数
        ans.append(sums[0] + sums[1])
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \cdot 2^n)$。

- 空间复杂度：$O(2^n)$。