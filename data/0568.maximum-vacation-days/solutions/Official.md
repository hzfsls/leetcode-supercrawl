## [568.最大休假天数 中文官方题解](https://leetcode.cn/problems/maximum-vacation-days/solutions/100000/zui-da-xiu-jia-tian-shu-by-leetcode-solu-d4fz)
[TOC]

## 解决方法

---

#### 方法 1：深度优先搜索 [超过时间限制]

 **算法**
 在暴力解法中，我们使用了递归函数 $dfs$，这个函数返回从当前城市 $cur\_city$ 和当前周 $weekno$ 开始可以休的假期的数量。
 在每次函数调用中，我们遍历所有的城市（用 $i$ 表示），找出所有与当前城市 $cur_city$ 相连的城市。如果在 $flights[cur_city][i]$ 位置有个 1，说明有一条连接到这个城市。现在，对于当前城市，我们可以选择旅行到与其相连的城市，也可以停留在相同的城市。假设我们将从当前城市变化的新位置的城市用 $j$ 表示。因此，改变城市后，我们需要查找我们可以从新城市作为当前城市和增加的周作为新的开始周度假的数量。这个度假数量可以表示为：$days[j][weekno] + dfs(flights, days, j, weekno + 1)$。
 因此，对于当前城市，我们通过选择不同的城市作为下一个城市获取了一些假期。对于所有这些来自不同城市的假期，我们可以找出需要返回的每次 $dfs$ 函数调用的最大假期数量。

 ```Java [solution]
public class Solution {
    public int maxVacationDays(int[][] flights, int[][] days) {
        return dfs(flights, days, 0, 0);
    }
    public int dfs(int[][] flights, int[][] days, int cur_city, int weekno) {
        if (weekno == days[0].length)
            return 0;
        int maxvac = 0;
        for (int i = 0; i < flights.length; i++) {
            if (flights[cur_city][i] == 1 || i == cur_city) {
                int vac = days[i][weekno] + dfs(flights, days, i, weekno + 1);
                maxvac = Math.max(maxvac, vac);
            }
        }
        return maxvac;
    }
}
 ```

 **复杂度分析**

* 时间复杂度：$O(n^k)$。递归树的深度将是 $k$，并且在最糟糕的情况下，每个节点包含 $n$ 个分支。这里 $n$ 代表城市的数量，$k$ 是周总数。
* 空间复杂度：$O(k)$。递归树的深度是 $k$。

---

#### 方法 2：DFS 与记忆化

 **算法**
 在上一个方法 中，我们执行了许多重复的函数调用，因为同样的函数调用 `dfs(flights, days, cur_city, weekno)` 可以用相同的 $cur\_city$ 和 $weekno$ 执行多次。如果我们使用备忘录，我们可以减少这些冗余调用。
 为了消除这些冗余的函数调用，我们使用一个二维的备忘录数组 $memo$。在这个数组中，$memo[i][j]$ 用于存储使用第 $i^{th}$ 城市作为当前城市和第 $j^{th}$ 周作为起始周可以休的假期数量。这个结果等同于通过函数调用获得的结果：`dfs(flights, days, i, j)`。因此，如果当前函数调用对应的 $memo$ 条目已经包含一个有效值，我们可以直接从这个数组中获取结果，而不需要进一步深入到递归中。

 ```Java [solution]
public class Solution {
    public int maxVacationDays(int[][] flights, int[][] days) {
        int[][] memo = new int[flights.length][days[0].length];
        for (int[] l: memo)
            Arrays.fill(l, Integer.MIN_VALUE);
        return dfs(flights, days, 0, 0, memo);
    }
    public int dfs(int[][] flights, int[][] days, int cur_city, int weekno, int[][] memo) {
        if (weekno == days[0].length)
            return 0;
        if (memo[cur_city][weekno] != Integer.MIN_VALUE)
            return memo[cur_city][weekno];
        int maxvac = 0;
        for (int i = 0; i < flights.length; i++) {
            if (flights[cur_city][i] == 1 || i == cur_city) {
                int vac = days[i][weekno] + dfs(flights, days, i, weekno + 1, memo);
                maxvac = Math.max(maxvac, vac);
            }
        }
        memo[cur_city][weekno] = maxvac;
        return maxvac;
    }
}
 ```

 **复杂度分析**

* 时间复杂度：$O(n^2k)$。 大小为 $n*k$ 的 $memo$ 数组被填满，每个单元格填充需要 O(n) 的时间。
* 空间复杂度：$O(n*k)$。 使用了大小为 $n*k$ 的 $memo$ 数组。这里 $n$ 代表城市的数量，$k$ 是周总数。

---

#### 方法 3：二维动态规划法

 **算法**
 这个方法的思想如下。给定我们从第 $i^{th}$ 城市在第 $j^{th}$ 周开始，可以休假的最大数量并不取决于可以在以前的几周里休假的数量。它只取决于在接下来的几周里可以休假的数量，以及各个城市之间的连接（$flights$）。
 因此，我们可以使用一个二维的 $dp$，其中 $dp[i][k]$ 表示从第 $i^{th}$ 城市在第 $k^{th}$ 周开始可以休假的最大数量。这个 $dp$ 是以反向方式（就周数而言）填满的。
 在填充 $dp[i][k]$ 的条目时，我们需要考虑以下两种情况：

