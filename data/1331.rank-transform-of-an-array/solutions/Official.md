## [1331.数组序号转换 中文官方题解](https://leetcode.cn/problems/rank-transform-of-an-array/solutions/100000/shu-zu-xu-hao-zhuan-huan-by-leetcode-sol-8zlu)
#### 方法一：排序 + 哈希表

**思路** 

首先用一个数组保存排序完的原数组，然后用一个哈希表保存各元素的序号，最后将原属组的元素替换为序号后返回。

**代码**

```Python [sol1-Python3]
class Solution:
    def arrayRankTransform(self, arr: List[int]) -> List[int]:
        ranks = {v: i for i, v in enumerate(sorted(set(arr)), 1)}
        return [ranks[v] for v in arr]
```

```Java [sol1-Java]
class Solution {
    public int[] arrayRankTransform(int[] arr) {
        int[] sortedArr = new int[arr.length];
        System.arraycopy(arr, 0, sortedArr, 0, arr.length);
        Arrays.sort(sortedArr);
        Map<Integer, Integer> ranks = new HashMap<Integer, Integer>();
        int[] ans = new int[arr.length];
        for (int a : sortedArr) {
            if (!ranks.containsKey(a)) {
                ranks.put(a, ranks.size() + 1);
            }
        }
        for (int i = 0; i < arr.length; i++) {
            ans[i] = ranks.get(arr[i]);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] ArrayRankTransform(int[] arr) {
        int[] sortedArr = new int[arr.Length];
        Array.Copy(arr, 0, sortedArr, 0, arr.Length);
        Array.Sort(sortedArr);
        Dictionary<int, int> ranks = new Dictionary<int, int>();
        int[] ans = new int[arr.Length];
        foreach (int a in sortedArr) {
            ranks.TryAdd(a, ranks.Count + 1);
        }
        for (int i = 0; i < arr.Length; i++) {
            ans[i] = ranks[arr[i]];
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> arrayRankTransform(vector<int>& arr) {
        vector<int> sortedArr = arr;
        sort(sortedArr.begin(), sortedArr.end());
        unordered_map<int, int> ranks;
        vector<int> ans(arr.size());
        for (auto &a : sortedArr) {
            if (!ranks.count(a)) {
                ranks[a] = ranks.size() + 1;
            }
        }
        for (int i = 0; i < arr.size(); i++) {
            ans[i] = ranks[arr[i]];
        }
        return ans;
    }
};
```

```C [sol1-C]
typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem;

static inline int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int* arrayRankTransform(int* arr, int arrSize, int* returnSize) {
    int *sortedArr = (int *)malloc(sizeof(int) * arrSize);
    int *ans = (int *)malloc(sizeof(int) * arrSize);
    memcpy(sortedArr, arr, sizeof(int) * arrSize);
    qsort(sortedArr, arrSize, sizeof(int), cmp);
    HashItem *ranks = NULL;
    for (int i = 0; i < arrSize; i++) {
        HashItem *pEntry = NULL;
        HASH_FIND_INT(ranks, &sortedArr[i], pEntry);
        if (pEntry == NULL) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = sortedArr[i];
            pEntry->val = HASH_COUNT(ranks) + 1;
            HASH_ADD_INT(ranks, key, pEntry);
        }
    }
    for (int i = 0; i < arrSize; i++) {
        HashItem *pEntry = NULL;
        HASH_FIND_INT(ranks, &arr[i], pEntry);
        ans[i] = pEntry->val;
    }
    *returnSize = arrSize;
    HashItem *cur, *tmp;
    HASH_ITER(hh, ranks, cur, tmp) {
        HASH_DEL(ranks, cur);  
        free(cur);             
    }
    free(sortedArr);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var arrayRankTransform = function(arr) {
    const sortedArr = new Array(arr.length).fill(0);
    sortedArr.splice(0, arr.length, ...arr);
    sortedArr.sort((a, b) => a - b);
    const ranks = new Map();
    const ans = new Array(arr.length).fill(0);
    for (const a of sortedArr) {
        if (!ranks.has(a)) {
            ranks.set(a, ranks.size + 1);
        }
    }
    for (let i = 0; i < arr.length; i++) {
        ans[i] = ranks.get(arr[i]);
    }
    return ans;
};
```

```go [sol1-Golang]
func arrayRankTransform(arr []int) []int {
    a := append([]int{}, arr...)
    sort.Ints(a)
    ranks := map[int]int{}
    for _, v := range a {
        if _, ok := ranks[v]; !ok {
            ranks[v] = len(ranks) + 1
        }
    }
    for i, v := range arr {
        arr[i] = ranks[v]
    }
    return arr
}
```

**复杂度分析**

- 时间复杂度：$O(n \times \log{n})$，其中 $n$ 是输入数组 $\textit{arr}$ 的长度，排序消耗 $O(n \times \log{n})$ 时间。

- 空间复杂度：$O(n)$。有序数组和哈希表各消耗 $O(n)$ 空间。