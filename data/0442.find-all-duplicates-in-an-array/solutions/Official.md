#### 方法一：将元素交换到对应的位置

**思路与算法**

由于给定的 $n$ 个数都在 $[1, n]$ 的范围内，如果有数字出现了两次，就意味着 $[1,n]$ 中有数字没有出现过。

因此，我们可以尝试将每一个数放在对应的位置。由于数组的下标范围是 $[0, n-1]$，我们需要将数 $i$ 放在数组中下标为 $i-1$ 的位置：

- 如果 $i$ 恰好出现了一次，那么将 $i$ 放在数组中下标为 $i-1$ 的位置即可；
- 如果 $i$ 出现了两次，那么我们希望其中的一个 $i$ 放在数组下标中为 $i-1$ 的位置，另一个 $i$ 放置在任意「不冲突」的位置 $j$。也就是说，数 $j+1$ 没有在数组中出现过。

这样一来，如果我们按照上述的规则放置每一个数，那么我们只需要对数组进行一次遍历。当遍历到位置 $i$ 时，如果 $\textit{nums}[i]-1 \neq i$，说明 $\textit{nums}[i]$ 出现了两次（另一次出现在位置 $\textit{num}[i] - 1$），我们就可以将 $\textit{num}[i]$ 放入答案。

放置的方法也很直观：我们对数组进行一次遍历。当遍历到位置 $i$ 时，我们知道 $\textit{nums}[i]$ 应该被放在位置 $\textit{nums}[i] - 1$。因此我们交换 $\textit{num}[i]$ 和 $\textit{nums}[\textit{nums}[i] - 1]$ 即可，直到待交换的两个元素相等为止。

**代码**

```Python [sol1-Python3]
class Solution:
    def findDuplicates(self, nums: List[int]) -> List[int]:
        for i in range(len(nums)):
            while nums[i] != nums[nums[i] - 1]:
                nums[nums[i] - 1], nums[i] = nums[i], nums[nums[i] - 1]
        return [num for i, num in enumerate(nums) if num - 1 != i]
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findDuplicates(vector<int>& nums) {
        int n = nums.size();
        for (int i = 0; i < n; ++i) {
            while (nums[i] != nums[nums[i] - 1]) {
                swap(nums[i], nums[nums[i] - 1]);
            }
        }
        vector<int> ans;
        for (int i = 0; i < n; ++i) {
            if (nums[i] - 1 != i) {
                ans.push_back(nums[i]);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> findDuplicates(int[] nums) {
        int n = nums.length;
        for (int i = 0; i < n; ++i) {
            while (nums[i] != nums[nums[i] - 1]) {
                swap(nums, i, nums[i] - 1);
            }
        }
        List<Integer> ans = new ArrayList<Integer>();
        for (int i = 0; i < n; ++i) {
            if (nums[i] - 1 != i) {
                ans.add(nums[i]);
            }
        }
        return ans;
    }

    public void swap(int[] nums, int index1, int index2) {
        int temp = nums[index1];
        nums[index1] = nums[index2];
        nums[index2] = temp;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> FindDuplicates(int[] nums) {
        int n = nums.Length;
        for (int i = 0; i < n; ++i) {
            while (nums[i] != nums[nums[i] - 1]) {
                Swap(nums, i, nums[i] - 1);
            }
        }
        IList<int> ans = new List<int>();
        for (int i = 0; i < n; ++i) {
            if (nums[i] - 1 != i) {
                ans.Add(nums[i]);
            }
        }
        return ans;
    }

    public void Swap(int[] nums, int index1, int index2) {
        int temp = nums[index1];
        nums[index1] = nums[index2];
        nums[index2] = temp;
    }
}
```

```go [sol1-Golang]
func findDuplicates(nums []int) (ans []int) {
    for i := range nums {
        for nums[i] != nums[nums[i]-1] {
            nums[i], nums[nums[i]-1] = nums[nums[i]-1], nums[i]
        }
    }
    for i, num := range nums {
        if num-1 != i {
            ans = append(ans, num)
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var findDuplicates = function(nums) {
    const swap = (nums, index1, index2) => {
        const temp = nums[index1];
        nums[index1] = nums[index2];
        nums[index2] = temp;
    };
    const n = nums.length;
    for (let i = 0; i < n; ++i) {
        while (nums[i] != nums[nums[i] - 1]) {
            swap(nums, i, nums[i] - 1);
        }
    }
    const ans = [];
    for (let i = 0; i < n; ++i) {
        if (nums[i] - 1 !== i) {
            ans.push(nums[i]);
        }
    }
    return ans;
}
```

