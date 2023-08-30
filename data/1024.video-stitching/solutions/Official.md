#### 前言

本题要求从一系列视频子区间中选出尽可能少的一部分，使得这部分视频子区间能够重新剪出一个完整的视频。我们可以这样理解：给定区间 $[0,\textit{time})$ 的一系列子区间（可能重叠），要求从中选出尽可能少的子区间，使得这些子区间能够完全覆盖区间 $[0,\textit{time})$。

为下文表述方便，我们用 $[a,b)$ 来代表每一个子区间，第 $i$ 个子区间表示为 $[a_i,b_i)$。

#### 方法一：动态规划

**思路及解法**

比较容易想到的方法是动态规划，我们令 $\textit{dp}[i]$ 表示将区间 $[0,i)$ 覆盖所需的最少子区间的数量。由于我们希望子区间的数目尽可能少，因此可以将所有 $\textit{dp}[i]$ 的初始值设为一个大整数，并将 $\textit{dp}[0]$（即空区间）的初始值设为 $0$。

我们可以枚举所有的子区间来依次计算出所有的 $\textit{dp}$ 值。我们首先枚举 $i$，同时对于任意一个子区间 $[a_j,b_j)$，若其满足 $a_j < i \leq b_j$，那么它就可以覆盖区间 $[0, i)$ 的后半部分，而前半部分则可以用 $\textit{dp}[a_j]$ 对应的**最优**方法进行覆盖，因此我们可以用 $dp[a_j] + 1$ 来更新 $\textit{dp}[i]$。状态转移方程如下：

$$
\textit{dp}[i] = \min \{ \textit{dp}[a_j] \} + 1 \quad (a_j < i \leq b_j)
$$

最终的答案即为 $\textit{dp}[\textit{time}]$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int videoStitching(vector<vector<int>>& clips, int time) {
        vector<int> dp(time + 1, INT_MAX - 1);
        dp[0] = 0;
        for (int i = 1; i <= time; i++) {
            for (auto& it : clips) {
                if (it[0] < i && i <= it[1]) {
                    dp[i] = min(dp[i], dp[it[0]] + 1);
                }
            }
        }
        return dp[time] == INT_MAX - 1 ? -1 : dp[time];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int videoStitching(int[][] clips, int time) {
        int[] dp = new int[time + 1];
        Arrays.fill(dp, Integer.MAX_VALUE - 1);
        dp[0] = 0;
        for (int i = 1; i <= time; i++) {
            for (int[] clip : clips) {
                if (clip[0] < i && i <= clip[1]) {
                    dp[i] = Math.min(dp[i], dp[clip[0]] + 1);
                }
            }
        }
        return dp[time] == Integer.MAX_VALUE - 1 ? -1 : dp[time];
    }
}
```

```Golang [sol1-Golang]
func videoStitching(clips [][]int, time int) int {
    const inf = math.MaxInt64 - 1
    dp := make([]int, time+1)
    for i := range dp {
        dp[i] = inf
    }
    dp[0] = 0
    for i := 1; i <= time; i++ {
        for _, c := range clips {
            l, r := c[0], c[1]
            // 若能剪出子区间 [l,i]，则可以从 dp[l] 转移到 dp[i]
            if l < i && i <= r && dp[l]+1 < dp[i] {
                dp[i] = dp[l] + 1
            }
        }
    }
    if dp[time] == inf {
        return -1
    }
    return dp[time]
}
```

```C [sol1-C]
int videoStitching(int** clips, int clipsSize, int* clipsColSize, int time) {
    int dp[time + 1];
    memset(dp, 0x3f, sizeof(dp));
    dp[0] = 0;
    for (int i = 1; i <= time; i++) {
        for (int j = 0; j < clipsSize; j++) {
            if (clips[j][0] < i && i <= clips[j][1]) {
                dp[i] = fmin(dp[i], dp[clips[j][0]] + 1);
            }
        }
    }
    return dp[time] == 0x3f3f3f3f ? -1 : dp[time];
}
```

```Python [sol1-Python3]
class Solution:
    def videoStitching(self, clips: List[List[int]], time: int) -> int:
        dp = [0] + [float("inf")] * time
        for i in range(1, time + 1):
            for aj, bj in clips:
                if aj < i <= bj:
                    dp[i] = min(dp[i], dp[aj] + 1)
        
        return -1 if dp[time] == float("inf") else dp[time]
