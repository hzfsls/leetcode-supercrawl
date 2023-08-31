## [1253.重构 2 行二进制矩阵 中文官方题解](https://leetcode.cn/problems/reconstruct-a-2-row-binary-matrix/solutions/100000/zhong-gou-2-xing-er-jin-zhi-ju-zhen-by-l-if8v)
#### 方法一：贪心

**思路与算法**

我们需要求得任意一个 $2$ 行 $n$ 列的二进制数组（其中行和列的序号从 $0$ 开始），满足数组中的每一个元素不是 $0$ 就是 $1$，并且第 $0$ 行的元素和为 $\textit{upper}$，第 $1$ 行的元素和为 $\textit{lower}$，第 $i$ 列的元素之和为 $\textit{colsum}[i]$，若不存在直接返回一个空的二维数组即可。

记 $\textit{sum}$ 为数组 $\textit{colsum}$ 的元素和，$\textit{two}$ 为数组 $\textit{colsum}$ 中 $2$ 的个数。明显当 $\textit{sum} \neq \textit{upper} + \textit{lower}$ 时，一定不存在满足题意的矩阵。然后当第 $i$ 列 $\textit{colsum}[i] = 2$ 时，第 $i$ 列的两个元素只能都为 $1$。那么如果 $\textit{two} > \min\{\textit{upper}, \textit{lower}\}$ 时，此时同样不存在满足题意的矩阵。

否则我们一定可以通过下述的方案来构造一个符合题目要求的矩阵。设结果矩阵为 $\textit{res}[2][n]$。当第 $i$ 列 $\textit{colsum}[i]$ 等于 $0$ 或者 $2$ 时只有一种情况：

- $\textit{colsum}[i] = 0$ 时：$\textit{res}[0][i] = \textit{res}[1][i] = 0$。
- $\textit{colsum}[i] = 2$ 时：$\textit{res}[0][i] = \textit{res}[1][i] = 1$。
  
所以现在我们只关注 $\textit{colsum}[i] = 1$ 的情况。首先我们将初始的 $\textit{upper}$ 和 $\textit{lower}$ 减去数组 $\textit{colsum}$ 中 $2$ 的个数 $\textit{two}$，那么现在 $\textit{upper} + \textit{lower}$ 为数组 $\textit{colsum}$ 中 $1$ 的个数。那么我们将从左到右遍历 $\textit{colsum}$ 中的每一列，若第 $i$ 列 $\textit{colsum}[i]$ 等于 $1$：

- 若 $\textit{upper} > 0$，则我们在该列的第一行放置 $1$，第二行放置 $0$：$\textit{res}[0][i] = 1$，$\textit{res}[1][i] = 0$，并且 $\textit{upper}$ 减一。
- 否则我们在该列的第一行放置 $0$，第二行放置 $1$：$\textit{res}[0][i] = 0$，$\textit{res}[1][i] = 1$。

