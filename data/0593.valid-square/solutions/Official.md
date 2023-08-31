## [593.有效的正方形 中文官方题解](https://leetcode.cn/problems/valid-square/solutions/100000/you-xiao-de-zheng-fang-xing-by-leetcode-94t5m)

#### 方法一：数学

**思路与算法**

[正方形判定定理](https://baike.baidu.com/item/%E6%AD%A3%E6%96%B9%E5%BD%A2%E5%88%A4%E5%AE%9A%E5%AE%9A%E7%90%86/5599805)是几何学里用于判定一个四边形是否为正方形的判定定理。判别正方形的一般顺序为先说明它是平行四边形；再说明它是菱形（或矩形）；最后说明它是矩形（或菱形）。那么我们可以从枚举四边形的两条斜边入手来进行判断：

1. 如果两条斜边的中点相同：则说明以该两条斜边组成的四边形为「平行四边形」。
2. 在满足「条件一」的基础上，如果两条斜边的长度相同：则说明以该两条斜边组成的四边形为「矩形」。
3. 在满足「条件二」的基础上，如果两条斜边的相互垂直：则说明以该两条斜边组成的四边形为「正方形」。

**代码**

```Python [sol1-Python3]
def checkLength(v1: Tuple[int, int], v2: Tuple[int, int]) -> bool:
    return v1[0] * v1[0] + v1[1] * v1[1] == v2[0] * v2[0] + v2[1] * v2[1]

def checkMidPoint(p1: List[int], p2: List[int], p3: List[int], p4: List[int]) -> bool:
    return p1[0] + p2[0] == p3[0] + p4[0] and p1[1] + p2[1] == p3[1] + p4[1]

def calCos(v1: Tuple[int, int], v2: Tuple[int, int]) -> int:
    return v1[0] * v2[0] + v1[1] * v2[1]

def help(p1: List[int], p2: List[int], p3: List[int], p4: List[int]) -> bool:
    v1 = (p1[0] - p2[0], p1[1] - p2[1])
    v2 = (p3[0] - p4[0], p3[1] - p4[1])
    return checkMidPoint(p1, p2, p3, p4) and checkLength(v1, v2) and calCos(v1, v2) == 0

class Solution:
    def validSquare(self, p1: List[int], p2: List[int], p3: List[int], p4: List[int]) -> bool:
        if p1 == p2:
            return False
        if help(p1, p2, p3, p4):
            return True
        if p1 == p3:
            return False
        if help(p1, p3, p2, p4):
            return True
        if p1 == p4:
            return False
        if help(p1, p4, p2, p3):
            return True
        return False
```

```C++ [sol1-C++]
class Solution {
public:
    bool checkLength(vector<int>& v1, vector<int>& v2) {
        return (v1[0] * v1[0] + v1[1] * v1[1]) == (v2[0] * v2[0] + v2[1] * v2[1]);
    }

    bool checkMidPoint(vector<int>& p1, vector<int>& p2, vector<int>& p3, vector<int>& p4) {
        return (p1[0] + p2[0]) == (p3[0] + p4[0]) && (p1[1] + p2[1]) == (p3[1] + p4[1]);
    }

    int calCos(vector<int>& v1, vector<int>& v2) {
        return (v1[0] * v2[0] + v1[1] * v2[1]) == 0;
    }

    bool help(vector<int>& p1, vector<int>& p2, vector<int>& p3, vector<int>& p4) {
        vector<int> v1 = {p1[0] - p2[0], p1[1] - p2[1]};
        vector<int> v2 = {p3[0] - p4[0], p3[1] - p4[1]};
        if (checkMidPoint(p1, p2, p3, p4) && checkLength(v1, v2) && calCos(v1, v2)) {
            return true;
        } 
        return false;
    }

    bool validSquare(vector<int>& p1, vector<int>& p2, vector<int>& p3, vector<int>& p4) {
        if (p1 == p2) {
            return false;
        }
        if (help(p1, p2, p3, p4)) {
            return true;
        }
        if (p1 == p3) {
            return false;
        }
        if (help(p1, p3, p2, p4)) {
            return true;
        }
        if (p1 == p4) {
            return false;
        }
        if (help(p1, p4, p2, p3)) {
            return true;
        }
        return false;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean validSquare(int[] p1, int[] p2, int[] p3, int[] p4) {
        if (Arrays.equals(p1, p2)) {
            return false;
        }
        if (help(p1, p2, p3, p4)) {
            return true;
        }
        if (Arrays.equals(p1, p3)) {
            return false;
        }
        if (help(p1, p3, p2, p4)) {
            return true;
        }
        if (Arrays.equals(p1, p4)) {
            return false;
        }
        if (help(p1, p4, p2, p3)) {
            return true;
        }
        return false;
    }

    public boolean help(int[] p1, int[] p2, int[] p3, int[] p4) {
        int[] v1 = {p1[0] - p2[0], p1[1] - p2[1]};
        int[] v2 = {p3[0] - p4[0], p3[1] - p4[1]};
        if (checkMidPoint(p1, p2, p3, p4) && checkLength(v1, v2) && calCos(v1, v2)) {
            return true;
        } 
        return false;
    }

    public boolean checkLength(int[] v1, int[] v2) {
        return (v1[0] * v1[0] + v1[1] * v1[1]) == (v2[0] * v2[0] + v2[1] * v2[1]);
    }

    public boolean checkMidPoint(int[] p1, int[] p2, int[] p3, int[] p4) {
        return (p1[0] + p2[0]) == (p3[0] + p4[0]) && (p1[1] + p2[1]) == (p3[1] + p4[1]);
    }

    public boolean calCos(int[] v1, int[] v2) {
        return (v1[0] * v2[0] + v1[1] * v2[1]) == 0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool ValidSquare(int[] p1, int[] p2, int[] p3, int[] p4) {
        if (p1[0] == p2[0] && p1[1] == p2[1]) {
            return false;
        }
        if (Help(p1, p2, p3, p4)) {
            return true;
        }
        if (p1[0] == p3[0] && p1[1] == p3[1]) {
            return false;
        }
        if (Help(p1, p3, p2, p4)) {
            return true;
        }
        if (p1[0] == p4[0] && p1[1] == p4[1]) {
            return false;
        }
        if (Help(p1, p4, p2, p3)) {
            return true;
        }
        return false;
    }

    public bool Help(int[] p1, int[] p2, int[] p3, int[] p4) {
        int[] v1 = {p1[0] - p2[0], p1[1] - p2[1]};
        int[] v2 = {p3[0] - p4[0], p3[1] - p4[1]};
        if (CheckMidPoint(p1, p2, p3, p4) && CheckLength(v1, v2) && CalCos(v1, v2)) {
            return true;
        } 
        return false;
    }

    public bool CheckLength(int[] v1, int[] v2) {
        return (v1[0] * v1[0] + v1[1] * v1[1]) == (v2[0] * v2[0] + v2[1] * v2[1]);
    }

    public bool CheckMidPoint(int[] p1, int[] p2, int[] p3, int[] p4) {
        return (p1[0] + p2[0]) == (p3[0] + p4[0]) && (p1[1] + p2[1]) == (p3[1] + p4[1]);
    }

    public bool CalCos(int[] v1, int[] v2) {
        return (v1[0] * v2[0] + v1[1] * v2[1]) == 0;
    }
}
```

```C [sol1-C]
static inline bool isSamePoint(const int *v1, const int *v2) {
    return (v1[0] == v2[0]) && (v1[1] == v2[1]);
}

static inline bool checkLength(const int *v1, const int *v2) {
    return (v1[0] * v1[0] + v1[1] * v1[1]) == (v2[0] * v2[0] + v2[1] * v2[1]);
}

static inline bool checkMidPoint(const int* p1, const int* p2, const int* p3, const int* p4) {
    return (p1[0] + p2[0]) == (p3[0] + p4[0]) && (p1[1] + p2[1]) == (p3[1] + p4[1]);
}

static inline int calCos(const int *v1, const int *v2) {
    return (v1[0] * v2[0] + v1[1] * v2[1]) == 0;
}

bool help(const int* p1, const int* p2, const int* p3, const int* p4) {
    int v1[2] = {p1[0] - p2[0], p1[1] - p2[1]};
    int v2[2] = {p3[0] - p4[0], p3[1] - p4[1]};
    if (checkMidPoint(p1, p2, p3, p4) && checkLength(v1, v2) && calCos(v1, v2)) {
        return true;
    } 
    return false;
}
bool validSquare(int* p1, int p1Size, int* p2, int p2Size, int* p3, int p3Size, int* p4, int p4Size) {
    if (isSamePoint(p1, p2) || isSamePoint(p1, p3) || isSamePoint(p1, p4)) {
        return false;
    }
    if (help(p1, p2, p3, p4) || help(p1, p3, p2, p4) || help(p1, p4, p2, p3)) {
        return true;
    }
    return false;
}
```

```JavaScript [sol1-JavaScript]
var validSquare = function(p1, p2, p3, p4) {
    if (_.isEqual(p1, p2)) {
        return false;
    }
    if (help(p1, p2, p3, p4)) {
        return true;
    }
    if (_.isEqual(p1, p3)) {
        return false;
    }
    if (help(p1, p3, p2, p4)) {
        return true;
    }
    if (_.isEqual(p1, p4)) {
        return false;
    }
    if (help(p1, p4, p2, p3)) {
        return true;
    }
    return false;
}

const help = (p1, p2, p3, p4) => {
    const v1 = [p1[0] - p2[0], p1[1] - p2[1]];
    const v2 = [p3[0] - p4[0], p3[1] - p4[1]];
    if (checkMidPoint(p1, p2, p3, p4) && checkLength(v1, v2) && calCos(v1, v2)) {
        return true;
    } 
    return false;
}

const checkLength = (v1, v2) => {
    return (v1[0] * v1[0] + v1[1] * v1[1]) === (v2[0] * v2[0] + v2[1] * v2[1]);
}

const checkMidPoint = (p1, p2, p3, p4) => {
    return (p1[0] + p2[0]) === (p3[0] + p4[0]) && (p1[1] + p2[1]) === (p3[1] + p4[1]);
}

const calCos = (v1, v2) => {
    return (v1[0] * v2[0] + v1[1] * v2[1]) === 0;
};
```

```go [sol1-Golang]
func checkLength(v1, v2 []int) bool {
    return v1[0]*v1[0]+v1[1]*v1[1] == v2[0]*v2[0]+v2[1]*v2[1]
}

func checkMidPoint(p1, p2, p3, p4 []int) bool {
    return p1[0]+p2[0] == p3[0]+p4[0] && p1[1]+p2[1] == p3[1]+p4[1]
}

func calCos(v1, v2 []int) int {
    return v1[0]*v2[0] + v1[1]*v2[1]
}

func help(p1, p2, p3, p4 []int) bool {
    v1 := []int{p1[0] - p2[0], p1[1] - p2[1]}
    v2 := []int{p3[0] - p4[0], p3[1] - p4[1]}
    return checkMidPoint(p1, p2, p3, p4) && checkLength(v1, v2) && calCos(v1, v2) == 0
}

func validSquare(p1, p2, p3, p4 []int) bool {
    if p1[0] == p2[0] && p1[1] == p2[1] {
        return false
    }
    if help(p1, p2, p3, p4) {
        return true
    }
    if p1[0] == p3[0] && p1[1] == p3[1] {
        return false
    }
    if help(p1, p3, p2, p4) {
        return true
    }
    if p1[0] == p4[0] && p1[1] == p4[1] {
        return false
    }
    if help(p1, p4, p2, p3) {
        return true
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$，仅使用常数变量。