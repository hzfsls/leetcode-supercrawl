#### 方法一：模拟

**思路与算法**

一种容易想到的方法是，我们按照时间顺序，依次给每一个时间单位分配任务。

那么如果当前有多种任务不在冷却中，那么我们应该如何挑选执行的任务呢？直觉上，我们应当选择**剩余执行次数最多的那个任务**，将每种任务的剩余执行次数尽可能平均，使得 CPU 处于待命状态的时间尽可能少。当然这也是可以证明的，详细证明见下一个小标题。

因此我们可以用二元组 $(\textit{nextValid}_i, \textit{rest}_i)$ 表示第 $i$ 个任务，其中 $\textit{nextValid}_i$ 表示其因冷却限制，**最早**可以执行的时间；$\textit{rest}_i$ 表示其剩余执行次数。初始时，所有的 $\textit{nextValid}_i$ 均为 $1$，而 $\textit{rest}_i$ 即为任务 $i$ 在数组 $\textit{tasks}$ 中出现的次数。

我们用 $\textit{time}$ 记录当前的时间。根据我们的策略，我们需要选择**不在冷却中**并且**剩余执行次数最多的那个任务**，也就是说，我们需要找到满足 $\textit{nextValid}_i \leq \textit{time}$ 的并且 $\textit{rest}_i$ 最大的索引 $i$。因此我们只需要遍历所有的二元组，即可找到 $i$。在这之后，我们将 $(\textit{nextValid}_i, \textit{rest}_i)$ 更新为 $(\textit{time}+n+1, \textit{rest}_i-1)$，记录任务 $i$ 下一次冷却结束的时间以及剩余执行次数。如果更新后的 $\textit{rest}_i=0$，那么任务 $i$ 全部做完，我们在遍历二元组时也就可以忽略它了。

而对于 $\textit{time}$ 的更新，我们可以选择将其不断增加 $1$，模拟每一个时间片。但这会导致我们在 CPU 处于待命状态时，对二元组进行不必要的遍历。为了减少时间复杂度，我们可以在每一次遍历之前，将 $\textit{time}$ 更新为**所有 $\textit{nextValid}_i$ 中的最小值**，直接「跳过」待命状态，保证每一次对二元组的遍历都是有效的。需要注意的是，只有当这个最小值大于 $\textit{time}$ 时，才需要这样快速更新。

**证明**

对于某个时间点 $t$，设任务 $a$ 和 $b$ 均不在冷却中，并且它们分别剩余 $p$ 和 $q$ 次。不失一般性，假设 $p>q$，那么我们应当在此时选择任务 $a$，但我们选择了任务 $b$。我们需要证明，存在一种交换方法，使得将此时的任务 $b$「变成」任务 $a$ 后，总时间不会增加。

为了叙述方便，设 $a_1, a_2, \cdots, a_p$ 为选择任务 $a$ 的时间点，$b_1, b_2, \cdots, b_q$ 为选择任务 $b$ 的时间点，根据假设有

$$
a_1 > b_1 = t
$$

以及对于任意相邻的两项 $a_i, a_{i+1}$ 或者 $b_j, b_{j+1}$，均有

$$
a_{i+1} - a_i > n
$$

以及

$$
b_{j+1} - b_j > n
$$

接下来我们分情况讨论：