当遍历完成后就得到了符合题目要求的矩阵 $\textit{res}[2][n]$。现在给出该方案的正确性证明：从上述的构造过程可以得到，整个数组中除了 $1$ 就 $0$，每一列中 $1$ 的个数完全符合数组 $\textit{colsum}$ 描述，且在第一行中我们共放置了 $\textit{upper}$ 个 $1$，第二行共放置了 $\textit{lower}$ 个 $1$。因此这样构造的矩阵 $\textit{res}[2][n]$ 为满足题意的二进制矩阵，正确性得证。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> reconstructMatrix(int upper, int lower, vector<int>& colsum) {
        int n = colsum.size();
        int sum = 0, two = 0;
        for (int i = 0; i < n; ++i) {
            if (colsum[i] == 2) {
                ++two;
            }
            sum += colsum[i];
        }
        if (sum != upper + lower || min(upper, lower) < two) {
            return {};
        }
        upper -= two;
        lower -= two;
        vector<vector<int>> res(2, vector<int>(n, 0));
        for (int i = 0; i < n; ++i) {
            if (colsum[i] == 2) {
                res[0][i] = res[1][i] = 1;
            } else if (colsum[i] == 1) {
                if (upper > 0) {
                    res[0][i] = 1;
                    --upper;
                } else {
                    res[1][i] = 1;
                }
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<List<Integer>> reconstructMatrix(int upper, int lower, int[] colsum) {
        int n = colsum.length;
        int sum = 0, two = 0;
        for (int i = 0; i < n; ++i) {
            if (colsum[i] == 2) {
                ++two;
            }
            sum += colsum[i];
        }
        if (sum != upper + lower || Math.min(upper, lower) < two) {
            return new ArrayList<List<Integer>>();
        }
        upper -= two;
        lower -= two;
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        for (int i = 0; i < 2; ++i) {
            res.add(new ArrayList<Integer>());
        }
        for (int i = 0; i < n; ++i) {
            if (colsum[i] == 2) {
                res.get(0).add(1);
                res.get(1).add(1);
            } else if (colsum[i] == 1) {
                if (upper > 0) {
                    res.get(0).add(1);
                    res.get(1).add(0);
                    --upper;
                } else {
                    res.get(0).add(0);
                    res.get(1).add(1);
                }
            } else {
                res.get(0).add(0);
                res.get(1).add(0);
            }
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def reconstructMatrix(self, upper: int, lower: int, colsum: List[int]) -> List[List[int]]:
        n = len(colsum)
        sum_val = 0
        two_num = 0
        for i in range(n):
            if colsum[i] == 2:
                two_num += 1
            sum_val += colsum[i]
        if sum_val != upper + lower or min(upper, lower) < two_num:
            return []
        upper -= two_num
        lower -= two_num
        res = [[0] * n for _ in range(2)]
        for i in range(n):
            if colsum[i] == 2:
                res[0][i] = res[1][i] = 1
            elif colsum[i] == 1:
                if upper > 0:
                    res[0][i] = 1
                    upper -= 1
                else:
                    res[1][i] = 1
        return res
```

```Go [sol1-Go]
func reconstructMatrix(upper int, lower int, colsum []int) [][]int {
    n := len(colsum)
    sumVal := 0
    twoNum := 0
    for i := 0; i < n; i++ {
        if colsum[i] == 2 {
            twoNum++
        }
        sumVal += colsum[i]
    }
    if sumVal != upper + lower || math.Min(float64(upper), float64(lower)) < float64(twoNum) {
        return [][]int{}
    }
    upper -= twoNum
    lower -= twoNum
    res := make([][]int, 2)
    for i := 0; i < 2; i++ {
        res[i] = make([]int, n)
    }
    for i := 0; i < n; i++ {
        if colsum[i] == 2 {
            res[0][i], res[1][i] = 1, 1
        } else if colsum[i] == 1 {
            if upper > 0 {
                res[0][i] = 1
                upper--
            } else {
                res[1][i] = 1
            }
        }
    }
    return res
}
```

```JavaScript [sol1-JavaScript]
var reconstructMatrix = function(upper, lower, colsum) {
    let n = colsum.length;
    let sumVal = 0;
    let twoNum = 0;
    for (let i = 0; i < n; i++) {
        if (colsum[i] == 2) {
            twoNum++;
        }
        sumVal += colsum[i];
    }
    if (sumVal != upper + lower || Math.min(upper, lower) < twoNum) {
        return [];
    }
    upper -= twoNum;
    lower -= twoNum;
    let res = Array.from({ length: 2 }, () => new Array(n).fill(0));
    for (let i = 0; i < n; i++) {
        if (colsum[i] == 2) {
            res[0][i] = res[1][i] = 1;
        } else if (colsum[i] == 1) {
            if (upper > 0) {
                res[0][i] = 1;
                upper--;
            } else {
                res[1][i] = 1;
            }
        }
    }
    return res;
}
```

```C# [sol1-C#]
public class Solution {
    public IList<IList<int>> ReconstructMatrix(int upper, int lower, int[] colsum) {
        int n = colsum.Length;
        int sum = 0, two = 0;
        for (int i = 0; i < n; ++i) {
            if (colsum[i] == 2) {
                ++two;
            }
            sum += colsum[i];
        }
        if (sum != upper + lower || Math.Min(upper, lower) < two) {
            return new List<IList<int>>();
        }
        upper -= two;
        lower -= two;
        IList<IList<int>> res = new List<IList<int>>();
        for (int i = 0; i < 2; ++i) {
            res.Add(new List<int>());
        }
        for (int i = 0; i < n; ++i) {
            if (colsum[i] == 2) {
                res[0].Add(1);
                res[1].Add(1);
            } else if (colsum[i] == 1) {
                if (upper > 0) {
                    res[0].Add(1);
                    res[1].Add(0);
                    --upper;
                } else {
                    res[0].Add(0);
                    res[1].Add(1);
                }
            } else {
                res[0].Add(0);
                res[1].Add(0);
            }
        }
        return res;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int** reconstructMatrix(int upper, int lower, int* colsum, int colsumSize, int* returnSize, int** returnColumnSizes) {
    int n = colsumSize;
    int sum = 0, two = 0;
    for (int i = 0; i < n; ++i) {
        if (colsum[i] == 2) {
            ++two;
        }
        sum += colsum[i];
    }
    if (sum != upper + lower || MIN(upper, lower) < two) {
        *returnSize = 0;
        return NULL;
    }
    upper -= two;
    lower -= two;
    int **res = (int **)malloc(sizeof(int *) * 2);
    *returnColumnSizes = (int *)malloc(sizeof(int) * 2);
    for (int i = 0; i < 2; i++) {
        res[i] = (int *)calloc(n, sizeof(int));
        (*returnColumnSizes)[i] = n;
    }
    for (int i = 0; i < n; ++i) {
        if (colsum[i] == 2) {
            res[0][i] = res[1][i] = 1;
        } else if (colsum[i] == 1) {
            if (upper > 0) {
                res[0][i] = 1;
                --upper;
            } else {
                res[1][i] = 1;
            }
        }
    }
    *returnSize = 2;
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{colsum}$ 的长度。
- 空间复杂度：$O(1)$，仅使用常量空间。注意返回的结果数组不计入空间开销。