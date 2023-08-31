## [1626.无矛盾的最佳球队 中文官方题解](https://leetcode.cn/problems/best-team-with-no-conflicts/solutions/100000/wu-mao-dun-de-zui-jia-qiu-dui-by-leetcod-2lxf)
#### 方法一：动态规划

**思路与算法**

题目给出 $n$ 名球员的分数和年龄数组 $\textit{scores}$ 和 $\textit{ages}$，其中 $\textit{scores}[i]$ 和 $\textit{ages}[i]$ 分别为球员 $i$ 的分数和年龄。当一名年龄较小球员的分数严格大于一名年龄较大的球员，则存在矛盾。同龄球员之间不会发生矛盾。球队的得分是球队中所有球员分数的总和，现在我们需要求所有可能的无矛盾的球队的最高分数。

首先我们将所有队员按照分数升序进行排序，分数相同时，则按照年龄升序进行排序，我们用数组 $\textit{people}[n][2]$ 来表示排序后的 $n$ 名球员信息，其中 $\textit{people}[i][0]$，$\textit{people}[i][1]$ 分别为排序后第 $i$ 名球员的分数和年龄。然后我们可以用动态规划来解决该问题，设 $\textit{dp}[i]$ 为我们最后组建的球队中的最大球员序号为排序后的第 $i$ 名球员时的球队最大分数（此时的球员序号为排序后的新序号），因为我们是按照分数升序排序的，所以最后组建球队的最后一名球员的分数一定不会小于队伍中该球员前面一名球员的分数，所以为了避免矛盾的产生我们只需要让最后组建球队的最后一名球员的年龄不小于该球员前面一名球员的年龄即可，那么转移的方程如下：

$$\textit{dp}[i] = \max\{\textit{dp}[j]\} + \textit{people}[i][0], j < i \And \textit{people}[j][1] \le \textit{people}[i][1] \tag{1}$$

上文讨论的是建立在 $i > 0$ 的前提上的，我们还需要考虑动态规划的边界条件，当 $i = 0$ 时，只有一名球员 $\textit{people}[0]$，此时该球员单独组成一只队伍有： $\textit{dp}[0] = \textit{people}[0][0]$。最后我们返回 $\max\{dp[i], 0 \le i < n\}$ 即为所有可能的无矛盾的球队的最高分数。

**代码**

```Python [sol1-Python3]
class Solution:
    def bestTeamScore(self, scores: List[int], ages: List[int]) -> int:
        people = sorted(zip(scores, ages))
        dp = [0] * len(scores)
        ans = 0
        for i in range(len(scores)):
            for j in range(i):
                if people[i][1] >= people[j][1]:
                    dp[i] = max(dp[i], dp[j])
            dp[i] += people[i][0]
            ans = max(ans, dp[i])
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int bestTeamScore(vector<int>& scores, vector<int>& ages) {
        int n = scores.size();
        vector<pair<int, int>> people;
        for (int i = 0; i < n; ++i) {
            people.push_back({scores[i], ages[i]});
        }
        sort(people.begin(), people.end());
        vector<int> dp(n, 0);
        int res = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i - 1; j >= 0; --j) {
                if (people[j].second <= people[i].second) {
                    dp[i] = max(dp[i], dp[j]);
                }
            }
            dp[i] += people[i].first;
            res = max(res, dp[i]);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int bestTeamScore(int[] scores, int[] ages) {
        int n = scores.length;
        int[][] people = new int[n][2];
        for (int i = 0; i < n; ++i) {
            people[i] = new int[]{scores[i], ages[i]};
        }
        Arrays.sort(people, (a, b) -> a[0] != b[0] ? a[0] - b[0] : a[1] - b[1]);
        int[] dp = new int[n];
        int res = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i - 1; j >= 0; --j) {
                if (people[j][1] <= people[i][1]) {
                    dp[i] = Math.max(dp[i], dp[j]);
                }
            }
            dp[i] += people[i][0];
            res = Math.max(res, dp[i]);
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int BestTeamScore(int[] scores, int[] ages) {
        int n = scores.Length;
        int[][] people = new int[n][];
        for (int i = 0; i < n; ++i) {
            people[i] = new int[]{scores[i], ages[i]};
        }
        Array.Sort(people, (a, b) => a[0] != b[0] ? a[0] - b[0] : a[1] - b[1]);
        int[] dp = new int[n];
        int res = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i - 1; j >= 0; --j) {
                if (people[j][1] <= people[i][1]) {
                    dp[i] = Math.Max(dp[i], dp[j]);
                }
            }
            dp[i] += people[i][0];
            res = Math.Max(res, dp[i]);
        }
        return res;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

static int cmp(const void *pa, const void *pb) {
    if (((int *)pa)[0] == ((int *)pb)[0]) {
        return ((int *)pa)[1] - ((int *)pb)[1];
    }
    return ((int *)pa)[0] - ((int *)pb)[0];
}

int bestTeamScore(int* scores, int scoresSize, int* ages, int agesSize) {
    int n = scoresSize;
    int people[n][2];
    for (int i = 0; i < n; ++i) {
        people[i][0] = scores[i];
        people[i][1] = ages[i];
    }
    qsort(people, n, sizeof(people[0]), cmp);
    int dp[n];
    int res = 0;
    memset(dp, 0, sizeof(dp));
    for (int i = 0; i < n; ++i) {
        for (int j = i - 1; j >= 0; --j) {
            if (people[j][1] <= people[i][1]) {
                dp[i] = MAX(dp[i], dp[j]);
            }
        }
        dp[i] += people[i][0];
        res = MAX(res, dp[i]);
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var bestTeamScore = function(scores, ages) {
    const n = scores.length;
    const people = new Array(n).fill(0).map(() => new Array(2).fill(0));
    for (let i = 0; i < n; ++i) {
        people[i] = [scores[i], ages[i]];
    }
    people.sort((a, b) => a[0] !== b[0] ? a[0] - b[0] : a[1] - b[1]);
    const dp = new Array(n).fill(0);
    let res = 0;
    for (let i = 0; i < n; ++i) {
        for (let j = i - 1; j >= 0; --j) {
            if (people[j][1] <= people[i][1]) {
                dp[i] = Math.max(dp[i], dp[j]);
            }
        }
        dp[i] += people[i][0];
        res = Math.max(res, dp[i]);
    }
    return res;
};
```

