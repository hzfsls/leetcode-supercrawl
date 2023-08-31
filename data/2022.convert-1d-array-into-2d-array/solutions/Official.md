## [2022.将一维数组转变成二维数组 中文官方题解](https://leetcode.cn/problems/convert-1d-array-into-2d-array/solutions/100000/jiang-yi-wei-shu-zu-zhuan-bian-cheng-er-zt47o)

#### 方法一：模拟

设 $\textit{original}$ 的长度为 $k$，根据题意，如果 $k\ne mn$ 则无法构成二维数组，此时返回空数组。否则我们可以遍历 $\textit{original}$，每 $n$ 个元素创建一个一维数组，放入二维数组中。

```Python [sol1-Python3]
class Solution:
    def construct2DArray(self, original: List[int], m: int, n: int) -> List[List[int]]:
        return [original[i: i + n] for i in range(0, len(original), n)] if len(original) == m * n else []
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> construct2DArray(vector<int> &original, int m, int n) {
        vector<vector<int>> ans;
        if (original.size() != m * n) {
            return ans;
        }
        for (auto it = original.begin(); it != original.end(); it += n) {
            ans.emplace_back(it, it + n);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[][] construct2DArray(int[] original, int m, int n) {
        if (original.length != m * n) {
            return new int[0][];
        }
        int[][] ans = new int[m][n];
        for (int i = 0; i < original.length; i += n) {
            System.arraycopy(original, i, ans[i / n], 0, n);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[][] Construct2DArray(int[] original, int m, int n) {
        if (original.Length != m * n) {
            return new int[0][];
        }
        int[][] ans = new int[m][];
        for (int i = 0; i < m; ++i) {
            ans[i] = new int[n];
        }
        for (int i = 0; i < original.Length; i += n) {
            Array.Copy(original, i, ans[i / n], 0, n);
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func construct2DArray(original []int, m, n int) [][]int {
    k := len(original)
    if k != m*n {
        return nil
    }
    ans := make([][]int, 0, m)
    for i := 0; i < k; i += n {
        ans = append(ans, original[i:i+n])
    }
    return ans
}
```

```C [sol1-C]
int** construct2DArray(int* original, int originalSize, int m, int n, int* returnSize, int** returnColumnSizes){    
    if (originalSize != m * n) {
        *returnSize = 0;
        return NULL;
    }
    int ** ans = (int **)malloc(sizeof(int *) * m);
    *returnColumnSizes = (int *)malloc(sizeof(int) * m);
    for (int i = 0; i < m; ++i) {
        ans[i] = (int *)malloc(sizeof(int) * n);
        (*returnColumnSizes)[i] = n;
    }
    for (int i = 0; i < originalSize; i += n) {
        memcpy(ans[i / n], original + i, sizeof(int) * n);
    }
    *returnSize = m;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var construct2DArray = function(original, m, n) {
    if (original.length !== m * n) {
        return [];
    }
    const ans = new Array(m).fill(0).map(() => new Array(n).fill(0));
    for (let i = 0; i < original.length; i += n) {
        ans[Math.floor(i / n)].splice(0, n, ...original.slice(i, i + n)) 
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(mn)$ 或 $O(m)$（取决于语言实现）。

- 空间复杂度：$O(1)$。不考虑返回值的空间占用。