## [554.砖墙 中文官方题解](https://leetcode.cn/problems/brick-wall/solutions/100000/zhuan-qiang-by-leetcode-solution-2kls)

#### 方法一：哈希表

**思路及算法**

由于砖墙是一面矩形，所以对于任意一条垂线，其穿过的砖块数量加上从边缘经过的砖块数量之和是一个定值，即砖墙的高度。

因此，问题可以转换成求「垂线穿过的砖块边缘数量的最大值」，用砖墙的高度减去该最大值即为答案。

虽然垂线在每行至多只能通过一个砖块边缘，但是每行的砖块边缘也各不相同，因此我们需要用哈希表统计所有符合要求的砖块边缘的数量。

注意到题目要求垂线不能通过砖墙的两个垂直边缘，所以砖墙两侧的边缘不应当被统计。因此，我们只需要统计每行砖块中除了最右侧的砖块以外的其他砖块的右边缘即可。

具体地，我们遍历砖墙的每一行，对于当前行，我们从左到右地扫描每一块砖，使用一个累加器记录当前砖的右侧边缘到砖墙的左边缘的距离，将除了最右侧的砖块以外的其他砖块的右边缘到砖墙的左边缘的距离加入到哈希表中。最后我们遍历该哈希表，找到出现次数最多的砖块边缘，这就是垂线经过的砖块边缘，而该垂线经过的砖块数量即为砖墙的高度减去该垂线经过的砖块边缘的数量。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int leastBricks(vector<vector<int>>& wall) {
        unordered_map<int, int> cnt;
        for (auto& widths : wall) {
            int n = widths.size();
            int sum = 0;
            for (int i = 0; i < n - 1; i++) {
                sum += widths[i];
                cnt[sum]++;
            }
        }
        int maxCnt = 0;
        for (auto& [_, c] : cnt) {
            maxCnt = max(maxCnt, c);
        }
        return wall.size() - maxCnt;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int leastBricks(List<List<Integer>> wall) {
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (List<Integer> widths : wall) {
            int n = widths.size();
            int sum = 0;
            for (int i = 0; i < n - 1; i++) {
                sum += widths.get(i);
                cnt.put(sum, cnt.getOrDefault(sum, 0) + 1);
            }
        }
        int maxCnt = 0;
        for (Map.Entry<Integer, Integer> entry : cnt.entrySet()) {
            maxCnt = Math.max(maxCnt, entry.getValue());
        }
        return wall.size() - maxCnt;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LeastBricks(IList<IList<int>> wall) {
        Dictionary<int, int> cnt = new Dictionary<int, int>();
        foreach (IList<int> widths in wall) {
            int n = widths.Count;
            int sum = 0;
            for (int i = 0; i < n - 1; i++) {
                sum += widths[i];
                if (!cnt.ContainsKey(sum)) {
                    cnt.Add(sum, 1);
                } else {
                    cnt[sum]++;
                }
            }
        }
        int maxCnt = 0;
        foreach (var entry in cnt) {
            maxCnt = Math.Max(maxCnt, entry.Value);
        }
        return wall.Count - maxCnt;
    }
}
```

```JavaScript [sol1-JavaScript]
var leastBricks = function(wall) {
    const cnt = new Map();
    for (const widths of wall) {
        const n = widths.length;
        let sum = 0;
        for (let i = 0; i < n - 1; i++) {
            sum += widths[i];
            cnt.set(sum, (cnt.get(sum) || 0) + 1);
        }
    }
    let maxCnt = 0;
    for (const [_, c] of cnt.entries()) {
        maxCnt = Math.max(maxCnt, c);
    }
    return wall.length - maxCnt;
};
```

```go [sol1-Golang]
func leastBricks(wall [][]int) int {
    cnt := map[int]int{}
    for _, widths := range wall {
        sum := 0
        for _, width := range widths[:len(widths)-1] {
            sum += width
            cnt[sum]++
        }
    }
    maxCnt := 0
    for _, c := range cnt {
        if c > maxCnt {
            maxCnt = c
        }
    }
    return len(wall) - maxCnt
}
```

```C [sol1-C]
struct HashTable {
    int key, val;
    UT_hash_handle hh;
};

int leastBricks(int** wall, int wallSize, int* wallColSize) {
    struct HashTable* cnt = NULL;
    for (int i = 0; i < wallSize; i++) {
        int n = wallColSize[i];
        int sum = 0;
        for (int j = 0; j < n - 1; j++) {
            sum += wall[i][j];
            struct HashTable* tmp;
            HASH_FIND_INT(cnt, &sum, tmp);
            if (tmp == NULL) {
                tmp = malloc(sizeof(struct HashTable));
                tmp->key = sum, tmp->val = 1;
                HASH_ADD_INT(cnt, key, tmp);
            } else {
                tmp->val++;
            }
        }
    }
    int maxCnt = 0;
    struct HashTable *iter, *tmp;
    HASH_ITER(hh, cnt, iter, tmp) {
        maxCnt = fmax(maxCnt, iter->val);
    }
    return wallSize - maxCnt;
}
```

**复杂度分析**

- 时间复杂度：$O(nm)$，其中 $n$ 是砖墙的高度，$m$ 是每行砖墙的砖的平均数量。我们需要遍历每行砖块中除了最右侧的砖块以外的每一块砖，将其右侧边缘到砖墙的左边缘的距离加入到哈希表中。

- 空间复杂度：$O(nm)$，其中 $n$ 是砖墙的高度，$m$ 是每行砖墙的砖的平均数量。我们需要将每行砖块中除了最右侧的砖块以外的每一块砖的右侧边缘到砖墙的左边缘的距离加入到哈希表中。