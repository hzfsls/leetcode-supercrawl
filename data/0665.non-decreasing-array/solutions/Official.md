## [665.非递减数列 中文官方题解](https://leetcode.cn/problems/non-decreasing-array/solutions/100000/fei-di-jian-shu-lie-by-leetcode-solution-zdsm)

#### 方法一：数组

首先思考如下问题：

> 要使数组 $\textit{nums}$ 变成一个非递减数列，数组中**至多**有多少个 $i$ 满足 $\textit{nums}[i]>\textit{nums}[i+1]$？

假设有两个不同的下标 $i$, $j$ 满足上述不等式，不妨设 $i<j$.

若 $i+1<j$，则无论怎么修改 $\textit{nums}[i]$ 或 $\textit{nums}[i+1]$，都不会影响 $\textit{nums}[j]$ 与 $\textit{nums}[j+1]$ 之间的大小关系；修改 $\textit{nums}[j]$ 或 $\textit{nums}[j+1]$ 也同理。因此，这种情况下，我们无法将 $\textit{nums}$ 变成非递减数列。

若 $i+1=j$，则有 $\textit{nums}[i]>\textit{nums}[i+1]>\textit{nums}[i+2]$。同样地，无论怎么修改其中一个数，都无法使这三个数变为 $\textit{nums}[i]\le\textit{nums}[i+1]\le\textit{nums}[i+2]$ 的大小关系。

因此，上述问题的结论是:

> 至多一个。

满足这个条件就足够了吗？并不，对于满足该条件的数组 $[3,4,1,2]$ 而言，无论怎么修改也无法将其变成非递减数列。

因此，若找到了一个满足 $\textit{nums}[i]>\textit{nums}[i+1]$ 的 $i$，在修改 $\textit{nums}[i]$ 或 $\textit{nums}[i+1]$ 之后，还需要检查 $\textit{nums}$ 是否变成了非递减数列。

我们可以将 $\textit{nums}[i]$ 修改成小于或等于 $\textit{nums}[i+1]$ 的数，但由于还需要保证 $\textit{nums}[i]$ 不小于它之前的数，$\textit{nums}[i]$ 越大越好，所以将 $\textit{nums}[i]$ 修改成 $\textit{nums}[i+1]$ 是最佳的；同理，对于 $\textit{nums}[i+1]$，修改成 $\textit{nums}[i]$ 是最佳的。

```cpp [sol1-C++]
class Solution {
public:
    bool checkPossibility(vector<int> &nums) {
        int n = nums.size();
        for (int i = 0; i < n - 1; ++i) {
            int x = nums[i], y = nums[i + 1];
            if (x > y) {
                nums[i] = y;
                if (is_sorted(nums.begin(), nums.end())) {
                    return true;
                }
                nums[i] = x; // 复原
                nums[i + 1] = x;
                return is_sorted(nums.begin(), nums.end());
            }
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean checkPossibility(int[] nums) {
        int n = nums.length;
        for (int i = 0; i < n - 1; ++i) {
            int x = nums[i], y = nums[i + 1];
            if (x > y) {
                nums[i] = y;
                if (isSorted(nums)) {
                    return true;
                }
                nums[i] = x; // 复原
                nums[i + 1] = x;
                return isSorted(nums);
            }
        }
        return true;
    }

    public boolean isSorted(int[] nums) {
        int n = nums.length;
        for (int i = 1; i < n; ++i) {
            if (nums[i - 1] > nums[i]) {
                return false;
            }
        }
        return true;
    }
}
```

```go [sol1-Golang]
func checkPossibility(nums []int) bool {
    for i := 0; i < len(nums)-1; i++ {
        x, y := nums[i], nums[i+1]
        if x > y {
            nums[i] = y
            if sort.IntsAreSorted(nums) {
                return true
            }
            nums[i] = x // 复原
            nums[i+1] = x
            return sort.IntsAreSorted(nums)
        }
    }
    return true
}
```

