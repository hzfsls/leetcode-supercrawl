#### 方法一：贪心 + 分类讨论

**思路与算法**

题目给出一个长度为 $n$ 的整数数组 $\textit{nums}$，每次操作会从中选择一个元素并将该元素减少 $1$。现在给出「锯齿数组」的定义，若一个数组 $A$ 符合下列情况之一，则它就是「锯齿数组」：

- 每个偶数索引对应的元素都大于相邻的元素，即 $A[0] > A[1] < A[2] > A[3] < A[4] > \cdots$
- 或者，每个奇数索引对应的元素都大于相邻的元素，即 $A[0] < A[1] > A[2] < A[3] > A[4] < \cdots$

现在我们需要求得将 $\textit{nums}$ 转换为「锯齿数组」所需的最小操作次数。不失一般性，我们设我们最后求得的「锯齿数组」满足每一个偶数索引对应的元素都大于其相邻的元素。因为操作的先后并不会影响最终结果，所以我们若我们要对某些偶数下标的元素进行操作，则先完成该些操作，然后再统一对奇数下标的元素进行操作，设数组 $p$ 为对 $\textit{nums}$ 某些偶数下标的元素进行操作后的数组，那么为了使数组 $p$ 为满足每一个偶数索引对应的元素都大于其相邻的元素的「锯齿数组」，其奇数下标的元素都需要小于其相邻元素的最小值，即为了使某一个奇数下标位置 $i$ 满足要求的最少操作次数 $c_i = \max(p[i] - q(i) + 1, 0)$，其中 $q(i)$ 表示数组 $p$ 中位置 $i$ 相邻元素的最小值，因为若我们对某个偶数下标的元素进行了操作，则该元素相邻的奇数下标元素所需要的操作次数只增不减，但是总的操作次数一定增加了，所以最优解中一定不会存在对偶数下标操作的情况。那么我们对 $\textit{nums}$ 中每一个奇数位置 $i$ 的 $c_i$ 求和即为此时求每一个偶数索引对应的元素都大于其相邻的元素的「锯齿数组」的最少操作的次数。对于求每一个奇数索引对应的元素都大于其相邻的元素的「锯齿数组」的最小操作次数同理，最终返回两者的较小值即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def movesToMakeZigzag(self, nums: List[int]) -> int:
        def help(pos: int) -> int:
            res = 0
            for i in range(pos, len(nums), 2):
                a = 0
                if i - 1 >= 0:
                    a = max(a, nums[i] - nums[i - 1] + 1)
                if i + 1 < len(nums):
                    a = max(a, nums[i] - nums[i + 1] + 1)
                res += a
            return res

        return min(help(0), help(1))
```

```C++ [sol1-C++]
class Solution {
public:
    int help(vector<int>& nums, int pos) {
        int res = 0;
        for (int i = pos; i < nums.size(); i += 2) {
            int a = 0;
            if (i - 1 >= 0) {
                a = max(a, nums[i] - nums[i - 1] + 1);
            }
            if (i + 1 < nums.size()) {
                a = max(a, nums[i] - nums[i + 1] + 1);
            }
            res += a;
        }
        return res;
    }

    int movesToMakeZigzag(vector<int>& nums) {
        return min(help(nums, 0), help(nums, 1));
    }
};
```

```Java [sol1-Java]
class Solution {
    public int movesToMakeZigzag(int[] nums) {
        return Math.min(help(nums, 0), help(nums, 1));
    }

    public int help(int[] nums, int pos) {
        int res = 0;
        for (int i = pos; i < nums.length; i += 2) {
            int a = 0;
            if (i - 1 >= 0) {
                a = Math.max(a, nums[i] - nums[i - 1] + 1);
            }
            if (i + 1 < nums.length) {
                a = Math.max(a, nums[i] - nums[i + 1] + 1);
            }
            res += a;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MovesToMakeZigzag(int[] nums) {
        return Math.Min(Help(nums, 0), Help(nums, 1));
    }

    public int Help(int[] nums, int pos) {
        int res = 0;
        for (int i = pos; i < nums.Length; i += 2) {
            int a = 0;
            if (i - 1 >= 0) {
                a = Math.Max(a, nums[i] - nums[i - 1] + 1);
            }
            if (i + 1 < nums.Length) {
                a = Math.Max(a, nums[i] - nums[i + 1] + 1);
            }
            res += a;
        }
        return res;
    }
}
```

```C [sol1-C]
static inline int min(int a, int b) {
    return a < b ? a : b;
}

static inline int max(int a, int b) {
    return a > b ? a : b;
}

int help(const int *nums, int numsSize, int pos) {
    int res = 0;
    for (int i = pos; i < numsSize; i += 2) {
        int a = 0;
        if (i - 1 >= 0) {
            a = max(a, nums[i] - nums[i - 1] + 1);
        }
        if (i + 1 < numsSize) {
            a = max(a, nums[i] - nums[i + 1] + 1);
        }
        res += a;
    }
    return res;
}

int movesToMakeZigzag(int* nums, int numsSize) {
    return min(help(nums, numsSize, 0), help(nums, numsSize, 1));
}
```

```JavaScript [sol1-JavaScript]
var movesToMakeZigzag = function(nums) {
    return Math.min(help(nums, 0), help(nums, 1));
}

const help = (nums, pos) => {
    let res = 0;
    for (let i = pos; i < nums.length; i += 2) {
        let a = 0;
        if (i - 1 >= 0) {
            a = Math.max(a, nums[i] - nums[i - 1] + 1);
        }
        if (i + 1 < nums.length) {
            a = Math.max(a, nums[i] - nums[i + 1] + 1);
        }
        res += a;
    }
    return res;
};
```

```go [sol1-Golang]
func movesToMakeZigzag(nums []int) int {
    help := func(pos int) int {
        res := 0
        for i := pos; i < len(nums); i += 2 {
            a := 0
            if i-1 >= 0 {
                a = max(a, nums[i]-nums[i-1]+1)
            }
            if i+1 < len(nums) {
                a = max(a, nums[i]-nums[i+1]+1)
            }
            res += a
        }
        return res
    }

    return min(help(0), help(1))
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。
- 空间复杂度：$O(1)$。仅使用常量空间。