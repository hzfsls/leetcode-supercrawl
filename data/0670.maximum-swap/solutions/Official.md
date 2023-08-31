## [670.最大交换 中文官方题解](https://leetcode.cn/problems/maximum-swap/solutions/100000/zui-da-jiao-huan-by-leetcode-solution-lnd5)

#### 方法一：直接遍历

由于对于整数 $\textit{num}$ 的十进制数字位长最长为 $8$ 位，任意两个数字交换一次最多有 $28$ 种不同的交换方法，因此我们可以尝试遍历所有可能的数字交换方法即可，并找到交换后的最大数字即可。
+ 我们将数字存储为长度为 $n$ 的列表，其中 $n$ 为整数 $\textit{num}$ 的十进制位数的长度。对于位置为 $\text{(i, j)}$ 的每个候选交换，我们交换数字并记录组成的新数字是否大于当前答案；
+ 对于前导零的问题，我们也不需要特殊处理。
+ 由于数字只有 $8$ 位，所以我们不必考虑交换后溢出的风险；

```Python [sol1-Python3]
class Solution:
    def maximumSwap(self, num: int) -> int:
        ans = num
        s = list(str(num))
        for i in range(len(s)):
            for j in range(i):
                s[i], s[j] = s[j], s[i]
                ans = max(ans, int(''.join(s)))
                s[i], s[j] = s[j], s[i]
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int maximumSwap(int num) {
        string charArray = to_string(num);
        int n = charArray.size();
        int maxNum = num;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                swap(charArray[i], charArray[j]);
                maxNum = max(maxNum, stoi(charArray));
                swap(charArray[i], charArray[j]);
            }
        }
        return maxNum;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maximumSwap(int num) {
        char[] charArray = String.valueOf(num).toCharArray();
        int n = charArray.length;
        int maxNum = num;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                swap(charArray, i, j);
                maxNum = Math.max(maxNum, Integer.parseInt(new String(charArray)));
                swap(charArray, i, j);
            }
        }
        return maxNum;
    }

    public void swap(char[] charArray, int i, int j) {
        char temp = charArray[i];
        charArray[i] = charArray[j];
        charArray[j] = temp;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaximumSwap(int num) {
        char[] charArray = num.ToString().ToCharArray();
        int n = charArray.Length;
        int maxNum = num;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                Swap(charArray, i, j);
                maxNum = Math.Max(maxNum, int.Parse(new string(charArray)));
                Swap(charArray, i, j);
            }
        }
        return maxNum;
    }

    public void Swap(char[] charArray, int i, int j) {
        char temp = charArray[i];
        charArray[i] = charArray[j];
        charArray[j] = temp;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MAX_LEN 32

static inline void swap(char* a, char* b) {
    char c = *a;
    *a = *b;
    *b = c;
}

int maximumSwap(int num) {
    char charArray[MAX_LEN];
    sprintf(charArray, "%d", num);
    int n = strlen(charArray);
    int maxNum = num;
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            swap(&charArray[i], &charArray[j]);
            maxNum = MAX(maxNum, atoi(charArray));
            swap(&charArray[i], &charArray[j]);
        }
    }
    return maxNum;
}
```

```JavaScript [sol1-JavaScript]
var maximumSwap = function(num) {
    const charArray = [...'' + num];
    const n = charArray.length;
    let maxNum = num;
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
            swap(charArray, i, j);
            maxNum = Math.max(maxNum, parseInt(charArray.join('')));
            swap(charArray, i, j);
        }
    }
    return maxNum;
}

const swap = (charArray, i, j) => {
    const temp = charArray[i];
    charArray[i] = charArray[j];
    charArray[j] = temp;
};
```

