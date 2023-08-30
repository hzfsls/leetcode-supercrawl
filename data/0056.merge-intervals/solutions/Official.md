#### 方法一：排序

**思路**

如果我们按照区间的左端点排序，那么在排完序的列表中，可以合并的区间一定是连续的。如下图所示，标记为蓝色、黄色和绿色的区间分别可以合并成一个大区间，它们在排完序的列表中是连续的：

![56-2.png](https://pic.leetcode-cn.com/50417462969bd13230276c0847726c0909873d22135775ef4022e806475d763e-56-2.png)
{:align="center"}

**算法**

我们用数组 `merged` 存储最终的答案。

首先，我们将列表中的区间按照左端点升序排序。然后我们将第一个区间加入 `merged` 数组中，并按顺序依次考虑之后的每个区间：

- 如果当前区间的左端点在数组 `merged` 中最后一个区间的右端点之后，那么它们不会重合，我们可以直接将这个区间加入数组 `merged` 的末尾；

- 否则，它们重合，我们需要用当前区间的右端点更新数组 `merged` 中最后一个区间的右端点，将其置为二者的较大值。

**正确性证明**

上述算法的正确性可以用反证法来证明：在排完序后的数组中，两个本应合并的区间没能被合并，那么说明存在这样的三元组 $(i, j, k)$ 以及数组中的三个区间 $a[i], a[j], a[k]$ 满足 $i < j < k$ 并且 $(a[i], a[k])$ 可以合并，但 $(a[i], a[j])$ 和 $(a[j], a[k])$ 不能合并。这说明它们满足下面的不等式：

$$
a[i].end < a[j].start \quad (a[i] \text{ 和 } a[j] \text{ 不能合并}) \\
a[j].end < a[k].start \quad (a[j] \text{ 和 } a[k] \text{ 不能合并}) \\
a[i].end \geq a[k].start \quad (a[i] \text{ 和 } a[k] \text{ 可以合并}) \\
$$

我们联立这些不等式（注意还有一个显然的不等式 $a[j].start \leq a[j].end$），可以得到：

$$
a[i].end < a[j].start \leq a[j].end < a[k].start
$$

产生了矛盾！这说明假设是不成立的。因此，所有能够合并的区间都必然是连续的。

```Python [sol1-Python3]
class Solution:
    def merge(self, intervals: List[List[int]]) -> List[List[int]]:
        intervals.sort(key=lambda x: x[0])

        merged = []
        for interval in intervals:
            # 如果列表为空，或者当前区间与上一区间不重合，直接添加
            if not merged or merged[-1][1] < interval[0]:
                merged.append(interval)
            else:
                # 否则的话，我们就可以与上一区间进行合并
                merged[-1][1] = max(merged[-1][1], interval[1])

        return merged
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> merge(vector<vector<int>>& intervals) {
        if (intervals.size() == 0) {
            return {};
        }
        sort(intervals.begin(), intervals.end());
        vector<vector<int>> merged;
        for (int i = 0; i < intervals.size(); ++i) {
            int L = intervals[i][0], R = intervals[i][1];
            if (!merged.size() || merged.back()[1] < L) {
                merged.push_back({L, R});
            }
            else {
                merged.back()[1] = max(merged.back()[1], R);
            }
        }
        return merged;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[][] merge(int[][] intervals) {
        if (intervals.length == 0) {
            return new int[0][2];
        }
        Arrays.sort(intervals, new Comparator<int[]>() {
            public int compare(int[] interval1, int[] interval2) {
                return interval1[0] - interval2[0];
            }
        });
        List<int[]> merged = new ArrayList<int[]>();
        for (int i = 0; i < intervals.length; ++i) {
            int L = intervals[i][0], R = intervals[i][1];
            if (merged.size() == 0 || merged.get(merged.size() - 1)[1] < L) {
                merged.add(new int[]{L, R});
            } else {
                merged.get(merged.size() - 1)[1] = Math.max(merged.get(merged.size() - 1)[1], R);
            }
        }
        return merged.toArray(new int[merged.size()][]);
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 为区间的数量。除去排序的开销，我们只需要一次线性扫描，所以主要的时间开销是排序的 $O(n\log n)$。

- 空间复杂度：$O(\log n)$，其中 $n$ 为区间的数量。这里计算的是存储答案之外，使用的额外空间。$O(\log n)$ 即为排序所需要的空间复杂度。