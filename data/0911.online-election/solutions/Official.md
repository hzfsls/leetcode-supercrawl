## [911.在线选举 中文官方题解](https://leetcode.cn/problems/online-election/solutions/100000/zai-xian-xuan-ju-by-leetcode-solution-4835)
#### 方法一：预计算 + 二分查找

**思路及解法**

记 $\textit{persons}$ 的长度为 $N$。我们对输入进行预计算，用一个长度为 $N$ 的数组 $\textit{tops}$ 记录各时间段得票领先的候选人。具体来说，$\textit{tops}[i]$ 表示

$$
\begin{cases} 
\textit{times}[i] \leq t < \textit{times}[i+1], &0 \leq i < N-1\\
t \ge \textit{times}[i], &i = N-1
\end{cases}
$$

的时间段中领先的候选人。这样的预计算可以通过对 $\textit{persons}$ 在 $\textit{times}$ 上的计数完成。具体实现方法是，我们用一个哈希表 $\textit{voteCounts}$ 记录不同候选人的得票数，用一个变量 $\textit{top}$ 表示当前领先的候选人。按时间从小到大遍历 $\textit{persons}$ 和 $\textit{times}$，并更新 $\textit{voteCounts}$ 和 $\textit{top}$，把 $\textit{top}$ 放入 $\textit{tops}$。遍历结束后，我们可以得到一个长度为 $N$ 的 $\textit{tops}$，表示各个时间段得票领先的候选人。

每次查询时，我们在 $\textit{times}$ 中找出不大于 $t$ 且离 $t$ 最近的元素的下标，这步操作可以通过二分查找完成。到 $\textit{tops}$ 索引相同的下标即可返回结果。

**代码**

```Python [sol1-Python3]
class TopVotedCandidate:

    def __init__(self, persons: List[int], times: List[int]):
        tops = []
        voteCounts = defaultdict(int)
        voteCounts[-1] = -1
        top = -1
        for p in persons:
            voteCounts[p] += 1
            if voteCounts[p] >= voteCounts[top]:
                top = p
            tops.append(top)
        self.tops = tops
        self.times = times
        
    def q(self, t: int) -> int:
        l, r = 0, len(self.times) - 1
        # 找到满足 times[l] <= t 的最大的 l
        while l < r:
            m = l + (r - l + 1) // 2
            if self.times[m] <= t:
                l = m
            else:
                r = m - 1
        # 也可以使用内置的二分查找的包来确定 l
        # l = bisect.bisect(self.times, t) - 1
        return self.tops[l]
```

```Java [sol1-Java]
class TopVotedCandidate {
    List<Integer> tops;
    Map<Integer, Integer> voteCounts;
    int[] times;

    public TopVotedCandidate(int[] persons, int[] times) {
        tops = new ArrayList<Integer>();
        voteCounts = new HashMap<Integer, Integer>();
        voteCounts.put(-1, -1);
        int top = -1;
        for (int i = 0; i < persons.length; ++i) {
            int p = persons[i];
            voteCounts.put(p, voteCounts.getOrDefault(p, 0) + 1);
            if (voteCounts.get(p) >= voteCounts.get(top)) {
                top = p;
            }
            tops.add(top);
        }
        this.times = times;
    }
    
    public int q(int t) {
        int l = 0, r = times.length - 1;
        // 找到满足 times[l] <= t 的最大的 l
        while (l < r) {
            int m = l + (r - l + 1) / 2;
            if (times[m] <= t) {
                l = m;
            } else {
                r = m - 1;
            }
        }
        return tops.get(l);
    }
}
```

```C# [sol1-C#]
public class TopVotedCandidate {
    IList<int> tops;
    Dictionary<int, int> voteCounts;
    int[] times;

    public TopVotedCandidate(int[] persons, int[] times) {
        tops = new List<int>();
        voteCounts = new Dictionary<int, int>();
        voteCounts.Add(-1, -1);
        int top = -1;
        for (int i = 0; i < persons.Length; ++i) {
            int p = persons[i];
            if (!voteCounts.ContainsKey(p)) {
                voteCounts.Add(p, 0);
            } else {
                ++voteCounts[p];
            }
            if (voteCounts[p] >= voteCounts[top]) {
                top = p;
            }
            tops.Add(top);
        }
        this.times = times;
    }
    
    public int Q(int t) {
        int l = 0, r = times.Length - 1;
        // 找到满足 times[l] <= t 的最大的 l
        while (l < r) {
            int m = l + (r - l + 1) / 2;
            if (times[m] <= t) {
                l = m;
            } else {
                r = m - 1;
            }
        }
        return tops[l];
    }
}
```

