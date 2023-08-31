## [1274.矩形内船只的数目 中文官方题解](https://leetcode.cn/problems/number-of-ships-in-a-rectangle/solutions/100000/ju-xing-nei-chuan-zhi-de-shu-mu-by-leetcode-soluti)

## 解决方案 

---

#### 概述 

 海域中随机点有一些船只。我们得到了两个坐标，它们分别代表着表示 `海洋` 部分的矩形的 `左下` 角和 `右上` 角。在这个区域内可以有多达 10 艘船在不同的坐标内，我们可以问游戏主人在给定的 `海洋` 子区域内是否有任何船只。 游戏的一个条件是我们最多可以问这个问题 400 次；为了赢得游戏，我们必须找到确切的船只数目。 

 ![Ships_Introduction.png](https://pic.leetcode.cn/1691659902-RPiTWn-Ships_Introduction.png){:width=400}


 这个问题看起来像个非常令人迷惑的游戏，但这反而使得问题更有趣。 

 任何坐标上只能有一艘船，所以让我们计算可能的最大点数。 根据问题描述，笛卡尔坐标系的最大尺寸是（1,000 × 1,000），这意味着可能存在船只的坐标点的最大数目为 1,000,000。我们只有 400 次找到船只的机会，所以这里不能使用暴力方法；我们必须要聪明点！ 

---

#### 方法 1：分治 + 四分查找

 **思路** 
 因为我们只允许 400 次猜测，但 `海洋` 中可能有多达一百万个点，我们知道检查每一个坐标不是一个可行的策略。然而，通过从一个较大的区域开始，递归地检查越来越小的区域，我们可以消除任何不含有一艘船的区域，从而将我们的搜索限制在剩余的区域内。 
 通过这种方式，我们可以使用排除法将我们的搜索集中到正确的方向。为了应用这个方法，我们首先需要将矩形的笛卡尔坐标平面分成一定数量的大致相等的部分。 
 对每一个子矩形，我们将对方法 `hasShip()` 做一个单独的调用。如果一个子矩形内没有船，可以消除它从未来的搜索中。 
 对剩下的子矩形我们可以进行类似的搜索过程，直到左下角和右上角的坐标收敛到一个点（这就是船只的位置）。 

 > 在这个解决方案中，我们将问题分解成子问题，直到子问题可以在没有进一步分解的情况下解决。这样的解决方案可以递归地实现。 

 现在，重要的问题是_每一步的子矩形的最优数量是什么？_ 
 让我们考虑将矩形大致分成4个相等的部分。 因此，我们将对 `hasShip()` 做 4 次调用，以确定每个子矩形内是否有船只；然后，任何空的子矩形可以从搜索空间中消除。 

 以下图示说明了这个想法。 

 ![image.png](https://pic.leetcode.cn/1691736483-MOQAYS-image.png){:width=900}

 _分析_ 

 由于我们将每个矩形递归地分成4个子矩形，所以在递归树的每一个层级，我们将有 $4^{level}$ 个可能的子矩形。 

 ![image.png](https://pic.leetcode.cn/1691736677-SlkBVU-image.png){:width=900}

 _计算层数：_ 

 从问题说明中，我们知道原始矩形的最大尺寸为 $(1000 \cdot 1000)$。 

 如果我们递归地将这个矩形划分成四个相等的子矩形，那么每个层级的最大数量是 $\log_4 (1000000) \approx 10$  

 因此，对于任何给定的输入，最大层数将不会超过 10。 

 _计算子矩形的数量：_ 

 假设在 `海洋` 的每一个坐标点上都有一艘船。那么，在上述递归图中，每个坐标都将是一个叶节点。我们需要超过一百万次调用 `hasShip()` 来找出确切的船只数量，但我们只允许调用 $400$ 次。我们怎样才能解决这个问题呢？ 

 > 提示：再读一遍问题陈述。 

 让我们仔细看看问题陈述。它指出，在矩形中最多可以有 10 艘船。这意味着，在最坏的情况下，如果每个子矩形最多包含一艘船，那么在任何层级上最多可以有 10 个非空的子矩形。 因此，每个递归层次的子矩形的最大数目是 40（10 个含有船只的，和 30 个空的）。 
 对于每个包含船只的子矩形，我们将对 `hasShip()` 进行 $4$ 次递归调用。因此，即使在最坏的情况下，对 `hasShip()` 的总调用数也将小于船只数量 $(10)$ 倍的 $4$ 倍乘以最大层数 $(\log_4 (1000 \cdot 1000) = 10)$。也就是说，$10 \cdot 4 \cdot 10 = 400$。 

![image.png](https://pic.leetcode.cn/1691736486-SxgQpa-image.png){:width=900}

 **算法** 

 > 这种将问题划分为更多同类或相关类型的子问题的技术，直到这些问题变得简单到可以直接解决，被称为 _分治法_。 

1. 检查由 `右上` 角和 `左下` 角坐标给出的当前矩形，是否包含一艘船。如果有，将矩形分成 4 个子矩形，并递归地找出每个子矩形中的船只数量。 
   否则，终止搜索过程。因此，在每一步，我们都会排除所有不包含一艘船的矩形。 
2. 要将矩形分成四个相等的部分，我们首先需要定义X轴和Y轴的中心坐标 `midX` 和 `midY`；从而形成 4 个子矩形。下图阐述了这个想法。 

   ![Sub_Rectangle_Mid_Position.png](https://pic.leetcode.cn/1691660348-WcTvIx-Sub_Rectangle_Mid_Position.png){:width=900}

   ![Rectangle_Four_Division.png](https://pic.leetcode.cn/1691660389-JenpoZ-Rectangle_Four_Division.png){:width=900}

3. 对于每一个子矩形，递归地计算船只的数量。给定矩形中船只的数量将是每个子矩形递归调用返回的船只的总和。 
4. 当满足以下条件之一时，递归搜索过程将终止： 
   i. 矩形中没有船只。 
   ii. 不能再进一步划分矩形，也就是矩形代表一个单一的点。当 `右上` 坐标等于 `左下` 坐标时，这个条件成立。 

 **代码实现** 
```C++ [slu1]
class Solution {
public:
    int countShips(Sea sea, vector<int> topRight, vector<int> bottomLeft) {
        // 如果当前矩形不包含船，则返回 0。       
        if (bottomLeft[0] > topRight[0] || bottomLeft[1] > topRight[1])
            return 0;
        if (!sea.hasShips(topRight, bottomLeft))
            return 0;

        // 如果矩形代表一个点，则定位了一艘船
        if (topRight[0] == bottomLeft[0] && topRight[1] == bottomLeft[1])
            return 1;

        // 递归地检查 4 个子矩形中的船
        int midX = (topRight[0] + bottomLeft[0]) / 2;
        int midY = (topRight[1] + bottomLeft[1]) / 2;
        return countShips(sea, {midX, midY}, bottomLeft) +
               countShips(sea, topRight, {midX + 1, midY + 1}) +
               countShips(sea, {midX, topRight[1]}, {bottomLeft[0], midY + 1}) +
               countShips(sea, {topRight[0], midY}, {midX + 1, bottomLeft[1]});
    }
};
```
```Java [slu1]
class Solution {
    public int countShips(Sea sea, int[] topRight, int[] bottomLeft) {
        // 如果当前矩形不包含船，则返回 0。         
        if (bottomLeft[0] > topRight[0] || bottomLeft[1] > topRight[1])
            return 0;
        if (!sea.hasShips(topRight, bottomLeft))
            return 0;

        // 如果矩形代表一个点，则定位了一艘船
        if (topRight[0] == bottomLeft[0] && topRight[1] == bottomLeft[1])
            return 1;

        // 递归地检查 4 个子矩形中的船
        int midX = (topRight[0] + bottomLeft[0]) / 2;
        int midY = (topRight[1] + bottomLeft[1]) / 2;
        return countShips(sea, new int[]{midX, midY}, bottomLeft) +
               countShips(sea, topRight, new int[]{midX + 1, midY + 1}) +
               countShips(sea, new int[]{midX, topRight[1]}, new int[]{bottomLeft[0], midY + 1}) +
               countShips(sea, new int[]{topRight[0], midY}, new int[]{midX + 1, bottomLeft[1]});
    }
}
```
```Python3 [slu1]
class Solution:
    def countShips(self, sea: 'Sea', topRight: 'Point', bottomLeft: 'Point') -> int:
        # 如果当前矩形不包含船，则返回 0。           
        if (bottomLeft.x > topRight.x) or (bottomLeft.y > topRight.y):
            return 0
        if not sea.hasShips(topRight, bottomLeft):
            return 0

        # 如果矩形代表一个点，则定位了一艘船
        if (topRight.x == bottomLeft.x) and (topRight.y == bottomLeft.y):
            return 1

        # 递归地检查 4 个子矩形中的船
        mid_x = (topRight.x + bottomLeft.x) // 2
        mid_y = (topRight.y + bottomLeft.y) // 2
        return self.countShips(sea, Point(mid_x, mid_y), bottomLeft) + \
               self.countShips(sea, topRight, Point(mid_x + 1, mid_y + 1)) + \
               self.countShips(sea, Point(mid_x, topRight.y), Point(bottomLeft.x, mid_y + 1)) + \
               self.countShips(sea, Point(topRight.x, mid_y), Point(mid_x + 1, bottomLeft.y))

```

 **复杂度分析** 
 假设 $M$ 是 `bottomLeft[0]` 与 `topRight[0]` 之间可能的x坐标值的范围，$N$ 是 `bottomLeft[1]` 和 `topRight[1]` 之间可能的y坐标值的范围。因此，矩形中最大可能的点数为 $M \cdot N$。最后，让 $S$ 是海洋中船只的最大数量。 

 * 时间复杂度: $O(S \cdot (\log_2 \max(M, N) - \log_4 S))$ 
   每次调用 `countShips` 只需要常数时间，所以时间复杂度将是 $O(1)$ 倍的 `countShips` 的最大可能调用次数。 
     最坏的情况是当有最大可能数量的船只 $(S = 10)$，并且它们分布在经过 $S$ 次递归调用后的 $S$ 个区域（递归树的 $\log_4 S$ 层）中，每个区域都包含 $1$ 艘船，其余区域是空的。 
     每个含有 $1$ 艘船的区域，将产生 $4$ 个递归调用。其中 $3$ 个将返回 $0$ 因为它们不含有船，$1$ 个调用将产生 $4$ 个更多的递归调用，因为它含有船。这个过程将重复，直到我们在递归调用中指出了船只的精确坐标。 
     最晚，我们会在递归树的最大深度指出船只，深度为 $\log_2 \max(M, N)$，因为在每个递归调用中，我们为每个$2$维将搜索空间减半。 
     因此，一旦一个区域只含有 $1$ 艘船，可能仍需要 $4 \cdot (\log_2 \max(M, N) - \log_4 S)$ 的递归调用次数才能指出船只的位置（并返回 $1$）。而且因为有 $S$ 艘船，所以在所有区域中至多有 $1$ 艘船后的递归调用总数是 $4 \cdot S \cdot (\log_2 \max(M, N) - \log_4 S)$。 
     综上，时间复杂度是 $S + 4 \cdot S \cdot (\log_2 \max(M, N) - \log_4 S)$，在最坏的情况下（当 $S = 10$ 且 $M = N = 1000$），需要 $342$ 个递归调用。 
 * 空间复杂度: $O(\log_2 \max(M, N))$. 
   对 `countShips` 的每一次调用只需要常量空间，所以我们的空间复杂度直接与递归调用栈的最大高度有关。由于我们有 2 个分别是 M 和 N 的维度，并且在每次递归调用 `countShips` 时，每个维度的搜索空间都会减半，递归调用栈的最大高度将为 $\log_2 \max(M, N)$。



#### 方法 2：分治 + 二分查找

在方法 1 中，我们使用将一个区域分成四个小区域的方法，通过递归查找，得到船只的数目。由于题目中的船只数量最多为 `10`，它相对于最大的区域范围 `(1000, 1000) ~ (0, 0)` 而言是一个很小的数目，因此可以预见的是，我们会进行很多次失败（即 API 返回 `False`）的查找。例如当区域的大小为 `8 * 8` 但其中只有一艘船只时，我们会进行

```
1 次对 8 * 8 区域的查找，返回 True
4 次对 4 * 4 区域的查找，其中 1 次返回 True，3 次返回 False
4 次对 2 * 2 区域的查找，其中 1 次返回 True，3 次返回 False
4 次对 1 * 1 区域的查找，其中 1 次返回 True，3 次返回 False
```

总计 `13` 次 API 调用。

那么有什么办法可以减少失败的查找次数呢？设想一下，如果我们将区域仅划分为两个小区域 `A` 和 `B`，那么当对 `A` 区域调用 API 返回 `False` 时，我们可以直接断定，对 `B` 区域调用 API 一定会返回 `True`，这样就省去了一次 API 的调用。使用划分为两个而不是四个小区域的方法，我们会进行

```
1 次对 8 * 8 区域的查找，返回 True
1~2 次对 4 * 8 区域的查找，取决于第 1 个 4 * 8 区域是否返回 False
1~2 次对 2 * 8 区域的查找
1~2 次对 1 * 8 区域的查找
1~2 次对 1 * 4 区域的查找
1~2 次对 1 * 2 区域的查找
1~2 次对 1 * 1 区域的查找
```

总计 `7 ~ 13` 次，平均 `10` 次的 API 调用，优于方法 1 中的 `13` 次。

综上所述，我们得到了一种更优的方法：

- 我们从最大的区域开始查找；

- 对于当前的查找区域：

  - 如果它不是矩形，我们返回 `0`；

  - 如果它被断定为返回 `True`，我们可以不用调用 API，直接令 API 返回 `True`；如果它未被断定，则调用 API 并得到返回值；

  - 如果 API 返回 `False`，我们返回 `0`，表示区域内没有船只；

  - 如果 API 返回 `True`，此时有两种情况：如果当前查找的区域为一个点，我们返回 `1`，表示找到了一艘船只；否则我们将该区域划分成两个小区域 `A` 和 `B`，递归地进行查找。如果小区域 `A` 递归的结果为 `0`，那么我们断定对小区域 `B` 调用 API 一定会返回 `True`，省去一次 API 的调用；

  - 返回的值为对区域 `A` 和 `B` 递归查找的返回值之和，即表示当前查找的区域内船只的数目。

```C++ [sol2]
class Solution {
public:
    int countShips(Sea& sea, vector<int> topRight, vector<int> bottomLeft, bool claim = false) {
        int x1 = topRight[0], y1 = topRight[1];
        int x2 = bottomLeft[0], y2 = bottomLeft[1];

        if (x1 < x2 || y1 < y2) {
            return 0;
        }

        bool judge = (claim ? true : sea.hasShips(topRight, bottomLeft));
        if (!judge) {
            return 0;
        }
        if (x1 == x2 && y1 == y2) {
            return 1;
        }

        if (x1 == x2) {
            int ymid = (y1 + y2) / 2;
            int A = countShips(sea, {x1, ymid}, {x1, y2});
            return A + countShips(sea, {x1, y1}, {x1, ymid + 1}, A == 0);
        }
        else {
            int xmid = (x1 + x2) / 2;
            int A = countShips(sea, {xmid, y1}, {x2, y2});
            return A + countShips(sea, {x1, y1}, {xmid + 1, y2}, A == 0);
        }
    }
};
```

```Python [sol2]
class Solution(object):
    def countShips(self, sea: 'Sea', topRight: 'Point', bottomLeft: 'Point', claim: bool=False) -> int:
        x1, y1 = topRight.x, topRight.y
        x2, y2 = bottomLeft.x, bottomLeft.y

        if x1 < x2 or y1 < y2:
            return 0

        judge = True if claim else sea.hasShips(topRight, bottomLeft)
        if not judge:
            return 0
        if (x1, y1) == (x2, y2):
            return 1

        if x1 == x2:
            ymid = (y1 + y2) // 2
            A = self.countShips(sea, Point(x1, ymid), Point(x1, y2))
            return A + self.countShips(sea, Point(x1, y1), Point(x1, ymid + 1), A == 0)
        else:
            xmid = (x1 + x2) // 2
            A = self.countShips(sea, Point(xmid, y1), Point(x2, y2))
            return A + self.countShips(sea, Point(x1, y1), Point(xmid + 1, y2), A == 0)
```

**复杂度分析**

本题要求 API 的调用次数不能超过 `400` 次，因此我们用 API 被调用的平均次数来衡量时间复杂度。在右上角坐标为 `(1000, 1000)`，左下角坐标为 `(0, 0)`，船只数量为 `10` 且随机生成的情况下，API 平均调用的次数约为 `257`，优于方法 1 。在上面的 `8 * 8` 区域中仅有一艘船只的例子中，方法 1 平均调用 `13` 次 `API` 而方法二平均调用 `10` 次 `API`，根据方法 1 的总平均调用次数 `326`，我们计算出 `326 * (10/13) = 250.8` 与 `257` 十分接近。