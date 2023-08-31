## [1039.多边形三角剖分的最低得分 中文官方题解](https://leetcode.cn/problems/minimum-score-triangulation-of-polygon/solutions/100000/duo-bian-xing-san-jiao-pou-fen-de-zui-di-weqg)
#### 方法一：动态规划

**思路**

设 $\textit{dp}[i][j](j\geq i+2)$ 的值为顶点 $i, i+1, \dots, j-1, j$ 构成的凸 $j-i+1$ 边形进行三角形剖分后可以得到的最低分。当 $i+2=j$ 时，凸多边形退化为三角形。其他情况下，需要进行剖分，假设剖分得到的三角形中，顶点 $i, j$ 和另一个顶点 $k(i<k<j)$ 构成了一个三角形，那么三角形 $ikj$ 就将这个凸多边形分成了三部分：
1. 顶点 $i, i+1, \dots, k-1, k$ 构成的凸 $k-i+1$ 边形。当 $k=i+1$ 时，这部分不存在。
2. 顶点 $i, k, j$ 构成的三角形。
3. 顶点 $k, k+1, \dots, j-1, j$ 构成的凸 $j-k+1$ 边形。当 $j=k+1$ 时，这部分不存在。

凸多边形的值就是这三部分的值之和。可以通过遍历 $k$ 的值，来求出多边形的值的最小值。而第一部分和第三部分的值，也可以通过相同的方法求得最小值。

代码实现上，可以通过记忆化搜索来完成。最后返回 $\textit{dp}[0][n-1]$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def minScoreTriangulation(self, values: List[int]) -> int:
        @lru_cache(None)
        def dp(i, j):
            if i + 2 > j:
                return 0
            if i + 2 == j:
                return values[i] * values[i + 1] * values[j]
            return min((values[i] * values[k] * values[j] + dp(i, k) + dp(k, j)) for k in range(i + 1, j))
        return dp(0, len(values) - 1)
```

```Java [sol1-Java]
class Solution {
    int n;
    int[] values;
    Map<Integer, Integer> memo = new HashMap<Integer, Integer>();

    public int minScoreTriangulation(int[] values) {
        this.n = values.length;
        this.values = values;
        return dp(0, n - 1);
    }

    public int dp(int i, int j) {
        if (i + 2 > j) {
            return 0;
        }
        if (i + 2 == j) {
            return values[i] * values[i + 1] * values[j];
        }
        int key = i * n + j;
        if (!memo.containsKey(key)) {
            int minScore = Integer.MAX_VALUE;
            for (int k = i + 1; k < j; k++) {
                minScore = Math.min(minScore, values[i] * values[k] * values[j] + dp(i, k) + dp(k, j));
            }
            memo.put(key, minScore);
        }
        return memo.get(key);
    }
}
```

```C# [sol1-C#]
public class Solution {
    int n;
    int[] values;
    IDictionary<int, int> memo = new Dictionary<int, int>();

    public int MinScoreTriangulation(int[] values) {
        this.n = values.Length;
        this.values = values;
        return DP(0, n - 1);
    }

    public int DP(int i, int j) {
        if (i + 2 > j) {
            return 0;
        }
        if (i + 2 == j) {
            return values[i] * values[i + 1] * values[j];
        }
        int key = i * n + j;
        if (!memo.ContainsKey(key)) {
            int minScore = int.MaxValue;
            for (int k = i + 1; k < j; k++) {
                minScore = Math.Min(minScore, values[i] * values[k] * values[j] + DP(i, k) + DP(k, j));
            }
            memo.Add(key, minScore);
        }
        return memo[key];
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minScoreTriangulation(vector<int>& values) {
        unordered_map<int, int> memo;
        int n = values.size();
        function<int(int, int)> dp = [&](int i, int j) -> int {
             if (i + 2 > j) {
                return 0;
            }
            if (i + 2 == j) {
                return values[i] * values[i + 1] * values[j];
            }
            int key = i * n + j;
            if (!memo.count(key)) {
                int minScore = INT_MAX;
                for (int k = i + 1; k < j; k++) {
                    minScore = min(minScore, values[i] * values[k] * values[j] + dp(i, k) + dp(k, j));
                }
                memo[key] = minScore;
            }
            return memo[key];
        };
        return dp(0, n - 1);
    }
};
```

```C [sol1-C]
typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

int hashGetItem(HashItem **obj, int key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

bool hashSetItem(HashItem **obj, int key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

inline int min(int a, int b) {
    return a < b ? a : b;
}

int dp(int i, int j, int* values, int valuesSize, HashItem **memo) {
    if (i + 2 > j) {
        return 0;
    }
    if (i + 2 == j) {
        return values[i] * values[i + 1] * values[j];
    }
    int key = i * valuesSize + j;
    if (!hashFindItem(memo, key)) {
        int minScore = INT_MAX;
        for (int k = i + 1; k < j; k++) {
            minScore = min(minScore, values[i] * values[k] * values[j] + \
                                    dp(i, k, values, valuesSize, memo) + \
                                    dp(k, j, values, valuesSize, memo));
        }
        hashAddItem(memo, key, minScore);
    }
    return hashGetItem(memo, key, 0);
}

int minScoreTriangulation(int* values, int valuesSize) {
    HashItem *memo = NULL;
    int ret = dp(0, valuesSize - 1, values, valuesSize, &memo);
    hashFree(&memo);
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var minScoreTriangulation = function(values) {
    const n = values.length;
    const memo = new Map();
    const dp = (i, j) => {
        if (i + 2 > j) {
            return 0;
        }
        if (i + 2 === j) {
            return values[i] * values[i + 1] * values[j];
        }
        const key = i * n + j;
        if (!memo.has(key)) {
            let minScore = Number.MAX_VALUE;
            for (let k = i + 1; k < j; k++) {
                minScore = Math.min(minScore, values[i] * values[k] * values[j] + dp(i, k) + dp(k, j));
            }
            memo.set(key, minScore);
        }
        return memo.get(key);
    }
    return dp(0, n - 1);
};
```

```Go [sol1-Go]
func minScoreTriangulation(values []int) int {
    memo := make(map[int]int)
    n := len(values)
    var dp func(int, int) int
    dp = func(i int, j int) int {
        if i + 2 > j {
            return 0
        }
        if i + 2 == j {
            return values[i] * values[i + 1] * values[j]
        }
        key := i * n + j
        if _, ok := memo[key]; !ok {
            minScore := math.MaxInt32
            for k := i + 1; k < j; k++ {
                minScore = min(minScore, values[i] * values[k] * values[j] + dp(i, k) + dp(k, j))
            }
            memo[key] = minScore
        }
        return memo[key]
    }
    return dp(0, n - 1)
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

**复杂度分析**

- 时间复杂度：$O(n^3)$。动态规划一共有 $O(n^2)$ 个状态，计算每个状态消耗 $O(n)$。

- 空间复杂度：$O(n^2)$。动态规划一共有 $O(n^2)$ 个状态。