```go [sol1-Golang]
func bestTeamScore(scores []int, ages []int) int {
    n := len(scores)
    people := make([][]int, n)
    for i := range scores {
        people[i] = []int{scores[i], ages[i]}
    }
    sort.Slice(people, func(i, j int) bool {
        if people[i][0] < people[j][0] {
            return true
        } else if people[i][0] > people[j][0] {
            return false
        }
        return people[i][1] < people[j][1]
    })
    dp := make([]int, n)
    res := 0
    for i := 0; i < n; i++ {
        for j := 0; j < i; j++ {
            if people[j][1] <= people[i][1] {
                dp[i] = max(dp[i], dp[j])
            }
        }
        dp[i] += people[i][0]
        res = max(res, dp[i])
    }
    return res
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为数组 $\textit{scores}$ 和 $\textit{ages}$ 的长度，其中排序的时间复杂度为 $O(n \times \log n)$，求解每一个状态的复杂度为 $O(n)$，共有 $n$ 个状态需要求解，所以求解动态规划的总时间复杂度为 $O(n^2)$。
- 空间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{scores}$ 和 $\textit{ages}$ 的长度。空间复杂度主要取决于动态规划模型中状态的总数。

#### 方法二：动态规划【树状数组优化】

**思路与算法**

对于上述动态规划的过程我们也可以用「树状数组」或者「线段树」来进行优化（有关「树状数组」和「线段树」的相关知识可以见 [题解「树状数组」和「线段树」方法](https://leetcode.cn/problems/range-sum-query-mutable/solutions/1389182/qu-yu-he-jian-suo-shu-zu-ke-xiu-gai-by-l-76xj/)），因为两者优化的思想类似，所以本文中用「树状数组」来进行说明。

在求解过程中以每一个球员为最后组建球队的最后一名球员，我们此时用「树状数组」来维护以该球员的年龄的最大队伍分数。通过方法一种动态规划的转移方程我们可以看到对于某一个状态 $\textit{dp}[i]$ 的求解我们只需要知道当前「树状数组」中以年龄区间为 $[0, \textit{people}[i][1]]$ 结尾的组建队伍的最大分数即可。通过「树状数组」我们可以在 $O(\log n)$ 的时间复杂度中完成该问题的查询和更新信息，这样对于求解每一个状态的时间复杂度就从 $O(n)$ 降到了 $O(\log n)$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int max_age;
    vector<int> t;
    vector<pair<int, int>> people;
    int lowbit(int x) {
        return x & (-x);
    }

    void update(int i, int val) {
        for (; i <= max_age; i += lowbit(i)) {
            t[i] = max(t[i], val);
        }
    }

    int query(int i) {
        int ret = 0;
        for (; i > 0; i -= lowbit(i)) {
            ret = max(ret, t[i]);
        }
        return ret;
    }

    int bestTeamScore(vector<int>& scores, vector<int>& ages) {
        max_age = *max_element(ages.begin(), ages.end());
        t = vector<int>(max_age + 1, 0);
        int res = 0;
        for (int i = 0; i < scores.size(); ++i) {
            people.push_back({scores[i], ages[i]});
        }
        sort(people.begin(), people.end());

        for (int i = 0; i < people.size(); ++i) {
            int score = people[i].first, age = people[i].second, cur = score + query(age);
            update(age, cur);
            res = max(res, cur);
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    int maxAge;
    int[] t;
    int[][] people;

    public int bestTeamScore(int[] scores, int[] ages) {
        maxAge = Arrays.stream(ages).max().getAsInt();
        t = new int[maxAge + 1];
        int res = 0;
        int n = scores.length;
        people = new int[n][2];
        for (int i = 0; i < n; ++i) {
            people[i] = new int[]{scores[i], ages[i]};
        }
        Arrays.sort(people, (a, b) -> a[0] != b[0] ? a[0] - b[0] : a[1] - b[1]);

        for (int i = 0; i < n; ++i) {
            int score = people[i][0], age = people[i][1], cur = score + query(age);
            update(age, cur);
            res = Math.max(res, cur);
        }
        return res;
    }

    public int lowbit(int x) {
        return x & (-x);
    }

    public void update(int i, int val) {
        for (; i <= maxAge; i += lowbit(i)) {
            t[i] = Math.max(t[i], val);
        }
    }

    public int query(int i) {
        int ret = 0;
        for (; i > 0; i -= lowbit(i)) {
            ret = Math.max(ret, t[i]);
        }
        return ret;
    }
}
```

