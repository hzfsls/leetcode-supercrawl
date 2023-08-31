## [120.三角形最小路径和 中文官方题解](https://leetcode.cn/problems/triangle/solutions/100000/san-jiao-xing-zui-xiao-lu-jing-he-by-leetcode-solu)
#### 前言

本题是一道非常经典且历史悠久的动态规划题，其作为算法题出现，最早可以追溯到 1994 年的 IOI（国际信息学奥林匹克竞赛）的 [The Triangle](https://ioinformatics.org/files/ioi1994problem1.pdf)。时光飞逝，经过 20 多年的沉淀，往日的国际竞赛题如今已经变成了动态规划的入门必做题，不断督促着我们学习和巩固算法。

在本题中，给定的三角形的行数为 $n$，并且第 $i$ 行（从 $0$ 开始编号）包含了 $i+1$ 个数。如果将每一行的左端对齐，那么会形成一个等腰直角三角形，如下所示：

```
[2]
[3,4]
[6,5,7]
[4,1,8,3]
```

#### 方法一：动态规划

**思路与算法**

我们用 $f[i][j]$ 表示从三角形顶部走到位置 $(i, j)$ 的最小路径和。这里的位置 $(i, j)$ 指的是三角形中第 $i$ 行第 $j$ 列（均从 $0$ 开始编号）的位置。

由于每一步只能移动到下一行「相邻的节点」上，因此要想走到位置 $(i, j)$，上一步就只能在位置 $(i - 1, j - 1)$ 或者位置 $(i - 1, j)$。我们在这两个位置中选择一个路径和较小的来进行转移，状态转移方程为：

$$
f[i][j] = \min(f[i-1][j-1], f[i-1][j]) + c[i][j]
$$

其中 $c[i][j]$ 表示位置 $(i, j)$ 对应的元素值。

注意第 $i$ 行有 $i+1$ 个元素，它们对应的 $j$ 的范围为 $[0, i]$。当 $j=0$ 或 $j=i$ 时，上述状态转移方程中有一些项是没有意义的。例如当 $j=0$ 时，$f[i-1][j-1]$ 没有意义，因此状态转移方程为：

$$
f[i][0] = f[i-1][0] + c[i][0]
$$

即当我们在第 $i$ 行的最左侧时，我们只能从第 $i-1$ 行的最左侧移动过来。当 $j=i$ 时，$f[i-1][j]$ 没有意义，因此状态转移方程为：

$$
f[i][i] = f[i-1][i-1] + c[i][i]
$$

即当我们在第 $i$ 行的最右侧时，我们只能从第 $i-1$ 行的最右侧移动过来。

最终的答案即为 $f[n-1][0]$ 到 $f[n-1][n-1]$ 中的最小值，其中 $n$ 是三角形的行数。

**细节**

状态转移方程的边界条件是什么？由于我们已经去除了所有「没有意义」的状态，因此边界条件可以定为：

$$
f[0][0] = c[0][0]
$$

即在三角形的顶部时，最小路径和就等于对应位置的元素值。这样一来，我们从 $1$ 开始递增地枚举 $i$，并在 $[0, i]$ 的范围内递增地枚举 $j$，就可以完成所有状态的计算。

```C++ [sol1-C++]
class Solution {
public:
    int minimumTotal(vector<vector<int>>& triangle) {
        int n = triangle.size();
        vector<vector<int>> f(n, vector<int>(n));
        f[0][0] = triangle[0][0];
        for (int i = 1; i < n; ++i) {
            f[i][0] = f[i - 1][0] + triangle[i][0];
            for (int j = 1; j < i; ++j) {
                f[i][j] = min(f[i - 1][j - 1], f[i - 1][j]) + triangle[i][j];
            }
            f[i][i] = f[i - 1][i - 1] + triangle[i][i];
        }
        return *min_element(f[n - 1].begin(), f[n - 1].end());
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minimumTotal(List<List<Integer>> triangle) {
        int n = triangle.size();
        int[][] f = new int[n][n];
        f[0][0] = triangle.get(0).get(0);
        for (int i = 1; i < n; ++i) {
            f[i][0] = f[i - 1][0] + triangle.get(i).get(0);
            for (int j = 1; j < i; ++j) {
                f[i][j] = Math.min(f[i - 1][j - 1], f[i - 1][j]) + triangle.get(i).get(j);
            }
            f[i][i] = f[i - 1][i - 1] + triangle.get(i).get(i);
        }
        int minTotal = f[n - 1][0];
        for (int i = 1; i < n; ++i) {
            minTotal = Math.min(minTotal, f[n - 1][i]);
        }
        return minTotal;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minimumTotal(self, triangle: List[List[int]]) -> int:
        n = len(triangle)
        f = [[0] * n for _ in range(n)]
        f[0][0] = triangle[0][0]

        for i in range(1, n):
            f[i][0] = f[i - 1][0] + triangle[i][0]
            for j in range(1, i):
                f[i][j] = min(f[i - 1][j - 1], f[i - 1][j]) + triangle[i][j]
            f[i][i] = f[i - 1][i - 1] + triangle[i][i]
        
        return min(f[n - 1])
```

```golang [sol1-Golang]
func minimumTotal(triangle [][]int) int {
    n := len(triangle)
    f := make([][]int, n)
    for i := 0; i < n; i++ {
        f[i] = make([]int, n)
    }
    f[0][0] = triangle[0][0]
    for i := 1; i < n; i++ {
        f[i][0] = f[i - 1][0] + triangle[i][0]
        for j := 1; j < i; j++ {
            f[i][j] = min(f[i - 1][j - 1], f[i - 1][j]) + triangle[i][j]
        }
        f[i][i] = f[i - 1][i - 1] + triangle[i][i]
    }
    ans := math.MaxInt32
    for i := 0; i < n; i++ {
        ans = min(ans, f[n-1][i])
    }
    return ans
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```

```C [sol1-C]
int minimumTotal(int** triangle, int triangleSize, int* triangleColSize) {
    int f[triangleSize][triangleSize];
    memset(f, 0, sizeof(f));
    f[0][0] = triangle[0][0];
    for (int i = 1; i < triangleSize; ++i) {
        f[i][0] = f[i - 1][0] + triangle[i][0];
        for (int j = 1; j < i; ++j) {
            f[i][j] = fmin(f[i - 1][j - 1], f[i - 1][j]) + triangle[i][j];
        }
        f[i][i] = f[i - 1][i - 1] + triangle[i][i];
    }
    int ret = f[triangleSize - 1][0];
    for (int i = 1; i < triangleSize; i++)
        ret = fmin(ret, f[triangleSize - 1][i]);
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是三角形的行数。

- 空间复杂度：$O(n^2)$。我们需要一个 $n*n$ 的二维数组存放所有的状态。


#### 方法二：动态规划 + 空间优化

**思路与算法**

在题目描述中的「进阶」部分，提到了可以将空间复杂度优化至 $O(n)$。

我们回顾方法一中的状态转移方程：

$$
\begin{aligned}
f[i][j] = \begin{cases}
f[i-1][0] + c[i][0], & j=0\\
f[i-1][i-1] + c[i][i], & j=i \\
\min(f[i-1][j-1], f[i-1][j]) + c[i][j], & \text{otherwise}
\end{cases}
\end{aligned}
$$

可以发现，$f[i][j]$ 只与 $f[i-1][..]$ 有关，而与 $f[i-2][..]$ 及之前的状态无关，因此我们不必存储这些无关的状态。具体地，我们使用两个长度为 $n$ 的一维数组进行转移，将 $i$ 根据奇偶性映射到其中一个一维数组，那么 $i-1$ 就映射到了另一个一维数组。这样我们使用这两个一维数组，交替地进行状态转移。

```C++ [sol2-C++]
class Solution {
public:
    int minimumTotal(vector<vector<int>>& triangle) {
        int n = triangle.size();
        vector<vector<int>> f(2, vector<int>(n));
        f[0][0] = triangle[0][0];
        for (int i = 1; i < n; ++i) {
            int curr = i % 2;
            int prev = 1 - curr;
            f[curr][0] = f[prev][0] + triangle[i][0];
            for (int j = 1; j < i; ++j) {
                f[curr][j] = min(f[prev][j - 1], f[prev][j]) + triangle[i][j];
            }
            f[curr][i] = f[prev][i - 1] + triangle[i][i];
        }
        return *min_element(f[(n - 1) % 2].begin(), f[(n - 1) % 2].end());
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minimumTotal(List<List<Integer>> triangle) {
        int n = triangle.size();
        int[][] f = new int[2][n];
        f[0][0] = triangle.get(0).get(0);
        for (int i = 1; i < n; ++i) {
            int curr = i % 2;
            int prev = 1 - curr;
            f[curr][0] = f[prev][0] + triangle.get(i).get(0);
            for (int j = 1; j < i; ++j) {
                f[curr][j] = Math.min(f[prev][j - 1], f[prev][j]) + triangle.get(i).get(j);
            }
            f[curr][i] = f[prev][i - 1] + triangle.get(i).get(i);
        }
        int minTotal = f[(n - 1) % 2][0];
        for (int i = 1; i < n; ++i) {
            minTotal = Math.min(minTotal, f[(n - 1) % 2][i]);
        }
        return minTotal;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def minimumTotal(self, triangle: List[List[int]]) -> int:
        n = len(triangle)
        f = [[0] * n for _ in range(2)]
        f[0][0] = triangle[0][0]

        for i in range(1, n):
            curr, prev = i % 2, 1 - i % 2
            f[curr][0] = f[prev][0] + triangle[i][0]
            for j in range(1, i):
                f[curr][j] = min(f[prev][j - 1], f[prev][j]) + triangle[i][j]
            f[curr][i] = f[prev][i - 1] + triangle[i][i]
        
        return min(f[(n - 1) % 2])
```

```golang [sol2-Golang]
func minimumTotal(triangle [][]int) int {
    n := len(triangle)
    f := [2][]int{}
    for i := 0; i < 2; i++ {
        f[i] = make([]int, n)
    }
    f[0][0] = triangle[0][0]
    for i := 1; i < n; i++ {
        curr := i % 2
        prev := 1 - curr
        f[curr][0] = f[prev][0] + triangle[i][0]
        for j := 1; j < i; j++ {
            f[curr][j] = min(f[prev][j - 1], f[prev][j]) + triangle[i][j]
        }
        f[curr][i] = f[prev][i - 1] + triangle[i][i]
    }
    ans := math.MaxInt32
    for i := 0; i < n; i++ {
        ans = min(ans, f[(n-1)%2][i])
    }
    return ans
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```

```C [sol2-C]
int minimumTotal(int** triangle, int triangleSize, int* triangleColSize) {
    int f[2][triangleSize];
    memset(f, 0, sizeof(f));
    f[0][0] = triangle[0][0];
    for (int i = 1; i < triangleSize; ++i) {
        int curr = i % 2;
        int prev = 1 - curr;
        f[curr][0] = f[prev][0] + triangle[i][0];
        for (int j = 1; j < i; ++j) {
            f[curr][j] = fmin(f[prev][j - 1], f[prev][j]) + triangle[i][j];
        }
        f[curr][i] = f[prev][i - 1] + triangle[i][i];
    }
    int ret = f[(triangleSize - 1) % 2][0];
    for (int i = 1; i < triangleSize; i++)
        ret = fmin(ret, f[(triangleSize - 1) % 2][i]);
    return ret;
}
```

上述方法的空间复杂度为 $O(n)$，使用了 $2n$ 的空间存储状态。我们还可以继续进行优化吗？

答案是可以的。我们从 $i$ 到 $0$ 递减地枚举 $j$，这样我们只需要一个长度为 $n$ 的一维数组 $f$，就可以完成状态转移。

> 为什么只有在递减地枚举 $j$ 时，才能省去一个一维数组？当我们在计算位置 $(i, j)$ 时，$f[j+1]$ 到 $f[i]$ 已经是第 $i$ 行的值，而 $f[0]$ 到 $f[j]$ 仍然是第 $i-1$ 行的值。此时我们直接通过

$$
f[j] = \min(f[j-1], f[j]) + c[i][j]
$$

> 进行转移，恰好就是在 $(i-1, j-1)$ 和 $(i-1, j)$ 中进行选择。但如果我们递增地枚举 $j$，那么在计算位置 $(i, j)$ 时，$f[0]$ 到 $f[j-1]$ 已经是第 $i$ 行的值。如果我们仍然使用上述状态转移方程，那么是在 $(i, j-1)$ 和 $(i-1, j)$ 中进行选择，就产生了错误。

这样虽然空间复杂度仍然为 $O(n)$，但我们只使用了 $n$ 的空间存储状态，减少了一半的空间消耗。

```C++ [sol3-C++]
class Solution {
public:
    int minimumTotal(vector<vector<int>>& triangle) {
        int n = triangle.size();
        vector<int> f(n);
        f[0] = triangle[0][0];
        for (int i = 1; i < n; ++i) {
            f[i] = f[i - 1] + triangle[i][i];
            for (int j = i - 1; j > 0; --j) {
                f[j] = min(f[j - 1], f[j]) + triangle[i][j];
            }
            f[0] += triangle[i][0];
        }
        return *min_element(f.begin(), f.end());
    }
};
```

```Java [sol3-Java]
class Solution {
    public int minimumTotal(List<List<Integer>> triangle) {
        int n = triangle.size();
        int[] f = new int[n];
        f[0] = triangle.get(0).get(0);
        for (int i = 1; i < n; ++i) {
            f[i] = f[i - 1] + triangle.get(i).get(i);
            for (int j = i - 1; j > 0; --j) {
                f[j] = Math.min(f[j - 1], f[j]) + triangle.get(i).get(j);
            }
            f[0] += triangle.get(i).get(0);
        }
        int minTotal = f[0];
        for (int i = 1; i < n; ++i) {
            minTotal = Math.min(minTotal, f[i]);
        }
        return minTotal;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def minimumTotal(self, triangle: List[List[int]]) -> int:
        n = len(triangle)
        f = [0] * n
        f[0] = triangle[0][0]

        for i in range(1, n):
            f[i] = f[i - 1] + triangle[i][i]
            for j in range(i - 1, 0, -1):
                f[j] = min(f[j - 1], f[j]) + triangle[i][j]
            f[0] += triangle[i][0]
        
        return min(f)
```

```golang [sol3-Golang]
func minimumTotal(triangle [][]int) int {
    n := len(triangle)
    f := make([]int, n)
    f[0] = triangle[0][0]
    for i := 1; i < n; i++ {
        f[i] = f[i - 1] + triangle[i][i]
        for j := i - 1; j > 0; j-- {
            f[j] = min(f[j - 1], f[j]) + triangle[i][j]
        }
        f[0] += triangle[i][0]
    }
    ans := math.MaxInt32
    for i := 0; i < n; i++ {
        ans = min(ans, f[i])
    }
    return ans
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```

```C [sol3-C]
int minimumTotal(int** triangle, int triangleSize, int* triangleColSize) {
    int f[triangleSize];
    memset(f, 0, sizeof(f));
    f[0] = triangle[0][0];
    for (int i = 1; i < triangleSize; ++i) {
        f[i] = f[i - 1] + triangle[i][i];
        for (int j = i - 1; j > 0; --j) {
            f[j] = fmin(f[j - 1], f[j]) + triangle[i][j];
        }
        f[0] += triangle[i][0];
    }
    int ret = f[0];
    for (int i = 1; i < triangleSize; i++) ret = fmin(ret, f[i]);
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是三角形的行数。

- 空间复杂度：$O(n)$。

#### 结语

本题还有一些其它的动态规划方法，例如：

- 从三角形的底部开始转移，到顶部结束；

- 直接在给定的三角形数组上进行状态转移，不使用额外的空间。

读者可以自行尝试。如果在面试中遇到类似的题目，需要和面试官进行沟通，可以询问「是否有空间复杂度限制」「是否可以修改原数组」等问题，给出符合条件的算法。