```go [sol1-Golang]
func maximumSwap(num int) int {
    ans := num
    s := []byte(strconv.Itoa(num))
    for i := range s {
        for j := range s[:i] {
            s[i], s[j] = s[j], s[i]
            v, _ := strconv.Atoi(string(s))
            ans = max(ans, v)
            s[i], s[j] = s[j], s[i]
        }
    }
    return ans
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(\log^3 \textit{num})$，其中整数 $\textit{num}$ 为给定的数字。$\textit{num}$ 转换为十进制数，有 $O(\log \textit{num})$ 个数字，一共有 $O(\log^2 \textit{num})$ 种不同的交换方法，每种方法需要重新构造一个新的整数，需要的时间为 $O(\log \textit{num})$，因此总的时间复杂度为 $O(\log^3 \textit{num})$。

- 空间复杂度：$O(\log \textit{num})$，其中整数 $\textit{num}$ 为给定的数字。$\textit{num}$ 转换为十进制数，有 $O(\log \textit{num})$ 个数字，需要保存 $\textit{num}$ 所有的数字。

#### 方法二：贪心

设整数 $\text{num}$ 从右向左的数字分别为 $(d_0, d_1, d_2, \cdots, d_{n-1})$，则此时我们可以知道: $\textit{num} = \sum_{i=0}^{n-1} d_{i} \times 10^{i}$，假设我们对位于 $j, k$ 位上的数字进行交换，其中满足 $0 \le j < k < n$，则可以知道交换后的值 $\text{val}$ 如下:
$$
\text{val} = \sum_{i=0}^{n-1} (d_{i} \times 10^{i}) + (d_j - d_k) \times 10 ^ k - (d_j - d_k) \times 10 ^ j \\
= \sum_{i=0}^{n-1} (d_{i} \times 10^{i}) + (d_j - d_k) \times (10 ^ k  - 10 ^ j)
$$
根据以上等式我们可以看出，若使得 $\textit{val}$ 的值最大，应依次满足如下条件：
+ 最优的交换一定需要满足 $d_j > d_k$；
+ 在满足 $d_j > d_k$ 时，应该保证索引 $k$ 越大从而使得数字 $\textit{val}$ 越大；
+ 在同样大小的数字 $d_k$ 时，应使得数字 $d_j$ 越大从而使得 $\textit{val}$ 越大；
+ 在同样大小的数字 $d_j$ 时，应使得索引 $j$ 越小从而使得 $\textit{val}$ 越大；

通过以上可以观察到右边越大的数字与左边较小的数字进行交换，这样产生的整数才能保证越大。因此我们可以利用贪心法则，尝试将数字中右边较大的数字与左边较小的数字进行交换，这样即可保证得到的整数值最大。具体做法如下：
+ 我们将从右向左扫描数字数组，并记录当前已经扫描过的数字的最大值的索引为 $\textit{maxId}$ 且保证 $\textit{maxId}$ 越靠近数字的右侧，此时则说明 $\textit{charArray}[\textit{maxId}]$ 则为当前已经扫描过的最大值。
+ 如果检测到当前数字 $\textit{charArray}[i] < \textit{charArray}[\textit{maxId}]$，此时则说明索引 $i$ 的右侧的数字最大值为 $\textit{charArray}[\textit{maxId}]$，此时我们可以尝试将 $\textit{charArray}[i]$ 与 $\textit{charArray}[\textit{maxId}]$ 进行交换即可得到一个比 $\textit{num}$ 更大的值。我们尝试记录当前可以交换的数对 $(i, \textit{maxId})$，根据贪心法则，此时最左边的 $i$ 构成的可交换的数对进行交换后形成的整数值最大。

```Python [sol2-Python3]
class Solution:
    def maximumSwap(self, num: int) -> int:
        s = list(str(num))
        n = len(s)
        maxIdx = n - 1
        idx1 = idx2 = -1
        for i in range(n - 1, -1, -1):
            if s[i] > s[maxIdx]:
                maxIdx = i
            elif s[i] < s[maxIdx]:
                idx1, idx2 = i, maxIdx
        if idx1 < 0:
            return num
        s[idx1], s[idx2] = s[idx2], s[idx1]
        return int(''.join(s))