```C [sol1-C]
int* findDuplicates(int* nums, int numsSize, int* returnSize) {
    for (int i = 0; i < numsSize; ++i) {
        while (nums[i] != nums[nums[i] - 1]) {
            int tmp = nums[i];
            nums[i] = nums[tmp - 1];
            nums[tmp - 1] = tmp;
        }
    }
    int *ans = (int *)malloc(sizeof(int) * numsSize);
    int pos = 0;
    for (int i = 0; i < numsSize; ++i) {
        if (nums[i] - 1 != i) {
            ans[pos++] = nums[i];
        }
    }
    *returnSize = pos;
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。每一次交换操作会使得至少一个元素被交换到对应的正确位置，因此交换的次数为 $O(n)$，总时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。返回值不计入空间复杂度。

#### 方法二：使用正负号作为标记

**思路与算法**

我们也可以给 $\textit{nums}[i]$ 加上「负号」表示数 $i+1$ 已经出现过一次。具体地，我们首先对数组进行一次遍历。当遍历到位置 $i$ 时，我们考虑 $\textit{nums}[\textit{nums}[i] - 1]$ 的正负性：

- 如果 $\textit{nums}[\textit{nums}[i] - 1]$ 是正数，说明 $\textit{nums}[i]$ 还没有出现过，我们将 $\textit{nums}[\textit{nums}[i] - 1]$ 加上负号；

- 如果 $\textit{nums}[\textit{nums}[i] - 1]$ 是负数，说明 $\textit{nums}[i]$ 已经出现过一次，我们将 $\textit{nums}[i]$ 放入答案。

**细节**

由于 $\textit{nums}[i]$ 本身可能已经为负数，因此在将 $\textit{nums}[i]$ 作为下标或者放入答案时，需要取绝对值。

**代码**

```Python [sol2-Python3]
class Solution:
    def findDuplicates(self, nums: List[int]) -> List[int]:
        ans = []
        for x in nums:
            x = abs(x)
            if nums[x - 1] > 0:
                nums[x - 1] = -nums[x - 1]
            else:
                ans.append(x)
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> findDuplicates(vector<int>& nums) {
        int n = nums.size();
        vector<int> ans;
        for (int i = 0; i < n; ++i) {
            int x = abs(nums[i]);
            if (nums[x - 1] > 0) {
                nums[x - 1] = -nums[x - 1];
            }
            else {
                ans.push_back(x);
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> findDuplicates(int[] nums) {
        int n = nums.length;
        List<Integer> ans = new ArrayList<Integer>();
        for (int i = 0; i < n; ++i) {
            int x = Math.abs(nums[i]);
            if (nums[x - 1] > 0) {
                nums[x - 1] = -nums[x - 1];
            } else {
                ans.add(x);
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<int> FindDuplicates(int[] nums) {
        int n = nums.Length;
        IList<int> ans = new List<int>();
        for (int i = 0; i < n; ++i) {
            int x = Math.Abs(nums[i]);
            if (nums[x - 1] > 0) {
                nums[x - 1] = -nums[x - 1];
            } else {
                ans.Add(x);
            }
        }
        return ans;
    }
}
```

```go [sol2-Golang]
func findDuplicates(nums []int) (ans []int) {
    for _, x := range nums {
        if x < 0 {
            x = -x
        }
        if nums[x-1] > 0 {
            nums[x-1] = - nums[x-1]
        } else {
            ans = append(ans, x)
        }
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var findDuplicates = function(nums) {
    const n = nums.length;
    const ans = [];
    for (let i = 0; i < n; ++i) {
        const x = Math.abs(nums[i]);
        if (nums[x - 1] > 0) {
            nums[x - 1] = -nums[x - 1];
        } else {
            ans.push(x);
        }
    }
    return ans;
}
```

```C [sol2-C]
int* findDuplicates(int* nums, int numsSize, int* returnSize) {    
    int *ans = (int *)malloc(sizeof(int) * numsSize);
    int pos = 0;
    for (int i = 0; i < numsSize; ++i) {
        int x = abs(nums[i]);
        if (nums[x - 1] > 0) {
            nums[x - 1] = -nums[x - 1];
        } else {
            ans[pos++] = x;
        }
    }
    *returnSize = pos;
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。我们只需要对数组 $\textit{nums}$ 进行一次遍历。

- 空间复杂度：$O(1)$。返回值不计入空间复杂度。