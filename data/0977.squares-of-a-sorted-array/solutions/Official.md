## [977.有序数组的平方 中文官方题解](https://leetcode.cn/problems/squares-of-a-sorted-array/solutions/100000/you-xu-shu-zu-de-ping-fang-by-leetcode-solution)
#### 方法一：直接排序

**思路与算法**

最简单的方法就是将数组 $\textit{nums}$ 中的数平方后直接排序。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> sortedSquares(vector<int>& nums) {
        vector<int> ans;
        for (int num: nums) {
            ans.push_back(num * num);
        }
        sort(ans.begin(), ans.end());
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] sortedSquares(int[] nums) {
        int[] ans = new int[nums.length];
        for (int i = 0; i < nums.length; ++i) {
            ans[i] = nums[i] * nums[i];
        }
        Arrays.sort(ans);
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def sortedSquares(self, nums: List[int]) -> List[int]:
        return sorted(num * num for num in nums)
```

```Golang [sol1-Golang]
func sortedSquares(nums []int) []int {
    ans := make([]int, len(nums))
    for i, v := range nums {
        ans[i] = v * v
    }
    sort.Ints(ans)
    return ans
}
```

```C [sol1-C]
int cmp(const void* _a, const void* _b) {
    int a = *(int*)_a, b = *(int*)_b;
    return a - b;
}

int* sortedSquares(int* nums, int numsSize, int* returnSize) {
    (*returnSize) = numsSize;
    int* ans = malloc(sizeof(int) * numsSize);
    for (int i = 0; i < numsSize; ++i) {
        ans[i] = nums[i] * nums[i];
    }
    qsort(ans, numsSize, sizeof(int), cmp);
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(\log n)$。除了存储答案的数组以外，我们需要 $O(\log n)$ 的栈空间进行排序。

#### 方法二：双指针

**思路与算法**

方法一没有利用「数组 $\textit{nums}$ 已经按照升序排序」这个条件。显然，如果数组 $\textit{nums}$ 中的所有数都是非负数，那么将每个数平方后，数组仍然保持升序；如果数组 $\textit{nums}$ 中的所有数都是负数，那么将每个数平方后，数组会保持降序。

这样一来，如果我们能够找到数组 $\textit{nums}$ 中负数与非负数的分界线，那么就可以用类似「归并排序」的方法了。具体地，我们设 $\textit{neg}$ 为数组 $\textit{nums}$ 中负数与非负数的分界线，也就是说，$\textit{nums}[0]$ 到 $\textit{nums}[\textit{neg}]$ 均为负数，而 $\textit{nums}[\textit{neg}+1]$ 到 $\textit{nums}[n-1]$ 均为非负数。当我们将数组 $\textit{nums}$ 中的数平方后，那么 $\textit{nums}[0]$ 到 $\textit{nums}[\textit{neg}]$ 单调递减，$\textit{nums}[\textit{neg}+1]$ 到 $\textit{nums}[n-1]$ 单调递增。

由于我们得到了两个已经有序的子数组，因此就可以使用归并的方法进行排序了。具体地，使用两个指针分别指向位置 $\textit{neg}$ 和 $\textit{neg}+1$，每次比较两个指针对应的数，选择较小的那个放入答案并移动指针。当某一指针移至边界时，将另一指针还未遍历到的数依次放入答案。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<int> sortedSquares(vector<int>& nums) {
        int n = nums.size();
        int negative = -1;
        for (int i = 0; i < n; ++i) {
            if (nums[i] < 0) {
                negative = i;
            } else {
                break;
            }
        }

        vector<int> ans;
        int i = negative, j = negative + 1;
        while (i >= 0 || j < n) {
            if (i < 0) {
                ans.push_back(nums[j] * nums[j]);
                ++j;
            }
            else if (j == n) {
                ans.push_back(nums[i] * nums[i]);
                --i;
            }
            else if (nums[i] * nums[i] < nums[j] * nums[j]) {
                ans.push_back(nums[i] * nums[i]);
                --i;
            }
            else {
                ans.push_back(nums[j] * nums[j]);
                ++j;
            }
        }

        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] sortedSquares(int[] nums) {
        int n = nums.length;
        int negative = -1;
        for (int i = 0; i < n; ++i) {
            if (nums[i] < 0) {
                negative = i;
            } else {
                break;
            }
        }

        int[] ans = new int[n];
        int index = 0, i = negative, j = negative + 1;
        while (i >= 0 || j < n) {
            if (i < 0) {
                ans[index] = nums[j] * nums[j];
                ++j;
            } else if (j == n) {
                ans[index] = nums[i] * nums[i];
                --i;
            } else if (nums[i] * nums[i] < nums[j] * nums[j]) {
                ans[index] = nums[i] * nums[i];
                --i;
            } else {
                ans[index] = nums[j] * nums[j];
                ++j;
            }
            ++index;
        }

        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def sortedSquares(self, nums: List[int]) -> List[int]:
        n = len(nums)
        negative = -1
        for i, num in enumerate(nums):
            if num < 0:
                negative = i
            else:
                break

        ans = list()
        i, j = negative, negative + 1
        while i >= 0 or j < n:
            if i < 0:
                ans.append(nums[j] * nums[j])
                j += 1
            elif j == n:
                ans.append(nums[i] * nums[i])
                i -= 1
            elif nums[i] * nums[i] < nums[j] * nums[j]:
                ans.append(nums[i] * nums[i])
                i -= 1
            else:
                ans.append(nums[j] * nums[j])
                j += 1

        return ans
```

```Golang [sol2-Golang]
func sortedSquares(nums []int) []int {
    n := len(nums)
    lastNegIndex := -1
    for i := 0; i < n && nums[i] < 0; i++ {
        lastNegIndex = i
    }

    ans := make([]int, 0, n)
    for i, j := lastNegIndex, lastNegIndex+1; i >= 0 || j < n; {
        if i < 0 {
            ans = append(ans, nums[j]*nums[j])
            j++
        } else if j == n {
            ans = append(ans, nums[i]*nums[i])
            i--
        } else if nums[i]*nums[i] < nums[j]*nums[j] {
            ans = append(ans, nums[i]*nums[i])
            i--
        } else {
            ans = append(ans, nums[j]*nums[j])
            j++
        }
    }

    return ans
}
```

```C [sol2-C]
int* sortedSquares(int* nums, int numsSize, int* returnSize) {
    int negative = -1;
    for (int i = 0; i < numsSize; ++i) {
        if (nums[i] < 0) {
            negative = i;
        } else {
            break;
        }
    }

    int* ans = malloc(sizeof(int) * numsSize);
    *returnSize = 0;
    int i = negative, j = negative + 1;
    while (i >= 0 || j < numsSize) {
        if (i < 0) {
            ans[(*returnSize)++] = nums[j] * nums[j];
            ++j;
        } else if (j == numsSize) {
            ans[(*returnSize)++] = nums[i] * nums[i];
            --i;
        } else if (nums[i] * nums[i] < nums[j] * nums[j]) {
            ans[(*returnSize)++] = nums[i] * nums[i];
            --i;
        } else {
            ans[(*returnSize)++] = nums[j] * nums[j];
            ++j;
        }
    }

    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。除了存储答案的数组以外，我们只需要维护常量空间。

#### 方法三：双指针

**思路与算法**

同样地，我们可以使用两个指针分别指向位置 $0$ 和 $n-1$，每次比较两个指针对应的数，选择较大的那个**逆序**放入答案并移动指针。这种方法无需处理某一指针移动至边界的情况，读者可以仔细思考其精髓所在。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    vector<int> sortedSquares(vector<int>& nums) {
        int n = nums.size();
        vector<int> ans(n);
        for (int i = 0, j = n - 1, pos = n - 1; i <= j;) {
            if (nums[i] * nums[i] > nums[j] * nums[j]) {
                ans[pos] = nums[i] * nums[i];
                ++i;
            }
            else {
                ans[pos] = nums[j] * nums[j];
                --j;
            }
            --pos;
        }
        return ans;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int[] sortedSquares(int[] nums) {
        int n = nums.length;
        int[] ans = new int[n];
        for (int i = 0, j = n - 1, pos = n - 1; i <= j;) {
            if (nums[i] * nums[i] > nums[j] * nums[j]) {
                ans[pos] = nums[i] * nums[i];
                ++i;
            } else {
                ans[pos] = nums[j] * nums[j];
                --j;
            }
            --pos;
        }
        return ans;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def sortedSquares(self, nums: List[int]) -> List[int]:
        n = len(nums)
        ans = [0] * n
        
        i, j, pos = 0, n - 1, n - 1
        while i <= j:
            if nums[i] * nums[i] > nums[j] * nums[j]:
                ans[pos] = nums[i] * nums[i]
                i += 1
            else:
                ans[pos] = nums[j] * nums[j]
                j -= 1
            pos -= 1
        
        return ans
```

```Golang [sol3-Golang]
func sortedSquares(nums []int) []int {
    n := len(nums)
    ans := make([]int, n)
    i, j := 0, n-1
    for pos := n - 1; pos >= 0; pos-- {
        if v, w := nums[i]*nums[i], nums[j]*nums[j]; v > w {
            ans[pos] = v
            i++
        } else {
            ans[pos] = w
            j--
        }
    }
    return ans
}
```

```C [sol3-C]
int* sortedSquares(int* nums, int numsSize, int* returnSize) {
    int* ans = malloc(sizeof(int) * numsSize);
    *returnSize = numsSize;
    for (int i = 0, j = numsSize - 1, pos = numsSize - 1; i <= j;) {
        if (nums[i] * nums[i] > nums[j] * nums[j]) {
            ans[pos] = nums[i] * nums[i];
            ++i;
        } else {
            ans[pos] = nums[j] * nums[j];
            --j;
        }
        --pos;
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。除了存储答案的数组以外，我们只需要维护常量空间。