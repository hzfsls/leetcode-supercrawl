## [462.最小操作次数使数组元素相等 II 中文官方题解](https://leetcode.cn/problems/minimum-moves-to-equal-array-elements-ii/solutions/100000/zui-shao-yi-dong-ci-shu-shi-shu-zu-yuan-xt3r2)

#### 方法一：排序

假设数组元素都变成 $x$ 时，所需的移动数最少，那么 $x$ 需要满足什么性质呢？

为了简化讨论，我们先假定数组长度 $n$ 是偶数。我们将数组 $\textit{nums}$ 从小到大进行排序，然后将数组进行首尾配对，从而划分为多个数对，并将这些数对组成区间：
$$[\textit{nums}_0, \textit{nums}_{n-1}], [\textit{nums}_1, \textit{nums}_{n-2}], ...,[\textit{nums}_{\frac{n}{2} - 1}, \textit{nums}_{\frac{n}{2}}]$$

当 $x$ 同时位于以上区间内时，所需的移动数最少，总移动数为 $\sum_{i=0}^{\frac{n}{2} - 1} (\textit{nums}_{n-1-i} - \textit{nums}_i)$。

> 证明：对于某一个区间 $[\textit{nums}_i, \textit{nums}_{n - 1 -i}]$，该区间对应的数对所需要的移动数为 $|\textit{nums}_{n - 1 - i} - x| + |\textit{nums}_i - x| \ge |\textit{nums}_{n - 1 - i} - x - (\textit{nums}_i - x)| = \textit{nums}_{n - 1 - i} - \textit{nums}_i$，当且仅当 $x \in [\textit{nums}_i, \textit{nums}_{n - 1 -i}]$ 时，等号成立。

在上述区间中，后一个区间是前一个区间的子集，因此只要 $x \in [\textit{nums}_{\frac{n}{2} - 1}, \textit{nums}_{\frac{n}{2}}]$，就满足要求。当 $n$ 为奇数时，我们将排序后的数组中间的元素 $\textit{nums}_{\lfloor \frac{n}{2} \rfloor}$ 当成区间 $[\textit{nums}_{\lfloor \frac{n}{2} \rfloor}, \textit{nums}_{\lfloor \frac{n}{2} \rfloor}]$ 看待，则 $x \in [\textit{nums}_{\lfloor \frac{n}{2} \rfloor}, \textit{nums}_{\lfloor \frac{n}{2} \rfloor}]$ 即 $x = \textit{nums}_{\lfloor \frac{n}{2} \rfloor}$时，所需的移动数最少。

综上所述，所有元素都变成 $\textit{nums}_{\lfloor \frac{n}{2} \rfloor}$ 时，所需的移动数最少。

```Python [sol1-Python3]
class Solution:
    def minMoves2(self, nums: List[int]) -> int:
        nums.sort()
        return sum(abs(num - nums[len(nums) // 2]) for num in nums)
```

```C++ [sol1-C++]
class Solution {
public:
    int minMoves2(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        int n = nums.size(), ret = 0, x = nums[n / 2];
        for (int i = 0; i < n; i++) {
            ret += abs(nums[i] - x);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minMoves2(int[] nums) {
        Arrays.sort(nums);
        int n = nums.length, ret = 0, x = nums[n / 2];
        for (int i = 0; i < n; i++) {
            ret += Math.abs(nums[i] - x);
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinMoves2(int[] nums) {
        Array.Sort(nums);
        int n = nums.Length, ret = 0, x = nums[n / 2];
        for (int i = 0; i < n; i++) {
            ret += Math.Abs(nums[i] - x);
        }
        return ret;
    }
}
```

```C [sol1-C]
int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int minMoves2(int* nums, int numsSize){
    qsort(nums, numsSize, sizeof(int), cmp);
    int ret = 0, x = nums[numsSize / 2];
    for (int i = 0; i < numsSize; i++) {
        ret += abs(nums[i] - x);
    }
    return ret;
}
```

