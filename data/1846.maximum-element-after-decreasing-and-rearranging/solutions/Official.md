#### 方法一：排序 + 贪心

提示 $1$

如果一个数组是满足要求的，那么将它的元素按照升序排序后得到的数组也是满足要求的。

提示 $1$ 解释

假设数组中出现了元素 $x$ 和 $y$，且 $x<y$，由于相邻元素差值的绝对值小于等于 $1$，那么区间 $[x,y]$ 内的所有整数应该都出现过。

只要我们令 $x$ 和 $y$ 分别为数组中元素的最小值和最大值，就说明了将数组升序排序后，得到的结果是不会出现「断层」的，也就是满足要求的。

提示 $2$

在提示 $1$ 的基础上，我们得到了一个单调递增的数组。那么数组中相邻两个元素，要么后者等于前者，要么后者等于前者加上 $1$。

我们可以先将数组进行升序排序，随后对数组进行遍历，将 $\textit{arr}[i]$ 更新为其自身与 $\textit{arr}[i-1]+1$ 中的较小值即可。

最终的答案（最大值）即为 $\textit{arr}$ 中的最后一个元素。

```C++ [sol1-C++]
class Solution {
public:
    int maximumElementAfterDecrementingAndRearranging(vector<int> &arr) {
        int n = arr.size();
        sort(arr.begin(), arr.end());
        arr[0] = 1;
        for (int i = 1; i < n; ++i) {
            arr[i] = min(arr[i], arr[i - 1] + 1);
        }
        return arr.back();
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maximumElementAfterDecrementingAndRearranging(int[] arr) {
        int n = arr.length;
        Arrays.sort(arr);
        arr[0] = 1;
        for (int i = 1; i < n; ++i) {
            arr[i] = Math.min(arr[i], arr[i - 1] + 1);
        }
        return arr[n - 1];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaximumElementAfterDecrementingAndRearranging(int[] arr) {
        int n = arr.Length;
        Array.Sort(arr);
        arr[0] = 1;
        for (int i = 1; i < n; ++i) {
            arr[i] = Math.Min(arr[i], arr[i - 1] + 1);
        }
        return arr[n - 1];
    }
}
```

```go [sol1-Golang]
func maximumElementAfterDecrementingAndRearranging(arr []int) int {
    n := len(arr)
    sort.Ints(arr)
    arr[0] = 1
    for i := 1; i < n; i++ {
        arr[i] = min(arr[i], arr[i-1]+1)
    }
    return arr[n-1]
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var maximumElementAfterDecrementingAndRearranging = function(arr) {
    const n = arr.length;
    arr.sort((a, b) => a - b);
    arr[0] = 1;
    for (let i = 1; i < n; ++i) {
        arr[i] = Math.min(arr[i], arr[i - 1] + 1);
    }
    return arr[n - 1];
};
```

