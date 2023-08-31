## [48.旋转图像 中文官方题解](https://leetcode.cn/problems/rotate-image/solutions/100000/xuan-zhuan-tu-xiang-by-leetcode-solution-vu3m)

### 📺 视频题解  

![48. 旋转图像.mp4](c822bfe3-419a-42d1-a358-a78067a76355)

### 📖 文字题解

#### 方法一：使用辅助数组

我们以题目中的示例二

$$
\begin{bmatrix}
5 & 1 & 9 & 11 \\
2 & 4 & 8 & 10 \\
13 & 3 & 6 & 7 \\
15 & 14 & 12 & 16
\end{bmatrix}
$$

作为例子，分析将图像旋转 90 度之后，这些数字出现在什么位置。

对于矩阵中的第一行而言，在旋转后，它出现在倒数第一列的位置：

$$
\begin{bmatrix}
5 & 1 & 9 & 11 \\
\circ & \circ & \circ & \circ \\
\circ & \circ & \circ & \circ \\
\circ & \circ & \circ & \circ \\
\end{bmatrix}
\xRightarrow[]{旋转后}
\begin{bmatrix}
\circ & \circ & \circ & 5 \\
\circ & \circ & \circ & 1 \\
\circ & \circ & \circ & 9 \\
\circ & \circ & \circ & 11
\end{bmatrix}
$$

并且，第一行的第 $x$ 个元素在旋转后恰好是倒数第一列的第 $x$ 个元素。

对于矩阵中的第二行而言，在旋转后，它出现在倒数第二列的位置：

$$
\begin{bmatrix}
\circ & \circ & \circ & \circ \\
2 & 4 & 8 & 10 \\
\circ & \circ & \circ & \circ \\
\circ & \circ & \circ & \circ
\end{bmatrix}
\xRightarrow[]{旋转后}
\begin{bmatrix}
\circ & \circ & 2 & \circ \\
\circ & \circ & 4 & \circ \\
\circ & \circ & 8 & \circ \\
\circ & \circ & 10 & \circ
\end{bmatrix}
$$

对于矩阵中的第三行和第四行同理。这样我们可以得到规律：

> 对于矩阵中第 $i$ 行的第 $j$ 个元素，在旋转后，它出现在倒数第 $i$ 列的第 $j$ 个位置。

我们将其翻译成代码。由于矩阵中的行列从 $0$ 开始计数，因此对于矩阵中的元素 $\textit{matrix}[\textit{row}][\textit{col}]$，在旋转后，它的新位置为 $\textit{matrix}_\textit{new}[\textit{col}][n - \textit{row} - 1]$。

这样以来，我们使用一个与 $\textit{matrix}$ 大小相同的辅助数组 ${matrix}_\textit{new}$，临时存储旋转后的结果。我们遍历 $\textit{matrix}$ 中的每一个元素，根据上述规则将该元素存放到 ${matrix}_\textit{new}$ 中对应的位置。在遍历完成之后，再将 ${matrix}_\textit{new}$ 中的结果复制到原数组中即可。

```C++ [sol1-C++]
class Solution {
public:
    void rotate(vector<vector<int>>& matrix) {
        int n = matrix.size();
        // C++ 这里的 = 拷贝是值拷贝，会得到一个新的数组
        auto matrix_new = matrix;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                matrix_new[j][n - i - 1] = matrix[i][j];
            }
        }
        // 这里也是值拷贝
        matrix = matrix_new;
    }
};
```

```Java [sol1-Java]
class Solution {
    public void rotate(int[][] matrix) {
        int n = matrix.length;
        int[][] matrix_new = new int[n][n];
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                matrix_new[j][n - i - 1] = matrix[i][j];
            }
        }
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                matrix[i][j] = matrix_new[i][j];
            }
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def rotate(self, matrix: List[List[int]]) -> None:
        n = len(matrix)
        # Python 这里不能 matrix_new = matrix 或 matrix_new = matrix[:] 因为是引用拷贝
        matrix_new = [[0] * n for _ in range(n)]
        for i in range(n):
            for j in range(n):
                matrix_new[j][n - i - 1] = matrix[i][j]
        # 不能写成 matrix = matrix_new
        matrix[:] = matrix_new
```

