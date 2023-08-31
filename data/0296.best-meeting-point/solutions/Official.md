## [296.最佳的碰头地点 中文官方题解](https://leetcode.cn/problems/best-meeting-point/solutions/100000/zui-jia-de-peng-tou-di-dian-by-leetcode-folxq)

[TOC]

 ## 解决方案

---

 #### 方法一 广度优先搜索[超过时间限制]

 一种暴力的方法是评估网格中的所有可能的碰头地点。我们可以从每个点开始应用广度优先搜索。
 在将一个点插入队列时，我们需要记录该点到碰头地点的距离。此外，我们还需要一个额外的 `visited` 表来记录哪个点已经被访问过，以避免再次被插入队列。

 ```Java
public int minTotalDistance(int[][] grid) {
    int minDistance = Integer.MAX_VALUE;
    for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[0].length; col++) {
            int distance = search(grid, row, col);
            minDistance = Math.min(distance, minDistance);
        }
    }
    return minDistance;
}

private int search(int[][] grid, int row, int col) {
    Queue<Point> q = new LinkedList<>();
    int m = grid.length;
    int n = grid[0].length;
    boolean[][] visited = new boolean[m][n];
    q.add(new Point(row, col, 0));
    int totalDistance = 0;
    while (!q.isEmpty()) {
        Point point = q.poll();
        int r = point.row;
        int c = point.col;
        int d = point.distance;
        if (r < 0 || c < 0 || r >= m || c >= n || visited[r][c]) {
            continue;
        }
        if (grid[r][c] == 1) {
            totalDistance += d;
        }
        visited[r][c] = true;
        q.add(new Point(r + 1, c, d + 1));
        q.add(new Point(r - 1, c, d + 1));
        q.add(new Point(r, c + 1, d + 1));
        q.add(new Point(r, c - 1, d + 1));
    }
    return totalDistance;
}

public class Point {
    int row;
    int col;
    int distance;
    public Point(int row, int col, int distance) {
        this.row = row;
        this.col = col;
        this.distance = distance;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度： $O(m^2n^2)$。 对于 $m \times n$ 大小的网格中的每个点，广度优先搜索最多需要 $m \times n$ 步才能到达所有点。因此，时间复杂度为 $O(m^2n^2)$。
 * 空间复杂度： $O(mn)$。 `visited`表由匹配网格中每个点的$m \times n$元素组成。我们最多插入$m \times n$点到队列中。

---

 #### 方法二 曼哈顿距离公式[超过时间限制]

 你可能注意到广度优先搜索是不必要的。你可以使用公式直接计算曼哈顿距离：
 $distance(p1, p2) = \left | p2.x - p1.x \right | + \left | p2.y - p1.y \right |$

 ```Java
public int minTotalDistance(int[][] grid) {
    List<Point> points = getAllPoints(grid);
    int minDistance = Integer.MAX_VALUE;
    for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[0].length; col++) {
            int distance = calculateDistance(points, row, col);
            minDistance = Math.min(distance, minDistance);
        }
    }
    return minDistance;
}

private int calculateDistance(List<Point> points, int row, int col) {
    int distance = 0;
    for (Point point : points) {
        distance += Math.abs(point.row - row) + Math.abs(point.col - col);
    }
    return distance;
}

private List<Point> getAllPoints(int[][] grid) {
    List<Point> points = new ArrayList<>();
    for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[0].length; col++) {
            if (grid[row][col] == 1) {
                points.add(new Point(row, col));
            }
        }
    }
    return points;
}

