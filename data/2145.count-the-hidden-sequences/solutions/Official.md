## [2145.统计隐藏数组数目 中文官方题解](https://leetcode.cn/problems/count-the-hidden-sequences/solutions/100000/tong-ji-yin-cang-shu-zu-shu-mu-by-leetco-t5su)
#### 方法一：确定隐藏数组上下界的差值

**思路与算法**

记最终的数组为 $a_0, a_1, \cdots, a_n$。我们可以发现，如果数组 $a$ 满足要求，那么：

$$
a_0 + k, a_1 + k, \cdots, a_n + k
$$

也一定满足要求。这里的「要求」指的是相邻元素的差值对应着给定的数组 $\textit{differences}$。

因此我们就可以任意指定 $a_0$，为了方便不妨直接令 $a_0 = 0$，我们就可以还原出数组 $a_0, a_1, \cdots, a_n$ 了。如果我们继续考虑数组元素都在 $[\textit{lower}, \textit{upper}]$ 范围内的要求，不妨记数组中最小的元素为 $a_i$，最大的元素为 $a_j$，显然需要满足：

$$
\textit{lower} \leq a_i \leq a_j \leq \textit{upper}
$$

那么 $a_i$ 的取值下界即为 $\textit{lower}$，上界为 $\textit{upper} - (a_j - a_i)$，即需要保证最大值 $a_j$ 不能超过 $\textit{upper}$。这里的 $a_j - a_i$ 实际上与 $a_i, a_j$ 本身的值无关，它就等于：

$$
\sum_{k=i}^{j-1} \textit{differences}[k]
$$

因此符合要求的隐藏数组的数目即为 $\textit{upper} - (a_j - a_i) - \textit{lower} + 1$，整理可得：

$$
(\textit{upper} - \textit{lower}) - (a_j - a_i) + 1
$$

实际上就是规定的数组元素的区间长度，减去数组元素最大值与最小值的差值，再加上 $1$。我们可以将其看成是一个长度为 $a_j - a_i$ 的小窗口在长度为 $\textit{upper} - \textit{lower}$ 的大窗口中滑动时，能够放置的位置数量。

**细节**

在还原数组 $a$ 的过程中，我们无需记录整个数组，而是只需要记录最大值和最小值即可。如果某一时刻最大值与最小值的差值大于 $\textit{upper} - \textit{lower}$，我们可以直接返回 $0$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numberOfArrays(vector<int>& differences, int lower, int upper) {
        int x = 0, y = 0, cur = 0;
        for (int d: differences) {
            cur += d;
            x = min(x, cur);
            y = max(y, cur);
            if (y - x > upper - lower) {
                return 0;
            }
        }
        return (upper - lower) - (y - x) + 1;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numberOfArrays(self, differences: List[int], lower: int, upper: int) -> int:
        x = y = cur = 0
        for d in differences:
            cur += d
            x = min(x, cur)
            y = max(y, cur)
            if y - x > upper - lower:
                return 0
        return (upper - lower) - (y - x) + 1
```

```Golang [sol1-Golang]
func numberOfArrays(differences []int, lower int, upper int) int {
	var x, y, cur int
	for _, d := range differences {
		cur += d
		x, y = min(x, cur), max(y, cur)
		if y-x > upper-lower {
			return 0
		}
	}
	return (upper - lower) - (y - x) + 1
}

func min(x, y int) int {
	if x > y {
		return y
	}
	return x
}

func max(x, y int) int {
	if x > y {
		return x
	}
	return y
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$。