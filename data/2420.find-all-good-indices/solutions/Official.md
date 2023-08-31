## [2420.找到所有好下标 中文官方题解](https://leetcode.cn/problems/find-all-good-indices/solutions/100000/zhao-dao-suo-you-hao-xia-biao-by-leetcod-w5ar)
#### 方法一：动态规划

**思路**

下标 $i$ 是好下标需满足：下标 $i$ 前连续 $k$ 个元素都是非递增与下标 $i$ 后连续 $k$ 个元素都是非递减。只需要预先计算出下标 $i$ 前元素连续非递增的个数以及下标 $i$ 后元素连续非递减的个数即可判断下标 $i$ 是否为好下标。对于下标 $j$，设下标 $j$ 及之前元素连续非递增的个数为 $\textit{left}_j$，下标 $j$ 及之后元素连续非递减的个数为 $\textit{right}_j$。当下标 $i$ 同时满足 $\textit{left}_{i - 1} \ge k,\textit{right}_{i + 1} \ge k$ 时，下标 $i$ 为好下标。计算连续非递增和非递减的个数的方法如下：

+ 如果下标 $i$ 的元素小于等于下标 $i-1$ 的元素，假设已知下标 $i-1$ 及之前有 $j$ 个元素连续非递增，则此时满足 $\textit{nums}_{i-1} \le \textit{nums}_{i-2} \cdots \le \textit{nums}_{i-j}$，已知 $\textit{nums}_i \le \textit{nums}_{i-1}$，可推出 $\textit{nums}_{i} \le \textit{nums}_{i-1} \cdots \le \textit{nums}_{i-j}$，则此时 $\textit{left}_i = j + 1 = \textit{left}_{i-1} + 1$；如果下标 $i$ 的元素大于下标 $i-1$ 的元素，则此时 $\textit{left}_i = 1$。

+ 如果下标 $i$ 的元素小于等于下标 $i+1$ 的元素，假设已知下标 $i+1$ 及之后有 $j$ 个元素连续非递减，则此时满足 $\textit{nums}_{i+1} \le \textit{nums}_{i+2} \cdots \le \textit{nums}_{i+j}$，已知 $\textit{nums}_i \le \textit{nums}_{i+1}$，可推出 $\textit{nums}_{i} \le \textit{nums}_{i+1} \cdots \le \textit{nums}_{i+j}$，则此时 $\textit{right}_i = j + 1 = \textit{right}_{i+1} + 1$；如果下标 $i$ 的元素大于下标 $i+1$ 的元素，则此时 $\textit{right}_i = 1$。

依次检测所有的下标，即可得到所有好下标。

**代码**

```Python [sol1-Python3]
class Solution:
    def goodIndices(self, nums: List[int], k: int) -> List[int]:
        n = len(nums)
        left = [1] * n
        right = [1] * n
        for i in range(1, n):
            if nums[i] <= nums[i - 1]:
                left[i] = left[i - 1] + 1
            if nums[n - i - 1] <= nums[n - i]:
                right[n - i - 1] = right[n - i] + 1
        return [i for i in range(k, n - k) if left[i - 1] >= k and right[i + 1] >= k]
```

