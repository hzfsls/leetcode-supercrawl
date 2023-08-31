## [1182.与目标颜色间的最短距离 中文官方题解](https://leetcode.cn/problems/shortest-distance-to-target-color/solutions/100000/yu-mu-biao-yan-se-jian-de-zui-duan-ju-chi-by-leetc)
[TOC]

## 解决方案

---

#### 方法一：二分查找

 **算法简述**
 给定一个数组 `colors` 和一系列查询，每个查询包含两个整数 `i` 和 `c`，我们希望找到 `i` 和目标颜色 `c` 之间的最短距离。 最直接的方法是：对于包含索引 `i` 和颜色 `c` 的每个查询，查找数组中 `c` 的所有出现。对于每个出现，计算它和索引 `i` 之间的距离。返回找到的最短距离。
 然而，上述方法会浪费时间去处理颜色不为 `c` 的元素。 为了解决这个问题，我们可以首先初始化三个列表；每个颜色一个。然后我们可以遍历 `colors`，把每个索引放入其相应的颜色列表。然后当我们遍历查询列表时，我们只需要查看对应 `c` 的列表。存储这些列表最合理的方式是使用一个哈希映射；键是颜色，值是列表。

 <![image.png](https://pic.leetcode.cn/1692088146-MHcARk-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692088149-FvNMvA-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692088151-hPdSkQ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692088154-ViQBEg-image.png){:width=400}>

 我们已经取得了巨大的改进，但我们可以做的更好！事实上，我们不必扫描给定查询 `i` 和 `c` 的整个列表； 因为我们按从 `0` 到 `n` 的顺序插入索引，所以每个列表中的值是已排序的。 因此，我们可以使用二分查找找到最接近 `i` 的值。使用二分查找将时间复杂度从线性提高到对数。
 **算法步骤**

 - 初始化一个哈希映射，将每个颜色映射到一个索引列表。 
 - 遍历 `colors` 并将每个索引放入哈希映射的相应列表。 
 - 对于包含索引 `i` 和颜色 `c` 的查询：  
 - 如果 `c` 不在哈希映射的键中，那么我们知道 `colors` 不包含 `c`，因此应该返回 `-1`，如问题描述中所述；  
 - 否则，我们想找到 `i` 在其对应颜色列表 `indexList` 中的位置，以保持排序顺序：  
 - 如果 `i` 小于 `indexList` 中的所有元素，那么最短距离是 `i - indexList[0]`；  
 - 否则如果 `i` 大于颜色列表中的所有元素，那么最短距离是 `indexList[indexList.size() - 1] - i`；  
 - 否则，最靠近 `i` 的 `c` 出现位置（近邻）应该在插入位置或其前一个位置，我们计算 `i` 到两者之间的距离，并返回最小者。

> **面试技巧**：是否应该自己实现二分查找算法，或者使用内置的二分查找，是一个挑战。有些面试官希望你能实现自己编写，因为这是他们评估你的一部分。其他人可能希望你使用内置的二分查找，因为自己编写经常被视为糟糕的 *软件工程* 实践。 安全起见，我们建议你向面试官询问 *你是否可以使用内置的* 二分查找。如果他们说这是你的选择，那么我们建议使用内置的二分查找，因为这被认为是软件工程的最佳实践。 要了解更多关于实现二分查找的知识，请查看我们的LB https://leetcode.cn/leetbook/detail/binary-search/

```Java [solution]
class Solution {
    public List<Integer> shortestDistanceColor(int[] colors, int[][] queries) {
        // 初始化
        List<Integer> queryResults = new ArrayList<>();
        Map<Integer, List<Integer>> hashmap = new HashMap<>();

        for (int i = 0; i < colors.length; i++) {
            hashmap.putIfAbsent(colors[i], new ArrayList<Integer>());
            hashmap.get(colors[i]).add(i);
        }

        // 对每个 query 都应用二分查找
        for (int i = 0; i < queries.length; i++) {
            int target = queries[i][0], color = queries[i][1];
            if (!hashmap.containsKey(color)) {
                queryResults.add(-1);
                continue;
            }

            List<Integer> indexList = hashmap.get(color);
            int insert = Collections.binarySearch(indexList, target);

            // 根据它的性质，我们从 Collections.binarySearch 需要转换返回值
            // 更多信息: https://docs.oracle.com/en/java/javase/12/docs/api/java.base/java/util/Collections.html#binarySearch(java.util.List,T)
            if (insert < 0) {
                insert = (insert + 1) * -1;
            }

            // 在下列情况下进行特殊处理:
            // - 目标索引小于indexList中的所有元素
            // - 目标索引大于indexList中的所有元素
            // - 目标索引位于左右边界之间
            if (insert == 0) {
                queryResults.add(indexList.get(insert) - target);
            } else if (insert == indexList.size()) {
                queryResults.add(target - indexList.get(insert - 1));
            } else {
                int leftNearest = target - indexList.get(insert - 1);
                int rightNearest = indexList.get(insert) - target;
                queryResults.add(Math.min(leftNearest, rightNearest));
            }

        }
        return queryResults;
    }
}
```

```Python3 [solution]
class Solution:
    def shortestDistanceColor(self, colors: List[int], queries: List[List[int]]) -> List[int]:
        hashmap = collections.defaultdict(list)
        for i,c in enumerate(colors):
            hashmap[c].append(i)

        query_results = []
        for i, (target, color) in enumerate(queries):
            if color not in hashmap:
                query_results.append(-1)
                continue

            index_list = hashmap[color]
            # 使用 Python 标准库中的 bisect
            # 更多信息: https://docs.python.org/3/library/bisect.html
            insert = bisect.bisect_left(index_list, target)

            # 比较insert的左右索引
            # 确保它不会超过index_list
            left_nearest = abs(index_list[max(insert - 1, 0)] - target)
            right_nearest = abs(index_list[min(insert, len(index_list) - 1)] - target)
            query_results.append(min(left_nearest, right_nearest))

        return query_results
```

```Golang
func shortestDistanceColor(colors []int, queries [][]int) []int {
    m := make(map[int][]int)
    for i, c := range colors {
        m[c] = append(m[c], i)
    }
    ret := []int{}
    for _, q := range queries {
        dis := m[q[1]]
        if len(dis) == 0 {
            ret = append(ret, -1)
            continue
        }
        idx := sort.SearchInts(dis, q[0]) // 二分查找找到目标数字插入的位置
        d := 2 << 31
        if idx < len(dis) {
            d = min(d, dis[idx] - q[0])
        }
        if idx - 1 >= 0 {
            d = min(d, q[0] - dis[idx - 1])
        }
        ret = append(ret, d)
    }
    return ret
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```


 **复杂性分析**

 * 时间复杂度：$\mathcal{O}(Q \log N + N)$，其中 $Q$ 是 `queries` 的长度，$N$ 是 `colors` 的长度。
   遍历输入数组 `colors` 并存储每个 `颜色-索引` 对需要 $\mathcal{O}(N)$ 时间。当迭代 `queries` 生成结果时，我们对每个查询都使用一次二分查找，每次二分查找需要 $\mathcal{O}(\log N)$，得出 $\mathcal{O}(Q \log N)$。把它们都加在一起，并忽略大 O 记法的常数项，我们得到 $\mathcal{O}(Q \log N + N)$。 
* 空间复杂度：$\mathcal{O}(N)$。 这是因为我们把每个 `颜色-索引` 对的索引存储在一个哈希映射中。
  <br/>

---

#### 方法二：预计算

 **算法简述**
 另一种方法是预计算并存储每个索引 `i` 和每个颜色 `c` 之间的最短距离，这样，对于每个查询，我们可以在常数时间内返回答案。
 为了找到 `i` 和 `c` 之间的最短距离，我们将其分为两步：首先找到 `i` 左边的最近的 `c`；其次，找到 `i` 右边的最近的 `c`。 这两者之间的最小值就是最短距离。
 一个重要的事实是，如果 `color[i]` 和 `color[j]` 都是 `c`，而 `i<j` 并且 `i` 和 `j` 之间没有 `c`，那么对于 `i` 和 `j` 之间的每个索引 `k`： 

 - `k` 到其 *左边* 的 `c` 的最短距离是 `k-i`。 
 - `k` 到其 *右边* 的 `c` 的最短距离是 `j-k`。

 ![image.png](https://pic.leetcode.cn/1692088518-OSRvzH-image.png){:width=400}

 *图1.查找左右最近的颜色。*
 因此，我们可以在两个阶段中找到最近的目标颜色： 

- **从左到右** 迭代并向 **前** 查找，找到 **左边** 最近的目标颜色。 
- **从右到左** 迭代并向 **后** 查找，找到 **右边** 最近的目标颜色。

 下面是它的可视化。左侧（前进）和右侧（回退）是相似的，为便于参考，我把它们串联在一起。

 <![image.png](https://pic.leetcode.cn/1692089732-whCOBX-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089734-lbAdQO-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089737-zomwPL-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089741-bizkjw-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089744-kNlgad-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089747-lDWnIq-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089749-Lhrcsd-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089752-OauyIE-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089754-BkMMcK-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089757-vkoAjS-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089759-udgxnm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089763-sDaYVL-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089766-lORGIf-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089769-QhOToU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089771-YJvFEt-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089774-UoLVhA-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089776-zOdWgT-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692089779-iCGZqJ-image.png){:width=400}>

 **算法**

```Java [solution]
class Solution {
    public List<Integer> shortestDistanceColor(int[] colors, int[][] queries) {
        // 初始化
        int n = colors.length;
        int[] rightmost = {0, 0, 0};
        int[] leftmost = {n - 1, n - 1, n - 1};

        int[][] distance = new int[3][n];

        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < n; j++) {
                distance[i][j] = -1;
            }
        }

        // 预计算
        for (int i = 0; i < n; i++) {
            int color = colors[i] - 1;
            for (int j = rightmost[color]; j < i + 1; j++) {
                distance[color][j] = i - j;
            }
            rightmost[color] = i + 1;
        }

        // 回溯
        for (int i = n - 1; i > -1; i--) {
            int color = colors[i] - 1;
            for (int j = leftmost[color]; j > i - 1; j--) {
                if (distance[color][j] == -1 || distance[color][j] > j - i) {
                    distance[color][j] = j - i;
                }
            }
            leftmost[color] = i - 1;
        }

        List<Integer> queryResults = new ArrayList<>();
        for (int i = 0; i < queries.length; i++) {
            queryResults.add(distance[queries[i][1] - 1][queries[i][0]]);
        }
        return queryResults;

    }
}
```

```Python3 [solution]
class Solution:
    def shortestDistanceColor(self, colors: List[int], queries: List[List[int]]) -> List[int]:
        # 初始化
        n = len(colors)
        rightmost = [0, 0, 0]
        leftmost = [n - 1, n - 1, n - 1]

        distance = [[-1] * n for _ in range(3)]

        # 预计算
        for i in range(n):
            color = colors[i] - 1
            for j in range(rightmost[color], i + 1):
                distance[color][j] = i - j
            rightmost[color] = i + 1

        # 回溯
        for i in range(n - 1, -1, -1):
            color = colors[i] - 1
            for j in range(leftmost[color], i - 1, -1):
                # if the we did not find a target color on its right
                # or we find out that a target color on its left is
                # closer to the one on its right
                if distance[color][j] == -1 or distance[color][j] > j - i:
                    distance[color][j] = j - i
            leftmost[color] = i - 1

        return [distance[color - 1][index] for index,color in queries]
```

```Golang
func shortestDistanceColor(colors []int, queries [][]int) []int {
    n := len(colors)
    left, right := make([][3]int, n), make([][3]int, n)
    ret := []int{}
    for i := 0; i < n; i++ {
        left[i] = [3]int{-1, -1, -1}
        right[i] = [3]int{-1, -1, -1}
    }

    // 预处理左边
    for i := 0; i < n; i++ {
        for j := 0; j < 3; j++ {
            if i - 1 >= 0 && left[i-1][j] != -1 {
                left[i][j] = left[i-1][j] + 1
            }
        }
        left[i][colors[i]-1] = 0
    }

    // 预处理右边
    for i := n - 1; i >= 0; i-- {
        for j := 0; j < 3; j++ {
            if i + 1 < n && right[i+1][j] != -1 {
                right[i][j] = right[i+1][j] + 1
            }
        }
        right[i][colors[i]-1] = 0
    }

    for _, q := range queries {
        idx, c := q[0], q[1] - 1
        d := 1 << 31
        if left[idx][c] != -1 {
            d = min(d, left[idx][c])
        }
        if right[idx][c] != -1 {
            d = min(d, right[idx][c])
        }
        if d == 1 << 31 {
            ret = append(ret, -1)
        } else {
            ret = append(ret, d)
        }
    }
    return ret
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```


 **复杂性分析**

 * 时间复杂度：$\mathcal{O}(N + Q)$，其中 `N` 是 `colors` 的长度，`Q` 是 `queries` 的长度。
   这是因为我们使用迭代来填充 `distance`，这是一个 3 行 $N$ 列的矩阵，需要 $\mathcal{O}(N)$ 时间。然后，我们在 $\mathcal{O}(1)$ 时间内为 `queries` 中的每个查询生成答案。 
* 空间复杂度：$\mathcal{O}(N)$。
  这是因为我们初始化了两个大小为 3 的数组和一个 3 行 $N$ 列的二维数组。 <br/>

---