## [2071.你可以安排的最多任务数目 中文官方题解](https://leetcode.cn/problems/maximum-number-of-tasks-you-can-assign/solutions/100000/ni-ke-yi-an-pai-de-zui-duo-ren-wu-shu-mu-p7dm)
#### 方法一：二分查找 + 贪心选择工人

**提示 $1$**

如果我们已经知道「一定」可以完成 $k$ 个任务，那么：

- 我们可以在 $\textit{tasks}$ 中选择 $k$ 个值**最小**的任务；

- 我们可以在 $\textit{workers}$ 中选择 $k$ 个值**最大**的工人。

**提示 $2$**

如果我们可以完成 $k$ 个任务，并且满足提示 $1$，那么一定可以完成 $k-1$ 个任务，并且可以选择 $k-1$ 个值最小的任务以及 $k-1$ 个值最大的工人，同样满足提示 $1$。

**思路与算法**

根据提示 $2$，我们就可以使用二分查找的方法找到 $k$ 的上界 $k'$，使得我们可以完成 $k'$ 个任务，但不能完成 $k'+1$ 个任务。我们找到的 $k'$ 即为答案。

在二分查找的每一步中，当我们得到 $k$ 个值最小的任务以及 $k$ 个值最大的工人后，我们应该如何判断这些任务是否都可以完成呢？

我们可以考虑值**最大**的那个任务，此时会出现两种情况：

- 如果有工人的值大于等于该任务的值，那么我们一定不需要使用药丸，并且一定让值**最大**的工人完成该任务。

    > 证明的思路为：由于我们考虑的是值最大的那个任务，因此所有能完成该任务的工人都能完成剩余的所有任务。因此如果一个值并非最大的工人（无论是否使用药丸）完成该任务，而值最大的工人完成了另一个任务，那么我们将这两个工人完成的任务交换，仍然是可行的。

- 如果所有工人的值都小于该任务的值，那么我们必须使用药丸让一名工人完成任务，并且一定让值**最小**的工人完成该任务。

    > 这里的值**最小**指的是在使用药丸能完成任务的前提下，值最小的工人。

    > 证明的思路为：由于我们考虑的是值最大的那个任务，因此所有通过使用药丸能完成该任务的工人都能完成剩余的所有任务。如果一个值并非最小的工人使用药丸完成该任务，而值最小的工人（无论是否使用药丸）完成了另一个任务，那么我们将这两个工人完成的任务交换，仍然是可行的。

因此，我们可以从大到小枚举每一个任务，并使用有序集合维护所有的工人。当枚举到任务的值为 $t$ 时：

- 如果有序集合中最大的元素大于等于 $t$，那么我们将最大的元素从有序集合中删除。

- 如果有序集合中最大的元素小于 $t$，那么我们在有序集合中找出最小的大于等于 $t - \textit{strength}$ 的元素并删除。

    对于这种情况，如果我们没有药丸剩余，或者有序集合中不存在大于等于 $t - \textit{strength}$ 的元素，那么我们就无法完成所有任务。

