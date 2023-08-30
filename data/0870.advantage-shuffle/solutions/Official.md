#### 方法一：贪心算法

**思路与算法**

我们首先分别将数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 进行排序，随后只需要不断考虑这两个数组的首个元素：

- 如果 $\textit{nums}_1$ 的首个元素大于 $\textit{nums}_2$ 的首个元素，那么就将它们在答案中对应起来，同时从数组中移除这两个元素，并增加一点「优势」；

- 如果 $\textit{nums}_1$ 的首个元素小于等于 $\textit{nums}_2$ 的首个元素，那么移除 $\textit{nums}_1$ 的首个元素。

当 $\textit{nums}_1$ 中没有元素时，遍历结束。

这样做的正确性在于：

- 对于第一种情况，由于 $\textit{nums}_1$ 是有序的，那么 $\textit{nums}_1$ 的任意元素大于 $\textit{nums}_2$ 的首个元素：

    - 如果我们不与 $\textit{nums}_2$ 的首个元素配对，由于 $\textit{nums}_2$ 是有序的，之后的元素会更大，这样并不划算；
    
    - 如果我们与 $\textit{nums}_2$ 的首个元素配对，我们使用 $\textit{nums}_1$ 的首个元素，可以使得剩余的元素尽可能大，之后可以获得更多「优势」。

- 对于第二种情况，由于 $\textit{nums}_2$ 是有序的，那么 $\textit{nums}_1$ 的首个元素小于等于 $\textit{nums}_2$ 中的任意元素，因此 $\textit{nums}_1$ 的首个元素无法增加任何「优势」，可以直接移除。

在本题中，由于 $\textit{nums}_1$ 中的每一个元素都要与 $\textit{nums}_2$ 中的元素配对，而我们是按照顺序考虑 $\textit{nums}_2$ 中的元素的。因此在遍历结束后，$\textit{nums}_2$ 中剩余的元素实际上是原先 $\textit{nums}_2$ 的一个后缀。因此当 $\textit{nums}_1$ 的首个元素无法配对时，我们给它配对一个 $\textit{nums}_2$ 的尾元素即可，并将该尾元素移除。

