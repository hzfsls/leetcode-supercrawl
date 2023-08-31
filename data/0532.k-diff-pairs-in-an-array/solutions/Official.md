## [532.数组中的 k-diff 数对 中文官方题解](https://leetcode.cn/problems/k-diff-pairs-in-an-array/solutions/100000/shu-zu-zhong-de-k-diff-shu-dui-by-leetco-ane6)

#### 方法一：哈希表

**思路**

遍历数组，找出符合条件的数对。因为是寻找不同的数对，所以可以将数对放入哈希表 $\textit{res}$，完成去重的效果，最后返回哈希表的长度即可。遍历数组时，可以将遍历到的下标当作潜在的 $j$，判断 $j$ 左侧是否有满足条件的 $i$ 来构成 **k-diff** 数对，而这一判断也可以通过提前将下标 $j$ 左侧的元素都放入另一个哈希表 $\textit{visited}$ 来降低时间复杂度。如果可以构成，则将数对放入哈希表 $\textit{res}$。

代码实现时，由于 $k$ 是定值，知道数对的较小值，也就知道了另一个值，因此我们可以只将数对的较小值放入 $\textit{res}$，而不影响结果的正确性。判断完之后，再将当前元素放入 $\textit{visited}$，作为后续判断潜在的 $\textit{nums}[i]$。

**代码**

```Python [sol1-Python3]
class Solution:
    def findPairs(self, nums: List[int], k: int) -> int:
        visited, res = set(), set()
        for num in nums:
            if num - k in visited:
                res.add(num - k)
            if num + k in visited:
                res.add(num)
            visited.add(num)
        return len(res) 
```

```Java [sol1-Java]
class Solution {
    public int findPairs(int[] nums, int k) {
        Set<Integer> visited = new HashSet<Integer>();
        Set<Integer> res = new HashSet<Integer>();
        for (int num : nums) {
            if (visited.contains(num - k)) {
                res.add(num - k);
            }
            if (visited.contains(num + k)) {
                res.add(num);
            }
            visited.add(num);
        }
        return res.size();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindPairs(int[] nums, int k) {
        ISet<int> visited = new HashSet<int>();
        ISet<int> res = new HashSet<int>();
        foreach (int num in nums) {
            if (visited.Contains(num - k)) {
                res.Add(num - k);
            }
            if (visited.Contains(num + k)) {
                res.Add(num);
            }
            visited.Add(num);
        }
        return res.Count;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int findPairs(vector<int>& nums, int k) {
        unordered_set<int> visited;
        unordered_set<int> res;
        for (int num : nums) {
            if (visited.count(num - k)) {
                res.emplace(num - k);
            }
            if (visited.count(num + k)) {
                res.emplace(num);
            }
            visited.emplace(num);
        }
        return res.size();
    }
};
```

```C [sol1-C]
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem;

int findPairs(int* nums, int numsSize, int k){
    HashItem *visited = NULL, *res = NULL;
    int target = 0;
    for (int i = 0; i < numsSize; i++) {
        HashItem *pEntry = NULL;
        target = nums[i] - k;
        HASH_FIND_INT(visited, &target, pEntry);
        if (pEntry) {
            pEntry = NULL;
            HASH_FIND_INT(res, &target, pEntry); 
            if (NULL == pEntry) {
                pEntry = (HashItem *)malloc(sizeof(HashItem));
                pEntry->key = nums[i] - k;
                HASH_ADD_INT(res, key, pEntry);
            }
        }
        pEntry = NULL;
        target = nums[i] + k;
        HASH_FIND_INT(visited, &target, pEntry);
        if (pEntry) {
            pEntry = NULL;
            target = nums[i];
            HASH_FIND_INT(res, &target, pEntry); 
            if (NULL == pEntry) {
                pEntry = (HashItem *)malloc(sizeof(HashItem));
                pEntry->key = nums[i];
                HASH_ADD_INT(res, key, pEntry);
            }
        }
        pEntry = NULL;
        target = nums[i];
        HASH_FIND_INT(visited, &target, pEntry);
        if (NULL == pEntry) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = nums[i];
            HASH_ADD_INT(visited, key, pEntry);
        }
    }
    return HASH_COUNT(res);
}
```

```go [sol1-Golang]
func findPairs(nums []int, k int) int {
    visited := map[int]struct{}{}
    res := map[int]struct{}{}
    for _, num := range nums {
        if _, ok := visited[num-k]; ok {
            res[num-k] = struct{}{}
        }
        if _, ok := visited[num+k]; ok {
            res[num] = struct{}{}
        }
        visited[num] = struct{}{}
    }
    return len(res)
}
```