```Java [sol1-Java]
class Solution {
    public List<Integer> goodIndices(int[] nums, int k) {
        int n = nums.length;
        int[] left = new int[n];
        int[] right = new int[n];
        Arrays.fill(left, 1);
        Arrays.fill(right, 1);
        for (int i = 1; i < n; i++) {
            if (nums[i] <= nums[i - 1]) {
                left[i] = left[i - 1] + 1;
            }
            if (nums[n - i - 1] <= nums[n - i]) {
                right[n - i - 1] = right[n - i] + 1;
            }
        }

        List<Integer> ans = new ArrayList<>();
        for (int i = k; i < n - k; i++) {
            if (left[i - 1] >= k && right[i + 1] >= k) {
                ans.add(i);    
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> goodIndices(vector<int>& nums, int k) {
        int n = nums.size();
        vector<int> left(n, 1);
        vector<int> right(n, 1);
        for (int i = 1; i < n; i++) {
            if (nums[i] <= nums[i - 1]) {
                left[i] = left[i - 1] + 1;
            }
            if (nums[n - i - 1] <= nums[n - i]) {
                right[n - i - 1] = right[n - i] + 1;
            }
        }

        vector<int> ans;
        for (int i = k; i < n - k; i++) {
            if (left[i - 1] >= k && right[i + 1] >= k) {
                ans.emplace_back(i);
            }
        }
        return ans;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public IList<int> GoodIndices(int[] nums, int k) {
        int n = nums.Length;
        int[] left = new int[n];
        int[] right = new int[n];
        Array.Fill(left, 1);
        Array.Fill(right, 1);
        for (int i = 1; i < n; i++) {
            if (nums[i] <= nums[i - 1]) {
                left[i] = left[i - 1] + 1;
            }
            if (nums[n - i - 1] <= nums[n - i]) {
                right[n - i - 1] = right[n - i] + 1;
            }
        }

        IList<int> ans = new List<int>();
        for (int i = k; i < n - k; i++) {
            if (left[i - 1] >= k && right[i + 1] >= k) {
                ans.Add(i);    
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
int* goodIndices(int* nums, int numsSize, int k, int* returnSize) {
    int * left = (int *)malloc(sizeof(int) * numsSize);
    int * right = (int *)malloc(sizeof(int) * numsSize);
    memset(left, 0, sizeof(int) * numsSize);
    memset(right, 0, sizeof(int) * numsSize);
    for (int i = 0; i < numsSize; i++) {
        left[i] = right[i] = 1;
    }
    for (int i = 1; i < numsSize; i++) {
        if (nums[i] <= nums[i - 1]) {
            left[i] = left[i - 1] + 1;
        }
        if (nums[numsSize - i - 1] <= nums[numsSize - i]) {
            right[numsSize - i - 1] = right[numsSize - i] + 1;
        }
    }

    int * ans = (int *)malloc(sizeof(int) * numsSize);
    int pos = 0;
    for (int i = k; i < numsSize - k; i++) {
        if (left[i - 1] >= k && right[i + 1] >= k) {
            ans[pos++] = i;
        }
    }
    free(left);
    free(right);
    *returnSize = pos;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var goodIndices = function(nums, k) {
    const n = nums.length;
    const left = new Array(n).fill(1);
    const right = new Array(n).fill(1);
    for (let i = 1; i < n; i++) {
        if (nums[i] <= nums[i - 1]) {
            left[i] = left[i - 1] + 1;
        }
        if (nums[n - i - 1] <= nums[n - i]) {
            right[n - i - 1] = right[n - i] + 1;
        }
    }

    const ans = [];
    for (let i = k; i < n - k; i++) {
        if (left[i - 1] >= k && right[i + 1] >= k) {
            ans.push(i);    
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func goodIndices(nums []int, k int) (ans []int) {
    n := len(nums)
    left := make([]int, n)
    right := make([]int, n)
    for i := 0; i < n; i++ {
        left[i] = 1
        right[i] = 1
    }
    for i := 1; i < n; i++ {
        if nums[i] <= nums[i-1] {
            left[i] = left[i-1] + 1
        }
        if nums[n-i-1] <= nums[n-i] {
            right[n-i-1] = right[n-i] + 1
        }
    }

    for i := k; i < n-k; i++ {
        if left[i-1] >= k && right[i+1] >= k {
            ans = append(ans, i)
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。需要遍历数组求出下标 $i$ 及之前连续非递增的个数与下标 $i$ 及之后连续非递减的个数，然后再遍历数组检测下标 $i$ 是否为好下标。

- 空间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。需要 $O(n)$ 的空间来存储下标 $i$ 及之前连续非递增的个数与下标 $i$ 及之后连续非递减的个数。