在实际的代码编写中，我们无需真正地「移除」元素。对于 $\textit{nums}_1$，我们使用一个循环依次遍历其中的每个元素；对于 $\textit{nums}_2$，我们可以使用双指针 $\textit{left}$ 和 $\textit{right}$。如果 $\textit{nums}_1$ 的首个元素可以增加「优势」，就配对 $\textit{left}$ 对应的元素并向右移动一个位置；如果无法配对，就配对 $\textit{right}$ 对应的元素并向左移动一个位置。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> advantageCount(vector<int>& nums1, vector<int>& nums2) {
        int n = nums1.size();
        vector<int> idx1(n), idx2(n);
        iota(idx1.begin(), idx1.end(), 0);
        iota(idx2.begin(), idx2.end(), 0);
        sort(idx1.begin(), idx1.end(), [&](int i, int j) { return nums1[i] < nums1[j]; });
        sort(idx2.begin(), idx2.end(), [&](int i, int j) { return nums2[i] < nums2[j]; });
        
        vector<int> ans(n);
        int left = 0, right = n - 1;
        for (int i = 0; i < n; ++i) {
            if (nums1[idx1[i]] > nums2[idx2[left]]) {
                ans[idx2[left]] = nums1[idx1[i]];
                ++left;
            }
            else {
                ans[idx2[right]] = nums1[idx1[i]];
                --right;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] advantageCount(int[] nums1, int[] nums2) {
        int n = nums1.length;
        Integer[] idx1 = new Integer[n];
        Integer[] idx2 = new Integer[n];
        for (int i = 0; i < n; ++i) {
            idx1[i] = i;
            idx2[i] = i;
        }
        Arrays.sort(idx1, (i, j) -> nums1[i] - nums1[j]);
        Arrays.sort(idx2, (i, j) -> nums2[i] - nums2[j]);

        int[] ans = new int[n];
        int left = 0, right = n - 1;
        for (int i = 0; i < n; ++i) {
            if (nums1[idx1[i]] > nums2[idx2[left]]) {
                ans[idx2[left]] = nums1[idx1[i]];
                ++left;
            } else {
                ans[idx2[right]] = nums1[idx1[i]];
                --right;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] AdvantageCount(int[] nums1, int[] nums2) {
        int n = nums1.Length;
        int[] idx1 = new int[n];
        int[] idx2 = new int[n];
        for (int i = 0; i < n; ++i) {
            idx1[i] = i;
            idx2[i] = i;
        }
        Array.Sort(idx1, (i, j) => nums1[i] - nums1[j]);
        Array.Sort(idx2, (i, j) => nums2[i] - nums2[j]);

        int[] ans = new int[n];
        int left = 0, right = n - 1;
        for (int i = 0; i < n; ++i) {
            if (nums1[idx1[i]] > nums2[idx2[left]]) {
                ans[idx2[left]] = nums1[idx1[i]];
                ++left;
            } else {
                ans[idx2[right]] = nums1[idx1[i]];
                --right;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def advantageCount(self, nums1: List[int], nums2: List[int]) -> List[int]:
        n = len(nums1)
        idx1, idx2 = list(range(n)), list(range(n))
        idx1.sort(key=lambda x: nums1[x])
        idx2.sort(key=lambda x: nums2[x])

        ans = [0] * n
        left, right = 0, n - 1
        for i in range(n):
            if nums1[idx1[i]] > nums2[idx2[left]]:
                ans[idx2[left]] = nums1[idx1[i]]
                left += 1
            else:
                ans[idx2[right]] = nums1[idx1[i]]
                right -= 1
        
        return ans
```

```C [sol1-C]
static int cmp(const void *pa, const void *pb) {
    int *a = (int *)pa;
    int *b = (int *)pb;
    return a[1] - b[1];
}

int* advantageCount(int* nums1, int nums1Size, int* nums2, int nums2Size, int* returnSize) {
    int n = nums1Size;
    int idx1[n][2], idx2[n][2];
    for (int i = 0; i < n; i++) {
        idx1[i][0] = i, idx1[i][1] = nums1[i];
        idx2[i][0] = i, idx2[i][1] = nums2[i];
    }
    qsort(idx1, n, sizeof(idx1[0]), cmp);
    qsort(idx2, n, sizeof(idx2[0]), cmp);
    int *ans = (int *)malloc(sizeof(int) * n);
    int left = 0, right = n - 1;
    for (int i = 0; i < n; ++i) {
        if (nums1[idx1[i][0]] > nums2[idx2[left][0]]) {
            ans[idx2[left][0]] = nums1[idx1[i][0]];
            ++left;
        }
        else {
            ans[idx2[right][0]] = nums1[idx1[i][0]];
            --right;
        }
    }
    *returnSize = n;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var advantageCount = function(nums1, nums2) {
    const n = nums1.length;
    const idx1 = new Array(n).fill(0);
    const idx2 = new Array(n).fill(0);
    for (let i = 0; i < n; ++i) {
        idx1[i] = i;
        idx2[i] = i;
    }
    idx1.sort((i, j) => nums1[i] - nums1[j]);
    idx2.sort((i, j) => nums2[i] - nums2[j]);

    const ans = new Array(n).fill(0);
    let left = 0, right = n - 1;
    for (let i = 0; i < n; ++i) {
        if (nums1[idx1[i]] > nums2[idx2[left]]) {
            ans[idx2[left]] = nums1[idx1[i]];
            ++left;
        } else {
            ans[idx2[right]] = nums1[idx1[i]];
            --right;
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func advantageCount(nums1 []int, nums2 []int) []int {
    n := len(nums1)
    idx1 := make([]int, n)
    idx2 := make([]int, n)
    for i := 1; i < n; i++ {
        idx1[i] = i
        idx2[i] = i
    }
    sort.Slice(idx1, func(i, j int) bool { return nums1[idx1[i]] < nums1[idx1[j]] })
    sort.Slice(idx2, func(i, j int) bool { return nums2[idx2[i]] < nums2[idx2[j]] })

    ans := make([]int, n)
    left, right := 0, n-1
    for i := 0; i < n; i++ {
        if nums1[idx1[i]] > nums2[idx2[left]] {
            ans[idx2[left]] = nums1[idx1[i]]
            left++
        } else {
            ans[idx2[right]] = nums1[idx1[i]]
            right--
        }
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度，即为排序需要的时间。

- 空间复杂度：$O(n)$，即为排序时存储下标需要的空间。