```JavaScript [sol1-JavaScript]
var rotate = function(matrix) {
    const n = matrix.length;
    const matrix_new = new Array(n).fill(0).map(() => new Array(n).fill(0));
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            matrix_new[j][n - i - 1] = matrix[i][j];
        }
    }
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            matrix[i][j] = matrix_new[i][j];
        }
    }
};
```

```Go [sol1-Golang]
func rotate(matrix [][]int) {
    n := len(matrix)
    tmp := make([][]int, n)
    for i := range tmp {
        tmp[i] = make([]int, n)
    }
    for i, row := range matrix {
        for j, v := range row {
            tmp[j][n-1-i] = v
        }
    }
    copy(matrix, tmp) // 拷贝 tmp 矩阵每行的引用
}
```

```C [sol1-C]
void rotate(int** matrix, int matrixSize, int* matrixColSize) {
    int matrix_new[matrixSize][matrixSize];
    for (int i = 0; i < matrixSize; i++) {
        for (int j = 0; j < matrixSize; j++) {
            matrix_new[i][j] = matrix[i][j];
        }
    }
    for (int i = 0; i < matrixSize; ++i) {
        for (int j = 0; j < matrixSize; ++j) {
            matrix[j][matrixSize - i - 1] = matrix_new[i][j];
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 是 $\textit{matrix}$ 的边长。

- 空间复杂度：$O(N^2)$。我们需要使用一个和 $\textit{matrix}$ 大小相同的辅助数组。

#### 方法二：原地旋转

题目中要求我们尝试在不使用额外内存空间的情况下进行矩阵的旋转，也就是说，我们需要「原地旋转」这个矩阵。那么我们如何在方法一的基础上完成原地旋转呢？

我们观察方法一中的关键等式：

$$
\textit{matrix}_\textit{new}[\textit{col}][n - \textit{row} - 1] = \textit{matrix}[\textit{row}][\textit{col}]
$$

它阻止了我们进行原地旋转，这是因为如果我们直接将 $\textit{matrix}[\textit{row}][\textit{col}]$ 放到原矩阵中的目标位置 $\textit{matrix}[\textit{col}][n - \textit{row} - 1]$：

$$
\textit{matrix}[\textit{col}][n - \textit{row} - 1] = \textit{matrix}[\textit{row}][\textit{col}]
$$

原矩阵中的 $\textit{matrix}[\textit{col}][n - \textit{row} - 1]$ 就被覆盖了！这并不是我们想要的结果。因此我们可以考虑用一个临时变量 $\textit{temp}$ 暂存 $\textit{matrix}[\textit{col}][n - \textit{row} - 1]$ 的值，这样虽然 $\textit{matrix}[\textit{col}][n - \textit{row} - 1]$ 被覆盖了，我们还是可以通过 $\textit{temp}$ 获取它原来的值：

$$
\left\{
\begin{alignedat}{2}
&\textit{temp} &&= \textit{matrix}[\textit{col}][n - \textit{row} - 1]\\
&\textit{matrix}[\textit{col}][n - \textit{row} - 1] &&= \textit{matrix}[\textit{row}][\textit{col}]
\end{alignedat}
\right.
$$

那么 $\textit{matrix}[\textit{col}][n - \textit{row} - 1]$ 经过旋转操作之后会到哪个位置呢？我们还是使用方法一中的关键等式，不过这次，我们需要将

$$
\left\{
\begin{alignedat}{2}
& \textit{row} &&= \textit{col} \\
& \textit{col} &&= n - \textit{row} - 1
\end{alignedat}
\right.
$$

带入关键等式，就可以得到：

$$
\textit{matrix}[n - \textit{row} - 1][n - \textit{col} - 1] = \textit{matrix}[\textit{col}][n - \textit{row} - 1]
$$

同样地，直接赋值会覆盖掉 $\textit{matrix}[n - \textit{row} - 1][n - \textit{col} - 1]$ 原来的值，因此我们还是需要使用一个临时变量进行存储，不过这次，我们可以直接使用之前的临时变量 $\textit{temp}$：

$$
\left\{
\begin{alignedat}{2}
&\textit{temp} &&= \textit{matrix}[n - \textit{row} - 1][n - \textit{col} - 1]\\
&\textit{matrix}[n - \textit{row} - 1][n - \textit{col} - 1] &&= \textit{matrix}[\textit{col}][n - \textit{row} - 1]\\
&\textit{matrix}[\textit{col}][n - \textit{row} - 1] &&= \textit{matrix}[\textit{row}][\textit{col}]
\end{alignedat}
\right.
$$

我们再重复一次之前的操作，$\textit{matrix}[n - \textit{row} - 1][n - \textit{col} - 1]$ 经过旋转操作之后会到哪个位置呢？

$$
\left\{
\begin{alignedat}{2}
& \textit{row} &&= n - \textit{row} - 1\\
& \textit{col} &&= n - \textit{col} - 1
\end{alignedat}
\right.
$$

带入关键等式，就可以得到：

$$
\textit{matrix}[n - \textit{col} - 1][\textit{row}] = \textit{matrix}[n - \textit{row} - 1][n - \textit{col} - 1]
$$

写进去：

$$
\left\{
\begin{alignedat}{2}
&\textit{temp} &&= \textit{matrix}[n - \textit{col} - 1][\textit{row}]\\
&\textit{matrix}[n - \textit{col} - 1][\textit{row}] &&= \textit{matrix}[n - \textit{row} - 1][n - \textit{col} - 1]\\
&\textit{matrix}[n - \textit{row} - 1][n - \textit{col} - 1] &&= \textit{matrix}[\textit{col}][n - \textit{row} - 1]\\
&\textit{matrix}[\textit{col}][n - \textit{row} - 1] &&= \textit{matrix}[\textit{row}][\textit{col}]
\end{alignedat}
\right.
$$

不要灰心，再来一次！$\textit{matrix}[n - \textit{col} - 1][\textit{row}]$ 经过旋转操作之后回到哪个位置呢？

$$
\left\{
\begin{alignedat}{2}
& \textit{row} &&= n - \textit{col} - 1\\
& \textit{col} &&= \textit{row}
\end{alignedat}
\right.
$$

带入关键等式，就可以得到：

$$
\textit{matrix}[\textit{row}][\textit{col}] = \textit{matrix}[n - \textit{col} - 1][\textit{row}]
$$

我们回到了最初的起点 $\textit{matrix}[\textit{row}][\textit{col}]$，也就是说：

$$
\begin{cases}
\textit{matrix}[\textit{row}][\textit{col}]\\
\textit{matrix}[\textit{col}][n - \textit{row} - 1]\\
\textit{matrix}[n - \textit{row} - 1][n - \textit{col} - 1]\\
\textit{matrix}[n - \textit{col} - 1][\textit{row}]
\end{cases}
$$

这四项处于一个循环中，并且每一项旋转后的位置就是下一项所在的位置！因此我们可以使用一个临时变量 $\textit{temp}$ 完成这四项的原地交换：

$$
\left\{
\begin{alignedat}{2}
&\textit{temp} &&= \textit{matrix}[\textit{row}][\textit{col}]\\
&\textit{matrix}[\textit{row}][\textit{col}] &&= \textit{matrix}[n - \textit{col} - 1][\textit{row}]\\
&\textit{matrix}[n - \textit{col} - 1][\textit{row}] &&= \textit{matrix}[n - \textit{row} - 1][n - \textit{col} - 1]\\
&\textit{matrix}[n - \textit{row} - 1][n - \textit{col} - 1] &&= \textit{matrix}[\textit{col}][n - \textit{row} - 1]\\
&\textit{matrix}[\textit{col}][n - \textit{row} - 1] &&= \textit{temp}
\end{alignedat}
\right.
$$

当我们知道了如何原地旋转矩阵之后，还有一个重要的问题在于：我们应该枚举哪些位置 $(\textit{row}, \textit{col})$ 进行上述的原地交换操作呢？由于每一次原地交换四个位置，因此：

- 当 $n$ 为偶数时，我们需要枚举 $n^2 / 4 = (n/2) \times (n/2)$ 个位置，可以将该图形分为四块，以 $4 \times 4$ 的矩阵为例：

![fig1](https://assets.leetcode-cn.com/solution-static/48/1.png){:width="80%"}
  
保证了不重复、不遗漏；

- 当 $n$ 为奇数时，由于中心的位置经过旋转后位置不变，我们需要枚举 $(n^2-1) / 4 = ((n-1)/2) \times ((n+1)/2)$ 个位置，需要换一种划分的方式，以 $5 \times 5$ 的矩阵为例：

![fig2](https://assets.leetcode-cn.com/solution-static/48/2.png){:width="80%"}

同样保证了不重复、不遗漏，矩阵正中央的点无需旋转。

```C++ [sol2-C++]
class Solution {
public:
    void rotate(vector<vector<int>>& matrix) {
        int n = matrix.size();
        for (int i = 0; i < n / 2; ++i) {
            for (int j = 0; j < (n + 1) / 2; ++j) {
                int temp = matrix[i][j];
                matrix[i][j] = matrix[n - j - 1][i];
                matrix[n - j - 1][i] = matrix[n - i - 1][n - j - 1];
                matrix[n - i - 1][n - j - 1] = matrix[j][n - i - 1];
                matrix[j][n - i - 1] = temp;
            }
        }
    }
};
```

```C++ [sol2-C++17]
class Solution {
public:
    void rotate(vector<vector<int>>& matrix) {
        int n = matrix.size();
        for (int i = 0; i < n / 2; ++i) {
            for (int j = 0; j < (n + 1) / 2; ++j) {
                tie(matrix[i][j], matrix[n - j - 1][i], matrix[n - i - 1][n - j - 1], matrix[j][n - i - 1]) \
                    = make_tuple(matrix[n - j - 1][i], matrix[n - i - 1][n - j - 1], matrix[j][n - i - 1], matrix[i][j]);
            }
        }
    }
};
```

```Java [sol2-Java]
class Solution {
    public void rotate(int[][] matrix) {
        int n = matrix.length;
        for (int i = 0; i < n / 2; ++i) {
            for (int j = 0; j < (n + 1) / 2; ++j) {
                int temp = matrix[i][j];
                matrix[i][j] = matrix[n - j - 1][i];
                matrix[n - j - 1][i] = matrix[n - i - 1][n - j - 1];
                matrix[n - i - 1][n - j - 1] = matrix[j][n - i - 1];
                matrix[j][n - i - 1] = temp;
            }
        }
    }
}
```

```Python [sol2-Python3]
class Solution:
    def rotate(self, matrix: List[List[int]]) -> None:
        n = len(matrix)
        for i in range(n // 2):
            for j in range((n + 1) // 2):
                matrix[i][j], matrix[n - j - 1][i], matrix[n - i - 1][n - j - 1], matrix[j][n - i - 1] \
                    = matrix[n - j - 1][i], matrix[n - i - 1][n - j - 1], matrix[j][n - i - 1], matrix[i][j]
```

```JavaScript [sol2-JavaScript]
var rotate = function(matrix) {
    const n = matrix.length;
    for (let i = 0; i < Math.floor(n / 2); ++i) {
        for (let j = 0; j < Math.floor((n + 1) / 2); ++j) {
            const temp = matrix[i][j];
            matrix[i][j] = matrix[n - j - 1][i];
            matrix[n - j - 1][i] = matrix[n - i - 1][n - j - 1];
            matrix[n - i - 1][n - j - 1] = matrix[j][n - i - 1];
            matrix[j][n - i - 1] = temp;
        }
    }
};
```

```Go [sol2-Golang]
func rotate(matrix [][]int) {
    n := len(matrix)
    for i := 0; i < n/2; i++ {
        for j := 0; j < (n+1)/2; j++ {
            matrix[i][j], matrix[n-j-1][i], matrix[n-i-1][n-j-1], matrix[j][n-i-1] =
                matrix[n-j-1][i], matrix[n-i-1][n-j-1], matrix[j][n-i-1], matrix[i][j]
        }
    }
}
```

```C [sol2-C]
void rotate(int** matrix, int matrixSize, int* matrixColSize) {
    for (int i = 0; i < matrixSize / 2; ++i) {
        for (int j = 0; j < (matrixSize + 1) / 2; ++j) {
            int temp = matrix[i][j];
            matrix[i][j] = matrix[matrixSize - j - 1][i];
            matrix[matrixSize - j - 1][i] = matrix[matrixSize - i - 1][matrixSize - j - 1];
            matrix[matrixSize - i - 1][matrixSize - j - 1] = matrix[j][matrixSize - i - 1];
            matrix[j][matrixSize - i - 1] = temp;
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 是 $\textit{matrix}$ 的边长。我们需要枚举的子矩阵大小为 O($\lfloor n/2 \rfloor \times \lfloor (n+1)/2 \rfloor) = O(N^2)$。

- 空间复杂度：$O(1)$。为原地旋转。

#### 方法三：用翻转代替旋转

我们还可以另辟蹊径，用翻转操作代替旋转操作。我们还是以题目中的示例二

$$
\begin{bmatrix}
5 & 1 & 9 & 11 \\
2 & 4 & 8 & 10 \\
13 & 3 & 6 & 7 \\
15 & 14 & 12 & 16
\end{bmatrix}
$$

作为例子，先将其通过水平轴翻转得到：

$$
\begin{bmatrix}
5 & 1 & 9 & 11 \\
2 & 4 & 8 & 10 \\
13 & 3 & 6 & 7 \\
15 & 14 & 12 & 16
\end{bmatrix}
\xRightarrow[]{水平翻转}
\begin{bmatrix}
15 & 14 & 12 & 16 \\
13 & 3 & 6 & 7 \\
2 & 4 & 8 & 10 \\
5 & 1 & 9 & 11
\end{bmatrix}
$$

再根据主对角线翻转得到：

$$
\begin{bmatrix}
15 & 14 & 12 & 16 \\
13 & 3 & 6 & 7 \\
2 & 4 & 8 & 10 \\
5 & 1 & 9 & 11
\end{bmatrix}
\xRightarrow[]{主对角线翻转}
\begin{bmatrix}
15 & 13 & 2 & 5 \\
14 & 3 & 4 & 1 \\
12 & 6 & 8 & 9 \\
16 & 7 & 10 & 11
\end{bmatrix}
$$

就得到了答案。这是为什么呢？对于水平轴翻转而言，我们只需要枚举矩阵上半部分的元素，和下半部分的元素进行交换，即

$$
\textit{matrix}[\textit{row}][\textit{col}] \xRightarrow[]{水平轴翻转} \textit{matrix}[n - \textit{row} - 1][\textit{col}]
$$

对于主对角线翻转而言，我们只需要枚举对角线左侧的元素，和右侧的元素进行交换，即

$$
\textit{matrix}[\textit{row}][\textit{col}] \xRightarrow[]{主对角线翻转} \textit{matrix}[\textit{col}][\textit{row}]
$$

将它们联立即可得到：

$$
\begin{aligned}
\textit{matrix}[\textit{row}][\textit{col}] & \xRightarrow[]{水平轴翻转} \textit{matrix}[n - \textit{row} - 1][\textit{col}] \\
&\xRightarrow[]{主对角线翻转} \textit{matrix}[\textit{col}][n - \textit{row} - 1]
\end{aligned}
$$

和方法一、方法二中的关键等式：

$$
\textit{matrix}_\textit{new}[\textit{col}][n - \textit{row} - 1] = \textit{matrix}[\textit{row}][\textit{col}]
$$

是一致的。

```C++ [sol3-C++]
class Solution {
public:
    void rotate(vector<vector<int>>& matrix) {
        int n = matrix.size();
        // 水平翻转
        for (int i = 0; i < n / 2; ++i) {
            for (int j = 0; j < n; ++j) {
                swap(matrix[i][j], matrix[n - i - 1][j]);
            }
        }
        // 主对角线翻转
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < i; ++j) {
                swap(matrix[i][j], matrix[j][i]);
            }
        }
    }
};
```

```Java [sol3-Java]
class Solution {
    public void rotate(int[][] matrix) {
        int n = matrix.length;
        // 水平翻转
        for (int i = 0; i < n / 2; ++i) {
            for (int j = 0; j < n; ++j) {
                int temp = matrix[i][j];
                matrix[i][j] = matrix[n - i - 1][j];
                matrix[n - i - 1][j] = temp;
            }
        }
        // 主对角线翻转
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < i; ++j) {
                int temp = matrix[i][j];
                matrix[i][j] = matrix[j][i];
                matrix[j][i] = temp;
            }
        }
    }
}
```

```Python [sol3-Python3]
class Solution:
    def rotate(self, matrix: List[List[int]]) -> None:
        n = len(matrix)
        # 水平翻转
        for i in range(n // 2):
            for j in range(n):
                matrix[i][j], matrix[n - i - 1][j] = matrix[n - i - 1][j], matrix[i][j]
        # 主对角线翻转
        for i in range(n):
            for j in range(i):
                matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
```

```JavaScript [sol3-JavaScript]
var rotate = function(matrix) {
    const n = matrix.length;
    // 水平翻转
    for (let i = 0; i < Math.floor(n / 2); i++) {
        for (let j = 0; j < n; j++) {
            [matrix[i][j], matrix[n - i - 1][j]] = [matrix[n - i - 1][j], matrix[i][j]];
        }
    }
    // 主对角线翻转
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < i; j++) {
            [matrix[i][j], matrix[j][i]] = [matrix[j][i], matrix[i][j]];
        }
    }
};
```

```Go [sol3-Golang]
func rotate(matrix [][]int) {
    n := len(matrix)
    // 水平翻转
    for i := 0; i < n/2; i++ {
        matrix[i], matrix[n-1-i] = matrix[n-1-i], matrix[i]
    }
    // 主对角线翻转
    for i := 0; i < n; i++ {
        for j := 0; j < i; j++ {
            matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
        }
    }
}
```

```C [sol3-C]
void swap(int* a, int* b) {
    int t = *a;
    *a = *b, *b = t;
}

void rotate(int** matrix, int matrixSize, int* matrixColSize) {
    // 水平翻转
    for (int i = 0; i < matrixSize / 2; ++i) {
        for (int j = 0; j < matrixSize; ++j) {
            swap(&matrix[i][j], &matrix[matrixSize - i - 1][j]);
        }
    }
    // 主对角线翻转
    for (int i = 0; i < matrixSize; ++i) {
        for (int j = 0; j < i; ++j) {
            swap(&matrix[i][j], &matrix[j][i]);
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 是 $\textit{matrix}$ 的边长。对于每一次翻转操作，我们都需要枚举矩阵中一半的元素。

- 空间复杂度：$O(1)$。为原地翻转得到的原地旋转。