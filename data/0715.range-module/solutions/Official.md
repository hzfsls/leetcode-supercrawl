#### 方法一：有序集合 / 有序映射

**思路与算法**

我们可以使用有序集合或者有序映射来实时维护所有的区间。在任意一次 $\text{addRange}$ 或 $\text{removeRange}$ 操作后，我们需要保证有序集合中的区间两两不能合并成一个更大的连续区间。也就是说：如果当前有序集合中有 $k$ 个区间 $[l_1, r_1), [l_2, r_2), \cdots, [l_k, r_k)$，那么需要保证：

$$
l_1 < r_1 < l_2 < r_2 < \cdots < l_k < r_k
$$

成立。这样一来 $\text{queryRange}$ 操作就会变得非常方便：对于 $\text{queryRange(left, right)}$ 而言，我们只需要判断是否存在一个区间 $[l_i, r_i)$，满足 $l_i \leq \textit{left} < \textit{right} \leq r_i$ 即可。

接下来我们详细讲解如何处理 $\text{addRange}$ 或 $\text{removeRange}$ 和操作。对于 $\text{addRange(left, right)}$ 操作，我们首先在有序集合上进行二分，找出最后一个满足 $l_i \leq \textit{left}$ 的区间 $[l_i, r_i)$，那么会有如下的四种情况：

- 如果不存在这样的区间，那么我们可以忽略这一步；

- 如果 $l_i \leq \textit{left} < \textit{right} \leq r_i$，即 $[l_i, r_i)$ 完全包含待添加的区间，那么我们不需要进行任何操作，可以直接返回；

- 如果 $l_i \leq \textit{left} \leq r_i < \textit{right}$，我们需要删除区间 $[l_i, r_i)$，并把 $\textit{left}$ 置为 $l_i$。此时 $[\textit{left}, \textit{right})$ 就表示待添加区间与 $[l_i, r_i)$ 的并集；

- 如果 $l_i < r_i < \textit{left} < \textit{right}$，那么我们也可以忽略这一步。

随后，我们遍历 $[l_i, r_i)$ 之后的区间（如果前面不存在满足要求的 $[l_i, r_i)$，那么就从头开始遍历），这些区间 $[l_j, r_j)$ 都满足 $l_j > \textit{left}$，那么只要 $l_j \leq \textit{right}$，$[l_j, r_j)$ 就可以与 $[\textit{left}, \textit{right})$ 合并成一个更大的连续区间。当遍历到 $l_j > \textit{right}$ 时，根据集合的有序性，之后的所有区间都不会和 $[\textit{left}, \textit{right})$ 有交集，就可以结束遍历。

在遍历完成后，我们还需要将 $[\textit{left}, \textit{right})$ 加入有序集合中。

对于 $\text{removeRange(left, right)}$ 操作，我们的处理方法是类似的，首先在有序集合上进行二分，找出最后一个满足 $l_i \leq \textit{left}$ 的区间 $[l_i, r_i)$，那么会有如下的四种情况：

- 如果不存在这样的区间，那么我们可以忽略这一步；

- 如果满足 $l_i \leq \textit{left} \leq \textit{right} \leq r_i$，即 $[l_i, r_i)$ 完全包含待添加的区间，那么 $l_i \leq \textit{left} \leq \textit{right} \leq r_i$ 的删除会导致 $[l_i, r_i)$ 变成两个短区间：$[l_i, \textit{left})$ 和 $[\textit{right}, r_i)$。如果 $\textit{left} = l_i$，那么第一个区间为空区间；如果 $\textit{right} = r_i$，那么第二个区间为空区间。我们将 $[l_i, r_i)$ 删除后，向有序集合中添加所有的非空区间，即可直接返回；

- 如果 $l_i \leq \textit{left} < r_i < \textit{right}$，我们把区间 $[l_i, r_i)$ 变成 $[l_i, \textit{left})$ 即可。特别地，如果 $\textit{left} = l_i$，我们可以直接把这个区间删除；

- 如果 $l_i < r_i \leq \textit{left} < \textit{right}$，那么我们也可以忽略这一步。

