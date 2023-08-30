#### 方法一：差分数组

由于对同一个子数组执行两次翻转操作不会改变该子数组，所以对每个长度为 $k$ 的子数组，应至多执行一次翻转操作。

对于若干个 $k$ 位翻转操作，改变先后顺序并不影响最终翻转的结果。不妨从 $\textit{nums}[0]$ 开始考虑，若 $\textit{nums}[0]=0$，则必定要翻转从位置 $0$ 开始的子数组；若 $\textit{nums}[0]=1$，则不翻转从位置 $0$ 开始的子数组。

按照这一策略，我们从左到右地执行这些翻转操作。由于翻转操作是唯一的，若最终数组元素均为 $1$，则执行的翻转次数就是最小的。

用 $n$ 表示数组 $\textit{nums}$ 的长度。若直接模拟上述过程，复杂度将会是 $O(nk)$ 的。如何优化呢？

考虑不去翻转数字，而是统计每个数字需要翻转的次数。对于一次翻转操作，相当于把子数组中所有数字的翻转次数加 $1$。

这启发我们用**差分数组**的思想来计算当前数字需要翻转的次数。我们可以维护一个差分数组 $\textit{diff}$，其中 $\textit{diff}[i]$ 表示两个相邻元素 $\textit{nums}[i-1]$ 和 $\textit{nums}[i]$ 的翻转次数的差，对于区间 $[l,r]$，将其元素全部加 $1$，只会影响到 $l$ 和 $r+1$ 处的差分值，故 $\textit{diff}[l]$ 增加 $1$，$\textit{diff}[r+1]$ 减少 $1$。

通过累加差分数组可以得到当前位置需要翻转的次数，我们用变量 $revCnt$ 来表示这一累加值。

遍历到 $\textit{nums}[i]$ 时，若 $\textit{nums}[i]+\textit{revCnt}$ 是偶数，则说明当前元素的实际值为 $0$，需要翻转区间 $[i,i+k-1]$，我们可以直接将 $\textit{revCnt}$ 增加 $1$，$\textit{diff}[i+k]$ 减少 $1$。

注意到若 $i+k>n$ 则无法执行翻转操作，此时应返回 $-1$。

**代码**

```C++ [sol11-C++]
class Solution {
public:
    int minKBitFlips(vector<int>& nums, int k) {
        int n = nums.size();
        vector<int> diff(n + 1);
        int ans = 0, revCnt = 0;
        for (int i = 0; i < n; ++i) {
            revCnt += diff[i];
            if ((nums[i] + revCnt) % 2 == 0) {
                if (i + k > n) {
                    return -1;
                }
                ++ans;
                ++revCnt;
                --diff[i + k];
            }
        }
        return ans;
    }
};
```

```Java [sol11-Java]
class Solution {
    public int minKBitFlips(int[] nums, int k) {
        int n = nums.length;
        int[] diff = new int[n + 1];
        int ans = 0, revCnt = 0;
        for (int i = 0; i < n; ++i) {
            revCnt += diff[i];
            if ((nums[i] + revCnt) % 2 == 0) {
                if (i + k > n) {
                    return -1;
                }
                ++ans;
                ++revCnt;
                --diff[i + k];
            }
        }
        return ans;
    }
}
```

```go [sol11-Golang]
func minKBitFlips(nums []int, k int) (ans int) {
    n := len(nums)
    diff := make([]int, n+1)
    revCnt := 0
    for i, v := range nums {
        revCnt += diff[i]
        if (v+revCnt)%2 == 0 {
            if i+k > n {
                return -1
            }
            ans++
            revCnt++
            diff[i+k]--
        }
    }
    return
}
```

```C [sol11-C]
int minKBitFlips(int* nums, int numsSize, int k) {
    int diff[numsSize + 1];
    memset(diff, 0, sizeof(diff));
    int ans = 0, revCnt = 0;
    for (int i = 0; i < numsSize; ++i) {
        revCnt += diff[i];
        if ((nums[i] + revCnt) % 2 == 0) {
            if (i + k > numsSize) {
                return -1;
            }
            ++ans;
            ++revCnt;
            --diff[i + k];
        }
    }
    return ans;
}
```

```JavaScript [sol11-JavaScript]
var minKBitFlips = function(nums, k) {
    const n = nums.length;
    const diff = new Array(n + 1).fill(0);
    let ans = 0, revCnt = 0;
    for (let i = 0; i < n; i++) {
        revCnt += diff[i];
        if ((nums[i] + revCnt) % 2 === 0) {
            if ((i + k) > n) {
                return -1;
            }
            ++ans;
            ++revCnt;
            --diff[i + k]
        }
    }
    return ans;
};
```

由于模 $2$ 意义下的加减法与异或等价，我们也可以用异或改写上面的代码。

```C++ [sol12-C++]
class Solution {
public:
    int minKBitFlips(vector<int>& nums, int k) {
        int n = nums.size();
        vector<int> diff(n + 1);
        int ans = 0, revCnt = 0;
        for (int i = 0; i < n; ++i) {
            revCnt ^= diff[i];
            if (nums[i] == revCnt) { // nums[i] ^ revCnt == 0
                if (i + k > n) {
                    return -1;
                }
                ++ans;
                revCnt ^= 1;
                diff[i + k] ^= 1;
            }
        }
        return ans;
    }
};
```

