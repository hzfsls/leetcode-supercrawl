## [1460.通过翻转子数组使两个数组相等 中文官方题解](https://leetcode.cn/problems/make-two-arrays-equal-by-reversing-subarrays/solutions/100000/tong-guo-fan-zhuan-zi-shu-zu-shi-liang-g-dueo)
#### 方法一：哈希表判断数组元素是否相同

**思路**

如果 $\textit{arr}$ 长度是 $1$，那么只需判断 $\textit{arr}$ 和 $\textit{target}$ 是否相同即可。因为此时翻转非空子数组的过程并不会改变数组，只需判断原数组是否相同即可。

如果 $\textit{arr}$ 长度大于 $1$，那么首先证明通过一次或二次翻转过程，可以实现数组 $\textit{arr}$ 中任意两个元素交换位置并且保持其他元素不动。如果想要交换两个相邻元素的位置，那么翻转这两个元素组成的子数组即可。如果想要交换两个非相邻元素的位置，那么首先翻转这两个元素及其中间所有元素组成的子数组，再翻转这两个元素中间的元素组成的子数组即可。这样下来，通过一次或二次翻转过程，即可交换数组中任意两个元素的位置。一旦一个数组中任意两个元素可以交换位置，那么这个数组就能实现任意重排。只需要 $\textit{arr}$ 和 $\textit{target}$ 元素相同，$\textit{arr}$ 就能通过若干次操作变成 $\textit{target}$。

**代码**

```Python [sol1-Python3]
class Solution:
    def canBeEqual(self, target: List[int], arr: List[int]) -> bool:
        return Counter(target) == Counter(arr)
```

```Java [sol1-Java]
class Solution {
    public boolean canBeEqual(int[] target, int[] arr) {
        Map<Integer, Integer> counts1 = new HashMap<Integer, Integer>();
        Map<Integer, Integer> counts2 = new HashMap<Integer, Integer>();
        for (int num : target) {
            counts1.put(num, counts1.getOrDefault(num, 0) + 1);
        }
        for (int num : arr) {
            counts2.put(num, counts2.getOrDefault(num, 0) + 1);
        }
        if (counts1.size() != counts2.size()) {
            return false;
        }
        for (Map.Entry<Integer, Integer> entry : counts1.entrySet()) {
            int key = entry.getKey(), value = entry.getValue();
            if (!counts2.containsKey(key) || counts2.get(key) != value) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CanBeEqual(int[] target, int[] arr) {
        Dictionary<int, int> counts1 = new Dictionary<int, int>();
        Dictionary<int, int> counts2 = new Dictionary<int, int>();
        foreach (int num in target) {
            if (!counts1.ContainsKey(num)) {
                counts1.Add(num, 0);
            }
            counts1[num]++;
        }
        foreach (int num in arr) {
            if (!counts2.ContainsKey(num)) {
                counts2.Add(num, 0);
            }
            counts2[num]++;
        }
        if (counts1.Count != counts2.Count) {
            return false;
        }
        foreach (KeyValuePair<int, int> pair in counts1) {
            int key = pair.Key, value = pair.Value;
            if (!counts2.ContainsKey(key) || counts2[key] != value) {
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
    bool canBeEqual(vector<int>& target, vector<int>& arr) {
        unordered_map<int, int> counts1, counts2;
        for (int num : target) {
            counts1[num]++;
        }
        for (int num : arr) {
            counts2[num]++;
        }
        if (counts1.size() != counts2.size()) {
            return false;
        }
        for (auto &[key, value] : counts1) {
            if (!counts2.count(key) || counts2[key] != value) {
                return false;
            }
        }
        return true;
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

bool canBeEqual(int* target, int targetSize, int* arr, int arrSize){
    HashItem *counts1 = NULL, *counts2 = NULL;
    for (int i = 0; i < targetSize; i++) {
        hashSetItem(&counts1, target[i], hashGetItem(&counts1, target[i], 0) + 1);
    }
    for (int i = 0; i < arrSize; i++) {
        hashSetItem(&counts2, arr[i], hashGetItem(&counts2, arr[i], 0) + 1);
    }
    if (HASH_COUNT(counts1) != HASH_COUNT(counts2)) {
        return false;
    }
    for (HashItem *pEntry = counts1; pEntry != NULL; pEntry = pEntry->hh.next) {
        int key = pEntry->key, value = pEntry->val;
        if (hashGetItem(&counts2, key, 0) != value) {
            return false;
        }
    }
    hashFree(&counts1);
    hashFree(&counts2);
    return true;
}
```

```JavaScript [sol1-JavaScript]
var canBeEqual = function(target, arr) {
    const counts1 = new Map();
    const counts2 = new Map();
    for (const num of target) {
        counts1.set(num, (counts1.get(num) || 0) + 1);
    }
    for (const num of arr) {
        counts2.set(num, (counts2.get(num) || 0) + 1);   
    }
    if (counts1.size !== counts2.size) {
        return false;
    }
    for (const [key, value] of counts1.entries()) {
        if (!counts2.has(key) || counts2.get(key) !== value) {
            return false;
        }
    }
    return true;
};
```

```go [sol1-Golang]
func canBeEqual(target, arr []int) bool {
    cnt := map[int]int{}
    for i, x := range target {
        cnt[x]++
        cnt[arr[i]]--
    }
    for _, c := range cnt {
        if c != 0 {
            return false
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是输入数组的长度，统计并判断频次是否相同消耗 $O(n)$。

- 空间复杂度：$O(n)$，哈希表最多消耗 $O(n)$ 空间。

#### 方法二：排序判断数组元素是否相同

**思路**

与方法一类似，但是判断元素是否相同时，可以将两个数组分别排序，再判断排完序的数组是否相同即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def canBeEqual(self, target: List[int], arr: List[int]) -> bool:
        target.sort()
        arr.sort()
        return target == arr
```

```Java [sol2-Java]
class Solution {
    public boolean canBeEqual(int[] target, int[] arr) {
        Arrays.sort(target);
        Arrays.sort(arr);
        return Arrays.equals(target, arr);
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool CanBeEqual(int[] target, int[] arr) {
        Array.Sort(target);
        Array.Sort(arr);
        return target.SequenceEqual(arr);
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    bool canBeEqual(vector<int>& target, vector<int>& arr) {
        sort(target.begin(), target.end());
        sort(arr.begin(), arr.end());
        return target == arr;
    }
};
```

```C [sol2-C]
static inline int cmp(const void* pa, const void* pb) {
    return *(int *)pa - *(int *)pb;
}

bool canBeEqual(int* target, int targetSize, int* arr, int arrSize) {
    qsort(target, targetSize, sizeof(int), cmp);
    qsort(arr, arrSize, sizeof(int), cmp);
    return memcmp(target, arr, sizeof(int) * arrSize) == 0;
}
```

```JavaScript [sol2-JavaScript]
var canBeEqual = function(target, arr) {
    target.sort((a, b) => a - b);
    arr.sort((a, b) => a - b);
    return target.toString() === arr.toString();
};
```

```go [sol2-Golang]
func canBeEqual(target, arr []int) bool {
    sort.Ints(target)
    sort.Ints(arr)
    for i, x := range target {
        if x != arr[i] {
            return false
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n \times \log n)$，其中 $n$ 是输入数组的长度。排序消耗 $O(n \times \log n)$ 复杂度，判断是否相同消耗 $O(n)$ 复杂度。

- 空间复杂度：$O(\log n)$，快速排序递归深度平均为 $O(\log n)$。