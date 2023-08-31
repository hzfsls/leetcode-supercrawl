## [961.在长度 2N 的数组中找出重复 N 次的元素 中文官方题解](https://leetcode.cn/problems/n-repeated-element-in-size-2n-array/solutions/100000/zai-chang-du-2n-de-shu-zu-zhong-zhao-chu-w88a)
#### 方法一：哈希表

**思路与算法**

记重复 $n$ 次的元素为 $x$。由于数组 $\textit{nums}$ 中有 $n+1$ 个不同的元素，而其长度为 $2n$，那么数组中剩余的元素均只出现了一次。也就是说，我们只需要找到重复出现的元素即为答案。

因此我们可以对数组进行一次遍历，并使用哈希集合存储已经出现过的元素。如果遍历到了哈希集合中的元素，那么返回该元素作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int repeatedNTimes(vector<int>& nums) {
        unordered_set<int> found;
        for (int num: nums) {
            if (found.count(num)) {
                return num;
            }
            found.insert(num);
        }
        // 不可能的情况
        return -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int repeatedNTimes(int[] nums) {
        Set<Integer> found = new HashSet<Integer>();
        for (int num : nums) {
            if (!found.add(num)) {
                return num;
            }
        }
        // 不可能的情况
        return -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int RepeatedNTimes(int[] nums) {
        ISet<int> found = new HashSet<int>();
        foreach (int num in nums) {
            if (!found.Add(num)) {
                return num;
            }
        }
        // 不可能的情况
        return -1;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def repeatedNTimes(self, nums: List[int]) -> int:
        found = set()

        for num in nums:
            if num in found:
                return num
            found.add(num)
        
        # 不可能的情况
        return -1
```

```C [sol1-C]
struct HashItem {
    int key;
    UT_hash_handle hh;
};

void freeHash(struct HashItem **obj) {
    struct HashItem *curr, *tmp;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);        
    }
}

int repeatedNTimes(int* nums, int numsSize){
    struct HashItem *found = NULL;
    for (int i = 0; i < numsSize; i++) {
        struct HashItem *pEntry = NULL;
        HASH_FIND_INT(found, &nums[i], pEntry);
        if (pEntry != NULL) {
            freeHash(&found);
            return nums[i];
        } else {
            pEntry = (struct HashItem *)malloc(sizeof(struct HashItem));
            pEntry->key = nums[i];
            HASH_ADD_INT(found, key, pEntry);
        }
    }
    // 不可能的情况
    freeHash(&found);
    return -1;
}
```

```go [sol1-Golang]
func repeatedNTimes(nums []int) int {
    found := map[int]bool{}
    for _, num := range nums {
        if found[num] {
            return num
        }
        found[num] = true
    }
    return -1 // 不可能的情况
}
```

```JavaScript [sol1-JavaScript]
var repeatedNTimes = function(nums) {
    const found = new Set();
    for (const num of nums) {
        if (found.has(num)) {
            return num;
        }
        found.add(num);
    }
    // 不可能的情况
    return -1;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$。我们只需要对数组 $\textit{nums}$ 进行一次遍历。

- 空间复杂度：$O(n)$，即为哈希集合需要使用的空间。

#### 方法二：数学

**思路与算法**

我们可以考虑重复的元素 $x$ 在数组 $\textit{nums}$ 中出现的位置。

如果相邻的 $x$ 之间至少都隔了 $2$ 个位置，那么数组的总长度至少为：

$$
n + 2(n - 1) = 3n - 2
$$

当 $n > 2$ 时，$3n-2 > 2n$，不存在满足要求的数组。因此一定存在两个相邻的 $x$，它们的位置是连续的，或者只隔了 $1$ 个位置。

当 $n = 2$ 时，数组的长度最多为 $2n = 4$，因此最多只能隔 $2$ 个位置。

这样一来，我们只需要遍历所有间隔 $2$ 个位置及以内的下标对，判断对应的元素是否相等即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int repeatedNTimes(vector<int>& nums) {
        int n = nums.size();
        for (int gap = 1; gap <= 3; ++gap) {
            for (int i = 0; i + gap < n; ++i) {
                if (nums[i] == nums[i + gap]) {
                    return nums[i];
                }
            }
        }
        // 不可能的情况
        return -1;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int repeatedNTimes(int[] nums) {
        int n = nums.length;
        for (int gap = 1; gap <= 3; ++gap) {
            for (int i = 0; i + gap < n; ++i) {
                if (nums[i] == nums[i + gap]) {
                    return nums[i];
                }
            }
        }
        // 不可能的情况
        return -1;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int RepeatedNTimes(int[] nums) {
        int n = nums.Length;
        for (int gap = 1; gap <= 3; ++gap) {
            for (int i = 0; i + gap < n; ++i) {
                if (nums[i] == nums[i + gap]) {
                    return nums[i];
                }
            }
        }
        // 不可能的情况
        return -1;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def repeatedNTimes(self, nums: List[int]) -> int:
        n = len(nums)
        for gap in range(1, 4):
            for i in range(n - gap):
                if nums[i] == nums[i + gap]:
                    return nums[i]
        
        # 不可能的情况
        return -1
```

```C [sol2-C]
int repeatedNTimes(int* nums, int numsSize) {
    for (int gap = 1; gap <= 3; ++gap) {
        for (int i = 0; i + gap < numsSize; ++i) {
            if (nums[i] == nums[i + gap]) {
                return nums[i];
            }
        }
    }
    // 不可能的情况
    return -1;
}
```

```go [sol2-Golang]
func repeatedNTimes(nums []int) int {
    for gap := 1; gap <= 3; gap++ {
        for i, num := range nums[:len(nums)-gap] {
            if num == nums[i+gap] {
                return num
            }
        }
    }
    return -1 // 不可能的情况
}
```

```JavaScript [sol2-JavaScript]
var repeatedNTimes = function(nums) {
    const n = nums.length;
    for (let gap = 1; gap <= 3; ++gap) {
        for (let i = 0; i + gap < n; ++i) {
            if (nums[i] === nums[i + gap]) {
                return nums[i];
            }
        }
    }
    // 不可能的情况
    return -1;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$。我们最多对数组进行三次遍历（除了 $n=2$ 之外，最多两次遍历）。

- 空间复杂度：$O(1)$。

#### 方法三：随机选择

**思路与算法**

我们可以每次随机选择两个不同的下标，判断它们对应的元素是否相等即可。如果相等，那么返回任意一个作为答案。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    int repeatedNTimes(vector<int>& nums) {
        int n = nums.size();
        mt19937 gen{random_device{}()};
        uniform_int_distribution<int> dis(0, n - 1);

        while (true) {
            int x = dis(gen), y = dis(gen);
            if (x != y && nums[x] == nums[y]) {
                return nums[x];
            }
        }
    }
};
```

```Java [sol3-Java]
class Solution {
    public int repeatedNTimes(int[] nums) {
        int n = nums.length;
        Random random = new Random();

        while (true) {
            int x = random.nextInt(n), y = random.nextInt(n);
            if (x != y && nums[x] == nums[y]) {
                return nums[x];
            }
        }
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int RepeatedNTimes(int[] nums) {
        int n = nums.Length;
        Random random = new Random();

        while (true) {
            int x = random.Next(n), y = random.Next(n);
            if (x != y && nums[x] == nums[y]) {
                return nums[x];
            }
        }
    }
}
```

```Python [sol3-Python3]
class Solution:
    def repeatedNTimes(self, nums: List[int]) -> int:
        n = len(nums)

        while True:
            x, y = random.randrange(n), random.randrange(n)
            if x != y and nums[x] == nums[y]:
                return nums[x]
```

```C [sol3-C]
int repeatedNTimes(int* nums, int numsSize) {
    srand(time(NULL));
    while (true) {
        int x = random() % numsSize, y = random() % numsSize;
        if (x != y && nums[x] == nums[y]) {
            return nums[x];
        }
    }
}
```

```go [sol3-Golang]
func repeatedNTimes(nums []int) int {
    n := len(nums)
    for {
        x, y := rand.Intn(n), rand.Intn(n)
        if x != y && nums[x] == nums[y] {
            return nums[x]
        }
    }
}
```

```JavaScript [sol3-JavaScript]
var repeatedNTimes = function(nums) {
    const n = nums.length;

    while (true) {
        const x = Math.floor(Math.random() * n), y = Math.floor(Math.random() * n);
        if (x !== y && nums[x] === nums[y]) {
            return nums[x];
        }
    }
};
```

**复杂度分析**

- 时间复杂度：期望 $O(1)$。选择两个相同元素的概率为 $\dfrac{n}{2n} \times \dfrac{n-1}{2n} \approx \dfrac{1}{4}$，因此期望 $4$ 次结束循环。

- 空间复杂度：$O(1)$。