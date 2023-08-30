#### 方法一：哈希表

因为数组 $\textit{arr}$ 每个整数互不相同，且 $\textit{pieces}$ 的整数也互不相同，所以我们可以通过 $\textit{arr}$ 固定 $\textit{pieces}$ 的放置。使用哈希表 $\textit{index}$ 记录 $\textit{pieces}$ 各个数组的**首元素**与数组下标的对应关系。

我们不断地将 $\textit{pieces}$ 中的数组与数组 $\textit{arr}$ 相对应，对于当前遍历的元素 $\textit{arr}[i]$，如果它不存在于哈希表中，说明我们无法将 $\textit{pieces}$ 与数组 $\textit{arr}$ 相对应，直接返回 $\text{false}$；否则我们找到对应的数组 $\textit{pieces}[j]$，然后将它与 $\textit{arr}[i]$ 及之后的整数进行比较（在比较过程中，如果判断相等不成立，直接返回 $\text{false}$），判断都相等后，将 $i$ 相应地向后移。全部 $\textit{pieces}$ 都匹配成功后，返回 $\text{true}$。

```Python [sol1-Python3]
class Solution:
    def canFormArray(self, arr: List[int], pieces: List[List[int]]) -> bool:
        index = {p[0]: i for i, p in enumerate(pieces)}
        i = 0
        while i < len(arr):
            if arr[i] not in index:
                return False
            p = pieces[index[arr[i]]]
            if arr[i: i + len(p)] != p:
                return False
            i += len(p)
        return True
```

```C++ [sol1-C++]
class Solution {
public:
    bool canFormArray(vector<int> &arr, vector<vector<int>> &pieces) {
        unordered_map<int, int> index;
        for (int i = 0; i < pieces.size(); i++) {
            index[pieces[i][0]] = i;
        }
        for (int i = 0; i < arr.size();) {
            auto it = index.find(arr[i]);
            if (it == index.end()) {
                return false;
            }
            for (int x : pieces[it->second]) {
                if (arr[i++] != x) {
                    return false;
                }
            }
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean canFormArray(int[] arr, int[][] pieces) {
        int n = arr.length, m = pieces.length;
        Map<Integer, Integer> index = new HashMap<Integer, Integer>();
        for (int i = 0; i < m; i++) {
            index.put(pieces[i][0], i);
        }
        for (int i = 0; i < n;) {
            if (!index.containsKey(arr[i])) {
                return false;
            }
            int j = index.get(arr[i]), len = pieces[j].length;
            for (int k = 0; k < len; k++) {
                if (arr[i + k] != pieces[j][k]) {
                    return false;
                }
            }
            i = i + len;
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CanFormArray(int[] arr, int[][] pieces) {
        int n = arr.Length, m = pieces.Length;
        Dictionary<int, int> index = new Dictionary<int, int>();
        for (int i = 0; i < m; i++) {
            index.Add(pieces[i][0], i);
        }
        for (int i = 0; i < n;) {
            if (!index.ContainsKey(arr[i])) {
                return false;
            }
            int j = index[arr[i]], len = pieces[j].Length;
            for (int k = 0; k < len; k++) {
                if (arr[i + k] != pieces[j][k]) {
                    return false;
                }
            }
            i = i + len;
        }
        return true;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

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

bool hashSetItem(HashItem **obj, int key, int val) {
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

bool canFormArray(int* arr, int arrSize, int** pieces, int piecesSize, int* piecesColSize){
    int n = arrSize, m = piecesSize;
    HashItem *index = NULL;
    for (int i = 0; i < m; i++) {
        hashAddItem(&index, pieces[i][0], i);
    }
    for (int i = 0; i < n;) {
        if (!hashFindItem(&index, arr[i])) {
            hashFree(&index);
            return false;
        }
        int j = hashGetItem(&index, arr[i], 0);
        int len = piecesColSize[j];
        for (int k = 0; k < len; k++) {
            if (arr[i + k] != pieces[j][k]) {
                hashFree(&index);
                return false;
            }
        }
        i = i + len;
    }
    hashFree(&index);
    return true;
}
```

```JavaScript [sol1-JavaScript]
var canFormArray = function(arr, pieces) {
    const n = arr.length, m = pieces.length;
    const index = new Map();
    for (let i = 0; i < m; i++) {
        index.set(pieces[i][0], i);
    }
    for (let i = 0; i < n;) {
        if (!index.has(arr[i])) {
            return false;
        }
        const j = index.get(arr[i]), len = pieces[j].length;
        for (let k = 0; k < len; k++) {
            if (arr[i + k] != pieces[j][k]) {
                return false;
            }
        }
        i = i + len;
    }
    return true;
};
```

```go [sol1-Golang]
func canFormArray(arr []int, pieces [][]int) bool {
    index := make(map[int]int, len(pieces))
    for i, p := range pieces {
        index[p[0]] = i
    }
    for i := 0; i < len(arr); {
        j, ok := index[arr[i]]
        if !ok {
            return false
        }
        for _, x := range pieces[j] {
            if arr[i] != x {
                return false
            }
            i++
        }
    }
    return true
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。

+ 空间复杂度：$O(n)$。保存哈希表需要 $O(n)$ 的空间。