## [2532.过桥的时间 中文官方题解](https://leetcode.cn/problems/time-to-cross-a-bridge/solutions/100000/guo-qiao-de-shi-jian-by-leetcode-solutio-thj9)

#### 方法一：优先队列

**思路与算法**

在本题中，工人共有 $4$ 种状态：

1. 在左侧等待
2. 在右侧等待
3. 在左侧工作（放下所选箱子）
4. 在右侧工作（搬起所选箱子）

每一种工作状态都有相应的优先级计算方法，因此我们用 $4$ 个优先队列来存放处于每种状态下的工人集合：

1. 在左侧等待的工人：$\textit{wait\_left}$，题目中定义的效率越高，优先级越高。
2. 在右侧等待的工人：$\textit{wait\_right}$，题目中定义的效率越高，优先级越高。
3. 在左侧工作的工人：$\textit{work\_left}$，完成时间越早，优先级越高。
4. 在右侧工作的工人：$\textit{work\_right}$，完成时间越早，优先级越高。

我们令 $\textit{remain}$ 表示右侧还有多少个箱子需要搬运，当 $\textit{remain} > 0$ 时，搬运工作需要继续。除此之外，题目求解的是最后一个回到左边的工人的到达时间，因此当右侧还有工人在等待或在工作时（即 $\textit{work\_right}$ 或 $\textit{wait\_right}$ 不为空），搬运工作就需要继续：

1. 若 $\textit{work\_left}$ 或 $\textit{work\_right}$ 中的工人在此刻已经完成工作，则需要将它们取出并分别加入到 $\textit{wait\_left}$ 和 $\textit{wait\_right}$ 中。
2. 若 $\textit{wait\_right}$ 不为空，则取其中**优先级最低**的工人过桥，将其加入到 $\textit{work\_left}$ 队列中，并将时间更改为过桥后的时间。继续下一轮循环。
3. 若 $\textit{remain} > 0$，并且 $\textit{wait\_left}$ 不为空，则需要取**优先级最低**的工人过桥去取箱子，将其加入到 $\textit{work\_right}$ 队列中，令 $\textit{remain}$ 减 $1$，并将时间更改为过桥后的时间。继续下一轮循环。
4. 若 $2$ 和 $3$ 都不满足，表示当前没有人需要过桥，当前时间应该过渡到 $\textit{work\_left}$ 和 $\textit{work\_right}$ 中的最早完成时间。然后继续下一轮循环。

