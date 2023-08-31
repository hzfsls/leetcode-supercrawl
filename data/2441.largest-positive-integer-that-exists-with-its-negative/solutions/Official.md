## [2441.与对应负数同时存在的最大正整数 中文官方题解](https://leetcode.cn/problems/largest-positive-integer-that-exists-with-its-negative/solutions/100000/yu-dui-ying-fu-shu-tong-shi-cun-zai-de-z-kg8f)
#### 方法一：暴力枚举

遍历整数数组 $\textit{nums}$，使用整数 $k$ 记录符合条件的最大整数，假设当前访问的元素为 $x$，如果 $-x$ 存在于整数数组 $\textit{nums}$ 中，我们使用 $x$ 更新 $k$。（不需要判断 $x$ 的正负，因为一对相反数都会被用来更新 $k$）

```C++ [sol1-C++]
class Solution {
public:
    int findMaxK(vector<int>& nums) {
        int k = -1;
        for (auto x : nums) {
            auto p = find(nums.begin(), nums.end(), -x);
            if (p != nums.end()) {
                k = max(k, x);
            }
        }
        return k;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def findMaxK(self, nums: List[int]) -> int:
        k = -1
        for x in nums:
            if -x in nums:
                k = max(k, x)
        return k

```

```Java [sol1-Java]
class Solution {
    public int findMaxK(int[] nums) {
        int k = -1;
        for (int x : nums) {
            for (int y : nums) {
                if (-x == y) {
                    k = Math.max(k, x);
                }
            }
        }
        return k;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindMaxK(int[] nums) {
        int k = -1;
        foreach (int x in nums) {
            foreach (int y in nums) {
                if (-x == y) {
                    k = Math.Max(k, x);
                }
            }
        }
        return k;
    }
}
```

```Golang [sol1-Golang]
func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func findMaxK(nums []int) int {
    k := -1
    for _, x := range nums {
        for _, y := range nums {
            if -x == y {
                k = max(x, k)
                break
            }
        }
    }
    return k;
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int findMaxK(int* nums, int numsSize) {
    int k = -1;
    for (int i = 0; i < numsSize; i++) {
        int pos = -1;
        for (int j = 0; j < numsSize; j++) {
            if (nums[j] == -nums[i]) {
                pos = j;
                break;
            }
        }
        if (pos != -1) {
            k = MAX(k, nums[i]);
        }
    }
    return k;
}
```

```JavaScript [sol1-JavaScript]
var findMaxK = function(nums) {
    let k = -1;
    for (const x of nums) {
        for (const y of nums) {
            if (-x === y) {
                k = Math.max(k, x);
            }
        }
    }
    return k;
};
```

**复杂度分析**

+ 时间复杂度：$O(n^2)$，其中 $n$ 是整数数组 $\textit{nums}$ 的长度。

+ 空间复杂度：$O(1)$。

#### 方法二：哈希表

使用哈希表保存数组 $\textit{nums}$ 的所有元素，遍历整数数组 $\textit{nums}$，使用整数 $k$ 记录符合条件的最大整数，假设当前访问的元素为 $x$，如果 $-x$ 存在于哈希表中，我们使用 $x$ 更新 $k$。（不需要判断 $x$ 的正负，因为一对相反数都会被用来更新 $k$）

```C++ [sol2-C++]
class Solution {
public:
    int findMaxK(vector<int>& nums) {
        int k = -1;
        unordered_set<int> s(nums.begin(), nums.end());
        for (auto x : nums) {
            if (s.count(-x)) {
                k = max(k, x);
            }
        }
        return k;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def findMaxK(self, nums: List[int]) -> int:
        k = -1
        s = set(nums)
        for x in nums:
            if -x in s:
                k = max(k, x)
        return k
```

```Java [sol2-Java]
class Solution {
    public int findMaxK(int[] nums) {
        int k = -1;
        Set<Integer> set = new HashSet<Integer>();
        for (int x : nums) {
            set.add(x);
        }
        for (int x : nums) {
            if (set.contains(-x)) {
                k = Math.max(k, x);
            }
        }
        return k;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int FindMaxK(int[] nums) {
        int k = -1;
        ISet<int> set = new HashSet<int>();
        foreach (int x in nums) {
            set.Add(x);
        }
        foreach (int x in nums) {
            if (set.Contains(-x)) {
                k = Math.Max(k, x);
            }
        }
        return k;
    }
}
```

