## [2367.算术三元组的数目 中文官方题解](https://leetcode.cn/problems/number-of-arithmetic-triplets/solutions/100000/suan-zhu-san-yuan-zu-de-shu-mu-by-leetco-ldq4)
#### 方法一：暴力枚举

为了得到算术三元组的数目，最直观的做法是使用三重循环暴力枚举数组中的每个三元组，判断每个三元组是否为算术三元组，枚举结束之后即可得到算术三元组的数目。

```Java [sol1-Java]
class Solution {
    public int arithmeticTriplets(int[] nums, int diff) {
        int ans = 0;
        int n = nums.length;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if (nums[j] - nums[i] != diff) {
                    continue;
                }
                for (int k = j + 1; k < n; k++) {
                    if (nums[k] - nums[j] == diff) {
                        ans++;
                    }
                }
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ArithmeticTriplets(int[] nums, int diff) {
        int ans = 0;
        int n = nums.Length;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if (nums[j] - nums[i] != diff) {
                    continue;
                }
                for (int k = j + 1; k < n; k++) {
                    if (nums[k] - nums[j] == diff) {
                        ans++;
                    }
                }
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int arithmeticTriplets(vector<int>& nums, int diff) {
        int ans = 0;
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if (nums[j] - nums[i] != diff) {
                    continue;
                }
                for (int k = j + 1; k < n; k++) {
                    if (nums[k] - nums[j] == diff) {
                        ans++;
                    }
                }
            }
        }
        return ans;
    }
};
```

