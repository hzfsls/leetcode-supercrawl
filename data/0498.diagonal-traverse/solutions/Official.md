#### 方法一：直接模拟

**思路与算法**

根据题目要求，矩阵按照对角线进行遍历。设矩阵的行数为 $m$, 矩阵的列数为 $n$, 我们仔细观察对角线遍历的规律可以得到如下信息:

+ 一共有 $m + n - 1$ 条对角线，相邻的对角线的遍历方向不同，当前遍历方向为从左下到右上，则紧挨着的下一条对角线遍历方向为从右上到左下；

+ 设对角线从上到下的编号为 $i \in [0, m + n - 2]$：
    - 当 $i$ 为偶数时，则第 $i$ 条对角线的走向是从下往上遍历；
    - 当 $i$ 为奇数时，则第 $i$ 条对角线的走向是从上往下遍历；

+ 当第 $i$ 条对角线从下往上遍历时，每次行索引减 $1$，列索引加 $1$，直到矩阵的边缘为止：
    - 当 $i < m$ 时，则此时对角线遍历的起点位置为 $(i,0)$；
    - 当 $i \ge m$ 时，则此时对角线遍历的起点位置为 $(m - 1, i - m + 1)$；

+ 当第 $i$ 条对角线从上往下遍历时，每次行索引加 $1$，列索引减 $1$，直到矩阵的边缘为止： 
    - 当 $i < n$ 时，则此时对角线遍历的起点位置为 $(0, i)$；
    - 当 $i \ge n$ 时，则此时对角线遍历的起点位置为 $(i - n + 1, n - 1)$；

根据以上观察得出的结论，我们直接模拟遍历所有的对角线即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def findDiagonalOrder(self, mat: List[List[int]]) -> List[int]:
        ans = []
        m, n = len(mat), len(mat[0])
        for i in range(m + n - 1):
            if i % 2:
                x = 0 if i < n else i - n + 1
                y = i if i < n else n - 1
                while x < m and y >= 0:
                    ans.append(mat[x][y])
                    x += 1
                    y -= 1
            else:
                x = i if i < m else m - 1
                y = 0 if i < m else i - m + 1
                while x >= 0 and y < n:
                    ans.append(mat[x][y])
                    x -= 1
                    y += 1
        return ans
```

```Java [sol1-Java]
class Solution {
    public int[] findDiagonalOrder(int[][] mat) {
        int m = mat.length;
        int n = mat[0].length;
        int[] res = new int[m * n];
        int pos = 0;
        for (int i = 0; i < m + n - 1; i++) {
            if (i % 2 == 1) {
                int x = i < n ? 0 : i - n + 1;
                int y = i < n ? i : n - 1;
                while (x < m && y >= 0) {
                    res[pos] = mat[x][y];
                    pos++;
                    x++;
                    y--;
                }
            } else {
                int x = i < m ? i : m - 1;
                int y = i < m ? 0 : i - m + 1;
                while (x >= 0 && y < n) {
                    res[pos] = mat[x][y];
                    pos++;
                    x--;
                    y++;
                }
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findDiagonalOrder(vector<vector<int>>& mat) {
        int m = mat.size();
        int n = mat[0].size();
        vector<int> res;
        for (int i = 0; i < m + n - 1; i++) {
            if (i % 2) {
                int x = i < n ? 0 : i - n + 1;
                int y = i < n ? i : n - 1;
                while (x < m && y >= 0) {
                    res.emplace_back(mat[x][y]);
                    x++;
                    y--;
                }
            } else {
                int x = i < m ? i : m - 1;
                int y = i < m ? 0 : i - m + 1;
                while (x >= 0 && y < n) {
                    res.emplace_back(mat[x][y]);
                    x--;
                    y++;
                }
            }
        }
        return res;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int[] FindDiagonalOrder(int[][] mat) {
        int m = mat.Length;
        int n = mat[0].Length;
        int[] res = new int[m * n];
        int pos = 0;
        for (int i = 0; i < m + n - 1; i++) {
            if (i % 2 == 1) {
                int x = i < n ? 0 : i - n + 1;
                int y = i < n ? i : n - 1;
                while (x < m && y >= 0) {
                    res[pos] = mat[x][y];
                    pos++;
                    x++;
                    y--;
                }
            } else {
                int x = i < m ? i : m - 1;
                int y = i < m ? 0 : i - m + 1;
                while (x >= 0 && y < n) {
                    res[pos] = mat[x][y];
                    pos++;
                    x--;
                    y++;
                }
            }
        }
        return res;
    }
}
```

```C [sol1-C]
int* findDiagonalOrder(int** mat, int matSize, int* matnSize, int* returnSize) {
    int m = matSize;
    int n = matnSize[0];
    int *res = (int *)malloc(sizeof(int) * m * n);
    int pos = 0;
    for (int i = 0; i < m + n - 1; i++) {
        if (i % 2) {
            int x = i < n ? 0 : i - n + 1;
            int y = i < n ? i : n - 1;
            while (x < m && y >= 0) {
                res[pos] = mat[x][y];
                pos++;
                x++;
                y--;
            }
        } else {
            int x = i < m ? i : m - 1;
            int y = i < m ? 0 : i - m + 1;
            while (x >= 0 && y < n) {
                res[pos] = mat[x][y];
                pos++;
                x--;
                y++;
            }
        }
    }
    *returnSize = m * n;
    return res;
}
```

```go [sol1-Golang]
func findDiagonalOrder(mat [][]int) []int {
    m, n := len(mat), len(mat[0])
    ans := make([]int, 0, m*n)
    for i := 0; i < m+n-1; i++ {
        if i%2 == 1 {
            x := max(i-n+1, 0)
            y := min(i, n-1)
            for x < m && y >= 0 {
                ans = append(ans, mat[x][y])
                x++
                y--
            }
        } else {
            x := min(i, m-1)
            y := max(i-m+1, 0)
            for x >= 0 && y < n {
                ans = append(ans, mat[x][y])
                x--
                y++
            }
        }
    }
    return ans
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var findDiagonalOrder = function(mat) {
    const m = mat.length;
    const n = mat[0].length;
    const res = new Array(m * n).fill(0);
    let pos = 0;
    for (let i = 0; i < m + n - 1; i++) {
        if (i % 2 === 1) {
            let x = i < n ? 0 : i - n + 1;
            let y = i < n ? i : n - 1;
            while (x < m && y >= 0) {
                res[pos] = mat[x][y];
                pos++;
                x++;
                y--;
            }
        } else {
            let x = i < m ? i : m - 1;
            let y = i < m ? 0 : i - m + 1;
            while (x >= 0 && y < n) {
                res[pos] = mat[x][y];
                pos++;
                x--;
                y++;
            }
        }
    }
    return res;
};
```

**复杂度分析**

+ 时间复杂度：$O(m \times n)$，其中 $m$ 为矩阵行的数量，$n$ 为矩阵列的数量。需要遍历一遍矩阵中的所有元素，需要的时间复杂度为 $O(m \times n)$。

+ 空间复杂度：$O(1)$。除返回值外不需要额外的空间。