## [1102.得分最高的路径 中文官方题解](https://leetcode.cn/problems/path-with-maximum-minimum-value/solutions/100000/de-fen-zui-gao-de-lu-jing-by-leetcode-so-9s5i)

## 解决方案 

---

#### 前言

 在这个问题中，我们被给定了一个二维整数矩阵。我们的任务是选择一条从左上角单元格开始并在右下角单元格结束的路径。如问题所述，一条路径的 **分数** 由这条路径中的最小值定义。 

 例如，在下面的矩阵中，绿色路径的值为 $[5, 1, 7, 4, 6]$，因此，绿色路径的 **分数** 是最小值 $1$。红色路径的值为 $[5, 4, 5, 6, 6]$，因此，红色路径的 **分数** 是最小值 $4$。我们可以得出，红色路径的 **分数** 大于绿色路径的 **分数**。 

 ![image.png](https://pic.leetcode.cn/1691657172-qRXaqb-image.png){:width=400}

 我们的任务是在给定矩阵中所有可能的路径中，找出最大的 **分数**。 

---

 #### 方法 1：迭代 + BFS 

 **思路**  

 在设计一个查找最优路径的函数之前，我们还可以从别的角度来思考这个问题！ 

 > 给定一个数 **S**，我们能在矩阵里找到 **score** 等于 **S** 的路径吗？ 

 回顾上一个图示： 

 ![image.png](https://pic.leetcode.cn/1691657172-qRXaqb-image.png){:width=400}

 给定 **S = 100**，我们可以找到最小值等于 **100** 的路径吗？答案当然是 NO。 给定 **S = 4**，那我们可以找到最小值等于 **4** 的一个路径吗？答案是YES（例如红色的路径）。 

 更具体地说，我们可以从一个大的数 **S** 开始（大到无法找到得分更高的路径），然后我们检查是否存在一个得分等于 **S** 的路径。如果存在，我们就找到了所有路径的最大最小值。否则，意味着当前的 **S** 太大，我们应该寻找一个更小的数。因为我们不想错过任何可能的值，我们只需将 **S** 减 1 即可。换句话说，我们继续检查是否存在数值为 **S - 1** 的路径。 

 ![image.png](https://pic.leetcode.cn/1691639850-RiudRW-image.png){:width=400}

 通过这种方式，我们可以将优化问题转化为决策问题：我们不需要担心怎么找路径，只要检验是否存在这样的路径就可以了。 

 然后这个问题就分为两步： 

 1. 从一个较大的初始得分 **S** 开始递减遍历。 
 2. 对每个 **S**，检查是否存在分数等于 **S** 的路径。 

 > 1. 如何找到最大的 **score**？ 

 如上图所示，为了不错过任何可能的最小值，我们将从一个大值 $S$ 开始，这是任何路径中可能的最大最小值。例如，我们可以使用矩阵中的最大值，然后尝试找到是否存在一个得分为 $maxVal$ 的路径。如果我们找不到这样的路径，那么我们将 $maxVal$ 减1，然后重复这个过程，直到我们找到一个得分为 $maxVal$ 的路径。 

 > 2. 给定一个得分 **S**，我们如何验证是否存在这样的路径？ 

 为了验证是否存在这样的路径，我们可以在矩阵上进行广度优先搜索，只搜索数值大于等于 **S** 的单元格。 

 > 更多关于 BFS 的信息，请参考: [广度优先搜索算法](https://leetcode.cn/leetbook/detail/bfs/) 

 <![image.png](https://pic.leetcode.cn/1691726045-SMfKLh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726049-RQcjNc-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726051-pkMjZF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726053-YKfGAr-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726056-EnVFiF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726058-ROKFmY-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726061-OZLxeK-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726065-MCSnzV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726067-KYwKPg-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726070-IpfNBL-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726073-lQKXop-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726076-KIrRZf-image.png){:width=400}>

 这里有一个技巧，那就是我们不需要从一个巨大的得分 **S** 开始，这可能会在获取最大得分前进行很多不必要的计算。取而代之，我们可以从左上角和右下角的较小值开始。因为我们的路径 **必须** 包含这两个点，所以路径的得分必须小于等于这两点的较小值。因此，通过选择上述两个单元格的较小值作为开始得分 **S**，我们可以减小搜索空间。 

<br> 

 **算法步骤** 
 1. 从得分 $curScore = min(grid[0][0], grid[R - 1][C - 1])$ 开始，其中 $R$ 和 $C$ 是输入网格的总行数和列数。 
 2. 对矩阵进行 BFS 并验证是否存在某条路径其中所有的值大于或等于 $curScore$：  
    - 使用双端队列存储所有未访问过的值大于或等于 $curScore$ 的单元格。  
    - 从队列前部弹出一个单元格，查看它是否有未访问的相邻单元格，并将它们添加到队列的后部。  
    - 如果我们成功到达右下角的单元格，那么存在这样的路径。  
    -  否则，如果在到达右下角的单元格之前，队列已空，那么这条路径不存在。 
 3. 
    - 如果不存在这样的路径，意味着 $curScore$ 太大，我们需要将它减 1，然后从步骤 2 开始重复。   
    -  否则返回 $curScore$ 作为答案。    

 **代码实现** 

> 注意：以下代码主要是为了帮助了解下面的优化方法。它是暴力破解的方法不太可能通过所有的测试用例。 

 ```C++ [slu1]
class Solution {
    // 指向单元格的可能邻居的4个方向.
    vector<vector<int>> dirs{{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
    public:    
        int maximumMinimumPath(vector<vector<int>>& grid) {
            int R = grid.size(), C = grid[0].size();
            int curScore = min(grid[0][0], grid[R - 1][C - 1]);

            // 从“curScore”开始，检查是否可以找到得分等于“curScore”的路径。 
            // 如果可以，返回 curScore 作为最大值
            // 否则对 curScore 减 1 并重复这些步骤
            while (curScore >= 0) {
                if (pathExists(grid, curScore)) {
                    return curScore;
                } else {
                    curScore = curScore - 1;
                }
            }
            return -1;
        }

        // 检查能否找到一条 score 等于 curScore 的路径
        bool pathExists(vector<vector<int>>& grid, int curScore) {
            int R = grid.size(), C = grid[0].size();        
            // 维护每个单元格的访问状态。 把每个单元格的状态设置为 false（未访问）
            vector<vector<bool>> visited (R, vector<bool> (C, false));

            // 把起点 grid[0][0] 放入 deque 并标记为已访问。
            visited[0][0] = true;        
            deque<pair<int, int>> dq({{0, 0}});

            auto push = [&](int row, int col){
                if (row == -1 || col == -1 || row == R || col == C || 
                    visited[row][col] || grid[row][col] < curScore) return;
                dq.push_back({row, col});
                visited[row][col] = true;
            };

            // 当我们仍然有值大于或等于 curScore 的单元格。
            while (!dq.empty()) {
                int curRow = dq.front().first, curCol = dq.front().second;
                dq.pop_front();

                // 如果当前单元格是右下角的单元格，则返回 true。
                if (curRow == R - 1 && curCol == C - 1) {
                    return true;
                }

                // 检查当前单元格是否有任何值大于或等于 curScore 的未访问邻居。
                // 如果是，我们将此邻居置于 deque，并将其标记为已访问。
                push(curRow + 1, curCol);
                push(curRow - 1, curCol);
                push(curRow, curCol + 1);
                push(curRow, curCol - 1);
            }
            return false;
        }
};
 ```

```Java [slu1]
class Solution {
    // 指向单元格的可能邻居的4个方向.
    public int[][] dirs = new int[][]{{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
    public int maximumMinimumPath(int[][] grid) {
        int R = grid.length, C = grid[0].length;
        int curScore = Math.min(grid[0][0], grid[R - 1][C - 1]);

        // 从 curScore 开始，检查是否可以找到值等于 curScore 的路径。 
        // 如果可以，返回 curScore 作为最大值, 否则对 curScore 减 1 并重复这些步骤。
        while (curScore >= 0) {
            if (pathExists(grid, curScore)) {
                return curScore;
            } else {
                curScore = curScore - 1;
            }
        }
        return -1;
    }
    
    // 检查能否找到一条 score 等于 curScore 的路径
    private boolean pathExists(int[][] grid, int curScore) {
        int R = grid.length, C = grid[0].length;
        
        // 维护每个单元格的访问状态。把每个单元格的状态设置为 false（未访问）
        boolean[][] visited = new boolean[R][C];
        visited[0][0] = true;
        
        // 把起点 grid[0][0] 放入 deque 并标记为已访问。
        Queue<int[]> deque = new LinkedList<>();
        deque.offer(new int[]{0, 0});
        
        // 当我们仍然有值大于或等于 curScore 的单元格。
        while (!deque.isEmpty()) {
            int[] curGrid = deque.poll();
            int curRow = curGrid[0];
            int curCol = curGrid[1];

            // 如果当前单元格是右下角的单元格，则返回 true。
            if (curRow == R - 1 && curCol == C - 1) {
                return true;
            }

            for (int[] dir : dirs) {
                int newRow = curRow + dir[0];
                int newCol = curCol + dir[1];

                // 检查当前单元格是否有任何值大于或等于 curScore 的未访问邻居。
                if (0 <= newRow && newRow < R && 0 <= newCol && newCol < C
                   && visited[newRow][newCol] == false && grid[newRow][newCol] >= curScore) {
                    // 如果是，我们将此邻居置于 deque，并将其标记为已访问。
                    visited[newRow][newCol] = true;
                    deque.offer(new int[]{newRow, newCol});
                }               
            }
        }

        // 如果我们清空了 deque 并且还没有到达右下角，返回 false
        return false;       
    }    
}
```

```Python3 [slu1]
class Solution:
    def maximumMinimumPath(self, grid: List[List[int]]) -> int:
        R = len(grid)
        C = len(grid[0])

        # 指向单元格的可能邻居的4个方向.
        dirs = [(1, 0), (0, 1), (-1, 0), (0, -1)]
        
        # 检查能否找到一条 score 等于 curScore 的路径
        def path_exists(cur_score):

            # 维护每个单元格的访问状态。 把每个单元格的状态设置为 false（未访问）
            visited = [[False] * C for _ in range(R)]         
            visited[0][0] = True

            # 把起点 grid[0][0] 放入 deque 并标记为已访问。
            dq = collections.deque([(0, 0)])
            
            # 当我们仍然有值大于或等于 curScore 的单元格。
            while dq:
                cur_row, cur_col = dq.popleft()

                # 如果当前单元格是右下角的单元格，则返回 true。
                if cur_row == R - 1 and cur_col == C - 1:
                    return True
                for d_row, d_col in dirs:
                    new_row = cur_row + d_row
                    new_col = cur_col + d_col

                    # 确保(new_row, new_col)在图上.
                    if not (0 <= new_row < R and 0 <= new_col < C):
                        continue

                    # 检查当前单元格是否有任何值大于或等于 curScore 的未访问邻居。
                    if grid[new_row][new_col] >= cur_score and not visited[new_row][new_col]:
                        # 如果是，我们将此邻居置于 deque，并将其标记为已访问。
                        visited[new_row][new_col] = True
                        dq.append((new_row, new_col))                    
            return False
        
        cur_score = min(grid[0][0], grid[R - 1][C - 1])
        
        # 从 curScore 开始，检查是否可以找到值等于 curScore 的路径。 
        # 如果可以，返回 curScore 作为最大值, 否则对 curScore 减 1 并重复这些步骤。
        while cur_score >= 0:
            if path_exists(cur_score):
                return cur_score
            else:
                cur_score -= 1

```



**复杂度分析** 
 设 $n, m$ 为输入矩阵 $grid$ 的维度，并且 $k$ 为矩阵中的最大可能值。 

 * 时间复杂度：$O(n\cdot m\cdot k)$ 
   - 对于每一个 **值**，我们在矩阵上进行 BFS 来验证是否存在一个有效的路径，这需要 $O(n \cdot m)$ 的时间。   
   - 在找到第一个（也是最大的）**值**之前，我们必须尝试每一个更大的值。假设在最坏的情况下（当答案接近于 $1$ 时），我们必须尝试从 $k$ 到 $1$ 的每一个值。那么总共有 $k$ 次迭代并且在矩阵上做了 $k$ 次 BFS。 
     - 总结一下，总的时间复杂度是 $O(n\cdot m\cdot k)$。   

 * 空间复杂度: $O(n \cdot m)$ 
   - 在最坏的情况下，我们需要在队列中维持 $n \cdot m$个单元格，这需要 $O(n \cdot m)$ 的空间用于单次 BFS。  
   - 我们还需要一个辅助数据结构来跟踪每次 BFS 中的 $n \cdot m$ 个单元格的访问情况。  
   - 因此，总的空间复杂度是 $O(n \cdot m)$。 


 <br/> 

---

 #### 方法 2：二分查找 + 广度优先搜索(BFS) 

 **思路**  
 在方法 1 中，我们在找到最大 **得分** 之前，检查了每一个较大的分数，那我们能够找到一种更有效的方法去定位最大 **得分** 吗？ 
 答案是 YES！ 

 ![image.png](https://pic.leetcode.cn/1691647158-okeYez-image.png){:width=400}

 回顾路径得分的定义，我们可以观察到两个规律： 

1. 如果我们能找到一个得分为 $N$ 的路径，我们也能找到一个得分为 $N - 1$ 的路径。  对于所有值都大于等于 $N$ 的路径，这些值同样也是大于等于 $N - 1$ 的。 
2. 如果我们找不到一个得分为 $N$ 的路径，我们也找不到得分为 $N + 1$ 的路径。 如果我们找不到一个得分为 $N$ 的路径，意味着所有的路径中都至少包含一个小于 $N$ 的值，这个值同样小于 $N + 1$，所以所有的路径都至少包含一个小于 $N + 1$ 的值。 

 ![image.png](https://pic.leetcode.cn/1691647448-FLBIov-image.png){:width=400}

 方便起见，我们将一条路径的得分称为 **可行得分** ，而在每一个路径中过大的那些值则为 **不可行得分** 。 
 根据以上两个规律，我们可以断定所有得分的分布应该如下所示： 

 ![image.png](https://pic.leetcode.cn/1691647725-blTnFK-image.png){:width=400}

 

 如果当前的值是一个 **可行分数**，那么最大的 **可行分数** 就在它的右边且包括它。如果当前值是一个 **不可行分数**，那么最大的可行分数应该在它的左边不包括它。 
 因此，我们可以使用二分查找在每一步中削减搜索空间的一半，定位那个分界点，即分割 **可行分数** 和 **不可行分数** 的边界，这个边界表示所有路径中的最大得分。 
 还有很多其他的有趣问题可以用二分查找去找到最优值的方法来解决。你可以在以下问题练习二分查找！
 <br> 
 - [410. 分割数组的最大值](https://leetcode.cn/problems/split-array-largest-sum/)  
 - [774. 最小化去加油站的最大距离](https://leetcode.cn/problems/minimize-max-distance-to-gas-station/)  
 - [875. 爱吃香蕉的珂珂](https://leetcode.cn/problems/koko-eating-bananas/) 
 - [1011. 在D天内送达包裹的能力](https://leetcode.cn/problems/capacity-to-ship-packages-within-d-days/) 
 - [1231. 分享巧克力](https://leetcode.cn/problems/divide-chocolate/) 

 
**算法** 

1. 初始化二分查找的两个边界， 
2. 当 $left < right$ 时，让 $middle = (left + right + 1) / 2$。  
3. 在矩阵上进行 BFS 并验证是否存在某条路径，该路径中所有的值都大于等于 $curScore$：  
   - 使用双端队列存储所有未访问过的值大于或等于 $curScore$ 的单元
   - 从双端队列的前端取出一个单元格，检查它是否有未访问过的相邻单元格，并将它们添加到双端队列的后端。
   - 如果我们成功地到达了右下角的单元格，那么路径就存在。
   - 否则，如果我们在到达右下角单元格之前已经清空了双端队列，那么路径就不存在。

4. 如果存在路径，让 $middle = left$。否则，让 $right = middle - 1$。
5. 重复步骤 2，3，4，直到两个边界重合，然后返回 $left$ 或 $right$ 作为答案。

**实现**

```C++ [slu2]
class Solution {
    // 单元格可能相邻的四个方向。
    vector<vector<int>> dirs{{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
    public:    
        int maximumMinimumPath(vector<vector<int>>& grid) {
            int R = grid.size(), C = grid[0].size();
            int left = 0, right = min(grid[0][0], grid[R- 1][C - 1]);
            while (left < right) {
                // 获取左边界和右边界之间的中间值。
                int middle = (left + right + 1) / 2;

                // 确认我们能否找到一条值为 middle 的路径，
                // 并减半搜索空间。
                if (pathExists(grid, middle)) {
                    left = middle;
                } else {
                    right = middle - 1;
                }
            }

            // 一旦左右边界重合，我们就找到目标值，
            // 就是路径的最大值。
            return left;
        }

        // 检查我们是否能找到一条值等于 val 的路径。
        bool pathExists(vector<vector<int>>& grid, int val) {
            int R = grid.size(), C = grid[0].size();   

            // 维护每个单元格的访问状态。
            // 初始化所有单元格的状态为 false（未访问）。 
            vector<vector<bool>> visited (R, vector<bool> (C, false));
            
            // 将起始单元格 grid[0][0] 放入双端队列，并将其标记为已访问。
            visited[0][0] = true;        
            deque<pair<int, int>> dq({{0, 0}});
            
            auto push = [&](int row, int col){
                if (row == -1 || col == -1 || row == R || col == C
                 || visited[row][col] || grid[row][col] < val) return;
                dq.push_back({row, col});
                visited[row][col] = true;
            };
            
            // 当我们仍然有值大于或等于 val 的单元格。
            while (!dq.empty()) {
                int curRow = dq.front().first, curCol = dq.front().second;
                dq.pop_front();

                // 如果当前单元格是右下角的单元格，则返回 true。
                if (curRow == R - 1 && curCol == C - 1) return true;

                // 检查当前单元格是否有任何值大于或等于 val 的未访问邻居。
                // 如果是，我们将此邻居置于双端队列，并将其标记为已访问
                push(curRow + 1, curCol);
                push(curRow - 1, curCol);
                push(curRow, curCol + 1);
                push(curRow, curCol - 1);
            }
            return false;
        }   
};
```
```Java [slu2]
class Solution {
    // 单元格可能相邻的四个方向。
    public int[][] dirs = new int[][]{{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
    public int maximumMinimumPath(int[][] grid) {
        int R = grid.length, C = grid[0].length;
        int left = 0, right = Math.min(grid[0][0], grid[R - 1][C - 1]);

        while (left < right) {
            // 获取左边界和右边界之间的中间值。
            int middle = (right + left + 1) / 2;

            // 确认我们能否找到一条值为 middle 的路径，
            // 并减半搜索空间。
            if (pathExists(grid, middle)) {
                left = middle;
            } else {
                right = middle - 1;
            }
        }

        // 一旦左右边界重合，我们就找到目标值，
        // 就是路径的最大值。
        return left;
    }
    
    // 检查我们是否能找到一条值等于 val 的路径。
    private boolean pathExists(int[][] grid, int val) {
        int R = grid.length, C = grid[0].length;
        
        // 维护每个单元格的访问状态。 初始化所有单元格的状态为 false（未访问）。 
        boolean[][] visited = new boolean[R][C];
        
        // 将起始单元格 grid[0][0] 放入双端队列，并将其标记为已访问。

        Queue<int[]> deque = new LinkedList<>();
        deque.offer(new int[]{0, 0});
        visited[0][0] = true;
        
        // 当我们仍然有值大于或等于 val 的单元格。 
        while (!deque.isEmpty()) {
            int[] curGrid = deque.poll();
            int curRow = curGrid[0];
            int curCol = curGrid[1];

            // 如果当前单元格是右下角的单元格，则返回 true。
            if (curRow == R - 1 && curCol == C - 1) {
                return true;
            }
            for (int[] dir : dirs) {
                int newRow = curRow + dir[0];
                int newCol = curCol + dir[1];

                // 检查当前单元格是否有任何值大于或等于 val 的未访问邻居。
                // 如果是，我们将此邻居置于双队列，并将其标记为已访问
                if (0 <= newRow && newRow < R && 0 <= newCol && newCol < C
                   && visited[newRow][newCol] == false && grid[newRow][newCol] >= val) {
                    // 如果是，我们将此邻居置于双端队列，并将其标记为已访问
                    visited[newRow][newCol] = true;                   
                    deque.offer(new int[]{newRow, newCol});
                }               
            }
        }
        return false;       
    }
}
```

```Python3 [slu2]
class Solution:
    def maximumMinimumPath(self, grid: List[List[int]]) -> int:
        R = len(grid)
        C = len(grid[0])
        # 单元格可能相邻的四个方向。
        dirs = [(1, 0), (0, 1), (-1, 0), (0, -1)]
        
        # 检查我们是否能找到一条值等于 cur_score 的路径。
        def path_exists(cur_score):
            dq = collections.deque()
            visited = [[False] * C for _ in range(R)]   

            # 将起始单元格 grid[0][0] 放入双端队列，并将其标记为已访问。
            visited[0][0] = True
            dq.append((0, 0))
            
            # 当我们仍然有值大于或等于 val 的单元格。 
            while dq:
                cur_row, cur_col = dq.popleft()

                # 如果当前单元格是右下角的单元格，则返回 true。
                if cur_row == R - 1 and cur_col == C - 1:
                    return True
                for d_row, d_col in dirs:
                    new_row = cur_row + d_row
                    new_col = cur_col + d_col

                    # 确保 (new_row, new_col) 在 grid 上
                    if not (0 <= new_row < R and 0 <= new_col < C):
                        continue

                    # 检查当前单元格是否有任何值大于或等于 cur_score 的未访问邻居。
                    if grid[new_row][new_col] >= cur_score and not visited[new_row][new_col]:
                        # 如果是，我们将此邻居置于双端队列，并将其标记为已访问
                        visited[new_row][new_col] = True
                        dq.append((new_row, new_col))                    
            return False
        
        left = 0
        right = min(grid[0][0], grid[-1][-1])
        
        while left < right:
            # 获取左边界和右边界之间的中间值。
            middle = (left + right + 1) // 2

            # 确认我们能否找到一条值为 middle 的路径，
            # 并减半搜索空间。
            if path_exists(middle):
                left = middle
            else:
                right = middle - 1

        # 一旦左右边界重合，我们就找到目标值，
        # 就是路径的最大值。
        return left
```

**复杂度分析**

令 $n, m$ 为输入矩阵 $grid$ 的维度，$k$ 为矩阵中的最大值。

* 时间复杂度：$O(n\cdot m\cdot \log k)$
  - 初始的搜索空间是 $1$ 到 $k$，需要 $\log k$ 次比较才能将搜索空间减少到 1。
  - 对于每一个 **值**，我们都要在矩阵上进行一个 BFS，以证实是否存在有效路径，这需要 $O(n \cdot m)$ 的时间。 
  - 总的来说，总的时间复杂度是 $O(n\cdot m\cdot \log k)$


* 空间复杂度：$O(n \cdot m)$
  - 我们使用了一个大小为 $O(n\cdot m)$ 的数组来保存每个单元格的访问/未访问状态。
  - 在最坏的情况下，我们需要在双端队列中放入大部分的单元格，这需要 $O(n \cdot m)$ 的空间来进行单次的BFS。
  - 因此，总的空间复杂度是 $O(n \cdot m)$。


---

#### 方法 3：二分查找 + 深度优先搜索(DFS)

**概述** 

如我们在第二种方法中讨论的，我们使用二分查找来定位最大的最小值。在这里，我们继承了先前算法的一部分：我们仍然使用二分查找来缩小搜索空间并定位最大值。然而，我们将使用不同的方法来验证在给定目标分数的情况下是否存在有效路径。

<![image.png](https://pic.leetcode.cn/1691726380-iYSQIo-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726383-UweQAd-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726389-deDDMg-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726392-uaUphU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726395-LxydRI-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726398-TxJmNw-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726400-RYBotQ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726403-iSibkq-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726406-zNCruC-image.png)>{:width=400}


**算法**

1. 初始化二分查找的两个边界，设左边界为 $left = 0$，设右边界为 $right = min(grid[0][0], grid[R - 1][C - 1])$，其中 $R, C$ 是输入单元格的行数和列数。
2. 当 $left < right$ 时，设 $middle = (left + right + 1) / 2$。
3. 在图上执行一个 DFS 来寻找是否存在一个每个值都大于或等于 $middle$ 的路径。
4. 如果路径存在，设 $middle = left$。否则，设 $right = middle - 1$。
5. 重复 2，3，4 步骤，直到上限和下限重合，然后返回 $left$ 或者 $right$ 作为答案。



**实现**

```C++ [slu3]
class Solution {
private:
    int R, C;
    bool visited[101][101];

    // 4 个指向单元格可能邻居的方向。
    vector<vector<int>> dirs{{1, 0}, {0, 1}, {-1, 0}, {0, -1}};

public:
    int maximumMinimumPath(vector<vector<int>>& grid) {
        R = grid.size();
        C = grid[0].size();

        // 初始化搜索空间的两个边界。
        int left = 0, right = min(grid[0][0], grid[R - 1][C - 1]);

        while (left < right) {
            // 获取左边界和右边界之间的中间值。
            int middle = (left + right + 1) >> 1;
            memset(visited, false, sizeof(visited));

            // 确认我们能否找到一条值为 middle 的路径，
            // 并减半搜索空间。
            if (pathExists(grid, middle, 0, 0)) {
                left = middle;
            } else {
                right = middle - 1;
            }
        }

        // 一旦左右边界重合，我们就找到目标值，
        // 就是路径的最大值。
        return left;
    }
    
    // 确认我们能否找到一条路径的值等于 val
    int pathExists(vector<vector<int>>& grid, int val, int curRow, int curCol) {
        // 如果到达右下角的单元格，则返回 true。
        if (curRow == R - 1 && curCol == C - 1) return true;

        // 把当前的单元格标记为已访问。
        visited[curRow][curCol] = true;
        for (vector<int> dir : dirs) {
            int newRow = curRow + dir[0];
            int newCol = curCol + dir[1];

            // 检查当前单元格是否有任何值
            // 大于或等于 val 的未访问邻居。
            if (newRow >= 0 && newRow < R && newCol >= 0 && newCol < C 
                && !visited[newRow][newCol] && grid[newRow][newCol] >= val) {

                // 如果是这样，我们就继续搜索这个邻居。
                if (pathExists(grid, val, newRow, newCol))
                    return true;
            }           
        }
        return false;
    } 
};
```

```Java [slu3]
class Solution {
    private int R, C;

    // 4 个指向单元格可能邻居的方向。
    private int[][] dirs = new int[][]{{1, 0}, {-1, 0}, {0, 1}, {0, -1}};

    public int maximumMinimumPath(int[][] grid) {
        R = grid.length;
        C = grid[0].length;
        int left = 0, right = Math.min(grid[0][0], grid[R - 1][C - 1]);
        while (left < right) {
            // 获取左边界和右边界之间的中间值。
            int middle = (right + left + 1) / 2;
            boolean[][] visited = new boolean[R][C];

            // 确认我们能否找到一条值为 middle 的路径，
            // 并减半搜索空间。
            if (pathExists(grid, middle, visited, 0, 0)) {
                left = middle;
            } else {
                right = middle - 1;
            }
        }

        // 一旦左右边界重合，我们就找到目标值，
        // 即路径的最大值。
        return left;
    }
    
    // 确认我们能否找到一条路径的值等于 val
    private boolean pathExists(int[][] grid, int val, boolean[][] visited, int curRow, int curCol) {
        // 如果到达右下角的单元格，则返回 true。
        if (curRow == R - 1 && curCol == C - 1) return true;

        // 把当前的单元格标记为已访问。
        visited[curRow][curCol] = true;
        for (int[] dir : dirs) {
            int newRow = curRow + dir[0];
            int newCol = curCol + dir[1];

            // 检查当前单元格是否有任何值
            // 大于或等于 val 的未访问邻居。
            if (newRow >= 0 && newRow < R && newCol >= 0 && newCol < C
                && !visited[newRow][newCol] && grid[newRow][newCol] >= val) {
                // 如果是这样，我们就继续搜索这个邻居。
                if (pathExists(grid, val, visited, newRow, newCol))
                    return true;
            }
        }
        return false;        
    }   
}
```

```Python3 [slu3]
class Solution:
    def maximumMinimumPath(self, grid: List[List[int]]) -> int:
        R = len(grid)
        C = len(grid[0])

        # 4 个指向单元格可能邻居的方向。
        dirs = [(1, 0), (0, 1), (-1, 0), (0, -1)]
        
        # 确认我们能否找到一条路径的值等于 val
        def path_exists(val):
            visited = [[False] * C for _ in range(R)]         
            def dfs(cur_row, cur_col):
                # 如果到达右下角的单元格，则返回 true。
                if cur_row == R - 1 and cur_col == C - 1:
                    return True

                # 把当前的单元格标记为已访问。
                visited[cur_row][cur_col] = True
                for d_row, d_col in dirs:
                    new_row = cur_row + d_row
                    new_col = cur_col + d_col

                    # 确保 (new_row, new_col) 在 grid 上并且还没有被访问
                    if not (0 <= new_row < R and 0 <= new_col < C) or visited[new_row][new_col]:
                        continue

                    # 检查当前单元格是否有任何值
                    # 大于或等于 val 的未访问邻居。
                    if grid[new_row][new_col] >= val and dfs(new_row, new_col):
                        # 如果是这样，我们就继续搜索这个邻居。
                        return True
                return False            
            return dfs(0,0)   
                        
        left = 0
        right = min(grid[0][0], grid[-1][-1])
 
        while left < right:
            # 获取左边界和右边界之间的中间值。
            middle = (left + right + 1) // 2

            # 确认我们能否找到一条值为 middle 的路径，
            # 并减半搜索空间。
            if path_exists(middle):
                left = middle
            else:
                right = middle - 1
        
        # 一旦左右边界重合，我们就找到目标值，
        # 即路径的最大值。
        return left
```

**复杂性分析**

设 $n, m$ 是输入样例 $grid$ 的维度并且 $k$ 是样例中的最大值。

* 时间复杂性：$O(n\cdot m\cdot \log k)$
  - 初始搜索空间是从 $1$ 到 $k$，需要用 $\log k$ 次比较来缩小搜索空间到 1。
  - 对于每个 **数值**，我们在样例上执行一次 DFS 来验证是否存在一个有效路径，这个过程需要一次 $O(n \cdot m)$ 的时间复杂性。
  - 综上，整体时间复杂度为 $O(n\cdot m\cdot \log k)$。


* 空间复杂性：$O(n \cdot m)$
  - 我们使用了 $O(n\cdot m)$ 的数组来保存每个单元的已访问/未访问状态。
  - 在最坏的情况下，我们需要遍历整个矩阵，这需要 $O(n \cdot m)$ 的空间来进行一次 DFS。
  - 因此，整体空间复杂度是 $O(n \cdot m)$

---

#### 方法 4：广度优先搜索 + 优先队列

**概述** 

假设我们从左上角单元格开始，检查其两个邻居，然后访问邻居单元格中具有更大值的一个。我们可以想象，这个新访问的单元格将会有其他的邻居单元格。再一次，我们可以考虑所有与已访问的两个单元格相邻的单元格，然后访问具有最大值的单元格。我们可以重复这些步骤，直到从左上角单元格到右下角单元格。因为在每一步中，我们都选择了未访问过的具有最大值的邻居，所以保证了迄今为止看到的最小值是有效路径中可能的最大最小值（最大得分）。

但是，这里有个问题：假设输入网格有 $M$ 行和 $N$ 列，在最坏的情况下，我们访问了 $O(MN)$ 个单元格，同时有 $O(MN)$ 个邻居单元格等待下一次访问。从 $O(MN)$ 个单元格中选择具有最大值的单元格需要 $O(MN)$ 的时间。因此这种方法需要 $O(M^2 N^2)$ 的时间。我们能找到一个有效地方式来存储所有未访问的邻居单元格并选择具有最大值的单元格吗？答案是肯定的！

> 我们可以利用优先队列，它维持了一个堆结构，并允许我们在对数时间内选择出最小值。

我们将所有未访问的邻居单元格存储在一个优先队列中。在路径中的所有这些单元格中，我们总是选择具有最大值的单元格。一旦我们从优先队列中移除了这个单元格，我们将其标记为 **已访问**，并检查该单元格是否有任何 **未访问** 的邻居。在每一步中，我们将从所有未访问的单元格中选择具有最大值的单元格，直到形成到达右下角单元格的路径。

参考下面的幻灯片作为一个例子。注意，虽然在这个例子中我们只访问了最优路径中的单元格，但通常情况下并非如此。这个算法只保证我们不会访问任何具有比最大最小路径值小的值的单元格，因而任何使用已访问单元格创建的路径不会有比最大最小路径值更小的值。

<![image.png](https://pic.leetcode.cn/1691726460-BcmsSa-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726462-owDPNf-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726464-LqGiIH-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726467-MJhbyR-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726469-nHRVsK-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726473-VUXHvK-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726476-NJhvLy-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726478-SxeiuH-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726481-zhPeVA-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691726483-UrUEAY-image.png){:width=400}>


> 看起来像 Dijkstra's 算法？

这种方法可能可以被认为是 Dijkstra's 算法的一种变体，因为它们确实有一些相似的特性，如使用优先队列贪婪地选择下一个要探索的顶点（单元格）。

然而，在 Dijkstra's 算法中，我们的目标是找到每个节点的 **最短路径**，通过使用前面所有选择的最优和，因此我们在迭代过程中动态地更新从起始节点到其他节点的最短路径。在这个问题中，我们的目标是最大化路径中的 **最小值**，所以我们不需要更新到其他目标的路径的最小值。因此，考虑到这个核心区别，我们将此方法称为 “BFS + 优先队列”。

**算法**

1. 初始化：
   - 一个空的优先队列 $pq$ 并把左上角的单元格放进去。
   - 所有单元格的状态设置为未访问。
   - 所看到的最小值 `min_val` 设为左上角单元格的值。
2. 从优先队列中弹出具有最大值的单元格，将其标记为已访问，并更新到目前为止看到的最小值。
3. 检查当前单元格是否有任何未访问的邻居。如果有，将它们添加到优先队列中。
4. 重复步骤 2，直到我们从优先队列中弹出右下角的单元格。返回更新后的最小值作为答案。


**实现**

```C++ [slu4]
class Solution {
public:
    int maximumMinimumPath(vector<vector<int>>& grid) {
        int R = grid.size(), C = grid[0].size();

        // 4 个指向单元格可能邻居的方向。
        vector<vector<int>> dirs{{1, 0}, {0, 1}, {-1, 0}, {0, -1}};

        // 把左上角的单元格放入优先队列，并标记为 true（已访问）。
        priority_queue<pair<int, pair<int, int>>> pq;
        pq.push({grid[0][0], {0, 0}});

        // 把所有单元格的状态标记为 false（未访问）。
        vector<vector<bool>> visited(R, vector<bool>(C));

        // 把左上角的单元格标记为已访问。
        visited[0][0] = true;
        int ans = grid[0][0];
        
        // 当优先队列非空
        while (!pq.empty()) {
            // 把最大值的单元格弹出。
            int curRow = pq.top().second.first;
            int curCol = pq.top().second.second;
            int curVal = pq.top().first;
            pq.pop();

            // 更新我们迄今访问过的最小值。
            ans = min(ans, curVal);
            
            // 如果我们到达了右下角的单元格，停止迭代。
            if (curRow == R - 1 && curCol == C - 1) {
                break;
            }
            
            for (vector<int> dir : dirs) {
                int newRow = curRow + dir[0];
                int newCol = curCol + dir[1];

                // 检查当前节点是否有未访问的邻居
                if (newRow >= 0 && newRow < R && newCol >= 0 
                    && newCol < C && !visited[newRow][newCol]) {
                    // 如果有，我们把这个邻居放入优先队列，
                    // 并把它标记为 true（
                    pq.push({grid[newRow][newCol], {newRow, newCol}});
                    visited[newRow][newCol] = true;
                }
            }
        }
        
        // 返回我们看到的最小值，即此路径的值。
        return ans;
  }
};
```

```Java [slu4]
class Solution {
    private int R, C;

    // 4 个指向单元格可能邻居的方向。
    private int[][] dirs = new int[][]{{1, 0}, {-1, 0}, {0, 1}, {0, -1}};

    public int maximumMinimumPath(int[][] grid) {
        R = grid.length;
         C = grid[0].length;
        Queue<int[]> pq = new PriorityQueue<>(
            (a, b) -> Integer.compare(grid[b[0]][b[1]], grid[a[0]][a[1]]));
              
        // 把所有单元格的状态标记为 false（未访问）。
        boolean[][] visited = new boolean[R][C];

        // 把左上角的单元格放入优先队列，
        // 并标记为 true（已访问）。
        pq.offer(new int[] {0, 0});
        visited[0][0] = true;

        int ans = grid[0][0];

        // 当优先队列非空
        while (!pq.isEmpty()) {
            // 把最大值的单元格弹出。
            int[] curGrid = pq.poll();
            int curRow = curGrid[0], curCol = curGrid[1];

            // 更新我们迄今访问过的最小值。
            ans = Math.min(ans, grid[curRow][curCol]);

            // 如果我们到达了右下角的单元格，停止迭代。
            if (curRow == R - 1 && curCol == C - 1) {
                break;
            }
            for (int[] dir : dirs) {
                int newRow = curRow + dir[0], newCol = curCol + dir[1];

                // 检查当前节点是否有未访问的邻居
                if (newRow >= 0 && newRow < R && newCol >= 0 && newCol < C 
                    && !visited[newRow][newCol]) {
                    // 如果有，我们把这个邻居放入优先队列，
                    // 并把它标记为 true（已访问）。
                    pq.offer(new int[] {newRow, newCol});
                    visited[newRow][newCol] = true;
                } 
            }
        }

        // 返回我们看到的最小值，即此路径的值。
        return ans;        
    }
}
```

```Python3 [slu4]
class Solution:
    def maximumMinimumPath(self, grid: List[List[int]]) -> int:
        R = len(grid)
        C = len(grid[0])

        # 4 个指向单元格可能邻居的方向。
        dirs = [(1, 0), (0, 1), (-1, 0), (0, -1)]
        
        heap = []
        ans = grid[0][0] 

        # 把所有单元格的状态标记为 0（未访问）。
        visited = [[False] * C for _ in range(R)]
                
        # 把左上角的单元格放入优先队列，
        # 并标记为 true（已访问）。
        # 请注意，我们保存了单元格值的负数，因此我们始终可以使# 用最小堆数据结构弹出具有最大值的单元格。
        heapq.heappush(heap, (-grid[0][0], 0, 0))
        visited[0][0] = True
        
        # 当优先队列非空
        while heap:
            # 把值最大的单元格弹出
            cur_val, cur_row, cur_col = heapq.heappop(heap) 

            # 更新我们迄今访问的最小值。
            ans = min(ans, grid[cur_row][cur_col])

            # 如果我们到达了右下角的单元格，停止迭代。
            if cur_row == R - 1 and cur_col == C - 1:
                break
            for d_row, d_col in dirs:
                new_row = cur_row + d_row
                new_col = cur_col + d_col

                # 检查当前节点是否有未访问的邻居
                if 0 <= new_row < R and 0 <= new_col < C and not visited[new_row][new_col]:   
                    # 如果有，我们把这个邻居放入优先队列，
                    # 并把它标记为 true（已访问）。
                    heapq.heappush(heap, (-grid[new_row][new_col], new_row, new_col))
                    visited[new_row][new_col] = True

        # 返回我们看到的最小值，即此路径的值。
        return ans
```

**复杂度分析**

设 $n, m$ 为输入矩阵 $grid$ 的维度，$k$ 为该矩阵中的最大值。

* 时间复杂度：$O(n\cdot m\cdot \log (n \cdot m))$
  - 向优先队列中添加或从中弹出元素需要对数时间。优先队列的大小可以接近 $n \cdot m$，所以每次添加/移除操作将需要 $O(\log (n \cdot m))$ 的时间。
  - 在最坏的情况下，我们需要遍历矩阵中的每个单元格，这需要 $O(n \cdot m)$ 的添加/移除操作。
  - 总结一下，总的时间复杂度是 $O(n \cdot m\cdot \log (n \cdot m))$


* 空间复杂度：$O(n \cdot m)$
  - 我们使用了一个大小为 $O(n \cdot m)$ 的数组来存储每个单元格的已访问/未访问状态。
  - 在最坏情况下，我们需要遍历整个矩阵，这需要 $O(n \cdot m)$ 的空间进行一次遍历。
  - 因此，总的空间复杂度为 $O(n \cdot m)$。

---

#### 方法 5：并查集

**概述**

看下面这张图。假设彩色的单元格是 **已访问** 的单元格，灰色的单元格是 **未访问** 的单元格。我们可以通过左上角单元格到右下角单元格是否有 4 方向连通的路径来判断路径是否已经找到。

![image.png](https://pic.leetcode.cn/1691659014-DHXryZ-image.png){:width=400}

我们可以通过总是选择值最大的未访问单元格来最大化路径的得分。为了确定应该按什么顺序访问单元格，我们可以对它们的值进行排序。然后，我们按照从最大值到最小值的顺序遍历这些单元格。每次我们访问一个单元格时，我们将其标记为 **已访问**，并使用并查集数据结构将这个单元格和它的 **已访问** 的邻居单元格连接起来。

访问每个单元格后，我们检查左上角的单元格和右下角的单元格是否已经连接，如果是，那么说明他们之间存在至少一条 4 方向连通的路径，而我们最后访问的单元格就是这条路径的'最后一块拼图'。由于我们是按照单元格的值降序遍历的，所以最后访问的单元格的值就是这条路径中的最小值，因此，也是所有有效路径中的最大最小值。

<![image.png](https://pic.leetcode.cn/1691659702-XwrCBV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691659706-DFbqPf-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691659709-exstta-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691659713-bOFKYq-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691659716-nHGeDN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691659719-fclIYV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691659722-UfLVLh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691659725-HPQGmX-image.png){:width=400}>

**算法步骤**

1. 按照值的大小递减对所有单元格进行排序。
2. 从最大值开始遍历排序后的单元格，对于每个被访问的单元格，检查它是否有任何 4 方向连通的已访问邻居单元格，如果有，我们使用并查集数据结构将它和它的已访问的邻居连通。
3. 检查左上角的单元格是否与右下角的单元格连通。
   - 如果是，返回最后一个访问的单元格的值。
   - 如果否，从步骤 2 重复。

**实现**

```C++ [slu5]
class Solution {
    // uf 记录所有的根节点
    vector<int> uf;
    vector<int> rank;

    // 找到 x 的根节点。
    int find(int x) {
        if (x != uf[x]) {
            uf[x] = find(uf[x]);
        }
        return uf[x];
    }  

    // 合并 x 和 y 的根。
    void uni(int x, int y) {
        int rootX = find(x), rootY = find(y);
        if (rootX != rootY) {
            if (rank[rootX] > rank[rootY]) {
                uf[rootY] = rootX;
            } else if (rank[rootX] < rank[rootY]) {
                uf[rootX] = rootY;
            } else {
                uf[rootY] = rootX;
                rank[rootX] += 1;
            }
        }
    }

public:    
    int maximumMinimumPath(vector<vector<int>>& grid) {
        int R = grid.size(), C = grid[0].size();

        // 根据值排序单元格
        vector<vector<int>> vals;

        // 4 个指向单元格可能邻居的方向。
        vector<vector<int>> dirs{{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
        
        // 初始化所有单元格的秩
        rank = vector<int>(R * C, 1);

        // 所有 R * C 个单元格的根
        uf = vector<int>(R * C, 0);
        
        // 将所有单元格的状态初始化为 false（未访问）。
        vector<vector<bool>> visited(R, vector<bool>(C));

        // 初始化所有单元格的根。
        for (int row = 0; row < R; ++row) {
            for (int col = 0; col < C; ++col) {
                uf[row * C + col] = row * C + col;
                vals.push_back({grid[row][col], row, col});
            }
        }

        // 从大到小排序所有单元格
        sort(vals.begin(), vals.end(), greater<vector<int>>());
        
        // 对排序的单元格进行迭代。
        for (vector<int>& curGrid : vals) {
            int curRow = curGrid[1], curCol = curGrid[2];
            int curPos = curRow * C + curCol;

            // 把当前的单元格标记为已访问。
            visited[curRow][curCol] = true;
            for (vector<int> dir : dirs) {
                int newRow = curRow + dir[0], newCol = curCol + dir[1];
                int newPos = newRow * C + newCol;

                // 检查当前单元格是否有任何值
                // 大于或等于 val 的未访问邻居。
                if (newRow >= 0 && newRow < R && newCol >= 0 && newCol < C 
                    && visited[newRow][newCol]) {
                    // 如果是这样的话，我们将当前的单元格与该邻居连接。
                    uni(curPos, newPos);
                }
            }

            // 检查左上角的单元格和右下角的是否连接
            if (find(0) == find(R * C - 1)) { 
                // 如果是，返回当前单元格的值
                return grid[curRow][curCol];
            }
        }
        return 0;
    }
};
```

```Java [slu5]
class UF {
    // root 记录所有的根。
    private int[] root;
    private int[] rank;
    public UF(int R, int C) {
        rank = new int[R * C];
        root = new int[R * C];
        for (int i = 0; i < root.length; ++i) 
            root[i] = i;
    }

    // 找到 x 的根。
    public int find(int x) {
        if (x != root[x])
            root[x] = find(root[x]);
        return root[x];
    }

    // 连接 x 和 y 的根。
    public void union(int x, int y) {
        int rootX = find(x), rootY = find(y);
        if (rootX != rootY) {
            if (rank[rootX] > rank[rootY]) {
                root[rootY] = rootX;
            } else if (rank[rootX] < rank[rootY]) {
                root[rootX] = rootY;
            } else {
                root[rootY] = rootX;
                rank[rootX] += 1;
            }
        }
    }
}

class Solution {
    // 4 个指向单元格可能邻居的方向。
    private int[][] dirs = new int[][]{{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
    public int maximumMinimumPath(int[][] grid) {
        int R = grid.length, C = grid[0].length;

        // 按其值对所有单元格进行排序。
        List<int[]> vals = new ArrayList<>();

        // 初始化所有单元格的根
        // 并标记所有单元格为 false（未访问）
        boolean[][] visited = new boolean[R][C];

        // 所有 R * C 个单元格的根
        UF uf = new UF(R, C);

        // 初始化所有单元格的根。
        for (int row = 0; row < R; ++row)
            for (int col = 0; col < C; ++col)
                vals.add(new int[]{row, col});

        // 从大到小排序所有单元格
        Collections.sort(vals, (gridA, gridB) -> {
            return grid[gridB[0]][gridB[1]] - grid[gridA[0]][gridA[1]];
        });

        // 对排序的单元格进行迭代。
        for (int[] curGrid : vals) {
            int curRow = curGrid[0], curCol = curGrid[1];
            int curPos = curRow * C + curCol;

            // 把当前的单元格标记为已访问。
            visited[curRow][curCol] = true;
            for (int[] dir : dirs) {
                int newRow = curRow + dir[0];
                int newCol = curCol + dir[1];
                int newPos = newRow * C + newCol;

                // 检查当前单元格是否有任何值
                // 大于或等于 val 的未访问邻居。
                if (newRow >= 0 && newRow < R && newCol >= 0
                    && newCol < C && visited[newRow][newCol] == true) {
                    // 如果是这样的话，我们将当前的单元格与该邻居连接。
                    uf.union(curPos, newPos);
                }
            }

            // 检查左上角的单元格是否与右下角的单元格相连。
            if (uf.find(0) == uf.find(R * C - 1)) {
                // 如果是，则返回当前单元格的值。
                return grid[curRow][curCol];
            }
        }
        return -1;
    }
}
```

```Python3 [slu5]
class Solution:
    def maximumMinimumPath(self, grid: List[List[int]]) -> int:
        # 找到 x 的根。
        def find(x):
            if x != root[x]:
                root[x] = find(root[x])
            return root[x]
        
        # 连接 x 和 y 的根。
        def union(x, y):
            root_x = find(x)
            root_y = find(y)
            if root_x != root_y:
                if rank[root_x] > rank[root_y]:
                    root[root_y] = root_x
                elif rank[root_x] < rank[root_y]:
                    root[root_x] = root_y
                else:
                    root[root_y] = root_x
                    rank[root_x] += 1
                
        R = len(grid)
        C = len(grid[0])
        
        # 4 个指向单元格可能邻居的方向。
        dirs = [(1, 0), (0, 1), (-1, 0), (0, -1)]

        # 初始化所有单元格的秩
        rank = [1] * (R * C)

        # 初始化所有单元格的根
        root = list(range(R * C))

        # 将所有单元格标记为 false（未访问）。
        visited = [[False] * C for _ in range(R)]
        
        # 按从大到小的值对所有单元格进行排序。
        vals = [(row, col) for row in range(R) for col in range(C)]
        vals.sort(key = lambda x: grid[x[0]][x[1]], reverse = True)
        
        # 对排序的单元格进行迭代。
        for cur_row, cur_col in vals:
            cur_pos = cur_row * C + cur_col

            # 将当前单元格标记为 true（已访问）。
            visited[cur_row][cur_col] = True
            for d_row, d_col in dirs:
                new_row = cur_row + d_row
                new_col = cur_col + d_col
                new_pos = new_row * C + new_col

                # 检查当前单元格是否有任何值
                # 大于或等于 val 的未访问邻居。
                if 0 <= new_row < R and 0 <= new_col < C and visited[new_row][new_col]:
                    # If so, we connect the current cell with this neighbor.
                    union(cur_pos, new_pos)

            # 检查左上角的单元格是否与右下角的单元格相连。
            if find(0) == find(R * C - 1):
                # 如果是，则返回当前单元格的值。
                return grid[cur_row][cur_col]
        return -1
```


**复杂度分析**

设 输入矩阵 $grid$ 的维度为 $n, m$，矩阵中的最大值为 $k$。

- 时间复杂度：$O(n \cdot m \cdot \log (n \cdot m))$
  - 我们首先需要对网格中的所有元素进行排序，这需要 $O(n \cdot m \cdot \log (n \cdot m))$ 时间。
  - 接下来，在最坏情况下，我们需要遍历所有元素才能找到从左上角到右下角的路径。对于每个元素，我们用并查集将其和已访问的邻居元素联合，这操作的均摊复杂度是 $O(\alpha(n \cdot m))$ ，其中 $\alpha$ 是 Ackermann 函数。
  - 因此，总体时间复杂度是 $O(n \cdot m \cdot (\log (n \cdot m) + \alpha(n \cdot m)))$，简化后为 $O(n \cdot m \cdot \log (n \cdot m))$。


- 空间复杂度：$O(n \cdot m)$

  - 我们使用了一组大小为 $O(n \cdot m)$ 的数组来保存每个单元格的已访问/未访问状态，以及同样大小的数组来保存并查集中每个单元格的根和等级。最后，我们还使用了大小为 $O(n \cdot m)$ 的数组来按排序顺序存储每个单元格。
  - 因此，总体空间复杂度为 $O(n \cdot m)$。