1. 我们从第 $i^{th}$ 城市在第 $k^{th}$ 周开始，并在同一城市待到第 $(k+1)^{th}$ 周。因此，更新 $dp[i][k]$ 条目时要考虑的因素为：$days[i][k] + dp[i, k+1]$。
2. 我们从第 $i^{th}$ 城市在第 $k^{th}$ 周开始，并在第 $(k+1)^{th}$ 周移动到第 $j^{th}$ 城市。但是，为了以这种方式改变城市，我们需要能够从第 $i^{th}$ 城市移动到第 $j^{th}$ 城市，也就是说 $flights[i][j]$ 应该是 1。
 但是，当在第 $k^{th}$ 周从第 $i^{th}$ 城市改变时，我们可以移动到任何一个与第 $i^{th}$ 城市相连的第 $j^{th}$ 城市，也就是说 $flights[i][j]=1$。 但是，为了最大化从第$i^{th}$城市在第$k^{th}$周开始可以得到的假期数量，我们需要选择能够带来最多假期的目标城市。因此，这里要考虑的因素为：$\text{max}days[j][k] + days[j, k+1]$，所有 $i$, $j$, $k$满足$flights[i][j] = 1$， $0 &leq; i,j &leq; n$，这里 $n$ 是城市的数量。
  最后，我们需要找到这两个因素中的最大值以更新 $dp[i][k]$ 值。
  为了填充 $dp$ 的值，我们从填充最后一周的条目开始并逆向进行。最后，$dp[0][0]$ 的值就是所需的结果。
  下面的动画演示了如何填充 $dp$ 数组的过程。

 <![image.png](https://pic.leetcode.cn/1692170218-LXcQAo-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692170222-YmnFWs-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692170225-abZoHD-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692170228-zdLweM-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692170231-hhQbNs-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692170234-mRWDJN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692170237-belNha-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692170240-cZQzaN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692170242-UXihcO-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692170245-jKXHxV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692170248-SPnZNY-image.png){:width=400}>

 ```Java [solution]
public class Solution {
    public int maxVacationDays(int[][] flights, int[][] days) {
        if (days.length == 0 || flights.length == 0) return 0;
        int[][] dp = new int[days.length][days[0].length + 1];
        for (int week = days[0].length - 1; week >= 0; week--) {
            for (int cur_city = 0; cur_city < days.length; cur_city++) {
                dp[cur_city][week] = days[cur_city][week] + dp[cur_city][week + 1];
                for (int dest_city = 0; dest_city < days.length; dest_city++) {
                    if (flights[cur_city][dest_city] == 1) {
                        dp[cur_city][week] = Math.max(days[dest_city][week] + dp[dest_city][week + 1], dp[cur_city][week]);
                    }
                }
            }
        }
        return dp[0][0];
    }
}
 ```

 **复杂度分析**

* 时间复杂度：$O(n^2k)$。大小为 $n*k$ 的 $dp$ 数组被填满，每个单元格填充需要 O(n) 的时间。这里 $n$ 代表城市的数量，$k$ 是周总数。
* 空间复杂度：$O(n*k)$。使用了大小为 $n*k$ 的 $dp$ 数组。

---

#### 方法 4：一维动态规划法

 **算法**
 如前一个方法中所观察的，为了更新第 $i^{th}$ 周的 $dp$ 的条目，我们只需要第 $(i+1)^{th}$ 周的值，以及 $days$ 和 $flights$ 数组。因此，我们可以省略一个维度，而不是使用一个二维的 $dp$ 数组，可以使用一个一维的 $dp$ 数组。
 现在，$dp[i]$ 被用来存储给定我们从第 $i^{th}$ 城市在当前周开始可以得到的假期数量。过程与前一种方法相同，除了我们在同一个 $dp$ 行一次又一次地进行更新。为了临时存储当前周对应的 $dp$ 值，我们使用一个 $temp$ 数组来保存他们，这样第 $week+1$ 周的原始 $dp$ 条目就不会被改变。

 ```Java [solution]
public class Solution {
    public int maxVacationDays(int[][] flights, int[][] days) {
        if (days.length == 0 || flights.length == 0) return 0;
        int[] dp = new int[days.length];
        for (int week = days[0].length - 1; week >= 0; week--) {
            int[] temp = new int[days.length];
            for (int cur_city = 0; cur_city < days.length; cur_city++) {
                temp[cur_city] = days[cur_city][week] + dp[cur_city];
                for (int dest_city = 0; dest_city < days.length; dest_city++) {
                    if (flights[cur_city][dest_city] == 1) {
                        temp[cur_city] = Math.max(days[dest_city][week] + dp[dest_city], temp[cur_city]);
                    }
                }
            }
            dp = temp;
        }

        return dp[0];
    }
}
 ```

 **复杂度分析**

* 时间复杂度：$O(n^2k)$。$dp$ 数组的大小是 $n*k$ 被填满，并且每个单元格的填充需要 O(n) 的时间。这里 $n$ 代表城市的数量，$k$ 是周总数。
* 空间复杂度：$O(k)$。使用了大小为 $nk$ 的 $dp$ 数组。