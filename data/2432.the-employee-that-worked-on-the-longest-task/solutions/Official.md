#### 方法一：枚举每一位员工

**思路与算法**

我们可以对数组 $\textit{logs}$ 进行一次遍历，算出其中每位员工的处理用时并得到答案。

具体地，我们在遍历时维护两个变量 $\textit{maxcost}$ 和 $\textit{ans}$，前者表示最长的处理用时，后者表示其对应的员工。首个任务从时刻 $0$ 开始，因此初始时，我们将这两个变量赋值为 $\textit{logs}[0]$ 中的两个值。随后我们从 $\textit{logs}[1]$ 开始遍历，通过相邻两项的差值计算出处理用时，并根据题目的要求对于 $\textit{maxcost}$ 和 $\textit{ans}$ 进行更新即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int hardestWorker(int n, vector<vector<int>>& logs) {
        int ans = logs[0][0], maxcost = logs[0][1];
        for (int i = 1; i < logs.size(); ++i) {
            int idx = logs[i][0];
            int cost = logs[i][1] - logs[i - 1][1];
            if (cost > maxcost || (cost == maxcost && idx < ans)) {
                ans = idx;
                maxcost = cost;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int hardestWorker(int n, int[][] logs) {
        int ans = logs[0][0], maxcost = logs[0][1];
        for (int i = 1; i < logs.length; ++i) {
            int idx = logs[i][0];
            int cost = logs[i][1] - logs[i - 1][1];
            if (cost > maxcost || (cost == maxcost && idx < ans)) {
                ans = idx;
                maxcost = cost;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int HardestWorker(int n, int[][] logs) {
        int ans = logs[0][0], maxcost = logs[0][1];
        for (int i = 1; i < logs.Length; ++i) {
            int idx = logs[i][0];
            int cost = logs[i][1] - logs[i - 1][1];
            if (cost > maxcost || (cost == maxcost && idx < ans)) {
                ans = idx;
                maxcost = cost;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def hardestWorker(self, n: int, logs: List[List[int]]) -> int:
        ans, maxcost = logs[0]
        for i in range(1, len(logs)):
            idx, cost = logs[i][0], logs[i][1] - logs[i - 1][1]
            if cost > maxcost or (cost == maxcost and idx < ans):
                ans, maxcost = idx, cost
        return ans
```

```Go [sol1-Go]
func hardestWorker(n int, logs [][]int) int {
    ans, maxCost := logs[0][0], logs[0][1]
    for i := 1; i < len(logs); i++ {
        idx := logs[i][0]
        cost := logs[i][1] - logs[i - 1][1]
        if cost > maxCost || (cost == maxCost && idx < ans) {
            ans = idx
            maxCost = cost
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var hardestWorker = function(n, logs) {
    let ans = logs[0][0], maxCost = logs[0][1];
    for (let i = 1; i < logs.length; i++) {
        const idx = logs[i][0];
        const cost = logs[i][1] - logs[i - 1][1];
        if (cost > maxCost || (cost === maxCost && idx < ans)) {
            ans = idx;
            maxCost = cost;
        }
    }
    return ans;
};
```

```C [sol1-C]
int hardestWorker(int n, int** logs, int logsSize, int* logsColSize) {
    int ans = logs[0][0], maxcost = logs[0][1];
    for (int i = 1; i < logsSize; ++i) {
        int idx = logs[i][0];
        int cost = logs[i][1] - logs[i - 1][1];
        if (cost > maxcost || (cost == maxcost && idx < ans)) {
            ans = idx;
            maxcost = cost;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(m)$，其中 $m$ 是数组 $\textit{logs}$ 的长度。

- 空间复杂度：$O(1)$。