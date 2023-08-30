#### 方法一：递归

**思路与算法**

若数组 $\textit{nums}$ 的长度 $n$ 等于 $1$，我们直接返回 $\textit{nums}[0]$ 作为答案。否则，按照题意求出一个长度为 $\dfrac{n}{2}$ 的数组 $\textit{newNums}$，递归求解 $\textit{newNums}$ 的答案即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def minMaxGame(self, nums: List[int]) -> int:
        n = len(nums)
        if n == 1:
            return nums[0]
        newNums = [0] * (n // 2)
        for i in range(n // 2):
            if i % 2 == 0:
                newNums[i] = min(nums[2 * i], nums[2 * i + 1])
            else:
                newNums[i] = max(nums[2 * i], nums[2 * i + 1])
        return self.minMaxGame(newNums)
```

```C++ [sol1-C++]
class Solution {
public:
    int minMaxGame(vector<int>& nums) {
        int n = nums.size();
        if (n == 1) {
            return nums[0];
        }
        vector<int> newNums(n / 2);
        for (int i = 0; i < newNums.size(); i++) {
            if (i % 2 == 0) {
                newNums[i] = min(nums[2 * i], nums[2 * i + 1]);
            } else {
                newNums[i] = max(nums[2 * i], nums[2 * i + 1]);
            }
        }
        return minMaxGame(newNums);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minMaxGame(int[] nums) {
        int n = nums.length;
        if (n == 1) {
            return nums[0];
        }
        int[] newNums = new int[n / 2];
        for (int i = 0; i < newNums.length; i++) {
            if (i % 2 == 0) {
                newNums[i] = Math.min(nums[2 * i], nums[2 * i + 1]);
            } else {
                newNums[i] = Math.max(nums[2 * i], nums[2 * i + 1]);
            }
        }
        return minMaxGame(newNums);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinMaxGame(int[] nums) {
        int n = nums.Length;
        if (n == 1) {
            return nums[0];
        }
        int[] newNums = new int[n / 2];
        for (int i = 0; i < newNums.Length; i++) {
            if (i % 2 == 0) {
                newNums[i] = Math.Min(nums[2 * i], nums[2 * i + 1]);
            } else {
                newNums[i] = Math.Max(nums[2 * i], nums[2 * i + 1]);
            }
        }
        return MinMaxGame(newNums);
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minMaxGame(int* nums, int numsSize) {
    if (numsSize == 1) {
        return nums[0];
    }

    numsSize /= 2;
    int newNums[numsSize];
    for (int i = 0; i < numsSize; i++) {
        if (i % 2 == 0) {
            newNums[i] = MIN(nums[2 * i], nums[2 * i + 1]);
        } else {
            newNums[i] = MAX(nums[2 * i], nums[2 * i + 1]);
        }
    }
    return minMaxGame(newNums, numsSize);
}
```

```JavaScript [sol1-JavaScript]
var minMaxGame = function(nums) {
    const n = nums.length;
    if (n === 1) {
        return nums[0];
    }
    const newNums = new Array(Math.floor(n / 2)).fill(0);
    for (let i = 0; i < newNums.length; i++) {
        if (i % 2 === 0) {
            newNums[i] = Math.min(nums[2 * i], nums[2 * i + 1]);
        } else {
            newNums[i] = Math.max(nums[2 * i], nums[2 * i + 1]);
        }
    }
    return minMaxGame(newNums);
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。递归的每一层时间复杂度为 $O(n)$，每次递归到下一层时问题规模减半，所以总体复杂度为 $O(n) + O(\dfrac{n}{2}) + O(\dfrac{n}{4}) + \cdots + O(1) = O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。递归的每一层空间复杂度为 $O(n)$，每次递归到下一层时问题规模减半，所以总体复杂度为 $O(n) + O(\dfrac{n}{2}) + O(\dfrac{n}{4}) + \cdots + O(1) = O(n)$。除此之外，递归的栈空间为 $O(\log n)$，故总体复杂度为 $O(n)$。

#### 方法二：模拟

**思路与算法**

我们用一个循环来模拟整个过程，循环的条件是 $n \neq 1$，其中 $n$ 是 $\textit{nums}$ 的长度。循环内，我们按照题意求出 $\textit{newNums}$，然后用 $\textit{newNums}$ 替换 $\textit{nums}$ 即可。最后返回 $\textit{nums}[0]$ 作为答案。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int minMaxGame(vector<int>& nums) {
        int n = nums.size();
        while (n != 1) {
            vector<int> newNums(n / 2);
            for (int i = 0; i < newNums.size(); i++) {
                if (i % 2 == 0) {
                    newNums[i] = min(nums[2 * i], nums[2 * i + 1]);
                } else {
                    newNums[i] = max(nums[2 * i], nums[2 * i + 1]);
                }
            }
            nums = newNums;
            n /= 2;
        }
        return nums[0];
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minMaxGame(int[] nums) {
        int n = nums.length;
        while (n != 1) {
            int[] newNums = new int[n / 2];
            for (int i = 0; i < newNums.length; i++) {
                if (i % 2 == 0) {
                    newNums[i] = Math.min(nums[2 * i], nums[2 * i + 1]);
                } else {
                    newNums[i] = Math.max(nums[2 * i], nums[2 * i + 1]);
                }
            }
            nums = newNums;
            n /= 2;
        }
        return nums[0];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinMaxGame(int[] nums) {
        int n = nums.Length;
        while (n != 1) {
            int[] newNums = new int[n / 2];
            for (int i = 0; i < newNums.Length; i++) {
                if (i % 2 == 0) {
                    newNums[i] = Math.Min(nums[2 * i], nums[2 * i + 1]);
                } else {
                    newNums[i] = Math.Max(nums[2 * i], nums[2 * i + 1]);
                }
            }
            nums = newNums;
            n /= 2;
        }
        return nums[0];
    }
}
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minMaxGame(int* nums, int numsSize) {
    while (numsSize != 1) {
        numsSize /= 2;
        int newNums[numsSize];
        for (int i = 0; i < numsSize; i++) {
            if (i % 2 == 0) {
                newNums[i] = MIN(nums[2 * i], nums[2 * i + 1]);
            } else {
                newNums[i] = MAX(nums[2 * i], nums[2 * i + 1]);
            }
        }
        memcpy(nums, newNums, sizeof(int) * numsSize);
    }
    return nums[0];
}
```

```JavaScript [sol2-JavaScript]
var minMaxGame = function(nums) {
    let n = nums.length;
    while (n !== 1) {
        const newNums = new Array(Math.floor(n / 2)).fill(0);
        for (let i = 0; i < newNums.length; i++) {
            if (i % 2 === 0) {
                newNums[i] = Math.min(nums[2 * i], nums[2 * i + 1]);
            } else {
                newNums[i] = Math.max(nums[2 * i], nums[2 * i + 1]);
            }
        }
        nums = newNums;
        n = Math.floor(n / 2);
    }
    return nums[0];
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。第一次循环的时间复杂度为 $O(n)$，下一次循环时问题规模减半，所以总体复杂度为 $O(n) + O(\dfrac{n}{2}) + O(\dfrac{n}{4}) + \cdots + O(1) = O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

#### 方法三：原地修改

**思路与算法**

注意到在顺序遍历的情况下，$\textit{newNums}[i]$ 的计算结果可以直接存储到 $\textit{nums}[i]$ 中。这是因为 $\textit{nums}[i]$ 早在计算 $\textit{newNums}[\Big\lfloor \dfrac{i}{2} \Big\rfloor]$ 时就已经被使用，而且它在未来一定不会再被使用。有一个特例是 $i = 0$，但此时可以原地修改的原因是很显然的。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    int minMaxGame(vector<int>& nums) {
        int n = nums.size();
        while (n != 1) {
            int m = n / 2;
            for (int i = 0; i < m; i++) {
                if (i % 2 == 0) {
                    nums[i] = min(nums[2 * i], nums[2 * i + 1]);
                } else {
                    nums[i] = max(nums[2 * i], nums[2 * i + 1]);
                }
            }
            n = m;
        }
        return nums[0];
    }
};
```

```Java [sol3-Java]
class Solution {
    public int minMaxGame(int[] nums) {
        int n = nums.length;
        while (n != 1) {
            int m = n / 2;
            for (int i = 0; i < m; i++) {
                if (i % 2 == 0) {
                    nums[i] = Math.min(nums[2 * i], nums[2 * i + 1]);
                } else {
                    nums[i] = Math.max(nums[2 * i], nums[2 * i + 1]);
                }
            }
            n = m;
        }
        return nums[0];
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int MinMaxGame(int[] nums) {
        int n = nums.Length;
        while (n != 1) {
            int m = n / 2;
            for (int i = 0; i < m; i++) {
                if (i % 2 == 0) {
                    nums[i] = Math.Min(nums[2 * i], nums[2 * i + 1]);
                } else {
                    nums[i] = Math.Max(nums[2 * i], nums[2 * i + 1]);
                }
            }
            n = m;
        }
        return nums[0];
    }
}
```

```C [sol3-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minMaxGame(int* nums, int numsSize) {
    while (numsSize != 1) {
        numsSize /= 2;
        for (int i = 0; i < numsSize; i++) {
            if (i % 2 == 0) {
                nums[i] = MIN(nums[2 * i], nums[2 * i + 1]);
            } else {
                nums[i] = MAX(nums[2 * i], nums[2 * i + 1]);
            }
        }
    }
    return nums[0];
}
```

```JavaScript [sol3-JavaScript]
var minMaxGame = function(nums) {
    let n = nums.length;
    while (n !== 1) {
        const m = Math.floor(n / 2);
        for (let i = 0; i < m; i++) {
            if (i % 2 === 0) {
                nums[i] = Math.min(nums[2 * i], nums[2 * i + 1]);
            } else {
                nums[i] = Math.max(nums[2 * i], nums[2 * i + 1]);
            }
        }
        n = m;
    }
    return nums[0];
};
```

```go [sol1-Golang]
func minMaxGame(nums []int) int {
    n := len(nums)
    if n == 1 {
        return nums[0]
    }
    newNums := make([]int, n/2)
    for i := 0; i < n/2; i++ {
        if i%2 == 0 {
            newNums[i] = min(nums[i*2], nums[i*2+1])
        } else {
            newNums[i] = max(nums[i*2], nums[i*2+1])
        }
    }
    return minMaxGame(newNums)
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

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。第一次循环的时间复杂度为 $O(n)$，下一次循环时问题规模减半，所以总体复杂度为 $O(n) + O(\dfrac{n}{2}) + O(\dfrac{n}{4}) + \cdots + O(1) = O(n)$。

- 空间复杂度：$O(1)$。