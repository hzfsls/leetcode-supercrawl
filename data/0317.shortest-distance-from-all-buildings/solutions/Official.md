## [317.离建筑物最近的距离 中文官方题解](https://leetcode.cn/problems/shortest-distance-from-all-buildings/solutions/100000/chi-jian-zhu-wu-zui-jin-de-ju-chi-by-lee-u22n)
[TOC]
 ## 解决方案

---

 #### 概述
 我们被要求建造一座房子，其到所有其他房子的总行程距离最短。为此，我们必须能够找出两个单元格（一个空地和一座房子）之间的最短距离。这个过程将为每一对空地和房子重复。因此，一个直观的第一步是在不同的向量中记录所有房子（1-值单元格）和空地（0-值单元格）的位置。
 然后，对于每个空地，遍历所有房子，并添加曼哈顿距离：`distance = |x1 - x2| + |y1 - y2|`，其中`(x1, y1)`是空地的坐标，`(x2, y2)`是房子的坐标。
 但是这里的问题是我们有一些被阻碍的单元格。例如，在下面的配置中，公式没有给出P1和P2之间的正确距离。这是因为两点之间有 **障碍物**。

![image.png](https://pic.leetcode.cn/1692244921-ObDRZz-image.png){:width=800}

 由于障碍物阻止我们使用公式，我们将改为对每个单元格执行按层次进行的广度优先搜索（BFS），其中每个级别距离起始单元格（四向遍历）进一步。当我们扩展我们的广度优先搜索时，我们不会访问任何被阻碍的单元格或已经被访问过的单元格。
 <br />
 _我们为什么选择使用 BFS？_
 > 我们的图是不带权重的。我们可以认为每条边的权重都是 1。由于图没有权重，所以可以使用 BFS 来寻找起始单元格和其他可达单元格之间的最短路线。
 > 真实的距离计算以只能水平和垂直移动的网格距离为衡量标准。由于我们只能向上、向下、向左和向右移动，我们可以应用 BFS 来计算实际距离。在 BFS 的每个迭代中，我们将只考虑在水平或垂直方向扩展我们的搜索。

---

 #### 方法 1：从空地到所有房子的 BFS
 **算法简述**
 我们的目标是找到与所有房子总距离最短的空地单元格，因此我们必须先找到从每个空地单元格到所有房子的最短总距离。如前所述，这可以通过 BFS 实现。对于网格中的每个空单元格（单元格值等于 0），开始一个 BFS 并将所有距离到房子（单元格值等于 1）的总和从这个单元格开始。我们也会跟踪我们从这个源单元格（空单元格）达到的房子数量。 如果我们无法从当前的空单元格到达所有的房子，那么它就不是一个有效的空单元格。此外，我们可以确定，在此BFS期间访问过的任何单元格也无法到达所有的房子。所以我们会将此 BFS 期间访问过的所有空地单元格标记为障碍物，以确保我们不会从这个区域开始另一个 BFS。
 **算法**
 1. 对于每个空单元网格（`grid[i][j]` 等于0），开始一个 BFS：  
    - 在 BFS 中，遍历所有 4 方向相邻的非阻塞或未访问的单元格，并跟踪开始单元格的距离。每次迭代使距离增加 1。  
    - 每次达到一家房子时，将房屋达到计数器 `housesReached` 增加 1，并将当前距离（即从开始单元格到房子的距离）增加到总距离 `distanceSum` 中。
    - 如果 `housesReached` 等于 `totalHouses`，则返回总距离。   
    - 否则，起始单元格（及在此BFS过程中访问过的每个单元格）无法到达所有的房子。所以将每个已访问的空地单元格设置为2，以确保我们不会从该单元格开始新的BFS，并返回 `INT_MAX`。 
2. 每次从 BFS 返回总距离时，更新最小距离（`minDistance`）。
3. 如果可以从任何空地单元格到达所有的房子，那么返回找到的最小距离。否则，返回 `-1`。

<![image.png](https://pic.leetcode.cn/1692254297-EvgtZn-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254300-StOMqt-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254302-qunJgH-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254306-MUtdtb-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254308-SjJily-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254310-xgDhdj-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254313-PZVnJB-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254315-jsZFAN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254318-cbejJx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254322-exOinu-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254325-aJeESP-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254328-YcIHxg-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254331-dyYJVk-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254334-FzRUgV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254336-kzaTdt-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254339-HlTtGA-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254342-ZHqINs-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254346-KlHUYc-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254349-GUybNi-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254352-muxUBh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254355-zRGCBP-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254358-XTJlOJ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254361-PnOIFK-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254364-HadpYx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254367-UmDsHj-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254371-TQiMQI-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254374-NCReft-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254377-DSfRxg-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254381-ZiGoOZ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692254384-LRqdSc-image.png){:width=400}>

 **实现**
 ```C++ [solution]
class Solution {
private:
    int bfs(vector<vector<int>>& grid, int row, int col, int totalHouses) {
        // 下一步的四个方向。
        int dirs[4][2] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        
        int rows = grid.size();
        int cols = grid[0].size();
        int distanceSum = 0;
        int housesReached = 0;

        // 用一个队列开始 BFS，从(r,c)单元格开始
        queue<pair<int, int>> q;
        q.push({ row, col });

        // 跟踪访问过的单元格
        vector<vector<bool>> vis(rows, vector<bool> (cols, false));
        vis[row][col] = true;

        int steps = 0;

        while (!q.empty() && housesReached != totalHouses) {
            for (int i = q.size(); i > 0; --i) {
                auto curr = q.front();
                q.pop();

                row = curr.first;
                col = curr.second;

                // 如果此单元格是房屋，则添加从源到此单元格的距离
                // 然后我们从这个单元格经过。
                if (grid[row][col] == 1) {
                    distanceSum += steps;
                    housesReached++;
                    continue;
                }

                // 此单元格为空单元格，因此遍历下一个单元格，这不是阻塞。
                for (auto& dir : dirs) {
                    int nextRow = row + dir[0];
                    int nextCol = col + dir[1];

                    if (nextRow >= 0 && nextCol >= 0 && nextRow < rows && nextCol < cols) {
                        if (!vis[nextRow][nextCol] && grid[nextRow][nextCol] != 2) {
                            vis[nextRow][nextCol] = true;
                            q.push({nextRow, nextCol});
                        }
                    }
                }
            }
            
            // 遍历一级单元格后，将步数加 1 以到达下一级。
            steps++;
        }

        // 如果我们没有到达所有的房子，那么任何被访问的小区也不能到达所有的房子。
        // 将所有已查看的单元格设置为 2，这样我们就不会再次检查它们并返回 INT_MAX。
        if (housesReached != totalHouses) {
            for (row = 0; row < rows; row++) {
                for (col = 0; col < cols; col++) {
                    if (grid[row][col] == 0 && vis[row][col]) {
                        grid[row][col] = 2;
                    }
                }
            }
            return INT_MAX;
        }
        // 如果我们已到达所有房屋，则返回计算出的总距离。
        return distanceSum;
    }

public:
    int shortestDistance(vector<vector<int>>& grid) {
        int minDistance = INT_MAX;
        int rows = grid.size();
        int cols = grid[0].size();
        int totalHouses = 0;

        for (int row = 0; row < rows; ++row) {
            for (int col = 0; col < cols; ++col) {
                if (grid[row][col] == 1) { 
                    totalHouses++;
                }
            }
        }

        // 求出每个空单元格的最小距离和。
        for (int row = 0; row < rows; ++row) {
            for (int col = 0; col < cols; ++col) {
                if (grid[row][col] == 0) {
                    minDistance = min(minDistance, bfs(grid, row, col, totalHouses));
                }
            }
        }

        // 如果不可能从任何空单元格到达所有房屋，则返回 -1。
        if (minDistance == INT_MAX) {
            return -1;
        }
        return minDistance;
    }
};
 ```
```Java [solution]
class Solution {
    private int bfs(int[][] grid, int row, int col, int totalHouses) {
        // 下一步的四个方向。
        int dirs[][] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        
        int rows = grid.length;
        int cols = grid[0].length;
        int distanceSum = 0;
        int housesReached = 0;
        
        // 用一个队列开始 BFS，从(r,c)单元格开始
        Queue<int[]> q = new LinkedList<>();
        q.offer(new int[]{ row, col });
        
        // 跟踪访问过的单元格
        boolean[][] vis = new boolean[rows][cols];
        vis[row][col] = true;

        int steps = 0;
        while (!q.isEmpty() && housesReached != totalHouses) {
            for (int i = q.size(); i > 0; --i) {
                int[] curr = q.poll();
                row = curr[0];
                col = curr[1];
                
                // 如果此单元格是房屋，则添加从源到此单元格的距离
                // 然后我们从这个单元格经过。
                if (grid[row][col] == 1) {
                    distanceSum += steps;
                    housesReached++;
                    continue;
                }
                
                // 此单元格为空单元格，因此遍历下一个单元格，这不是阻塞。
                for (int[] dir : dirs) {
                    int nextRow = row + dir[0]; 
                    int nextCol = col + dir[1];
                    if (nextRow >= 0 && nextCol >= 0 && nextRow < rows && nextCol < cols) {
                        if (!vis[nextRow][nextCol] && grid[nextRow][nextCol] != 2) {
                            vis[nextRow][nextCol] = true;
                            q.offer(new int[]{ nextRow, nextCol });
                        }
                    }
                }
            }
            
            // 遍历一级单元格后，将步数加 1 以到达下一级。
            steps++;
        }

        // 如果我们没有到达所有的房子，那么任何被访问的小区也不能到达所有的房子。
        // 将所有已查看的单元格设置为 2，这样我们就不会再次检查它们并返回 MAX_VALUE。
        if (housesReached != totalHouses) {
            for (row = 0; row < rows; row++) {
                for (col = 0; col < cols; col++) {
                    if (grid[row][col] == 0 && vis[row][col]) {
                        grid[row][col] = 2;
                    }
                }
            }
            return Integer.MAX_VALUE;
        }
        
        // 如果我们已到达所有房屋，则返回计算出的总距离。
        return distanceSum;
    }
    
    public int shortestDistance(int[][] grid) {
        int minDistance = Integer.MAX_VALUE;
        int rows = grid.length; 
        int cols = grid[0].length;
        int totalHouses = 0;
        
        for (int row = 0; row < rows; ++row) {
            for (int col = 0; col < cols; ++col) {
                if (grid[row][col] == 1) {
                    totalHouses++;
                }
            }
        }
        
        // 求出每个空单元格的最小距离和。
        for (int row = 0; row < rows; ++row) {
            for (int col = 0; col < cols; ++col) {
                if (grid[row][col] == 0) {
                    minDistance = Math.min(minDistance, bfs(grid, row, col, totalHouses));
                }
            }
        }
        
        // 如果不可能从任何空单元格到达所有房屋，则返回 -1。
        if (minDistance == Integer.MAX_VALUE) {
            return -1;
        }
        
        return minDistance;
    }
};
```
```JavaScript [solution]
// 下一步的四个方向。
let dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];

// BFS 函数从(row, col)开始 BFS。
let bfs = (grid, row, col, totalHouses) => {
    let rows = grid.length;
    let cols = grid[0].length;
    let distanceSum = 0;
    let housesReached = 0;
    
    // 用一个队列开始 BFS，从(r,c)单元格开始
    let queue = [[ row, col ]];
    
    // 跟踪访问过的单元格
    let vis = new Array(rows).fill(false).map(() => new Array(cols).fill(false));
    vis[row][col] = true;
    
    let steps = 0;
    
    while (queue.length && housesReached != totalHouses) {
        // 记录我们将在下一级别中探索的单元格
        let next_queue = [];
        for (let i = 0; i < queue.length; i++) {
            let curr = queue[i];
            row = curr[0];
            col = curr[1];
            
            // 如果此单元格是房屋，则添加从源到此单元格的距离
            // 然后我们从这个单元格经过。
            if (grid[row][col] == 1) {
                distanceSum += steps;
                housesReached++;
                continue;
            }
            
            // 这个单元格是空的单元格，因此遍历下一个单元格，这不是阻塞。
            dirs.forEach((dir) => {
                let nextRow = row + dir[0];
                let nextCol = col + dir[1];
                if (nextRow >= 0 && nextCol >= 0 && nextRow < rows && nextCol < cols) {
                    if (!vis[nextRow][nextCol] && grid[nextRow][nextCol] != 2) {
                        vis[nextRow][nextCol] = true;
                        next_queue.push([nextRow, nextCol]);
                    }
                }
            });
        }
        
        // 将队列设置为等于下一级队列。
        queue = next_queue;
        // 遍历一级单元格后，将步数加1以到达下一级。
        steps++;
    }
    
    // 如果我们没有到达所有的房子，那么任何被访问的小区也不能到达所有的房子。
    // 将所有已查看的单元格设置为 2，这样我们就不会再次检查它们并返回 MAX_VALUE
    if (housesReached != totalHouses) {
        for (let row = 0; row < rows; row++) {
            for (let col = 0; col < cols; col++) {
                if (grid[row][col] == 0 && vis[row][col]) {
                    grid[row][col] = 2;
                }
            }
        }
        return Number.MAX_VALUE;
    }
    
    // 如果我们已到达所有房屋，则返回计算出的总距离。
    return distanceSum;
};

let shortestDistance = function (grid) {
    let minDistance = Number.MAX_VALUE;
    let rows = grid.length;
    let cols = grid[0].length;
    let totalHouses = 0;
    
    for (let row = 0; row < rows; ++row) {
        for (let col = 0; col < cols; ++col) {
            if (grid[row][col] == 1) {
                totalHouses++;
            }
        }
    }
    
    // 求出每个空单元格的最小距离和。
    for (let row = 0; row < rows; ++row) {
        for (let col = 0; col < cols; ++col) {
            if (grid[row][col] == 0) {
                minDistance = Math.min(minDistance, bfs(grid, row, col, totalHouses));
            }
        }
    }
    
    // 如果不可能从任何空单元格到达所有房屋，则返回 -1。
    if (minDistance == Number.MAX_VALUE) {
        return -1;
    }
    return minDistance;
};
```


 **复杂度分析**
 令 $N$ 和 $M$ 分别为 `grid`中的行数和列数。
 -  时间复杂度： $O(N^2 \cdot M^2)$。
    对于每块空地，我们都会遍历所有其他的房子。这将需要 $O($零的数量 $\cdot$ 一的数量$)$ 的时间，矩阵中零和一的数量的顺序为 $N \cdot M$。考虑到当网格中的值有一半是 0，一半是 1 时，网格中的总元素数将是 $(M \cdot N)$，所以它们的数量分别是 $(M \cdot N)/2$ 和 $(M \cdot N)/2$，因此时间复杂度为 $(M \cdot N)/2 \cdot (M \cdot N)/2$，也就是 $O(N^2 \cdot M^2)$。
> 在 JavaScript 实现中，为了简单起见，我们使用了一个数组来做队列。 
> 但是，从数组的前端弹出元素是一个 O(n) 操作，这是我们不希望的。 
> 所以，我们将不会从 `queue` 的前端弹出，而是迭代遍历 `queue`，并在 `next_queue` 中记录下一级需要探索的单元格。 
> 一旦当前的 `queue`被遍历完，我们就将 `queue` 设置为 `next_queue`。
>  -  空间复杂度： $O(N \cdot M)$。
> 我们使用一个额外的矩阵来跟踪被访问过的单元格，队列在每次 BFS 调用中最多会存储每个矩阵元素一次。因此，需要 $O(N \cdot M)$ 的空间。

---

 #### 方法 2：从房屋到空地的 BFS
 **算法简述**
 在之前的方法中，为了获得最小距离，我们从每个空地（单元格值等于 0）开始做 BFS 来寻找所有的房子（单元格值等于 1），但是另一种解决问题的方法是从一个房子开始并找出所有可达的空地。
 如果我们能够从一个空地到达一栋房子，那么我们也可以反过来（即从一栋房子到达空地）。
 当有比空地少的房子时，这种方法将比之前的方法需要更少的时间，反之亦然。虽然平均来看，这种方法并没有改善之前的方法，但它将作为一个心理踏脚石，帮助我们更好地理解第三种方法 。
 以前，我们在一个 BFS 遍历中计算一个空单元格的总最小距离和，因此我们只是从每个单元格的 BFS 函数中返回距离和。但是，如果我们从一栋房子而不是一个空单元格开始 BFS，我们将会生成部分距离（即从只有一栋房子到当前单元格的距离，而不是从所有房子到这个空单元格的和距离），因此我们需要一些额外的空间来存储来自每栋房子单元格的部分距离的和。

 我们需要在每个空单元格的位置存储 2 个值：从所有房子到这片空地的总距离和和能够到达这片空地的房子的数量。
 **算法**
 1. 对于每个房子单元格（`grid[i][j]` 等于 1），开始 BFS：  
    - 对于我们到达的每个空单元格，将步骤数增加到该单元格的距离总和中。
    - 对于我们到达的每个空单元格，也将该单元格的房屋计数器增加 1。 
 2. 遍历所有房子后，从所有 `housesReached` 等于 `totalHouses` 的空单元格中获取最小距离。
 3. 如果所有房屋能够到达一个指定的空地单元格，则返回找到的最小距离。否则，返回 `-1`。

<![image.png](https://pic.leetcode.cn/1692256415-VJbJGb-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256419-eAsotQ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256445-OhGtZc-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256447-AfbddT-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256449-ggjhaO-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256452-vLFGzC-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256454-yOipMM-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256457-JsTgfB-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256459-WyUfij-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256462-hFHgfk-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256466-azOqsb-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256468-OzyyWb-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256470-amOoEe-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256474-aLigKT-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256476-gnhRia-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256478-FDQMjy-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256481-rStWOP-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256484-joKEeH-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256487-BoQDKu-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256489-YfEKXw-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256492-IBmmUC-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256495-clbVcr-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256499-IoJWwg-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256501-ytyvAA-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256503-vXxLQn-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256507-yVooEy-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256510-caYBvw-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256513-aeFVKC-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256516-dRvcva-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692256519-YUFXRL-image.png){:width=400}>

 <br />
 **实现**
 ```C++ [solution]
class Solution {
private:
    void bfs(vector<vector<int>>& grid, vector<vector<vector<int>>>& distances, int row, int col) {
        int dirs[4][2] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        
        int rows = grid.size(), cols = grid[0].size();
        
        // 用一个队列开始 BFS，从(r,c)单元格开始
        queue<pair<int, int>> q;
        q.push({ row, col });
        
        // 跟踪访问过的单元格。
        vector<vector<bool>> vis (rows, vector<bool>(cols, false));
        vis[row][col] = true;
        
        int steps = 0;
        
        while (!q.empty()) {
            for (int i = q.size(); i > 0; --i) {
                auto curr = q.front();
                q.pop();
                row = curr.first;
                col = curr.second;
                
                // 如果我们到达一个空单元格，则添加距离并递增到达该单元格的房屋计数。
                if (grid[row][col] == 0) {
                    distances[row][col][0] += steps;
                    distances[row][col][1] += 1;
                }
                
                // 穿过下一个不是障碍的单元格。
                for (auto& dir : dirs) {
                    int nextRow = row + dir[0];
                    int nextCol = col + dir[1];
                    if (nextRow >= 0 && nextCol >= 0 && nextRow < rows && nextCol < cols) {
                        if (!vis[nextRow][nextCol] && grid[nextRow][nextCol] == 0) {
                            vis[nextRow][nextCol] = true;
                            q.push({ nextRow, nextCol });
                        }
                    }
                }
            }
            
            // 遍历一级单元格后，步数递增 1。
            steps++;
        }
    }
    
public:
    int shortestDistance(vector<vector<int>>& grid) {
        int minDistance = INT_MAX;
        int rows = grid.size();
        int cols = grid[0].size();
        int totalHouses = 0;
        
        // 存储每个单元格的{ total_dist, houses_count }
        vector<vector<vector<int>>> distances (rows, vector<vector<int>> (cols, {0, 0}));
        
        // 计数房屋，并从每一栋房子开始 BFS。
        for (int row = 0; row < rows; ++row) {
            for (int col = 0; col < cols; ++col) {
                if (grid[row][col] == 1) {
                    totalHouses++;
                    bfs(grid, distances, row, col);
                }
            }
        }
        
        // 检查所有房屋数量等于房屋总数的空地，找出最小数量。
        for (int row = 0; row < rows; ++row) {
            for (int col = 0; col < cols; ++col) {
                if (distances[row][col][1] == totalHouses) {
                    minDistance = min(minDistance, distances[row][col][0]);
                }
            }
        }
        
        // 如果没有找到有效的单元格，则返回 -1。
        if (minDistance == INT_MAX) {
            return -1;
        }
        return minDistance;
    }
};
 ```
```Java [solution]
class Solution {
    private void bfs(int[][] grid, int[][][] distances, int row, int col) {
        int dirs[][] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        
        int rows = grid.length;
        int cols = grid[0].length;

        // 用一个队列开始 BFS，从(r,c)单元格开始。
        Queue<int[]> q = new LinkedList<>();
        q.offer(new int[]{ row, col });

        // 跟踪访问过的单元格。
        boolean[][] vis = new boolean[rows][cols];
        vis[row][col] = true;

        int steps = 0;

        while (!q.isEmpty()) {
            for (int i = q.size(); i > 0; --i) {
                int[] curr = q.poll();
                row = curr[0];
                col = curr[1];

                // 如果我们到达一个空单元格，则添加距离并递增到达该单元格的房屋计数。
                if (grid[row][col] == 0) {
                    distances[row][col][0] += steps;
                    distances[row][col][1] += 1;
                }

                // 穿过下一个不是障碍的单元格。
                for (int[] dir : dirs) {
                    int nextRow = row + dir[0];
                    int nextCol = col + dir[1];

                    if (nextRow >= 0 && nextCol >= 0 && nextRow < rows && nextCol < cols) {
                        if (!vis[nextRow][nextCol] && grid[nextRow][nextCol] == 0) {
                            vis[nextRow][nextCol] = true;
                            q.offer(new int[]{ nextRow, nextCol });
                        }
                    }
                }
            }

            // 遍历一级单元格后，步数递增 1。
            steps++;
        }
    }

    public int shortestDistance(int[][] grid) {
        int minDistance = Integer.MAX_VALUE;
        int rows = grid.length;
        int cols = grid[0].length;
        int totalHouses = 0;

        // 存储每个单元格的{ total_dist, houses_count }
        int[][][] distances = new int[rows][cols][2];

        // 计数房屋，并从每一栋房子开始 BFS。
        for (int row = 0; row < rows; ++row) {
            for (int col = 0; col < cols; ++col) {
                if (grid[row][col] == 1) {
                    totalHouses++;
                    bfs(grid, distances, row, col);
                }
            }
        }

        // 检查所有房屋数量等于房屋总数的空地，找出最小数量。
        for (int row = 0; row < rows; ++row) {
            for (int col = 0; col < cols; ++col) {
                if (distances[row][col][1] == totalHouses) {
                    minDistance = Math.min(minDistance, distances[row][col][0]);
                }
            }
        }

        // 如果没有找到有效的单元格，则返回-1。
        if (minDistance == Integer.MAX_VALUE) {
            return -1;
        }
        return minDistance;
    }
};
```
```JavaScript [solution]
let dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];

let bfs = function (grid, distances, row, col) {
    let rows = grid.length;
    let cols = grid[0].length;

    // 用一个队列开始 BFS，从(r,c)单元格开始。
    let queue = [[ row, col ]];

    // 跟踪访问过的单元格
    let vis = new Array(rows).fill(false).map(() => new Array(cols).fill(false));
    vis[row][col] = true;

    let steps = 0;

    while (queue.length) {
        // 记录我们将在下一级别中探索的单元格
        let next_queue = [];

        for (let i = 0; i < queue.length; i++) {
            let curr = queue[i];

            row = curr[0];
            col = curr[1];

            // 如果我们到达一个空单元格，则添加距离并递增到达该单元格的房屋计数。
            if (grid[row][col] == 0) {
                distances[row][col][0] += steps;
                distances[row][col][1]++;
            }

            // 穿过下一个不是障碍的单元格。
            dirs.forEach((dir) => {
                let nextRow = row + dir[0];
                let nextCol = col + dir[1];

                if (nextRow >= 0 && nextCol >= 0 && nextRow < rows && nextCol < cols) {
                    if (!vis[nextRow][nextCol] && grid[nextRow][nextCol] == 0) {
                        vis[nextRow][nextCol] = true;
                        next_queue.push([nextRow, nextCol]);
                    }
                }
            });
        }
        
        // 将队列设置为等于下一级队列。
        queue = next_queue;
        // 遍历一级单元格后，步数递增 1。
        steps++;
    }
};

let shortestDistance = function (grid) {
    let minDistance = Number.MAX_VALUE;
    let rows = grid.length;
    let cols = grid[0].length;
    let totalHouses = 0;

    // 存储每个单元格的{ total_dist, houses_count }
    let distances = new Array(rows).fill(0).map(() => new Array(cols).fill(0).map(() => new Array(2).fill(0)));

    // 计数房屋，并从每一栋房子开始 BFS。
    for (let row = 0; row < rows; ++row) {
        for (let col = 0; col < cols; ++col) {
            if (grid[row][col] == 1) {
                totalHouses++;
                bfs(grid, distances, row, col);
            }
        }
    }

    // 检查所有房屋数量等于房屋总数的空地，找出最小数量。
    for (let row = 0; row < rows; ++row) {
        for (let col = 0; col < cols; ++col) {
            if (distances[row][col][1] == totalHouses) {
                minDistance = Math.min(minDistance, distances[row][col][0]);
            }
        }
    }

    // 如果没有找到有效的单元格，则返回-1。
    if (minDistance == Number.MAX_VALUE) {
        return -1;
    }
    return minDistance;
};
```


 **复杂度分析**
 令 $N$ 和 $M$ 分别为 `grid`中的行数和列数。
 -  时间复杂度： $O(N^2 \cdot M^2)$。
    对于每栋房子，我们将遍历所有能够到达的空地。这将需要 $O($零的数量 $\cdot$ 一的数量 $)$ 的时间，矩阵中零和一的数量的顺序为 $N \cdot M$。  考虑到当网格中的值有一半是0，一半是1时，网格中的总元素数将是 $(M \cdot N)$，所以它们的数量分别是 $(M \cdot N)/2$ 和 $(M \cdot N)/2$，这将导致时间复杂度为 $(M \cdot N)/2 \cdot (M \cdot N)/2$，也就是 $O(N^2 \cdot M^2)$。
 > 在 JavaScript 实现中，为了简单起见，我们使用了一个数组来做队列。
 > 然而，从数组的前端弹出元素是一个 O(n) 操作，这是我们不希望的。 
 > 所以，我们将不会从 `queue` 的前端开始弹出，而是迭代遍历 `queue`，并在 `next_queue` 中记录下一级需要探索的单元格。
 > 一旦当前的 `queue`被遍历完，我们就将 `queue` 设置为 `next_queue`。
 >  -  空间复杂度：$O(N \cdot M)$。
 > 我们使用一个额外的矩阵来跟踪被访问过的单元格，另一个用来存储每个空单元格的距离和和房屋计数器，队列在每次 BFS 调用中最多会存储每个矩阵元素一次。因此，需要 $O(N \cdot M)$ 的空间。
 >  <br/>

---

 #### 方法 3：从房屋到空地的 BFS (优化)
 **算法简述**
 我们可以使用输入网格矩阵来跟踪被访问过的单元格，而不是每次都生成一个新的矩阵。 在第一次 BFS 中，我们可以将被访问过的空地值从 `0` 更改为 `-1`。然后在下一个 BFS 中，我们只会访问值为 `-1` 的空地，然后将 `-1` 改为 `-2`，然后在下一个 BFS 中，只对 `-2` 进行操作，依此类推......
 这种方法允许我们避免访问任何不能到达所有房子的单元格。
 我们是否也可以使用这种在空地值中的递减来表示该单元格已被访问过呢？
 > 想象一下，我们现在在单元格 `(2, 3)`，值为 `-1`，我们将其值改为 `-2`。 
 > 在队列中，下一个元素是 `(2, 4)`，它的值也是 `-1`，我们将其值改为 `-2`。在从 `(2, 4)` 探讨路径时，我们看到单元格 `(2, 3)` 是相邻的，并且具有值 `-2`。然而，目前，我们只检查具有 `-1` 值的单元格。因此，`(2, 3)` 不会再次被插入到队列中，所以这个递减的值可以用作已访问单元格的检查，因为当一个单元格被访问时，那么它的值将会减少 1，并且它将不满足插入到队列的条件。
 > 如果在先前的迭代中，有一个空土地单元格不可达，那么它的值并没有减少，因此在从另一个房子单元格开始 BFS 时，我们不会将该单元格插入到队列中。因此，这种方法剪去了许多迭代，节省了一些时间，因为我们不需要为每次 BFS 调用创建一个新的矩阵来追踪访问过的单元格。

<![image.png](https://pic.leetcode.cn/1692257202-bCSHUO-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692257206-GiDpAv-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692257209-qTAbrn-image.png){:width=400}>

 **算法**
 1. 对于每个 `grid[i][j]` 值等于1的位置，开始 BFS。在 BFS 期间：  
    - 所有 4 方向相邻的网格单元格，只有值等于 `emptyLandValue` 才有效。 
    - 逐个访问它们，并将这些单元格的距离存储在 `total` 矩阵中。
    - 将访问过的单元格的值减少1。 
 2. 每个 BFS 遍历结束后，将 `emptyLandValue` 减少 1。
 3. 在我们开始对一个房子做 BFS 调用之前，我们将 `minDist` 设置为 `INT_MAX`。
 4. 然后我们将遍历所有值等于 `emptyLandValue` 的空地单元格
 5. 在最后一个 BFS 遍历结束后，如果最小距离等于 `INT_MAX`，那么就没有任何单元格能够被所有的房子到达，所以返回 `-1`。
 6. 否则，返回最小距离 `minDist`。

<![image.png](https://pic.leetcode.cn/1692258977-GvDhvk-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692258980-OBTFsV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692258983-tyBXBM-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692258985-nNtRPY-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692258988-aEaTyw-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692258990-oJILSh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692258992-wFAJNY-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692258995-UgexeR-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692258998-rbUoSd-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692259000-SVPJTC-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692259004-RFETEa-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692259007-PbHMZx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692259010-xicESb-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692259012-mWhAQS-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692259016-tntASp-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692259018-WkELkO-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692259021-EPYEaP-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692259023-gPebiQ-image.png){:width=400}>

 **实现**
 ```C++ [solution]
class Solution {
public:
    int shortestDistance(vector<vector<int>>& grid) {
        // 下一步的四个方向。
        int dirs[4][2] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        
        int rows = grid.size();
        int cols = grid[0].size();
        
        // Total Mtrix用于存储每个空单元格的总距离和。
        vector<vector<int>> total(rows, vector<int> (cols, 0));

        int emptyLandValue = 0;
        int minDist = INT_MAX;

        for (int row = 0; row < rows; ++row) {
            for (int col = 0; col < cols; ++col) {

                // 从每一个房子开始 BFS
                if (grid[row][col] == 1) {
                    minDist = INT_MAX;

                    // 使用队列从位于(row,col)的单元格开始执行 BFS。
                    queue<pair<int, int>> q;
                    q.push({ row, col });
                    
                    int steps = 0;

                    while (!q.empty()) {
                        steps++;

                        for (int level = q.size(); level > 0; --level) {
                            auto curr = q.front();
                            q.pop();

                            for (auto& dir : dirs) {
                                int nextRow = curr.first + dir[0];
                                int nextCol = curr.second + dir[1];

                                // 对于每个值等于空地价值的单元格
                                // 添加距离并将单元格值减去1。
                                if (nextRow >= 0 && nextRow < rows &&
                                    nextCol >= 0 && nextCol < cols &&
                                    grid[nextRow][nextCol] == emptyLandValue) {
                                    grid[nextRow][nextCol]--;
                                    total[nextRow][nextCol] += steps;

                                    q.push({ nextRow, nextCol });
                                    minDist = min(minDist, total[nextRow][nextCol]);
                                }
                            }
                        }
                    }

                    // 递减要在下一次迭代中搜索的空地值。
                    emptyLandValue--;
                }
            }
        }

        return minDist == INT_MAX ? -1 : minDist;
    }
};
 ```
```Java [solution]
class Solution {
    public int shortestDistance(int[][] grid) {
        // 下一步的四个方向。
        int dirs[][] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        
        int rows = grid.length;
        int cols = grid[0].length;
        
        // Total Mtrix用于存储每个空单元格的总距离和。
        int[][] total = new int[rows][cols];

        int emptyLandValue = 0;
        int minDist = Integer.MAX_VALUE;

        for (int row = 0; row < rows; ++row) {
            for (int col = 0; col < cols; ++col) {

                // 从每一个房子开始 BFS
                if (grid[row][col] == 1) {
                    minDist = Integer.MAX_VALUE;

                    // 使用队列从位于(row,col)的单元格开始执行 BFS。
                    Queue<int[]> q = new LinkedList<>();
                    q.offer(new int[]{ row, col });

                    int steps = 0;

                    while (!q.isEmpty()) {
                        steps++;

                        for (int level = q.size(); level > 0; --level) {
                            int[] curr = q.poll();

                            for (int[] dir : dirs) {
                                int nextRow = curr[0] + dir[0];
                                int nextCol = curr[1] + dir[1];

                                // 对于每个值等于空地价值的单元格
                                // 添加距离并将单元格值减去1。
                                if (nextRow >= 0 && nextRow < rows &&
                                    nextCol >= 0 && nextCol < cols &&
                                    grid[nextRow][nextCol] == emptyLandValue) {
                                    grid[nextRow][nextCol]--;
                                    total[nextRow][nextCol] += steps;

                                    q.offer(new int[]{ nextRow, nextCol });
                                    minDist = Math.min(minDist, total[nextRow][nextCol]);
                                }
                            }
                        }
                    }

                    // 递减要在下一次迭代中搜索的空地值。
                    emptyLandValue--;
                }
            }
        }

        return minDist == Integer.MAX_VALUE ? -1 : minDist;
    }
}
```
```JavaScript [solution]
// 下一步的四个方向。
let dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];

// 使用链表实现的队列。
class Node {
    constructor(row, col) {
        this.row = row;
        this.col = col;
        this.prev = null;
        this.next = null;
    }
}

class QueueClass {
    constructor() {
        this.head = null;
        this.tail = null;
        this.length = 0;
    }

    length() {
        return this.length;
    }

    push(row, col) {
        const newNode = new Node(row, col);

        if (this.head == null) {
            this.head = newNode;
            this.tail = newNode;
        } 
        else {
            this.tail.next = newNode;
            newNode.prev = this.tail;
            this.tail = newNode;
        }

        this.length++;
    }

    pop() {
        if (this.head == null) return null;

        // 获取弹出的节点
        const popped = this.head;

        // 将 newHead 保存到变量(可以为空)。
        const newHead = this.head.next;

        // 如果 newHead 非空。
        if (newHead) {
            newHead.prev = null;
            this.head.next = null;
        } 
        
        else {
            // 在 newHead 为空的情况下更改 tail。
            this.tail = null;
        }

        // 分配新的尾部(可以为空)。
        this.head = newHead;

        // 递减长度。
        this.length--;
        return popped;
    }
    
    empty() {
        return this.length == 0;
    }
}

let shortestDistance = function (grid) {
    let minDistance = Number.MAX_VALUE;
    let rows = grid.length;
    let cols = grid[0].length;

    // Total Mtrix用于存储每个空单元格的总距离和。
    let total = new Array(rows).fill(0).map(() => new Array(cols).fill(0));

    let emptyLandValue = 0;
    let minDist = Number.MAX_VALUE;

    for (let row = 0; row < rows; ++row) {
        for (let col = 0; col < cols; ++col) {
            
            // 从每一个房子开始 BFS
            if (grid[row][col] == 1) {
                minDist = Number.MAX_VALUE;

                // 使用队列从位于(row,col)的单元格开始执行 BFS。
                let q = new QueueClass();
                q.push(row, col);

                let steps = 0;

                while (!q.empty()) {
                    steps++;

                    for (let level = q.length; level > 0; --level) {
                        let curr = q.pop();

                        dirs.forEach((dir) => {
                            let nextRow = curr.row + dir[0];
                            let nextCol = curr.col + dir[1];

                            // 对于每个值等于空地价值的单元格
                            // 添加距离并将单元格值减去1。
                            if (nextRow >= 0 && nextRow < rows &&
                                nextCol >= 0 && nextCol < cols &&
                                grid[nextRow][nextCol] == emptyLandValue) {
                                grid[nextRow][nextCol]--;
                                total[nextRow][nextCol] += steps;

                                q.push(nextRow, nextCol);
                                minDist = Math.min(minDist, total[nextRow][nextCol]);
                            }
                        });
                    }
                }

                // 递减要在下一次迭代中搜索的空地值。
                emptyLandValue--;
            }
        }
    }

    return minDist == Number.MAX_VALUE ? -1 : minDist;
};
```


 **复杂度分析**
 令 $N$ 和 $M$ 分别为 `grid` 中的行数和列数。
 -  时间复杂度：$O(N^2 \cdot M^2)$。
    对于每栋房子，我们将遍历所有能够到达的空地。这将需要 $O($零的数量 $\cdot$ 一的数量 $)$ 的时间，矩阵中零和一的数量的顺序为 $N \cdot M$。  考虑到当网格中的值有一半是 0，一半是 1 时，网格中的总元素数将是 $(M \cdot N)$，所以它们的数量分别是 $(M \cdot N)/2$ 和 $(M \cdot N)/2$ ，这将导致时间复杂度为 $(M \cdot N)/2 \cdot (M \cdot N)/2$，也就是 $O(N^2 \cdot M^2)$。
 -  空间复杂度：$O(N \cdot M)$。
    我们使用一个额外的矩阵来存储距离和，队列在每次 BFS 调用中最多会存储每个矩阵元素一次。因此，需要 $O(N \cdot M)$ 的空间。


---