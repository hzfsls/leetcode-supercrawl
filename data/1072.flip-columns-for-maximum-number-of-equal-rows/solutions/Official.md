## [1072.按列翻转得到最大值等行数 中文官方题解](https://leetcode.cn/problems/flip-columns-for-maximum-number-of-equal-rows/solutions/100000/an-lie-fan-zhuan-de-dao-zui-da-zhi-deng-teeig)
#### 方法一：哈希

**思路与算法**

题目给定 $m\times n$ 的矩阵，要求从中选取任意数量的列并翻转其上的每个单元格。单元格仅包含 $0$ 或者 $1$。问最多可以得到多少个由相同元素组成的行。如果某一行全部是 $1$ 或者全部是 $0$，则表示该行由相同元素组成。

如果翻转固定的某些列，可以使得两个不同的行都变成由相同元素组成的行，那么我们称这两行为本质相同的行。例如 $001$ 和 $110$ 就是本质相同的行。

本质相同的行有什么特点呢？可以发现，本质相同的行只存在两种情况，一种是由 $0$ 开头的行，另一种是由 $1$ 开头的行。在开头的元素确定以后，由于翻转的列已经固定，所以可以推断出后续所有元素是 $0$ 还是 $1$。

为了方便统计本质相同的行的数量，我们让由 $1$ 开头的行全部翻转，翻转后行内元素相同的行即为本质相同的行。之后我们将每一行转成字符串形式存储到哈希表中，遍历哈希表得到最多的本质相同的行的数量即为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxEqualRowsAfterFlips(vector<vector<int>>& matrix) {
        int m = matrix.size(), n = matrix[0].size();
        unordered_map<string, int> mp;
        for (int i = 0; i < m; i++) {
            string s = string(n, '0');
            for (int j = 0; j < n; j++) {
                // 如果 matrix[i][0] 为 1，则对该行元素进行翻转
                s[j] = '0' + (matrix[i][j] ^ matrix[i][0]);
            }
            mp[s]++;
        }
        int res = 0;
        for (auto &[k, v] : mp) {
            res = max(res, v);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxEqualRowsAfterFlips(int[][] matrix) {
        int m = matrix.length, n = matrix[0].length;
        Map<String, Integer> map = new HashMap<String, Integer>();
        for (int i = 0; i < m; i++) {
            char[] arr = new char[n];
            Arrays.fill(arr, '0');
            for (int j = 0; j < n; j++) {
                // 如果 matrix[i][0] 为 1，则对该行元素进行翻转
                arr[j] = (char) ('0' + (matrix[i][j] ^ matrix[i][0]));
            }
            String s = new String(arr);
            map.put(s, map.getOrDefault(s, 0) + 1);
        }
        int res = 0;
        for (Map.Entry<String, Integer> entry : map.entrySet()) {
            res = Math.max(res, entry.getValue());
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxEqualRowsAfterFlips(self, matrix: List[List[int]]) -> int:
        m, n = len(matrix), len(matrix[0])
        count = Counter()
        for i in range(m):
            value = 0
            for j in range(n):
                # 如果 matrix[i][0] 为 1，则对该行元素进行翻转
                value = value * 10 + (matrix[i][j] ^ matrix[i][0])
            count[value] += 1
        return max(count.values())
```

```Go [sol1-Go]
func maxEqualRowsAfterFlips(matrix [][]int) int {
    m, n := len(matrix), len(matrix[0])
    mp := make(map[string]int)
    for i := 0; i < m; i++ {
        arr := make([]byte, n)
        for j := 0; j < n; j++ {
            // 如果 matrix[i][0] 为 1，则对该行元素进行翻转
            if matrix[i][j] ^ matrix[i][0] == 0 {
                arr[j] = '0'
            } else {
                arr[j] = '1'
            }
        }
        s := string(arr)
        mp[s]++
    }
    res := 0
    for _, value := range mp {
        if value > res {
            res = value
        }
    }
    return res
}
```

```JavaScript [sol1-JavaScript]
var maxEqualRowsAfterFlips = function(matrix) {
    let m = matrix.length, n = matrix[0].length;
    let map = {};
    for (let i = 0; i < m; i++) {
        let arr = new Array(n).fill('0');
        for (let j = 0; j < n; j++) {
            // 如果 matrix[i][0] 为 1，则对该行元素进行翻转
            arr[j] = '0' + (matrix[i][j] ^ matrix[i][0]);
        }
        let s = arr.join('');
        map[s] = (map[s] || 0) + 1;
    }
    let res = 0;
    for (let key in map) {
        res = Math.max(res, map[key]);
    }
    return res;
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxEqualRowsAfterFlips(int[][] matrix) {
        int m = matrix.Length, n = matrix[0].Length;
        IDictionary<string, int> dictionary = new Dictionary<string, int>();
        for (int i = 0; i < m; i++) {
            char[] arr = new char[n];
            Array.Fill(arr, '0');
            for (int j = 0; j < n; j++) {
                // 如果 matrix[i][0] 为 1，则对该行元素进行翻转
                arr[j] = (char) ('0' + (matrix[i][j] ^ matrix[i][0]));
            }
            string s = new string(arr);
            dictionary.TryAdd(s, 0);
            dictionary[s]++;
        }
        int res = 0;
        foreach (KeyValuePair<string, int> pair in dictionary) {
            res = Math.Max(res, pair.Value);
        }
        return res;
    }
}
```

```C [sol1-C]
typedef struct {
    char *key;
    int val;
    UT_hash_handle hh;
} HashItem;

HashItem *hashFindItem(HashItem **obj, char *key) {
    HashItem *pEntry = NULL;
    HASH_FIND_STR(*obj, key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, char *key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, char *key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, char *key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);
        free(curr->key);
        free(curr);
    }
}

#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxEqualRowsAfterFlips(int** matrix, int matrixSize, int* matrixColSize) {
    int m = matrixSize, n = matrixColSize[0];
    HashItem *mp = NULL;
    for (int i = 0; i < m; i++) {
        char *s = (char *)calloc(n + 1, sizeof(char));
        memset(s, '0', sizeof(char) * n);
        for (int j = 0; j < n; j++) {
            // 如果 matrix[i][0] 为 1，则对该行元素进行翻转
            s[j] = '0' + (matrix[i][j] ^ matrix[i][0]);
        }
        hashSetItem(&mp, s, hashGetItem(&mp, s, 0) + 1);
    }
    int res = 0;
    for (HashItem *pEntry = mp; pEntry != NULL; pEntry = pEntry->hh.next) {
        res = MAX(res, pEntry->val);
    }
    hashFree(&mp);
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是矩阵 $\textit{matrix}$ 的行数和列数。过程中，我们遍历了矩阵中的每个元素各一次，这部分的时间复杂度为 $O(mn)$。哈希表中共有 $m$ 个元素，每个元素长度为 $n$，所有元素插入和查询的渐进复杂度仍为 $O(mn)$。因此总体时间复杂度为 $O(mn)$。

- 空间复杂度：$O(m)$。哈希表存放了 $m$ 个字符串的哈希值，空间复杂度为 $O(m)$。