## [2120.执行所有后缀指令 中文官方题解](https://leetcode.cn/problems/execution-of-all-suffix-instructions-staying-in-a-grid/solutions/100000/zhi-xing-suo-you-hou-zhui-zhi-ling-by-le-scvh)
#### 方法一：模拟

**思路与算法**

我们直接从每一条指令开始，模拟机器人的运动路径即可。具体地，从第 $i$ 条指令开始时，我们首先讲机器人置于 $\textit{startPos}$ 的位置，随后逐条执行指令。当遇到第 $j$ 条 $\text{L, R, U, D}$ 指令时，机器人会分别向左、右、上、下移动一个位置。如果机器人移动到了网格外，那么它可以执行 $j - i$ 条指令。如果在所有指令执行完毕后，机器人仍然位于网格内，那么它可以执行全部的 $m - i$ 条指令。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> executeInstructions(int n, vector<int>& startPos, string s) {
        int m = s.size();
        vector<int> ans;
        for (int i = 0; i < m; ++i) {
            int x = startPos[0], y = startPos[1];
            int cnt = m - i;
            for (int j = i; j < m; ++j) {
                char ch = s[j];
                if (ch == 'L') {
                    --y;
                }
                else if (ch == 'R') {
                    ++y;
                }
                else if (ch == 'U') {
                    --x;
                }
                else {
                    ++x;
                }
                if (x < 0 || x >= n || y < 0 || y >= n) {
                    cnt = j - i;
                    break;
                }
            }
            ans.push_back(cnt);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def executeInstructions(self, n: int, startPos: List[int], s: str) -> List[int]:
        m = len(s)
        ans = list()
        for i in range(m):
            x, y = startPos
            cnt = m - i
            for j in range(i, m):
                ch = s[j]
                if ch == "L":
                    y -= 1
                elif ch == "R":
                    y += 1
                elif ch == "U":
                    x -= 1
                else:
                    x += 1
                if x < 0 or x >= n or y < 0 or y >= n:
                    cnt = j - i
                    break
            ans.append(cnt)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(m^2)$。

- 空间复杂度：$O(1)$。