## [1033.移动石子直到连续 中文官方题解](https://leetcode.cn/problems/moving-stones-until-consecutive/solutions/100000/yi-dong-shi-zi-zhi-dao-lian-xu-by-leetco-y5kb)

#### 方法一：贪心

**思路与算法**

我们可以假设 $x, y, z$ 分别为从小到大排序后的 $a, b, c$，来讨论最小和最大移动次数。

1. 当三枚石子连续放置时，即 $(y - x) = 1$ 并且 $(z - y) = 1$，不需要额外移动，最小移动次数为 $0$。
2. 当三枚石子中有两枚是连续放置，或者间隔为 $1$ 时，我们只需对另外一枚石子移动一次，最小移动次数为 $1$。
3. 对于其他情况，我们最小需要移动 $2$ 次。

对于最多移动次数，我们可以考虑将 $x$ 向右（增加 $1$），或者将 $z$ 向左（减小 $1$），每次移动都会使得两侧的距离减小 $1$，所以最多可以移动 $z - x - 2$ 次。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> numMovesStones(int a, int b, int c) {
        int x = min({a, b, c});
        int z = max({a, b, c});
        int y = a + b + c - x - z;

        vector<int> res(2);
        res[0] = 2;
        if ((z - y) == 1 && (y - x) == 1) {
            res[0] = 0;
        } else if ((z - y) <= 2 || (y - x) <= 2) {
            res[0] = 1;
        }
        res[1] = (z - x - 2);
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] numMovesStones(int a, int b, int c) {
        int x = Math.min(Math.min(a, b), c);
        int z = Math.max(Math.max(a, b), c);
        int y = a + b + c - x - z;

        int[] res = new int[2];
        res[0] = 2;
        if (z - y == 1 && y - x == 1) {
            res[0] = 0;
        } else if (z - y <= 2 || y - x <= 2) {
            res[0] = 1;
        }
        res[1] = z - x - 2;
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numMovesStones(self, a: int, b: int, c: int) -> List[int]:
        x, y, z = sorted([a, b, c])
        res = [2, z - x - 2]
        if ((z - y) == 1 and (y - x) == 1):
            res[0] = 0
        elif ((z - y) <= 2 or (y - x) <= 2):
            res[0] = 1
        return res
```

```Go [sol1-Go]
func numMovesStones(a int, b int, c int) []int {
    x:= min(min(a, b), c)
    z:= max(max(a, b), c)
    y:= a + b + c - x - z
    res := []int{2, z - x - 2}
    if ((z - y) == 1 && (y - x) == 1) {
        res[0] = 0;
    } else if ((z - y) <= 2 || (y - x) <= 2) {
        res[0] = 1;
    }
    return res
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

```JavaScript [sol1-JavaScript]
var numMovesStones = function(a, b, c) {
    let x = Math.min(Math.min(a, b), c);
    let z = Math.max(Math.max(a, b), c);
    let y = a + b + c - x - z;
    let res = [2, z - x - 2];
    if (z - y == 1 && y - x == 1) {
        res[0] = 0;
    } else if (z - y <= 2 || y - x <= 2) {
        res[0] = 1;
    }
    return res;
};
```

```C# [sol1-C#]
public class Solution {
    public int[] NumMovesStones(int a, int b, int c) {
        int x = Math.Min(Math.Min(a, b), c);
        int z = Math.Max(Math.Max(a, b), c);
        int y = a + b + c - x - z;

        int[] res = new int[2];
        res[0] = 2;
        if (z - y == 1 && y - x == 1) {
            res[0] = 0;
        } else if (z - y <= 2 || y - x <= 2) {
            res[0] = 1;
        }
        res[1] = z - x - 2;
        return res;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int* numMovesStones(int a, int b, int c, int* returnSize) {
    int x = MIN(a, b);
    int z = MAX(a, b);
    x = MIN(x, c);
    z = MAX(z, c);
    int y = a + b + c - x - z;

    int *res = (int *)malloc(sizeof(int) * 2);
    res[0] = 2;
    if ((z - y) == 1 && (y - x) == 1) {
        res[0] = 0;
    } else if ((z - y) <= 2 || (y - x) <= 2) {
        res[0] = 1;
    }
    res[1] = (z - x - 2);
    *returnSize = 2;
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。