#### 方法一：枚举

**思路与算法**

首先很直观的想法，我们可以枚举矩阵中的每个位置 $(i,j)$，统计以其作为右下角时，有多少个元素全部都是 $1$ 的子矩形，那么我们就能不重不漏地统计出满足条件的子矩形个数。那么枚举以后，我们怎么统计满足条件的子矩形个数呢？

既然是枚举以 $(i,j)$ 作为右下角的子矩形个数，那么我们可以直接暴力地枚举左上角 $(k,y)$，看其组成的矩形是否满足条件，时间复杂度为 $O(nm)$。但这样无疑会使得时间复杂度变得很高，我们需要另寻他路。

我们预处理 $\textit{row}$ 数组，其中 $\textit{row}[i][j]$ 代表矩阵中 $(i,j)$ 向左延伸连续 $1$ 的个数，容易得出递推式：
$$
row[i][j]=\begin{cases}
0, & \quad mat[i][j]= 0 \\
row[i][j-1]+1, & \quad mat[i][j]= 1
\end{cases}
$$
有了 $\textit{row}$ 数组以后，如果要统计以 $(i,j)$ 为右下角满足条件的子矩形，我们就可以枚举子矩形的高，即第 $k$ 行，看当前高度有多少满足条件的子矩形。由于我们知道第 $k$ 行到第 $i$ 行「每一行第 $j$ 列向左延伸连续 $1$ 的个数」 $\textit{row}[k][j],\textit{row}[k+1][j],\cdots,\textit{row}[i][j]$，因此我们可以知道第 $k$ 行满足条件的子矩形个数就是这些值的最小值，它代表了「第 $k$ 行到第 $i$ 行子矩形的宽的最大值」，公式化来说，即：
$$
\min_{l=k..i} \{\textit{row}[l][j]\}
$$
因此我们倒序枚举 $k$，用 $\textit{col}$ 变量来记录到当前行 $\textit{row}$ 的最小值，即能在 $O(n)$ 的时间内统计出以 $(i,j)$ 为右下角满足条件的子矩形个数。

