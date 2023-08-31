## [636.函数的独占时间 中文官方题解](https://leetcode.cn/problems/exclusive-time-of-functions/solutions/100000/han-shu-de-du-zhan-shi-jian-by-leetcode-d54e2)
#### 方法一：栈

**思路与算法**

我们可以用**栈**来模拟函数调用的过程，栈顶的元素为当前正在执行函数：

- 当函数调用开始时，如果当前有函数正在运行，则当前正在运行函数应当停止，此时计算其的执行时间，然后将调用函数入栈。
- 当函数调用结束时，将栈顶元素弹出，并计算相应的执行时间，如果此时栈顶有被暂停的函数，则开始运行该函数。

由于每一个函数都有一个对应的 $\textit{start}$ 和 $\textit{end}$ 日志，且当遇到一个 $end$ 日志时，栈顶元素一定为其对应的 $\textit{start}$ 日志。那么我们对于每一个函数记录它的函数标识符和上次开始运行的时间戳，此时我们只需要在每次函数暂停运行的时候来计算执行时间和开始运行的时候更新时间戳即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def exclusiveTime(self, n: int, logs: List[str]) -> List[int]:
        ans = [0] * n
        st = []
        for log in logs:
            idx, tp, timestamp = log.split(':')
            idx, timestamp = int(idx), int(timestamp)
            if tp[0] == 's':
                if st:
                    ans[st[-1][0]] += timestamp - st[-1][1]
                    st[-1][1] = timestamp
                st.append([idx, timestamp])
            else:
                i, t = st.pop()
                ans[i] += timestamp - t + 1
                if st:
                    st[-1][1] = timestamp + 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> exclusiveTime(int n, vector<string>& logs) {
        stack<pair<int, int>> st; // {idx, 开始运行的时间}
        vector<int> res(n, 0);
        for (auto& log : logs) {
            char type[10];
            int idx, timestamp;
            sscanf(log.c_str(), "%d:%[^:]:%d", &idx, type, &timestamp);
            if (type[0] == 's') {
                if (!st.empty()) {
                    res[st.top().first] += timestamp - st.top().second;
                    st.top().second = timestamp;
                }
                st.emplace(idx, timestamp);
            } else {
                auto t = st.top();
                st.pop();
                res[t.first] += timestamp - t.second + 1;
                if (!st.empty()) {
                    st.top().second = timestamp + 1;
                }
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] exclusiveTime(int n, List<String> logs) {
        Deque<int[]> stack = new ArrayDeque<int[]>(); // {idx, 开始运行的时间}
        int[] res = new int[n];
        for (String log : logs) {
            int idx = Integer.parseInt(log.substring(0, log.indexOf(':')));
            String type = log.substring(log.indexOf(':') + 1, log.lastIndexOf(':'));
            int timestamp = Integer.parseInt(log.substring(log.lastIndexOf(':') + 1));
            if ("start".equals(type)) {
                if (!stack.isEmpty()) {
                    res[stack.peek()[0]] += timestamp - stack.peek()[1];
                    stack.peek()[1] = timestamp;
                }
                stack.push(new int[]{idx, timestamp});
            } else {
                int[] t = stack.pop();
                res[t[0]] += timestamp - t[1] + 1;
                if (!stack.isEmpty()) {
                    stack.peek()[1] = timestamp + 1;
                }
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] ExclusiveTime(int n, IList<string> logs) {
        Stack<int[]> stack = new Stack<int[]>(); // {idx, 开始运行的时间}
        int[] res = new int[n];
        foreach (string log in logs) {
            int idx = int.Parse(log.Substring(0, log.IndexOf(':')));
            string type = log.Substring(log.IndexOf(':') + 1, log.LastIndexOf(':') - log.IndexOf(':') - 1);
            int timestamp = int.Parse(log.Substring(log.LastIndexOf(':') + 1));
            if ("start".Equals(type)) {
                if (stack.Count > 0) {
                    res[stack.Peek()[0]] += timestamp - stack.Peek()[1];
                    stack.Peek()[1] = timestamp;
                }
                stack.Push(new int[]{idx, timestamp});
            } else {
                int[] t = stack.Pop();
                res[t[0]] += timestamp - t[1] + 1;
                if (stack.Count > 0) {
                    stack.Peek()[1] = timestamp + 1;
                }
            }
        }
        return res;
    }
}
```

```C [sol1-C]
typedef struct {
    int idx;
    int timestamp;
} Pair;

int* exclusiveTime(int n, char ** logs, int logsSize, int* returnSize) {
    Pair *stack = (Pair *)malloc(sizeof(Pair)* logsSize); // {idx, 开始运行的时间}
    int *res = (int *)malloc(sizeof(int) * n);
    memset(res, 0, sizeof(int) * n);
    int top = 0;
    for (int i = 0; i < logsSize; i++) {
        char type[10];
        int idx, timestamp;
        sscanf(logs[i], "%d:%[^:]:%d", &idx, type, &timestamp);
        if (type[0] == 's') {
            if (top > 0) {
                res[stack[top - 1].idx] += timestamp - stack[top - 1].timestamp;
                stack[top - 1].timestamp = timestamp;
            }
            stack[top].idx = idx;
            stack[top].timestamp = timestamp;
            top++;
        } else {
            res[stack[top - 1].idx] += timestamp - stack[top - 1].timestamp + 1;
            top--;
            if (top > 0) {
                stack[top - 1].timestamp = timestamp + 1;
            }
        }
    }
    free(stack);
    *returnSize = n;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var exclusiveTime = function(n, logs) {
    const stack = []; // {idx, 开始运行的时间}
    const res = new Array(n).fill(0);
    for (const log of logs) {
        const idx = parseInt(log.substring(0, log.indexOf(':')));
        const type = log.substring(log.indexOf(':') + 1, log.lastIndexOf(':'));
        const timestamp = parseInt(log.substring(log.lastIndexOf(':') + 1));
        if ("start" === type) {
            if (stack.length) {
                res[stack[stack.length - 1][0]] += timestamp - stack[stack.length - 1][1];
                stack[stack.length - 1][1] = timestamp;
            }
            stack.push([idx, timestamp]);
        } else {
            const t = stack.pop();
            res[t[0]] += timestamp - t[1] + 1;
            if (stack.length) {
                stack[stack.length - 1][1] = timestamp + 1;
            }
        }
    }
    return res;
};
```

```go [sol1-Golang]
func exclusiveTime(n int, logs []string) []int {
    ans := make([]int, n)
    type pair struct{ idx, timestamp int }
    st := []pair{}
    for _, log := range logs {
        sp := strings.Split(log, ":")
        idx, _ := strconv.Atoi(sp[0])
        timestamp, _ := strconv.Atoi(sp[2])
        if sp[1][0] == 's' {
            if len(st) > 0 {
                ans[st[len(st)-1].idx] += timestamp - st[len(st)-1].timestamp
                st[len(st)-1].timestamp = timestamp
            }
            st = append(st, pair{idx, timestamp})
        } else {
            p := st[len(st)-1]
            st = st[:len(st)-1]
            ans[p.idx] += timestamp - p.timestamp + 1
            if len(st) > 0 {
                st[len(st)-1].timestamp = timestamp + 1
            }
        }
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为全部日志 $\textit{logs}$ 的数量，$n$ 条日志信息对应总共 $n$ 次入栈和出栈操作。
- 空间复杂度：$O(n)$，其中 $n$ 为全部日志 $\textit{logs}$ 的数量，$n$ 条日志信息对应 $\frac{n}{2}$ 次入栈操作，最坏的情况下全部 $\frac{n}{2}$ 条日志入栈后才会依次弹栈。