## [1882.使用服务器处理任务 中文官方题解](https://leetcode.cn/problems/process-tasks-using-servers/solutions/100000/process-tasks-using-servers-by-leetcode-rot1m)

#### 方法一：优先队列

**思路与算法**

我们使用两个优先队列分别存储工作中的服务器以及空闲的服务器：

- 优先队列 $\textit{busy}$ 存储工作中的服务器，每一台服务器用二元组 $(t, \textit{idx})$ 表示，其中 $t$ 为该服务器结束工作的时间，$\textit{idx}$ 为该服务器的编号。优先队列的队首服务器满足 $t$ 最小，并且在 $t$ 相同的情况下，$\textit{idx}$ 最小。

- 优先队列 $\textit{idle}$ 存储空闲的服务器，每一台服务器用二元组 $(w, \textit{idx})$ 表示，其中 $w$ 为该服务器的 weight，$\textit{idx}$ 为该服务器的编号。优先队列的队首服务器满足 $w$ 最小，并且在 $w$ 相同的情况下，$\textit{idx}$ 最小。

这样设计的好处在于：

- 随着时间的增加，我们可以依次从优先队列 $\textit{busy}$ 中取出已经工作完成（即时间大于等于 $t$）的服务器；

- 当我们需要给任务安排服务器时，我们可以依次从优先队列 $\textit{idle}$ 中取出可用的服务器。

因此，我们就可以设计出算法的流程：

- 在初始时，我们将所有服务器放入优先队列 $\textit{idle}$ 中，并使用一个时间戳变量 $\textit{ts}$ 记录当前的时间，其初始值为 $0$；

- 随后我们遍历每一个任务：

    - 由于第 $i$ 个任务必须在时间 $i$ 时才可以开始，因此需要将 $\textit{ts}$ 置为其与 $i$ 的较大值；

    - 我们需要将优先队列 $\textit{busy}$ 中满足 $t \leq \textit{ts}$ 的服务器依次取出并放入优先队列 $\textit{idle}$；

    - 如果此时优先队列 $\textit{idle}$ 中没有服务器，说明我们需要等一台服务器完成任务，因此可以将 $\textit{ts}$ 置为优先队列 $\textit{busy}$ 的队首服务器的任务完成时间 $t$，并再次执行上一步；

    - 此时我们就可以给第 $i$ 个任务安排服务器了，即为优先队列 $\textit{idle}$ 的队首服务器，将其取出并放入优先队列 $\textit{busy}$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    using PLI = pair<long long, int>;
    using PII = pair<int, int>;
    
public:
    vector<int> assignTasks(vector<int>& servers, vector<int>& tasks) {
        int m = servers.size();
        int n = tasks.size();

        // 工作中的服务器，存储二元组 (t, idx)
        priority_queue<PLI, vector<PLI>, greater<PLI>> busy;
        // 空闲的服务器，存储二元组 (w, idx)
        priority_queue<PII, vector<PII>, greater<PII>> idle;
        for (int i = 0; i < m; ++i) {
            idle.emplace(servers[i], i);
        }
        
        long long ts = 0;
        // 将优先队列 busy 中满足 t<=ts 依次取出并放入优先队列 idle
        auto release = [&]() {
            while (!busy.empty() && busy.top().first <= ts) {
                auto&& [_, idx] = busy.top();
                idle.emplace(servers[idx], idx);
                busy.pop();
            }
        };
        
        vector<int> ans;
        for (int i = 0; i < n; ++i) {
            ts = max(ts, static_cast<long long>(i));
            release();
            if (idle.empty()) {
                ts = busy.top().first;
                release();
            }
            auto&& [_, idx] = idle.top();
            ans.push_back(idx);
            busy.emplace(ts + tasks[i], idx);
            idle.pop();
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def assignTasks(self, servers: List[int], tasks: List[int]) -> List[int]:
        # 工作中的服务器，存储二元组 (t, idx)
        busy = list()
        
        # 空闲的服务器，存储二元组 (w, idx)
        idle = [(w, i) for i, w in enumerate(servers)]
        heapq.heapify(idle)
        
        ts = 0
        # 将优先队列 busy 中满足 t<=ts 依次取出并放入优先队列 idle
        def release():
            while busy and busy[0][0] <= ts:
                _, idx = heapq.heappop(busy)
                heapq.heappush(idle, (servers[idx], idx))
        
        ans = list()
        for i, task in enumerate(tasks):
            ts = max(ts, i)
            release()
            if not idle:
                ts = busy[0][0]
                release()
            
            _, idx = heapq.heappop(idle)
            ans.append(idx)
            heapq.heappush(busy, (ts + task, idx))
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O((m+n) \log m)$ 或 $O(m + n \log m)$，其中 $m$ 和 $n$ 分别是数组 $\textit{servers}$ 和 $\textit{tasks}$ 的长度。

    - 我们需要 $O(m \log m)$ 或者 $O(m)$ 的时间将所有服务器放入优先队列 $\textit{idle}$，这一步的实现根据使用的 $\texttt{API}$ 而不同。

    - 我们需要 $O(n)$ 的时间遍历任务，对于每一个任务只会安排一台服务器，这一个「安排」的操作会将这台服务器从 $\textit{idle}$ 移至 $\textit{busy}$，并且会在未来的某个时刻因任务完成从 $\textit{busy}$ 移回 $\textit{idle}$，因此对于优先队列的操作次数是均摊 $O(1)$ 的。由于优先队列单词操作的时间复杂度为 $O(\log m)$，因此总时间复杂度为 $O(m \log m)$。

- 空间复杂度：$O(m)$，即为优先队列 $\textit{busy}$ 和 $\textit{idle}$ 需要使用的空间。