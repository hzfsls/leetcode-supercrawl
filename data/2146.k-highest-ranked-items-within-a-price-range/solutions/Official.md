#### 方法一：广度优先搜索

**思路与算法**

根据题意，我们需要求出所有感兴趣物品的距离、价格以及行列坐标。为了求出起点 $\textit{start}$ 到某件物品的最短路径，我们可以使用广度优先搜索，并在搜索的过程利用数组 $\textit{items}$ 来统计感兴趣物品的信息。具体地，$\textit{items}$ 中的每个元素为 $(d, \textit{price}, x, y)$，其中 $d$ 为物品坐标相对起点的最短距离，$\textit{price}$ 为物品价格，$(x, y)$ 为物品的行列坐标。

在广度优先搜索的过程中，我们在队列 $q$ 中保存 $(x, y, d)$ 三元组，其中 $(x, y)$ 为当前的行列坐标，$d$ 为当前坐标相对起点的最短距离。

我们首先将起点对应的三元组 $(\textit{start}[0], \textit{start}[1], 0)$ 加入队列。如果起点对应的物品价值在感兴趣的范围内，我们也需要将该物品的相关信息 $(0, \textit{grid}[\textit{start}[0]][\textit{start}[1]], \textit{start}[0], \textit{start}[1])$ 放入 $\textit{items}$ 数组。

在遍历到 $(x, y)$ 时，我们枚举它上下左右的相邻坐标 $(n_x, n_y)$，此时会有以下几种情况：

- $(n_x, n_y)$ 不合法或 $\textit{grid}[n_x][n_y] = 0$，此时无需进行任何操作；

- $\textit{grid}[n_x][n_y] = 1$ 或不在 $[\textit{low}, \textit{high}]$ 区间内，此时该坐标无物品或物品价格不在感兴趣范围内，我们只需将 $(n_x, n_y, d + 1)$ 加入队列 $q$；

- $\textit{grid}[n_x][n_y]$ 在 $[\textit{low}, \textit{high}]$ 区间内，此时该坐标的物品在感兴趣的价格范围内，除了需要将 $(n_x, n_y, d + 1)$ 加入队列 $q$ 以外，我们还需要将该物品的距离、价格以及行列坐标 $(d + 1, \textit{grid}[n_x][n_y], n_x, n_y)$ 放入 $\textit{items}$ 数组。

另外，为了避免重复遍历，我们需要在每个坐标（包括起点）**加入队列时**将 $\textit{grid}$ 中对应下标的数值修改为 $0$。

当遍历完成后，我们将 $\textit{items}$ 数组按照**元素的字典序升序排序**，亦即按照**优先级从高到低**的顺序排序。随后，我们用数组 $\textit{res}$ 统计 $\textit{items}$ 数组中前 $k$ 个（若不满即为全部）物品的行列坐标，并将 $\textit{res}$ 数组返回作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int dx[4] = {1, 0, -1, 0};
    static constexpr int dy[4] = {0, 1, 0, -1};

public:
    vector<vector<int>> highestRankedKItems(vector<vector<int>>& grid, vector<int>& pricing, vector<int>& start, int k) {
        vector<tuple<int, int, int, int>> items;   // 感兴趣物品的信息
        queue<tuple<int, int, int>> q;   // 广度优先搜索队列
        q.emplace(start[0], start[1], 0);
        if (pricing[0] <= grid[start[0]][start[1]] && grid[start[0]][start[1]] <= pricing[1]) {
            items.emplace_back(0, grid[start[0]][start[1]], start[0], start[1]);
        }
        grid[start[0]][start[1]] = 0;   // 避免重复遍历
        int m = grid.size();
        int n = grid[0].size();
        while (!q.empty()) {
            auto [x, y, d] = q.front();
            q.pop();
            for (int i = 0; i < 4; ++i) {
                // 遍历相邻坐标，并进行对应操作
                int nx = x + dx[i];
                int ny = y + dy[i];
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] > 0) {
                    if (pricing[0] <= grid[nx][ny] && grid[nx][ny] <= pricing[1]) {
                        items.emplace_back(d + 1, grid[nx][ny], nx, ny);
                    }
                    q.emplace(nx, ny, d + 1);
                    grid[nx][ny] = 0;   // 避免重复遍历
                }
            }
        }
        sort(items.begin(), items.end());   // 按照优先级从高到低排序
        vector<vector<int>> res;   // 排名最高 k 件物品的坐标
        int cnt = min(k, static_cast<int>(items.size()));
        for (int i = 0; i < cnt; ++i) {
            auto [d, price, x, y] = items[i];
            res.push_back({x, y});
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def highestRankedKItems(self, grid: List[List[int]], pricing: List[int], start: List[int], k: int) -> List[List[int]]:
        items = []   # 感兴趣物品的信息
        q = deque([(start[0], start[1], 0)])   # 广度优先搜索队列
        if pricing[0] <= grid[start[0]][start[1]] <= pricing[1]:
            items.append([0, grid[start[0]][start[1]], start[0], start[1]])
        grid[start[0]][start[1]] = 0   # 避免重复遍历
        m = len(grid)
        n = len(grid[0])
        dx = [1, 0, -1, 0]
        dy = [0, 1, 0, -1]
        while q:
            x, y, d = q.popleft()
            for i in range(4):
                # 遍历相邻坐标，并进行对应操作
                nx, ny = x + dx[i], y + dy[i]
                if 0 <= nx < m and 0 <= ny < n and grid[nx][ny] > 0:
                    q.append((nx, ny, d + 1))
                    if pricing[0] <= grid[nx][ny] <= pricing[1]:
                        items.append([d + 1, grid[nx][ny], nx, ny])
                    grid[nx][ny] = 0   # 避免重复遍历
        items.sort()   # 按照优先级从高到低排序
        res = [item[2:] for item in items][:k]   # 排名最高 k 件物品的坐标
        return res
```


**复杂度分析**

- 时间复杂度：$O(mn \log(mn))$，其中 $m, n$ 为 $\textit{grid}$ 的行数与列数。其中广度优先搜索求出可选择物品的时间复杂度为 $O(mn)$，对物品按要求排序的时间复杂度为 $O(mn \log(mn))$。

- 空间复杂度：$O(mn)$，即为保存符合要求物品信息的辅助数组的空间开销。