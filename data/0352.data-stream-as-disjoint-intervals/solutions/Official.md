## [352.将数据流变为多个不相交区间 中文官方题解](https://leetcode.cn/problems/data-stream-as-disjoint-intervals/solutions/100000/jiang-shu-ju-liu-bian-wei-duo-ge-bu-xian-hm1r)
#### 方法一：使用有序映射维护区间

**思路与算法**

假设我们使用某一数据结构维护这些不相交的区间，在设计具体的数据结构之前，我们需要先明确 $\texttt{void addNum(int val)}$ 这一操作会使得当前的区间集合发生何种变化：

- 情况一：如果存在一个区间 $[l, r]$，它完全包含 $\textit{val}$，即 $l \leq \textit{val} \leq r$，那么在加入 $\textit{val}$ 之后，区间集合不会有任何变化；

- 情况二：如果存在一个区间 $[l, r]$，它的右边界 $r$「紧贴着」$\textit{val}$，即 $r + 1 = \textit{val}$，那么在加入 $\textit{val}$ 之后，该区间会从 $[l, r]$ 变为 $[l, r+1]$；

- 情况三：如果存在一个区间 $[l, r]$，它的左边界 $l$「紧贴着」$\textit{val}$，即 $l - 1 = \textit{val}$，那么在加入 $\textit{val}$ 之后，该区间会从 $[l, r]$ 变为 $[l - 1, r]$；

- 情况四：如果情况二和情况三同时满足，即存在一个区间 $[l_0, r_0]$ 满足 $r_0+1 = \textit{val}$，并且存在一个区间 $[l_1, r_1]$ 满足 $l_1-1 = \textit{val}$，那么在加入 $\textit{val}$ 之后，这两个区间会合并成一个大区间 $[l_0, r_1]$；

- 情况五：在上述四种情况均不满足的情况下，$\textit{val}$ 会单独形成一个新的区间 $[\textit{val}, \textit{val}]$。

根据上面的五种情况，我们需要找到离 $\textit{val}$ 最近的两个区间。用严谨的语言可以表述为：

> 对于给定的 $\textit{val}$，我们需要找到区间 $[l_0, r_0]$，使得 $l_0$ 是**最大的**满足 $l_0 \leq \textit{val}$ 的区间。同时，我们需要找到区间 $[l_1, r_1]$，使得 $l_1$ 是**最小的**满足 $l_1 > \textit{val}$ 的区间。

如果我们的数据结构能够快速找到这两个区间，那么上面的五种情况分别对应为：

- 情况一：$l_0 \leq \textit{val} \leq l_1$；
- 情况二：$r_0 + 1 = \textit{val}$；
- 情况三：$l_1 - 1 = \textit{val}$；
- 情况四：$r_0 + 1 = \textit{val}$ 并且 $l_1 - 1 = \textit{val}$；
- 情况五：上述情况均不满足。

一种可以找到「最近」区间的数据结构是有序映射。有序映射中的键和值分别表示区间的左边界 $l$ 和右边界 $r$。由于有序映射支持查询「最大的比某个元素小的键」以及「最小的比某个元素大的键」这两个操作，因此我们可以快速地定位区间 $[l_0, r_0]$ 和 $[l_1, r_1]$。

除此之外，对于 $\texttt{int[][] getIntervals()}$ 操作，我们只需要对有序映射进行遍历，将所有的键值对返回即可。

**细节**

在实际的代码编写中，需要注意 $[l_0, r_0]$ 或 $[l_1, r_1]$ 不存在的情况。

**代码**