```C [sol1-C]
int cmp(int *a, int *b) {
    return *a - *b;
}

int maximumElementAfterDecrementingAndRearranging(int *arr, int arrSize) {
    qsort(arr, arrSize, sizeof(int), cmp);
    arr[0] = 1;
    for (int i = 1; i < arrSize; ++i) {
        arr[i] = fmin(arr[i], arr[i - 1] + 1);
    }
    return arr[arrSize - 1];
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。时间复杂度即排序的复杂度。

- 空间复杂度：$O(\log n)$。空间复杂度不考虑输入，因此空间复杂度主要取决于排序时产生的 $O(\log n)$ 的栈空间。


#### 方法二：计数排序 + 贪心

深挖题目隐含的性质，我们可以将时间复杂度优化至 $O(n)$。

记 $\textit{arr}$ 的长度为 $n$。由于第一个元素必须为 $1$，且任意两个相邻元素的差的绝对值小于等于 $1$，故答案不会超过 $n$。所以我们只需要对 $\textit{arr}$ 中值不超过 $n$ 的元素进行计数排序，而对于值超过 $n$ 的元素，由于其至少要减小到 $n$，我们可以将其视作 $n$。

读者可据此修改方法一中的排序代码，此处不再赘述，我们将重点转到另一种计算策略上。

从另一个视角来看，为了尽可能地构造出最大的答案，我们相当于是在用 $\textit{arr}$ 中的元素去填补自身在 $[1,n]$ 中缺失的元素。

首先，我们用一个长为 $n+1$ 的数组 $\textit{cnt}$ 统计 $\textit{arr}$ 中的元素个数（将值超过 $n$ 的元素视作 $n$）。然后，从 $1$ 到 $n$ 遍历 $\textit{cnt}$ 数组，若 $\textit{cnt}[i]=0$，则说明缺失元素 $i$，我们需要在后续找一个大于 $i$ 的元素，将其变更为 $i$。我们可以用一个变量 $\textit{miss}$ 记录 $\textit{cnt}[i]=0$ 的出现次数，当遇到 $\textit{cnt}[i]>0$ 时，则可以将多余的 $\textit{cnt}[i]-1$ 个元素减小，补充到之前缺失的元素上。

遍历 $\textit{cnt}$ 结束后，若此时 $\textit{miss}=0$，则说明修改后的 $\textit{arr}$ 包含了 $[1,n]$ 内的所有整数；否则，对于不同大小的缺失元素，我们总是优先填补较小的，因此剩余缺失元素必然是 $[n-\textit{miss}+1,n]$ 这一范围内的 $\textit{miss}$ 个数，因此答案为 $n-\textit{miss}$。

```C++ [sol2-C++]
class Solution {
public:
    int maximumElementAfterDecrementingAndRearranging(vector<int> &arr) {
        int n = arr.size();
        vector<int> cnt(n + 1);
        for (int v : arr) {
            ++cnt[min(v, n)];
        }
        int miss = 0;
        for (int i = 1; i <= n; ++i) {
            if (cnt[i] == 0) {
                ++miss;
            } else {
                miss -= min(cnt[i] - 1, miss); // miss 不会小于 0，故至多减去 miss 个元素
            }
        }
        return n - miss;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maximumElementAfterDecrementingAndRearranging(int[] arr) {
        int n = arr.length;
        int[] cnt = new int[n + 1];
        for (int v : arr) {
            ++cnt[Math.min(v, n)];
        }
        int miss = 0;
        for (int i = 1; i <= n; ++i) {
            if (cnt[i] == 0) {
                ++miss;
            } else {
                miss -= Math.min(cnt[i] - 1, miss); // miss 不会小于 0，故至多减去 miss 个元素
            }
        }
        return n - miss;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaximumElementAfterDecrementingAndRearranging(int[] arr) {
        int n = arr.Length;
        int[] cnt = new int[n + 1];
        foreach (int v in arr) {
            ++cnt[Math.Min(v, n)];
        }
        int miss = 0;
        for (int i = 1; i <= n; ++i) {
            if (cnt[i] == 0) {
                ++miss;
            } else {
                miss -= Math.Min(cnt[i] - 1, miss); // miss 不会小于 0，故至多减去 miss 个元素
            }
        }
        return n - miss;
    }
}
```

```go [sol2-Golang]
func maximumElementAfterDecrementingAndRearranging(arr []int) int {
    n := len(arr)
    cnt := make([]int, n+1)
    for _, v := range arr {
        cnt[min(v, n)]++
    }
    miss := 0
    for _, c := range cnt[1:] {
        if c == 0 {
            miss++
        } else {
            miss -= min(c-1, miss) // miss 不会小于 0，故至多减去 miss 个元素
        }
    }
    return n - miss
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol2-JavaScript]
var maximumElementAfterDecrementingAndRearranging = function(arr) {
    const n = arr.length;
    const cnt = new Array(n + 1).fill(0);
    for (const v of arr) {
        ++cnt[Math.min(v, n)];
    }
    let miss = 0;
    for (let i = 1; i <= n; ++i) {
        if (cnt[i] == 0) {
            ++miss;
        } else {
            miss -= Math.min(cnt[i] - 1, miss); // miss 不会小于 0，故至多减去 miss 个元素
        }
    }
    return n - miss;
};
```

```C [sol2-C]
int maximumElementAfterDecrementingAndRearranging(int *arr, int arrSize) {
    int cnt[arrSize + 1];
    memset(cnt, 0, sizeof(cnt));
    for (int i = 0; i < arrSize; i++) {
        cnt[(int)fmin(arr[i], arrSize)]++;
    }
    int miss = 0;
    for (int i = 1; i <= arrSize; ++i) {
        if (cnt[i] == 0) {
            ++miss;
        } else {
            miss -= fmin(cnt[i] - 1, miss);  // miss 不会小于 0，故至多减去 miss 个元素
        }
    }
    return arrSize - miss;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。我们仅需遍历 $\textit{arr}$ 数组和 $\textit{cnt}$ 数组各一次，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$。需要创建长度为 $n+1$ 的数组 $\textit{cnt}$。