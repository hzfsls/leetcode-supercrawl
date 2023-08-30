#### 方法一：排序 + 模拟

这道题要求计算将非负整数数组 $\textit{nums}$ 中的所有元素减少到 $0$ 的最少操作数。用 $m$ 表示数组 $\textit{nums}$ 中的最小非零元素，则可以选择不超过 $m$ 的正整数 $x$，将数组中的每个非零元素减 $x$。为了使操作数最少，应选择 $x = m$，理由如下。

- 当选择 $x = m$ 时，经过一次操作之后，数组中的所有元素 $m$ 都变成 $0$，且其余的所有非零元素都减少 $m$。

- 当选择 $x < m$ 时，经过一次操作之后，数组中的所有元素 $m$ 在减少 $x$ 之后仍大于 $0$，为了使数组中的最小非零元素变成 $0$，至少还需要一次操作，因此至少需要两次操作使数组中的所有元素 $m$ 都变成 $0$，且其余的所有非零元素都减少 $m$。

由于当 $x < m$ 时使元素 $m$ 变成 $0$ 的操作数大于当 $x = m$ 时使元素 $m$ 变成 $0$ 的操作数，且两种方案中，使元素 $m$ 变成 $0$ 之后，剩余的最小非零元素相同（所有非零元素都减少 $m$），因此只有当 $x = m$ 时才能使操作数最少。

根据上述分析，应使用贪心策略使操作数最少，贪心策略为每次选择数组中的最小非零元素作为 $x$，将数组中的每个非零元素减 $x$。

可以根据贪心策略模拟操作过程，计算最少操作数。

首先将数组 $\textit{nums}$ 按升序排序，然后从左到右遍历排序后的数组 $\textit{nums}$。对于每个遍历到的非零元素，该元素是数组中的最小非零元素，将该元素记为 $x$，将数组中的每个非零元素都减 $x$，将操作数加 $1$。遍历结束之后，即可得到最少操作数。

```Java [sol1-Java]
class Solution {
    public int minimumOperations(int[] nums) {
        int ans = 0;
        Arrays.sort(nums);
        int length = nums.length;
        for (int i = 0; i < length; i++) {
            if (nums[i] > 0) {
                subtract(nums, nums[i], i);
                ans++;
            }
        }
        return ans;
    }

    public void subtract(int[] nums, int x, int startIndex) {
        int length = nums.length;
        for (int i = startIndex; i < length; i++) {
            nums[i] -= x;
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumOperations(int[] nums) {
        int ans = 0;
        Array.Sort(nums);
        int length = nums.Length;
        for (int i = 0; i < length; i++) {
            if (nums[i] > 0) {
                Subtract(nums, nums[i], i);
                ans++;
            }
        }
        return ans;
    }

    public void Subtract(int[] nums, int x, int startIndex) {
        int length = nums.Length;
        for (int i = startIndex; i < length; i++) {
            nums[i] -= x;
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    void subtract(vector<int>& nums, int x, int startIndex) {
        int length = nums.size();
        for (int i = startIndex; i < length; i++) {
            nums[i] -= x;
        }
    }

    int minimumOperations(vector<int>& nums) {
        int ans = 0;
        sort(nums.begin(), nums.end());
        int length = nums.size();
        for (int i = 0; i < length; i++) {
            if (nums[i] > 0) {
                subtract(nums, nums[i], i);
                ans++;
            }
        }
        return ans;
    }
};
```

```C [sol1-C]
static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

void subtract(int* nums, int numsSize, int x, int startIndex) {
    for (int i = startIndex; i < numsSize; i++) {
        nums[i] -= x;
    }
}

int minimumOperations(int* nums, int numsSize) {
    int ans = 0;
    qsort(nums, numsSize, sizeof(int), cmp);
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] > 0) {
            subtract(nums, numsSize, nums[i], i);
            ans++;
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var minimumOperations = function(nums) {
    let ans = 0;
    nums.sort((a, b) => a - b);
    const length = nums.length;
    for (let i = 0; i < length; i++) {
        if (nums[i] > 0) {
            subtract(nums, nums[i], i);
            ans++;
        }
    }
    return ans;
}

const subtract = (nums, x, startIndex) => {
    const length = nums.length;
    for (let i = startIndex; i < length; i++) {
        nums[i] -= x;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。排序需要 $O(n \log n)$ 的时间，排序之后需要遍历数组一次，对于每个非零元素，将数组中的所有非零元素减去最小非零元素需要 $O(n)$ 的时间，因此时间复杂度是 $O(n^2)$。

- 空间复杂度：$O(\log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。排序需要 $O(\log n)$ 的递归调用栈空间。

#### 方法二：哈希集合

由于每次操作都将数组中的所有非零元素减少一个相同的值，因此数组中的相等元素减少到 $0$ 的操作数相等，数组中的不相等元素减少到 $0$ 的操作数不相等。

又由于使用贪心策略操作时，每次操作都会将数组中的最小非零元素减少到 $0$，因此最少操作数等于数组中的不同非零元素的个数。

使用哈希集合存储数组中的所有**非零元素**，则哈希集合的大小等于数组中的不同非零元素的个数，即为最少操作数。

需要注意的是，由于目标是将数组中的所有元素减为 $0$，如果数组中的一个元素已经是 $0$ 则不需要对该元素执行操作，因此只需要考虑数组中的不同非零元素的个数。

```Python [sol2-Python3]
class Solution:
    def minimumOperations(self, nums: List[int]) -> int:
        return len(set(nums) - {0})
```

```Java [sol2-Java]
class Solution {
    public int minimumOperations(int[] nums) {
        Set<Integer> set = new HashSet<Integer>();
        for (int num : nums) {
            if (num > 0) {
                set.add(num);
            }
        }
        return set.size();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinimumOperations(int[] nums) {
        ISet<int> set = new HashSet<int>();
        foreach (int num in nums) {
            if (num > 0) {
                set.Add(num);
            }
        }
        return set.Count;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int minimumOperations(vector<int>& nums) {
        unordered_set<int> hashSet;
        for (int num : nums) {
            if (num > 0) {
                hashSet.emplace(num);
            }
        }
        return hashSet.size();
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

int minimumOperations(int* nums, int numsSize) {
    HashItem *set = NULL;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] > 0) {
            hashAddItem(&set, nums[i]);
        }
    }
    int ret = HASH_COUNT(set);
    hashFree(&set);
    return ret;
}
```

```JavaScript [sol2-JavaScript]
var minimumOperations = function(nums) {
    const set = new Set();
    for (const num of nums) {
        if (num > 0) {
            set.add(num);
        }
    }
    return set.size;
};
```

```go [sol2-Golang]
func minimumOperations(nums []int) int {
	set := map[int]struct{}{}
	for _, x := range nums {
		if x > 0 {
			set[x] = struct{}{}
		}
	}
	return len(set)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要遍历数组一次，每个非零元素加入哈希集合的时间是 $O(1)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。哈希集合需要 $O(n)$ 的空间。