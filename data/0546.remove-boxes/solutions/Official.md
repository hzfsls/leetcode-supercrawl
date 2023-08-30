#### 方法一：动态规划

我们很容易陷入这样一个**错误的思路**：用 $f(l, r)$ 来表示移除区间 $[l, r]$ 内所有的盒子能得到的最大积分，然后去探索某一种移除盒子的策略来进行状态转移。而实际上，我们并不能直接使用起始节点和结束节点决定最大分数，因为这个分数并不只依赖于子序列，也依赖于之前的移动对当前数组的影响，这可能让最终的子序列不是一个连续的子串。比如 $\{ 3, 4, 2, 4, 4 \}$，如果先把 $2$ 移除，$3$ 个 $4$ 会合并在一起，对答案的贡献是 $3^2 = 9$，如果先移除左右两边的 $4$ 再移除 $2$ 这里 $3$ 个 $4$ 的贡献就是 $1^2 + 2^2 = 5$，最优的办法当然是先取走 $2$，但是这样剩下的 $3$ 个 $4$ 其实并不是原串的某个连续子串。

**那么正确的思路是什么呢？**

我们可以换一种思路，用 $f(l, r, k)$ 表示移除**区间 $[l, r]$ 的元素 $a_l, a_{l + 1}, a_{l + 2} \cdots a_r$加上该区间右边等于 $a_r$ 的 $k$ 个元素**组成的这个序列的最大积分。例如序列 $\{ 6, 3, 6, 5, 6, 7, 6, 6, 8, 6 \}$，$l = 0$，$r = 4$，那么 $f(l, r, 3)$ 对应的元素就是 $\{ {\color{red}[6, 3, 6, 5, 6]}, 7, {\color{red}6}, {\color{red}6}, 8, {\color{red}6} \}$ 中标记为红色的部分。$f(l, r, k)$ 的定义是移除这个红色的序列获得的最大积分。**请注意此时我们约定 $7$ 和 $8$ 已经先被移除**，所以在这个状态下我们可以认为最后四个 $6$ 是连续的，也就是说实际上**待删除的序列**是这样的：$\{ [6, 3, 6, 5, 6], 6, 6, 6 \}$，此时我们可以有这样一些策略来移除盒子：

+ $\{ {\color{orange}[6, 3, 6, 5}, {\color{red} 6]}, 7, {\color{red}6, 6}, 8, {\color{red}6} \}$，删除后面的四个 $6$，再删除前面的这个区间，这样获得的分数为 $f(0, 3, 0) + 4^2$。
+ $\{ {\color{orange}[6, 3}, {\color{red}6]}, [5], {\color{red} 6}, 7, {\color{red}6, 6}, 8, {\color{red}6} \}$，删除一个单独的 $a_3$（即 $5$），分数是 $f(3, 3, 0)$；然后问题就变成了删除区间 $[0, 2]$ 以及这个区间后面和 $a_2$ 相同的 $4$ 个数，分数是 $f(0, 2, 4)$；这样获得的分数是 $f(0, 2, 4) + f(3, 3, 0)$。
+ $\{ {\color{orange}[ }{\color{red}6]},[3, 6, 5], {\color{red} 6}, 7, {\color{red}6, 6}, 8, {\color{red}6} \}$，删除 $a_1$、$a_2$、$a_3$，分数为 $f(1, 3, 0)$；之后再删除区间 $[0, 0]$ 和这个区间后和 $a_1$ 相同的 $4$ 个数，分数是 $f(0, 0, 4)$；这样获得的分数是 $f(0, 0, 4) + f(1, 3, 0)$。

这个就是我们转移的时候使用的策略，我们可以推导出这样的动态规划转移方程：

$$
 f(l, r, k) = \max \left\{ f(l, r - 1, 0) + (k + 1)^2, \max_{i = l}^{r - 1} \{ [f(l, i, k + 1) + f(i + 1, r - 1, 0)] \times { \color{red} \epsilon (a_i = a_r)} \} \right\} 
