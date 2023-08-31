## [994.腐烂的橘子 中文官方题解](https://leetcode.cn/problems/rotting-oranges/solutions/100000/fu-lan-de-ju-zi-by-leetcode-solution)
#### 前言

由题目我们可以知道每分钟每个腐烂的橘子都会使上下左右相邻的新鲜橘子腐烂，这其实是一个模拟广度优先搜索的过程。**所谓广度优先搜索，就是从起点出发，每次都尝试访问同一层的节点，如果同一层都访问完了，再访问下一层，最后广度优先搜索找到的路径就是从起点开始的最短合法路径**。 

回到题目中，假设图中只有一个腐烂的橘子，它每分钟向外拓展，腐烂上下左右相邻的新鲜橘子，那么下一分钟，就是这些被腐烂的橘子再向外拓展腐烂相邻的新鲜橘子，这与广度优先搜索的过程均一一对应，**上下左右相邻的新鲜橘子就是该腐烂橘子尝试访问的同一层的节点，路径长度就是新鲜橘子被腐烂的时间**。我们记录下每个新鲜橘子被腐烂的时间，最后如果单元格中没有新鲜橘子，腐烂所有新鲜橘子所必须经过的最小分钟数就是新鲜橘子被腐烂的时间的最大值。

以上是基于图中只有一个腐烂的橘子的情况，可实际题目中腐烂的橘子数不止一个，看似与广度优先搜索有所区别，不能直接套用，但其实有两个方向的思路。

一个是耗时比较大且不推荐的做法：我们对每个腐烂橘子为起点都进行一次广度优先搜索，用 $dis[x][y][i]$ 表示只考虑第 $i$ 个腐烂橘子为起点的广度优先搜索，坐标位于 $(x, y)$ 的新鲜橘子被腐烂的时间，设没有被腐烂的新鲜橘子的 $dis[x][y][i]=inf$ ，即无限大，表示没有被腐烂，那么每个新鲜橘子被腐烂的最短时间即为

$$min_{i}\ dis[x][y][i]$$

最后的答案就是所有新鲜橘子被腐烂的最短时间的最大值，如果是无限大，说明有新鲜橘子没有被腐烂，输出 $-1$ 即可。

无疑上面的方法需要枚举每个腐烂橘子，所以时间复杂度需要在原先广度优先搜索遍历的时间复杂度上再乘以腐烂橘子数，这在整个网格范围变大的时候十分耗时，所以需要另寻他路。

#### 方法一：多源广度优先搜索

**思路**

观察到对于所有的腐烂橘子，其实它们**在广度优先搜索上是等价于同一层的节点的**。

假设这些腐烂橘子刚开始是新鲜的，而有一个腐烂橘子(**我们令其为超级源点**)会在下一秒把这些橘子都变腐烂，而这个腐烂橘子刚开始在的时间是 $-1$ ，那么按照广度优先搜索的算法，下一分钟也就是第 $0$ 分钟的时候，这个腐烂橘子会把它们都变成腐烂橘子，然后继续向外拓展，所以其实这些腐烂橘子是同一层的节点。那么在广度优先搜索的时候，我们将这些腐烂橘子都放进队列里进行广度优先搜索即可，最后每个新鲜橘子被腐烂的最短时间 $dis[x][y]$ 其实是以这个超级源点的腐烂橘子为起点的广度优先搜索得到的结果。

为了确认是否所有新鲜橘子都被腐烂，可以记录一个变量 $cnt$ 表示当前网格中的新鲜橘子数，广度优先搜索的时候如果有新鲜橘子被腐烂，则 `cnt-=1` ，最后搜索结束时如果 $cnt$ 大于 $0$ ，说明有新鲜橘子没被腐烂，返回 $-1$ ，否则返回所有新鲜橘子被腐烂的时间的最大值即可，也可以在广度优先搜索的过程中把已腐烂的新鲜橘子的值由 $1$ 改为 $2$，最后看网格中是否由值为 $1$ 即新鲜的橘子即可。

