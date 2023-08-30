#### 方法一: 使用柱状图的优化暴力方法

**思路与算法**

最原始地，我们可以列举每个可能的矩形。我们枚举矩形所有可能的左上角坐标和右下角坐标，并检查该矩形是否符合要求。然而该方法的时间复杂度过高，不能通过所有的测试用例，因此我们必须寻找其他方法。

我们首先计算出矩阵的每个元素的左边连续 $1$ 的数量，使用二维数组 $\textit{left}$ 记录，其中 $\textit{left}[i][j]$ 为矩阵第 $i$ 行第 $j$ 列元素的左边连续 $1$ 的数量。

<![ppt1](https://assets.leetcode-cn.com/solution-static/85/1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/85/2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/85/3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/85/4.png),![ppt5](https://assets.leetcode-cn.com/solution-static/85/5.png),![ppt6](https://assets.leetcode-cn.com/solution-static/85/6.png),![ppt7](https://assets.leetcode-cn.com/solution-static/85/7.png),![ppt8](https://assets.leetcode-cn.com/solution-static/85/8.png),![ppt9](https://assets.leetcode-cn.com/solution-static/85/9.png),![ppt10](https://assets.leetcode-cn.com/solution-static/85/10.png)>

随后，对于矩阵中任意一个点，我们枚举以该点为右下角的全 $1$ 矩形。

具体而言，当考察以 $\textit{matrix}[i][j]$ 为右下角的矩形时，我们枚举满足 $0 \le k \le i$ 的所有可能的 $k$，此时矩阵的最大宽度就为 

$$
\textit{left}[i][j], \textit{left}[i-1][j], \ldots, \textit{left}[k][j]
$$

的最小值。

下图有助于理解。给定每个点的最大宽度，可计算出底端黄色方块的最大矩形面积。

<![fig1](https://assets.leetcode-cn.com/solution-static/85/2_1.png),![fig2](https://assets.leetcode-cn.com/solution-static/85/2_2.png),![fig3](https://assets.leetcode-cn.com/solution-static/85/2_3.png),![fig4](https://assets.leetcode-cn.com/solution-static/85/2_4.png),![fig5](https://assets.leetcode-cn.com/solution-static/85/2_5.png),![fig6](https://assets.leetcode-cn.com/solution-static/85/2_6.png),![fig7](https://assets.leetcode-cn.com/solution-static/85/2_7.png)>

对每个点重复这一过程，就可以得到全局的最大矩形。

我们预计算最大宽度的方法事实上将输入转化成了一系列的柱状图，我们针对每个柱状图计算最大面积。

![fig2](https://assets.leetcode-cn.com/solution-static/85/3_1.png)
{:align="center"}

于是，上述方法本质上是「[84. 柱状图中最大的矩形](https://leetcode-cn.com/problems/largest-rectangle-in-histogram/)」题中优化暴力算法的复用。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximalRectangle(vector<vector<char>>& matrix) {
        int m = matrix.size();
        if (m == 0) {
            return 0;
        }
        int n = matrix[0].size();
        vector<vector<int>> left(m, vector<int>(n, 0));

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == '1') {
                    left[i][j] = (j == 0 ? 0: left[i][j - 1]) + 1;
                }
            }
        }

        int ret = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == '0') {
                    continue;
                }
                int width = left[i][j];
                int area = width;
                for (int k = i - 1; k >= 0; k--) {
                    width = min(width, left[k][j]);
                    area = max(area, (i - k + 1) * width);
                }
                ret = max(ret, area);
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maximalRectangle(char[][] matrix) {
        int m = matrix.length;
        if (m == 0) {
            return 0;
        }
        int n = matrix[0].length;
        int[][] left = new int[m][n];

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == '1') {
                    left[i][j] = (j == 0 ? 0 : left[i][j - 1]) + 1;
                }
            }
        }

        int ret = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == '0') {
                    continue;
                }
                int width = left[i][j];
                int area = width;
                for (int k = i - 1; k >= 0; k--) {
                    width = Math.min(width, left[k][j]);
                    area = Math.max(area, (i - k + 1) * width);
                }
                ret = Math.max(ret, area);
            }
        }
        return ret;
    }
}
```

```JavaScript [sol1-JavaScript]
var maximalRectangle = function(matrix) {
    const m = matrix.length;
    if (m === 0) {
        return 0;
    }
    const n = matrix[0].length;
    const left = new Array(m).fill(0).map(() => new Array(n).fill(0));

    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (matrix[i][j] === '1') {
                left[i][j] = (j === 0 ? 0 : left[i][j - 1]) + 1;
            }
        }
    }

    let ret = 0;
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (matrix[i][j] === '0') {
                continue;
            }
            let width = left[i][j];
            let area = width;
            for (let k = i - 1; k >= 0; k--) {
                width = Math.min(width, left[k][j]);
                area = Math.max(area, (i - k + 1) * width);
            }
            ret = Math.max(ret, area);
        }
    }
    return ret;
};
```

```go [sol1-Golang]
func maximalRectangle(matrix [][]byte) (ans int) {
    if len(matrix) == 0 {
        return
    }
    m, n := len(matrix), len(matrix[0])
    left := make([][]int, m)
    for i, row := range matrix {
        left[i] = make([]int, n)
        for j, v := range row {
            if v == '0' {
                continue
            }
            if j == 0 {
                left[i][j] = 1
            } else {
                left[i][j] = left[i][j-1] + 1
            }
        }
    }
    for i, row := range matrix {
        for j, v := range row {
            if v == '0' {
                continue
            }
            width := left[i][j]
            area := width
            for k := i - 1; k >= 0; k-- {
                width = min(width, left[k][j])
                area = max(area, (i-k+1)*width)
            }
            ans = max(ans, area)
        }
    }
    return
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol1-C]
int maximalRectangle(char** matrix, int matrixSize, int* matrixColSize) {
    int m = matrixSize;
    if (m == 0) {
        return 0;
    }
    int n = matrixColSize[0];
    int left[m][n];
    memset(left, 0, sizeof(left));
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (matrix[i][j] == '1') {
                left[i][j] = (j == 0 ? 0 : left[i][j - 1]) + 1;
            }
        }
    }

    int ret = 0;
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (matrix[i][j] == '0') {
                continue;
            }
            int width = left[i][j];
            int area = width;
            for (int k = i - 1; k >= 0; k--) {
                width = fmin(width, left[k][j]);
                area = fmax(area, (i - k + 1) * width);
            }
            ret = fmax(ret, area);
        }
    }
    return ret;
}
```

**复杂度分析**

* 时间复杂度：$O(m^2n)$，其中 $m$ 和 $n$ 分别是矩阵的行数和列数。计算 $\textit{left}$ 矩阵需要 $O(mn)$ 的时间。随后对于矩阵的每个点，需要 $O(m)$ 的时间枚举高度。故总的时间复杂度为 $O(mn) + O(mn) \cdot O(m) = O(m^2n)$。

* 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是矩阵的行数和列数。我们分配了一个与给定矩阵等大的数组，用于存储每个元素的左边连续 $1$ 的数量。

#### 方法二：单调栈 

**思路与算法**

在方法一中，我们讨论了将输入拆分成一系列的柱状图。为了计算矩形的最大面积，我们只需要计算每个柱状图中的最大面积，并找到全局最大值。

我们可以使用「[84. 柱状图中最大的矩形的官方题解](https://leetcode-cn.com/problems/largest-rectangle-in-histogram/solution/zhu-zhuang-tu-zhong-zui-da-de-ju-xing-by-leetcode-/)」中的单调栈的做法，将其应用在我们生成的柱状图中。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int maximalRectangle(vector<vector<char>>& matrix) {
        int m = matrix.size();
        if (m == 0) {
            return 0;
        }
        int n = matrix[0].size();
        vector<vector<int>> left(m, vector<int>(n, 0));

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == '1') {
                    left[i][j] = (j == 0 ? 0: left[i][j - 1]) + 1;
                }
            }
        }

        int ret = 0;
        for (int j = 0; j < n; j++) { // 对于每一列，使用基于柱状图的方法
            vector<int> up(m, 0), down(m, 0);

            stack<int> stk;
            for (int i = 0; i < m; i++) {
                while (!stk.empty() && left[stk.top()][j] >= left[i][j]) {
                    stk.pop();
                }
                up[i] = stk.empty() ? -1 : stk.top();
                stk.push(i);
            }
            stk = stack<int>();
            for (int i = m - 1; i >= 0; i--) {
                while (!stk.empty() && left[stk.top()][j] >= left[i][j]) {
                    stk.pop();
                }
                down[i] = stk.empty() ? m : stk.top();
                stk.push(i);
            }

            for (int i = 0; i < m; i++) {
                int height = down[i] - up[i] - 1;
                int area = height * left[i][j];
                ret = max(ret, area);
            }
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maximalRectangle(char[][] matrix) {
        int m = matrix.length;
        if (m == 0) {
            return 0;
        }
        int n = matrix[0].length;
        int[][] left = new int[m][n];

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == '1') {
                    left[i][j] = (j == 0 ? 0 : left[i][j - 1]) + 1;
                }
            }
        }

        int ret = 0;
        for (int j = 0; j < n; j++) { // 对于每一列，使用基于柱状图的方法
            int[] up = new int[m];
            int[] down = new int[m];

            Deque<Integer> stack = new LinkedList<Integer>();
            for (int i = 0; i < m; i++) {
                while (!stack.isEmpty() && left[stack.peek()][j] >= left[i][j]) {
                    stack.pop();
                }
                up[i] = stack.isEmpty() ? -1 : stack.peek();
                stack.push(i);
            }
            stack.clear();
            for (int i = m - 1; i >= 0; i--) {
                while (!stack.isEmpty() && left[stack.peek()][j] >= left[i][j]) {
                    stack.pop();
                }
                down[i] = stack.isEmpty() ? m : stack.peek();
                stack.push(i);
            }

            for (int i = 0; i < m; i++) {
                int height = down[i] - up[i] - 1;
                int area = height * left[i][j];
                ret = Math.max(ret, area);
            }
        }
        return ret;
    }
}
```

