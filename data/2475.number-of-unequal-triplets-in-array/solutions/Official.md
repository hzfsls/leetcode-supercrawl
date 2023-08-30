#### 方法一：枚举

记数组 $\textit{nums}$ 的大小为 $n$，使用三重循环，枚举所有 $0 \le i \lt j \lt k \lt n$ 的三元组，如果三元组 $(i, j, k)$ 满足 $\textit{nums}[i] \ne \textit{nums}[j]$、$\textit{nums}[i] \ne \textit{nums}[k]$ 且 $\textit{nums}[j] \ne \textit{nums}[k]$，那么将结果加 $1$，枚举结束后返回最终结果。

```C++ [sol1-C++]
class Solution {
public:
    int unequalTriplets(vector<int>& nums) {
        int res = 0, n = nums.size();
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                for (int k = j + 1; k < n; k++) {
                    if (nums[i] != nums[j] && nums[i] != nums[k] && nums[j] != nums[k]) {
                        res++;
                    }
                }
            }
        }
        return res;
    }
};
```

```Golang [sol1-Golang]
func unequalTriplets(nums []int) int {
    res, n := 0, len(nums)
    for i := 0; i < n; i++ {
        for j := i + 1; j < n; j++ {
            for k := j + 1; k < n; k++ {
                if nums[i] != nums[j] && nums[i] != nums[k] && nums[j] != nums[k] {
                    res++
                }
            }
        }
    }
    return res
}
```

```C [sol1-C]
int unequalTriplets(int* nums, int numsSize) {
    int res = 0;
    for (int i = 0; i < numsSize; i++) {
        for (int j = i + 1; j < numsSize; j++) {
            for (int k = j + 1; k < numsSize; k++) {
                if (nums[i] != nums[j] && nums[i] != nums[k] && nums[j] != nums[k]) {
                    res++;
                }
            }
        }
    }
    return res;
}
```

```Python [sol1-Python3]
class Solution:
    def unequalTriplets(self, nums: List[int]) -> int:
        res = 0
        n = len(nums)
        for i in range(n):
            for j in range(i + 1, n):
                for k in range(j + 1, n):
                    if nums[i] != nums[j] and nums[i] != nums[k] and nums[j] != nums[k]:
                        res += 1
        return res
```

```Java [sol1-Java]
class Solution {
    public int unequalTriplets(int[] nums) {
        int res = 0, n = nums.length;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                for (int k = j + 1; k < n; k++) {
                    if (nums[i] != nums[j] && nums[i] != nums[k] && nums[j] != nums[k]) {
                        res++;
                    }
                }
            }
        }
        return res;
    }
}
```

```JavaScript [sol1-JavaScript]
var unequalTriplets = function(nums) {
    let res = 0, n = nums.length;
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
            for (let k = j + 1; k < n; k++) {
                if (nums[i] != nums[j] && nums[i] != nums[k] && nums[j] != nums[k]) {
                    res++;
                }
            }
        }
    }
    return res;
};
```

**复杂度分析**

+ 时间复杂度：$O(n^3)$，其中 $n$ 是数组 $\textit{nums}$ 的大小。

+ 空间复杂度：$O(1)$。

#### 方法二：排序

由题意可知，数组元素的相对顺序不影响结果，因此我们可以将数组 $\textit{nums}$ 从小到大进行排序。排序后，数组中的相同元素一定是相邻的。当我们以某一堆相同的数 $[i, j)$ 作为三元组的中间元素时，这堆相同的元素的左边元素数目为 $i$，右边元素数目为 $n - j$，那么符合条件的三元组数目为：

$$i \times (j - i) \times (n - j)$$

对以上结果求和并返回最终结果。

```C++ [sol2-C++]
class Solution {
public:
    int unequalTriplets(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        int res = 0, n = nums.size();
        for (int i = 0, j = 0; i < n; i = j) {
            while (j < n && nums[j] == nums[i]) {
                j++;
            }
            res += i * (j - i) * (n - j);
        }
        return res;
    }
};
```

```Golang [sol2-Golang]
func unequalTriplets(nums []int) int {
    sort.Ints(nums)
    res, n := 0, len(nums)
    for i, j := 0, 0; i < n; i = j {
        for j < n && nums[j] == nums[i] {
            j++
        }
        res += i * (j - i) * (n - j)
    }
    return res
}
```