$$

+ $f(l, r - 1, 0) + (k + 1)^2$ 代表我们把 $a_r$ 和后面的 $k$ 个数一起删除，再删除 $[l, r - 1]$ 这个区间。也就是说，当我们删除 $f(l, r, k)$ 对应的数字的时候，我们可以考虑先删除 $a_r$ 和后面 $k$ 个与 $a_r$ 相等的数，即一共 $k + 1$ 个数，得分为 $(k+1)^2$，再删除 $[l, r - 1]$ 这个区间，由于第 $r - 1$ 个位置后面所有的数字都删除了，所以这里不用继续考虑后面的数字中和 $a_{r - 1}$ 相等的那些数字，所以这里的分数是 $f(l, r - 1, 0)$。

+ $[f(l, i, k + 1) + f(i + 1, r - 1, 0)] \times { \color{red} \epsilon (a_i = a_r)}$ 代表当 $a_i = a_r (l \leq i < r)$ 的时候，考虑先删掉 $[i + 1, r - 1]$ 这个区间，然后再删除 $[l, i]$ 区间和后面的 $k + 1$ 个和 $a_r$ 相等的数构成的序列，其中 $\epsilon(x)$ 为选择函数：
$$
 \epsilon(x) = \left \{ 
\begin{aligned}
& 1 ,& x = {\rm True} & \\
& 0 ,& x = {\rm False} 
\end{aligned}
\right . 
$$
这里我们只考虑和 $a_r$ 相等的 $a_i$，因为一个序列 $\{ a_l, \cdots, a_i, \cdots, a_r, x, x, x \}$，当 $a_r = x$ 时，我们可以考虑先删除 $[i, r - 1]$ 这个区间的元素，即 $a_i, a_{i + 1}, \cdots, a_{r - 1}$，我们把这些元素单独拿出来考虑，即不用考虑 $r - 1$ 后面和 $a_{r - 1}$ 相等的元素（因为 $a_r$ 和后面等于它的数字会在下一步中删除，而 $a_{r}$ 后面其他的数字已经被删除），故这里的分数为 $f(i, r - 1, 0)$；接着这个问题就变成了删除区间 $[l, i]$ 和 $a_r$ 以及 $a_r$ 后方和它相等的 $k$ 个数，因为 $a_i = a_r$，所以这个问题就是 $[l, i]$ 区间和它的后方和 $a_i$ 相等的 $k + 1$ 个数，这里的分数是 $f(l, i, k + 1)$。

这样我们就可以计算出 $f(0, n-1, 0)$ 的值，即为答案。

我们不难写出这样的代码：

```cpp [sol1-C++]
class Solution {
public:
    int dp[100][100][100];

    int removeBoxes(vector<int>& boxes) {
        memset(dp, 0, sizeof dp);
        return calculatePoints(boxes, 0, boxes.size() - 1, 0);
    }

    int calculatePoints(vector<int>& boxes, int l, int r, int k) {
        if (l > r) {
            return 0;
        }
        if (dp[l][r][k] == 0) {
            dp[l][r][k] = calculatePoints(boxes, l, r - 1, 0) + (k + 1) * (k + 1);
            for (int i = l; i < r; i++) {
                if (boxes[i] == boxes[r]) {
                    dp[l][r][k] = max(dp[l][r][k], calculatePoints(boxes, l, i, k + 1) + calculatePoints(boxes, i + 1, r - 1, 0));
                }
            }
        }
        return dp[l][r][k];
    }
};
```

```Java [sol1-Java]
class Solution {
    int[][][] dp;

    public int removeBoxes(int[] boxes) {
        int length = boxes.length;
        dp = new int[length][length][length];
        return calculatePoints(boxes, 0, length - 1, 0);
    }

    public int calculatePoints(int[] boxes, int l, int r, int k) {
        if (l > r) {
            return 0;
        }
        if (dp[l][r][k] == 0) {
            dp[l][r][k] = calculatePoints(boxes, l, r - 1, 0) + (k + 1) * (k + 1);
            for (int i = l; i < r; i++) {
                if (boxes[i] == boxes[r]) {
                    dp[l][r][k] = Math.max(dp[l][r][k], calculatePoints(boxes, l, i, k + 1) + calculatePoints(boxes, i + 1, r - 1, 0));
                }
            }
        }
        return dp[l][r][k];
    }
}
```

```golang [sol1-Golang]
func removeBoxes(boxes []int) int {
    dp := [100][100][100]int{}
    var calculatePoints func(boxes []int, l, r, k int) int
    calculatePoints = func(boxes []int, l, r, k int) int {
        if l > r {
            return 0
        }
        if dp[l][r][k] == 0 {
            dp[l][r][k] = calculatePoints(boxes, l, r - 1, 0) + (k + 1) * (k + 1)
            for i := l; i < r; i++ {
                if boxes[i] == boxes[r] {
                    dp[l][r][k] = max(dp[l][r][k], calculatePoints(boxes, l, i, k + 1) + calculatePoints(boxes, i + 1, r - 1, 0))
                }
            }
        }
        return dp[l][r][k]
    }
    return calculatePoints(boxes, 0, len(boxes) - 1, 0)
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

```C [sol1-C]
int dp[100][100][100];

int calculatePoints(int* boxes, int l, int r, int k) {
    if (l > r) {
        return 0;
    }
    if (dp[l][r][k] == 0) {
        dp[l][r][k] = calculatePoints(boxes, l, r - 1, 0) + (k + 1) * (k + 1);
        for (int i = l; i < r; i++) {
            if (boxes[i] == boxes[r]) {
                dp[l][r][k] = fmax(dp[l][r][k], calculatePoints(boxes, l, i, k + 1) + calculatePoints(boxes, i + 1, r - 1, 0));
            }
        }
    }
    return dp[l][r][k];
}

int removeBoxes(int* boxes, int boxesSize) {
    memset(dp, 0, sizeof dp);
    return calculatePoints(boxes, 0, boxesSize - 1, 0);
}
```

在这份代码中，我们把 $f(l, r, k)$ 初始化成 $f(l, r - 1, 0) + (k + 1)^2$。我们可以做一个小小的优化。假设当前区间是这样的：$\{ a_l, a_{l + 1}, \cdots, x, x, x, a_{r}, x, y, x, x, \cdots \}$，此时如果 $a_r = x$，那么初始化的时候 $f(l, r, k) = f(l, r - 1, 0) + (k + 1)^2$，接下来的循环从 $l$ 到 $r - 1$。我们观察到其实 $a_r$ 前面还有若干个连续的和 $a_r$ 相等的数，这些数可以和 $a_r$ 及后面的 $x$ 作为一个整体，在这里我们可以初始化 $f(l, r, k) = f(l, r - 3, 0) + (k + 3)^2$。为什么可以这样初始化呢？这样初始化相当于把前面 $3$ 个 $x$ 和 $a_r$ 和后面的一坨 $x$ 捆绑到了一起，因为分开计算一定是没有合并计算优的，因为当 $k \ge 0$ 的时候 $(k + 1 + 1 + 1)^2 > (k + 1)^2 + (1 + 1)^2 > (k + 1)^2 + 1^2 + 1^2$。

下面是优化的代码。

```cpp [sol2-C++]
class Solution {
public:
    int dp[100][100][100];

    int removeBoxes(vector<int>& boxes) {
        memset(dp, 0, sizeof dp);
        return calculatePoints(boxes, 0, boxes.size() - 1, 0);
    }

    int calculatePoints(vector<int>& boxes, int l, int r, int k) {
        if (l > r) {
            return 0;
        }
        if (dp[l][r][k] == 0) {
            int r1 = r, k1 = k;
            while (r1 > l && boxes[r1] == boxes[r1 - 1]) {
                r1--;
                k1++;
            }
            dp[l][r][k] = calculatePoints(boxes, l, r1 - 1, 0) + (k1 + 1) * (k1 + 1);
            for (int i = l; i < r1; i++) {
                if (boxes[i] == boxes[r1]) {
                    dp[l][r][k] = max(dp[l][r][k], calculatePoints(boxes, l, i, k1 + 1) + calculatePoints(boxes, i + 1, r1 - 1, 0));
                }
            }
        }
        return dp[l][r][k];
    }
};
```

```Java [sol2-Java]
class Solution {
    int[][][] dp;

    public int removeBoxes(int[] boxes) {
        int length = boxes.length;
        dp = new int[length][length][length];
        return calculatePoints(boxes, 0, length - 1, 0);
    }

    public int calculatePoints(int[] boxes, int l, int r, int k) {
        if (l > r) {
            return 0;
        }
        if (dp[l][r][k] == 0) {
            int r1 = r, k1 = k;
            while (r1 > l && boxes[r1] == boxes[r1 - 1]) {
                r1--;
                k1++;
            }
            dp[l][r][k] = calculatePoints(boxes, l, r1 - 1, 0) + (k1 + 1) * (k1 + 1);
            for (int i = l; i < r1; i++) {
                if (boxes[i] == boxes[r1]) {
                    dp[l][r][k] = Math.max(dp[l][r][k], calculatePoints(boxes, l, i, k1 + 1) + calculatePoints(boxes, i + 1, r1 - 1, 0));
                }
            }
        }
        return dp[l][r][k];
    }
}
```

```golang [sol2-Golang]
func removeBoxes(boxes []int) int {
    dp := [100][100][100]int{}
    var calculatePoints func(boxes []int, l, r, k int) int
    calculatePoints = func(boxes []int, l, r, k int) int {
        if l > r {
            return 0
        }
        if dp[l][r][k] == 0 {
            r1, k1 := r, k
            for r1 > l && boxes[r1] == boxes[r1 - 1] {
                r1--
                k1++
            }
            dp[l][r][k] = calculatePoints(boxes, l, r1 - 1, 0) + (k1 + 1) * (k1 + 1)
            for i := l; i < r1; i++ {
                if boxes[i] == boxes[r1] {
                    dp[l][r][k] = max(dp[l][r][k], calculatePoints(boxes, l, i, k1 + 1) + calculatePoints(boxes, i + 1, r1 - 1, 0))
                }
            }
        }
        return dp[l][r][k]
    }
    return calculatePoints(boxes, 0, len(boxes) - 1, 0)
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

```C [sol2-C]
int dp[100][100][100];

int calculatePoints(int* boxes, int l, int r, int k) {
    if (l > r) {
        return 0;
    }
    if (dp[l][r][k] == 0) {
        int r1 = r, k1 = k;
        while (r1 > l && boxes[r1] == boxes[r1 - 1]) {
            r1--;
            k1++;
        }
        dp[l][r][k] = calculatePoints(boxes, l, r1 - 1, 0) + (k1 + 1) * (k1 + 1);
        for (int i = l; i < r1; i++) {
            if (boxes[i] == boxes[r1]) {
                dp[l][r][k] = fmax(dp[l][r][k], calculatePoints(boxes, l, i, k1 + 1) + calculatePoints(boxes, i + 1, r1 - 1, 0));
           }
        }
    }
    return dp[l][r][k];
}

int removeBoxes(int* boxes, int boxesSize) {
    memset(dp, 0, sizeof dp);
    return calculatePoints(boxes, 0, boxesSize - 1, 0);
}
```

**复杂度分析**

+ 时间复杂度：$O(n^4)$，其中 $n$ 是盒子的数量。最坏情况下每个 $f(l, r, k)$ 被计算一次，每次状态转移需要 $O(n)$ 的时间复杂度。
+ 空间复杂度：$O(n^3)$。数组 $\textit{dp}$ 的空间代价是 $O(n^3)$，递归使用栈空间的代价为 $O(n)$。