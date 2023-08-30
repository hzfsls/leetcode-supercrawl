#### 前言

假定字符串 $s$ 和 $t$ 的长度均为 $n$，对于任意 $0 \le i<n$，将 $s[i]$ 变成 $t[i]$ 的开销是 $\Big| s[i]-t[i] \Big|$，因此可以创建一个长度为 $n$ 的数组 $\textit{diff}$，其中 $\textit{diff}[i]=\Big|s[i]-t[i] \Big|$。

创建数组 $\textit{diff}$ 之后，问题转化成计算数组 $\textit{diff}$ 的元素和不超过 $\textit{maxCost}$ 的最长子数组的长度。有两种方法可以解决，第一种方法是前缀和 + 二分查找，第二种方法是滑动窗口。

#### 方法一：前缀和 + 二分查找

首先计算数组 $\textit{diff}$ 的前缀和，创建长度为 $n+1$ 的数组 $\textit{accDiff}$，其中 $\textit{accDiff}[0]=0$，对于 $0 \le i< n$，有 $\textit{accDiff}[i+1]=\textit{accDiff}[i]+\textit{diff}[i]$。

即当 $1 \le i \le n$ 时，$\textit{accDiff}[i]$ 为 $\textit{diff}$ 从下标 $0$ 到下标 $i-1$ 的元素和：

$$
\textit{accDiff}[i]=\sum\limits_{j=0}^{i-1} \textit{diff}[j]
$$

当 $\textit{diff}$ 的子数组以下标 $j$ 结尾时，需要找到最小的下标 $k$（$k \le j$），使得 $\textit{diff}$ 从下标 $k$ 到 $j$ 的元素和不超过 $\textit{maxCost}$，此时子数组的长度是 $j-k+1$。由于已经计算出前缀和数组 $\textit{accDiff}$，因此可以通过 $\textit{accDiff}$ 得到 $\textit{diff}$ 从下标 $k$ 到 $j$ 的元素和：

$$
\begin{aligned}
&\quad \ \sum\limits_{i=k}^j \textit{diff}[k] \\
&= \sum\limits_{i=0}^j \textit{diff}[i] - \sum\limits_{i=0}^{k-1} \textit{diff}[i] \\
&= \textit{accDiff}[j+1] - \textit{accDiff}[k]
\end{aligned}
$$

因此，找到最小的下标 $k$（$k \le j$），使得 $\textit{diff}$ 从下标 $k$ 到 $j$ 的元素和不超过 $\textit{maxCost}$，等价于找到最小的下标 $k$（$k \le j$），使得 $\textit{accDiff}[j+1] - \textit{accDiff}[k] \le \textit{maxCost}$。

由于 $\textit{diff}$ 的的每个元素都是非负的，因此 $\textit{accDiff}$ 是递增的，对于每个下标 $j$，可以通过在 $\textit{accDiff}$ 内进行二分查找的方法找到符合要求的最小的下标 $k$。

以下是具体实现方面的细节。

- 不需要计算数组 $\textit{diff}$ 的元素值，而是可以根据字符串 $s$ 和 $t$ 的对应位置字符直接计算 $\textit{accDiff}$ 的元素值。

- 对于下标范围 $[1,n]$ 内的每个 $i$，通过二分查找的方式，在下标范围 $[0,i]$ 内找到最小的下标 $\textit{start}$，使得 $\textit{accDiff}[\textit{start}] \ge \textit{accDiff}[i]-\textit{maxCost}$，此时对应的 $\textit{diff}$ 的子数组的下标范围是从 $\textit{start}$ 到 $i-1$，子数组的长度是 $i-\textit{start}$。

- 遍历下标范围 $[1,n]$ 内的每个 $i$ 之后，即可得到符合要求的最长子数组的长度，即字符串可以转化的最大长度。

```Java [sol1-Java]
class Solution {
    public int equalSubstring(String s, String t, int maxCost) {
        int n = s.length();
        int[] accDiff = new int[n + 1];
        for (int i = 0; i < n; i++) {
            accDiff[i + 1] = accDiff[i] + Math.abs(s.charAt(i) - t.charAt(i));
        }
        int maxLength = 0;
        for (int i = 1; i <= n; i++) {
            int start = binarySearch(accDiff, i, accDiff[i] - maxCost);
            maxLength = Math.max(maxLength, i - start);
        }
        return maxLength;
    }

    public int binarySearch(int[] accDiff, int endIndex, int target) {
        int low = 0, high = endIndex;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (accDiff[mid] < target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```JavaScript [sol1-JavaScript]
