### 方法一：枚举

对于列表中的每个区间 `p`，我们可以枚举其余的所有区间，并依次判断区间 `p` 是否被某个区间所覆盖。

```C++ [sol1-C++]
class Solution {
public:
    int removeCoveredIntervals(vector<vector<int>>& intervals) {
        int n = intervals.size();
        int ans = n;
        for (int i = 0; i < intervals.size(); ++i) {
            for (int j = 0; j < intervals.size(); ++j) {
                if (i != j && intervals[j][0] <= intervals[i][0] && intervals[i][1] <= intervals[j][1]) {
                    --ans;
                    break;
                }
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def removeCoveredIntervals(self, intervals: List[List[int]]) -> int:
        n = len(intervals)
        ans = n
        for i in range(n):
            for j in range(n):
                if i != j and intervals[j][0] <= intervals[i][0] and intervals[i][1] <= intervals[j][1]:
                    ans -= 1
                    break
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 是区间的个数。

- 空间复杂度：$O(1)$。

### 方法二：排序 + 遍历

我们首先假设所有区间的左端点都不相同。

如果我们将所有区间按照左端点递增排序，那么对于排完序的列表中第 $i$ 个区间 $[l_i, r_i)$：

- 出现在其之前的任一区间 $[l_j, r_j)$ 一定满足 $l_j < l_i$。因此只要存在一个区间 $[l_j, r_j)$ 满足 $j < i$ 且 $r_j \geq r_i$，那么区间 $[l_i, r_i)$ 一定会被覆盖。换句话说，只要出现在 $[l_i, r_i)$ 之前的区间的右端点最大值 $r_{max} = \max(r_1, r_2, \cdots, r_{i-1})$ 满足 $r_{max} \geq r_i$，那么区间 $[l_i, r_i)$ 一定会被覆盖；

- 出现在其之后的任一区间 $[l_j, r_j)$ 一定满足 $l_j > l_i$，因此区间 $[l_i, r_i)$ 不可能被任何出现在其之后的区间覆盖。

这样以来，当我们判断第 $i$ 个区间是否被覆盖时，只需要判断 $r_{max} \geq r_i$ 是否满足即可。在这之后，我们更新 $r_{max}$ 的值，并判断第 $i + 1$ 个区间。以此类推。

那么我们如何处理区间左端点相同的情况呢？此时如果我们只按照区间左端点递增排序，那么对于第 $i$ 个区间 $[l_i, r_i)$，出现在其之后的区间 $[l_j, r_j)$ 满足的条件是 $l_j \geq l_i$ 而不是 $l_j > l_i$，即在 $l_j = l_i$ 时，第 $i$ 个区间还是有可能被出现在其之后的区间覆盖的。一种常用的解决方法是将区间按照左端点为第一关键字且递增、右端点为第二关键字且递减进行排序。此时对于第 $i$ 个区间 $[l_i, r_i)$，出现在其之后的区间 $[l_j, r_j)$ 即使满足 $l_j = l_i$，但根据新的排序规则，一定有 $r_j < r_i$，因此区间 $[l_i, r_i)$ 不可能被任何出现在其之后的区间覆盖。这样我们就很好地处理了左端点相同的情况。

```C++ [sol2-C++]
class Solution {
public:
    int removeCoveredIntervals(vector<vector<int>>& intervals) {
        int n = intervals.size();
        sort(intervals.begin(), intervals.end(), [](const vector<int>& u, const vector<int>& v) {
            return u[0] < v[0] || (u[0] == v[0] && u[1] > v[1]);
        });
        int ans = n;
        int rmax = intervals[0][1];
        for (int i = 1; i < n; ++i) {
            if (intervals[i][1] <= rmax) {
                --ans;
            }
            else {
                rmax = max(rmax, intervals[i][1]);
            }
        }
        return ans;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def removeCoveredIntervals(self, intervals: List[List[int]]) -> int:
        n = len(intervals)
        intervals.sort(key=lambda u: (u[0], -u[1]))
        ans, rmax = n, intervals[0][1]
        for i in range(1, n):
            if intervals[i][1] <= rmax:
                ans -= 1
            else:
                rmax = max(rmax, intervals[i][1])
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N \log N)$，其中 $N$ 是区间的个数。

- 空间复杂度：$O(\log N)$，为排序需要的空间。