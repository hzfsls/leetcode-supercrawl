[TOC]

## 解决方案

---

#### 概览

这个问题有两个部分

1. 找到每一个岛屿。我们可以使用一个简单的深度优先搜索（DFS）来完成这个任务。
2. 判断两个岛屿是否相同。这个部分更难，是本篇文章的关注点。

---

#### 方法 1：暴力解决

 **概述**
 假设我们已经使用 DFS 创建了一个岛屿列表，每个岛屿以坐标列表的形式表示。现在我们需要确定这些岛屿中有多少个实际上形状唯一。
 由于如果一个岛屿可以被平移到另一个岛屿，那么这两个岛屿就是相同的，所以我们可以将每个岛屿平移到其可能的最左上角的位置。通过这样做，同样形状但在不同位置的两个岛屿现在将具有相同的坐标。例如，如果一个岛屿是由单元 `[(2, 1), (3, 1), (1, 2), (2, 2)]` 组成的，当其定位在左上角时，它会变成 `[(1, 0), (2, 0), (0, 1), (1,1)]`。

 ![image_1.png](https://pic.leetcode.cn/1692178846-UUUkve-image_1.png){:width=400}

 同样，由单元 `[(2, 0), (3, 0), (1, 1), (2, 1)]` 组成的岛屿也会变成 `[(1, 0), (2, 0), (0, 1), (1,1)]`。  

 ![image_2.png](https://pic.leetcode.cn/1692178846-QGVtdt-image_2.png){:width=400}

 **算法步骤**

 1. 使用 DFS 创建一个岛屿列表，每个岛屿都是一个坐标列表。
 2. 初始化一个 “count” 来计算唯一岛屿的数量为 0。
 3. 对于每个岛屿，逐单元地与其他所有岛屿进行比较。如果发现它是唯一的，则将 “count” 加 1。
 4. 返回 “count” 的值。

 顺序不重要，所以两个岛屿 `[(0, 1), (0, 2)]` 和 `[(0, 2), (0, 1)]` 应被认为是相同的。然而，我们可以避免需要担心顺序的问题，通过确保相同形状的两个岛屿最初都是从相同的相对单元格发现的。然后从那里，DFS 将会总是按照相同的相对顺序访问单元格。这很容易做：我们只需通过从左到右、从上到下进行迭代来搜索岛屿。这样，每个岛屿都会始终从其顶行的最左侧单元格发现。下面的图表显示了使用这个遍历顺序找到的每个岛屿的第一个单元格。注意，相同形状的岛屿是首先从同一相对单元格发现的。

 ![image_3.png](https://pic.leetcode.cn/1692178846-dsHkKB-image_3.png){:width=400}

 我们还可以做一个其他聪明的观察：我们可以简单地将每个岛屿平移，使得 *岛屿上发现的第一个单元格在 `(0, 0)`*。例如，如果一个岛屿包含单元格 `[(2, 3), (2, 4), (2, 5), (3, 5)]`，我们可以从每个单元格中减去 `(2, 3)`，得到 `[(0, 0), (0, 1), (0, 2), (1, 2)]`。

 ```Java [slu1]
 class Solution {

    private List<List<int[]>> uniqueIslands = new ArrayList<>(); // 所有已知的不同岛屿
    private List<int[]> currentIsland = new ArrayList<>(); // 当前岛
    private int[][] grid; // 输入 grid
    private boolean[][] seen; // 被访问过的单元格
     
    public int numDistinctIslands(int[][] grid) {   
        this.grid = grid;
        this.seen = new boolean[grid.length][grid[0].length];   
        for (int row = 0; row < grid.length; row++) {
            for (int col = 0; col < grid[0].length; col++) {
                dfs(row, col);
                if (currentIsland.isEmpty()) {
                    continue;
                }
                // 把我们刚发现的岛平移到左上角。
                int minCol = grid[0].length - 1;
                for (int i = 0; i < currentIsland.size(); i++) {
                    minCol = Math.min(minCol, currentIsland.get(i)[1]);
                }
                for (int[] cell : currentIsland) {
                    cell[0] -= row;
                    cell[1] -= minCol;
                }
                // 如果这个岛是不同的，就把它添加到列表中。
                if (currentIslandUnique()) {
                    uniqueIslands.add(currentIsland);
                }
                currentIsland = new ArrayList<>();
            }
        }
        return uniqueIslands.size();
    }
    
    private void dfs(int row, int col) {
        if (row < 0 || col < 0 || row >= grid.length || col >= grid[0].length) return;
        if (seen[row][col] || grid[row][col] == 0) return;
        seen[row][col] = true;
        currentIsland.add(new int[]{row, col});
        dfs(row + 1, col);
        dfs(row - 1, col);
        dfs(row, col + 1);
        dfs(row, col - 1);
    }
    
    private boolean currentIslandUnique() {
        for (List<int[]> otherIsland : uniqueIslands) {
            if (currentIsland.size() != otherIsland.size()) continue;
            if (equalIslands(currentIsland, otherIsland)) {
                return false;
            }
        }
        return true;
    }
    
    private boolean equalIslands(List<int[]> island1, List<int[]> island2) {
        for (int i = 0; i < island1.size(); i++) {
            if (island1.get(i)[0] != island2.get(i)[0] || island1.get(i)[1] != island2.get(i)[1]) {
                return false;
            }
        }
        return true;
    }
}
 ```

 ```Python3 [slu1]
 class Solution:
    def numDistinctIslands(self, grid: List[List[int]]) -> int:
        
        def current_island_is_unique():
            for other_island in unique_islands:
                if len(other_island) != len(current_island):
                    continue
                for cell_1, cell_2 in zip(current_island, other_island):
                    if cell_1 != cell_2:
                        break
                else:
                    return False
            return True
            
        # 执行 DFS 以查找当前岛中的所有单元。
        def dfs(row, col):
            if row < 0 or col < 0 or row >= len(grid) or col >= len(grid[0]):
                return
            if (row, col) in seen or not grid[row][col]:
                return
            seen.add((row, col))
            current_island.append((row - row_origin, col - col_origin))
            dfs(row + 1, col)
            dfs(row - 1, col)
            dfs(row, col + 1)
            dfs(row, col - 1)
        
        # 只要还有岛屿，就重复启动 DFS。
        seen = set()
        unique_islands = []
        for row in range(len(grid)):
            for col in range(len(grid[0])):
                current_island = []
                row_origin = row
                col_origin = col
                dfs(row, col)
                if not current_island or not current_island_is_unique():
                    continue
                unique_islands.append(current_island)
        print(unique_islands)
        return len(unique_islands)
 ```

 **复杂度分析**

 * 时间复杂度：$O(M^2 \cdot N^2)$。
    在最糟糕的情况下，我们会有一个大的网格，其中有许多相同大小的独特岛屿，岛屿之间尽可能地靠得紧密。这意味着对于我们发现的每一个岛屿，我们都要循环的查看我们到目前为止发现的其他所有岛屿的所有单元格。例如，这是一个 $M = 10$，$N = 10$，以及所有岛屿都有 5 个大小的网格。

  ![image_4.png](https://pic.leetcode.cn/1692178846-ltobCN-image_4.png){:width=400}

  使用这个方法进行详细的分析远远超出了 LeetCode 和面试的范围。所以接下来的讨论是对你需要调查的关键思路的非正式介绍，以便证明时间复杂度，仅供参考。
  由方形单元格连接而成的形状被称为 polyominos。多形状被分组到特定大小的集合中。例如，所有由5个方形单元格（就像上面的例子中的那样）组成的多形状被称为 pentominoes。
  最糟糕的情况是使用最小的可能的多形状大小，以允许至少用所有独特的岛屿覆盖至少一半的网格。这最大化了我们必须在岛屿列表中重复迭代的次数。
  那么，每种大小的多形状有多少呢？[OEIS:A001168](https://oeis.org/A001168) 给出了答案。正如你看到的，这是一个非常快增长的序列——有 $36446$ 个等于 $10$ 的 polyominos！只是看看这个，你可以希望看到，随着我们想要放入岛屿的网格的大小的增长，我们需要使用的岛屿的大小增长 *非常* 慢！这相对较小的大小最大化了我们需要反复对岛列表进行迭代的次数。
 * 空间复杂度：$O(N \cdot M)$。
    `seen` 集需要 $O(N \cdot M)$ 的内存。此外，每个有陆地的单元格需要在 `islands` 数组中使用 $O(1)$ 的空间。

---

 #### 方法 2：根据本地坐标哈希

 **概述**

 前一个方法 *效率低下*，因为确定一个岛屿是否唯一的操作需要循环遍历所有到目前为止发现的每一个岛屿的每一个坐标。
 如果我们通过循环遍历坐标去比较岛屿，我们可以简单地为每个岛屿计算一个 **哈希**，以确保两个相同的岛屿有着相同的哈希值。然后这些哈希值可以放入一个哈希集。因为集合不存储重复数据，所以完成后哈希集中的岛屿数量就是唯一岛屿的数量。
 > **建议**：或许你会对这个方法感到疑惑？如果你对哈希算法没有太多经验，那么你不大可能自己想出这个方法。哈希法是降低时间复杂度的一种非常强大的技术，并且是设计许多领域的复杂现实世界算法的重要部分，比如人工智能。

 **实现**

 实现这个方法的最佳方式取决于语言。
 在 Java 中，我们可以实际上将每个岛屿表示为一个 `HashSet`，包含一对 `Pair`，其中每一个 `Pair` 表示一个单元格。然后我们可以将所有的岛屿放入另一个 `HashSet` 中，这将会哈希表示岛屿的 `HashSet`。
 在 Python 中，我们必须使用一个叫做 [`frozenset`](https://docs.python.org/3/library/stdtypes.html#frozenset) 的数据结构，因为与 Java 不同，Python 不允许在 `set` 中插入另一个 `set`。`frozenset` 是一个不可变的 `set`。

 ```Java [slu2]
 class Solution {
    
    private int[][] grid;
    private boolean[][] seen;
    private Set<Pair<Integer, Integer>> currentIsland;
    private int currRowOrigin;
    private int currColOrigin;
    
    private void dfs(int row, int col) {
        if (row < 0 || row >= grid.length || col < 0 || col >= grid[0].length) return;
        if (grid[row][col] == 0 || seen[row][col]) return;
        seen[row][col] = true;
        currentIsland.add(new Pair<>(row - currRowOrigin, col - currColOrigin));
        dfs(row + 1, col);
        dfs(row - 1, col);
        dfs(row, col + 1);
        dfs(row, col - 1);    
    }
    
    public int numDistinctIslands(int[][] grid) {
        this.grid = grid;
        this.seen = new boolean[grid.length][grid[0].length];   
        Set<Set<Pair<Integer, Integer>>> islands = new HashSet<>();
        for (int row = 0; row < grid.length; row++) {
            for (int col = 0; col < grid[0].length; col++) {
                this.currentIsland = new HashSet<>();
                this.currRowOrigin = row;
                this.currColOrigin = col;
                dfs(row, col);
                if (!currentIsland.isEmpty()) islands.add(currentIsland);
            }
        }         
        return islands.size();
    }
}
 ```

 ```Python3 [slu2]
 class Solution:
    def numDistinctIslands(self, grid: List[List[int]]) -> int:

        # 执行 DFS 以查找当前岛中的所有单元。
        def dfs(row, col):
            if row < 0 or col < 0 or row >= len(grid) or col >= len(grid[0]):
                return
            if (row, col) in seen or not grid[row][col]:
                return
            seen.add((row, col))
            current_island.add((row - row_origin, col - col_origin))
            dfs(row + 1, col)
            dfs(row - 1, col)
            dfs(row, col + 1)
            dfs(row, col - 1)
        
        # 只要还有岛屿，就重复启动 DFS。
        seen = set()
        unique_islands = set()
        for row in range(len(grid)):
            for col in range(len(grid[0])):
                current_island = set()
                row_origin = row
                col_origin = col
                dfs(row, col)
                if current_island:
                    unique_islands.add(frozenset(current_island))
        
        return len(unique_islands)
 ```

 **复杂度分析**

 假设 $M$ 为行数，$N$ 为列数。

* 时间复杂度：$O(M \cdot N)$。
  我们将每个单元格插入一张哈希表（对应其所在的岛屿），然后将这些哈希表插入另一张哈希表。
  将每个 $M \cdot N$ 个单元格插入其初始哈希表的成本是 $O(1)$，所以这些插入的总复杂度是 $O(M \cdot N)$。
  要将“岛屿”哈希表插入最终的哈希表，每个都必须由一个哈希函数在库代码中进行哈希。尽管我们通常认为哈希过程的复杂度是 $O(1)$，但在这里我们不能认为如此，因为要哈希的输入可能会很大。所以，对它们进行哈希的成本线性地与要哈希的哈希表中的单元格数量成正比。这个过程实质上也是对每个单元格进行一次哈希（因为每个都只能是一个岛屿的一部分），所以这个部分也是 $O(M \cdot N)$。
  因为两个阶段的时间复杂度都是 $O(M \cdot N)$，所以这就是总时间复杂度。
  注意，这个方法的时间复杂度 *取决于一个好的哈希函数*。Java 和 Python 的内建哈希函数看起来都是可以的，但我建议非常小心。一个差的哈希函数将导致接近方法 1 的性能。
 * 空间复杂度：$O(M \cdot N)$。`seen` 集是最大的额外内存使用者。

---

 #### 方法 3：根据路径签名进行哈希

 **概述**

 记得我们在方法 1 中不需要对岛屿进行排序吗？当我们开始在某个岛屿的左上方格子上进行深度优先搜索时，只有当形状相同时，我们深度优先搜索所走的路径才会相同。我们可以利用这一点通过使用路径作为哈希。

 **算法**

 每次当我们发现新岛屿的第一个单元格时，我们初始化一个空字符串。然后每次调用该岛屿的 `dfs（...）`，我们首先确定正在进入的单元格是否是未访问的陆地，就像以前一样。如果是，那么我们将我们进入的方向添加到字符串中。例如，这是我们的算法将遵循的路径来探索下面的岛屿。



 ![image_5.png](https://pic.leetcode.cn/1692178846-vGGUzm-image_5.png){:width=400}

 

这条路径将被编码为 `""RDDRUURRUL""`。
 我们需要小心的一件事是，以下三个岛屿将具有相同的编码 `RDDDR`。

 ![image_6.png](https://pic.leetcode.cn/1692178846-IMyORW-image_6.png){:width=400}

 解决这个问题的办法是，我们也需要记录我们*回溯*的地方。这每次都会在我们*退出*调用 `dfs(...)` 函数时发生。我们会通过在字符串后面添加 `0` 来完成这件事。

 ![image_7.png](https://pic.leetcode.cn/1692178847-ffMzRK-image_7.png){:width=400}

 这样，岛屿现在会有编码 `RDDDR`，`RDDD0R`，和 `RDDD00R`。

 ```Java [slu3]
 class Solution {
    private int[][] grid;
    private boolean[][] visited;
    private StringBuffer currentIsland;

    public int numDistinctIslands(int[][] grid) {  
        this.grid = grid;
        this.visited = new boolean[grid.length][grid[0].length];
        Set<String> islands = new HashSet<>();
        for (int row = 0; row < grid.length; row++) {
            for (int col = 0; col < grid[0].length; col++) {
                currentIsland = new StringBuffer();
                dfs(row, col, '0');
                if (currentIsland.length() == 0) {
                    continue;
                }
                islands.add(currentIsland.toString());
            }
        }
        return islands.size();
    }
   
    private void dfs(int row, int col, char dir) {
        if (row < 0 || col < 0 || row >= grid.length || col >= grid[0].length) return;
        if (visited[row][col] || grid[row][col] == 0) return;
        visited[row][col] = true;
        currentIsland.append(dir);
        dfs(row + 1, col, 'D');
        dfs(row - 1, col, 'U');
        dfs(row, col + 1, 'R');
        dfs(row, col - 1, 'L');
        currentIsland.append('0');
    }
}
 ```

 ```Python3 [slu3]
 class Solution:
    def numDistinctIslands(self, grid: List[List[int]]) -> int:

        # 执行 DFS 以查找当前岛中的所有单元。
        def dfs(row, col, direction):
            if row < 0 or col < 0 or row >= len(grid) or col >= len(grid[0]):
                return
            if (row, col) in seen or not grid[row][col]:
                return
            seen.add((row, col))
            path_signature.append(direction)
            dfs(row + 1, col, ""D"")
            dfs(row - 1, col, ""U"")
            dfs(row, col + 1, ""R"")
            dfs(row, col - 1, ""L"")
            path_signature.append(""0"")
        
        # 只要还有岛屿，就重复启动 DFS。
        seen = set()
        unique_islands = set()
        for row in range(len(grid)):
            for col in range(len(grid[0])):
                path_signature = []
                dfs(row, col, ""0"")
                if path_signature:
                    unique_islands.add(tuple(path_signature))
        
        return len(unique_islands)
 ```

 **复杂度分析**

 假设 $M$ 为行数，$N$ 为列数。

 * 时间复杂度：$O(M \cdot N)$。与方法 2 相同。
 * 空间复杂度：$O(M \cdot N)$。与方法 2 相同