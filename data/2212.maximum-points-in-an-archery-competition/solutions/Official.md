## [2212.射箭比赛中的最大得分 中文官方题解](https://leetcode.cn/problems/maximum-points-in-an-archery-competition/solutions/100000/she-jian-bi-sai-zhong-de-zui-da-de-fen-b-zwh9)

#### 方法一：枚举状态

**思路与算法**

为了最大化地利用箭，我们需要在每个需要获胜的区域都用**尽可能少**的箭数取胜。具体而言，对于第 $i$ 个区域，我们只需要使用 $\textit{aliceArrows}[i] + 1$ 支箭即可。

为了计算可能获得的最大得分及对应方法，一种方法是，枚举**所有区域可能的胜负情况**，并计算该情况的得分与最少需要的箭数，并判断是否可行。与此同时，我们维护可能的最大得分 $\textit{maxscore}$ 以及对应的胜负情况。最终，我们利用胜负情况构造出任意一种方法并返回即可。

由于每个区域只有 $\textit{Bob}$ 胜或负两种情况，因此我们可以用一个 $n$ 位的二进制整数 $\textit{mask}$ 表示所有区域的胜负情况，其中第 $i$ 位为 $0$ 代表 $\textit{Bob}$ 在得分为 $i$ 的区域中落败，为 $1$ 则代表 $\textit{Bob}$ 在该区域取胜。

在维护最大得分 $\textit{maxscore}$ 的同时，我们还维护最大得分对应的二进制状态 $\textit{state}$。我们遍历 $\textit{mask}$ 的所有可能取值，即 $[0, 2^n - 1]$ 闭区间内的所有整数，对于每个 $\textit{mask}$，我们遍历它的每一位计算该状态对应的得分 $\textit{score}$ 和最少需要箭数 $\textit{cnt}$。如果该状态可以达成，即 $cnt \le \textit{numArrows}$，且该状态刷新了当前可行的最大得分 $\textit{score} > \textit{maxscore}$，则我们更新最大得分 $\textit{maxscore}$ 与对应状态 $\textit{state}$。

最终，我们尝试通过最大得分对应状态 $\textit{state}$ 构造一种可行的方法。具体地，我们用长度为 $n$ 的数组 $\textit{res}$ 表示这一方法。首先，我们枚举每下标 $i$，判断该区域 $\textit{Bob}$ 是否取胜，如果是，则 $\textit{res}[i] = \textit{aliceArrows}[i] + 1$；反之则为 $0$。最终，如果箭**还有剩余**，我们可以将它放入任意的区域中，在这里我们将它放入第 $0$ 个区域。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> maximumBobPoints(int numArrows, vector<int>& aliceArrows) {
        int n = aliceArrows.size();
        int maxscore = 0;   // 可行的最大得分
        int state = 0;   // 对应状态
        // 枚举所有输赢状态
        for (int mask = 0; mask < (1 << n); ++mask) {
            int cnt = 0;
            int score = 0;
            for (int i = 0; i < n; ++i) {
                if ((mask >> i) & 1) {
                    cnt += aliceArrows[i] + 1;
                    score += i;
                }
            }
            if (cnt <= numArrows && score > maxscore) {
                // 可行，且更新了当前最大得分
                maxscore = score;
                state = mask;
            }
        }
        // 通过状态构造一种可行方法
        vector<int> res(n);
        for (int i = 0; i < n; ++i) {
            if ((state >> i) & 1) {
                res[i] = aliceArrows[i] + 1;
                numArrows -= res[i];
            }
        }
        res[0] += numArrows;
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def maximumBobPoints(self, numArrows: int, aliceArrows: List[int]) -> List[int]:
        n = len(aliceArrows)
        maxscore = 0   # 可行的最大得分
        state = 0   # 对应状态
        # 枚举所有输赢状态
        for mask in range(2 ** n):
            cnt = 0
            score = 0
            for i in range(n):
                if (mask >> i) & 1:
                    cnt += aliceArrows[i] + 1
                    score += i
            if cnt <= numArrows and score > maxscore:
                # 可行，且更新了当前最大得分
                maxscore = score
                state = mask
        # 通过状态构造一种可行方法
        res = [0] * n
        for i in range(n):
            if (state >> i) & 1:
                res[i] = aliceArrows[i] + 1
                numArrows -= res[i]
        res[0] += numArrows
        return res
```


**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 为箭靶的数量，在本题中 $n = 12$。所有的得分状态共有 $2^n$ 种，对于单个状态，判断是否可行以及维护最大得分的时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。