```C [sol2-C]
static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int unequalTriplets(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int res = 0, n = numsSize;
    for (int i = 0, j = 0; i < n; i = j) {
        while (j < n && nums[j] == nums[i]) {
            j++;
        }
        res += i * (j - i) * (n - j);
    }
    return res;
}
```

```Python [sol2-Python3]
class Solution:
    def unequalTriplets(self, nums: List[int]) -> int:
        nums.sort()
        res = 0
        n = len(nums)
        i = j = 0
        while i < n:
            while j < n and nums[j] == nums[i]:
                j += 1
            res += i * (j - i) * (n - j)
            i = j
        return res
```

```Java [sol2-Java]
class Solution {
    public int unequalTriplets(int[] nums) {
        Arrays.sort(nums);
        int res = 0, n = nums.length;
        for (int i = 0, j = 0; i < n; i = j) {
            while (j < n && nums[j] == nums[i]) {
                j++;
            }
            res += i * (j - i) * (n - j);
        }
        return res;
    }
}
```

```JavaScript [sol2-JavaScript]
var unequalTriplets = function(nums) {
    nums.sort();
    let res = 0, n = nums.length;
    for (let i = 0, j = 0; i < n; i = j) {
        while (j < n && nums[j] == nums[i]) {
            j++;
        }
        res += i * (j - i) * (n - j);
    }
    return res;
};
```

**复杂度分析**

+ 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的大小。主要为排序所需的时间。

+ 空间复杂度：$O(\log n)$。排序所需的栈空间。

#### 方法三：哈希表

类似于方法二，我们可以使用哈希表 $\textit{count}$ 记录各个元素的数目，然后遍历哈希表（此时数组元素按照哈希表的遍历顺序进行排列），记当前遍历的元素数目 $\textit{v}$，先前遍历的元素总数目为 $\textit{t}$，那么以当前遍历的元素为中间元素的符合条件的三元组数目为：

$$t \times v \times (n - t - v)$$

对以上结果求和并返回最终结果。

```C++ [sol3-C++]
class Solution {
public:
    int unequalTriplets(vector<int>& nums) {
        unordered_map<int, int> count;
        for (auto x : nums) {
            count[x]++;
        }
        int res = 0, n = nums.size(), t = 0;
        for (auto [_, v] : count) {
            res += t * v * (n - t - v);
            t += v;
        }
        return res;
    }
};
```

```Golang [sol3-Golang]
func unequalTriplets(nums []int) int {
    count := map[int]int{}
    for _, x := range nums {
        count[x]++
    }
    res, n, t := 0, len(nums), 0
    for _, v := range count {
        res, t = res + t * v * (n - t - v), t + v
    }
    return res
}
```

```C [sol3-C]
int unequalTriplets(int* nums, int numsSize) {
    int count[1001] = {0};
    for (int i = 0; i < numsSize; i++) {
        count[nums[i]]++;
    }
    int res = 0, n = numsSize, t = 0;
    for (int i = 0; i <= 1000; i++) {
        int v = count[i];
        res += t * v * (n - t - v);
        t += v;
    }
    return res;
}
```

```Python [sol3-Python3]
class Solution:
    def unequalTriplets(self, nums: List[int]) -> int:
        count = Counter(nums)
        res = 0
        n = len(nums)
        t = 0
        for _, v in count.items():
            res += t * v * (n - t - v)
            t += v
        return res
```

```Java [sol3-Java]
class Solution {
    public int unequalTriplets(int[] nums) {
        Map<Integer, Integer> count = new HashMap<>();
        for (int x : nums) {
            count.merge(x, 1, Integer::sum);
        }
        int res = 0, n = nums.length, t = 0;
        for (Map.Entry<Integer, Integer> entry : count.entrySet()) {
            res += t * entry.getValue() * (n - t - entry.getValue());
            t += entry.getValue();
        }
        return res;
    }
}
```

```JavaScript [sol3-JavaScript]
var unequalTriplets = function(nums) {
    let count = {}, res = 0, n = nums.length, t = 0;
    for (let x of nums) {
        count[x] = count[x] || 0;
        count[x]++;
    }
    for (let k in count) {
        res += t * count[k] * (n - t - count[k]);
        t += count[k];
    }
    return res;
};
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的大小。

+ 空间复杂度：$O(n)$。保存哈希表所需的空间。