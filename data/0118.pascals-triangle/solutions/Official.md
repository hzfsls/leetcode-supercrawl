### 📺 视频题解  
![118.杨辉三角.mp4](015836d3-6ee5-495e-94cc-724ee29a8432)

### 📖 文字题解
#### 方法一：数学

**思路及解法**

杨辉三角，是二项式系数在三角形中的一种几何排列。它是中国古代数学的杰出研究成果之一，它把二项式系数图形化，把组合数内在的一些代数性质直观地从图形中体现出来，是一种离散型的数与形的结合。

杨辉三角具有以下性质：

1. 每行数字左右对称，由 $1$ 开始逐渐变大再变小，并最终回到 $1$。

2. 第 $n$ 行（从 $0$ 开始编号）的数字有 $n+1$ 项，前 $n$ 行共有 $\frac{n(n+1)}{2}$ 个数。

3. 第 $n$ 行的第 $m$ 个数（从 $0$ 开始编号）可表示为可以被表示为组合数 $\mathcal{C}(n,m)$，记作 $\mathcal{C}_n^m$ 或 $\binom{n}{m}$，即为从 $n$ 个不同元素中取 $m$ 个元素的组合数。我们可以用公式来表示它：$\mathcal{C}_n^m=\dfrac{n!}{m!\times (n-m)!}$

4. 每个数字等于上一行的左右两个数字之和，可用此性质写出整个杨辉三角。即第 $n$ 行的第 $i$ 个数等于第 $n-1$ 行的第 $i-1$ 个数和第 $i$ 个数之和。这也是组合数的性质之一，即 $\mathcal{C}_n^i=\mathcal{C}_{n-1}^i+\mathcal{C}_{n-1}^{i-1}$。

5. $(a+b)^n$ 的展开式（二项式展开）中的各项系数依次对应杨辉三角的第 $n$ 行中的每一项。

依据性质 $4$，我们可以一行一行地计算杨辉三角。每当我们计算出第 $i$ 行的值，我们就可以在线性时间复杂度内计算出第 $i+1$ 行的值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> generate(int numRows) {
        vector<vector<int>> ret(numRows);
        for (int i = 0; i < numRows; ++i) {
            ret[i].resize(i + 1);
            ret[i][0] = ret[i][i] = 1;
            for (int j = 1; j < i; ++j) {
                ret[i][j] = ret[i - 1][j] + ret[i - 1][j - 1];
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<List<Integer>> generate(int numRows) {
        List<List<Integer>> ret = new ArrayList<List<Integer>>();
        for (int i = 0; i < numRows; ++i) {
            List<Integer> row = new ArrayList<Integer>();
            for (int j = 0; j <= i; ++j) {
                if (j == 0 || j == i) {
                    row.add(1);
                } else {
                    row.add(ret.get(i - 1).get(j - 1) + ret.get(i - 1).get(j));
                }
            }
            ret.add(row);
        }
        return ret;
    }
}
```

```Golang [sol1-Golang]
func generate(numRows int) [][]int {
    ans := make([][]int, numRows)
    for i := range ans {
        ans[i] = make([]int, i+1)
        ans[i][0] = 1
        ans[i][i] = 1
        for j := 1; j < i; j++ {
            ans[i][j] = ans[i-1][j] + ans[i-1][j-1]
        }
    }
    return ans
}
```

```C [sol1-C]
int** generate(int numRows, int* returnSize, int** returnColumnSizes) {
    int** ret = malloc(sizeof(int*) * numRows);
    *returnSize = numRows;
    *returnColumnSizes = malloc(sizeof(int) * numRows);
    for (int i = 0; i < numRows; ++i) {
        ret[i] = malloc(sizeof(int) * (i + 1));
        (*returnColumnSizes)[i] = i + 1;
        ret[i][0] = ret[i][i] = 1;
        for (int j = 1; j < i; ++j) {
            ret[i][j] = ret[i - 1][j] + ret[i - 1][j - 1];
        }
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var generate = function(numRows) {
    const ret = [];

    for (let i = 0; i < numRows; i++) {
        const row = new Array(i + 1).fill(1);
        for (let j = 1; j < row.length - 1; j++) {
            row[j] = ret[i - 1][j - 1] + ret[i - 1][j];
        }
        ret.push(row);
    }
    return ret;
};
```

```Python [sol1-Python3]
class Solution:
    def generate(self, numRows: int) -> List[List[int]]:
        ret = list()
        for i in range(numRows):
            row = list()
            for j in range(0, i + 1):
                if j == 0 or j == i:
                    row.append(1)
                else:
                    row.append(ret[i - 1][j] + ret[i - 1][j - 1])
            ret.append(row)
        return ret
```

**复杂度分析**

- 时间复杂度：$O(\textit{numRows}^2)$。

- 空间复杂度：$O(1)$。不考虑返回值的空间占用。