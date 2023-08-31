## [699.掉落的方块 中文官方题解](https://leetcode.cn/problems/falling-squares/solutions/100000/diao-luo-de-fang-kuai-by-leetcode-soluti-2dmw)

#### 方法一：暴力枚举

我们用数组 $\textit{heights}$ 记录各个方块掉落后的高度。对于第 $i$ 个掉落的方块，如果它的底部区间与第 $j$ 个掉落的方块有重叠，那么它掉落后的高度至少为 $\textit{heights}[j] + \textit{size}_i$，其中 $j \lt i$ 且 $\textit{size}_i$ 为第 $i$ 个掉落的方块的边长。因此对于第 $i$ 个掉落的方块，$\textit{heights}[i]$ 的初始值为 $\textit{size}_i$，我们暴力枚举所有之前已经掉落的方块，如果两者的底部区间有重叠，那么更新 $\textit{heights}[i] = \max(\textit{heights}[i], \textit{heights}[j] + \textit{size}_i)$。

因为题目要求返回一个所有已经落稳的方块的最大堆叠高度列表，我们从 $i=1$ 开始，更新 $\textit{heights}[i] = \max(\textit{heights}[i], \textit{heights}[i - 1])$，然后返回 $\textit{heights}$ 即可。

```Python [sol1-Python3]
class Solution:
    def fallingSquares(self, positions: List[List[int]]) -> List[int]:
        n = len(positions)
        heights = [0] * n
        for i, (left1, side1) in enumerate(positions):
            right1 = left1 + side1 - 1
            heights[i] = side1
            for j in range(i):
                left2, right2 = positions[j][0], positions[j][0] + positions[j][1] - 1
                if right1 >= left2 and right2 >= left1:
                    heights[i] = max(heights[i], heights[j] + side1)
        for i in range(1, n):
            heights[i] = max(heights[i], heights[i - 1])
        return heights
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> fallingSquares(vector<vector<int>>& positions) {
        int n = positions.size();
        vector<int> heights(n);
        for (int i = 0; i < n; i++) {
            int left1 = positions[i][0], right1 = positions[i][0] + positions[i][1] - 1;
            heights[i] = positions[i][1];
            for (int j = 0; j < i; j++) {
                int left2 = positions[j][0], right2 = positions[j][0] + positions[j][1] - 1;
                if (right1 >= left2 && right2 >= left1) {
                    heights[i] = max(heights[i], heights[j] + positions[i][1]);
                }
            }
        }
        for (int i = 1; i < n; i++) {
            heights[i] = max(heights[i], heights[i - 1]);
        }
        return heights;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> fallingSquares(int[][] positions) {
        int n = positions.length;
        List<Integer> heights = new ArrayList<Integer>();
        for (int i = 0; i < n; i++) {
            int left1 = positions[i][0], right1 = positions[i][0] + positions[i][1] - 1;
            int height = positions[i][1];
            for (int j = 0; j < i; j++) {
                int left2 = positions[j][0], right2 = positions[j][0] + positions[j][1] - 1;
                if (right1 >= left2 && right2 >= left1) {
                    height = Math.max(height, heights.get(j) + positions[i][1]);
                }
            }
            heights.add(height);
        }
        for (int i = 1; i < n; i++) {
            heights.set(i, Math.max(heights.get(i), heights.get(i - 1)));
        }
        return heights;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> FallingSquares(int[][] positions) {
        int n = positions.Length;
        IList<int> heights = new List<int>();
        for (int i = 0; i < n; i++) {
            int left1 = positions[i][0], right1 = positions[i][0] + positions[i][1] - 1;
            heights.Add(positions[i][1]);
            for (int j = 0; j < i; j++) {
                int left2 = positions[j][0], right2 = positions[j][0] + positions[j][1] - 1;
                if (right1 >= left2 && right2 >= left1) {
                    heights[i] = Math.Max(heights[i], heights[j] + positions[i][1]);
                }
            }
        }
        for (int i = 1; i < n; i++) {
            heights[i] = Math.Max(heights[i], heights[i - 1]);
        }
        return heights;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int* fallingSquares(int** positions, int positionsSize, int* positionsColSize, int* returnSize) {
    int *heights = (int *)malloc(sizeof(int) * positionsSize);
    for (int i = 0; i < positionsSize; i++) {
        int left1 = positions[i][0], right1 = positions[i][0] + positions[i][1] - 1;
        heights[i] = positions[i][1];
        for (int j = 0; j < i; j++) {
            int left2 = positions[j][0], right2 = positions[j][0] + positions[j][1] - 1;
            if (right1 >= left2 && right2 >= left1) {
                heights[i] = MAX(heights[i], heights[j] + positions[i][1]);
            }
        }
    }
    for (int i = 1; i < positionsSize; i++) {
        heights[i] = MAX(heights[i], heights[i - 1]);
    }
    *returnSize = positionsSize;
    return heights;
}
```

