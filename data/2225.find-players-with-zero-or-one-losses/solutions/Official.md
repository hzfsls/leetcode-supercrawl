## [2225.找出输掉零场或一场比赛的玩家 中文官方题解](https://leetcode.cn/problems/find-players-with-zero-or-one-losses/solutions/100000/zhao-chu-shu-diao-ling-chang-huo-yi-chan-fpsj)

#### 方法一：哈希表

**思路与算法**

我们可以用一个哈希映射记录每一名玩家输掉比赛的次数。对于哈希映射中的每一个键值对，键表示一名玩家，值表示该玩家输掉比赛的次数。

这样一来，我们只需要遍历数组 $\textit{matches}$。当我们遍历到第 $i$ 项 $(\textit{winner}_i, \textit{loser}_i)$ 时，如果 $\textit{winner}_i$ 或 $\textit{loser}_i$ 没有在哈希映射中作为键出现过，那么我们需要把他们加入哈希映射中，并且对应的值为 $0$。随后，我们需要将 $\textit{loser}_i$ 在哈希映射中对应的值增加 $1$，表示玩家 $\textit{loser}_i$ 输掉了一场比赛。

在这之后，我们只需要再对哈希表进行一次遍历，「没有输掉任何比赛的玩家」即为所有值为 $0$ 的键，「恰好输掉一场比赛的玩家」即为所有值为 $1$ 的键。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> findWinners(vector<vector<int>>& matches) {
        unordered_map<int, int> freq;
        for (const auto& match: matches) {
            int winner = match[0], loser = match[1];
            if (!freq.count(winner)) {
                freq[winner] = 0;
            }
            ++freq[loser];
        }

        vector<vector<int>> ans(2);
        for (const auto& [key, value]: freq) {
            if (value < 2) {
                ans[value].push_back(key);
            }
        }

        sort(ans[0].begin(), ans[0].end());
        sort(ans[1].begin(), ans[1].end());
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def findWinners(self, matches: List[List[int]]) -> List[List[int]]:
        freq = Counter()
        for winner, loser in matches:
            if winner not in freq:
                freq[winner] = 0
            freq[loser] += 1
        
        ans = [[], []]
        for key, value in freq.items():
            if value < 2:
                ans[value].append(key)
        
        ans[0].sort()
        ans[1].sort()
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{matches}$ 的长度。

- 空间复杂度：$O(n)$，即为哈希映射需要使用的空间。