```

**复杂度分析**

- 时间复杂度：$O(\textit{time} \times n)$，其中 $\textit{time}$ 是区间的长度，$n$ 是子区间的数量。对于任意一个前缀区间 $[0,i)$ ，我们都需要枚举所有的子区间，时间复杂度 $O(n)$。总时间复杂度为 $O(\textit{time}) \times O(n) = O(\textit{time} \times n)$。

- 空间复杂度：$O(\textit{time})$，其中 $\textit{time}$ 是区间的长度。我们需要记录每一个前缀区间 $[0,i)$ 的状态信息。

#### 方法二：贪心

**思路及解法**

注意到对于所有左端点相同的子区间，其右端点越远越有利。且最佳方案中不可能出现两个左端点相同的子区间。于是我们预处理所有的子区间，对于每一个位置 $i$，我们记录以其为左端点的子区间中最远的右端点，记为 $\textit{maxn}[i]$。

我们可以参考「[55. 跳跃游戏的官方题解](https://leetcode-cn.com/problems/jump-game/solution/tiao-yue-you-xi-by-leetcode-solution/)」，使用贪心解决这道题。

具体地，我们枚举每一个位置，假设当枚举到位置 $i$ 时，记左端点不大于 $i$ 的所有子区间的最远右端点为 $\textit{last}$。这样 $\textit{last}$ 就代表了当前能覆盖到的最远的右端点。

每次我们枚举到一个新位置，我们都用 $\textit{maxn}[i]$ 来更新 $\textit{last}$。如果更新后 $\textit{last} == i$，那么说明下一个位置无法被覆盖，我们无法完成目标。

同时我们还需要记录上一个被使用的子区间的结束位置为 $\textit{pre}$，每次我们越过一个被使用的子区间，就说明我们要启用一个新子区间，这个新子区间的结束位置即为当前的 $\textit{last}$。也就是说，每次我们遇到 $i == \textit{pre}$，则说明我们用完了一个被使用的子区间。这种情况下我们让答案加 $1$，并更新 $\textit{pre}$ 即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int videoStitching(vector<vector<int>>& clips, int time) {
        vector<int> maxn(time);
        int last = 0, ret = 0, pre = 0;
        for (vector<int>& it : clips) {
            if (it[0] < time) {
                maxn[it[0]] = max(maxn[it[0]], it[1]);
            }
        }
        for (int i = 0; i < time; i++) {
            last = max(last, maxn[i]);
            if (i == last) {
                return -1;
            }
            if (i == pre) {
                ret++;
                pre = last;
            }
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int videoStitching(int[][] clips, int time) {
        int[] maxn = new int[time];
        int last = 0, ret = 0, pre = 0;
        for (int[] clip : clips) {
            if (clip[0] < time) {
                maxn[clip[0]] = Math.max(maxn[clip[0]], clip[1]);
            }
        }
        for (int i = 0; i < time; i++) {
            last = Math.max(last, maxn[i]);
            if (i == last) {
                return -1;
            }
            if (i == pre) {
                ret++;
                pre = last;
            }
        }
        return ret;
    }
}
```

```Golang [sol2-Golang]
func videoStitching(clips [][]int, time int) (ans int) {
    maxn := make([]int, time)
    last, pre := 0, 0
    for _, c := range clips {
        l, r := c[0], c[1]
        if l < time && r > maxn[l] {
            maxn[l] = r
        }
    }
    for i, v := range maxn {
        if v > last {
            last = v
        }
        if i == last {
            return -1
        }
        if i == pre {
            ans++
            pre = last
        }
    }
    return
}
```

```C [sol2-C]
int videoStitching(int** clips, int clipsSize, int* clipsColSize, int time) {
    int maxn[time + 1];
    memset(maxn, 0, sizeof(maxn));
    int last = 0, ret = 0, pre = 0;
    for (int i = 0; i < clipsSize; i++) {
        if (clips[i][0] < time) {
            maxn[clips[i][0]] = fmax(maxn[clips[i][0]], clips[i][1]);
        }
    }
    for (int i = 0; i < time; i++) {
        last = fmax(last, maxn[i]);
        if (i == last) {
            return -1;
        }
        if (i == pre) {
            ret++;
            pre = last;
        }
    }
    return ret;
}
```

```Python [sol2-Python3]
class Solution:
    def videoStitching(self, clips: List[List[int]], time: int) -> int:
        maxn = [0] * time
        last = ret = pre = 0
        for a, b in clips:
            if a < time:
                maxn[a] = max(maxn[a], b)
        
        for i in range(time):
            last = max(last, maxn[i])
            if i == last:
                return -1
            if i == pre:
                ret += 1
                pre = last
        
        return ret
```

**复杂度分析**

- 时间复杂度：$O(\textit{time} + n)$，其中 $\textit{time}$ 是区间的长度，$n$ 是子区间的数量。我们需要枚举每一个位置，时间复杂度 $O(\textit{time})$，同时我们还需要预处理所有的子区间，时间复杂度 $O(n)$。总时间复杂度为 $O(\textit{time}) + O(n) = O(\textit{time} + n)$。

- 空间复杂度：$O(\textit{time})$，其中 $\textit{time}$ 是区间的长度。对于每一个位置，我们需要记录以其为左端点的子区间的最右端点。