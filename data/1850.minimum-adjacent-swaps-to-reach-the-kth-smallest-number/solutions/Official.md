#### 方法一：模拟 + 贪心

**前言**

本题是一道由两个经典模型进行拼接得到的题目。

第一步我们需要求出比 $\textit{num}$ 大的第 $k$ 个排列 $\textit{num}_k$。

第二步我们需要将 $\textit{num}$ 通过交换操作得到 $\textit{num}_k$，每一步交换操作只能交换相邻的两个字符。

**思路与算法**

对于第一步而言，可以参考[「31. 下一个排列」的官方题解](https://leetcode-cn.com/problems/next-permutation/solution/xia-yi-ge-pai-lie-by-leetcode-solution/)，只需要做 $k$ 次即可，这里不再赘述。

对于第二步而言，我们可以使用贪心的方法得到最少的交换次数。具体地，我们对 $\textit{num}$ 和 $\textit{num}_k$ 同时进行遍历，设当前遍历到位置 $i$：

- 如果 $\textit{num}[i] = \textit{num}_k[i]$，那么无需进行任何交换；

- 如果 $\textit{num}[i] \neq \textit{num}_k[i]$，那么我们需要找一个出现在 $\textit{num}[i]$ 之后的字符 $\textit{num}[j]$，使得 $\textit{num}[j] = \textit{num}_k[i]$，然后将 $\textit{num}[j]$ 经过 $j-i$ 次交换操作，交换到位置 $i$。如果多个满足要求的 $\textit{num}[j]$，我们一定贪心地选择 $j$ 最小的那个，其正确性在后文有详细的证明。

当我们遍历完成之后，我们就将 $\textit{num}$ 交换到与 $\textit{num}_k$ 一致，交换的次数即为答案。

**证明**

假设 $\textit{num}_k$ 中的任意两个字符均不相同，那么我们可以将其中的字符进行「重编号」，即出现在首位的字符最小，出现在第二个位置的字符次小，以此类推。这样一来：

- $\textit{num}_k$ 可以是一个 $1, 2, \cdots, n$ 的序列，而 $\textit{num}$ 可以看成是 $1, 2, \cdots, n$ 的一个排列。

要想将 $\textit{num}$ 通过交换相邻的字符得到 $\textit{num}_k$，等价于将 $\textit{num}$ 对应的排列恢复成 $1, 2, \cdots, n$。

我们可以通过 $\textit{num}$ 包含的「逆序对」的数量来得到最少的交换次数。在每一次交换操作中，设我们交换的是 $\textit{num}[i]$ 和 $\textit{num}[i+1]$：

- 如果 $\textit{num}[i] < \textit{num}[i+1]$，那么 $\textit{num}$ 包含的逆序对数量会增加 $1$；

- 如果 $\textit{num}[i] > \textit{num}[i+1]$，那么 $\textit{num}$ 包含的逆序对数量会减少 $1$。

由于逆序对为 $0$ 是排列是唯一的，即 $1, 2, \cdots, n$，那么我们的目标等价于将 $\textit{num}$ 包含的逆序对数量减少为 $0$，因此我们的最优决策就是每次寻找满足 $\textit{num}[i] > \textit{num}[i+1]$ 的位置 $i$，然后交换 $\textit{num}[i]$ 和 $\textit{num}[i+1]$。

可以发现，我们在「思路与算法」部分叙述的遍历操作，正是依次枚举 $1, 2, \cdots, n$ 中的每一个元素 $i$，然后将 $i$ 移动到位置 $i$（假设位置从 $1$ 开始编号），在移动之前，元素 $1, 2, \cdots, i-1$ 已经对应着 $\textit{num}[1], \textit{num}[2], \cdots, \textit{num}[i]$，因此在移动的过程中遇到的元素一定都大于 $i$，即我们总是将逆序对的数量减少 $1$，因此这样的方法一定可以最小化交换的次数。

如果 $\textit{num}_k$ 中存在相同的字符，那么在 $\textit{num}$ 中，它们的相对位置是不会发生变化的。因为如果相对位置发生了变化，那么必然有一步交换操作是交换这两个相同的字符，那么这一步交换操作是无意义的。因此，即使 $\textit{num}_k$ 中存在相同的字符，我们将其重编号为 $1, 2, \cdots, n$ 也是正确的。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int getMinSwaps(string num, int k) {
        string num_k = num;
        for (int i = 0; i < k; ++i) {
            next_permutation(num_k.begin(), num_k.end());
        }
        
        int n = num.size();
        int ans = 0;
        
        for (int i = 0; i < n; ++i) {
            if (num[i] != num_k[i]) {
                for (int j = i + 1; j < n; ++j) {
                    if (num[j] == num_k[i]) {
                        for (int k = j - 1; k >= i; --k) {
                            ++ans;
                            swap(num[k], num[k + 1]);
                        }
                        break;
                    }
                }
            }
        }
        
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def getMinSwaps(self, num: str, k: int) -> int:
        def nextPermutation(num: List[str]) -> None:
            i = len(num) - 2
            while i >= 0 and num[i] >= num[i + 1]:
                i -= 1
            if i >= 0:
                j = len(num) - 1
                while j >= 0 and num[i] >= num[j]:
                    j -= 1
                num[i], num[j] = num[j], num[i]

            left, right = i + 1, len(num) - 1
            while left < right:
                num[left], num[right] = num[right], num[left]
                left += 1
                right -= 1
        
        num = list(num)
        num_k = num[:]
        
        for i in range(k):
            nextPermutation(num_k)
        
        n = len(num)
        ans = 0
        
        for i in range(n):
            if num[i] != num_k[i]:
                for j in range(i + 1, n):
                    if num[j] == num_k[i]:
                        for k in range(j - 1, i - 1, -1):
                            ans += 1
                            num[k], num[k + 1] = num[k + 1], num[k]
                        break
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n(n+k))$，其中 $n$ 是字符串 $\textit{num}$ 的长度。第一步的时间复杂度为 $O(nk)$，第二步的时间复杂度为 $O(n^2)$，因此总时间复杂度为 $O(n(n+k))$。

- 空间复杂度：$O(n)$。我们需要 $O(n)$ 的空间存储 $\textit{num}_k$。