```JavaScript [sol1-JavaScript]
var checkPossibility = function(nums) {
    const n = nums.length;
    for (let i = 0; i < n - 1; ++i) {
        const x = nums[i], y = nums[i + 1];
        if (x > y) {
            nums[i] = y;
            if (isSorted(nums)) {
                return true;
            }
            nums[i] = x; // 复原
            nums[i + 1] = x;
            return isSorted(nums);
        }
    }
    return true;
};

const isSorted = (nums) => {
    const n = nums.length;
    for (let i = 1; i < n; ++i) {
        if (nums[i - 1] > nums[i]) {
            return false;
        }
    }
    return true;
}
```

```C [sol1-C]
bool isSorted(int* nums, int numsSize) {
    for (int i = 1; i < numsSize; ++i) {
        if (nums[i - 1] > nums[i]) {
            return false;
        }
    }
    return true;
}

bool checkPossibility(int* nums, int numsSize) {
    for (int i = 0; i < numsSize - 1; ++i) {
        int x = nums[i], y = nums[i + 1];
        if (x > y) {
            nums[i] = y;
            if (isSorted(nums, numsSize)) {
                return true;
            }
            nums[i] = x;  // 复原
            nums[i + 1] = x;
            return isSorted(nums, numsSize);
        }
    }
    return true;
}
```

**优化**

上面的代码多次遍历了 $\textit{nums}$ 数组，能否只遍历一次呢？

修改 $\textit{nums}[i]$ 为 $\textit{nums}[i+1]$ 后，还需要保证 $\textit{nums}[i-1]\le\textit{nums}[i]$ 仍然成立，即 $\textit{nums}[i-1]\le\textit{nums}[i+1]$，若该不等式不成立则整个数组必然不是非递减的，则需要修改 $\textit{nums}[i+1]$ 为 $\textit{nums}[i]$。修改完后，接着判断后续数字的大小关系。在遍历中统计 $\textit{nums}[i]>\textit{nums}[i+1]$ 的次数，若超过一次可以直接返回 $\text{false}$。

```cpp [sol2-C++]
class Solution {
public:
    bool checkPossibility(vector<int> &nums) {
        int n = nums.size(), cnt = 0;
        for (int i = 0; i < n - 1; ++i) {
            int x = nums[i], y = nums[i + 1];
            if (x > y) {
                cnt++;
                if (cnt > 1) {
                    return false;
                }
                if (i > 0 && y < nums[i - 1]) {
                    nums[i + 1] = x;
                }
            }
        }
        return true;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean checkPossibility(int[] nums) {
        int n = nums.length, cnt = 0;
        for (int i = 0; i < n - 1; ++i) {
            int x = nums[i], y = nums[i + 1];
            if (x > y) {
                cnt++;
                if (cnt > 1) {
                    return false;
                }
                if (i > 0 && y < nums[i - 1]) {
                    nums[i + 1] = x;
                }
            }
        }
        return true;
    }
}
```

```go [sol2-Golang]
func checkPossibility(nums []int) bool {
    cnt := 0
    for i := 0; i < len(nums)-1; i++ {
        x, y := nums[i], nums[i+1]
        if x > y {
            cnt++
            if cnt > 1 {
                return false
            }
            if i > 0 && y < nums[i-1] {
                nums[i+1] = x
            }
        }
    }
    return true
}
```

```JavaScript [sol2-JavaScript]
var checkPossibility = function(nums) {
    const n = nums.length;
    let cnt = 0;
    for (let i = 0; i < n - 1; ++i) {
        const x = nums[i], y = nums[i + 1];
        if (x > y) {
            cnt++;
            if (cnt > 1) {
                return false;
            }
            if (i > 0 && y < nums[i - 1]) {
                nums[i + 1] = x;
            }
        }
    }
    return true;
};
```

```C [sol2-C]
bool checkPossibility(int* nums, int numsSize) {
    int cnt = 0;
    for (int i = 0; i < numsSize - 1; ++i) {
        int x = nums[i], y = nums[i + 1];
        if (x > y) {
            cnt++;
            if (cnt > 1) {
                return false;
            }
            if (i > 0 && y < nums[i - 1]) {
                nums[i + 1] = x;
            }
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。