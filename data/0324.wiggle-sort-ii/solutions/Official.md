## [324.摆动排序 II 中文官方题解](https://leetcode.cn/problems/wiggle-sort-ii/solutions/100000/bai-dong-pai-xu-ii-by-leetcode-solution-no0s)

#### 方法一：排序

**思路与算法**

此题为「[280. 摆动排序](https://leetcode.cn/problems/wiggle-sort/)」的扩展题目，不同之处在于本题要求排序后的相邻的元素有严格的大小关系，满足 $\textit{nums}[0] < \textit{nums}[1] > \textit{nums}[2] < \textit{nums}[3] \cdots$。首先想到的解法即为排序，然后找到满足相邻的严格大小的关系。需要观察一下什么样的数组才能满足题目的要求，可以完成最终的摆动排序。假设数组中元素的数目为 $n$，则此时我们可以得到结论数组中相同元素的数目最多不超过  $\left\lfloor \dfrac{n + 1}{2} \right\rfloor$，我们可以用反证法来证明。当相同的元素的数目大于 $\left\lfloor \dfrac{n + 1}{2} \right\rfloor$，此时无论如何摆放都会有相同的元素相邻，必然导致摆动排序无法完成。将数组按照从小到大进行排序后，令 $x = \left\lfloor \dfrac{n + 1}{2} \right\rfloor$，此时根据前面的推论可以推测 $\textit{nums}[i] \neq \textit{nums}[i+x]$，则一定满足 $\textit{nums}[i] < \textit{nums}[i+x]$，因此我们可以得到：

$$
\textit{nums}[0] < \textit{nums}[x],\textit{nums}[1] < \textit{nums}[x+1], \cdots,\textit{nums}[i] < \textit{nums}[i+x]
$$

此时我们可以利用上述关系完成数组的摆动排列。我们分两种情况来讨论：

- 当 $n$ 为偶数时：因为 $\textit{nums}[i] < \textit{nums}[i+x]$，所以一定满足 $\textit{nums}[i] < \textit{nums}[i+x], \textit{nums}[i-1] < \textit{nums}[i+x]$，因此我们将 $\textit{nums}[i+x]$ 插入到 $\textit{nums}[i]$ 与 $\textit{nums}[i-1]$ 之间，比如我们可以按照以下顺序进行插入：

    $$
    \textit{nums}[x], \textit{nums}[0], \textit{nums}[x + 1], \textit{nums}[1],\cdots, \textit{nums}[n-2-x],\textit{nums}[n-1],\textit{nums}[n-1-x]
    $$

    然后将上述序列进行反转：

    $$
    \textit{nums}[n-1-x], \textit{nums}[n-1], \textit{nums}[n-2-x], \cdots, \textit{nums}[1], \textit{nums}[x + 1], \textit{nums}[0], \textit{nums}[x]
    $$

    即可得到合法的摆动排序。比如序列当前序列为 $[0,1,2,3,4,5]$，我们可以得到序列 $[3,0,4,1,5,2]$，然后将其反转即为 $[2,5,1,4,0,3]$。

- 当 $n$ 为奇数时：此时情况稍微复杂一些，此时我们需要证明当满足 $i > 0$ 时，$nums[i] < nums[i+x-1]$。此时我们可以用反证法来证明。假设存在 $i$ 且满足 $i > 0$，且满足 $\textit{nums}[i] = \textit{nums}[i+x-1]$ 时，则此时按照排序的规则可知 $\textit{nums}[i] = \textit{nums}[i+1] = \textit{nums}[i+2] = \cdots = \textit{nums}[i+x-1]$，此时数组中一共有 $x$ 个相同的元素。由于这 $x$ 个元素不能互相相邻，按照摆动排序的规则，这 $x$ 个相同的元素只能放在数组的偶数位的索引中（数组索引以 $0$ 为起始），只能放置在 $0,2,4,\cdots,n-1$ 位置上，否则就会出现相邻元素相等，而此时由于 $\textit{nums}[0]$ 最小，因此它只能放置在偶数位的索引上，而数组中的偶数位的索引最多只有 $x$ 个，这就必然会导致矛盾，$\textit{nums}[0]$ 无法摆放。因此，当满足 $i > 0$ 时，$nums[i] \neq nums[i+x-1]$，也即 $\textit{nums}[i] < \textit{nums}[i+x-1]$。根据上述的结论我们可以得到 $\textit{nums}[i] < \textit{nums}[i+x]，\textit{nums}[i+1] < \textit{nums}[i+x]$。因此我们将 $\textit{nums}[i+x]$ 插入到 $\textit{nums}[i]$ 与 $\textit{nums}[i+1]$ 之间，比如我们可以按照以下顺序进行插入：

    $$
    \textit{nums}[0], \textit{nums}[x], \textit{nums}[1],\cdots, \textit{nums}[n-1-x],\textit{nums}[n-1],\textit{nums}[n-x]
    $$

    比如序列当前序列为 $[0,1,2,3,4]$，我们可以返回序列 $[0,3,1,4,2]$。同理我们将上述序列进行反转后，该序列仍然为符合要求的摆动排序。

按照上述规则返回插入的序列即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def wiggleSort(self, nums: List[int]) -> None:
        n = len(nums)
        arr = sorted(nums)
        x = (n + 1) // 2
        j, k = x - 1, n - 1
        for i in range(0, n, 2):
            nums[i] = arr[j]
            if i + 1 < n:
                nums[i + 1] = arr[k]
            j -= 1
            k -= 1
```

```Java [sol1-Java]
class Solution {
    public void wiggleSort(int[] nums) {
        int[] arr = nums.clone();
        Arrays.sort(arr);
        int n = nums.length;
        int x = (n + 1) / 2;
        for (int i = 0, j = x - 1, k = n - 1; i < n; i += 2, j--, k--) {
            nums[i] = arr[j];
            if (i + 1 < n) {
                nums[i + 1] = arr[k];
            }
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    void wiggleSort(vector<int>& nums) {
        int n = nums.size();
        vector<int> arr = nums;
        sort(arr.begin(), arr.end());
        int x = (n + 1) / 2;
        for (int i = 0, j = x - 1, k = n - 1; i < n; i += 2, j--, k--) {
            nums[i] = arr[j];
            if (i + 1 < n) {
                nums[i + 1] = arr[k];
            }
        }
    }
};
```

```C# [sol1-C#]
public class Solution {
    public void WiggleSort(int[] nums) {
        int n = nums.Length;
        int[] arr = new int[n];
        Array.Copy(nums, arr, n);
        Array.Sort(arr);
        int x = (n + 1) / 2;
        for (int i = 0, j = x - 1, k = n - 1; i < n; i += 2, j--, k--) {
            nums[i] = arr[j];
            if (i + 1 < n) {
                nums[i + 1] = arr[k];
            }
        }
    }
}
```

```C [sol1-C]
static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

void wiggleSort(int* nums, int numsSize) {
    int * arr = (int *)malloc(sizeof(int) * numsSize);
    memcpy(arr, nums, sizeof(int) * numsSize);
    qsort(arr, numsSize, sizeof(int), cmp);
    int x = (numsSize + 1) / 2;
    for (int i = 0, j = x - 1, k = numsSize - 1; i < numsSize; i += 2, j--, k--) {
        nums[i] = arr[j];
        if (i + 1 < numsSize) {
            nums[i + 1] = arr[k];
        }
    }
    free(arr);
}
```

```JavaScript [sol1-JavaScript]
var wiggleSort = function(nums) {
    const arr = nums.slice();
    arr.sort((a, b) => a - b);
    const n = nums.length;
    const x = Math.floor((n + 1) / 2);
    for (let i = 0, j = x - 1, k = n - 1; i < n; i += 2, j--, k--) {
        nums[i] = arr[j];
        if (i + 1 < n) {
            nums[i + 1] = arr[k];
        }
    }
};
```

```go [sol1-Golang]
func wiggleSort(nums []int) {
    n := len(nums)
    arr := append([]int{}, nums...)
    sort.Ints(arr)
    x := (n + 1) / 2
    for i, j, k := 0, x-1, n-1; i < n; i += 2 {
        nums[i] = arr[j]
        if i+1 < n {
            nums[i+1] = arr[k]
        }
        j--
        k--
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 为数组的长度。数组排序的时间复杂度为 $O(n\log n)$，遍历数组的时间复杂度为 $O(n)$，总的时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为数组的长度。需要对原数组进行拷贝一次，需要的空间为 $O(n)$。

#### 方法二：三向切分

**思路与算法**

此解法思考难度较大，需要仔细思考。设数组的长度为 $n$，令 $x = \left\lfloor \dfrac{n + 1}{2} \right\rfloor$， 设数组中间的位置为 $\textit{mid} = x - 1$。据解法一的证明可以知道数组中 $\textit{nums}[\textit{mid}]$ 的个数最多不超过 $x$ 个，此时我们可以利用快速筛选法求出排序后的数组中 $\textit{nums}[\textit{mid}]$，然后我们利用快排的 $\texttt{partition}$ 方法将将原数组分为三部分：严格小于 $\textit{nums}[\textit{mid}]$ 的部分，等于 $\textit{nums}[\textit{mid}]$ 的部分，严格大于 $\textit{nums}[\textit{mid}]$ 的部分。假设划分后的数组如下：

$$
\textit{nums}[0],\cdots, \textit{nums}[i] \cdots, \textit{nums}[\textit{mid}],  \cdots, \textit{nums}[j],\cdots, \textit{nums}[n-1]
$$

其中数组中 $\textit{nums}[0 \cdots i-1]$ 严格小于 $\textit{nums}[\textit{mid}]$，$\textit{nums}[i \cdots j]$ 等于 $\textit{nums}[\textit{mid}]$，$\textit{nums}[j+1 \cdots n-1]$ 严格大于 $\textit{nums}[\textit{mid}]$，此时按照方法一的推论可以知道 $j - i + 1 \le x$。当满足 $0 \le k < i$ 时，$\textit{nums}[k] < \textit{nums}[\textit{mid}]$；当满足 $i \le k \le j$ 时，$\textit{nums}[k] = \textit{nums}[\textit{mid}]$；当满足 $j < k \le n - 1$ 时，$\textit{nums}[\textit{mid}] < \textit{nums}[k]$。此时，我们分为两种情况来讨论：

- 当 $n$ 为偶数时：此时我们还是按照方法一的顺序进行摆放，我们将 $\textit{nums}[i+x]$ 插入到 $\textit{nums}[i-1]$ 与 $\textit{nums}[i]$ 之间，按照以下顺序进行插入：

    $$
    \textit{nums}[\textit{mid} + 1], \textit{nums}[0], \textit{nums}[\textit{mid} + 2], \textit{nums}[1],\cdots, \textit{nums}[\textit{mid}-1],\textit{nums}[n-1],\textit{nums}[\textit{mid}]
    $$

    此时我们只需要证明只需要 $\textit{nums}[k] < \textit{nums}[k+x], \textit{nums}[k-1] < \textit{nums}[k+x]$ 即可，证明如下：

    - 当满足 $k \in [j-x + 1,mid]$ 时，此时 $(k + x) \in [j + 1, n-1]$，根据前面的推论可以知道 $\textit{nums}[k] \le \textit{nums}[\textit{mid}] < \textit{nums}[k+x]$，上述结论成立。

    - 当满足 $k \in [0,j-x]$ 时，此时 $(k + x) \in [x, j]$，此时 $\textit{mid} < (k+x) \le j$，因此 $\textit{nums}[k+x] = \textit{nums}[\textit{mid}]$，假设存在 $k$ 满足 $\textit{nums}[k] = \textit{nums}[k+x]$，则一定满足 $\textit{nums}[k] = \textit{nums}[\textit{mid}]$，则此时可以推出 $\textit{nums}[\textit{mid}]$ 必然出现了 $x+1$ 次，此时与之前的结论矛盾，无法构成摆动排序，因此此时 $\textit{nums}[k] < \textit{nums}[k+x]$ 必然成立。

    综上所述可知，当前序列满足如下大小关系：

    $$
    \textit{nums}[\textit{mid} + 1] > \textit{nums}[0] < \textit{nums}[\textit{mid} + 2] > \textit{nums}[1] \cdots \textit{nums}[\textit{mid}-1] < \textit{nums}[n-1] > \textit{nums}[\textit{mid}]
    $$

    将其反转后即为合法的摆动排序：

    $$
    \textit{nums}[\textit{mid}] < \textit{nums}[n-1] > \textit{nums}[\textit{mid}-1] \cdots \textit{nums}[1] < \textit{nums}[\textit{mid} + 2] > \textit{nums}[0] < \textit{nums}[\textit{mid} + 1]
    $$

- 当 $n$ 为奇数时：我们同样按照方法一进行摆放，将 $\textit{nums}[i+x]$ 插入到 $\textit{nums}[i]$ 与 $\textit{nums}[i+1]$ 之间：

    $$
    \textit{nums}[0], \textit{nums}[\textit{mid} + 1], \textit{nums}[1],\cdots, \textit{nums}[\textit{mid} - 1],\textit{nums}[n-1],\textit{nums}[\textit{mid}]
    $$

    此时只需证明 $\textit{nums}[k] < \textit{nums}[k+x]，\textit{nums}[k+1] < \textit{nums}[k+x]$ 即可，$\textit{nums}[k] < \textit{nums}[k+x]$ 的证明方法与上述相同，此时只需证明 $\textit{nums}[k+1] < \textit{nums}[k+x]$ 即可。

    - 当满足 $k \in [j-x + 1, \textit{mid}-1]$ 时，此时 $(k + x) \in [j + 1, n-1]$，根据前面的推论可以知道 $\textit{nums}[k] \le \textit{nums}[\textit{mid}] < \textit{nums}[k+x]$，而此时 $k + 1 \le \textit{mid}$，此时一定满足 $\textit{nums}[k+1] \le \textit{nums}[\textit{mid}] < \textit{nums}[k+x]$。

    - 当满足 $k \in [0,j-x]$ 时，此时 $(k + x) \in [x, j]$，此时 $\textit{nums}[k+x] = \textit{nums}[\textit{mid}]$，假设存在 $k$ 满足 $nums[k+1] = \textit{nums}[\textit{mid}] = \textit{nums}[k+x]$，则此时可以推出 $\textit{nums}[\textit{mid}]$ 必然出现了 $x$ 次，而此时我们知道 $\textit{nums}[0] < \textit{nums}[\textit{mid}]$ 且 $\textit{nums}[\textit{mid}]$ 只能出现在数组的偶数位上，相同的 $x$ 个元素只能同时放置在偶数位上否则必然会出现相邻元素相等的问题，此时 $\textit{nums}[0]$ 无法成功放置，因此 $\textit{nums}[k+1] < \textit{nums}[k+x]$ 必然成立。

    此时综上可知当前的序列一定满足如下大小关系：

    $$
    \textit{nums}[0] < \textit{nums}[\textit{mid} + 1] > \textit{nums}[1] \cdots \textit{nums}[\textit{mid}-1] < \textit{nums}[n-1] > \textit{nums}[\textit{mid}]
    $$

    将其反转后即为合法的摆动排序：

    $$
    \textit{nums}[\textit{mid}] < \textit{nums}[n-1] > \textit{nums}[\textit{mid}-1] \cdots
    \textit{nums}[1] < \textit{nums}[\textit{mid} + 1] > \textit{nums}[0]
    $$

综上所述，我们将数组进行 $\texttt{partition}$ 操作后，此时数组被分成了三部分，依次为小于 $\textit{nums}[\textit{mid}]$ 的部分，等于 $\textit{nums}[\textit{mid}]$ 的部分，大于 $\textit{nums}[\textit{mid}]$ 的部分。然后按照方法一排序方式进行返回即可。

- 如何找到数组中排序为第 $k$ 小的值需要一些技巧，可以参考「[215. 数组中的第K个最大元素](https://leetcode.cn/problems/kth-largest-element-in-an-array/)」中的快速排序的选择方法，该算法可以在 $O(n)$ 的时间复杂度内完成筛选。

**代码**

```Python [sol2-Python3]
class Helper:
    @staticmethod
    def quickSelect(arr: List, l: int, r: int, index: int) -> int:
        q = Helper.randomPartition(arr, l, r)
        if q == index:
            return arr[q]
        if q < index:
            return Helper.quickSelect(arr, q + 1, r, index)
        return Helper.quickSelect(arr, l, q - 1, index)

    @staticmethod
    def randomPartition(nums: List, l: int, r: int) -> int:
        i = randint(l, r)
        nums[r], nums[i] = nums[i], nums[r]
        return Helper.partition(nums, l, r)

    @staticmethod
    def partition(nums: List, l: int, r: int) -> int:
        pivot = nums[r]
        i = l - 1
        for j in range(l, r):
            if nums[j] < pivot:
                i += 1
                nums[i], nums[j] = nums[j], nums[i]
        nums[i + 1], nums[r] = nums[r], nums[i + 1]
        return i + 1

class Solution:
    def wiggleSort(self, nums: List[int]) -> None:
        n = len(nums)
        x = (n + 1) // 2
        seed(datetime.datetime.now())
        target = Helper.quickSelect(nums, 0, n - 1, x - 1)
        k, i, j = 0, 0, n - 1
        while k <= j:
            if nums[k] > target:
                while j > k and nums[j] > target:
                    j -= 1
                nums[k], nums[j] = nums[j], nums[k]
                j -= 1
            if nums[k] < target:
                nums[k], nums[i] = nums[i], nums[k]
                i += 1
            k += 1
        arr = nums.copy()
        j, k = x - 1, n - 1
        for i in range(0, n, 2):
            nums[i] = arr[j]
            if i + 1 < n:
                nums[i + 1] = arr[k]
            j -= 1
            k -= 1
```

```Java [sol2-Java]
class Solution {
    Random random = new Random();

    public void wiggleSort(int[] nums) {
        int n = nums.length;
        int x = (n + 1) / 2;
        int mid = x - 1;
        int target = findKthLargest(nums, n - mid);
        for (int k = 0, i = 0, j = n - 1; k <= j; k++) {
            if (nums[k] > target) {
                while (j > k && nums[j] > target) {
                    j--;
                }
                swap(nums, k, j--);
            }
            if (nums[k] < target) {
                swap(nums, k, i++);
            }
        }
        int[] arr = nums.clone();
        for (int i = 0, j = x - 1, k = n - 1; i < n; i += 2, j--, k--) {
            nums[i] = arr[j];
            if (i + 1 < n) {
                nums[i + 1] = arr[k];
            }
        }
    }

    public int findKthLargest(int[] nums, int k) {
        return quickSelect(nums, 0, nums.length - 1, nums.length - k);
    }

    public int quickSelect(int[] a, int l, int r, int index) {
        int q = randomPartition(a, l, r);
        if (q == index) {
            return a[q];
        } else {
            return q < index ? quickSelect(a, q + 1, r, index) : quickSelect(a, l, q - 1, index);
        }
    }

    public int randomPartition(int[] a, int l, int r) {
        int i = random.nextInt(r - l + 1) + l;
        swap(a, i, r);
        return partition(a, l, r);
    }

    public int partition(int[] a, int l, int r) {
        int x = a[r], i = l - 1;
        for (int j = l; j < r; ++j) {
            if (a[j] <= x) {
                swap(a, ++i, j);
            }
        }
        swap(a, i + 1, r);
        return i + 1;
    }

    public void swap(int[] a, int i, int j) {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    void wiggleSort(vector<int>& nums) {
        int n = nums.size();
        int x = (n + 1) / 2;
        int mid = x - 1;
        nth_element(nums.begin(), nums.begin() + mid, nums.end());
        for (int k = 0, i = 0, j = n - 1; k <= j; k++) {
            if (nums[k] > nums[mid]) {
                while (j > k && nums[j] > nums[mid]) {
                    j--;
                }
                swap(nums[k], nums[j--]);
            }
            if (nums[k] < nums[mid]) {
                swap(nums[k], nums[i++]);
            }
        }
        vector<int> arr = nums;
        for (int i = 0, j = x - 1, k = n - 1; i < n; i += 2, j--, k--) {
            nums[i] = arr[j];
            if (i + 1 < n) {
                nums[i + 1] = arr[k];
            }
        }
    }
};
```

```C# [sol2-C#]
public class Solution {
    Random random = new Random();

    public void WiggleSort(int[] nums) {
        int n = nums.Length;
        int x = (n + 1) / 2;
        int mid = x - 1;
        int target = FindKthLargest(nums, n - mid);
        for (int k = 0, i = 0, j = n - 1; k <= j; k++) {
            if (nums[k] > target) {
                while (j > k && nums[j] > target) {
                    j--;
                }
                Swap(nums, k, j--);
            }
            if (nums[k] < target) {
                Swap(nums, k, i++);
            }
        }
        int[] arr = new int[n];
        Array.Copy(nums, arr, n);
        for (int i = 0, j = x - 1, k = n - 1; i < n; i += 2, j--, k--) {
            nums[i] = arr[j];
            if (i + 1 < n) {
                nums[i + 1] = arr[k];
            }
        }
    }

    public int FindKthLargest(int[] nums, int k) {
        return QuickSelect(nums, 0, nums.Length - 1, nums.Length - k);
    }

    public int QuickSelect(int[] a, int l, int r, int index) {
        int q = RandomPartition(a, l, r);
        if (q == index) {
            return a[q];
        } else {
            return q < index ? QuickSelect(a, q + 1, r, index) : QuickSelect(a, l, q - 1, index);
        }
    }

    public int RandomPartition(int[] a, int l, int r) {
        int i = random.Next(r - l + 1) + l;
        Swap(a, i, r);
        return Partition(a, l, r);
    }

    public int Partition(int[] a, int l, int r) {
        int x = a[r], i = l - 1;
        for (int j = l; j < r; ++j) {
            if (a[j] <= x) {
                Swap(a, ++i, j);
            }
        }
        Swap(a, i + 1, r);
        return i + 1;
    }

    public void Swap(int[] a, int i, int j) {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
}
```

```C [sol2-C]
static inline void swap(int* a, int* b) {
    int t = *a;
    *a = *b;
    *b = t;
}

static inline int partition(int* a, int l, int r) {
    int x = a[r], i = l - 1;
    for (int j = l; j < r; ++j) {
        if (a[j] <= x) {
            swap(&a[++i], &a[j]);
        }
    }
    swap(&a[i + 1], &a[r]);
    return i + 1;
}

static inline int randomPartition(int* a, int l, int r) {
    int i = rand() % (r - l + 1) + l;
    swap(&a[i], &a[r]);
    return partition(a, l, r);
}

static int quickSelect(int* a, int l, int r, int index) {
    int q = randomPartition(a, l, r);
    if (q == index) {
        return a[q];
    } else {
        return q < index ? quickSelect(a, q + 1, r, index)
                         : quickSelect(a, l, q - 1, index);
    }
}

static int findKthLargest(int* nums, int numsSize, int k) {
    srand(time(0));
    return quickSelect(nums, 0, numsSize - 1, numsSize - k);
}

void wiggleSort(int* nums, int numsSize) {
    int x = (numsSize + 1) / 2;
    int mid = x - 1;
    int target = findKthLargest(nums, numsSize, numsSize - mid);
    for (int k = 0, i = 0, j = numsSize - 1; k <= j; k++) {
        if (nums[k] > target) {
            while (j > k && nums[j] > target) {
                j--;
            }
            swap(&nums[k], &nums[j--]);
        }
        if (nums[k] < target) {
            swap(&nums[k], &nums[i++]);
        }
    }
    int *arr = (int *)malloc(sizeof(int) * numsSize);
    memcpy(arr, nums, sizeof(int) * numsSize);
    for (int i = 0, j = x - 1, k = numsSize - 1; i < numsSize; i += 2, j--, k--) {
        nums[i] = arr[j];
        if (i + 1 < numsSize) {
            nums[i + 1] = arr[k];
        }
    }
    free(arr);
}
```

```go [sol2-Golang]
func wiggleSort(nums []int) {
    n := len(nums)
    x := (n + 1) / 2
    rand.Seed(time.Now().UnixNano())
    target := quickSelect(nums, 0, n-1, x-1)
    for k, i, j := 0, 0, n-1; k <= j; k++ {
        if nums[k] > target {
            for j > k && nums[j] > target {
                j--
            }
            nums[k], nums[j] = nums[j], nums[k]
            j--
        }
        if nums[k] < target {
            nums[k], nums[i] = nums[i], nums[k]
            i++
        }
    }
    arr := append([]int{}, nums...)
    for i, j, k := 0, x-1, n-1; i < n; i += 2 {
        nums[i] = arr[j]
        if i+1 < n {
            nums[i+1] = arr[k]
        }
        j--
        k--
    }
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

func randomPartition(a []int, l, r int) int {
    i := rand.Intn(r-l+1) + l
    a[i], a[r] = a[r], a[i]
    return partition(a, l, r)
}

func partition(a []int, l, r int) int {
    pivot := a[r]
    i := l - 1
    for j := l; j < r; j++ {
        if a[j] < pivot {
            i++
            a[i], a[j] = a[j], a[i]
        }
    }
    a[i+1], a[r] = a[r], a[i+1]
    return i + 1
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。找到数组中排序为 $k$ 的数需要的时间复杂度为 $O(n)$，对数组进行三向切分需要的时间复杂度为 $O(n)$，对数组进行摆放的时间的复杂度为 $O(n)$，总的时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为数组的长度。需要对原数组进行拷贝一次，需要的空间为 $O(n)$。

#### 方法三：索引转换

**思路与算法**

此解法为方法一或者方法二的基础上的优化。假设当前数组进行 $\texttt{partition}$ 后的顺序为：

$$
\textit{nums}[0],\cdots, \textit{nums}[i] \cdots, \textit{nums}[\textit{mid}],  \cdots, \textit{nums}[i],\cdots, \textit{nums}[n-1]
$$

设数组长度 $n$ ，令 $x = \left\lfloor \dfrac{n+1}{2} \right\rfloor$，我们分为两种情况来讨论：

- 当 $n$ 为偶数时，此时我们已知摆动排序后的顺序为：

    $$
    \textit{nums}[\textit{mid}] < \textit{nums}[n-1] > \textit{nums}[\textit{mid}-1] \cdots \textit{nums}[1] < \textit{nums}[\textit{mid} + 2] > \textit{nums}[0] < \textit{nums}[\textit{mid} + 1]
    $$

    我们可以观察到原数组的元素索引 $[0,1,2,\cdots, n-1]$ 在新数组中的索引分别为：

    $$
    n-2, n-4,\cdots,0,n-1,n-3,\cdots,1
    $$

    根据观察我们可以发现，如下转换关系：

    - 当原数组的索引 $i < x$ 时：其在新数组中对应的索引为 $n - 2 \times (i + 1)$。

    - 当 $i \ge x$ 时：其在新数组中对应的索引为 $n - 2 \times (i - x) - 1 = n - 2 \times i + 2 \times x - 1 = n - 2 \times (i + 1) + n + 1$。

    - 我们可以将上述式子进行合并可以得到：对于原数组的第 $i$ 个元素，在新数组中对应的元素索引为 $(n - 2 \times (i + 1) + n + 1) \bmod (n+1) = (2 \times n - 2 \times i - 1) \bmod (n+1)$。

- 当 $n$ 为奇数时，此时我们已知摆动排序后的顺序为：

    $$
    \textit{nums}[\textit{mid}] < \textit{nums}[n-1] > \textit{nums}[\textit{mid}-1] \cdots \textit{nums}[1] < \textit{nums}[\textit{mid} + 1] > \textit{nums}[0]
    $$

    我们可以观察到原数组的元素索引 $[0,1,2,\cdots, n-1]$ 在新数组中的索引分别为：

    $$
    n-1, n-3,\cdots,0,n-2,n-4,\cdots,1
    $$

    根据观察我们可以发现如下转换关系：

    - 当原数组的索引 $i < x$ 时：其在新数组中对应的索引为 $n - 1 - 2 \times i$。

    - 当 $i \ge x$ 时：其在新数组中对应的索引为 $n - 2 \times (i - x) - 2 = n - 2 \times i + 2 \times x - 2 = n - 1 - 2 \times i + n$。

    - 我们可以将上述式子进行合并可以得到：对于原数组的第 $i$ 个元素，在新数组中对应的元素索引为 $(n - 1 - 2 \times i + n) \bmod n = (2 \times n - 2 \times i - 1) \bmod n$。

综上我们可以对上述进行合并，当 $n$ 为偶数时，$(2 \times n - 2 \times i - 1)$ 需要对 $n + 1$ 进行取模，我们可以将索引 $i$ 的转换进行合并为 $(2 \times n - 2 \times i - 1) \bmod (n|1)$，此时我们直接对摆动排序后的数组进行 $\texttt{partition}$ 操作即可，我们按照 $\texttt{partition}$ 后的数组顺序进行遍历，然后依次进行比较交换即可，这样就避免了再次将数组进行拷贝复制。

**代码**

```Python [sol3-Python3]
class Helper:
    @staticmethod
    def quickSelect(arr: List, l: int, r: int, index: int) -> int:
        q = Helper.randomPartition(arr, l, r)
        if q == index:
            return arr[q]
        if q < index:
            return Helper.quickSelect(arr, q + 1, r, index)
        return Helper.quickSelect(arr, l, q - 1, index)

    @staticmethod
    def randomPartition(nums: List, l: int, r: int) -> int:
        i = randint(l, r)
        nums[r], nums[i] = nums[i], nums[r]
        return Helper.partition(nums, l, r)

    @staticmethod
    def partition(nums: List, l: int, r: int) -> int:
        pivot = nums[r]
        i = l - 1
        for j in range(l, r):
            if nums[j] < pivot:
                i += 1
                nums[i], nums[j] = nums[j], nums[i]
        nums[i + 1], nums[r] = nums[r], nums[i + 1]
        return i + 1

class Solution:
    def wiggleSort(self, nums: List[int]) -> None:
        n = len(nums)
        x = (n + 1) // 2
        seed(datetime.datetime.now())
        target = Helper.quickSelect(nums, 0, n - 1, x - 1)

        transAddress = lambda i: (2 * n - 2 * i - 1) % (n | 1)
        k, i, j = 0, 0, n - 1
        while k <= j:
            tk = transAddress(k)
            if nums[tk] > target:
                while j > k and nums[transAddress(j)] > target:
                    j -= 1
                tj = transAddress(j)
                nums[tk], nums[tj] = nums[tj], nums[tk]
                j -= 1
            if nums[tk] < target:
                ti = transAddress(i)
                nums[tk], nums[ti] = nums[ti], nums[tk]
                i += 1
            k += 1
```

```Java [sol3-Java]
class Solution {
    Random random = new Random();

    public void wiggleSort(int[] nums) {
        int n = nums.length;
        int x = (n + 1) / 2;
        int mid = x - 1;
        int target = findKthLargest(nums, n - mid);
        for (int k = 0, i = 0, j = n - 1; k <= j; k++) {
            if (nums[transAddress(k, n)] > target) {
                while (j > k && nums[transAddress(j, n)] > target) {
                    j--;
                }
                swap(nums, transAddress(k, n), transAddress(j--, n));
            }
            if (nums[transAddress(k, n)] < target) {
                swap(nums, transAddress(k, n), transAddress(i++, n));
            }
        }
    }

    public int transAddress(int i, int n) {
        return (2 * n - 2 * i - 1) % (n | 1);
    }

    public int findKthLargest(int[] nums, int k) {
        return quickSelect(nums, 0, nums.length - 1, nums.length - k);
    }

    public int quickSelect(int[] a, int l, int r, int index) {
        int q = randomPartition(a, l, r);
        if (q == index) {
            return a[q];
        } else {
            return q < index ? quickSelect(a, q + 1, r, index) : quickSelect(a, l, q - 1, index);
        }
    }

    public int randomPartition(int[] a, int l, int r) {
        int i = random.nextInt(r - l + 1) + l;
        swap(a, i, r);
        return partition(a, l, r);
    }

    public int partition(int[] a, int l, int r) {
        int x = a[r], i = l - 1;
        for (int j = l; j < r; ++j) {
            if (a[j] <= x) {
                swap(a, ++i, j);
            }
        }
        swap(a, i + 1, r);
        return i + 1;
    }

    public void swap(int[] a, int i, int j) {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    inline int transAddress(int i, int n) {
        return (2 * n - 2 * i - 1) % (n | 1);
    }

    void wiggleSort(vector<int>& nums) {
        int n = nums.size();
        int x = (n + 1) / 2;
        int mid = x - 1;
        nth_element(nums.begin(), nums.begin() + mid, nums.end());
        int target = nums[mid];
        for (int k = 0, i = 0, j = n - 1; k <= j; k++) {
            if (nums[transAddress(k, n)] > target) {
                while (j > k && nums[transAddress(j, n)] > target) {
                    j--;
                }
                swap(nums[transAddress(k, n)], nums[transAddress(j--, n)]);
            }
            if (nums[transAddress(k, n)] < target) {
                swap(nums[transAddress(k, n)], nums[transAddress(i++, n)]);
            }
        }
    }
};
```

```C# [sol3-C#]
public class Solution {
    Random random = new Random();

    public void WiggleSort(int[] nums) {
        int n = nums.Length;
        int x = (n + 1) / 2;
        int mid = x - 1;
        int target = FindKthLargest(nums, n - mid);
        for (int k = 0, i = 0, j = n - 1; k <= j; k++) {
            if (nums[TransAddress(k, n)] > target) {
                while (j > k && nums[TransAddress(j, n)] > target) {
                    j--;
                }
                Swap(nums, TransAddress(k, n), TransAddress(j--, n));
            }
            if (nums[TransAddress(k, n)] < target) {
                Swap(nums, TransAddress(k, n), TransAddress(i++, n));
            }
        }
    }

    public int TransAddress(int i, int n) {
        return (2 * n - 2 * i - 1) % (n | 1);
    }

    public int FindKthLargest(int[] nums, int k) {
        return QuickSelect(nums, 0, nums.Length - 1, nums.Length - k);
    }

    public int QuickSelect(int[] a, int l, int r, int index) {
        int q = randomPartition(a, l, r);
        if (q == index) {
            return a[q];
        } else {
            return q < index ? QuickSelect(a, q + 1, r, index) : QuickSelect(a, l, q - 1, index);
        }
    }

    public int randomPartition(int[] a, int l, int r) {
        int i = random.Next(r - l + 1) + l;
        Swap(a, i, r);
        return Partition(a, l, r);
    }

    public int Partition(int[] a, int l, int r) {
        int x = a[r], i = l - 1;
        for (int j = l; j < r; ++j) {
            if (a[j] <= x) {
                Swap(a, ++i, j);
            }
        }
        Swap(a, i + 1, r);
        return i + 1;
    }

    public void Swap(int[] a, int i, int j) {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
}
```

```C [sol3-C]
static inline void swap(int* a, int* b) {
    int t = *a;
    *a = *b;
    *b = t;
}

static inline int partition(int* a, int l, int r) {
    int x = a[r], i = l - 1;
    for (int j = l; j < r; ++j) {
        if (a[j] <= x) {
            swap(&a[++i], &a[j]);
        }
    }
    swap(&a[i + 1], &a[r]);
    return i + 1;
}

static inline int randomPartition(int* a, int l, int r) {
    int i = rand() % (r - l + 1) + l;
    swap(&a[i], &a[r]);
    return partition(a, l, r);
}

static int quickSelect(int* a, int l, int r, int index) {
    int q = randomPartition(a, l, r);
    if (q == index) {
        return a[q];
    } else {
        return q < index ? quickSelect(a, q + 1, r, index)
                         : quickSelect(a, l, q - 1, index);
    }
}

static int findKthLargest(int* nums, int numsSize, int k) {
    srand(time(0));
    return quickSelect(nums, 0, numsSize - 1, numsSize - k);
}

static inline int transAddress(int i, int n) {
    return (2 * n - 2 * i - 1) % (n | 1);
}

void wiggleSort(int* nums, int numsSize) {
    int x = (numsSize + 1) / 2;
    int mid = x - 1;
    int target = findKthLargest(nums, numsSize, numsSize - mid);
    for (int k = 0, i = 0, j = numsSize - 1; k <= j; k++) {
        if (nums[transAddress(k, numsSize)] > target) {
            while (j > k && nums[transAddress(j, numsSize)] > target) {
                j--;
            }
            swap(&nums[transAddress(k, numsSize)], &nums[transAddress(j--, numsSize)]);
        }
        if (nums[transAddress(k, numsSize)] < target) {
            swap(&nums[transAddress(k, numsSize)], &nums[transAddress(i++, numsSize)]);
        }
    }
}
```

```go [sol3-Golang]
func wiggleSort(nums []int) {
    n := len(nums)
    x := (n + 1) / 2
    rand.Seed(time.Now().UnixNano())
    target := quickSelect(nums, 0, n-1, x-1)

    transAddress := func(i int) int { return (2*n - 2*i - 1) % (n | 1) }
    for k, i, j := 0, 0, n-1; k <= j; k++ {
        tk := transAddress(k)
        if nums[tk] > target {
            for j > k && nums[transAddress(j)] > target {
                j--
            }
            tj := transAddress(j)
            nums[tk], nums[tj] = nums[tj], nums[tk]
            j--
        }
        if nums[tk] < target {
            ti := transAddress(i)
            nums[tk], nums[ti] = nums[ti], nums[tk]
            i++
        }
    }
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

func randomPartition(a []int, l, r int) int {
    i := rand.Intn(r-l+1) + l
    a[i], a[r] = a[r], a[i]
    return partition(a, l, r)
}

func partition(a []int, l, r int) int {
    pivot := a[r]
    i := l - 1
    for j := l; j < r; j++ {
        if a[j] < pivot {
            i++
            a[i], a[j] = a[j], a[i]
        }
    }
    a[i+1], a[r] = a[r], a[i+1]
    return i + 1
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。找到数组中排序为 $k$ 的数需要的时间复杂度为 $O(n)$，对数组进行三向切分需要的时间复杂度为 $O(n)$，总的时间复杂度为 $O(n)$。

- 空间复杂度：$O(\log n)$。查找第 $k$ 大的元素时需要使用递归，此时递归使用栈空间的空间代价的期望为 $O(\log n)$。

#### 方法四：递归优化

**思路与算法**

我们可以在方法三的基础上对查找数组中排序为第 $k$ 大元素的函数进行优化，用非递归实现查找第 $k$ 大的元素，进一步优化空间复杂度。

```Python [sol4-Python3]
def quickSelect(a: List[int], k: int) -> int:
    seed(datetime.datetime.now())
    shuffle(a)
    l, r = 0, len(a) - 1
    while l < r:
        pivot = a[l]
        i, j = l, r + 1
        while True:
            i += 1
            while i < r and a[i] < pivot:
                i += 1
            j -= 1
            while j > l and a[j] > pivot:
                j -= 1
            if i >= j:
                break
            a[i], a[j] = a[j], a[i]
        a[l], a[j] = a[j], pivot
        if j == k:
            break
        if j < k:
            l = j + 1
        else:
            r = j - 1
    return a[k]

class Solution:
    def wiggleSort(self, nums: List[int]) -> None:
        n = len(nums)
        x = (n + 1) // 2
        target = quickSelect(nums, x - 1)

        transAddress = lambda i: (2 * n - 2 * i - 1) % (n | 1)
        k, i, j = 0, 0, n - 1
        while k <= j:
            tk = transAddress(k)
            if nums[tk] > target:
                while j > k and nums[transAddress(j)] > target:
                    j -= 1
                tj = transAddress(j)
                nums[tk], nums[tj] = nums[tj], nums[tk]
                j -= 1
            if nums[tk] < target:
                ti = transAddress(i)
                nums[tk], nums[ti] = nums[ti], nums[tk]
                i += 1
            k += 1
```

```Java [sol4-Java]
class Solution {
    Random random = new Random();

    public void wiggleSort(int[] nums) {
        int n = nums.length;
        int x = (n + 1) / 2;
        int mid = x - 1;
        int target = findKthLargest(nums, n - mid);
        for (int k = 0, i = 0, j = n - 1; k <= j; k++) {
            if (nums[transAddress(k, n)] > target) {
                while (j > k && nums[transAddress(j, n)] > target) {
                    j--;
                }
                swap(nums, transAddress(k, n), transAddress(j--, n));
            }
            if (nums[transAddress(k, n)] < target) {
                swap(nums, transAddress(k, n), transAddress(i++, n));
            }
        }
    }

    public int findKthLargest(int[] nums, int k) {
        int left = 0, right = nums.length - 1;
        while (left <= right) {
            int pivot = random.nextInt(right - left + 1) + left;
            int newPivot = partitionAroundPivot(left, right, pivot, nums);
            if (newPivot == k - 1) {
                return nums[newPivot];
            } else if (newPivot > k - 1) {
                right = newPivot - 1;
            } else { 
                left = newPivot + 1;
            }
        }
        return nums[k - 1];
    }

    public int transAddress(int i, int n) {
        return (2 * n - 2 * i - 1) % (n | 1);
    }

    public int partitionAroundPivot(int left, int right, int pivot, int[] nums) {
        int pivotValue = nums[pivot];
        int newPivot = left;
        swap(nums, pivot, right);
        for (int i = left; i < right; ++i) {
            if (nums[i] > pivotValue) {
                swap(nums, i, newPivot++);
            }
        }
        swap(nums, right, newPivot);
        return newPivot;
    }

    public void swap(int[] a, int i, int j) {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
}
```

```C++ [sol4-C++]
class Solution {
public:
    int partitionAroundPivot(int left, int right, int pivot, vector<int> &nums) {
        int pivotValue = nums[pivot];
        int newPivot = left;
        swap(nums[pivot], nums[right]);
        for (int i = left; i < right; ++i) {
            if (nums[i] > pivotValue) {
                swap(nums[i], nums[newPivot++]);
            }
        }
        swap(nums[right], nums[newPivot]);
        return newPivot;
    }

    int findKthLargest(vector<int> &nums, int k) {
        int left = 0, right = nums.size() - 1;
        default_random_engine gen((random_device())());
        while (left <= right) {
            uniform_int_distribution<int> dis(left, right);
            int pivot = dis(gen);
            int newPivot = partitionAroundPivot(left, right, pivot, nums);
            if (newPivot == k - 1) {
                return nums[newPivot];
            } else if (newPivot > k - 1) {
                right = newPivot - 1;
            } else { 
                left = newPivot + 1;
            }
        }
        return nums[k - 1];
    }

    inline int transAddress(int i, int n) {
        return (2 * n - 2 * i - 1) % (n | 1);
    }

    void wiggleSort(vector<int>& nums) {
        int n = nums.size();
        int x = (n + 1) / 2;
        int mid = x - 1;
        int target = findKthLargest(nums, n - mid);
        for (int k = 0, i = 0, j = n - 1; k <= j; k++) {
            if (nums[transAddress(k, n)] > target) {
                while (j > k && nums[transAddress(j, n)] > target) {
                    j--;
                }
                swap(nums[transAddress(k, n)], nums[transAddress(j--, n)]);
            }
            if (nums[transAddress(k, n)] < target) {
                swap(nums[transAddress(k, n)], nums[transAddress(i++, n)]);
            }
        }
    }
};
```

```C# [sol4-C#]
public class Solution {
    Random random = new Random();

    public void WiggleSort(int[] nums) {
        int n = nums.Length;
        int x = (n + 1) / 2;
        int mid = x - 1;
        int target = FindKthLargest(nums, n - mid);
        for (int k = 0, i = 0, j = n - 1; k <= j; k++) {
            if (nums[TransAddress(k, n)] > target) {
                while (j > k && nums[TransAddress(j, n)] > target) {
                    j--;
                }
                Swap(nums, TransAddress(k, n), TransAddress(j--, n));
            }
            if (nums[TransAddress(k, n)] < target) {
                Swap(nums, TransAddress(k, n), TransAddress(i++, n));
            }
        }
    }

    public int FindKthLargest(int[] nums, int k) {
        int left = 0, right = nums.Length - 1;
        while (left <= right) {
            int pivot = random.Next(right - left + 1) + left;
            int newPivot = PartitionAroundPivot(left, right, pivot, nums);
            if (newPivot == k - 1) {
                return nums[newPivot];
            } else if (newPivot > k - 1) {
                right = newPivot - 1;
            } else { 
                left = newPivot + 1;
            }
        }
        return nums[k - 1];
    }

    public int TransAddress(int i, int n) {
        return (2 * n - 2 * i - 1) % (n | 1);
    }

    public int PartitionAroundPivot(int left, int right, int pivot, int[] nums) {
        int pivotValue = nums[pivot];
        int newPivot = left;
        Swap(nums, pivot, right);
        for (int i = left; i < right; ++i) {
            if (nums[i] > pivotValue) {
                Swap(nums, i, newPivot++);
            }
        }
        Swap(nums, right, newPivot);
        return newPivot;
    }

    public void Swap(int[] a, int i, int j) {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
}
```

```C [sol4-C]
static inline void swap(int *a, int *b) {
    int c = *a;
    *a = *b;
    *b = c;
}

static inline int partitionAroundPivot(int left, int right, int pivot, int *nums) {
    int pivotValue = nums[pivot];
    int newPivot = left;
    swap(&nums[pivot], &nums[right]);
    for (int i = left; i < right; ++i) {
        if (nums[i] > pivotValue) {
            swap(&nums[i], &nums[newPivot++]);
        }
    }
    swap(&nums[right], &nums[newPivot]);
    return newPivot;
}

static int findKthLargest(int* nums, int numsSize, int k) {
    int left = 0, right = numsSize - 1;
    srand(time(0));
    while (left <= right) {
        int pivot = rand() % (right - left + 1) + left;
        int newPivot = partitionAroundPivot(left, right, pivot, nums);
        if (newPivot == k - 1) {
            return nums[newPivot];
        } else if (newPivot > k - 1) {
            right = newPivot - 1;
        } else { 
            left = newPivot + 1;
        }
    }
    return nums[k - 1];
}

static inline int transAddress(int i, int n) {
    return (2 * n - 2 * i - 1) % (n | 1);
}

void wiggleSort(int* nums, int numsSize) {
    int x = (numsSize + 1) / 2;
    int mid = x - 1;
    int target = findKthLargest(nums, numsSize, numsSize - mid);
    for (int k = 0, i = 0, j = numsSize - 1; k <= j; k++) {
        if (nums[transAddress(k, numsSize)] > target) {
            while (j > k && nums[transAddress(j, numsSize)] > target) {
                j--;
            }
            swap(&nums[transAddress(k, numsSize)], &nums[transAddress(j--, numsSize)]);
        }
        if (nums[transAddress(k, numsSize)] < target) {
            swap(&nums[transAddress(k, numsSize)], &nums[transAddress(i++, numsSize)]);
        }
    }
}
```

```go [sol4-Golang]
func wiggleSort(nums []int) {
    n := len(nums)
    x := (n + 1) / 2
    target := quickSelect(nums, x-1)

    transAddress := func(i int) int { return (2*n - 2*i - 1) % (n | 1) }
    for k, i, j := 0, 0, n-1; k <= j; k++ {
        tk := transAddress(k)
        if nums[tk] > target {
            for j > k && nums[transAddress(j)] > target {
                j--
            }
            tj := transAddress(j)
            nums[tk], nums[tj] = nums[tj], nums[tk]
            j--
        }
        if nums[tk] < target {
            ti := transAddress(i)
            nums[tk], nums[ti] = nums[ti], nums[tk]
            i++
        }
    }
}

func quickSelect(a []int, k int) int {
    rand.Seed(time.Now().UnixNano())
    rand.Shuffle(len(a), func(i, j int) { a[i], a[j] = a[j], a[i] })
    for l, r := 0, len(a)-1; l < r; {
        pivot := a[l]
        i, j := l, r+1
        for {
            for i++; i < r && a[i] < pivot; i++ {
            }
            for j--; j > l && a[j] > pivot; j-- {
            }
            if i >= j {
                break
            }
            a[i], a[j] = a[j], a[i]
        }
        a[l], a[j] = a[j], pivot
        if j == k {
            break
        } else if j < k {
            l = j + 1
        } else {
            r = j - 1
        }
    }
    return a[k]
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。找到数组中排序为 $k$ 的数需要的时间复杂度为 $O(n)$，对数组进行三向切分需要的时间复杂度为 $O(n)$，总的时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。