```JavaScript [sol2-JavaScript]
var maximalRectangle = function(matrix) {
    const m = matrix.length;
    if (m === 0) {
        return 0;
    }
    const n = matrix[0].length;
    const left = new Array(m).fill(0).map(() => new Array(n).fill(0));

    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (matrix[i][j] === '1') {
                left[i][j] = (j === 0 ? 0 : left[i][j - 1]) + 1;
            }
        }
    }

    let ret = 0;
    for (let j = 0; j < n; j++) { // 对于每一列，使用基于柱状图的方法
        const up = new Array(m).fill(0);
        const down = new Array(m).fill(0);

        let stack = new Array();
        for (let i = 0; i < m; i++) {
            while (stack.length && left[stack[stack.length - 1]][j] >= left[i][j]) {
                stack.pop();
            }
            up[i] = stack.length === 0 ? -1 : stack[stack.length - 1];
            stack.push(i);
        }
        stack = [];
        for (let i = m - 1; i >= 0; i--) {
            while (stack.length && left[stack[stack.length - 1]][j] >= left[i][j]) {
                stack.pop();
            }
            down[i] = stack.length === 0 ? m : stack[stack.length - 1];
            stack.push(i);
        }

        for (let i = 0; i < m; i++) {
            const height = down[i] - up[i] - 1;
            const area = height * left[i][j];
            ret = Math.max(ret, area);
        }
    }
    return ret;
};
```