```JavaScript [sol1-JavaScript]
var findPairs = function(nums, k) {
    const visited = new Set();
    const res = new Set();
    for (const num of nums) {
        if (visited.has(num - k)) {
            res.add(num - k);
        }
        if (visited.has(num + k)) {
            res.add(num);
        }
        visited.add(num);
    }
    return res.size;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\text{nums}$ 的长度。需要遍历 $\text{nums}$ 一次。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\text{nums}$ 的长度。两个哈希表最多各存放 $n$ 个元素。

#### 方法二：排序 + 双指针

**思路**

题干的两个条件可以这样解读：

- 数对的两个元素的下标值不同。当 $k = 0$ 时，数对的两个元素值可以相同，但下标值必须不同。
- 数对的两个元素差值为 $k$。

这样的解读之下，原来 $i$ 和 $j$ 的大小关系被抹除了，只要求 $i$ 和 $j$ 不相等。而差值为 $k$ 这一要求则可以在排序后使用双指针来满足。

将原数组升序排序，并用新的指针 $x$ 和 $y$ 来搜索数对。即寻找不同的 $(\textit{nums}[x], \textit{nums}[y])$ 满足：
- $x < y$
- $\textit{nums}[x] + k = \textit{nums}[y]$

记录满足要求的 $x$ 的个数并返回。

**代码**

```Python [sol2-Python3]
class Solution:
    def findPairs(self, nums: List[int], k: int) -> int:
        nums.sort()
        n, y, res = len(nums), 0, 0
        for x in range(n):
            if x == 0 or nums[x] != nums[x - 1]:
                while y < n and (nums[y] < nums[x] + k or y <= x):
                    y += 1
                if y < n and nums[y] == nums[x] + k:
                    res += 1
        return res
```

```Java [sol2-Java]
class Solution {
    public int findPairs(int[] nums, int k) {
        Arrays.sort(nums);
        int n = nums.length, y = 0, res = 0;
        for (int x = 0; x < n; x++) {
            if (x == 0 || nums[x] != nums[x - 1]) {
                while (y < n && (nums[y] < nums[x] + k || y <= x)) {
                    y++;
                }
                if (y < n && nums[y] == nums[x] + k) {
                    res++;
                }
            }
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int FindPairs(int[] nums, int k) {
        Array.Sort(nums);
        int n = nums.Length, y = 0, res = 0;
        for (int x = 0; x < n; x++) {
            if (x == 0 || nums[x] != nums[x - 1]) {
                while (y < n && (nums[y] < nums[x] + k || y <= x)) {
                    y++;
                }
                if (y < n && nums[y] == nums[x] + k) {
                    res++;
                }
            }
        }
        return res;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int findPairs(vector<int>& nums, int k) {
        sort(nums.begin(), nums.end());
        int n = nums.size(), y = 0, res = 0;
        for (int x = 0; x < n; x++) {
            if (x == 0 || nums[x] != nums[x - 1]) {
                while (y < n && (nums[y] < nums[x] + k || y <= x)) {
                    y++;
                }
                if (y < n && nums[y] == nums[x] + k) {
                    res++;
                }
            }
        }
        return res;
    }
};
```

```C [sol2-C]
static inline int cmp(const void* pa, const void* pb) {
    return *(int *)pa - *(int *)pb;
}

int findPairs(int* nums, int numsSize, int k){
    qsort(nums, numsSize, sizeof(int), cmp);
    int y = 0, res = 0;
    for (int x = 0; x < numsSize; x++) {
        if (x == 0 || nums[x] != nums[x - 1]) {
            while (y < numsSize && (nums[y] < nums[x] + k || y <= x)) {
                y++;
            }
            if (y < numsSize && nums[y] == nums[x] + k) {
                res++;
            }
        }
    }
    return res;
}
```

```go [sol2-Golang]
func findPairs(nums []int, k int) (ans int) {
    sort.Ints(nums)
    y, n := 0, len(nums)
    for x, num := range nums {
        if x == 0 || num != nums[x-1] {
            for y < n && (nums[y] < num+k || y <= x) {
                y++
            }
            if y < n && nums[y] == num+k {
                ans++
            }
        }
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var findPairs = function(nums, k) {
    nums.sort((a, b) => a - b);
    let n = nums.length, y = 0, res = 0;
    for (let x = 0; x < n; x++) {
        if (x === 0 || nums[x] !== nums[x - 1]) {
            while (y < n && (nums[y] < nums[x] + k || y <= x)) {
                y++;
            }
            if (y < n && nums[y] === nums[x] + k) {
                res++;
            }
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是数组 $\text{nums}$ 的长度。排序需要消耗 $O(n\log n)$ 复杂度，遍历指针 $x$ 消耗 $O(n)$ 复杂度，指针 $y$ 的值最多变化 $O(n)$ 次，总的时间复杂度为 $O(n\log n)$。

- 空间复杂度：$O(\log n)$，其中 $n$ 是数组 $\text{nums}$ 的长度。排序消耗 $O(\log n)$ 复杂度，其余消耗常数空间复杂度，总的空间复杂度为 $O(\log n)$。