```C++ [sol1-C++]
class TopVotedCandidate {
public:
    vector<int> tops;
    vector<int> times;

    TopVotedCandidate(vector<int>& persons, vector<int>& times) {
        unordered_map<int, int> voteCounts;
        voteCounts[-1] = -1;
        int top = -1;
        for (auto & p : persons) {
            voteCounts[p]++;
            if (voteCounts[p] >= voteCounts[top]) {
                top = p;
            }
            tops.emplace_back(top);
        }
        this->times = times;
    }
    
    int q(int t) {
        int pos = upper_bound(times.begin(), times.end(), t) - times.begin() - 1;
        return tops[pos];
    }
};
```

```go [sol1-Golang]
type TopVotedCandidate struct {
    tops, times []int
}

func Constructor(persons, times []int) TopVotedCandidate {
    tops := []int{}
    top := -1
    voteCounts := map[int]int{-1: -1}
    for _, p := range persons {
        voteCounts[p]++
        if voteCounts[p] >= voteCounts[top] {
            top = p
        }
        tops = append(tops, top)
    }
    return TopVotedCandidate{tops, times}
}

func (c *TopVotedCandidate) Q(t int) int {
    return c.tops[sort.SearchInts(c.times, t+1)-1]
}
```

```JavaScript [sol1-JavaScript]
var TopVotedCandidate = function(persons, times) {
    this.tops = [];
    this.voteCounts = new Map();
    this.voteCounts.set(-1, -1);
    this.times = times;
    let top = -1;
    for (let i = 0; i < persons.length; ++i) {
        const p = persons[i];
        if (!this.voteCounts.has(p)) {
            this.voteCounts.set(p, 0);
        } else {
            this.voteCounts.set(p, this.voteCounts.get(p) + 1);
        }
        if (this.voteCounts.get(p) >= this.voteCounts.get(top)) {
            top = p;
        }
        this.tops.push(top);
    }
};

TopVotedCandidate.prototype.q = function(t) {
    let l = 0, r = this.times.length - 1;
    // 找到满足 times[l] <= t 的最大的 l
    while (l < r) {
        const m = l + Math.floor((r - l + 1) / 2);
        if (this.times[m] <= t) {
            l = m;
        } else {
            r = m - 1;
        }
    }

    return this.tops[l];
};
```

```C [sol1-C]
typedef struct {
    int * tops;
    int * times;
    int timesSize;
} TopVotedCandidate;


TopVotedCandidate* topVotedCandidateCreate(int* persons, int personsSize, int* times, int timesSize) {
    if (NULL == persons || NULL == times || persons <= 0 || timesSize <= 0) {
        return NULL;
    }

    TopVotedCandidate * obj = (TopVotedCandidate *)malloc(sizeof(TopVotedCandidate));
    int * voteCounts = (int *)malloc(sizeof(int) * personsSize); 
    memset(voteCounts, 0 ,sizeof(int) * personsSize);
    obj->timesSize = timesSize;
    obj->tops = (int *)malloc(sizeof(int) * personsSize);
    obj->times = (int *)malloc(sizeof(int) * timesSize);
    int top = -1;
    for (int i = 0; i < personsSize; ++i) {
        voteCounts[persons[i]]++;
        if (top < 0 || voteCounts[persons[i]] >= voteCounts[top]) {
            top = persons[i];
        }
        obj->tops[i] = top;
    }
    for (int i = 0; i < timesSize; ++i) {
        obj->times[i] = times[i];
    }
    free(voteCounts);
    return obj;
}

int topVotedCandidateQ(TopVotedCandidate* obj, int t) {
    if (NULL == obj) {
        return -1;
    }
    int l = 0, r = obj->timesSize - 1;
    while (l < r) {
        int m = l + (r - l + 1) / 2;
        if (obj->times[m] <= t) {
            l = m;
        } else {
            r = m - 1;
        }
    }
    return obj->tops[l];
}

void topVotedCandidateFree(TopVotedCandidate* obj) {
    if (NULL == obj) {
        return;
    }
    free(obj->tops);
    free(obj->times);
    free(obj);
}
```

**复杂度分析**

- 时间复杂度：预处理的时间复杂度为 $O(N)$，其中 $N$ 为 $\textit{persons}$ 的长度。单次查询的时间复杂度为 $O(\log N)$。

- 空间复杂度：$O(N)$。