```Golang [sol2-Golang]
func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func findMaxK(nums []int) int {
    k, s := -1, map[int]struct{}{}
    for _, x := range nums {
        s[x] = struct{}{}
    }
    for _, x := range nums {
        if _, ok := s[-x]; ok {
            k = max(x, k)
        }
    }
    return k
}
```

```C [sol2-C]
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);
    }
}

#define MAX(a, b) ((a) > (b) ? (a) : (b))

int findMaxK(int* nums, int numsSize){
    int k = -1;
    HashItem *cnt = NULL;
    for (int i = 0; i < numsSize; i++) {
        hashAddItem(&cnt, nums[i]);
    }
    for (int i = 0; i < numsSize; i++) {
        if (hashFindItem(&cnt, -nums[i])) {
            k = MAX(k, nums[i]);
        }
    }
    hashFree(&cnt);
    return k;
}
```

```JavaScript [sol2-JavaScript]
var findMaxK = function(nums) {
    let k = -1;
    const set = new Set();
    for (const x of nums) {
        set.add(x);
    }
    for (const x of nums) {
        if (set.has(-x)) {
            k = Math.max(k, x);
        }
    }
    return k;
};
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是整数数组 $\textit{nums}$ 的长度。

+ 空间复杂度：$O(n)$。

#### 方法三：排序 + 双指针

我们将数组 $\textit{nums}$ 从小到大进行排序，然后用指针 $j$ 从大到小对数组 $\textit{nums}$ 进行遍历，同时用指针 $i$ 从小到大查找值等于 $-\textit{nums}[j]$ 的元素。因为 $-\textit{nums}[j]$ 随 $j$ 减小而增大，所以上一步获得的 $i$ 值可以直接作为下一步的 $i$ 值。

```C++ [sol3-C++]
class Solution {
public:
    int findMaxK(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        for (int i = 0, j = nums.size() - 1; i < j; j--) {
            while (i < j && nums[i] < -nums[j]) {
                i++;
            }
            if (nums[i] == -nums[j]) {
                return nums[j];
            }
        }
        return -1;
    }
};
```

```Python [sol3-Python3]
class Solution:
    def findMaxK(self, nums: List[int]) -> int:
        nums.sort()
        i, j = 0, len(nums) - 1
        while i < j:
            while i < j and nums[i] < -nums[j]:
                i += 1
            if nums[i] == -nums[j]:
                return nums[j]
            j -= 1
        return -1
```

```Java [sol3-Java]
class Solution {
    public int findMaxK(int[] nums) {
        Arrays.sort(nums);
        for (int i = 0, j = nums.length - 1; i < j; j--) {
            while (i < j && nums[i] < -nums[j]) {
                i++;
            }
            if (nums[i] == -nums[j]) {
                return nums[j];
            }
        }
        return -1;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int FindMaxK(int[] nums) {
        Array.Sort(nums);
        for (int i = 0, j = nums.Length - 1; i < j; j--) {
            while (i < j && nums[i] < -nums[j]) {
                i++;
            }
            if (nums[i] == -nums[j]) {
                return nums[j];
            }
        }
        return -1;
    }
}
```

```Golang [sol3-Golang]
func findMaxK(nums []int) int {
    sort.Ints(nums)
    for i, j := 0, len(nums)-1; i < j; j-- {
        for i < j && nums[i] < -nums[j] {
            i++
        }
        if nums[i] == -nums[j] {
            return nums[j]
        }
    }
    return -1
}
```

```JavaScript [sol3-JavaScript]
var findMaxK = function(nums) {
    nums.sort((a, b) => a - b);
    for (let i = 0, j = nums.length - 1; i < j; j--) {
        while (i < j && nums[i] < -nums[j]) {
            i++;
        }
        if (nums[i] === -nums[j]) {
            return nums[j];
        }
    }
    return -1;
};
```

```C [sol3-C]
static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int findMaxK(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    for (int i = 0, j = numsSize - 1; i < j; j--) {
        while (i < j && nums[i] < -nums[j]) {
            i++;
        }
        if (nums[i] == -nums[j]) {
            return nums[j];
        }
    }
    return -1;
}
```

**复杂度分析**

+ 时间复杂度：$O(n\log n)$，其中 $n$ 是整数数组 $\textit{nums}$ 的长度。主要为排序的时间复杂度。

+ 空间复杂度：$O(\log n)$。主要为排序的空间复杂度。