随后，我们遍历 $[l_i, r_i)$ 之后的区间，这些区间 $[l_j, r_j)$ 都满足 $l_j > \textit{left}$，那么只要 $l_j < \textit{right}$，$[l_j, r_j)$ 中的一部分就会被删除。如果 $r_j \leq \textit{right}$，那么 $[l_j, r_j)$ 会被完全删除；如果  $r_j > \textit{right}$，那么 $[l_j, r_j)$ 会剩下 $[\textit{right}, r_j)$，此时之后的所有区间都不会和 $[\textit{left}, \textit{right})$ 有交集，就可以结束遍历。

最后，对于 $\text{queryRange(left, right)}$ 操作，我们同样在有序集合上进行二分，找出最后一个满足 $l_i \leq \textit{left}$ 的区间 $[l_i, r_i)$。如果 $l_i \leq \textit{left} < \textit{right} \leq r_i$，那么返回 $\text{True}$，否则返回 $\text{False}$。


**代码**

```C++ [sol1-C++]
class RangeModule {
public:
    RangeModule() {}
    
    void addRange(int left, int right) {
        auto it = intervals.upper_bound(left);
        if (it != intervals.begin()) {
            auto start = prev(it);
            if (start->second >= right) {
                return;
            }
            if (start->second >= left) {
                left = start->first;
                intervals.erase(start);
            }
        }
        while (it != intervals.end() && it->first <= right) {
            right = max(right, it->second);
            it = intervals.erase(it);
        }
        intervals[left] = right;
    }
    
    bool queryRange(int left, int right) {
        auto it = intervals.upper_bound(left);
        if (it == intervals.begin()) {
            return false;
        }
        it = prev(it);
        return right <= it->second;
    }
    
    void removeRange(int left, int right) {
        auto it = intervals.upper_bound(left);
        if (it != intervals.begin()) {
            auto start = prev(it);
            if (start->second >= right) {
                int ri = start->second;
                if (start->first == left) {
                    intervals.erase(start);
                }
                else {
                    start->second = left;
                }
                if (right != ri) {
                    intervals[right] = ri;
                }
                return;
            }
            else if (start->second > left) {
                if (start->first == left) {
                    intervals.erase(start);
                }
                else {
                    start->second = left;
                }
            }
        }
        while (it != intervals.end() && it->first < right) {
            if (it->second <= right) {
                it = intervals.erase(it);
            }
            else {
                intervals[right] = it->second;
                intervals.erase(it);
                break;
            }
        }
    }

private:
    map<int, int> intervals;
};
```

```Java [sol1-Java]
class RangeModule {
    TreeMap<Integer, Integer> intervals;

    public RangeModule() {
        intervals = new TreeMap<Integer, Integer>();
    }

    public void addRange(int left, int right) {
        Map.Entry<Integer, Integer> entry = intervals.higherEntry(left);
        if (entry != intervals.firstEntry()) {
            Map.Entry<Integer, Integer> start = entry != null ? intervals.lowerEntry(entry.getKey()) : intervals.lastEntry();
            if (start != null && start.getValue() >= right) {
                return;
            }
            if (start != null && start.getValue() >= left) {
                left = start.getKey();
                intervals.remove(start.getKey());
            }
        }
        while (entry != null && entry.getKey() <= right) {
            right = Math.max(right, entry.getValue());
            intervals.remove(entry.getKey());
            entry = intervals.higherEntry(entry.getKey());
        }
        intervals.put(left, right);
    }

    public boolean queryRange(int left, int right) {
        Map.Entry<Integer, Integer> entry = intervals.higherEntry(left);
        if (entry == intervals.firstEntry()) {
            return false;
        }
        entry = entry != null ? intervals.lowerEntry(entry.getKey()) : intervals.lastEntry();
        return entry != null && right <= entry.getValue();
    }

    public void removeRange(int left, int right) {
        Map.Entry<Integer, Integer> entry = intervals.higherEntry(left);
        if (entry != intervals.firstEntry()) {
            Map.Entry<Integer, Integer> start = entry != null ? intervals.lowerEntry(entry.getKey()) : intervals.lastEntry();
            if (start != null && start.getValue() >= right) {
                int ri = start.getValue();
                if (start.getKey() == left) {
                    intervals.remove(start.getKey());
                } else {
                    intervals.put(start.getKey(), left);
                }
                if (right != ri) {
                    intervals.put(right, ri);
                }
                return;
            } else if (start != null && start.getValue() > left) {
                if (start.getKey() == left) {
                    intervals.remove(start.getKey());
                } else {
                    intervals.put(start.getKey(), left);
                }
            }
        }
        while (entry != null && entry.getKey() < right) {
            if (entry.getValue() <= right) {
                intervals.remove(entry.getKey());
                entry = intervals.higherEntry(entry.getKey());
            } else {
                intervals.put(right, entry.getValue());
                intervals.remove(entry.getKey());
                break;
            }
        }
    }
}
```