```C# [sol2-C#]
public class Solution {
    int maxAge;
    int[] t;
    int[][] people;

    public int BestTeamScore(int[] scores, int[] ages) {
        maxAge = ages.Max();
        t = new int[maxAge + 1];
        int res = 0;
        int n = scores.Length;
        people = new int[n][];
        for (int i = 0; i < n; ++i) {
            people[i] = new int[]{scores[i], ages[i]};
        }
        Array.Sort(people, (a, b) => a[0] != b[0] ? a[0] - b[0] : a[1] - b[1]);

        for (int i = 0; i < n; ++i) {
            int score = people[i][0], age = people[i][1], cur = score + Query(age);
            Update(age, cur);
            res = Math.Max(res, cur);
        }
        return res;
    }

    public int lowbit(int x) {
        return x & (-x);
    }

    public void Update(int i, int val) {
        for (; i <= maxAge; i += lowbit(i)) {
            t[i] = Math.Max(t[i], val);
        }
    }

    public int Query(int i) {
        int ret = 0;
        for (; i > 0; i -= lowbit(i)) {
            ret = Math.Max(ret, t[i]);
        }
        return ret;
    }
}
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

static int cmp(const void *pa, const void *pb) {
    if (((int *)pa)[0] == ((int *)pb)[0]) {
        return ((int *)pa)[1] - ((int *)pb)[1];
    }
    return ((int *)pa)[0] - ((int *)pb)[0];
}

int lowbit(int x) {
    return x & (-x);
}

void update(int i, int val, int *t, int max_age) {
    for (; i <= max_age; i += lowbit(i)) {
        t[i] = MAX(t[i], val);
    }
}

int query(int i, const int *t) {
    int ret = 0;
    for (; i > 0; i -= lowbit(i)) {
        ret = MAX(ret, t[i]);
    }
    return ret;
}

int bestTeamScore(int* scores, int scoresSize, int* ages, int agesSize) {
    int max_age = 0;
    for (int i = 0; i < agesSize; i++) {
        max_age = MAX(max_age, ages[i]);
    }
    int t[max_age + 1];
    memset(t, 0, sizeof(t));
    int res = 0;
    int people[scoresSize][2];
    int peopleSize = scoresSize;
    for (int i = 0; i < scoresSize; ++i) {
        people[i][0] = scores[i];
        people[i][1] = ages[i];
    }
    qsort(people, peopleSize, sizeof(people[0]), cmp);
    for (int i = 0; i < peopleSize; ++i) {
        int score = people[i][0], age = people[i][1], cur = score + query(age, t);
        update(age, cur, t, max_age);
        res = MAX(res, cur);
    }
    return res;
}
```

```JavaScript [sol2-JavaScript]
var bestTeamScore = function(scores, ages) {
    const maxAge = _.max(ages);
    const t = new Array(maxAge + 1).fill(0);
    let res = 0;
    const n = scores.length;
    const people = new Array(n).fill(0).map(() => new Array(2).fill(0));
    for (let i = 0; i < n; ++i) {
        people[i] = [scores[i], ages[i]];
    }
    people.sort((a, b) => a[0] !== b[0] ? a[0] - b[0] : a[1] - b[1]);

    const lowbit = (x) => {
        return x & (-x);
    }

    const update = (i, val) => {
        for (; i <= maxAge; i += lowbit(i)) {
            t[i] = Math.max(t[i], val);
        }
    }

    const query = (i) => {
        let ret = 0;
        for (; i > 0; i -= lowbit(i)) {
            ret = Math.max(ret, t[i]);
        }
        return ret;
    };

    for (let i = 0; i < n; ++i) {
        const score = people[i][0], age = people[i][1], cur = score + query(age);
        update(age, cur);
        res = Math.max(res, cur);
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n \times \log n + n \times \log m)$，其中 $n$ 为数组 $\textit{scores}$ 和 $\textit{ages}$ 的长度，$m$ 为最大年龄，其中排序的时间复杂度为 $O(n \times \log n)$，优化后用「树状数组」来求解每一个状态的复杂度为 $O(\log m)$，共有 $n$ 个状态需要求解，所以求解动态规划的总时间复杂度为 $O(n \times \log n + n \times \log m)$。
- 空间复杂度：$O(m)$，其中 $m$ 为最大年龄。空间复杂度主要取决于「树状数组」的大小。