```C++ [sol1-C++]
class SummaryRanges {
private:
    map<int, int> intervals;

public:
    SummaryRanges() {}
    
    void addNum(int val) {
        // 找到 l1 最小的且满足 l1 > val 的区间 interval1 = [l1, r1]
        // 如果不存在这样的区间，interval1 为尾迭代器
        auto interval1 = intervals.upper_bound(val);
        // 找到 l0 最大的且满足 l0 <= val 的区间 interval0 = [l0, r0]
        // 在有序集合中，interval0 就是 interval1 的前一个区间
        // 如果不存在这样的区间，interval0 为尾迭代器
        auto interval0 = (interval1 == intervals.begin() ? intervals.end() : prev(interval1));

        if (interval0 != intervals.end() && interval0->first <= val && val <= interval0->second) {
            // 情况一
            return;
        }
        else {
            bool left_aside = (interval0 != intervals.end() && interval0->second + 1 == val);
            bool right_aside = (interval1 != intervals.end() && interval1->first - 1 == val);
            if (left_aside && right_aside) {
                // 情况四
                int left = interval0->first, right = interval1->second;
                intervals.erase(interval0);
                intervals.erase(interval1);
                intervals.emplace(left, right);
            }
            else if (left_aside) {
                // 情况二
                ++interval0->second;
            }
            else if (right_aside) {
                // 情况三
                int right = interval1->second;
                intervals.erase(interval1);
                intervals.emplace(val, right);
            }
            else {
                // 情况五
                intervals.emplace(val, val);
            }
        }
    }
    
    vector<vector<int>> getIntervals() {
        vector<vector<int>> ans;
        for (const auto& [left, right]: intervals) {
            ans.push_back({left, right});
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class SummaryRanges {
    TreeMap<Integer, Integer> intervals;

    public SummaryRanges() {
        intervals = new TreeMap<Integer, Integer>();
    }
    
    public void addNum(int val) {
        // 找到 l1 最小的且满足 l1 > val 的区间 interval1 = [l1, r1]
        // 如果不存在这样的区间，interval1 为尾迭代器
        Map.Entry<Integer, Integer> interval1 = intervals.ceilingEntry(val + 1);
        // 找到 l0 最大的且满足 l0 <= val 的区间 interval0 = [l0, r0]
        // 在有序集合中，interval0 就是 interval1 的前一个区间
        // 如果不存在这样的区间，interval0 为尾迭代器
        Map.Entry<Integer, Integer> interval0 = intervals.floorEntry(val);

        if (interval0 != null && interval0.getKey() <= val && val <= interval0.getValue()) {
            // 情况一
            return;
        } else {
            boolean leftAside = interval0 != null && interval0.getValue() + 1 == val;
            boolean rightAside = interval1 != null && interval1.getKey() - 1 == val;
            if (leftAside && rightAside) {
                // 情况四
                int left = interval0.getKey(), right = interval1.getValue();
                intervals.remove(interval0.getKey());
                intervals.remove(interval1.getKey());
                intervals.put(left, right);
            } else if (leftAside) {
                // 情况二
                intervals.put(interval0.getKey(), interval0.getValue() + 1);
            } else if (rightAside) {
                // 情况三
                int right = interval1.getValue();
                intervals.remove(interval1.getKey());
                intervals.put(val, right);
            } else {
                // 情况五
                intervals.put(val, val);
            }
        }
    }
    
    public int[][] getIntervals() {
        int size = intervals.size();
        int[][] ans = new int[size][2];
        int index = 0;
        for (Map.Entry<Integer, Integer> entry : intervals.entrySet()) {
            int left = entry.getKey(), right = entry.getValue();
            ans[index][0] = left;
            ans[index][1] = right;
            ++index;
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
from sortedcontainers import SortedDict

class SummaryRanges:

    def __init__(self):
        self.intervals = SortedDict()

    def addNum(self, val: int) -> None:
        intervals_ = self.intervals
        keys_ = self.intervals.keys()
        values_ = self.intervals.values()

        # 找到 l1 最小的且满足 l1 > val 的区间 interval1 = [l1, r1]
        # 如果不存在这样的区间，interval1 为 len(intervals)
        interval1 = intervals_.bisect_right(val)
        # 找到 l0 最大的且满足 l0 <= val 的区间 interval0 = [l0, r0]
        # 在有序集合中，interval0 就是 interval1 的前一个区间
        # 如果不存在这样的区间，interval0 为尾迭代器
        interval0 = (len(intervals_) if interval1 == 0 else interval1 - 1)

        if interval0 != len(intervals_) and keys_[interval0] <= val <= values_[interval0]:
            # 情况一
            return
        else:
            left_aside = (interval0 != len(intervals_) and values_[interval0] + 1 == val)
            right_aside = (interval1 != len(intervals_) and keys_[interval1] - 1 == val)
            if left_aside and right_aside:
                # 情况四
                left, right = keys_[interval0], values_[interval1]
                intervals_.popitem(interval1)
                intervals_.popitem(interval0)
                intervals_[left] = right
            elif left_aside:
                # 情况二
                intervals_[keys_[interval0]] += 1
            elif right_aside:
                # 情况三
                right = values_[interval1]
                intervals_.popitem(interval1)
                intervals_[val] = right
            else:
                # 情况五
                intervals_[val] = val

    def getIntervals(self) -> List[List[int]]:
        # 这里实际上返回的是 List[Tuple[int, int]] 类型
        # 但 Python 的类型提示不是强制的，因此也可以通过
        return list(self.intervals.items())
```

```go [sol1-Golang]
type SummaryRanges struct {
    *redblacktree.Tree
}

func Constructor() SummaryRanges {
    return SummaryRanges{redblacktree.NewWithIntComparator()}
}

func (ranges *SummaryRanges) AddNum(val int) {
    // 找到 l0 最大的且满足 l0 <= val 的区间 interval0 = [l0, r0]
    interval0, has0 := ranges.Floor(val)
    if has0 && val <= interval0.Value.(int) {
        // 情况一
        return
    }

    // 找到 l1 最小的且满足 l1 > val 的区间 interval1 = [l1, r1]
    // 在有序集合中，interval1 就是 interval0 的后一个区间
    interval1 := ranges.Iterator()
    if has0 {
        interval1 = ranges.IteratorAt(interval0)
    }
    has1 := interval1.Next()

    leftAside := has0 && interval0.Value.(int)+1 == val
    rightAside := has1 && interval1.Key().(int)-1 == val
    if leftAside && rightAside {
        // 情况四
        interval0.Value = interval1.Value().(int)
        ranges.Remove(interval1.Key())
    } else if leftAside {
        // 情况二
        interval0.Value = val
    } else if rightAside {
        // 情况三
        right := interval1.Value().(int)
        ranges.Remove(interval1.Key())
        ranges.Put(val, right)
    } else {
        // 情况五
        ranges.Put(val, val)
    }
}

func (ranges *SummaryRanges) GetIntervals() [][]int {
    ans := make([][]int, 0, ranges.Size())
    for it := ranges.Iterator(); it.Next(); {
        ans = append(ans, []int{it.Key().(int), it.Value().(int)})
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：
    - $\texttt{void addNum(int val)}$ 的时间复杂度为 $O(\log n)$，即为对有序映射进行常数次添加、删除、修改操作需要的时间。
    
    - $\texttt{int[][] getIntervals()}$ 的时间复杂度为 $O(n)$，即为对有序映射进行一次遍历需要的时间。

- 空间复杂度：$O(n)$。在最坏情况下，数据流中的 $n$ 个元素分别独自形成一个区间，有序映射中包含 $n$ 个键值对。