```go [sol1-Golang]
func minMoves2(nums []int) (ans int) {
    sort.Ints(nums)
    x := nums[len(nums)/2]
    for _, num := range nums {
        ans += abs(num - x)
    }
    return
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```JavaScript [sol1-JavaScript]
var minMoves2 = function(nums) {
    nums.sort((a, b) => a - b);
    let n = nums.length, ret = 0, x = nums[Math.floor(n / 2)];
    for (let i = 0; i < n; i++) {
        ret += Math.abs(nums[i] - x);
    }
    return ret;
};
```

**复杂度分析**

+ 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。排序需要 $O(n \log n)$ 的时间。

+ 空间复杂度：$O(\log n)$。排序需要 $O(\log n)$ 的递归栈空间。

#### 方法二：快速选择

根据方法一的推导，$x$ 取数组 $\textit{nums}$ 第 $\lfloor \frac{n}{2} \rfloor$ 小元素（从 $0$ 开始计数）时，所需要的移动数最少。

求解数组第 $k$ 小元素可以使用快速选择算法，具体算法推导可以参考「[215. 数组中的第K个最大元素](https://leetcode.cn/problems/kth-largest-element-in-an-array/solution/shu-zu-zhong-de-di-kge-zui-da-yuan-su-by-leetcode-/)」。

```Python [sol2-Python3]
class Helper:
    @staticmethod
    def partition(nums: List[int], l: int, r: int) -> int:
        pivot = nums[r]
        i = l - 1
        for j in range(l, r):
            if nums[j] <= pivot:
                i += 1
                nums[i], nums[j] = nums[j], nums[i]
        nums[i + 1], nums[r] = nums[r], nums[i + 1]
        return i + 1

    @staticmethod
    def randomPartition(nums: List[int], l: int, r: int) -> int:
        i = randint(l, r)
        nums[r], nums[i] = nums[i], nums[r]
        return Helper.partition(nums, l, r)

    @staticmethod
    def quickSelected(nums: List[int], l: int, r: int, k: int) -> int:
        index = Helper.randomPartition(nums, l, r)
        if k == index:
            return nums[k]
        if k < index:
            return Helper.quickSelected(nums, l, index - 1, k)
        return Helper.quickSelected(nums, index + 1, r, k)