```Python [sol1-Python3]
from sortedcontainers import SortedDict

class RangeModule:

    def __init__(self):
        self.intervals = SortedDict()

    def addRange(self, left: int, right: int) -> None:
        itvs_ = self.intervals

        x = itvs_.bisect_right(left)
        if x != 0:
            start = x - 1
            if itvs_.values()[start] >= right:
                return
            if itvs_.values()[start] >= left:
                left = itvs_.keys()[start]
                itvs_.popitem(start)
                x -= 1
        
        while x < len(itvs_) and itvs_.keys()[x] <= right:
            right = max(right, itvs_.values()[x])
            itvs_.popitem(x)
        
        itvs_[left] = right

    def queryRange(self, left: int, right: int) -> bool:
        itvs_ = self.intervals

        x = itvs_.bisect_right(left)
        if x == 0:
            return False
        
        return right <= itvs_.values()[x - 1]

    def removeRange(self, left: int, right: int) -> None:
        itvs_ = self.intervals

        x = itvs_.bisect_right(left)
        if x != 0:
            start = x - 1
            if (ri := itvs_.values()[start]) >= right:
                if (li := itvs_.keys()[start]) == left:
                    itvs_.popitem(start)
                else:
                    itvs_[li] = left
                if right != ri:
                    itvs_[right] = ri
                return
            elif ri > left:
                if (li := itvs_.keys()[start]) == left:
                    itvs_.popitem(start)
                    x -= 1
                else:
                    itvs_[itvs_.keys()[start]] = left
                
        while x < len(itvs_) and itvs_.keys()[x] < right:
            if itvs_.values()[x] <= right:
                itvs_.popitem(x)
            else:
                itvs_[right] = itvs_.values()[x]
                itvs_.popitem(x)
                break
```

```go [sol1-Golang]
type RangeModule struct {
    *redblacktree.Tree
}

func Constructor() RangeModule {
    return RangeModule{redblacktree.NewWithIntComparator()}
}

func (t RangeModule) AddRange(left, right int) {
    if node, ok := t.Floor(left); ok {
        r := node.Value.(int)
        if r >= right {
            return
        }
        if r >= left {
            left = node.Key.(int)
            t.Remove(left)
        }
    }
    for node, ok := t.Ceiling(left); ok && node.Key.(int) <= right; node, ok = t.Ceiling(left) {
        right = max(right, node.Value.(int))
        t.Remove(node.Key)
    }
    t.Put(left, right)
}

func (t RangeModule) QueryRange(left, right int) bool {
    node, ok := t.Floor(left)
    return ok && node.Value.(int) >= right
}

func (t RangeModule) RemoveRange(left, right int) {
    if node, ok := t.Floor(left); ok {
        l, r := node.Key.(int), node.Value.(int)
        if r >= right {
            if l == left {
                t.Remove(l)
            } else {
                node.Value = left
            }
            if right != r {
                t.Put(right, r)
            }
            return
        }
        if r > left {
            if l == left {
                t.Remove(l)
            } else {
                node.Value = left
            }
        }
    }
    for node, ok := t.Ceiling(left); ok && node.Key.(int) < right; node, ok = t.Ceiling(left) {
        r := node.Value.(int)
        t.Remove(node.Key)
        if r > right {
            t.Put(right, r)
            break
        }
    }
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：对于操作 $\text{queryRange}$，时间复杂度为 $O(\log(a+r))$，其中 $a$ 是操作 $\text{addRange}$ 的次数，$r$ 是操作 $\text{removeRange}$ 的次数。对于操作 $\text{addRange}$ 和 $\text{removeRange}$，时间复杂度为均摊 $O(\log(a+r))$，这是因为 $\text{addRange}$ 操作最多添加一个区间，$\text{removeRange}$ 最多添加两个区间，每一个添加的区间只会在未来的操作中被移除一次，因此均摊时间复杂度为对有序集合 / 有序映射常数次操作需要的时间，即为 $O(\log(a+r))$。

- 空间复杂度：$O(a+r)$，即为有序集合 / 有序映射需要使用的空间。