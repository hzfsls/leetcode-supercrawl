## [240.搜索二维矩阵 II 中文官方题解](https://leetcode.cn/problems/search-a-2d-matrix-ii/solutions/100000/sou-suo-er-wei-ju-zhen-ii-by-leetcode-so-9hcx)
#### 方法一：直接查找

**思路与算法**

我们直接遍历整个矩阵 $\textit{matrix}$，判断 $\textit{target}$ 是否出现即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool searchMatrix(vector<vector<int>>& matrix, int target) {
        for (const auto& row: matrix) {
            for (int element: row) {
                if (element == target) {
                    return true;
                }
            }
        }
        return false;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        for (int[] row : matrix) {
            for (int element : row) {
                if (element == target) {
                    return true;
                }
            }
        }
        return false;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool SearchMatrix(int[][] matrix, int target) {
        foreach (int[] row in matrix) {
            foreach (int element in row) {
                if (element == target) {
                    return true;
                }
            }
        }
        return false;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        for row in matrix:
            for element in row:
                if element == target:
                    return True
        return False
```

```go [sol1-Golang]
func searchMatrix(matrix [][]int, target int) bool {
    for _, row := range matrix {
        for _, v := range row {
            if v == target {
                return true
            }
        }
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$。

- 空间复杂度：$O(1)$。

#### 方法二：二分查找

**思路与算法**

由于矩阵 $\textit{matrix}$ 中每一行的元素都是升序排列的，因此我们可以对每一行都使用一次二分查找，判断 $\textit{target}$ 是否在该行中，从而判断 $\textit{target}$ 是否出现。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    bool searchMatrix(vector<vector<int>>& matrix, int target) {
        for (const auto& row: matrix) {
            auto it = lower_bound(row.begin(), row.end(), target);
            if (it != row.end() && *it == target) {
                return true;
            }
        }
        return false;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        for (int[] row : matrix) {
            int index = search(row, target);
            if (index >= 0) {
                return true;
            }
        }
        return false;
    }

    public int search(int[] nums, int target) {
        int low = 0, high = nums.length - 1;
        while (low <= high) {
            int mid = (high - low) / 2 + low;
            int num = nums[mid];
            if (num == target) {
                return mid;
            } else if (num > target) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }
        }
        return -1;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool SearchMatrix(int[][] matrix, int target) {
        foreach (int[] row in matrix) {
            int index = Search(row, target);
            if (index >= 0) {
                return true;
            }
        }
        return false;
    }

    public int Search(int[] nums, int target) {
        int low = 0, high = nums.Length - 1;
        while (low <= high) {
            int mid = (high - low) / 2 + low;
            int num = nums[mid];
            if (num == target) {
                return mid;
            } else if (num > target) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }
        }
        return -1;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        for row in matrix:
            idx = bisect.bisect_left(row, target)
            if idx < len(row) and row[idx] == target:
                return True
        return False
```

```JavaScript [sol2-JavaScript]
var searchMatrix = function(matrix, target) {
    for (const row of matrix) {
        const index = search(row, target);
        if (index >= 0) {
            return true;
        }
    }
    return false;
};

const search = (nums, target) => {
    let low = 0, high = nums.length - 1;
    while (low <= high) {
        const mid = Math.floor((high - low) / 2) + low;
        const num = nums[mid];
        if (num === target) {
            return mid;
        } else if (num > target) {
            high = mid - 1;
        } else {
            low = mid + 1;
        }
    }
    return -1;
}
```

```go [sol2-Golang]
func searchMatrix(matrix [][]int, target int) bool {
    for _, row := range matrix {
        i := sort.SearchInts(row, target)
        if i < len(row) && row[i] == target {
            return true
        }
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(m \log n)$。对一行使用二分查找的时间复杂度为 $O(\log n)$，最多需要进行 $m$ 次二分查找。

- 空间复杂度：$O(1)$。

#### 方法三：Z 字形查找

**思路与算法**

我们可以从矩阵 $\textit{matrix}$ 的右上角 $(0, n-1)$ 进行搜索。在每一步的搜索过程中，如果我们位于位置 $(x, y)$，那么我们希望在以 $\textit{matrix}$ 的左下角为左下角、以 $(x, y)$ 为右上角的矩阵中进行搜索，即行的范围为 $[x, m - 1]$，列的范围为 $[0, y]$：

- 如果 $\textit{matrix}[x, y] = \textit{target}$，说明搜索完成；

- 如果 $\textit{matrix}[x, y] > \textit{target}$，由于每一列的元素都是升序排列的，那么在当前的搜索矩阵中，所有位于第 $y$ 列的元素都是严格大于 $\textit{target}$ 的，因此我们可以将它们全部忽略，即将 $y$ 减少 $1$；

- 如果 $\textit{matrix}[x, y] < \textit{target}$，由于每一行的元素都是升序排列的，那么在当前的搜索矩阵中，所有位于第 $x$ 行的元素都是严格小于 $\textit{target}$ 的，因此我们可以将它们全部忽略，即将 $x$ 增加 $1$。

在搜索的过程中，如果我们超出了矩阵的边界，那么说明矩阵中不存在 $\textit{target}$。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    bool searchMatrix(vector<vector<int>>& matrix, int target) {
        int m = matrix.size(), n = matrix[0].size();
        int x = 0, y = n - 1;
        while (x < m && y >= 0) {
            if (matrix[x][y] == target) {
                return true;
            }
            if (matrix[x][y] > target) {
                --y;
            }
            else {
                ++x;
            }
        }
        return false;
    }
};
```

```Java [sol3-Java]
class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        int m = matrix.length, n = matrix[0].length;
        int x = 0, y = n - 1;
        while (x < m && y >= 0) {
            if (matrix[x][y] == target) {
                return true;
            }
            if (matrix[x][y] > target) {
                --y;
            } else {
                ++x;
            }
        }
        return false;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public bool SearchMatrix(int[][] matrix, int target) {
        int m = matrix.Length, n = matrix[0].Length;
        int x = 0, y = n - 1;
        while (x < m && y >= 0) {
            if (matrix[x][y] == target) {
                return true;
            }
            if (matrix[x][y] > target) {
                --y;
            } else {
                ++x;
            }
        }
        return false;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        m, n = len(matrix), len(matrix[0])
        x, y = 0, n - 1
        while x < m and y >= 0:
            if matrix[x][y] == target:
                return True
            if matrix[x][y] > target:
                y -= 1
            else:
                x += 1
        return False
```

```JavaScript [sol3-JavaScript]
var searchMatrix = function(matrix, target) {
    const m = matrix.length, n = matrix[0].length;
    let x = 0, y = n - 1;
    while (x < m && y >= 0) {
        if (matrix[x][y] === target) {
            return true;
        }
        if (matrix[x][y] > target) {
            --y;
        } else {
            ++x;
        }
    }
    return false;
};
```

```go [sol3-Golang]
func searchMatrix(matrix [][]int, target int) bool {
    m, n := len(matrix), len(matrix[0])
    x, y := 0, n-1
    for x < m && y >= 0 {
        if matrix[x][y] == target {
            return true
        }
        if matrix[x][y] > target {
            y--
        } else {
            x++
        }
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(m + n)$。在搜索的过程中，如果我们没有找到 $\textit{target}$，那么我们要么将 $y$ 减少 $1$，要么将 $x$ 增加 $1$。由于 $(x, y)$ 的初始值分别为 $(0, n-1)$，因此 $y$ 最多能被减少 $n$ 次，$x$ 最多能被增加 $m$ 次，总搜索次数为 $m + n$。在这之后，$x$ 和 $y$ 就会超出矩阵的边界。

- 空间复杂度：$O(1)$。