```

```C++ [sol2-C++]
class Solution {
public:
    int maximumSwap(int num) {
        string charArray = to_string(num);
        int n = charArray.size();
        int maxIdx = n - 1;
        int idx1 = -1, idx2 = -1;
        for (int i = n - 1; i >= 0; i--) {
            if (charArray[i] > charArray[maxIdx]) {
                maxIdx = i;
            } else if (charArray[i] < charArray[maxIdx]) {
                idx1 = i;
                idx2 = maxIdx;
            }
        }
        if (idx1 >= 0) {
            swap(charArray[idx1], charArray[idx2]);
            return stoi(charArray);
        } else {
            return num;
        }
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maximumSwap(int num) {
        char[] charArray = String.valueOf(num).toCharArray();
        int n = charArray.length;
        int maxIdx = n - 1;
        int idx1 = -1, idx2 = -1;
        for (int i = n - 1; i >= 0; i--) {
            if (charArray[i] > charArray[maxIdx]) {
                maxIdx = i;
            } else if (charArray[i] < charArray[maxIdx]) {
                idx1 = i;
                idx2 = maxIdx;
            }
        }
        if (idx1 >= 0) {
            swap(charArray, idx1, idx2);
            return Integer.parseInt(new String(charArray));
        } else {
            return num;
        }
    }

    public void swap(char[] charArray, int i, int j) {
        char temp = charArray[i];
        charArray[i] = charArray[j];
        charArray[j] = temp;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaximumSwap(int num) {
        char[] charArray = num.ToString().ToCharArray();
        int n = charArray.Length;
        int maxIdx = n - 1;
        int idx1 = -1, idx2 = -1;
        for (int i = n - 1; i >= 0; i--) {
            if (charArray[i] > charArray[maxIdx]) {
                maxIdx = i;
            } else if (charArray[i] < charArray[maxIdx]) {
                idx1 = i;
                idx2 = maxIdx;
            }
        }
        if (idx1 >= 0) {
            Swap(charArray, idx1, idx2);
            return int.Parse(new string(charArray));
        } else {
            return num;
        }
    }

    public void Swap(char[] charArray, int i, int j) {
        char temp = charArray[i];
        charArray[i] = charArray[j];
        charArray[j] = temp;
    }
}
```

```C [sol2-C]
#define MAX_LEN 32

static inline void swap(char* a, char* b) {
    char c = *a;
    *a = *b;
    *b = c;
}

int maximumSwap(int num) {
    char charArray[MAX_LEN];
    sprintf(charArray, "%d", num);
    int n = strlen(charArray);
    char maxIdx = n - 1;
    int idx1 = -1, idx2 = -1;
    for (int i = n - 1; i >= 0; i--) {
        if (charArray[i] > charArray[maxIdx]) {
            maxIdx = i;
        } else if (charArray[i] < charArray[maxIdx]) {
            idx1 = i;
            idx2 = maxIdx;
        }
    }
    if (idx1 >= 0) {
        swap(&charArray[idx1], &charArray[idx2]);
        return atoi(charArray);
    } else {
        return num;
    }
}
```

```JavaScript [sol2-JavaScript]
var maximumSwap = function(num) {
    const charArray = [...'' + num];
    const n = charArray.length;
    let maxIdx = n - 1;
    let idx1 = -1, idx2 = -1;
    for (let i = n - 1; i >= 0; i--) {
        if (charArray[i] > charArray[maxIdx]) {
            maxIdx = i;
        } else if (charArray[i] < charArray[maxIdx]) {
            idx1 = i;
            idx2 = maxIdx;
        }
    }
    if (idx1 >= 0) {
        swap(charArray, idx1, idx2);
        return parseInt(charArray.join(''));
    } else {
        return num;
    }
}

const swap = (charArray, i, j) => {
    const temp = charArray[i];
    charArray[i] = charArray[j];
    charArray[j] = temp;
};
```

```go [sol2-Golang]
func maximumSwap(num int) int {
    s := []byte(strconv.Itoa(num))
    n := len(s)
    maxIdx, idx1, idx2 := n-1, -1, -1
    for i := n - 1; i >= 0; i-- {
        if s[i] > s[maxIdx] {
            maxIdx = i
        } else if s[i] < s[maxIdx] {
            idx1, idx2 = i, maxIdx
        }
    }
    if idx1 < 0 {
        return num
    }
    s[idx1], s[idx2] = s[idx2], s[idx1]
    v, _ := strconv.Atoi(string(s))
    return v
}
```

**复杂度分析**

- 时间复杂度：$O(\log \textit{num})$，其中整数 $\textit{num}$ 为给定的数字。$\textit{num}$ 转换为十进制数，有 $O(\log \textit{num})$ 个数字，需要遍历一次所有的数字即可。

- 空间复杂度：$O(\log \textit{num})$，其中整数 $\textit{num}$ 为给定的数字。$\textit{num}$ 转换为十进制数，有 $O(\log \textit{num})$ 个数字，需要保存 $\textit{num}$ 所有的数字。