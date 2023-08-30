#### 方法一：递归法枚举子集

**思路与算法**

我们用函数 $\textit{dfs}(\textit{val}, \textit{idx})$ 来递归枚举数组 $\textit{nums}$ 的子集。其中 $\textit{val}$ 代表当前选取部分的异或值，$\textit{idx}$ 代表递归的当前位置。

我们用 $n$ 来表示 $\textit{nums}$ 的长度。在进入 $\textit{dfs}(\textit{val}, \textit{idx})$ 时，数组中 $[0,\textit{idx} - 1]$ 部分的选取情况是已经确定的，而 $[\textit{idx}, n)$ 部分的选取情况还未确定。我们需要确定 $\textit{idx}$ 位置的选取情况，然后求解子问题 $\textit{dfs}(\textit{val'}, \textit{idx} + 1)$。

此时选取情况有两种：

- 选取，此时 $\textit{val'} = \textit{val} \oplus \textit{nums}[\textit{idx}]$，其中 $\oplus$ 代表异或运算；

- 不选取，此时 $\textit{val'} = \textit{val}$。

当 $\textit{idx} = n$ 时，递归结束。与此同时，我们维护这些子集异或总和 $\textit{val}$ 的和。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int res;
    int n;
    
    void dfs(int val, int idx, vector<int>& nums){
        if (idx == n){
            // 终止递归
            res += val;
            return;
        }
        // 考虑选择当前数字
        dfs(val ^ nums[idx], idx + 1, nums);
        // 考虑不选择当前数字
        dfs(val, idx + 1, nums);
    }
    
    int subsetXORSum(vector<int>& nums) {
        res = 0;
        n = nums.size();
        dfs(0, 0, nums);
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def subsetXORSum(self, nums: List[int]) -> int:
        res = 0
        n = len(nums)
        def dfs(val, idx):
            nonlocal res
            if idx == n:
                # 终止递归
                res += val
                return
            # 考虑选择当前数字
            dfs(val ^ nums[idx], idx + 1)
            # 考虑不选择当前数字
            dfs(val, idx + 1)
        
        dfs(0, 0)
        return res
```

**复杂度分析**

- 时间复杂度：$O(2^n)$，其中 $n$ 为 $\textit{nums}$ 的长度。

    第 $\textit{idx}$ 层的递归函数共有 $2^\textit{idx}$ 个，总计共会调用 $\sum_{i = 0}^n 2^i = 2^{n+1} - 1$ 次递归函数。而每个递归函数的时间复杂度均为 $O(1)$。

- 空间复杂度：$O(n)$，即为递归时的栈空间开销。

#### 方法二：迭代法枚举子集

**提示 $1$**

一个长度为 $n$ 的数组 $\textit{nums}$ 有 $2^n$ 个子集（包括空集与自身）。我们可以将这些子集一一映射到 $[0, 2^n-1]$ 中的整数。

**提示 $2$**

数组中的每个元素都有「选取」与「未选取」两个状态，可以对应一个二进制位的 $1$ 与 $0$。那么对于一个长度为 $n$ 的数组 $\textit{nums}$，我们也可以用 $n$ 个二进制位的整数来唯一表示每个元素的选取情况。此时该整数第 $j$ 位的取值表示数组第 $j$ 个元素是否包含在对应的子集中。

**思路与算法**

我们也可以用迭代来实现子集枚举。

根据 **提示 $1$** 与 **提示 $2$**，我们枚举 $[0, 2^n-1]$ 中的整数 $i$，其第 $j$ 位的取值表示 $\textit{nums}$ 的第 $j$ 个元素是否包含在对应的子集中。

对于每个整数 $i$，我们遍历它的每一位计算对应子集的异或总和，并维护这些值之和。


**代码**

```C++ [sol2-C++]
class Solution {
public:
    int subsetXORSum(vector<int>& nums) {
        int res = 0;
        int n = nums.size();
        for (int i = 0; i < (1 << n); ++i){   // 遍历所有子集
            int tmp = 0;
            for (int j = 0; j < n; ++j){   // 遍历每个元素
                if (i & (1 << j)){
                    tmp ^= nums[j];
                }
            }
            res += tmp;
        }
        return res;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def subsetXORSum(self, nums: List[int]) -> int:
        res = 0
        n = len(nums)
        for i in range(1 << n):   # 遍历所有子集
            tmp = 0
            for j in range(n):   # 遍历每个元素
                if i & (1 << j):
                    tmp ^= nums[j]
            res += tmp
        return res
```

**复杂度分析**

- 时间复杂度：$O(n2^n)$，其中 $n$ 为 $\textit{nums}$ 的长度。我们遍历了 $\textit{nums}$ 的 $2^n$ 个子集，每个子集需要 $O(n)$ 的时间计算异或总和。

- 空间复杂度：$O(1)$。


#### 方法三：按位考虑 + 二项式展开

**提示 $1$**

由于异或运算本质上是按位操作，因此我们可以按位考虑取值情况。

**提示 $2$**

对于数组中所有元素的某一位，存在两种可能：

- 第一种，所有元素该位都为 $0$；

- 第二种，至少有一个元素该位为 $1$。

假设数组元素个数为 $n$，那么第一种情况下，所有子集异或总和中该位均为 $0$；第二种情况下，所有子集异或总和中该位为 $0$ 的个数与为 $1$ 的个数相等，均为 $2^{n-1}$。

**提示 $2$ 解释**

首先，一个子集的异或总和中某位为 $0$ 当且仅当子集内该位为 $1$ 的元素数量为偶数（包括 $0$），某位为 $1$ 当且仅当子集内该位为 $1$ 的元素数量为奇数。那么第一种情况时显然所有子集的异或总和中该位都为 $0$。

其次，假设数组内某一位为 $1$ 的元素个数为 $m$，那么它的子集里面包含 $k$ 个 $1$ 的数量为（$k \le m \le n$）：

$$
2^{n-m}\binom{k}{m},
$$

那么包含奇数个 $1$ 的子集数量为：

$$
\sum_{k\ \text{is odd}, 0\le k\le m}2^{n-m}\binom{k}{m} = 2^{n-m}\sum_{k\ \text{is odd}, 0\le k\le m}\binom{k}{m},
$$

同理，包含偶数个 $1$ 的子集数量为：

$$
\sum_{k\ \text{is even}, 0\le k\le m}2^{n-m}\binom{k}{m} = 2^{n-m}\sum_{k\ \text{is even}, 0\le k\le m}\binom{k}{m}.
$$

事实上，我们通过对于 $(x + 1)^m$ 二项式展开并取 $x = -1$ 时，有：

$$
(-1+1)^m = \sum_{k = 0}^{m} \binom{k}{m} (-1)^k 1^{m-k} = \sum_{k\ \text{is even}, 0\le k\le m}\binom{k}{m} - \sum_{k\ \text{is odd}, 0\le k\le m}\binom{k}{m} = 0.
$$

这也就说明，包含奇数个 $1$ 的子集数量与包含偶数个 $1$ 的子集数量相等，均为全体子集数量的一半，即 $2^{n-1}$。

**思路与算法**

根据 **提示 $2$**，我们用 $\textit{res}$ 来维护数组全体元素的**按位或**，使得 $\textit{res}$ 的某一位为 $1$ 当且仅当数组中存在该位为 $1$ 的元素。

那么，对于 $\textit{res}$ 中为 $1$ 的任何一位，其对于结果的贡献均为该位对应的值乘上异或总和为 $1$ 的子集数量 $2^{n-1}$；对于为 $0$ 的任何一位，乘上 $2^{n-1}$ 也不会对结果产生影响。因此我们可以直接将 $\textit{res}$ 算术左移 $n - 1$ 位作为结果返回。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    int subsetXORSum(vector<int>& nums) {
        int res = 0;
        int n = nums.size();
        for (auto num: nums){
            res |= num;
        }
        return res << (n - 1);
    }
};
```

```Python [sol3-Python3]
class Solution:
    def subsetXORSum(self, nums: List[int]) -> int:
        res = 0
        n = len(nums)
        for num in nums:
            res |= num
        return res << (n - 1)
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度，即为一遍遍历数组的时间复杂度。

- 空间复杂度：$O(1)$。