var equalSubstring = function(s, t, maxCost) {
    const n = s.length;
    const accDiff = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) {
        accDiff[i + 1] = accDiff[i] + Math.abs(s[i].charCodeAt() - t[i].charCodeAt());
    }
    let maxLength = 0;
    for (let i = 1; i <= n; i++) {
        const start = binarySearch(accDiff, i, accDiff[i] - maxCost);
        maxLength = Math.max(maxLength, i - start);
    }
    return maxLength;
};

const binarySearch = (accDiff, endIndex, target) => {
    let low = 0, high = endIndex;
    while (low < high) {
        const mid = Math.floor((high - low) / 2) + low;
        if (accDiff[mid] < target) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
}
```

```C++ [sol1-C++]
class Solution {
public:
    int binarySearch(const vector<int>& accDiff, int endIndex, int target) {
        int low = 0, high = endIndex;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (accDiff[mid] < target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }

    int equalSubstring(string s, string t, int maxCost) {
        int n = s.length();
        vector<int> accDiff(n + 1, 0);
        for (int i = 0; i < n; i++) {
            accDiff[i + 1] = accDiff[i] + abs(s[i] - t[i]);
        }
        int maxLength = 0;
        for (int i = 1; i <= n; i++) {
            int start = binarySearch(accDiff, i, accDiff[i] - maxCost);
            maxLength = max(maxLength, i - start);
        }
        return maxLength;
    }
};
```

```go [sol1-Golang]
func equalSubstring(s string, t string, maxCost int) (maxLen int) {
    n := len(s)
    accDiff := make([]int, n+1)
    for i, ch := range s {
        accDiff[i+1] = accDiff[i] + abs(int(ch)-int(t[i]))
    }
    for i := 1; i <= n; i++ {
        start := sort.SearchInts(accDiff[:i], accDiff[i]-maxCost)
        maxLen = max(maxLen, i-start)
    }
    return
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol1-Python3]
class Solution:
    def equalSubstring(self, s: str, t: str, maxCost: int) -> int:
        n = len(s)
        accDiff = [0] + list(accumulate(abs(ord(sc) - ord(tc)) for sc, tc in zip(s, t)))
        maxLength = 0

        for i in range(1, n + 1):
            start = bisect.bisect_left(accDiff, accDiff[i] - maxCost)
            maxLength = max(maxLength, i - start)
        
        return maxLength
```

```C [sol1-C]
int binarySearch(int* accDiff, int endIndex, int target) {
    int low = 0, high = endIndex;
    while (low < high) {
        int mid = (high - low) / 2 + low;
        if (accDiff[mid] < target) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
}

int equalSubstring(char* s, char* t, int maxCost) {
    int n = strlen(s);
    int accDiff[n + 1];
    memset(accDiff, 0, sizeof(accDiff));
    for (int i = 0; i < n; i++) {
        accDiff[i + 1] = accDiff[i] + fabs(s[i] - t[i]);
    }
    int maxLength = 0;
    for (int i = 1; i <= n; i++) {
        int start = binarySearch(accDiff, i, accDiff[i] - maxCost);
        maxLength = fmax(maxLength, i - start);
    }
    return maxLength;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是字符串的长度。
  计算前缀和数组 $\textit{accDiff}$ 的时间复杂度是 $O(n)$。
  需要进行 $n$ 次二分查找，每次二分查找的时间复杂度是 $O(\log n)$，二分查找共需要 $O(n \log n)$ 的时间。
  因此总时间复杂度是 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是字符串的长度。需要创建长度为 $n+1$ 的前缀和数组 $\textit{accDiff}$。

#### 方法二：滑动窗口

由于 $\textit{diff}$ 的的每个元素都是非负的，因此可以用滑动窗口的方法得到符合要求的最长子数组的长度。

滑动窗口的思想是，维护两个指针 $\textit{start}$ 和 $\textit{end}$ 表示数组 $\textit{diff}$ 的子数组的开始下标和结束下标，满足子数组的元素和不超过 $\textit{maxCost}$，子数组的长度是 $\textit{end}-\textit{start}+1$。初始时，$\textit{start}$ 和 $\textit{end}$ 的值都是 $0$。

另外还要维护子数组的元素和 $\textit{sum}$，初始值为 $0$。在移动两个指针的过程中，更新 $\textit{sum}$ 的值，判断子数组的元素和是否大于 $\textit{maxCost}$，并决定应该如何移动指针。

为了得到符合要求的最长子数组的长度，应遵循以下两点原则：

- 当 $\textit{start}$ 的值固定时，$\textit{end}$ 的值应尽可能大；

- 当 $\textit{end}$ 的值固定时，$\textit{start}$ 的值应尽可能小。

基于上述原则，滑动窗口的做法如下：

- 将 $\textit{diff}[\textit{end}]$ 的值加到 $\textit{sum}$；

- 如果 $\textit{sum} \le \textit{maxCost}$，则子数组的元素和不超过 $\textit{maxCost}$，使用当前子数组的长度 $\textit{end}-\textit{start}+1$ 更新最大子数组的长度；

- 如果 $\textit{sum}>\textit{maxCost}$，则子数组的元素和大于 $\textit{maxCost}$，需要向右移动指针 $\textit{start}$ 并同时更新 $\textit{sum}$ 的值，直到 $\textit{sum} \le \textit{maxCost}$，此时子数组的元素和不超过 $\textit{maxCost}$，使用子数组的长度 $\textit{end}-\textit{start}+1$ 更新最大子数组的长度；

- 将指针 $\textit{end}$ 右移一位，重复上述步骤，直到 $\textit{end}$ 超出数组下标范围。

遍历结束之后，即可得到符合要求的最长子数组的长度，即字符串可以转化的最大长度。

```Java [sol2-Java]
class Solution {
    public int equalSubstring(String s, String t, int maxCost) {
        int n = s.length();
        int[] diff = new int[n];
        for (int i = 0; i < n; i++) {
            diff[i] = Math.abs(s.charAt(i) - t.charAt(i));
        }
        int maxLength = 0;
        int start = 0, end = 0;
        int sum = 0;
        while (end < n) {
            sum += diff[end];
            while (sum > maxCost) {
                sum -= diff[start];
                start++;
            }
            maxLength = Math.max(maxLength, end - start + 1);
            end++;
        }
        return maxLength;
    }
}
```

```JavaScript [sol2-JavaScript]
var equalSubstring = function(s, t, maxCost) {
    const n = s.length;
    const diff = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        diff[i] = Math.abs(s[i].charCodeAt() - t[i].charCodeAt());
    }
    let maxLength = 0;
    let start = 0, end = 0;
    let sum = 0;
    while (end < n) {
        sum += diff[end];
        while (sum > maxCost) {
            sum -= diff[start];
            start++;
        }
        maxLength = Math.max(maxLength, end - start + 1);
        end++;
    }
    return maxLength;
};
```

```C++ [sol2-C++]
class Solution {
public:
    int equalSubstring(string s, string t, int maxCost) {
        int n = s.length();
        vector<int> diff(n, 0);
        for (int i = 0; i < n; i++) {
            diff[i] = abs(s[i] - t[i]);
        }
        int maxLength = 0;
        int start = 0, end = 0;
        int sum = 0;
        while (end < n) {
            sum += diff[end];
            while (sum > maxCost) {
                sum -= diff[start];
                start++;
            }
            maxLength = max(maxLength, end - start + 1);
            end++;
        }
        return maxLength;
    }
};
```

```go [sol2-Golang]
func equalSubstring(s string, t string, maxCost int) (maxLen int) {
    n := len(s)
    diff := make([]int, n)
    for i, ch := range s {
        diff[i] = abs(int(ch) - int(t[i]))
    }
    sum, start := 0, 0
    for end, d := range diff {
        sum += d
        for sum > maxCost {
            sum -= diff[start]
            start++
        }
        maxLen = max(maxLen, end-start+1)
    }
    return
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol2-Python3]
class Solution:
    def equalSubstring(self, s: str, t: str, maxCost: int) -> int:
        n = len(s)
        diff = [abs(ord(sc) - ord(tc)) for sc, tc in zip(s, t)]
        maxLength = start = end = 0
        total = 0

        while end < n:
            total += diff[end]
            while total > maxCost:
                total -= diff[start]
                start += 1
            maxLength = max(maxLength, end - start + 1)
            end += 1
        
        return maxLength
```

```C [sol2-C]
int equalSubstring(char* s, char* t, int maxCost) {
    int n = strlen(s);
    int diff[n];
    memset(diff, 0, sizeof(diff));
    for (int i = 0; i < n; i++) {
        diff[i] = fabs(s[i] - t[i]);
    }
    int maxLength = 0;
    int start = 0, end = 0;
    int sum = 0;
    while (end < n) {
        sum += diff[end];
        while (sum > maxCost) {
            sum -= diff[start];
            start++;
        }
        maxLength = fmax(maxLength, end - start + 1);
        end++;
    }
    return maxLength;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。
  计算数组 $\textit{diff}$ 的时间复杂度是 $O(n)$。
  遍历数组的过程中，两个指针的移动次数都不会超过 $n$ 次。
  因此总时间复杂度是 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是字符串的长度。需要创建长度为 $n$ 的数组 $\textit{diff}$。