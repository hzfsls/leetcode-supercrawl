#### 方法一：模拟

**思路**

按照题目要求，对任意一行，将它与每一列都进行比较，如果相等，则对结果加一，最后返回总数。

**代码**

```Python [sol1-Python3]
class Solution:
    def equalPairs(self, grid: List[List[int]]) -> int:
        res, n = 0, len(grid)
        for row in range(n):
            for col in range(n):
                if self.equal(row, col, n, grid):
                    res += 1
        return res
    
    def equal(self, row: int, col: int, n: int, grid: List[List[int]]) -> bool:
        for i in range(n):
            if grid[row][i] != grid[i][col]:
                return False
        return True
```

```Java [sol1-Java]
class Solution {
    public int equalPairs(int[][] grid) {
        int res = 0, n = grid.length;
        for (int row = 0; row < n; row++) {
            for (int col = 0; col < n; col++) {
                if (equal(row, col, n, grid)) {
                    res++;
                }
            }
        }
        return res;
    }

    public boolean equal(int row, int col, int n, int[][] grid) {
        for (int i = 0; i < n; i++) {
            if (grid[row][i] != grid[i][col]) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int EqualPairs(int[][] grid) {
        int res = 0, n = grid.Length;
        for (int row = 0; row < n; row++) {
            for (int col = 0; col < n; col++) {
                if (Equal(row, col, n, grid)) {
                    res++;
                }
            }
        }
        return res;
    }

    public bool Equal(int row, int col, int n, int[][] grid) {
        for (int i = 0; i < n; i++) {
            if (grid[row][i] != grid[i][col]) {
                return false;
            }
        }
        return true;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int equalPairs(vector<vector<int>>& grid) {
        int res = 0, n = grid.size();
        for (int row = 0; row < n; row++) {
            for (int col = 0; col < n; col++) {
                if (equal(row, col, grid)) {
                    res++;
                }
            }
        }
        return res;
    }

    bool equal(int row, int col, vector<vector<int>>& grid) {
        int n = grid.size();
        for (int i = 0; i < n; i++) {
            if (grid[row][i] != grid[i][col]) {
                return false;
            }
        }
        return true;
    }
};
```

```C [sol1-C]
bool equal(int row, int col, const int** grid, int gridSize) {
    for (int i = 0; i < gridSize; i++) {
        if (grid[row][i] != grid[i][col]) {
            return false;
        }
    }
    return true;
}

int equalPairs(int** grid, int gridSize, int* gridColSize) {
    int res = 0;
    for (int row = 0; row < gridSize; row++) {
        for (int col = 0; col < gridSize; col++) {
            if (equal(row, col, grid, gridSize)) {
                res++;
            }
        }
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，需要进行双层循环，每次循环最多需要遍历 $n$ 个数字。

- 空间复杂度：$O(1)$，仅使用常数空间。

#### 方法二：哈希表

**思路**

首先将矩阵的行放入哈希表中统计次数，哈希表的键可以是将行拼接后的字符串，也可以用各语言内置的数据结构，然后分别统计每一列相等的行有多少，求和即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def equalPairs(self, grid: List[List[int]]) -> int:
        res, n = 0, len(grid)
        cnt = Counter(tuple(row) for row in grid)
        res = 0
        for j in range(n):
            res += cnt[tuple([grid[i][j] for i in range(n)])]
        return res
```

```C++ [sol2-C++]
class Solution {
public:
    int equalPairs(vector<vector<int>>& grid) {
        int n = grid.size();
        map<vector<int>, int> cnt;
        for (auto row : grid) {
            cnt[row]++;
        }

        int res = 0;
        for (int j = 0; j < n; j++) {
            vector<int> arr;
            for (int i = 0; i < n; i++) {
                arr.emplace_back(grid[i][j]);
            }
            if (cnt.find(arr) != cnt.end()) {
                res += cnt[arr];
            }
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int equalPairs(int[][] grid) {
        int n = grid.length;
        Map<List<Integer>, Integer> cnt = new HashMap<List<Integer>, Integer>();
        for (int[] row : grid) {
            List<Integer> arr = new ArrayList<Integer>();
            for (int num : row) {
                arr.add(num);
            }
            cnt.put(arr, cnt.getOrDefault(arr, 0) + 1);
        }

        int res = 0;
        for (int j = 0; j < n; j++) {
            List<Integer> arr = new ArrayList<Integer>();
            for (int i = 0; i < n; i++) {
                arr.add(grid[i][j]);
            }
            if (cnt.containsKey(arr)) {
                res += cnt.get(arr);
            }
        }
        return res;
    }
}
```

```Go [sol2-Go]
func equalPairs(grid [][]int) int {
    n := len(grid)
    cnt := make(map[string]int)
    for _, row := range grid {
        cnt[fmt.Sprint(row)]++
    }
    res := 0
    for j := 0; j < n; j++ {
        var arr []int
        for i := 0; i < n; i++ {
            arr = append(arr, grid[i][j])
        }
        if val, ok := cnt[fmt.Sprint(arr)]; ok {
            res += val
        }
    }

    return res
}
```

```JavaScript [sol2-JavaScript]
var equalPairs = function(grid) {
    const n = grid.length;
    const cnt = {};

    for (const row of grid) {
        const rowStr = row.toString();
        cnt[rowStr] = (cnt[rowStr] || 0) + 1;
    }

    let res = 0;
    for (let j = 0; j < n; j++) {
        const arr = [];
        for (let i = 0; i < n; i++) {
            arr.push(grid[i][j]);
        }
        const arrStr = arr.toString();
        if (cnt[arrStr]) {
            res += cnt[arrStr];
        }
    }

    return res;
};
```

```C [sol2-C]
typedef struct {
    long long key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, long long key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, long long key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, long long key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, int key, int defaultVal) {
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
        free(curr);
    }
}

const long long base = 1000003;
const long long mod = 1e9 + 7;

int equalPairs(int** grid, int gridSize, int* gridColSize) {
    int n = gridSize;
    HashItem *cnt = NULL;
    for (int i = 0; i < n; i++) {
        long long key = 0;
        for (int j = 0; j < n; j++) {
            key = (key * base + grid[i][j]) % mod;
        }
        hashSetItem(&cnt, key, hashGetItem(&cnt, key, 0) + 1);
    }

    int res = 0;
    for (int j = 0; j < n; j++) {
        long long key = 0;
        for (int i = 0; i < n; i++) {
            key = (key * base + grid[i][j]) % mod;
        }
        res += hashGetItem(&cnt, key, 0);
    }
    hashFree(&cnt);
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，将行放入哈希表中消耗 $O(n^2)$，读所有列的哈希表中的次数也消耗 $O(n^2)$。

- 空间复杂度：$O(n^2)$，哈希表的空间复杂度为 $O(n^2)$。