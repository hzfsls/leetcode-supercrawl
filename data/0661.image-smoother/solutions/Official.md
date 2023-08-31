## [661.图片平滑器 中文官方题解](https://leetcode.cn/problems/image-smoother/solutions/100000/tu-pian-ping-hua-qi-by-leetcode-solution-9oi5)

#### 方法一：遍历

**思路和算法**

按照题目的要求，我们直接依次计算每一个位置平滑处理后的结果即可。

具体地，对于位置 $(i,j)$，我们枚举其周围的九个单元是否存在，对于存在的单元格，我们统计其数量 $\textit{num}$ 与总和 $\textit{sum}$，那么该位置平滑处理后的结果即为 $\Big\lfloor\dfrac{\textit{sum}}{\textit{num}}\Big\rfloor$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> imageSmoother(vector<vector<int>>& img) {
        int m = img.size(), n = img[0].size();
        vector<vector<int>> ret(m, vector<int>(n));
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int num = 0, sum = 0;
                for (int x = i - 1; x <= i + 1; x++) {
                    for (int y = j - 1; y <= j + 1; y++) {
                        if (x >= 0 && x < m && y >= 0 && y < n) {
                            num++;
                            sum += img[x][y];
                        }
                    }
                }
                ret[i][j] = sum / num;
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[][] imageSmoother(int[][] img) {
        int m = img.length, n = img[0].length;
        int[][] ret = new int[m][n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int num = 0, sum = 0;
                for (int x = i - 1; x <= i + 1; x++) {
                    for (int y = j - 1; y <= j + 1; y++) {
                        if (x >= 0 && x < m && y >= 0 && y < n) {
                            num++;
                            sum += img[x][y];
                        }
                    }
                }
                ret[i][j] = sum / num;
            }
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[][] ImageSmoother(int[][] img) {
        int m = img.Length, n = img[0].Length;
        int[][] ret = new int[m][];
        for (int i = 0; i < m; i++) {
            ret[i] = new int[n];
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int num = 0, sum = 0;
                for (int x = i - 1; x <= i + 1; x++) {
                    for (int y = j - 1; y <= j + 1; y++) {
                        if (x >= 0 && x < m && y >= 0 && y < n) {
                            num++;
                            sum += img[x][y];
                        }
                    }
                }
                ret[i][j] = sum / num;
            }
        }
        return ret;
    }
}
```

```C [sol1-C]
int** imageSmoother(int** img, int imgSize, int* imgColSize, int* returnSize, int** returnColumnSizes){
    int m = imgSize, n = imgColSize[0];
    int ** ret = (int **)malloc(sizeof(int *) * m);
    *returnColumnSizes = (int *)malloc(sizeof(int) * m);
    for (int i = 0; i < m; i ++) {
        ret[i] = (int *)malloc(sizeof(int) * n);
        memset(ret[i], 0, sizeof(int) * n);
        (*returnColumnSizes)[i] = n;
    }
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            int num = 0, sum = 0;
            for (int x = i - 1; x <= i + 1; x++) {
                for (int y = j - 1; y <= j + 1; y++) {
                    if (x >= 0 && x < m && y >= 0 && y < n) {
                        num++;
                        sum += img[x][y];
                    }
                }
            }
            ret[i][j] = sum / num;
        }
    }
    *returnSize = m;
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var imageSmoother = function(img) {
    const m = img.length, n = img[0].length;
    const ret = new Array(m).fill(0).map(() => new Array(n).fill(0));
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            let num = 0, sum = 0;
            for (let x = i - 1; x <= i + 1; x++) {
                for (let y = j - 1; y <= j + 1; y++) {
                    if (x >= 0 && x < m && y >= 0 && y < n) {
                        num++;
                        sum += img[x][y];
                    }
                }
            }
            ret[i][j] = Math.floor(sum / num);
        }
    }
    return ret;
};
```

```Python [sol1-Python3]
class Solution:
    def imageSmoother(self, img: List[List[int]]) -> List[List[int]]:
        m, n = len(img), len(img[0])
        ans = [[0] * n for _ in range(m)]
        for i in range(m):
            for j in range(n):
                tot, num = 0, 0
                for x in range(max(i - 1, 0), min(i + 2, m)):
                    for y in range(max(j - 1, 0), min(j + 2, n)):
                        tot += img[x][y]
                        num += 1
                ans[i][j] = tot // num
        return ans
```

```go [sol1-Golang]
func imageSmoother(img [][]int) [][]int {
    m, n := len(img), len(img[0])
    ans := make([][]int, m)
    for i := range ans {
        ans[i] = make([]int, n)
        for j := range ans[i] {
            sum, num := 0, 0
            for _, row := range img[max(i-1, 0):min(i+2, m)] {
                for _, v := range row[max(j-1, 0):min(j+2, n)] {
                    sum += v
                    num++
                }
            }
            ans[i][j] = sum / num
        }
    }
    return ans
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(mnC^2)$，其中 $m$ 为给定矩阵的行数，$n$ 为给定矩阵的列数，$C=3$ 为过滤器的宽高。我们需要遍历整个矩阵以计算每个位置的值，计算单个位置的值的时间复杂度为 $O(C^2)$。

- 空间复杂度：$O(1)$。注意返回值不计入空间复杂度。