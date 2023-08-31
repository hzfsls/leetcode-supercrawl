## [1713.得到子序列的最少操作次数 中文官方题解](https://leetcode.cn/problems/minimum-operations-to-make-a-subsequence/solutions/100000/de-dao-zi-xu-lie-de-zui-shao-cao-zuo-ci-hefgl)
#### 方法一：贪心 + 二分查找

记数组 $\textit{target}$ 的长度为 $n$，数组$\textit{arr}$ 的长度为 $m$。

根据题意，$\textit{target}$ 和 $\textit{arr}$ 这两个数组的公共子序列越长，需要添加的元素个数也就越少。因此最少添加的元素个数为 $n$ 减去两数组的最长公共子序列的长度。

求最长公共子序列是一个经典问题，读者可参考「[1143. 最长公共子序列的官方题解](https://leetcode-cn.com/problems/longest-common-subsequence/solution/zui-chang-gong-gong-zi-xu-lie-by-leetcod-y7u0/)」。但是，这一做法的时间复杂度是 $O(nm)$ 的，在本题的数据范围下无法承受，我们需要改变思路。

由于 $\textit{target}$ 的元素互不相同，我们可以用一个哈希表记录 $\textit{target}$ 的每个元素所处的下标，并将 $\textit{arr}$ 中的元素映射到下标上，对于不存在于 $\textit{target}$ 中的元素，由于其必然不会在最长公共子序列中，可将其忽略。

我们使用示例 $2$ 来说明，将 $\textit{arr}$ 中的元素转换成该元素在 $\textit{target}$ 中的下标（去掉不在 $\textit{target}$ 中的元素 $7$），可以得到一个新数组

$$
\textit{arr}' = [1,0,5,4,2,0,3]
$$

若将 $\textit{target}$ 也做上述转换，这相当于将每个元素变为其下标，得

$$
\textit{target}' = [0,1,2,3,4,5]
$$

则求原数组的最长公共子序列等价于求上述转换后的两数组的最长公共子序列。

注意到 $\textit{target}'$ 是严格单调递增的，因此 $\textit{arr}'$ 在最长公共子序列中的部分也必须是严格单调递增的，因此问题可进一步地转换成求 $\textit{arr}'$ 的最长递增子序列的长度。这也是一个经典问题，读者可以参考「[300. 最长递增子序列的官方题解](https://leetcode-cn.com/problems/longest-increasing-subsequence/solution/zui-chang-shang-sheng-zi-xu-lie-by-leetcode-soluti/)」，使用贪心和二分查找的方法得到最长递增子序列的长度。

```C++ [sol1-C++]
class Solution {
public:
    int minOperations(vector<int> &target, vector<int> &arr) {
        int n = target.size();
        unordered_map<int, int> pos;
        for (int i = 0; i < n; ++i) {
            pos[target[i]] = i;
        }
        vector<int> d;
        for (int val : arr) {
            if (pos.count(val)) {
                int idx = pos[val];
                auto it = lower_bound(d.begin(), d.end(), idx);
                if (it != d.end()) {
                    *it = idx;
                } else {
                    d.push_back(idx);
                }
            }
        }
        return n - d.size();
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minOperations(int[] target, int[] arr) {
        int n = target.length;
        Map<Integer, Integer> pos = new HashMap<Integer, Integer>();
        for (int i = 0; i < n; ++i) {
            pos.put(target[i], i);
        }
        List<Integer> d = new ArrayList<Integer>();
        for (int val : arr) {
            if (pos.containsKey(val)) {
                int idx = pos.get(val);
                int it = binarySearch(d, idx);
                if (it != d.size()) {
                    d.set(it, idx);
                } else {
                    d.add(idx);
                }
            }
        }
        return n - d.size();
    }

    public int binarySearch(List<Integer> d, int target) {
        int size = d.size();
        if (size == 0 || d.get(size - 1) < target) {
            return size;
        }
        int low = 0, high = size - 1;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (d.get(mid) < target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinOperations(int[] target, int[] arr) {
        int n = target.Length;
        Dictionary<int, int> pos = new Dictionary<int, int>();
        for (int i = 0; i < n; ++i) {
            pos.Add(target[i], i);
        }
        IList<int> d = new List<int>();
        foreach (int val in arr) {
            if (pos.ContainsKey(val)) {
                int idx = pos[val];
                int it = BinarySearch(d, idx);
                if (it != d.Count) {
                    d[it] = idx;
                } else {
                    d.Add(idx);
                }
            }
        }
        return n - d.Count;
    }

    public int BinarySearch(IList<int> d, int target) {
        int size = d.Count;
        if (size == 0 || d[size - 1] < target) {
            return size;
        }
        int low = 0, high = size - 1;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (d[mid] < target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```go [sol1-Golang]
func minOperations(target, arr []int) int {
    n := len(target)
    pos := make(map[int]int, n)
    for i, val := range target {
        pos[val] = i
    }
    d := []int{}
    for _, val := range arr {
        if idx, has := pos[val]; has {
            if p := sort.SearchInts(d, idx); p < len(d) {
                d[p] = idx
            } else {
                d = append(d, idx)
            }
        }
    }
    return n - len(d)
}
```

```C [sol1-C]
struct HashTable {
    int key, val;
    UT_hash_handle hh;
};

int lower_bound(int* arr, int l, int r, int val) {
    while (l < r) {
        int mid = (l + r) >> 1;
        if (arr[mid] >= val) {
            r = mid;
        } else {
            l = mid + 1;
        }
    }
    return l;
}

int minOperations(int* target, int targetSize, int* arr, int arrSize) {
    struct HashTable* hashTable = NULL;
    for (int i = 0; i < targetSize; i++) {
        struct HashTable* tmp;
        HASH_FIND_INT(hashTable, &target[i], tmp);
        if (tmp == NULL) {
            tmp = (struct HashTable*)malloc(sizeof(struct HashTable));
            tmp->key = target[i], tmp->val = i;
            HASH_ADD_INT(hashTable, key, tmp);
        }
    }
    int d[arrSize], dSize = 0;
    for (int i = 0; i < arrSize; i++) {
        struct HashTable* tmp;
        HASH_FIND_INT(hashTable, &arr[i], tmp);
        if (tmp != NULL) {
            int idx = tmp->val;
            int it = lower_bound(d, 0, dSize, idx);
            if (it == dSize) {
                d[dSize++] = idx;
            } else {
                d[it] = idx;
            }
        }
    }
    return targetSize - dSize;
}
```

```JavaScript [sol1-JavaScript]
var minOperations = function(target, arr) {
    const n = target.length;
    const pos = new Map();
    for (let i = 0; i < n; ++i) {
        pos.set(target[i], i);
    }
    const d = [];
    for (const val of arr) {
        if (pos.has(val)) {
            const idx = pos.get(val);
            const it = binarySearch(d, idx);
            if (it !== d.length) {
                d[it] = idx;
            } else {
                d.push(idx);
            }
        }
    }
    return n - d.length;
};

const binarySearch = (d, target) => {
    const size = d.length;
    if (size === 0 || d[size - 1] < target) {
        return size;
    }
    let low = 0, high = size - 1;
    while (low < high) {
        const mid = Math.floor((high - low) / 2) + low;
        if (d[mid] < target) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
}
```

**复杂度分析**

- 时间复杂度：$O(n+m\log m)$，其中 $n$ 是数组 $\textit{target}$ 的长度，$m$ 是数组 $\textit{arr}$ 的长度。遍历 $\textit{target}$ 需要 $O(n)$ 的时间，求 $\textit{arr}'$ 的最长递增子序列需要 $O(m\log m)$ 的时间。

- 空间复杂度：$O(n+m)$。需要 $O(n)$ 大小的哈希表存储 $\textit{target}$ 的元素的下标，以及 $O(m)$ 的空间求最长递增子序列。