```go [sol1-Golang]
func fallingSquares(positions [][]int) []int {
    n := len(positions)
    heights := make([]int, n)
    for i, p := range positions {
        left1, right1 := p[0], p[0]+p[1]-1
        heights[i] = p[1]
        for j, q := range positions[:i] {
            left2, right2 := q[0], q[0]+q[1]-1
            if right1 >= left2 && right2 >= left1 {
                heights[i] = max(heights[i], heights[j]+p[1])
            }
        }
    }
    for i := 1; i < n; i++ {
        heights[i] = max(heights[i], heights[i-1])
    }
    return heights
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var fallingSquares = function(positions) {
    const n = positions.length;
    const heights = [];
    for (let i = 0; i < n; i++) {
        let left1 = positions[i][0], right1 = positions[i][0] + positions[i][1] - 1;
        let height = positions[i][1];
        for (let j = 0; j < i; j++) {
            let left2 = positions[j][0], right2 = positions[j][0] + positions[j][1] - 1;
            if (right1 >= left2 && right2 >= left1) {
                height = Math.max(height, heights[j] + positions[i][1]);
            }
        }
        heights.push(height);
    }
    for (let i = 1; i < n; i++) {
        heights.splice(i, 1, Math.max(heights[i], heights[i - 1]));
    }
    return heights;
};
```

**复杂度分析**

+ 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{positions}$ 的长度。

+ 空间复杂度：$O(1)$。返回值不计入空间复杂度。

#### 方法二：有序集合

已经落稳的方块的堆叠高度情况可以使用一个有序集合 $\textit{heightMap}$ 进行记录，$\textit{heightMap}[x_1]$ 表示从 $x_1$ 开始（包括 $x_1$）直到遇到下一个 $x_2$（不包括 $x_2$）的所有数轴上的点的堆叠高度为 $\textit{heightMap}[x_1]$，其中 $x_2 > x_1$。通俗上来说就是用 $\textit{heightMap}$ 记录每一个相对于前一个点而言，堆叠高度发生变化的点。初始时，令 $\textit{heightMap}[0] = 0$，表示从 $0$ 开始的所有点的堆叠高度都为 $0$。

对于第 $i$ 个掉落的方块，记它底部的左端点为 $\textit{left}$，右端点为 $\textit{right}$。我们在有序集合中查找该区间 $[\textit{left}, \textit{right}]$ 内所有点的堆叠高度，然后更新该方块对应的堆叠高度 $\textit{height}$。在第 $i$ 个方块掉落后，区间 $[\textit{left}, \textit{right}]$ 内的所有点的堆叠高度都是 $\textit{height}$，因此我们将有序集合里对应区间 $[\textit{left}, \textit{right}]$ 内的点全部删除。该掉落的方块带来的堆叠高度变化主要在两个点，即 $\textit{left}$ 和 $\textit{right} + 1$，更新对应的变化即可。

前 $i$ 个掉落的方块的最大堆叠高度等于前 $i - 1$ 个掉落的方块的最大堆叠高度与第 $i$ 个方块的堆叠高度的最大值。

