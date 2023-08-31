## [1725.可以形成最大正方形的矩形数目 中文官方题解](https://leetcode.cn/problems/number-of-rectangles-that-can-form-the-largest-square/solutions/100000/ke-yi-xing-cheng-zui-da-zheng-fang-xing-n6pvm)
#### 方法一：一次遍历

**思路**

记 $l$ 和 $w$ 为某个矩形的长度和宽度，设 $k$ 为可以从这个矩形中切出的最大正方形的边长，则有 $k = \min(l, w)$。我们遍历输入数组，维护两个变量，$\textit{maxLen}$ 表示遍历到当前矩形时的所有可以切出的最大正方形的边长的最大值，$\textit{res}$ 表示可以切出边长为 $\textit{maxLen}$ 的正方形的个数。计算当前的 $k$，当 $k = \textit{maxLen}$ 时，对 $\textit{res}$ 进行加 $1$ 操作；当 $k > \textit{maxLen}$ 时，则更新 $\textit{maxLen}$ 为 $k$，并把 $\textit{res}$ 重置为 $1$。

**代码**

```Python [sol1-Python3]
class Solution:
    def countGoodRectangles(self, rectangles: List[List[int]]) -> int:
        res, maxLen = 0, 0
        for l, w in rectangles:
            k = min(l, w)
            if k == maxLen:
                res += 1
            elif k > maxLen:
                res = 1
                maxLen = k
        return res
```

```Java [sol1-Java]
class Solution {
    public int countGoodRectangles(int[][] rectangles) {
        int res = 0, maxLen = 0;
        for (int[] rectangle : rectangles) {
            int l = rectangle[0], w = rectangle[1];
            int k = Math.min(l, w);
            if (k == maxLen) {
                ++res;
            } else if (k > maxLen) {
                res = 1;
                maxLen = k;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountGoodRectangles(int[][] rectangles) {
        int res = 0, maxLen = 0;
        foreach (int[] rectangle in rectangles) {
            int l = rectangle[0], w = rectangle[1];
            int k = Math.Min(l, w);
            if (k == maxLen) {
                ++res;
            } else if (k > maxLen) {
                res = 1;
                maxLen = k;
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int countGoodRectangles(vector<vector<int>>& rectangles) {
        int res = 0, maxLen = 0;
        for (auto & rectangle : rectangles) {
            int l = rectangle[0], w = rectangle[1];
            int k = min(l, w);
            if (k == maxLen) {
                ++res;
            } else if (k > maxLen) {
                res = 1;
                maxLen = k;
            }
        }
        return res;
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int countGoodRectangles(int** rectangles, int rectanglesSize, int* rectanglesColSize){
    int res = 0, maxLen = 0;
    for (int i = 0; i < rectanglesSize; ++i) {
        int l = rectangles[i][0], w = rectangles[i][1];
        int k = MIN(l, w);
        if (k == maxLen) {
            ++res;
        } else if (k > maxLen) {
            res = 1;
            maxLen = k;
        }
    }
    return res;
}
```

```go [sol1-Golang]
func countGoodRectangles(rectangles [][]int) (ans int) {
    maxLen := 0
    for _, rect := range rectangles {
        k := min(rect[0], rect[1])
        if k == maxLen {
            ans++
        } else if k > maxLen {
            maxLen, ans = k, 1
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
```

```JavaScript [sol1-JavaScript]
var countGoodRectangles = function(rectangles) {
    let res = 0, maxLen = 0;
    for (const rectangle of rectangles) {
        const l = rectangle[0], w = rectangle[1];
        const k = Math.min(l, w);
        if (k === maxLen) {
            ++res;
        } else if (k > maxLen) {
            res = 1;
            maxLen = k;
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为输入数组 $\textit{rectangles}$ 的长度。我们仅需一次遍历即可得到答案。

- 空间复杂度：$O(1)$。我们仅需要常数空间来存储变量。