```Java [sol12-Java]
class Solution {
    public int minKBitFlips(int[] nums, int k) {
        int n = nums.length;
        int[] diff = new int[n + 1];
        int ans = 0, revCnt = 0;
        for (int i = 0; i < n; ++i) {
            revCnt ^= diff[i];
            if (nums[i] == revCnt) { // nums[i] ^ revCnt == 0
                if (i + k > n) {
                    return -1;
                }
                ++ans;
                revCnt ^= 1;
                diff[i + k] ^= 1;
            }
        }
        return ans;
    }
}
```

```go [sol12-Golang]
func minKBitFlips(nums []int, k int) (ans int) {
    n := len(nums)
    diff := make([]int, n+1)
    revCnt := 0
    for i, v := range nums {
        revCnt ^= diff[i]
        if v == revCnt { // v^revCnt == 0
            if i+k > n {
                return -1
            }
            ans++
            revCnt ^= 1
            diff[i+k] ^= 1
        }
    }
    return
}
```

```C [sol12-C]
int minKBitFlips(int* nums, int numsSize, int k) {
    int diff[numsSize + 1];
    memset(diff, 0, sizeof(diff));
    int ans = 0, revCnt = 0;
    for (int i = 0; i < numsSize; ++i) {
        revCnt ^= diff[i];
        if (nums[i] == revCnt) {  // nums[i] ^ revCnt == 0
            if (i + k > numsSize) {
                return -1;
            }
            ++ans;
            revCnt ^= 1;
            diff[i + k] ^= 1;
        }
    }
    return ans;
}
```

```JavaScript [sol12-JavaScript]
var minKBitFlips = function(nums, k) {
    const n = nums.length;
    const diff = new Array(n + 1).fill(0);
    let ans = 0, revCnt = 0;
    for (let i = 0; i < n; i++) {
        revCnt ^= diff[i];
        if (nums[i] === revCnt) { // nums[i] ^ revCnt == 0
            if ((i + k) > n) {
                return -1;
            }
            ++ans;
            revCnt ^= 1;
            diff[i + k] ^= 1;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要对数组 $\textit{nums}$ 遍历一次。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要创建一个长度为 $n+1$ 的差分数组 $\textit{diff}$。


#### 方法二：滑动窗口

能否将空间复杂度优化至 $O(1)$ 呢？

回顾方法一的代码，当遍历到位置 $i$ 时，若能知道位置 $i-k$ 上发生了翻转操作，便可以直接修改 $\textit{revCnt}$，从而去掉 $\textit{diff}$ 数组。

注意到 $0\le \textit{nums}[i]\le 1$，我们可以用 $\textit{nums}[i]$ 范围**之外**的数来表达「是否翻转过」的含义。

具体来说，若要翻转从位置 $i$ 开始的子数组，可以将 $\textit{nums}[i]$ 加 $2$，这样当遍历到位置 $i'$ 时，若有 $\textit{nums}[i'-k]>1$，则说明在位置 $i'-k$ 上发生了翻转操作。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int minKBitFlips(vector<int>& nums, int k) {
        int n = nums.size();
        int ans = 0, revCnt = 0;
        for (int i = 0; i < n; ++i) {
            if (i >= k && nums[i - k] > 1) {
                revCnt ^= 1;
                nums[i - k] -= 2; // 复原数组元素，若允许修改数组 nums，则可以省略
            }
            if (nums[i] == revCnt) {
                if (i + k > n) {
                    return -1;
                }
                ++ans;
                revCnt ^= 1;
                nums[i] += 2;
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minKBitFlips(int[] nums, int k) {
        int n = nums.length;
        int ans = 0, revCnt = 0;
        for (int i = 0; i < n; ++i) {
            if (i >= k && nums[i - k] > 1) {
                revCnt ^= 1;
                nums[i - k] -= 2; // 复原数组元素，若允许修改数组 nums，则可以省略
            }
            if (nums[i] == revCnt) {
                if (i + k > n) {
                    return -1;
                }
                ++ans;
                revCnt ^= 1;
                nums[i] += 2;
            }
        }
        return ans;
    }
}
```

```go [sol2-Golang]
func minKBitFlips(nums []int, k int) (ans int) {
    n := len(nums)
    revCnt := 0
    for i, v := range nums {
        if i >= k && nums[i-k] > 1 {
            revCnt ^= 1
            nums[i-k] -= 2 // 复原数组元素，若允许修改数组 nums，则可以省略
        }
        if v == revCnt {
            if i+k > n {
                return -1
            }
            ans++
            revCnt ^= 1
            nums[i] += 2
        }
    }
    return
}
```

```C [sol2-C]
int minKBitFlips(int* nums, int numsSize, int k) {
    int ans = 0, revCnt = 0;
    for (int i = 0; i < numsSize; ++i) {
        if (i >= k && nums[i - k] > 1) {
            revCnt ^= 1;
            nums[i - k] -= 2;  // 复原数组元素，若允许修改数组 nums，则可以省略
        }
        if (nums[i] == revCnt) {
            if (i + k > numsSize) {
                return -1;
            }
            ++ans;
            revCnt ^= 1;
            nums[i] += 2;
        }
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var minKBitFlips = function(nums, k) {
    const n = nums.length;
    let ans = 0, revCnt = 0;
    for (let i = 0; i < n; ++i) {
        if (i >= k && nums[i - k] > 1) {
            revCnt ^= 1;
            nums[i - k] -= 2; // 复原数组元素，若允许修改数组 nums，则可以省略
        }
        if (nums[i] == revCnt) {
            if (i + k > n) {
                return -1;
            }
            ++ans;
            revCnt ^= 1;
            nums[i] += 2;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$。其中 $n$ 是数组 $\textit{nums}$ 的长度。需要对数组 $\textit{nums}$ 遍历一次。

- 空间复杂度：$O(1)$。