class Solution:
    def minMoves2(self, nums: List[int]) -> int:
        seed(time())
        x = Helper.quickSelected(nums, 0, len(nums) - 1, len(nums) // 2)
        return sum(abs(num - x) for num in nums)
```

```C++ [sol2-C++]
class Solution {
public:
    int quickSelect(vector<int>& nums, int left, int right, int index) {
        int q = randomPartition(nums, left, right);
        if (q == index) {
            return nums[q];
        } else {
            return q < index ? quickSelect(nums, q + 1, right, index) : quickSelect(nums, left, q - 1, index);
        }
    }

    inline int randomPartition(vector<int>& nums, int left, int right) {
        int i = rand() % (right - left + 1) + left;
        swap(nums[i], nums[right]);
        return partition(nums, left, right);
    }

    inline int partition(vector<int>& nums, int left, int right) {
        int x = nums[right], i = left - 1;
        for (int j = left; j < right; ++j) {
            if (nums[j] <= x) {
                swap(nums[++i], nums[j]);
            }
        }
        swap(nums[i + 1], nums[right]);
        return i + 1;
    }

    int minMoves2(vector<int>& nums) {
        srand(time(0));
        int n = nums.size(), x = quickSelect(nums, 0, n - 1, n / 2), ret = 0;
        for (int i = 0; i < n; ++i) {
            ret += abs(nums[i] - x);
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    Random random = new Random();

    public int minMoves2(int[] nums) {
        int n = nums.length, x = quickSelect(nums, 0, n - 1, n / 2), ret = 0;
        for (int i = 0; i < n; ++i) {
            ret += Math.abs(nums[i] - x);
        }
        return ret;
    }

    public int quickSelect(int[] nums, int left, int right, int index) {
        int q = randomPartition(nums, left, right);
        if (q == index) {
            return nums[q];
        } else {
            return q < index ? quickSelect(nums, q + 1, right, index) : quickSelect(nums, left, q - 1, index);
        }
    }

    public int randomPartition(int[] nums, int left, int right) {
        int i = random.nextInt(right - left + 1) + left;
        swap(nums, i, right);
        return partition(nums, left, right);
    }

    public int partition(int[] nums, int left, int right) {
        int x = nums[right], i = left - 1;
        for (int j = left; j < right; ++j) {
            if (nums[j] <= x) {
                ++i;
                swap(nums, i, j);
            }
        }
        swap(nums, i + 1, right);
        return i + 1;
    }

    public void swap(int[] nums, int index1, int index2) {
        int temp = nums[index1];
        nums[index1] = nums[index2];
        nums[index2] = temp;
    }
}
```

```C# [sol2-C#]
public class Solution {
    Random random = new Random();

    public int MinMoves2(int[] nums) {
        int n = nums.Length, x = QuickSelect(nums, 0, n - 1, n / 2), ret = 0;
        for (int i = 0; i < n; ++i) {
            ret += Math.Abs(nums[i] - x);
        }
        return ret;
    }

    public int QuickSelect(int[] nums, int left, int right, int index) {
        int q = RandomPartition(nums, left, right);
        if (q == index) {
            return nums[q];
        } else {
            return q < index ? QuickSelect(nums, q + 1, right, index) : QuickSelect(nums, left, q - 1, index);
        }
    }

    public int RandomPartition(int[] nums, int left, int right) {
        int i = random.Next(right - left + 1) + left;
        Swap(nums, i, right);
        return partition(nums, left, right);
    }

    public int partition(int[] nums, int left, int right) {
        int x = nums[right], i = left - 1;
        for (int j = left; j < right; ++j) {
            if (nums[j] <= x) {
                ++i;
                Swap(nums, i, j);
            }
        }
        Swap(nums, i + 1, right);
        return i + 1;
    }

    public void Swap(int[] nums, int index1, int index2) {
        int temp = nums[index1];
        nums[index1] = nums[index2];
        nums[index2] = temp;
    }
}
```

```C [sol2-C]
static inline void swap(int *a, int *b) {
    int c = *a;
    *a = *b;
    *b = c;
}

static inline int partition(int *nums, int left, int right) {
    int x = nums[right], i = left - 1;
    for (int j = left; j < right; ++j) {
        if (nums[j] <= x) {
            swap(&nums[++i], &nums[j]);
        }
    }
    swap(&nums[i + 1], &nums[right]);
    return i + 1;
}

static inline int randomPartition(int *nums, int left, int right) {
    int i = rand() % (right - left + 1) + left;
    swap(&nums[i], &nums[right]);
    return partition(nums, left, right);
}

static int quickSelect(int *nums, int left, int right, int index) {
    int q = randomPartition(nums, left, right);
    if (q == index) {
        return nums[q];
    } else {
        return q < index ? quickSelect(nums, q + 1, right, index) : quickSelect(nums, left, q - 1, index);
    }
}

int minMoves2(int* nums, int numsSize){
    srand(time(0));
    int n = numsSize, x = quickSelect(nums, 0, n - 1, n / 2), ret = 0;
    for (int i = 0; i < n; ++i) {
        ret += abs(nums[i] - x);
    }
    return ret;
}
```

```go [sol2-Golang]
func partition(a []int, l, r int) int {
    x := a[r]
    i := l - 1
    for j := l; j < r; j++ {
        if a[j] <= x {
            i++
            a[i], a[j] = a[j], a[i]
        }
    }
    a[i+1], a[r] = a[r], a[i+1]
    return i + 1
}

func randomPartition(a []int, l, r int) int {
    i := rand.Intn(r-l+1) + l
    a[i], a[r] = a[r], a[i]
    return partition(a, l, r)
}

func quickSelect(a []int, l, r, index int) int {
    q := randomPartition(a, l, r)
    if q == index {
        return a[q]
    }
    if q < index {
        return quickSelect(a, q+1, r, index)
    }
    return quickSelect(a, l, q-1, index)
}

func minMoves2(nums []int) (ans int) {
    rand.Seed(time.Now().UnixNano())
    x := quickSelect(nums, 0, len(nums)-1, len(nums)/2)
    for _, num := range nums {
        ans += abs(num - x)
    }
    return
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```JavaScript [sol2-JavaScript]
var minMoves2 = function(nums) {
    let n = nums.length, x = quickSelect(nums, 0, n - 1, Math.floor(n / 2)), ret = 0;
    for (let i = 0; i < n; ++i) {
        ret += Math.abs(nums[i] - x);
    }
    return ret;
}

const quickSelect = (nums, left, right, index) => {
    const q = randomPartition(nums, left, right);
    if (q === index) {
        return nums[q];
    } else {
        return q < index ? quickSelect(nums, q + 1, right, index) : quickSelect(nums, left, q - 1, index);
    }
}

const randomPartition = (nums, left, right) => {
    const i = Math.floor(Math.random() * (right - left + 1)) + left;
    swap(nums, i, right);
    return partition(nums, left, right);
}

const partition = (nums, left, right) => {
    let x = nums[right], i = left - 1;
    for (let j = left; j < right; ++j) {
        if (nums[j] <= x) {
            ++i;
            swap(nums, i, j);
        }
    }
    swap(nums, i + 1, right);
    return i + 1;
}

const swap = (nums, index1, index2) => {
    const temp = nums[index1];
    nums[index1] = nums[index2];
    nums[index2] = temp;
}
```


**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。快速选择算法的平均时间复杂度为 $O(n)$。

+ 空间复杂度：$O(\log n)$。递归栈的平均占用空间为 $O(\log n)$。