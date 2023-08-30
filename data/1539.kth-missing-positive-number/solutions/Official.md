#### 方法一：枚举

**思路与算法**

我们可以顺序枚举。

用一个变量 $\textit{current}$ 表示当前应该出现的数，从 $1$ 开始，每次循环都让该变量递增。用一个指针 $\textit{ptr}$ 指向数组中没有匹配的第一个元素，每轮循环中将该元素和 $\textit{current}$ 进行比较，如果相等，则指针后移，否则指针留在原地不动，说明缺失正整数 $\textit{current}$。我们用 $\textit{missCount}$ 变量记录缺失的正整数的个数，每次发现有正整数缺失的时候，该变量自增，并且记录这个缺失的正整数，直到我们找到第 $k$ 个缺失的正整数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int findKthPositive(vector<int>& arr, int k) {
        int missCount = 0, lastMiss = -1, current = 1, ptr = 0; 
        for (missCount = 0; missCount < k; ++current) {
            if (current == arr[ptr]) {
                ptr = (ptr + 1 < arr.size()) ? ptr + 1 : ptr;
            } else {
                ++missCount;
                lastMiss = current;
            }
        }
        return lastMiss;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findKthPositive(int[] arr, int k) {
        int missCount = 0, lastMiss = -1, current = 1, ptr = 0; 
        for (missCount = 0; missCount < k; ++current) {
            if (current == arr[ptr]) {
                ptr = (ptr + 1 < arr.length) ? ptr + 1 : ptr;
            } else {
                ++missCount;
                lastMiss = current;
            }
        }
        return lastMiss;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindKthPositive(int[] arr, int k) {
        int missCount = 0, lastMiss = -1, current = 1, ptr = 0; 
        for (missCount = 0; missCount < k; ++current) {
            if (current == arr[ptr]) {
                ptr = (ptr + 1 < arr.Length) ? ptr + 1 : ptr;
            } else {
                ++missCount;
                lastMiss = current;
            }
        }
        return lastMiss;
    }
}
```

```JavaScript [sol1-JavaScript]
var findKthPositive = function(arr, k) {
    let missCount = 0, lastMiss = -1, current = 1, ptr = 0; 
    for (missCount = 0; missCount < k; ++current) {
        if (current == arr[ptr]) {
            ptr = (ptr + 1 < arr.length) ? ptr + 1 : ptr;
        } else {
            ++missCount;
            lastMiss = current;
        }
    }
    return lastMiss;
};
```

```Python [sol1-Python3]
class Solution:
    def findKthPositive(self, arr: List[int], k: int) -> int:
        missCount = 0
        lastMiss = -1
        current = 1
        ptr = 0

        while missCount < k:
            if current == arr[ptr]:
                if ptr + 1 < len(arr):
                    ptr += 1
            else:
                missCount += 1
                lastMiss = current
            current += 1
        
        return lastMiss
```

**复杂度分析**

+ 时间复杂度：$O(n + k)$，其中 $n$ 是数组 $\textit{arr}$ 的长度，$k$ 是给定的整数。最坏情况下遍历完整个数组都没有缺失正整数，还要再将 $\textit{current}$ 递增 $k$ 次，才能找到最终的答案。

+ 空间复杂度：$O(1)$。

#### 方法二：二分查找

**思路与算法**

对于每个元素 $a_i$，我们都可以唯一确定到第 $i$ 个元素为止缺失的元素数量为 $a_i - i - 1$，例如：

|第 $i$ 个元素| $a_i$ 的值 | 到第 $i$ 个元素为止缺失的元素数量 $p_i$ |
|-------|------|-----|
| $a_0$ | $2$  | $1$ |
| $a_1$ | $3$  | $1$ |
| $a_2$ | $4$  | $1$ |
| $a_3$ | $7$  | $3$ |
| $a_4$ | $11$ | $6$ |

我们发现 $p_i$ 是随 $i$ 非严格递增的，于是可以使用二分查找解决这个问题。我们只要找到一个 $i$ 使得 $p_{i - 1} < k \leq p_{i}$，就可以确定缺失的第 $k$ 个数为 $k - p_{i - 1} + a_{i - 1}$。也就是说，我们要找到第一个大于等于 $k$ 的 $p_i$。

在实现的时候，我们要注意两个边界的处理：

+ 当 $a_0 > k$ 时，最终 $i = 0$，找不到 $i - 1$，所以提前判断是否 $a_0 > k$，如果是，则直接返回 $k$。
+ 当最后一个元素对应的缺失个数 $p_{n - 1} < k$ 时，我们并不能找到第一个大于等于 $k$ 的 $p_i$，为了解决这个问题，可以在 $a$ 序列的最后加入一个虚拟的值，这个值的大小为一个不会出现的非常大的数，这样就可以保证一定能找到一个大于等于 $k$ 的 $p_i$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int findKthPositive(vector<int>& arr, int k) {
        if (arr[0] > k) {
            return k;
        }

        int l = 0, r = arr.size();
        while (l < r) {
            int mid = (l + r) >> 1;
            int x = mid < arr.size() ? arr[mid] : INT_MAX;
            if (x - mid - 1 >= k) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }

        return k - (arr[l - 1] - (l - 1) - 1) + arr[l - 1];
    }
};
```

```Java [sol2-Java]
class Solution {
    public int findKthPositive(int[] arr, int k) {
        if (arr[0] > k) {
            return k;
        }

        int l = 0, r = arr.length;
        while (l < r) {
            int mid = (l + r) >> 1;
            int x = mid < arr.length ? arr[mid] : Integer.MAX_VALUE;
            if (x - mid - 1 >= k) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }

        return k - (arr[l - 1] - (l - 1) - 1) + arr[l - 1];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int FindKthPositive(int[] arr, int k) {
        if (arr[0] > k) {
            return k;
        }

        int l = 0, r = arr.Length;
        while (l < r) {
            int mid = (l + r) >> 1;
            int x = mid < arr.Length ? arr[mid] : int.MaxValue;
            if (x - mid - 1 >= k) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }

        return k - (arr[l - 1] - (l - 1) - 1) + arr[l - 1];
    }
}
```

```JavaScript [sol2-JavaScript]
var findKthPositive = function(arr, k) {
    if (arr[0] > k) {
        return k;
    }

    let l = 0, r = arr.length;
    while (l < r) {
        const mid = Math.floor((l + r) / 2);
        let x = mid < arr.length ? arr[mid] : 2000000;
        if (x - mid - 1 >= k) {
            r = mid;
        } else {
            l = mid + 1;
        }
    }

    return k - (arr[l - 1] - (l - 1) - 1) + arr[l - 1];
};
```

```Python [sol2-Python3]
class Solution:
    def findKthPositive(self, arr: List[int], k: int) -> int:
        if arr[0] > k:
            return k
        
        l, r = 0, len(arr)
        while l < r:
            mid = (l + r) >> 1
            x = arr[mid] if mid < len(arr) else 10**9
            if x - mid - 1 >= k:
                r = mid
            else:
                l = mid + 1

        return k - (arr[l - 1] - (l - 1) - 1) + arr[l - 1]
```

**复杂度分析**

+ 时间复杂度：$O(\log n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。即二分查找的时间复杂度。

+ 空间复杂度：$O(1)$。