<![fig1](https://assets.leetcode-cn.com/solution-static/1504/1.png),![fig2](https://assets.leetcode-cn.com/solution-static/1504/2.png),![fig3](https://assets.leetcode-cn.com/solution-static/1504/3.png),![fig4](https://assets.leetcode-cn.com/solution-static/1504/4.png),![fig5](https://assets.leetcode-cn.com/solution-static/1504/5.png),![fig6](https://assets.leetcode-cn.com/solution-static/1504/6.png),![fig7](https://assets.leetcode-cn.com/solution-static/1504/7.png),![fig8](https://assets.leetcode-cn.com/solution-static/1504/8.png),![fig9](https://assets.leetcode-cn.com/solution-static/1504/9.png),![fig10](https://assets.leetcode-cn.com/solution-static/1504/10.png),![fig11](https://assets.leetcode-cn.com/solution-static/1504/11.png),![fig12](https://assets.leetcode-cn.com/solution-static/1504/12.png),![fig13](https://assets.leetcode-cn.com/solution-static/1504/13.png),![fig14](https://assets.leetcode-cn.com/solution-static/1504/14.png),![fig15](https://assets.leetcode-cn.com/solution-static/1504/15.png),![fig16](https://assets.leetcode-cn.com/solution-static/1504/16.png),![fig17](https://assets.leetcode-cn.com/solution-static/1504/17.png),![fig18](https://assets.leetcode-cn.com/solution-static/1504/18.png),![fig19](https://assets.leetcode-cn.com/solution-static/1504/19.png),![fig20](https://assets.leetcode-cn.com/solution-static/1504/20.png),![fig21](https://assets.leetcode-cn.com/solution-static/1504/21.png)>

```C++ [sol1-C++]
class Solution {
public:
    int numSubmat(vector<vector<int>>& mat) {
        int n = mat.size();
        int m = mat[0].size();
        vector<vector<int> > row(n, vector<int>(m, 0));
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (j == 0) {
                    row[i][j] = mat[i][j];
                } else if (mat[i][j]) {
                    row[i][j] = row[i][j - 1] + 1;
                }
                else {
                    row[i][j] = 0;
                }
            }
        }
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                int col = row[i][j];
                for (int k = i; k >= 0 && col; --k) {
                    col = min(col, row[k][j]);
                    ans += col;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numSubmat(int[][] mat) {
        int n = mat.length;
        int m = mat[0].length;
        int[][] row = new int[n][m];
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (j == 0) {
                    row[i][j] = mat[i][j];
                } else if (mat[i][j] != 0) {
                    row[i][j] = row[i][j - 1] + 1;
                } else {
                    row[i][j] = 0;
                }
            }
        }
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                int col = row[i][j];
                for (int k = i; k >= 0 && col != 0; --k) {
                    col = Math.min(col, row[k][j]);
                    ans += col;
                }
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
int numSubmat(int** mat, int matSize, int* matColSize) {
    int n = matSize;
    int m = matColSize[0];
    int row[n][m];
    memset(row, 0, sizeof(row));
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            if (j == 0) {
                row[i][j] = mat[i][j];
            } else if (mat[i][j]) {
                row[i][j] = row[i][j - 1] + 1;
            } else {
                row[i][j] = 0;
            }
        }
    }
    int ans = 0;
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            int col = row[i][j];
            for (int k = i; k >= 0 && col; --k) {
                col = fmin(col, row[k][j]);
                ans += col;
            }
        }
    }
    return ans;
}
```

```Python [sol1-Python3]
class Solution:
    def numSubmat(self, mat: List[List[int]]) -> int:
        n, m = len(mat), len(mat[0])
        
        row = [[0] * m for _ in range(n)]
        for i in range(n):
            for j in range(m):
                if j == 0:
                    row[i][j] = mat[i][j]
                else:
                    row[i][j] = 0 if mat[i][j] == 0 else row[i][j - 1] + 1
        
        ans = 0
        for i in range(n):
            for j in range(m):
                col = row[i][j]
                for k in range(i, -1, -1):
                    col = min(col, row[k][j])
                    if col == 0:
                        break
                    ans += col
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n^2m)$，其中 $n$ 为矩阵行数，$m$ 为矩阵列数。我们预处理 $\textit{row}$ 数组需要 $O(nm)$ 的时间，统计答案的时候一共需要枚举 $O(nm)$ 个位置，每次枚举的时候需要 $O(n)$ 的时间计算，因此时间复杂度为 $O(n^2m)$，故总时间复杂度为 $O(nm+n^2m)=O(n^2m)$。
- 空间复杂度：$O(nm)$。我们需要 $O(nm)$ 的空间来存储 $\textit{row}$ 数组。

#### 方法二：单调栈

**思路与算法**

枚举方法虽然直观，但是通常会造成许多不必要的计算，为了进一步优化时间复杂度，我们需要寻找可以复用的信息。例如下图，我们可以思考，假设我们已经计算出了 $(0,2)$, $(1,2)$, $(2,2)$ 三个位置的答案，那么我们在计算 $(3,2)$ 这个位置的答案的时候，我们真的还需要再倒序遍历对 $\textit{row}[2][2]$, $\textit{row}[1][2]$, $\textit{row}[0][2]$ 取 $\textit{min}$ 么？我们是不是只需要在遍历的时候记录 $(0,2)$, $(1,2)$, $(2,2)$ 答案的和，就能在 $O(1)$ 的时间内计算出 $(3,2)$ 这个位置的答案呢？

![img1](https://assets.leetcode-cn.com/solution-static/1504/1504_fig1.png)

答案不尽然，相信思维活跃的读者很快能想到下图这种情况，这个时候 $(3,2)$ 的答案就不再是简单的复用前面答案的和，而是如图中方框标注的那样，这种情况会在 $\textit{row}[0..i][j]$ 随行号非单调递增的时候出现，那么这个时候我们要怎么快速统计答案呢？答案就是单调栈。

![img2](https://assets.leetcode-cn.com/solution-static/1504/1504_fig2.png)

单调栈是一种特殊的栈，它始终保证栈里的元素具有单调性，要么是单调递增，要么是单调递减，在此题中我们需要维护一个存储 $\textit{row}$ 值的单调栈，满足从栈底到栈顶的元素单调递增。为什么会想到这么做？这是因为我们会发现，最容易统计的情况是 $\textit{row}[0..i][j]$ 的值随行号单调递增，此时答案就是它们的和，但是如果遇到非递增的时候，即当前 $\textit{row}[i][j]$ 小于当前 $\textit{row}[i-1][j]$，此时无疑 $i-1$ 行 $\textit{row}[i-1][j]-\textit{row}[i][j]$ 的部分我们是不再需要的，它对后面 $i+1,i+2,\cdots, n-1$ 统计答案的时候都不会再用到，这个时候我们就可以抛弃掉这部分的值，然后再去看 $\textit{row}[i][j]$ 和 $\textit{row}[i-2][j]$ 的值，以此类推，直到 $\textit{row}[i][j]$ 的值大于当前单调栈栈顶的元素时结束，然后再推入 $\textit{row}[i][j]$。

![img3](https://assets.leetcode-cn.com/solution-static/1504/1504_fig3.png)

这其实就是维护一个单调栈的过程，但是还没完，我们不能简单地将不满足条件的值从栈里弹出，以上面第 $i-1$ 行举例，它有 $\textit{row}[i][j]$ 大小的部分是需要统计入答案的，这个时候我们需要怎么做呢？

我们对单调栈存储的元素进行修改，改成存储一个二元组 $(\textit{row}[i][j], \textit{height})$，表示当前矩形的宽和高，一开始我们放入的单调栈的都是高为 $1$ 宽为 $\textit{row}[i][j]$ 的矩形，但碰到上面情况的时候，为了保留弹出元素中「可用部分」的答案，我们需要将当前要推入栈中的元素的高加上弹出元素的高，由于这个情况只会发生在推入元素小于栈顶元素的时候发生，因此矩形的宽一定是当前推入元素的 $\textit{row}$ 值，同时我们再维护一个到当前行的答案和 $\textit{sum}$ 值即可。

通过单调栈的使用，我们就不再需要每次枚举的时候再重复倒序枚举 $k$ 了，进一步优化了时间复杂度。 

<![fig1](https://assets.leetcode-cn.com/solution-static/1504/2_1.png),![fig2](https://assets.leetcode-cn.com/solution-static/1504/2_2.png),![fig3](https://assets.leetcode-cn.com/solution-static/1504/2_3.png),![fig4](https://assets.leetcode-cn.com/solution-static/1504/2_4.png),![fig5](https://assets.leetcode-cn.com/solution-static/1504/2_5.png),![fig6](https://assets.leetcode-cn.com/solution-static/1504/2_6.png),![fig7](https://assets.leetcode-cn.com/solution-static/1504/2_7.png),![fig8](https://assets.leetcode-cn.com/solution-static/1504/2_8.png),![fig9](https://assets.leetcode-cn.com/solution-static/1504/2_9.png),![fig10](https://assets.leetcode-cn.com/solution-static/1504/2_10.png)>

```C++ [sol2-C++]
class Solution {
public:
    int numSubmat(vector<vector<int>>& mat) {
        int n = mat.size();
        int m = mat[0].size();
        vector<vector<int> > row(n, vector<int>(m, 0));
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (j == 0) {
                    row[i][j] = mat[i][j];
                } else if (mat[i][j]) {
                    row[i][j] = row[i][j - 1] + 1;
                }
                else {
                    row[i][j] = 0;
                }
            }
        }
        int ans = 0;
        for (int j = 0; j < m; ++j) { 
            int i = 0; 
            stack<pair<int, int> > Q; 
            int sum = 0; 
            while (i <= n - 1) { 
                int height = 1; 
                while (!Q.empty() && Q.top().first > row[i][j]) {
                  	// 弹出的时候要减去多于的答案
                    sum -= Q.top().second * (Q.top().first - row[i][j]); 
                    height += Q.top().second; 
                    Q.pop(); 
                } 
                sum += row[i][j]; 
                ans += sum; 
                Q.push({ row[i][j], height }); 
                i++; 
            } 
        } 
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int numSubmat(int[][] mat) {
        int n = mat.length;
        int m = mat[0].length;
        int[][] row = new int[n][m];
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (j == 0) {
                    row[i][j] = mat[i][j];
                } else if (mat[i][j] != 0) {
                    row[i][j] = row[i][j - 1] + 1;
                } else {
                    row[i][j] = 0;
                }
            }
        }
        int ans = 0;
        for (int j = 0; j < m; ++j) { 
            int i = 0;
            Deque<int[]> Q = new LinkedList<int[]>();
            int sum = 0; 
            while (i <= n - 1) { 
                int height = 1; 
                while (!Q.isEmpty() && Q.peekFirst()[0] > row[i][j]) {
                  	// 弹出的时候要减去多于的答案
                    sum -= Q.peekFirst()[1] * (Q.peekFirst()[0] - row[i][j]); 
                    height += Q.peekFirst()[1]; 
                    Q.pollFirst(); 
                } 
                sum += row[i][j]; 
                ans += sum; 
                Q.offerFirst(new int[]{row[i][j], height}); 
                i++; 
            } 
        } 
        return ans;
    }
}
```

```C [sol2-C]
int numSubmat(int** mat, int matSize, int* matColSize) {
    int n = matSize;
    int m = matColSize[0];
    int row[n][m];
    memset(row, 0, sizeof(row));
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            if (j == 0) {
                row[i][j] = mat[i][j];
            } else if (mat[i][j]) {
                row[i][j] = row[i][j - 1] + 1;
            } else {
                row[i][j] = 0;
            }
        }
    }
    int* Sta1 = (int*)malloc(sizeof(int) * (n + 1));
    int* Sta2 = (int*)malloc(sizeof(int) * (n + 1));
    int ans = 0;
    for (int j = 0; j < m; ++j) {
        int i = 0;
        int top = 0;
        int sum = 0;
        while (i <= n - 1) {
            int height = 1;
            while (top && Sta1[top] > row[i][j]) {
                // 弹出的时候要减去多于的答案
                sum -= Sta2[top] * (Sta1[top] - row[i][j]);
                height += Sta2[top];
                top--;
            }
            sum += row[i][j];
            ans += sum;
            Sta1[++top] = row[i][j];
            Sta2[top] = height;
            i++;
        }
    }
    free(Sta1);
    free(Sta2);
    return ans;
}
```

```Python [sol2-Python3]
class Solution:
    def numSubmat(self, mat: List[List[int]]) -> int:
        n, m = len(mat), len(mat[0])
        
        row = [[0] * m for _ in range(n)]
        for i in range(n):
            for j in range(m):
                if j == 0:
                    row[i][j] = mat[i][j]
                else:
                    row[i][j] = 0 if mat[i][j] == 0 else row[i][j - 1] + 1
        
        ans = 0
        for j in range(m):
            Q = list()
            total = 0
            for i in range(n):
                height = 1
                while Q and Q[-1][0] > row[i][j]:
                    # 弹出的时候要减去多于的答案
                    total -= Q[-1][1] * (Q[-1][0] - row[i][j])
                    height += Q[-1][1]
                    Q.pop()
                total += row[i][j]
                ans += total
                Q.append((row[i][j], height))

        return ans
```

**复杂度分析**

- 时间复杂度：$O(nm)$，其中 $n$ 为矩阵行数，$m$ 为矩阵列数。预处理 $\textit{row}$ 数组需要 $O(nm)$ 的时间复杂度，计算答案的时候我们需要对 $O(m)$ 列进行统计，每一列统计答案的时候单调栈的时间复杂度为 $O(n)$，因此总时间复杂度为 $O(nm)$。
- 空间复杂度：$O(n)$。单调栈最坏情况下需要 $O(n)$ 的空间。