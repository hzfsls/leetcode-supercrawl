## [1894.找到需要补充粉笔的学生编号 中文官方题解](https://leetcode.cn/problems/find-the-student-that-will-replace-the-chalk/solutions/100000/zhao-dao-xu-yao-bu-chong-fen-bi-de-xue-s-qrn1)
#### 方法一：优化的模拟

**思路与算法**

学生消耗粉笔的过程是重复的。记每一轮消耗粉笔的总量为 $\textit{total}$，它等于数组 $\textit{chalk}$ 的元素之和。因此，我们可以将粉笔数量 $k$ 对 $\textit{total}$ 进行取模，求得余数 $k'$ 以方便后续计算。由于 $k'$ 一定小于 $\textit{total}$，因此我们只需要至多遍历一遍数组 $\textit{chalk}$，同时模拟 $k'$ 减小的过程，即可以得到需要补充粉笔的学生编号。

**细节**

由于 $\textit{total}$ 可能会超过 $32$ 位有符号整数的范围，因此对于一些整数类型有范围的语言，为了避免溢出，需要使用 $64$ 位整数存储 $\textit{total}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int chalkReplacer(vector<int>& chalk, int k) {
        int n = chalk.size();
        long long total = accumulate(chalk.begin(), chalk.end(), 0LL);
        k %= total;
        int res = -1;
        for (int i = 0; i < n; ++i) {
            if (chalk[i] > k) {
                res = i;
                break;
            }
            k -= chalk[i];
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int chalkReplacer(int[] chalk, int k) {
        int n = chalk.length;
        long total = 0;
        for (int num : chalk) {
            total += num;
        }
        k %= total;
        int res = -1;
        for (int i = 0; i < n; ++i) {
            if (chalk[i] > k) {
                res = i;
                break;
            }
            k -= chalk[i];
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ChalkReplacer(int[] chalk, int k) {
        int n = chalk.Length;
        long total = 0;
        foreach (int num in chalk) {
            total += num;
        }
        if (k >= total) {
            k %= (int) total;
        }
        int res = -1;
        for (int i = 0; i < n; ++i) {
            if (chalk[i] > k) {
                res = i;
                break;
            }
            k -= chalk[i];
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def chalkReplacer(self, chalk: List[int], k: int) -> int:
        total = sum(chalk)
        k %= total
        res = -1
        for i, cnt in enumerate(chalk):
            if cnt > k:
                res = i
                break
            k -= cnt
        return res
```

```JavaScript [sol1-JavaScript]
var chalkReplacer = function(chalk, k) {
    const n = chalk.length;
    let total = 0;
    for (const num of chalk) {
        total += num;
    }
    k %= total;
    let res = -1;
    for (let i = 0; i < n; ++i) {
        if (chalk[i] > k) {
            res = i;
            break;
        }
        k -= chalk[i];
    }
    return res;
};
```

```go [sol1-Golang]
func chalkReplacer(chalk []int, k int) int {
    total := 0
    for _, v := range chalk {
        total += v
    }
    k %= total
    for i, c := range chalk {
        if k < c {
            return i
        }
        k -= c
    }
    return 0
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{chalk}$ 的长度。我们最多遍历数组 $\textit{chalk}$ 两次，第一次求出粉笔的总量 $\textit{total}$，第二次找出答案。

- 空间复杂度：$O(1)$。

#### 方法二：前缀和 + 二分查找

**思路与算法**

对于方法一中的第二次遍历，我们也可以使用二分查找进行加速。

在对数组 $\textit{chalk}$ 的遍历过程中，我们可以求出其前缀和，记为数组 $\textit{pre}$。那么需要补充粉笔的学生编号 $i'$ 是**最小的**满足 $\textit{pre}[i] > k'$ 的下标 $i'$，可以通过二分查找在 $O(\log n)$ 的时间内找出。

**细节**

由于前缀和数组中的元素可能会超过 $32$ 位整数的范围，因此不能直接在原数组上计算并更新前缀和。但可以注意到的是，本题中 $k \leq 10^9$，因此在计算前缀和数组的过程中，如果超过了 $k$，说明我们找到了需要补充粉笔的学生编号，此时就无需继续计算下去，那么也就不会超过 $32$ 位整数的范围了。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int chalkReplacer(vector<int>& chalk, int k) {
        int n = chalk.size();
        if (chalk[0] > k) {
            return 0;
        }
        for (int i = 1; i < n; ++i) {
            chalk[i] += chalk[i - 1];
            if (chalk[i] > k) {
                return i;
            }
        }

        k %= chalk.back();
        return upper_bound(chalk.begin(), chalk.end(), k) - chalk.begin();
    }
};
```

```Java [sol2-Java]
class Solution {
    public int chalkReplacer(int[] chalk, int k) {
        int n = chalk.length;
        if (chalk[0] > k) {
            return 0;
        }
        for (int i = 1; i < n; ++i) {
            chalk[i] += chalk[i - 1];
            if (chalk[i] > k) {
                return i;
            }
        }

        k %= chalk[n - 1];
        return binarySearch(chalk, k);
    }

    public int binarySearch(int[] arr, int target) {
        int low = 0, high = arr.length - 1;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (arr[mid] <= target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ChalkReplacer(int[] chalk, int k) {
        int n = chalk.Length;
        if (chalk[0] > k) {
            return 0;
        }
        for (int i = 1; i < n; ++i) {
            chalk[i] += chalk[i - 1];
            if (chalk[i] > k) {
                return i;
            }
        }

        k %= chalk[n - 1];
        return BinarySearch(chalk, k);
    }

    public int BinarySearch(int[] arr, int target) {
        int low = 0, high = arr.Length - 1;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (arr[mid] <= target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def chalkReplacer(self, chalk: List[int], k: int) -> int:
        n = len(chalk)
        if chalk[0] > k:
            return 0
        for i in range(1, n):
            chalk[i] += chalk[i - 1]
            if chalk[i] > k:
                return i

        k %= chalk[-1]
        return bisect_right(chalk, k)
```

```JavaScript [sol2-JavaScript]
var chalkReplacer = function(chalk, k) {
   const n = chalk.length;
    if (chalk[0] > k) {
        return 0;
    }
    for (let i = 1; i < n; ++i) {
        chalk[i] += chalk[i - 1];
        if (chalk[i] > k) {
            return i;
        }
    }

    k %= chalk[n - 1];
    return binarySearch(chalk, k);
};

const binarySearch = (arr, target) => {
    let low = 0, high = arr.length - 1;
    while (low < high) {
        const mid = Math.floor((high - low) / 2) + low;
        if (arr[mid] <= target) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
}
```

```go [sol2-Golang]
func chalkReplacer(chalk []int, k int) int {
    if chalk[0] > k {
        return 0
    }
    n := len(chalk)
    for i := 1; i < n; i++ {
        chalk[i] += chalk[i-1]
        if chalk[i] > k {
            return i
        }
    }
    k %= chalk[n-1]
    return sort.SearchInts(chalk, k+1)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{chalk}$ 的长度。计算前缀和的时间复杂度为 $O(n)$，二分查找的时间复杂度为 $O(\log n)$，因此总时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。