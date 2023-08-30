#### 方法一：排序 + 优先队列

**提示 $1$**

我们需要两个数据结构来实现题目描述中的 CPU 操作。

- 第一个数据结构负责按照时间顺序将任务分配给 CPU；
- 第二个数据结构负责帮助 CPU 在所有任务中选择处理时间最小的那个执行。

你能想出这两个数据结构分别是什么吗？

**思路与算法**

第一个数据结构即为数组。我们将数组 $\textit{task}$ 中的所有任务按照 $\textit{enqueueTime}_i$ 升序排序即可。

> 需要注意的是，在排序完成之后，我们就会丢失任务的编号信息。一种可行的解决方案是，我们使用一个长度为 $n$ 的数组存储编号，并直接对编号进行自定义排序，排序的标准即为 $\textit{enqueueTime}_i$。

第二个数据结构即为优先队列（小根堆）。我们将所有分配给 CPU 的任务放入优先队列中，每次取出处理时间 $\textit{processingTime}_i$ 最小的任务执行。

**细节**

为了使得上面的两个数据结构能够帮助我们解决本题，我们可以维护一个时间戳变量 $\textit{timestamp}$，表示当前的时间，它的初始值为 $0$。

我们需要让 CPU 执行所有的 $n$ 个任务，在执行第 $i$ 个任务前：

- 如果 CPU 没有可以执行的任务（即优先队列为空），我们将时间戳直接「快进」到数组中下一个还没有分配给 CPU 的那个任务的 $\textit{enqueueTime}_i$；

- 在这之后，我们将所有 $\textit{enqueueTime}_i \leq \textit{timestamp}$ 的任务放入优先队列中。我们可以使用一个指针在数组上从前往后进行遍历，保证每个任务只会被加入优先队列恰好一次；

- 最终我们就可以在优先队列中挑选 $\textit{processingTime}_i$ 最小的那个任务让 CPU 来执行，并且我们需要将 $\textit{timestamp}$ 增加 $\textit{processingTime}_i$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    using PII = pair<int, int>;
    using LL = long long;

public:
    vector<int> getOrder(vector<vector<int>>& tasks) {
        int n = tasks.size();
        vector<int> indices(n);
        iota(indices.begin(), indices.end(), 0);
        sort(indices.begin(), indices.end(), [&](int i, int j) {
            return tasks[i][0] < tasks[j][0];
        });

        vector<int> ans;
        // 优先队列
        priority_queue<PII, vector<PII>, greater<PII>> q;
        // 时间戳
        LL timestamp = 0;
        // 数组上遍历的指针
        int ptr = 0;
        
        for (int i = 0; i < n; ++i) {
            // 如果没有可以执行的任务，直接快进
            if (q.empty()) {
                timestamp = max(timestamp, (LL)tasks[indices[ptr]][0]);
            }
            // 将所有小于等于时间戳的任务放入优先队列
            while (ptr < n && tasks[indices[ptr]][0] <= timestamp) {
                q.emplace(tasks[indices[ptr]][1], indices[ptr]);
                ++ptr;
            }
            // 选择处理时间最小的任务
            auto&& [process, index] = q.top();
            timestamp += process;
            ans.push_back(index);
            q.pop();
        }
        
        return ans;
    }
};

```

```Python [sol1-Python3]
class Solution:
    def getOrder(self, tasks: List[List[int]]) -> List[int]:
        n = len(tasks)
        indices = list(range(n))
        indices.sort(key=lambda x: tasks[x][0])

        ans = list()
        # 优先队列
        q = list()
        # 时间戳
        timestamp = 0
        # 数组上遍历的指针
        ptr = 0
        
        for i in range(n):
            # 如果没有可以执行的任务，直接快进
            if not q:
                timestamp = max(timestamp, tasks[indices[ptr]][0])
            # 将所有小于等于时间戳的任务放入优先队列
            while ptr < n and tasks[indices[ptr]][0] <= timestamp:
                heapq.heappush(q, (tasks[indices[ptr]][1], indices[ptr]))
                ptr += 1
            # 选择处理时间最小的任务
            process, index = heapq.heappop(q)
            timestamp += process
            ans.append(index)
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$。排序的时间复杂度为 $O(n \log n)$，优先队列单次操作的时间复杂度为 $O(\log n)$，操作的次数为 $O(n)$。

- 空间复杂度：$O(n)$，即为存储编号的数组以及优先队列需要使用的空间。