这样一来，我们就解决了二分查找后判断可行性的问题。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxTaskAssign(vector<int>& tasks, vector<int>& workers, int pills, int strength) {
        int n = tasks.size(), m = workers.size();
        sort(tasks.begin(), tasks.end());
        sort(workers.begin(), workers.end());
        
        auto check = [&](int mid) -> bool {
            int p = pills;
            // 工人的有序集合
            multiset<int> ws;
            for (int i = m - mid; i < m; ++i) {
                ws.insert(workers[i]);
            }
            // 从大到小枚举每一个任务
            for (int i = mid - 1; i >= 0; --i) {
                // 如果有序集合中最大的元素大于等于 tasks[i]
                if (auto it = prev(ws.end()); *it >= tasks[i]) {
                    ws.erase(it);
                }
                else {
                    if (!p) {
                        return false;
                    }
                    auto rep = ws.lower_bound(tasks[i] - strength);
                    if (rep == ws.end()) {
                        return false;
                    }
                    --p;
                    ws.erase(rep);
                }
            }
            return true;
        };
        
        int left = 1, right = min(m, n), ans = 0;
        while (left <= right) {
            int mid = (left + right) / 2;
            if (check(mid)) {
                ans = mid;
                left = mid + 1;
            }
            else {
                right = mid - 1;
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
from sortedcontainers import SortedList

class Solution:
    def maxTaskAssign(self, tasks: List[int], workers: List[int], pills: int, strength: int) -> int:
        n, m = len(tasks), len(workers)
        tasks.sort()
        workers.sort()

        def check(mid: int) -> bool:
            p = pills
            #  工人的有序集合
            ws = SortedList(workers[m - mid:])
            # 从大到小枚举每一个任务
            for i in range(mid - 1, -1, -1):
                # 如果有序集合中最大的元素大于等于 tasks[i]
                if ws[-1] >= tasks[i]:
                    ws.pop()
                else:
                    if p == 0:
                        return False
                    rep = ws.bisect_left(tasks[i] - strength)
                    if rep == len(ws):
                        return False
                    p -= 1
                    ws.pop(rep)
            return True

        left, right, ans = 1, min(m, n), 0
        while left <= right:
            mid = (left + right) // 2
            if check(mid):
                ans = mid
                left = mid + 1
            else:
                right = mid - 1
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log n + m \log m + \min(m, n) \log^2 \min(m, n))$。

    - 对数组 $\textit{tasks}$ 排序需要 $O(n \log n)$ 的时间；

    - 对数组 $\textit{workers}$ 排序需要 $O(m \log m)$ 的时间；

    - 二分查找的下界为 $1$，上界为 $m$ 和 $n$ 中的较小值，因此二分查找的次数为 $\log \min(m, n)$。每一次查找需要枚举 $\min(m, n)$ 个任务，并且枚举的过程中需要对工人的有序集合进行删除操作，单次操作时间复杂度为 $\log \min(m, n)$。因此二分查找的总时间复杂度为 $O(\min(m, n) \log^2 \min(m, n))$。

- 空间复杂度：$O(\log n + \log m + \min(m, n))$。

    - 对数组 $\textit{tasks}$ 排序需要 $O(\log n)$ 的栈空间；

    - 对数组 $\textit{workers}$ 排序需要 $O(\log m)$ 的栈空间；

    - 二分查找中使用的有序集合需要 $O(\min(m, n))$ 的空间。

**扩展**

可以发现，当我们从大到小枚举每一个任务时，如果我们维护了（在使用药丸的情况下）所有可以完成任务的工人，那么：

- 如果有工人可以不使用药丸完成该任务，那么我们选择（删除）值最大的工人；

- 如果所有工人都需要使用药丸才能完成该任务，那么我们选择（删除）值最小的工人。

而随着任务值的减少，可以完成任务的工人只增不减，因此我们可以使用一个「双端队列」来维护所有可以（在使用药丸的情况下）所有可以完成任务的工人，此时要么队首的工人被选择（删除），要么队尾的工人被选择（删除），那么单次删除操作的时间复杂度由 $O(\log \min (m, n))$ 降低为 $O(1)$，总时间复杂度降低为：

$$
O(n \log n + m \log m + \min(m, n) \log \min(m, n)) = O(n \log n + m \log m)
$$

```C++ [sol2-C++]
class Solution {
public:
    int maxTaskAssign(vector<int>& tasks, vector<int>& workers, int pills, int strength) {
        int n = tasks.size(), m = workers.size();
        sort(tasks.begin(), tasks.end());
        sort(workers.begin(), workers.end());
        
        auto check = [&](int mid) -> bool {
            int p = pills;
            deque<int> ws;
            int ptr = m - 1;
            // 从大到小枚举每一个任务
            for (int i = mid - 1; i >= 0; --i) {
                while (ptr >= m - mid && workers[ptr] + strength >= tasks[i]) {
                    ws.push_front(workers[ptr]);
                    --ptr;
                }
                if (ws.empty()) {
                    return false;
                }
                // 如果双端队列中最大的元素大于等于 tasks[i]
                else if (ws.back() >= tasks[i]) {
                    ws.pop_back();
                }
                else {
                    if (!p) {
                        return false;
                    }
                    --p;
                    ws.pop_front();
                }
            }
            return true;
        };
        
        int left = 1, right = min(m, n), ans = 0;
        while (left <= right) {
            int mid = (left + right) / 2;
            if (check(mid)) {
                ans = mid;
                left = mid + 1;
            }
            else {
                right = mid - 1;
            }
        }
        return ans;
    }
};
```

```Python [sol2-Python3]
from sortedcontainers import SortedList

class Solution:
    def maxTaskAssign(self, tasks: List[int], workers: List[int], pills: int, strength: int) -> int:
        n, m = len(tasks), len(workers)
        tasks.sort()
        workers.sort()

        def check(mid: int) -> bool:
            p = pills
            ws = deque()
            ptr = m - 1
            # 从大到小枚举每一个任务
            for i in range(mid - 1, -1, -1):
                while ptr >= m - mid and workers[ptr] + strength >= tasks[i]:
                    ws.appendleft(workers[ptr])
                    ptr -= 1
                if not ws:
                    return False
                # 如果双端队列中最大的元素大于等于 tasks[i]
                elif ws[-1] >= tasks[i]:
                    ws.pop()
                else:
                    if p == 0:
                        return False
                    p -= 1
                    ws.popleft()
            return True

        left, right, ans = 1, min(m, n), 0
        while left <= right:
            mid = (left + right) // 2
            if check(mid):
                ans = mid
                left = mid + 1
            else:
                right = mid - 1
        
        return ans
```