按照上述过程模拟，直到循环条件不再满足。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    using PII = pair<int, int>;
    int findCrossingTime(int n, int k, vector<vector<int>>& time) {
        // 定义等待中的工人优先级比较规则，时间总和越高，效率越低，优先级越低，越优先被取出
        auto wait_priority_cmp = [&](int x, int y) {
            int time_x = time[x][0] + time[x][2];
            int time_y = time[y][0] + time[y][2];
            return time_x != time_y ? time_x < time_y : x < y;
        };

        priority_queue<int, vector<int>, decltype(wait_priority_cmp)> wait_left(wait_priority_cmp), wait_right(wait_priority_cmp);

        priority_queue<PII, vector<PII>, greater<PII>> work_left, work_right;

        int remain = n, cur_time = 0;
        for (int i = 0; i < k; i++) {
            wait_left.push(i);
        }
        while (remain > 0 || !work_right.empty() || !wait_right.empty()) {
            // 1. 若 work_left 或 work_right 中的工人完成工作，则将他们取出，并分别放置到 wait_left 和 wait_right 中。
            while (!work_left.empty() && work_left.top().first <= cur_time) {
                wait_left.push(work_left.top().second);
                work_left.pop();
            }
            while (!work_right.empty() && work_right.top().first <= cur_time) {
                wait_right.push(work_right.top().second);
                work_right.pop();
            }

            if (!wait_right.empty()) {
                // 2. 若右侧有工人在等待，则取出优先级最低的工人并过桥
                int id = wait_right.top();
                wait_right.pop();
                cur_time += time[id][2];
                work_left.push({cur_time + time[id][3], id});
            } else if (remain > 0 && !wait_left.empty()) {
                // 3. 若右侧还有箱子，并且左侧有工人在等待，则取出优先级最低的工人并过桥
                int id = wait_left.top();
                wait_left.pop();
                cur_time += time[id][0];
                work_right.push({cur_time + time[id][1], id});
                remain--;
            } else {
                // 4. 否则，没有人需要过桥，时间过渡到 work_left 和 work_right 中的最早完成时间
                int next_time = INT_MAX;
                if (!work_left.empty()) {
                    next_time = min(next_time, work_left.top().first);
                }
                if (!work_right.empty()) {
                    next_time = min(next_time, work_right.top().first);
                }
                if (next_time != INT_MAX) {
                    cur_time = max(next_time, cur_time);
                }
            }
        }
        return cur_time;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findCrossingTime(int n, int k, int[][] time) {
        // 定义等待中的工人优先级比较规则，时间总和越高，效率越低，优先级越低，越优先被取出
        PriorityQueue<Integer> waitLeft = new PriorityQueue<Integer>((x, y) -> {
            int timeX = time[x][0] + time[x][2];
            int timeY = time[y][0] + time[y][2];
            return timeX != timeY ? timeY - timeX : y - x;
        });
        PriorityQueue<Integer> waitRight = new PriorityQueue<Integer>((x, y) -> {
            int timeX = time[x][0] + time[x][2];
            int timeY = time[y][0] + time[y][2];
            return timeX != timeY ? timeY - timeX : y - x;
        });

        PriorityQueue<int[]> workLeft = new PriorityQueue<int[]>((x, y) -> {
            if (x[0] != y[0]) {
                return x[0] - y[0];
            } else {
                return x[1] - y[1];
            }
        });
        PriorityQueue<int[]> workRight = new PriorityQueue<int[]>((x, y) -> {
            if (x[0] != y[0]) {
                return x[0] - y[0];
            } else {
                return x[1] - y[1];
            }
        });

        int remain = n, curTime = 0;
        for (int i = 0; i < k; i++) {
            waitLeft.offer(i);
        }
        while (remain > 0 || !workRight.isEmpty() || !waitRight.isEmpty()) {
            // 1. 若 workLeft 或 workRight 中的工人完成工作，则将他们取出，并分别放置到 waitLeft 和 waitRight 中。
            while (!workLeft.isEmpty() && workLeft.peek()[0] <= curTime) {
                waitLeft.offer(workLeft.poll()[1]);
            }
            while (!workRight.isEmpty() && workRight.peek()[0] <= curTime) {
                waitRight.offer(workRight.poll()[1]);
            }

            if (!waitRight.isEmpty()) {
                // 2. 若右侧有工人在等待，则取出优先级最低的工人并过桥
                int id = waitRight.poll();
                curTime += time[id][2];
                workLeft.offer(new int[]{curTime + time[id][3], id});
            } else if (remain > 0 && !waitLeft.isEmpty()) {
                // 3. 若右侧还有箱子，并且左侧有工人在等待，则取出优先级最低的工人并过桥
                int id = waitLeft.poll();
                curTime += time[id][0];
                workRight.offer(new int[]{curTime + time[id][1], id});
                remain--;
            } else {
                // 4. 否则，没有人需要过桥，时间过渡到 workLeft 和 workRight 中的最早完成时间
                int nextTime = Integer.MAX_VALUE;
                if (!workLeft.isEmpty()) {
                    nextTime = Math.min(nextTime, workLeft.peek()[0]);
                }
                if (!workRight.isEmpty()) {
                    nextTime = Math.min(nextTime, workRight.peek()[0]);
                }
                if (nextTime != Integer.MAX_VALUE) {
                    curTime = Math.max(nextTime, curTime);
                }
            }
        }
        return curTime;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindCrossingTime(int n, int k, int[][] time) {
        // 定义等待中的工人优先级比较规则，时间总和越高，效率越低，优先级越低，越优先被取出
        PriorityQueue<int, long> waitLeft = new PriorityQueue<int, long>();
        PriorityQueue<int, long> waitRight = new PriorityQueue<int, long>();

        PriorityQueue<int[], long> workLeft = new PriorityQueue<int[], long>();
        PriorityQueue<int[], long> workRight = new PriorityQueue<int[], long>();

        int remain = n, curTime = 0;
        for (int i = 0; i < k; i++) {
            long priority = -(time[i][0] + time[i][2]) * (long) 1001 - i;
            waitLeft.Enqueue(i, priority);
        }
        while (remain > 0 || workRight.Count > 0 || waitRight.Count > 0) {
            // 1. 若 workLeft 或 workRight 中的工人完成工作，则将他们取出，并分别放置到 waitLeft 和 waitRight 中。
            while (workLeft.Count > 0 && workLeft.Peek()[0] <= curTime) {
                int val = workLeft.Dequeue()[1];
                long priority = -(time[val][0] + time[val][2]) * (long) 1001 - val;
                waitLeft.Enqueue(val, priority);
            }
            while (workRight.Count > 0 && workRight.Peek()[0] <= curTime) {
                int val = workRight.Dequeue()[1];
                long priority = -(time[val][0] + time[val][2]) * (long) 1001 - val;
                waitRight.Enqueue(val, priority);
            }

            if (waitRight.Count > 0) {
                // 2. 若右侧有工人在等待，则取出优先级最低的工人并过桥
                int id = waitRight.Dequeue();
                curTime += time[id][2];
                long priority = (curTime + time[id][3]) * (long) 1001 + id;
                workLeft.Enqueue(new int[]{curTime + time[id][3], id}, priority);
            } else if (remain > 0 && waitLeft.Count > 0) {
                // 3. 若右侧还有箱子，并且左侧有工人在等待，则取出优先级最低的工人并过桥
                int id = waitLeft.Dequeue();
                curTime += time[id][0];
                long priority = (curTime + time[id][1]) * (long) 1001 + id;
                workRight.Enqueue(new int[]{curTime + time[id][1], id}, priority);
                remain--;
            } else {
                // 4. 否则，没有人需要过桥，时间过渡到 workLeft 和 workRight 中的最早完成时间
                int nextTime = int.MaxValue;
                if (workLeft.Count > 0) {
                    nextTime = Math.Min(nextTime, workLeft.Peek()[0]);
                }
                if (workRight.Count > 0) {
                    nextTime = Math.Min(nextTime, workRight.Peek()[0]);
                }
                if (nextTime != int.MaxValue) {
                    curTime = Math.Max(nextTime, curTime);
                }
            }
        }
        return curTime;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n\log k)$，其中 $n$ 为箱子的个数，$k$ 为工人的个数。过程中每个队列最多会进出元素 $n$ 次，每次进出的时间复杂度为 $O(\log k)$，因此总的时间复杂度为 $O(n\log k)$。

- 空间复杂度：$O(k)$。过程中每个优先队列最多会包含 $k$ 个元素，因此总的空间复杂度为 $O(k)$。