```go [sol2-Golang]
func maximalRectangle(matrix [][]byte) (ans int) {
    if len(matrix) == 0 {
        return
    }
    m, n := len(matrix), len(matrix[0])
    left := make([][]int, m)
    for i, row := range matrix {
        left[i] = make([]int, n)
        for j, v := range row {
            if v == '0' {
                continue
            }
            if j == 0 {
                left[i][j] = 1
            } else {
                left[i][j] = left[i][j-1] + 1
            }
        }
    }
    for j := 0; j < n; j++ { // 对于每一列，使用基于柱状图的方法
        up := make([]int, m)
        down := make([]int, m)
        stk := []int{}
        for i, l := range left {
            for len(stk) > 0 && left[stk[len(stk)-1]][j] >= l[j] {
                stk = stk[:len(stk)-1]
            }
            up[i] = -1
            if len(stk) > 0 {
                up[i] = stk[len(stk)-1]
            }
            stk = append(stk, i)
        }
        stk = nil
        for i := m - 1; i >= 0; i-- {
            for len(stk) > 0 && left[stk[len(stk)-1]][j] >= left[i][j] {
                stk = stk[:len(stk)-1]
            }
            down[i] = m
            if len(stk) > 0 {
                down[i] = stk[len(stk)-1]
            }
            stk = append(stk, i)
        }
        for i, l := range left {
            height := down[i] - up[i] - 1
            area := height * l[j]
            ans = max(ans, area)
        }
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol2-C]
int maximalRectangle(char** matrix, int matrixSize, int* matrixColSize) {
    int m = matrixSize;
    if (m == 0) {
        return 0;
    }
    int n = matrixColSize[0];
    int left[m][n];
    memset(left, 0, sizeof(left));
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (matrix[i][j] == '1') {
                left[i][j] = (j == 0 ? 0 : left[i][j - 1]) + 1;
            }
        }
    }

    int ret = 0;
    for (int j = 0; j < n; j++) {  // 对于每一列，使用基于柱状图的方法
        int up[m], down[m];
        memset(up, 0, sizeof(up));
        memset(down, 0, sizeof(down));
        int stk[m], top = 0;
        for (int i = 0; i < m; i++) {
            while (top > 0 && left[stk[top - 1]][j] >= left[i][j]) {
                top--;
            }
            up[i] = top == 0 ? -1 : stk[top - 1];
            stk[top++] = i;
        }
        top = 0;
        for (int i = m - 1; i >= 0; i--) {
            while (top > 0 && left[stk[top - 1]][j] >= left[i][j]) {
                top--;
            }
            down[i] = top == 0 ? m : stk[top - 1];
            stk[top++] = i;
        }

        for (int i = 0; i < m; i++) {
            int height = down[i] - up[i] - 1;
            int area = height * left[i][j];
            ret = fmax(ret, area);
        }
    }
    return ret;
}
```

读者可以自行比对上面的代码与此前第 84 题的代码的相似之处。

**复杂度分析**

* 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是矩阵的行数和列数。计算 $\textit{left}$ 矩阵需要 $O(mn)$ 的时间；对每一列应用柱状图算法需要 $O(m)$ 的时间，一共需要 $O(mn)$ 的时间。

* 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是矩阵的行数和列数。我们分配了一个与给定矩阵等大的数组，用于存储每个元素的左边连续 $1$ 的数量。