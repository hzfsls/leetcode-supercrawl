## [849.到最近的人的最大距离 中文官方题解](https://leetcode.cn/problems/maximize-distance-to-closest-person/solutions/100000/dao-zui-jin-de-ren-de-zui-da-ju-chi-by-l-zboe)
#### 方法一：双指针 + 贪心

**思路与算法**

题目给出一个下标从 $0$ 开始，长度为 $n$ 的数组 $\textit{seats}$，其中 $\textit{seats}[i] = 1$ 表示有人坐在第 $i$ 个位置上，在该题解中我们称之为「有人座位」，$\textit{seats}[i] = 0$ 表示第 $i$ 个座位为空，称之为「无人座位」，并且题目数据保证至少有一个「有人座位」和「无人座位」。现在我们需要找到一个「无人座位」使得该位置与距离该位置最近的「有人位置」之间的距离最大，并返回该值。

首先假设已经确定了我们所选择的「无人座位」$i$ 的左和右离它最近的「有人座位」分别为座位 $l$ 和 $r$，$0 \le l < i < r < n$。那么此时座位 $i$ 的离其位置最近的人的距离 

$$d_{min} = \min\{i - l, r - i\} \le \lfloor \frac{r - l}{2} \rfloor$$

其中当 $i = \lfloor \frac{l + r}{2} \rfloor$ 时取到等号。所以对于两个相邻的「有人座位」，我们在中间就坐一定是最优的。因此我们可以用「双指针」来找到每一对相邻的有人座位，并计算若在其中间就坐能得到的最大间隔距离。

以上的讨论是建立在我们选择的「无人座位」的左右都存在「有人座位」的情况。对于边缘的「无人座位」，即其某一侧不存在「有人座位」：

- 若左边存在边缘的「无人座位」，则此时为了使距离其最近的右边的「有人座位」最远，我们应该尽可能的往左边坐，即坐在第一个位置。
- 若右边存在边缘的「无人座位」，则此时为了使距离其最近的左边的「有人座位」最远，我们应该尽可能的往右边坐，即坐在第最后一个位置。

最后返回全部情况中能得到的最大距离即可。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    int maxDistToClosest(vector<int>& seats) {
        int res = 0;
        int l = 0;
        while (l < seats.size() && seats[l] == 0) {
            ++l;
        }
        res = max(res, l);
        while (l < seats.size()) {
            int r = l + 1;
            while (r < seats.size() && seats[r] == 0) {
                ++r;
            }
            if (r == seats.size()) {
                res = max(res, r - l - 1);
            } else {
                res = max(res, (r - l) / 2);
            }
            l = r;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxDistToClosest(int[] seats) {
        int res = 0;
        int l = 0;
        while (l < seats.length && seats[l] == 0) {
            ++l;
        }
        res = Math.max(res, l);
        while (l < seats.length) {
            int r = l + 1;
            while (r < seats.length && seats[r] == 0) {
                ++r;
            }
            if (r == seats.length) {
                res = Math.max(res, r - l - 1);
            } else {
                res = Math.max(res, (r - l) / 2);
            }
            l = r;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxDistToClosest(int[] seats) {
        int res = 0;
        int l = 0;
        while (l < seats.Length && seats[l] == 0) {
            ++l;
        }
        res = Math.Max(res, l);
        while (l < seats.Length) {
            int r = l + 1;
            while (r < seats.Length && seats[r] == 0) {
                ++r;
            }
            if (r == seats.Length) {
                res = Math.Max(res, r - l - 1);
            } else {
                res = Math.Max(res, (r - l) / 2);
            }
            l = r;
        }
        return res;
    }
}
```

```C [sol1-C]
int maxDistToClosest(int* seats, int seatsSize) {
    int res = 0, l = 0;
    while (l < seatsSize && seats[l] == 0) {
        ++l;
    }
    res = fmax(res, l);
    while (l < seatsSize) {
        int r = l + 1;
        while (r < seatsSize && seats[r] == 0) {
            ++r;
        }
        if (r == seatsSize) {
            res = fmax(res, r - l - 1);
        } else {
            res = fmax(res, (r - l) / 2);
        }
        l = r;
    }
    return res;
}
```

```Python [sol1-Python]
class Solution:
    def maxDistToClosest(self, seats: List[int]) -> int:
        res, l = 0, 0
        while l < len(seats) and seats[l] == 0:
            l += 1
        res = max(res, l)
        while l < len(seats):
            r = l + 1
            while r < len(seats) and seats[r] == 0:
                r += 1
            if r == len(seats):
                res = max(res, r - l - 1)
            else:
                res = max(res, (r - l) // 2)
            l = r
        return res
```

```Go [sol1-Go]
func maxDistToClosest(seats []int) int {
    res := 0
    l := 0
    for l < len(seats) && seats[l] == 0 {
        l++
    }
    res = max(res, l)
    for l < len(seats) {
        r := l + 1
        for r < len(seats) && seats[r] == 0 {
            r++
        }
        if r == len(seats) {
            res = max(res, r - l - 1)
        } else {
            res = max(res, (r - l) / 2)
        }
        l = r
    }
    return res
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var maxDistToClosest = function(seats) {
    let res = 0, l = 0;
    while (l < seats.length && seats[l] === 0) {
        l++;
    }
    res = Math.max(res, l);
    while (l < seats.length) {
        let r = l + 1;
        while (r < seats.length && seats[r] === 0) {
            r++;
        }
        if (r === seats.length) {
            res = Math.max(res, r - l - 1);
        } else {
            res = Math.max(res, parseInt((r - l) / 2));
        }
        l = r;
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{seats}$ 的长度。
- 空间复杂度：$O(1)$，仅使用常量空间。