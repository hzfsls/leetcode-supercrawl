#### 方法一：哈希表

首先使用哈希表记录每个数字的出现次数；随后再利用新的哈希表，统计不同的出现次数的数目。如果不同的出现次数的数目等于不同数字的数目，则返回 $\text{true}$，否则返回 $\text{false}$。

```C++ [sol1-C++]
class Solution {
public:
    bool uniqueOccurrences(vector<int>& arr) {
        unordered_map<int, int> occur;
        for (const auto& x: arr) {
            occur[x]++;
        }
        unordered_set<int> times;
        for (const auto& x: occur) {
            times.insert(x.second);
        }
        return times.size() == occur.size();
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean uniqueOccurrences(int[] arr) {
        Map<Integer, Integer> occur = new HashMap<Integer, Integer>();
        for (int x : arr) {
            occur.put(x, occur.getOrDefault(x, 0) + 1);
        }
        Set<Integer> times = new HashSet<Integer>();
        for (Map.Entry<Integer, Integer> x : occur.entrySet()) {
            times.add(x.getValue());
        }
        return times.size() == occur.size();
    }
}
```

```C [sol1-C]
struct unordered_set {
    int key;
    UT_hash_handle hh;
};

struct unordered_map {
    int key;
    int val;
    UT_hash_handle hh;
};

bool uniqueOccurrences(int* arr, int arrSize) {
    struct unordered_map* occur = NULL;
    for (int i = 0; i < arrSize; i++) {
        struct unordered_map* tmp = NULL;
        HASH_FIND_INT(occur, &arr[i], tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct unordered_map));
            tmp->key = arr[i], tmp->val = 1;
            HASH_ADD_INT(occur, key, tmp);
        } else {
            (tmp->val)++;
        }
    }
    struct unordered_set* times = NULL;
    struct unordered_map *cur, *cur_tmp;
    HASH_ITER(hh, occur, cur, cur_tmp) {
        struct unordered_set* tmp = NULL;
        HASH_FIND_INT(times, &(cur->val), tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct unordered_set));
            tmp->key = cur->val;
            HASH_ADD_INT(times, key, tmp);
        }
    }
    return HASH_COUNT(occur) == HASH_COUNT(times);
}
```

```JavaScript [sol1-JavaScript]
var uniqueOccurrences = function(arr) {
    const occur = new Map();
    for (const x of arr) {
        if (occur.has(x)) {
            occur.set(x, occur.get(x) + 1);
        } else {
            occur.set(x, 1);
        }
    }
    const times = new Set();
    for (const [key, value] of occur) {
        times.add(value);
    }
    return times.size === occur.size;
};
```

```Golang [sol1-Golang]
func uniqueOccurrences(arr []int) bool {
    cnts := map[int]int{}
    for _, v := range arr {
        cnts[v]++
    }
    times := map[int]struct{}{}
    for _, c := range cnts {
        times[c] = struct{}{}
    }
    return len(times) == len(cnts)
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为数组的长度。遍历原始数组需要 $O(N)$ 时间，而遍历中间过程产生的哈希表又需要 $O(N)$ 的时间。

- 空间复杂度：$O(N)$。