## [982.按位与为零的三元组 中文官方题解](https://leetcode.cn/problems/triples-with-bitwise-and-equal-to-zero/solutions/100000/an-wei-yu-wei-ling-de-san-yuan-zu-by-lee-gjud)

#### 方法一：枚举

**思路与算法**

最容易想到的做法是使用三重循环枚举三元组 $(i,j,k)$，再判断 $\textit{nums}[i] ~\&~ \textit{nums}[j] ~\&~ \textit{nums}[k]$ 的值是否为 $0$。但这样做的时间复杂度是 $O(n^3)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，会超出时间限制。

注意到题目中给定了一个限制：数组 $\textit{nums}$ 的元素不会超过 $2^{16}$。这说明，$\textit{nums}[i] ~\&~ \textit{nums}[j]$ 的值也不会超过 $2^{16}$。因此，我们可以首先使用二重循环枚举 $i$ 和 $j$，并使用一个长度为 $2^{16}$ 的数组（或哈希表）存储每一种 $\textit{nums}[i] ~\&~ \textit{nums}[j]$ 以及它出现的次数。随后，我们再使用二重循环，其中的一重枚举记录频数的数组，另一重枚举 $k$，这样就可以将时间复杂度从 $O(n^3)$ 降低至 $O(n^2 + 2^{16} \cdot n)$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countTriplets(vector<int>& nums) {
        vector<int> cnt(1 << 16);
        for (int x: nums) {
            for (int y: nums) {
                ++cnt[x & y];
            }
        }
        int ans = 0;
        for (int x: nums) {
            for (int mask = 0; mask < (1 << 16); ++mask) {
                if ((x & mask) == 0) {
                    ans += cnt[mask];
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countTriplets(int[] nums) {
        int[] cnt = new int[1 << 16];
        for (int x : nums) {
            for (int y : nums) {
                ++cnt[x & y];
            }
        }
        int ans = 0;
        for (int x : nums) {
            for (int mask = 0; mask < (1 << 16); ++mask) {
                if ((x & mask) == 0) {
                    ans += cnt[mask];
                }
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountTriplets(int[] nums) {
        int[] cnt = new int[1 << 16];
        foreach (int x in nums) {
            foreach (int y in nums) {
                ++cnt[x & y];
            }
        }
        int ans = 0;
        foreach (int x in nums) {
            for (int mask = 0; mask < (1 << 16); ++mask) {
                if ((x & mask) == 0) {
                    ans += cnt[mask];
                }
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def countTriplets(self, nums: List[int]) -> int:
        cnt = Counter((x & y) for x in nums for y in nums)
        
        ans = 0
        for x in nums:
            for mask, freq in cnt.items():
                if (x & mask) == 0:
                    ans += freq
        return ans
```

```C [sol1-C]
int countTriplets(int* nums, int numsSize) {
    int *cnt = (int *)calloc(sizeof(int), 1 << 16);
    for (int i = 0; i < numsSize; i++) {
        int x = nums[i];
        for (int j = 0; j < numsSize; j++) {
            int y = nums[j];
            ++cnt[x & y];
        }
    }
    int ans = 0;
    for (int i = 0; i < numsSize; i++) {
        int x = nums[i];
        for (int mask = 0; mask < (1 << 16); ++mask) {
            if ((x & mask) == 0) {
                ans += cnt[mask];
            }
        }
    }
    free(cnt);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var countTriplets = function(nums) {
    const cnt = new Array(1 << 16).fill(0);
    for (const x of nums) {
        for (const y of nums) {
            ++cnt[x & y];
        }
    }
    let ans = 0;
    for (const x of nums) {
        for (let mask = 0; mask < (1 << 16); ++mask) {
            if ((x & mask) === 0) {
                ans += cnt[mask];
            }
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func countTriplets(nums []int) int {
    cnt := make(map[int]int)
    for i := range nums {
        for j := range nums {
            cnt[nums[i]&nums[j]]++
        }
    }
    res := 0
    for i := range nums {
        for k, v := range cnt {
            if k&nums[i] == 0 {
                res += v
            }
        }
    }
    return res
}
```

**复杂度分析**

- 时间复杂度：$O(n^2 + C \cdot n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是数组 $\textit{nums}$ 中的元素范围，在本题中 $C = 2^{16}$。

- 空间复杂度：$O(C)$，即为数组（或哈希表）需要使用的空间。

#### 方法二：枚举 + 子集优化

**思路与算法**

在方法一的第二个二重循环中，我们需要枚举 $[0, 2^{16})$ 中的所有整数。即使我们使用哈希表代替数组，在数据随机的情况下，$\textit{nums}[i] ~\&~ \textit{nums}[j]$ 也会覆盖 $[0, 2^{16})$ 中的大部分整数，使得哈希表不会有明显更好的表现。

这里我们介绍另一个常数级别的优化。当我们在第二个二重循环中枚举 $k$ 时，我们希望统计出所有与 $\textit{nums}[k]$ 按位与为 $0$ 的二元组数量。也就是说：

> 如果 $\textit{nums}[k]$ 的第 $t$ 个二进制位是 $0$，那么二元组的第 $t$ 个二进制位才可以是 $1$，否则**一定不能**是 $1$。

因此，我们可以将 $\textit{nums}[k]$ 与 $2^{16}-1$（即二进制表示下的 $16$ 个 $1$）进行按位异或运算。这样一来，满足要求的二元组的二进制表示中包含的 $1$ 必须是该数的**子集**，例如该数是 $(100111)_2$，那么满足要求的二元组可以是 $(100010)_2$ 或者 $(000110)_2$，但不能是 $(010001)_2$。

此时，要想得到所有该数的**子集**，我们可以使用「二进制枚举子集」的技巧。这里给出对应的步骤：

- 记该数为 $x$。我们用 $\textit{sub}$ 表示当前枚举到的子集。初始时 $\textit{sub} = x$，因为 $x$ 也是本身的子集；

- 我们不断地令 $\textit{sub} = (\textit{sub} - 1) ~\&~ x$，其中 $\&$ 表示按位与运算。这样我们就可以从大到小枚举 $x$ 的所有子集。当 $\textit{sub} = 0$ 时枚举结束。

我们可以粗略估计这样做可以优化的时间复杂度：当数据随机时，$x$ 的二进制表示中期望有 $16/2=8$ 个 $1$，那么「二进制枚举子集」需要枚举 $2^8$ 次。在优化前，我们需要枚举 $2^{16}$ 次，因此常数项就缩减到原来的 $\dfrac{1}{2^8}$。但在最坏情况下，$x$ 的二进制表示有 $16$ 个 $1$，两种方法的表现没有区别。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int countTriplets(vector<int>& nums) {
        vector<int> cnt(1 << 16);
        for (int x: nums) {
            for (int y: nums) {
                ++cnt[x & y];
            }
        }
        int ans = 0;
        for (int x: nums) {
            x = x ^ 0xffff;
            for (int sub = x; sub; sub = (sub - 1) & x) {
                ans += cnt[sub];
            }
            ans += cnt[0];
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int countTriplets(int[] nums) {
        int[] cnt = new int[1 << 16];
        for (int x : nums) {
            for (int y : nums) {
                ++cnt[x & y];
            }
        }
        int ans = 0;
        for (int x : nums) {
            x = x ^ 0xffff;
            for (int sub = x; sub != 0; sub = (sub - 1) & x) {
                ans += cnt[sub];
            }
            ans += cnt[0];
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int CountTriplets(int[] nums) {
        int[] cnt = new int[1 << 16];
        foreach (int x in nums) {
            foreach (int y in nums) {
                ++cnt[x & y];
            }
        }
        int ans = 0;
        foreach (int x in nums) {
            int y = x ^ 0xffff;
            for (int sub = y; sub != 0; sub = (sub - 1) & y) {
                ans += cnt[sub];
            }
            ans += cnt[0];
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def countTriplets(self, nums: List[int]) -> int:
        cnt = Counter((x & y) for x in nums for y in nums)
        
        ans = 0
        for x in nums:
            sub = x = x ^ 0xffff
            while True:
                if sub in cnt:
                    ans += cnt[sub]
                if sub == 0:
                    break
                sub = (sub - 1) & x
        
        return ans
```

```C [sol2-C]
int countTriplets(int* nums, int numsSize) {
    int *cnt = (int *)calloc(sizeof(int), 1 << 16);
    for (int i = 0; i < numsSize; i++) {
        int x = nums[i];
        for (int j = 0; j < numsSize; j++) {
            int y = nums[j];
            ++cnt[x & y];
        }
    }
    int ans = 0;
    for (int i = 0; i < numsSize; i++) {
        int x = nums[i] ^ 0xffff;
        for (int sub = x; sub; sub = (sub - 1) & x) {
            ans += cnt[sub];
        }
        ans += cnt[0];
    }
    free(cnt);
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var countTriplets = function(nums) {
    const cnt = new Array(1 << 16).fill(0);
    for (const x of nums) {
        for (const y of nums) {
            ++cnt[x & y];
        }
    }
    let ans = 0;
    for (let x of nums) {
        x = x ^ 0xffff;
        for (let sub = x; sub !== 0; sub = (sub - 1) & x) {
            ans += cnt[sub];
        }
        ans += cnt[0];
    }
    return ans;
};
```

```go [sol1-Golang]
func countTriplets(nums []int) int {
    var cnt [1 << 16]int
    for i := range nums {
        for j := range nums {
            cnt[nums[i]&nums[j]]++
        }
    }
    res := 0
    for i := range nums {
        x := nums[i] ^ 0xffff
        for sub := x; sub > 0; sub = (sub - 1) & x {
            res += cnt[sub]
        }
        res += cnt[0]
    }
    return res
}
```

**复杂度分析**

- 时间复杂度：$O(n^2 + C \cdot n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是数组 $\textit{nums}$ 中的元素范围，在本题中 $C = 2^{16}$。

- 空间复杂度：$O(C)$，即为数组（或哈希表）需要使用的空间。