- 如果 $\exists k' \in [2, q]$ 使得 $a_{k'} < b_{k'}$，那么我们找出其中最小的那个 $k'$ 记为 $k$。此时我们有

    $$
    \begin{cases}
    a_1 > b_1 \\
    a_2 > b_2 \\
    \cdots \\
    a_{k-1} > b_{k-1} \\
    a_k < b_k
    \end{cases}
    $$

    那么我们可以构造序列：
    
    - $b_1, b_2, \cdots, b_{k-1}, a_k, a_{k+1}, \cdots, a_p$ 作为交换后选择任务 $a$ 的时间点；
    - $a_1, a_2, \cdots, a_{k-1}, b_k, b_{k+1}, \cdots, b_q$ 作为交换后选择任务 $b$ 的时间点。

    对于交换后任务 $a$ 的序列，其一共有 $p$ 项，并且有

    $$
    a_k - b_{k-1} > a_k - a_{k-1} > n
    $$
    
    因此其满足任意相邻两项之差大于 $n$，不会违反冷却时间的规则。
    
    同理对于对于交换后任务 $b$ 的序列，其一共有 $q$ 项，并且有

    $$
    b_k - a_{k-1} > a_k - a_{k-1} > n
    $$

    同样不会违反冷却时间的规则。

- 如果 $\forall k' \in [2, q]$ 均有 $a_{k'} > b_{k'}$，那么我们只要构造序列：

    - $b_1, b_2, \cdots, b_k$ 作为交换后选择任务 $a$ 的时间点；
    - $a_1, a_2, \cdots, a_k, b_{k+1}, \cdots, b_n$ 作为交换后选择任务 $b$ 的时间点。

    由于 $b_{k+1} - a_k > b_{k+1} - b_k > n$，因此不会违反冷却时间的规则。

无论哪一种情况，我们都将 $b_1=t$ 变成了选择任务 $a$ 的时间点，并且由于我们只在任务 $a$ 和 $b$ 的内部进行交换，因此交换后总时间一定不会增加。这样就证明了一定存在一种总时间最少的方法，是通过不断地选择**不在冷却中**并且**剩余执行次数最多的那个任务**得到的。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int leastInterval(vector<char>& tasks, int n) {
        unordered_map<char, int> freq;
        for (char ch: tasks) {
            ++freq[ch];
        }
        
        // 任务总数
        int m = freq.size();
        vector<int> nextValid, rest;
        for (auto [_, v]: freq) {
            nextValid.push_back(1);
            rest.push_back(v);
        }

        int time = 0;
        for (int i = 0; i < tasks.size(); ++i) {
            ++time;
            int minNextValid = INT_MAX;
            for (int j = 0; j < m; ++j) {
                if (rest[j]) {
                    minNextValid = min(minNextValid, nextValid[j]);
                }
            }
            time = max(time, minNextValid);
            int best = -1;
            for (int j = 0; j < m; ++j) {
                if (rest[j] && nextValid[j] <= time) {
                    if (best == -1 || rest[j] > rest[best]) {
                        best = j;
                    }
                }
            }
            nextValid[best] = time + n + 1;
            --rest[best];
        }

        return time;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int leastInterval(char[] tasks, int n) {
        Map<Character, Integer> freq = new HashMap<Character, Integer>();
        for (char ch : tasks) {
            freq.put(ch, freq.getOrDefault(ch, 0) + 1);
        }
        
        // 任务总数
        int m = freq.size();
        List<Integer> nextValid = new ArrayList<Integer>();
        List<Integer> rest = new ArrayList<Integer>();
        Set<Map.Entry<Character, Integer>> entrySet = freq.entrySet();
        for (Map.Entry<Character, Integer> entry : entrySet) {
            int value = entry.getValue();
            nextValid.add(1);
            rest.add(value);
        }

        int time = 0;
        for (int i = 0; i < tasks.length; ++i) {
            ++time;
            int minNextValid = Integer.MAX_VALUE;
            for (int j = 0; j < m; ++j) {
                if (rest.get(j) != 0) {
                    minNextValid = Math.min(minNextValid, nextValid.get(j));
                }
            }
            time = Math.max(time, minNextValid);
            int best = -1;
            for (int j = 0; j < m; ++j) {
                if (rest.get(j) != 0 && nextValid.get(j) <= time) {
                    if (best == -1 || rest.get(j) > rest.get(best)) {
                        best = j;
                    }
                }
            }
            nextValid.set(best, time + n + 1);
            rest.set(best, rest.get(best) - 1);
        }

        return time;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def leastInterval(self, tasks: List[str], n: int) -> int:
        freq = collections.Counter(tasks)

        # 任务总数
        m = len(freq)
        nextValid = [1] * m
        rest = list(freq.values())

        time = 0
        for i in range(len(tasks)):
            time += 1
            minNextValid = min(nextValid[j] for j in range(m) if rest[j] > 0)
            time = max(time, minNextValid)
            
            best = -1
            for j in range(m):
                if rest[j] and nextValid[j] <= time:
                    if best == -1 or rest[j] > rest[best]:
                        best = j
            
            nextValid[best] = time + n + 1
            rest[best] -= 1

        return time
```

```JavaScript [sol1-JavaScript]
var leastInterval = function(tasks, n) {
    const freq = _.countBy(tasks);

    // 任务总数
    const m = Object.keys(freq).length;
    const nextValid = new Array(m).fill(1);
    const rest = Object.values(freq);

    let time = 0;
    for (let i = 0; i < tasks.length; i++) {
        time++;
        let minNextValid = Number.MAX_VALUE;
        for (let j = 0; j < m; j++) {
            if (rest[j] > 0) {
                minNextValid = Math.min(nextValid[j], minNextValid);
            }
        }
        time = Math.max(time, minNextValid);

        let best = -1;
        for (let j = 0; j < m; j++) {
            if (rest[j] && nextValid[j] <= time) {
                if (best === -1 || rest[j] > rest[best]) {
                    best = j;
                }
            }
        }

        nextValid[best] = time + n + 1;
        rest[best]--;
    }

    return time;
};
```

```Golang [sol1-Golang]
func leastInterval(tasks []byte, n int) (minTime int) {
    cnt := map[byte]int{}
    for _, t := range tasks {
        cnt[t]++
    }

    nextValid := make([]int, 0, len(cnt))
    rest := make([]int, 0, len(cnt))
    for _, c := range cnt {
        nextValid = append(nextValid, 1)
        rest = append(rest, c)
    }

    for range tasks {
        minTime++
        minNextValid := math.MaxInt64
        for i, r := range rest {
            if r > 0 && nextValid[i] < minNextValid {
                minNextValid = nextValid[i]
            }
        }
        if minNextValid > minTime {
            minTime = minNextValid
        }
        best := -1
        for i, r := range rest {
            if r > 0 && nextValid[i] <= minTime && (best == -1 || r > rest[best]) {
                best = i
            }
        }
        nextValid[best] = minTime + n + 1
        rest[best]--
    }
    return
}
```

```C [sol1-C]
int leastInterval(char* tasks, int tasksSize, int n) {
    int freq[26];
    memset(freq, 0, sizeof(freq));
    for (int i = 0; i < tasksSize; ++i) {
        ++freq[tasks[i] - 'A'];
    }

    // 任务总数
    int m = 0;
    int nextValid[26], rest[26];
    for (int i = 0; i < 26; ++i) {
        if (freq[i] > 0) {
            nextValid[m] = 1;
            rest[m++] = freq[i];
        }
    }

    int time = 0;
    for (int i = 0; i < tasksSize; ++i) {
        ++time;
        int minNextValid = INT_MAX;
        for (int j = 0; j < m; ++j) {
            if (rest[j]) {
                minNextValid = fmin(minNextValid, nextValid[j]);
            }
        }
        time = fmax(time, minNextValid);
        int best = -1;
        for (int j = 0; j < m; ++j) {
            if (rest[j] && nextValid[j] <= time) {
                if (best == -1 || rest[j] > rest[best]) {
                    best = j;
                }
            }
        }
        nextValid[best] = time + n + 1;
        --rest[best];
    }

    return time;
}
```

**复杂度分析**

- 时间复杂度：$O(|\textit{tasks}| \cdot |\Sigma|)$，其中 $|\Sigma|$ 是数组 $\textit{task}$ 中出现任务的种类，在本题中任务用大写字母表示，因此 $|\Sigma|$ 不会超过 $26$。在对 $\textit{time}$ 的更新进行优化后，每一次遍历中我们都可以安排一个任务，因此会进行 $|\textit{tasks}|$ 次遍历，每次遍历的时间复杂度为 $O(|\Sigma|)$，相乘即可得到总时间复杂度。

- 空间复杂度：$O(|\Sigma|)$。我们需要使用哈希表统计每种任务出现的次数，以及使用数组 $\textit{nextValid}$ 和 $\textit{test}$ 帮助我们进行遍历得到结果，这些数据结构的空间复杂度均为 $O(|\Sigma|)$。

#### 方法二：构造

**思路与算法**

我们首先考虑所有任务种类中执行次数最多的那一种，记它为 $\texttt{A}$，的执行次数为 $\textit{maxExec}$。

我们使用一个宽为 $n+1$ 的矩阵可视化地展现执行 $\texttt{A}$ 的时间点。其中任务以行优先的顺序执行，没有任务的格子对应 CPU 的待命状态。由于冷却时间为 $n$，因此我们将所有的 $\texttt{A}$ 排布在矩阵的第一列，可以保证满足题目要求，并且容易看出这是可以使得总时间最小的排布方法，对应的总时间为：

$$
(\textit{maxExec} - 1)(n + 1) + 1
$$

同理，如果还有其它也需要执行 $\textit{maxExec}$ 次的任务，我们也需要将它们依次排布成列。例如，当还有任务 $\texttt{B}$ 和 $\texttt{C}$ 时，我们需要将它们排布在矩阵的第二、三列。

![fig1](https://assets.leetcode-cn.com/solution-static/621/1.png)

如果需要执行 $\textit{maxExec}$ 次的任务的数量为 $\textit{maxCount}$，那么类似地可以得到对应的总时间为：

$$
(\textit{maxExec} - 1)(n + 1) + \textit{maxCount}
$$

读者可能会对这个总时间产生疑问：如果 $\textit{maxCount} > n+1$，那么多出的任务会无法排布进矩阵的某一列中，上面计算总时间的方法就不对了。我们把这个疑问放在这里，先「假设」一定有 $\textit{maxCount} \leq n+1$。

处理完执行次数为 $\textit{maxExec}$ 次的任务，剩余任务的执行次数一定都小于 $\textit{maxExec}$，那么我们应当如何将它们放入矩阵中呢？一种构造的方法是，我们从**倒数第二行开始**，按照**反向列优先的顺序（即先放入靠左侧的列，同一列中先放入下方的行）**，依次放入每一种任务，并且同一种任务需要连续地填入。例如还有任务 $\texttt{D}$，$\texttt{E}$ 和 $\texttt{F}$ 时，我们会按照下图的方式依次放入这些任务。

![fig2](https://assets.leetcode-cn.com/solution-static/621/2.png)

对于任意一种任务而言，一定不会被放入同一行两次（否则说明该任务的执行次数大于等于 $\textit{maxExec}$），并且由于我们是按照列优先的顺序放入这些任务，因此任意两个相邻的任务之间要么间隔 $n$（例如上图中位于同一列的相同任务），要么间隔 $n+1$（例如上图中第一列和第二列的 $\texttt{F}$），都是满足题目要求的。因此如果我们按照这样的方法填入所有的任务，那么就可以保证总时间不变，仍然为：

$$
(\textit{maxExec} - 1)(n + 1) + \textit{maxCount}
$$

当然，这些都建立在我们的「假设」之上，即我们不会填「超出」$n+1$ 列。但读者可以想一想，如果我们真的填「超出」了 $n+1$ 列，会发生什么呢？

![fig3](https://assets.leetcode-cn.com/solution-static/621/3.png)

上图给出了一个例子，此时 $n+1=5$ 但我们填了 $7$ 列。标记为 $\texttt{X}$ 的格子表示 CPU 的待命状态。看上去我们需要 $(5-1) \times 7 + 4 = 32$ 的时间来执行所有任务，但实际上**如果我们填「超出」了 $n+1$ 列，那么所有的 CPU 待命状态都是可以省去的**。这是因为 **CPU 待命状态本身只是为了规定任意两个相邻任务的执行间隔至少为 $n$**，但如果列数超过了 $n+1$，那么就算没有这些待命状态，任意两个相邻任务的执行间隔肯定也会至少为 $n$。此时，总执行时间就是任务的总数 $|\textit{task}|$。

同时我们可以发现：

- 如果我们没有填「超出」了 $n+1$ 列，那么图中存在 $0$ 个或多个位置没有放入任务，由于位置数量为 $(\textit{maxExec} - 1)(n + 1) + \textit{maxCount}$，因此有：

    $$
    |\textit{task}| < (\textit{maxExec} - 1)(n + 1) + \textit{maxCount}
    $$

- 如果我们填「超出」了 $n+1$ 列，那么同理有：

    $$
    |\textit{task}| > (\textit{maxExec} - 1)(n + 1) + \textit{maxCount}
    $$

因此，在任意的情况下，需要的最少时间就是 $(\textit{maxExec} - 1)(n + 1) + \textit{maxCount}$ 和 $|\textit{task}|$ 中的较大值。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int leastInterval(vector<char>& tasks, int n) {
        unordered_map<char, int> freq;
        for (char ch: tasks) {
            ++freq[ch];
        }

        // 最多的执行次数
        int maxExec = max_element(freq.begin(), freq.end(), [](const auto& u, const auto& v) {
            return u.second < v.second;
        })->second;
        // 具有最多执行次数的任务数量
        int maxCount = accumulate(freq.begin(), freq.end(), 0, [=](int acc, const auto& u) {
            return acc + (u.second == maxExec);
        });

        return max((maxExec - 1) * (n + 1) + maxCount, static_cast<int>(tasks.size()));
    }
};
```

```Java [sol2-Java]
class Solution {
    public int leastInterval(char[] tasks, int n) {
        Map<Character, Integer> freq = new HashMap<Character, Integer>();
        // 最多的执行次数
        int maxExec = 0;
        for (char ch : tasks) {
            int exec = freq.getOrDefault(ch, 0) + 1;
            freq.put(ch, exec);
            maxExec = Math.max(maxExec, exec);
        }

        // 具有最多执行次数的任务数量
        int maxCount = 0;
        Set<Map.Entry<Character, Integer>> entrySet = freq.entrySet();
        for (Map.Entry<Character, Integer> entry : entrySet) {
            int value = entry.getValue();
            if (value == maxExec) {
                ++maxCount;
            }
        }

        return Math.max((maxExec - 1) * (n + 1) + maxCount, tasks.length);
    }
}
```

```Python [sol2-Python3]
class Solution:
    def leastInterval(self, tasks: List[str], n: int) -> int:
        freq = collections.Counter(tasks)

        # 最多的执行次数
        maxExec = max(freq.values())
        # 具有最多执行次数的任务数量
        maxCount = sum(1 for v in freq.values() if v == maxExec)

        return max((maxExec - 1) * (n + 1) + maxCount, len(tasks))
```

```JavaScript [sol2-JavaScript]
var leastInterval = function(tasks, n) {
    const freq = _.countBy(tasks);

    // 最多的执行次数
    const maxExec = Math.max(...Object.values(freq));
    // 具有最多执行次数的任务数量
    let maxCount = 0;
    Object.values(freq).forEach(v => {
        if (v === maxExec) {
            maxCount++;
        }
    })

    return Math.max((maxExec - 1) * (n + 1) + maxCount, tasks.length);
};
```

```Golang [sol2-Golang]
func leastInterval(tasks []byte, n int) int {
    cnt := map[byte]int{}
    for _, t := range tasks {
        cnt[t]++
    }

    maxExec, maxExecCnt := 0, 0
    for _, c := range cnt {
        if c > maxExec {
            maxExec, maxExecCnt = c, 1
        } else if c == maxExec {
            maxExecCnt++
        }
    }

    if time := (maxExec-1)*(n+1) + maxExecCnt; time > len(tasks) {
        return time
    }
    return len(tasks)
}
```

```C [sol2-C]
int leastInterval(char* tasks, int tasksSize, int n) {
    int freq[26];
    memset(freq, 0, sizeof(freq));
    for (int i = 0; i < tasksSize; ++i) {
        ++freq[tasks[i] - 'A'];
    }

    // 最多的执行次数
    int maxExec = 0;
    for (int i = 0; i < 26; i++) {
        maxExec = fmax(maxExec, freq[i]);
    }
    // 具有最多执行次数的任务数量
    int maxCount = 0;
    for (int i = 0; i < 26; i++) {
        if (maxExec == freq[i]) {
            maxCount++;
        }
    }

    return fmax((maxExec - 1) * (n + 1) + maxCount, tasksSize);
}
```

**复杂度分析**

- 时间复杂度：$O(|\textit{task}| + |\Sigma|)$，其中 $|\Sigma|$ 是数组 $\textit{task}$ 中出现任务的种类，在本题中任务用大写字母表示，因此 $|\Sigma|$ 不会超过 $26$。

- 空间复杂度：$O(|\Sigma|)$。