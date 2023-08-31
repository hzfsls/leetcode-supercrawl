## [2054.两个最好的不重叠活动 中文官方题解](https://leetcode.cn/problems/two-best-non-overlapping-events/solutions/100000/liang-ge-zui-hao-de-bu-zhong-die-huo-don-urq5)

#### 方法一：时间戳排序

**思路与算法**

我们可以将所有活动的左右边界放在一起进行自定义排序。具体地，我们用 $(\textit{ts}, \textit{op}, \textit{val})$ 表示一个「事件」：

- $\textit{op}$ 表示该事件的类型。如果 $\textit{op} = 0$，说明该事件表示一个活动的开始；如果 $\textit{op} = 1$，说明该事件表示一个活动的结束。

- $\textit{ts}$ 表示该事件发生的时间，即活动的开始时间或结束时间。

- $\textit{val}$ 表示该事件的价值，即对应活动的 $\textit{value}$ 值。

我们将所有的时间按照 $\textit{ts}$ 为第一关键字升序排序，这样我们就能按照时间顺序依次处理每一个事件。当 $\textit{ts}$ 相等时，我们按照 $\textit{op}$ 为第二关键字升序排序，这是因为题目中要求了「第一个活动的结束时间不能等于第二个活动的起始时间」，因此当时间相同时，我们先处理开始的事件，再处理结束的事件。

当排序完成后，我们就可以通过对所有的事件进行一次遍历，从而算出最多两个时间不重叠的活动的最大价值：

- 当我们遍历到一个结束事件时，我们用 $\textit{val}$ 来更新 $\textit{bestFirst}$，其中 $\textit{bestFirst}$ 表示当前已经结束的所有活动的最大价值。这样做的意义在于，**所有已经结束的事件都可以当作第一个活动**。

- 当我们遍历到一个开始事件时，我们将该活动当作第二个活动，由于第一个活动的最大价值为 $\textit{bestFirst}$，因此我们用 $\textit{val} + \textit{bestFirst}$ 更新答案即可。

**代码**

```C++ [sol1-C++]
struct Event {
    // 时间戳
    int ts;
    // op = 0 表示左边界，op = 1 表示右边界
    int op;
    int val;
    Event(int _ts, int _op, int _val): ts(_ts), op(_op), val(_val) {}
    bool operator< (const Event& that) const {
        return tie(ts, op) < tie(that.ts, that.op);
    }
};

class Solution {
public:
    int maxTwoEvents(vector<vector<int>>& events) {
        vector<Event> evs;
        for (const auto& event: events) {
            evs.emplace_back(event[0], 0, event[2]);
            evs.emplace_back(event[1], 1, event[2]);
        }
        sort(evs.begin(), evs.end());
        
        int ans = 0, bestFirst = 0;
        for (const auto& [ts, op, val]: evs) {
            if (op == 0) {
                ans = max(ans, val + bestFirst);
            }
            else {
                bestFirst = max(bestFirst, val);
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Event:
    def __init__(self, ts: int, op: int, val: int):
        self.ts = ts
        self.op = op
        self.val = val
    
    def __lt__(self, other: "Event") -> bool:
        return (self.ts, self.op) < (other.ts, other.op)


class Solution:
    def maxTwoEvents(self, events: List[List[int]]) -> int:
        evs = list()
        for event in events:
            evs.append(Event(event[0], 0, event[2]))
            evs.append(Event(event[1], 1, event[2]))
        evs.sort()

        ans = bestFirst = 0
        for ev in evs:
            if ev.op == 0:
                ans = max(ans, ev.val + bestFirst)
            else:
                bestFirst = max(bestFirst, ev.val)
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{events}$ 的长度。

- 空间复杂度：$O(n)$。