public class Point {
    int row;
    int col;
    public Point(int row, int col) {
        this.row = row;
        this.col = col;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度： $O(m^2n^2)$。 假设 $k$ 是房屋的总数。对于 $m \times n$ 大小的网格中的每个点，我们在 $O(k)$ 中计算曼哈顿距离。因此，时间复杂度为 $O(mnk)$. 但请注意，可能有多达 $m \times n$ 的房屋，使得最坏的情况时间复杂度为 $O(m^2n^2)$。
 * 空间复杂度： $O(mn)$。

---

 #### 方法三 排序

 在二维网格中寻找最佳的碰头地点似乎很困难。让我们退一步，解决这个更简单的一维情况。注意，曼哈顿距离是两个独立变量的总和。因此，一旦我们解决了一维的问题，我们就可以将二维的问题作为两个独立的一维问题来解决。
 让我们看一下下面的一维示例：

> 情况 #1 ：1-0-0-0-1
> 情况 #2 ：0-1-0-1-0

 我们知道最佳的碰头地点必须位于最左边的点和最右边的点之间的某个地方。对于上述两种情况，我们选择 $x = 2$ 处的中心点作为最佳的碰头地点。那么选择所有点的均值作为碰头地点呢？
 考虑这种情况：

 > 情况 #3 ：1-0-0-0-0-0-0-1-1

 使用平均值给出碰头地点 $\bar{x} = \frac{0 + 7 + 8}{3} = 5$。总距离是 $10$。
 但是最佳的碰头地点应该在 $x = 7$，总距离是 $8$。
 你可能会认为平均值*接近*最优点。但是想象一个更大的情况，许多的 1 聚集在右边，只有一个 1 在最左边。将平均值作为碰头地点将远不是最优的。
 除了平均值，还有什么更好的方法来表示点的分布呢？中位数是否更好的表示？的确。实际上，中位数*一定*是最佳的碰头地点。

 > 情况 #4 ：1-1-0-0-1

 要明白为什么是这样，让我们看看上面的情况 #4，并选择中位数 $x = 1$ 作为我们的初始碰头地点。假设总的行走距离是 *d*。注意，我们在其左侧和右侧有相等数量的点。现在让我们向右移动一步，其中 $x = 2$，并注意据此如何改变距离。
 由于 $x = 2$ 左边有两个点，我们给 *d* 加上 $2 * (+1)$。以及 *d* 由于右边有一个点而减去 1。 这意味着总的距离增加了 1。
 因此，一目了然的是：

只要点的左右两边有相等数量的点，总的距离就是最小的。

>  情况 #5 ：1-1-0-0-1-1

有人可能认为，最佳的碰头地点必须落在其中一个 1 上。对于有奇数个1的情况这是真的，但当有偶数个 1 时，就像情况＃5 一样，并不一定是这样。你可以选择从 $x = 1$ 到 $x = 4$ 的任何点，总的距离会被最小化。为什么呢？
首先我们收集行和列坐标，排序它们并选择它们的中间元素。然后，我们将总的距离计算为两个独立的一维问题的总和。

 ```Java
public int minTotalDistance(int[][] grid) {
    List<Integer> rows = new ArrayList<>();
    List<Integer> cols = new ArrayList<>();
    for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[0].length; col++) {
            if (grid[row][col] == 1) {
                rows.add(row);
                cols.add(col);
            }
        }
    }
    int row = rows.get(rows.size() / 2);
    Collections.sort(cols);
    int col = cols.get(cols.size() / 2);
    return minDistance1D(rows, row) + minDistance1D(cols, col);
}

private int minDistance1D(List<Integer> points, int origin) {
    int distance = 0;
    for (int point : points) {
        distance += Math.abs(point - origin);
    }
    return distance;
}
 ```

上述代码中我们不需要对 *rows* 排序，为什么？

**复杂度分析**

 * 时间复杂度： $O(mn \log mn)$。 因为最多可能有 $m \times n$ 点，因此由于排序，时间复杂度是$O(mn \log mn)$。
 * 空间复杂度： $O(mn)$。

---

 #### 方法四 按排序顺序收集坐标

 我们可以使用选择算法在 $O(mn)$ 时间内选择中位数，但有一个更简单的方法 。注意，我们可以按排序的顺序收集行和列坐标。

 ```java
public int minTotalDistance(int[][] grid) {
    List<Integer> rows = collectRows(grid);
    List<Integer> cols = collectCols(grid);
    int row = rows.get(rows.size() / 2);
    int col = cols.get(cols.size() / 2);
    return minDistance1D(rows, row) + minDistance1D(cols, col);
}

private int minDistance1D(List<Integer> points, int origin) {
    int distance = 0;
    for (int point : points) {
        distance += Math.abs(point - origin);
    }
    return distance;
}

private List<Integer> collectRows(int[][] grid) {
    List<Integer> rows = new ArrayList<>();
    for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[0].length; col++) {
            if (grid[row][col] == 1) {
                rows.add(row);
            }
        }
    }
    return rows;
}

private List<Integer> collectCols(int[][] grid) {
    List<Integer> cols = new ArrayList<>();
    for (int col = 0; col < grid[0].length; col++) {
        for (int row = 0; row < grid.length; row++) {
            if (grid[row][col] == 1) {
                cols.add(col);
            }
        }
    }
    return cols;
}
 ```

 **复杂度分析**

 * 时间复杂度： $O(mn)$。
 * 空间复杂度： $O(mn)$。