```C++ [sol1-C++]
class Solution {
    int cnt;
    int dis[10][10];
    int dir_x[4]={0, 1, 0, -1};
    int dir_y[4]={1, 0, -1, 0};
public:
    int orangesRotting(vector<vector<int>>& grid) {
        queue<pair<int,int> >Q;
        memset(dis, -1, sizeof(dis));
        cnt = 0;
        int n=(int)grid.size(), m=(int)grid[0].size(), ans = 0;
        for (int i = 0; i < n; ++i){
            for (int j = 0; j < m; ++j){
                if (grid[i][j] == 2){
                    Q.push(make_pair(i, j));
                    dis[i][j] = 0;
                }
                else if (grid[i][j] == 1) cnt += 1;
            }
        }
        while (!Q.empty()){
            pair<int,int> x = Q.front();Q.pop();
            for (int i = 0; i < 4; ++i){
                int tx = x.first + dir_x[i];
                int ty = x.second + dir_y[i];
                if (tx < 0|| tx >= n || ty < 0|| ty >= m|| ~dis[tx][ty] || !grid[tx][ty]) continue;
                dis[tx][ty] = dis[x.first][x.second] + 1;
                Q.push(make_pair(tx, ty));
                if (grid[tx][ty] == 1){
                    cnt -= 1;
                    ans = dis[tx][ty];
                    if (!cnt) break;
                }
            }
        }
        return cnt ? -1 : ans;
    }
};
```
```Java [sol1-Java]
class Solution {
    int[] dr = new int[]{-1, 0, 1, 0};
    int[] dc = new int[]{0, -1, 0, 1};

    public int orangesRotting(int[][] grid) {
        int R = grid.length, C = grid[0].length;
        Queue<Integer> queue = new ArrayDeque<Integer>();
        Map<Integer, Integer> depth = new HashMap<Integer, Integer>();
        for (int r = 0; r < R; ++r) {
            for (int c = 0; c < C; ++c) {
                if (grid[r][c] == 2) {
                    int code = r * C + c;
                    queue.add(code);
                    depth.put(code, 0);
                }
            }
        }
        int ans = 0;
        while (!queue.isEmpty()) {
            int code = queue.remove();
            int r = code / C, c = code % C;
            for (int k = 0; k < 4; ++k) {
                int nr = r + dr[k];
                int nc = c + dc[k];
                if (0 <= nr && nr < R && 0 <= nc && nc < C && grid[nr][nc] == 1) {
                    grid[nr][nc] = 2;
                    int ncode = nr * C + nc;
                    queue.add(ncode);
                    depth.put(ncode, depth.get(code) + 1);
                    ans = depth.get(ncode);
                }
            }
        }
        for (int[] row: grid) {
            for (int v: row) {
                if (v == 1) {
                    return -1;
                }
            }
        }
        return ans;
    }
}
```
```Python [sol1-Python3]
class Solution:
    def orangesRotting(self, grid: List[List[int]]) -> int:
        R, C = len(grid), len(grid[0])

        # queue - all starting cells with rotting oranges
        queue = collections.deque()
        for r, row in enumerate(grid):
            for c, val in enumerate(row):
                if val == 2:
                    queue.append((r, c, 0))

        def neighbors(r, c) -> (int, int):
            for nr, nc in ((r - 1, c), (r, c - 1), (r + 1, c), (r, c + 1)):
                if 0 <= nr < R and 0 <= nc < C:
                    yield nr, nc

        d = 0
        while queue:
            r, c, d = queue.popleft()
            for nr, nc in neighbors(r, c):
                if grid[nr][nc] == 1:
                    grid[nr][nc] = 2
                    queue.append((nr, nc, d + 1))

        if any(1 in row for row in grid):
            return -1
        return d
```

**复杂度分析**

- 时间复杂度：$O(nm)$
即进行一次广度优先搜索的时间，其中 $n=grid.length$, $m=grid[0].length$ 。

- 空间复杂度：$O(nm)$
需要额外的 $dis$ 数组记录每个新鲜橘子被腐烂的最短时间，大小为 $O(nm)$，且广度优先搜索中队列里存放的状态最多不会超过 $nm$ 个，最多需要 $O(nm)$ 的空间，所以最后的空间复杂度为 $O(nm)$。