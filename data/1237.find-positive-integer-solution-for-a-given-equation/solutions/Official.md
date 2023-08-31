## [1237.找出给定方程的正整数解 中文官方题解](https://leetcode.cn/problems/find-positive-integer-solution-for-a-given-equation/solutions/100000/zhao-chu-gei-ding-fang-cheng-de-zheng-zh-kie6)
#### 前言

本题是「[240. 搜索二维矩阵 II](https://leetcode.cn/problems/search-a-2d-matrix-ii/)」的变形题。

#### 方法一：枚举

根据题目给出的 $x$ 和 $y$ 的取值范围，枚举所有的 $x, y$ 数对，保存满足 $f(x,y)=z$ 的数对，最后返回结果。

```Python [sol1-Python3]
# 超时
class Solution:
    def findSolution(self, customfunction: 'CustomFunction', z: int) -> List[List[int]]:
        ans = []
        for x in range(1, 1001):
            for y in range(1, 1001):
                if customfunction.f(x, y) == z:
                    ans.append([x, y])
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> findSolution(CustomFunction& customfunction, int z) {
        vector<vector<int>> res;
        for (int x = 1; x <= 1000; x++) {
            for (int y = 1; y <= 1000; y++) {
                if (customfunction.f(x, y) == z) {
                    res.push_back({x, y});
                }
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<List<Integer>> findSolution(CustomFunction customfunction, int z) {
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        for (int x = 1; x <= 1000; x++) {
            for (int y = 1; y <= 1000; y++) {
                if (customfunction.f(x, y) == z) {
                    List<Integer> pair = new ArrayList<Integer>();
                    pair.add(x);
                    pair.add(y);
                    res.add(pair);
                }
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<IList<int>> FindSolution(CustomFunction customfunction, int z) {
        IList<IList<int>> res = new List<IList<int>>();
        for (int x = 1; x <= 1000; x++) {
            for (int y = 1; y <= 1000; y++) {
                if (customfunction.f(x, y) == z) {
                    res.Add(new List<int> {x, y});
                }
            }
        }
        return res;
    }
}
```

```C [sol1-C]
int** findSolution(int (*customFunction)(int, int), int z, int* returnSize, int** returnColumnSizes) {
    int **res = (int **)malloc(sizeof(int *) * 1000 * 1000);
    int pos = 0;
    for (int x = 1; x <= 1000; x++) {
        for (int y = 1; y <= 1000; y++) {
            if (customFunction(x, y) == z) {
                res[pos] = (int *)malloc(sizeof(int) * 2);
                res[pos][0] = x, res[pos][1] = y;
                pos++;
            }
        }
    }
    *returnSize = pos;
    *returnColumnSizes = (int *)malloc(sizeof(int) * pos);
    for (int i = 0; i < pos; i++) {
        (*returnColumnSizes)[i] = 2;
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var findSolution = function(customfunction, z) {
    const res = [];
    for (let x = 1; x <= 1000; x++) {
        for (let y = 1; y <= 1000; y++) {
            if (customfunction.f(x, y) === z) {
                res.push([x, y]);
            }
        }
    }
    return res;
};
```

```go [sol1-Golang]
func findSolution(customFunction func(int, int) int, z int) (ans [][]int) {
    for x := 1; x <= 1000; x++ {
        for y := 1; y <= 1000; y++ {
            if customFunction(x, y) == z {
                ans = append(ans, []int{x, y})
            }
        }
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(mn)$，其中 $m$ 是 $x$ 的取值数目，$n$ 是 $y$ 的取值数目。

+ 空间复杂度：$O(1)$。返回值不计入空间复杂度。

#### 方法二：二分查找

当我们固定 $x = x_0$ 时，函数 $g(y) = f(x_0, y)$ 是单调递增函数，可以通过二分查找来判断是否存在 $y=y_0$，使 $g(y_0)=f(x_0,y_0)=z$ 成立。

```Python [sol2-Python3]
class Solution:
    def findSolution(self, customfunction: 'CustomFunction', z: int) -> List[List[int]]:
        ans = []
        for x in range(1, 1001):
            y = 1 + bisect_left(range(1, 1000), z, key=lambda y: customfunction.f(x, y))
            if customfunction.f(x, y) == z:
                ans.append([x, y])
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    vector<vector<int>> findSolution(CustomFunction& customfunction, int z) {
        vector<vector<int>> res;
        for (int x = 1; x <= 1000; x++) {
            int yleft = 1, yright = 1000;
            while (yleft <= yright) {
                int ymiddle = (yleft + yright) / 2;
                if (customfunction.f(x, ymiddle) == z) {
                    res.push_back({x, ymiddle});
                    break;
                }
                if (customfunction.f(x, ymiddle) > z) {
                    yright = ymiddle - 1;
                } else {
                    yleft = ymiddle + 1;
                }
            }
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<List<Integer>> findSolution(CustomFunction customfunction, int z) {
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        for (int x = 1; x <= 1000; x++) {
            int yleft = 1, yright = 1000;
            while (yleft <= yright) {
                int ymiddle = (yleft + yright) / 2;
                if (customfunction.f(x, ymiddle) == z) {
                    List<Integer> pair = new ArrayList<Integer>();
                    pair.add(x);
                    pair.add(ymiddle);
                    res.add(pair);
                    break;
                }
                if (customfunction.f(x, ymiddle) > z) {
                    yright = ymiddle - 1;
                } else {
                    yleft = ymiddle + 1;
                }
            }
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<IList<int>> FindSolution(CustomFunction customfunction, int z) {
        IList<IList<int>> res = new List<IList<int>>();
        for (int x = 1; x <= 1000; x++) {
            int yleft = 1, yright = 1000;
            while (yleft <= yright) {
                int ymiddle = (yleft + yright) / 2;
                if (customfunction.f(x, ymiddle) == z) {
                    res.Add(new List<int> {x, ymiddle});
                    break;
                }
                if (customfunction.f(x, ymiddle) > z) {
                    yright = ymiddle - 1;
                } else {
                    yleft = ymiddle + 1;
                }
            }
        }
        return res;
    }
}
```

```C [sol2-C]
int** findSolution(int (*customFunction)(int, int), int z, int* returnSize, int** returnColumnSizes) {
    int **res = (int **)malloc(sizeof(int *) * 1000 * 1000);
    int pos = 0;
    for (int x = 1; x <= 1000; x++) {
        int yleft = 1, yright = 1000;
        while (yleft <= yright) {
            int ymiddle = (yleft + yright) / 2;
            if (customFunction(x, ymiddle) == z) {
                res[pos] = (int *)malloc(sizeof(int) * 2);
                res[pos][0] = x, res[pos][1] = ymiddle;
                pos++;
                break;
            }
            if (customFunction(x, ymiddle) > z) {
                yright = ymiddle - 1;
            } else {
                yleft = ymiddle + 1;
            }
        }
    }
    *returnSize = pos;
    *returnColumnSizes = (int *)malloc(sizeof(int) * pos);
    for (int i = 0; i < pos; i++) {
        (*returnColumnSizes)[i] = 2;
    }
    return res;
}
```

```JavaScript [sol2-JavaScript]
var findSolution = function(customfunction, z) {
    const res = [];
    for (let x = 1; x <= 1000; x++) {
        let yleft = 1, yright = 1000;
        while (yleft <= yright) {
            const ymiddle = Math.floor((yleft + yright) / 2);
            if (customfunction.f(x, ymiddle) === z) {
                res.push([x, ymiddle]);
                break;
            }
            if (customfunction.f(x, ymiddle) > z) {
                yright = ymiddle - 1;
            } else {
                yleft = ymiddle + 1;
            }
        }
    }
    return res;
};
```

```go [sol2-Golang]
func findSolution(customFunction func(int, int) int, z int) (ans [][]int) {
    for x := 1; x <= 1000; x++ {
        y := 1 + sort.Search(999, func(y int) bool { return customFunction(x, y+1) >= z })
        if customFunction(x, y) == z {
            ans = append(ans, []int{x, y})
        }
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(m \log n)$，其中 $m$ 是 $x$ 的取值数目，$n$ 是 $y$ 的取值数目。

+ 空间复杂度：$O(1)$。返回值不计入空间复杂度。

#### 方法三：双指针

假设 $x_1 < x_2$，且 $f(x_1, y_1) = f(x_2, y_2) = z$，显然有 $y_1 > y_2$。因此我们从小到大进行枚举 $x$，并且从大到小枚举 $y$，当固定 $x$ 时，不需要重头开始枚举所有的 $y$，只需要从上次结束的值开始枚举即可。

```Python [sol3-Python3]
class Solution:
    def findSolution(self, customfunction: 'CustomFunction', z: int) -> List[List[int]]:
        ans = []
        y = 1000
        for x in range(1, 1001):
            while y and customfunction.f(x, y) > z:
                y -= 1
            if y == 0:
                break
            if customfunction.f(x, y) == z:
                ans.append([x, y])
        return ans
```

```C++ [sol3-C++]
class Solution {
public:
    vector<vector<int>> findSolution(CustomFunction& customfunction, int z) {
        vector<vector<int>> res;
        for (int x = 1, y = 1000; x <= 1000 && y >= 1; x++) {
            while (y >= 1 && customfunction.f(x, y) > z) {
                y--;
            }
            if (y >= 1 && customfunction.f(x, y) == z) {
                res.push_back({x, y});
            }
        }
        return res;
    }
};
```

```Java [sol3-Java]
class Solution {
    public List<List<Integer>> findSolution(CustomFunction customfunction, int z) {
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        for (int x = 1, y = 1000; x <= 1000 && y >= 1; x++) {
            while (y >= 1 && customfunction.f(x, y) > z) {
                y--;
            }
            if (y >= 1 && customfunction.f(x, y) == z) {
                List<Integer> pair = new ArrayList<Integer>();
                pair.add(x);
                pair.add(y);
                res.add(pair);
            }
        }
        return res;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public IList<IList<int>> FindSolution(CustomFunction customfunction, int z) {
        IList<IList<int>> res = new List<IList<int>>();
        for (int x = 1, y = 1000; x <= 1000 && y >= 1; x++) {
            while (y >= 1 && customfunction.f(x, y) > z) {
                y--;
            }
            if (y >= 1 && customfunction.f(x, y) == z) {
                res.Add(new List<int> {x, y});
            }
        }
        return res;
    }
}
```

```C [sol3-C]
int** findSolution(int (*customFunction)(int, int), int z, int* returnSize, int** returnColumnSizes) {
    int **res = (int **)malloc(sizeof(int *) * 1000 * 1000);
    int pos = 0;
    for (int x = 1, y = 1000; x <= 1000 && y >= 1; x++) {
        while (y >= 1 && customFunction(x, y) > z) {
            y--;
        }
        if (y >= 1 && customFunction(x, y) == z) {
            res[pos] = (int *)malloc(sizeof(int) * 2);
            res[pos][0] = x, res[pos][1] = y;
            pos++;
        }
    }
    *returnSize = pos;
    *returnColumnSizes = (int *)malloc(sizeof(int) * pos);
    for (int i = 0; i < pos; i++) {
        (*returnColumnSizes)[i] = 2;
    }
    return res;
}
```

```JavaScript [sol3-JavaScript]
var findSolution = function(customfunction, z) {
    const res = [];
    for (let x = 1, y = 1000; x <= 1000 && y >= 1; x++) {
        while (y >= 1 && customfunction.f(x, y) > z) {
            y--;
        }
        if (y >= 1 && customfunction.f(x, y) === z) {
            res.push([x, y]);
        }
    }
    return res;
};
```

```go [sol3-Golang]
func findSolution(customFunction func(int, int) int, z int) (ans [][]int) {
    for x, y := 1, 1000; x <= 1000 && y > 0; x++ {
        for y > 0 && customFunction(x, y) > z {
            y--
        }
        if y > 0 && customFunction(x, y) == z {
            ans = append(ans, []int{x, y})
        }
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(m + n)$，其中 $m$ 是 $x$ 的取值数目，$n$ 是 $y$ 的取值数目。

+ 空间复杂度：$O(1)$。返回值不计入空间复杂度。