```C [sol1-C]
int arithmeticTriplets(int* nums, int numsSize, int diff) {
    int ans = 0;
    for (int i = 0; i < numsSize; i++) {
        for (int j = i + 1; j < numsSize; j++) {
            if (nums[j] - nums[i] != diff) {
                continue;
            }
            for (int k = j + 1; k < numsSize; k++) {
                if (nums[k] - nums[j] == diff) {
                    ans++;
                }
            }
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var arithmeticTriplets = function(nums, diff) {
    let ans = 0;
    const n = nums.length;
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
            if (nums[j] - nums[i] !== diff) {
                continue;
            }
            for (let k = j + 1; k < n; k++) {
                if (nums[k] - nums[j] === diff) {
                    ans++;
                }
            }
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。使用三重循环暴力枚举需要 $O(n^3)$ 的时间。

- 空间复杂度：$O(1)$。只需要常数的额外空间。

#### 方法二：哈希集合

由于给定的数组 $\textit{nums}$ 是严格递增的，因此数组中不存在重复元素，不存在两个相同的算术三元组。

对于数组 $\textit{nums}$ 中的元素 $x$，如果 $x + \textit{diff}$ 和 $x + 2 \times \textit{diff}$ 都在数组中，则存在一个算术三元组，其中的三个元素分别是 $x$、$x + \textit{diff}$ 和 $x + 2 \times \textit{diff}$，因此问题转换成计算数组 $\textit{nums}$ 中有多少个元素可以作为算术三元组的最小元素。

为了快速判断一个元素是否在数组中，可以使用哈希集合存储数组中的所有元素，然后判断元素是否在哈希集合中。

将数组中的所有元素都加入哈希集合之后，遍历数组并统计满足 $x + \textit{diff}$ 和 $x + 2 \times \textit{diff}$ 都在哈希集合中的元素 $x$ 的个数，即为算术三元组的数目。

```Java [sol2-Java]
class Solution {
    public int arithmeticTriplets(int[] nums, int diff) {
        Set<Integer> set = new HashSet<Integer>();
        for (int x : nums) {
            set.add(x);
        }
        int ans = 0;
        for (int x : nums) {
            if (set.contains(x + diff) && set.contains(x + 2 * diff)) {
                ans++;
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ArithmeticTriplets(int[] nums, int diff) {
        ISet<int> set = new HashSet<int>();
        foreach (int x in nums) {
            set.Add(x);
        }
        int ans = 0;
        foreach (int x in nums) {
            if (set.Contains(x + diff) && set.Contains(x + 2 * diff)) {
                ans++;
            }
        }
        return ans;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int arithmeticTriplets(vector<int>& nums, int diff) {
        unordered_set<int> hashSet;
        for (int x : nums) {
            hashSet.emplace(x);
        }
        int ans = 0;
        for (int x : nums) {
            if (hashSet.count(x + diff) && hashSet.count(x + 2 * diff)) {
                ans++;
            }
        }
        return ans;
    }
};
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

int arithmeticTriplets(int* nums, int numsSize, int diff) {
    HashItem *hashSet = NULL;
    for (int i = 0; i < numsSize; i++) {
        hashAddItem(&hashSet, nums[i]);
    }
    int ans = 0;
    for (int i = 0; i < numsSize; i++) {
        if (hashFindItem(&hashSet, nums[i] + diff) && hashFindItem(&hashSet, nums[i] + 2 * diff)) {
            ans++;
        }
    }
    hashFree(&hashSet);
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var arithmeticTriplets = function(nums, diff) {
    const set = new Set();
    for (const x of nums) {
        set.add(x);
    }
    let ans = 0;
    for (const x of nums) {
        if (set.has(x + diff) && set.has(x + 2 * diff)) {
            ans++;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要遍历数组两次，每次将元素加入哈希集合与判断元素是否在哈希集合中的时间都是 $O(1)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。哈希集合需要 $O(n)$ 的空间。

#### 方法三：三指针

利用数组 $\textit{nums}$ 严格递增的条件，可以使用三指针遍历数组得到算术三元组，使用 $O(n)$ 时间复杂度和 $O(1)$ 空间复杂度。

用 $i$、$j$ 和 $k$ 分别表示三元组的三个下标，其中 $i < j < k$，初始时 $i = 0$，$j = 1$，$k = 2$。对于每个下标 $i$，最多有一个下标 $j$ 和一个下标 $k$ 使得 $(i, j, k)$ 是算术三元组。假设存在两个算术三元组 $(i_1, j_1, k_1)$ 和 $(i_2, j_2, k_2)$ 满足 $i_1 < i_2$，则根据数组 $\textit{nums}$ 严格递增可以得到 $\textit{nums}[i_1] < \textit{nums}[i_2]$，因此有 $\textit{nums}[j_1] < \textit{nums}[j_2]$ 和 $\textit{nums}[k_1] < \textit{nums}[k_2]$，下标关系满足 $j_1 < j_2$ 和 $k_1 < k_2$。由此可以得到结论：如果 $(i, j, k)$ 是算术三元组，则在将 $i$ 增加之后，为了得到以 $i$ 作为首个下标的算术三元组，必须将 $j$ 和 $k$ 也增加。

利用上述结论，可以使用三指针统计算术三元组的数目。

从小到大枚举每个 $i$，对于每个 $i$，执行如下操作。

1. 定位 $j$。

   1. 为了确保 $j > i$，如果 $j \le i$ 则将 $j$ 更新为 $i + 1$。

   2. 如果 $j < n - 1$ 且 $\textit{nums}[j] - \textit{nums}[i] < \textit{diff}$，则只有将 $j$ 向右移动才可能满足 $\textit{nums}[j] - \textit{nums}[i] = \textit{diff}$，因此将 $j$ 向右移动，直到 $j \ge n - 1$ 或 $\textit{nums}[j] - \textit{nums}[i] \ge \textit{diff}$。如果此时 $j \ge n - 1$ 或 $\textit{nums}[j] - \textit{nums}[i] > \textit{diff}$，则对于当前的 $i$ 不存在 $j$ 和 $k$ 可以组成算术三元组，因此继续枚举下一个 $i$。

2. 当 $j < n - 1$ 且 $\textit{nums}[j] - \textit{nums}[i] = \textit{diff}$ 时，定位 $k$。

   1. 为了确保 $k > j$，如果 $k \le j$ 则将 $k$ 更新为 $j + 1$。

   2. 如果 $k < n$ 且 $\textit{nums}[k] - \textit{nums}[j] < \textit{diff}$，则只有将 $k$ 向右移动才可能满足 $\textit{nums}[k] - \textit{nums}[j] = \textit{diff}$，因此将 $k$ 向右移动，直到 $k \ge n$ 或 $\textit{nums}[k] - \textit{nums}[j] \ge \textit{diff}$。如果此时 $k < n$ 且 $\textit{nums}[k] - \textit{nums}[j] = \textit{diff}$，则当前的 $(i, j, k)$ 是算术三元组。

枚举所有可能的情况之后，即可得到算术三元组的数目。上述操作中，每个下标都只会增加不会减少，因此每个下标遍历数组的时间都是 $O(n)$。

```Java [sol3-Java]
class Solution {
    public int arithmeticTriplets(int[] nums, int diff) {
        int ans = 0;
        int n = nums.length;
        for (int i = 0, j = 1, k = 2; i < n - 2 && j < n - 1 && k < n; i++) {
            j = Math.max(j, i + 1);
            while (j < n - 1 && nums[j] - nums[i] < diff) {
                j++;
            }
            if (j >= n - 1 || nums[j] - nums[i] > diff) {
                continue;
            }
            k = Math.max(k, j + 1);
            while (k < n && nums[k] - nums[j] < diff) {
                k++;
            }
            if (k < n && nums[k] - nums[j] == diff) {
                ans++;
            }
        }
        return ans;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int ArithmeticTriplets(int[] nums, int diff) {
        int ans = 0;
        int n = nums.Length;
        for (int i = 0, j = 1, k = 2; i < n - 2 && j < n - 1 && k < n; i++) {
            j = Math.Max(j, i + 1);
            while (j < n - 1 && nums[j] - nums[i] < diff) {
                j++;
            }
            if (j >= n - 1 || nums[j] - nums[i] > diff) {
                continue;
            }
            k = Math.Max(k, j + 1);
            while (k < n && nums[k] - nums[j] < diff) {
                k++;
            }
            if (k < n && nums[k] - nums[j] == diff) {
                ans++;
            }
        }
        return ans;
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    int arithmeticTriplets(vector<int>& nums, int diff) {
        int ans = 0;
        int n = nums.size();
        for (int i = 0, j = 1, k = 2; i < n - 2 && j < n - 1 && k < n; i++) {
            j = max(j, i + 1);
            while (j < n - 1 && nums[j] - nums[i] < diff) {
                j++;
            }
            if (j >= n - 1 || nums[j] - nums[i] > diff) {
                continue;
            }
            k = max(k, j + 1);
            while (k < n && nums[k] - nums[j] < diff) {
                k++;
            }
            if (k < n && nums[k] - nums[j] == diff) {
                ans++;
            }
        }
        return ans;
    }
};
```

```C [sol3-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int arithmeticTriplets(int* nums, int numsSize, int diff){
    int ans = 0;
    int n = numsSize;
    for (int i = 0, j = 1, k = 2; i < n - 2 && j < n - 1 && k < n; i++) {
        j = MAX(j, i + 1);
        while (j < n - 1 && nums[j] - nums[i] < diff) {
            j++;
        }
        if (j >= n - 1 || nums[j] - nums[i] > diff) {
            continue;
        }
        k = MAX(k, j + 1);
        while (k < n && nums[k] - nums[j] < diff) {
            k++;
        }
        if (k < n && nums[k] - nums[j] == diff) {
            ans++;
        }
    }
    return ans;
}
```

```JavaScript [sol3-JavaScript]
var arithmeticTriplets = function(nums, diff) {
    let ans = 0;
    const n = nums.length;
    for (let i = 0, j = 1, k = 2; i < n - 2 && j < n - 1 && k < n; i++) {
        j = Math.max(j, i + 1);
        while (j < n - 1 && nums[j] - nums[i] < diff) {
            j++;
        }
        if (j >= n - 1 || nums[j] - nums[i] > diff) {
            continue;
        }
        k = Math.max(k, j + 1);
        while (k < n && nums[k] - nums[j] < diff) {
            k++;
        }
        if (k < n && nums[k] - nums[j] === diff) {
            ans++;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。三个指针最多各遍历数组一次。

- 空间复杂度：$O(1)$。只需要常数的额外空间。