```C++ [sol2-C++]
class Solution {
public:
    vector<int> fallingSquares(vector<vector<int>>& positions) {
        int n = positions.size();
        vector<int> ret(n);
        map<int, int> heightMap;
        heightMap[0] = 0; // 初始时从 0 开始的所有点的堆叠高度都是 0
        for (int i = 0; i < n; i++) {
            int size = positions[i][1];
            int left = positions[i][0], right = positions[i][0] + positions[i][1] - 1;
            auto lp = heightMap.upper_bound(left), rp = heightMap.upper_bound(right);
            int rHeight = prev(rp)->second; // 记录 right + 1 对应的堆叠高度（如果 right + 1 不在 heightMap 中）

            // 更新第 i 个掉落的方块的堆叠高度
            int height = 0;
            for (auto p = prev(lp); p != rp; p++) {
                height = max(height, p->second + size);
            }

            // 清除 heightMap 中位于 (left, right] 内的点
            heightMap.erase(lp, rp);

            heightMap[left] = height; // 更新 left 的变化
            if (rp == heightMap.end() || rp->first != right + 1) { // 如果 right + 1 不在 heightMap 中，更新 right + 1 的变化
                heightMap[right + 1] = rHeight;
            }
            ret[i] = i > 0 ? max(ret[i - 1], height) : height;
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> fallingSquares(int[][] positions) {
        int n = positions.length;
        List<Integer> ret = new ArrayList<Integer>();
        TreeMap<Integer, Integer> heightMap = new TreeMap<Integer, Integer>();
        heightMap.put(0, 0); // 初始时从 0 开始的所有点的堆叠高度都是 0
        for (int i = 0; i < n; i++) {
            int size = positions[i][1];
            int left = positions[i][0], right = positions[i][0] + positions[i][1] - 1;
            Integer lp = heightMap.higherKey(left), rp = heightMap.higherKey(right);
            Integer prevRightKey = rp != null ? heightMap.lowerKey(rp) : heightMap.lastKey();
            int rHeight = prevRightKey != null ? heightMap.get(prevRightKey) : 0; // 记录 right + 1 对应的堆叠高度（如果 right + 1 不在 heightMap 中）

            // 更新第 i 个掉落的方块的堆叠高度
            int height = 0;
            Integer prevLeftKey = lp != null ? heightMap.lowerKey(lp) : heightMap.lastKey();
            Map<Integer, Integer> tail = prevLeftKey != null ? heightMap.tailMap(prevLeftKey) : heightMap;
            for (Map.Entry<Integer, Integer> entry : tail.entrySet()) {
                if (entry.getKey() == rp) {
                    break;
                }
                height = Math.max(height, entry.getValue() + size);
            }

            // 清除 heightMap 中位于 (left, right] 内的点
            Set<Integer> keySet = new TreeSet<Integer>(tail.keySet());
            for (Integer tmp : keySet) {
                if (lp == null || tmp < lp) {
                    continue;
                }
                if (rp != null && tmp >= rp) {
                    break;
                }
                heightMap.remove(tmp);
            }

            heightMap.put(left, height); // 更新 left 的变化
            if (rp == null || rp != right + 1) { // 如果 right + 1 不在 heightMap 中，更新 right + 1 的变化
                heightMap.put(right + 1, rHeight);
            }
            ret.add(i > 0 ? Math.max(ret.get(i - 1), height) : height);
        }
        return ret;
    }
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{positions}$ 的长度。有序集合 $\textit{heightMap}$ 最多插入 $2n + 1$ 个元素，因此整个循环最多执行删除操作 $2n + 1$ 次，而每次循环里的查询操作只比删除操作多一次，因此总的查询操作最多为 $3n + 1$ 次；插入操作、删除操作、迭代器递增操作以及二分查找操作都需要 $O(\log n)$，因此总共需要 $O(n \log n)$。

+ 空间复杂度：$O(n)$。有序集合最多保存 $2n + 1$ 个元素。