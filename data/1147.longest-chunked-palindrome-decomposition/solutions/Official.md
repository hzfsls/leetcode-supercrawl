## [1147.段式回文 中文官方题解](https://leetcode.cn/problems/longest-chunked-palindrome-decomposition/solutions/100000/duan-shi-hui-wen-by-leetcode-solution-vanl)

#### 前言

本题解涉及到「滚动哈希」，关于「滚动哈希」或「Rabin-Karp 算法」的知识具体可以参考 [官方题解](https://leetcode.cn/problems/longest-happy-prefix/solutions/172436/zui-chang-kuai-le-qian-zhui-by-leetcode-solution/) 或者使用搜索引擎，本文将不再赘述。简单的讲就是通过字符串哈希后，我们可以通过 $O(1)$ 的时间开销得到某一段子字符的哈希值，并且若两段字符串的哈希值相同则我们假定两段字符串相同。

#### 方法一：贪心 + 双指针

**思路与算法**

题目首先给出一个长度为 $n$ 的字符串 $\textit{text}$，现在我们需要将其分割为 $k$ 个非空子字符串 $(\textit{subtext}_1,\textit{subtext}_2,\dots,\textit{subtext}_k)$，且需要满足对于 $1 \le i \le k$ 有 $\textit{subtext}_i = \textit{subtext}_{k - i + 1}$ 成立，并且全部字符串依次连接后等于 $\textit{text}$。现在我们需要计算 $k$ 可能的最大值。现在我们用 $\textit{text}[l, r]$ 来表示 $\textit{text}[l], \textit{text}[l + 1], \dots, \textit{text}[r]$ 这段字符串区间，给出贪心方案如下：

假设现在我们需要进行分割的非空字符串为 $\textit{text}[l,r]$，$0 \le l \le r < n$，则找到长度最短的能满足相同且无重叠的前后缀进行分割

- 若找不到，则 $\textit{text}[l,r]$ 整体作为一个段式回文直接返回 $1$。
- 否则此时该字符串可以被分割为前缀，中间部分与后缀字符串组成
  - 若中间部分字符串非空，则返回中间部分字符串能分割成的段式回文的最大数目加 $2$。
  - 否则字符串 $\textit{text}[l,r]$ 最多只能拆分为前后缀 $2$ 个段式回文，直接返回 $2$ 即可。

然后我们按照该方案，返回从字符串 $\textit{text}[0,n-1]$ 开始分割能得到的最多段式回文个数即可。

现在我们给出该贪心方案的证明：

假设现在给定一个字符串 $\textit{text}[l,r]$，它有两个长度分别为 $\textit{len}_1$ 和 $\textit{len}_2$ 的相同且无重叠的前后缀，其中 $\textit{len}_1 < \textit{len}_2$。现在我们需要证明，在对字符串 $\textit{text}[l,r]$ 进行分割时，选取长度为 $\textit{len}_1$ 的前后缀一定比选取长度为 $\textit{len}_2$ 的前后缀进行分割更优。

我们记字符串 $\textit{text}[l,r]$ 长度为 $\textit{len}_1$ 的前后缀为 $A$，此时的中间部分字符串为 $X$，长度为 $\textit{len}_2$ 的前后缀为 $AB$，此时的中间部分字符串为 $Y$，则我们有

$$\textit{text}[l,r]=(A)X(A)=(AB)Y(AB)$$

- 若字符串 $B$ 的长度大于等于 $A$，则 $B$ 可以被分割为 $CA$ 的形式，其中 $C$ 可以为空字符串。那么有
$$\textit{text}[l,r]=(ACA)Y(ACA)$$

此时我们可以在选取前缀为 $A$ 的基础上得到
$$\textit{text}[l,r]=(A)(C)(A)Y(A)(C)(A)$$

即此时我们可以比直接分割长度为 $\textit{len}_2$ 的前后缀多得到 $4$ 个段式回文，所以此时选取 $\textit{len}_1$ 的前后缀进行分割更优。
- 否则当字符串 $B$ 的长度小于 $A$ 时，字符串 $A$ 可以被分割为 $CB$ 的形式。有
$$\textit{text}[l,r]=(CBB)Y(CBB)$$

此时我们可以在选取前缀为 $A$ 的基础上得到
$$\textit{text}[l,r]=(A)(B)Y(B)(A)$$

即此时我们可以比直接分割长度为 $\textit{len}_2$ 的前后缀多得到 $2$ 个段式回文，所以此时选取 $\textit{len}_1$ 的前后缀进行分割更优。

综上，优先选取长度较小的前后缀进行分割一定是比选取长度较大的前后缀进行分割更优。即该贪心方案的正确性得证。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool judge(const string& text, int l1, int l2, int len) {
        while (len --) {
            if (text[l1] != text[l2]) {
                return false;
            }
            ++l1;
            ++l2;
        }
        return true;
    }
    int longestDecomposition(string text) {
        int n = text.size();
        int res = 0;
        int l = 0, r = n - 1;
        while (l <= r) {
            int len = 1;
            while (l + len - 1 < r - len + 1) {
                if (judge(text, l, r - len + 1, len)) {
                    res += 2;
                    break;
                }
                ++len;
            }
            if (l + len - 1 >= r - len + 1) {
                ++res;
            }
            l += len;
            r -= len;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int longestDecomposition(String text) {
        int n = text.length();
        int res = 0;
        int l = 0, r = n - 1;
        while (l <= r) {
            int len = 1;
            while (l + len - 1 < r - len + 1) {
                if (judge(text, l, r - len + 1, len)) {
                    res += 2;
                    break;
                }
                ++len;
            }
            if (l + len - 1 >= r - len + 1) {
                ++res;
            }
            l += len;
            r -= len;
        }
        return res;
    }

    public boolean judge(String text, int l1, int l2, int len) {
        while (len > 0) {
            if (text.charAt(l1) != text.charAt(l2)) {
                return false;
            }
            ++l1;
            ++l2;
            --len;
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LongestDecomposition(string text) {
        int n = text.Length;
        int res = 0;
        int l = 0, r = n - 1;
        while (l <= r) {
            int len = 1;
            while (l + len - 1 < r - len + 1) {
                if (Judge(text, l, r - len + 1, len)) {
                    res += 2;
                    break;
                }
                ++len;
            }
            if (l + len - 1 >= r - len + 1) {
                ++res;
            }
            l += len;
            r -= len;
        }
        return res;
    }

    public bool Judge(string text, int l1, int l2, int len) {
        while (len > 0) {
            if (text[l1] != text[l2]) {
                return false;
            }
            ++l1;
            ++l2;
            --len;
        }
        return true;
    }
}
```

```C [sol1-C]
bool judge(const char* text, int l1, int l2, int len) {
    while (len --) {
        if (text[l1] != text[l2]) {
            return false;
        }
        ++l1;
        ++l2;
    }
    return true;
}

int longestDecomposition(char * text){
    int n = strlen(text);
    int res = 0;
    int l = 0, r = n - 1;
    while (l <= r) {
        int len = 1;
        while (l + len - 1 < r - len + 1) {
            if (judge(text, l, r - len + 1, len)) {
                res += 2;
                break;
            }
            ++len;
        }
        if (l + len - 1 >= r - len + 1) {
            ++res;
        }
        l += len;
        r -= len;
    }
    return res;
}
```

```Python [sol1-Python3]
class Solution:
    def longestDecomposition(self, text: str) -> int:
        i, j = 0, len(text)-1
        count = 0
        left = ''
        right = ''
        while i <= j:
            left += text[i]
            right = text[j] + right
            if i == j:
                break
            else:
                if left == right:
                    left = ''
                    right = ''
                    count += 2
            i += 1
            j -= 1
        if left != '' and right != '':
            count += 1
        return count
```

```JavaScript [sol1-JavaScript]
var longestDecomposition = function(text) {
    const n = text.length;
    let res = 0;
    let l = 0, r = n - 1;
    while (l <= r) {
        let len = 1;
        while (l + len - 1 < r - len + 1) {
            if (judge(text, l, r - len + 1, len)) {
                res += 2;
                break;
            }
            ++len;
        }
        if (l + len - 1 >= r - len + 1) {
            ++res;
        }
        l += len;
        r -= len;
    }
    return res;
}

const judge = (text, l1, l2, len) => {
    while (len > 0) {
        if (text[l1] !== text[l2]) {
            return false;
        }
        ++l1;
        ++l2;
        --len;
    }
    return true;
};
```

```go [sol1-Golang]
func longestDecomposition(text string) int {
    if len(text) == 1 {
        return 1
    }
    k := 0
    str := text
    for len(str) > 0 {
        l := 1
        r := len(str)-1
        for l <= r {
            if str[:l] == str[r:] {
                k += 2
                str = str[l:r]
                break
            }
            l++
            r--
        }
        if l > r && len(str) > 0 {
            k++
            break
        }
    }
    return k
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为字符串 $\textit{text}$ 的长度，用「双指针」判断两字符串是否相等的时间复杂度为 $O(n)$，需要判断 $O(n)$ 次，所以总的时间复杂度为 $O(n^2)$。
- 空间复杂度：$O(1)$，仅使用常量空间。

#### 方法二：滚动哈希

**思路与算法**

在「方法一」的实现过程中，我们可以对字符串 $\textit{text}$ 进行「滚动哈希」预处理，这样在对于字符串判断某一个长度的前后缀是否相同时，可以在 $O(1)$ 时间得到前后缀的哈希值进行判断。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<long long> pre1, pre2;
    vector<long long> pow1, pow2;
    static constexpr int MOD1 = 1000000007;
    static constexpr int MOD2 = 1000000009;
    int Base1, Base2;

    void init(string& s) {
        mt19937 gen{random_device{}()};
        Base1 = uniform_int_distribution<int>(1e6, 1e7)(gen);
        Base2 = uniform_int_distribution<int>(1e6, 1e7)(gen);
        while (Base2 == Base1) {
            Base2 = uniform_int_distribution<int>(1e6, 1e7)(gen);
        }
        int n = s.size();
        pow1.resize(n);
        pow2.resize(n);
        pre1.resize(n + 1);
        pre2.resize(n + 1);
        pow1[0] = pow2[0] = 1;
        pre1[1] = pre2[1] = s[0];
        for (int i = 1; i < n; ++i) {
            pow1[i] = (pow1[i - 1] * Base1) % MOD1;
            pow2[i] = (pow2[i - 1] * Base2) % MOD2;
            pre1[i + 1] = (pre1[i] * Base1 + s[i]) % MOD1;
            pre2[i + 1] = (pre2[i] * Base2 + s[i]) % MOD2;
        }
    }

    pair<int, int> getHash(int l, int r) {
        return {(pre1[r + 1] - ((pre1[l] * pow1[r + 1 - l]) % MOD1) + MOD1) % MOD1, (pre2[r + 1] - ((pre2[l] * pow2[r + 1 - l]) % MOD2) + MOD2) % MOD2};
    }

    int longestDecomposition(string text) {
        init(text);
        int n = text.size();
        int res = 0;
        int l = 0, r = n - 1;
        while (l <= r) {
            int len = 1;
            while (l + len - 1 < r - len + 1) {
                if (getHash(l, l + len - 1) == getHash(r - len + 1, r)) {
                    res += 2;
                    break;
                }
                ++len;
            }
            if (l + len - 1 >= r - len + 1) {
                ++res;
            }
            l += len;
            r -= len;
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    long[] pre1;
    long[] pre2;
    long[] pow1;
    long[] pow2;
    static final int MOD1 = 1000000007;
    static final int MOD2 = 1000000009;
    int base1, base2;
    Random random = new Random();

    public int longestDecomposition(String text) {
        init(text);
        int n = text.length();
        int res = 0;
        int l = 0, r = n - 1;
        while (l <= r) {
            int len = 1;
            while (l + len - 1 < r - len + 1) {
                if (Arrays.equals(getHash(l, l + len - 1), getHash(r - len + 1, r))) {
                    res += 2;
                    break;
                }
                ++len;
            }
            if (l + len - 1 >= r - len + 1) {
                ++res;
            }
            l += len;
            r -= len;
        }
        return res;
    }

    public void init(String s) {
        base1 = 1000000 + random.nextInt(9000000);
        base2 = 1000000 + random.nextInt(9000000);
        while (base2 == base1) {
            base2 = 1000000 + random.nextInt(9000000);
        }
        int n = s.length();
        pow1 = new long[n];
        pow2 = new long[n];
        pre1 = new long[n + 1];
        pre2 = new long[n + 1];
        pow1[0] = pow2[0] = 1;
        pre1[1] = pre2[1] = s.charAt(0);
        for (int i = 1; i < n; i ++) {
            pow1[i] = (pow1[i - 1] * base1) % MOD1;
            pow2[i] = (pow2[i - 1] * base2) % MOD2;
            pre1[i + 1] = (pre1[i] * base1 + s.charAt(i)) % MOD1;
            pre2[i + 1] = (pre2[i] * base2 + s.charAt(i)) % MOD2;
        }
    }

    public long[] getHash(int l, int r) {
        return new long[]{(pre1[r + 1] - ((pre1[l] * pow1[r + 1 - l]) % MOD1) + MOD1) % MOD1, (pre2[r + 1] - ((pre2[l] * pow2[r + 1 - l]) % MOD2) + MOD2) % MOD2};
    }
}
```

```C# [sol2-C#]
public class Solution {
    long[] pre1;
    long[] pre2;
    long[] pow1;
    long[] pow2;
    const int MOD1 = 1000000007;
    const int MOD2 = 1000000009;
    int base1, base2;
    Random random = new Random();

    public int LongestDecomposition(string text) {
        Init(text);
        int n = text.Length;
        int res = 0;
        int l = 0, r = n - 1;
        while (l <= r) {
            int len = 1;
            while (l + len - 1 < r - len + 1) {
                if (Enumerable.SequenceEqual(GetHash(l, l + len - 1), GetHash(r - len + 1, r))) {
                    res += 2;
                    break;
                }
                ++len;
            }
            if (l + len - 1 >= r - len + 1) {
                ++res;
            }
            l += len;
            r -= len;
        }
        return res;
    }

    public void Init(String s) {
        base1 = 1000000 + random.Next(9000000);
        base2 = 1000000 + random.Next(9000000);
        while (base2 == base1) {
            base2 = 1000000 + random.Next(9000000);
        }
        int n = s.Length;
        pow1 = new long[n];
        pow2 = new long[n];
        pre1 = new long[n + 1];
        pre2 = new long[n + 1];
        pow1[0] = pow2[0] = 1;
        pre1[1] = pre2[1] = s[0];
        for (int i = 1; i < n; i ++) {
            pow1[i] = (pow1[i - 1] * base1) % MOD1;
            pow2[i] = (pow2[i - 1] * base2) % MOD2;
            pre1[i + 1] = (pre1[i] * base1 + s[i]) % MOD1;
            pre2[i + 1] = (pre2[i] * base2 + s[i]) % MOD2;
        }
    }

    public long[] GetHash(int l, int r) {
        return new long[]{(pre1[r + 1] - ((pre1[l] * pow1[r + 1 - l]) % MOD1) + MOD1) % MOD1, (pre2[r + 1] - ((pre2[l] * pow2[r + 1 - l]) % MOD2) + MOD2) % MOD2};
    }
}
```

```C [sol2-C]
static int MOD1 = 1000000007;
static int MOD2 = 1000000009;

void init(const char *s, int n, long long *pre1, long long *pre2, long long *pow1, long long *pow2) {
    srand(time(NULL));
    int Base1 = 1000000 + rand() % 9000000;
    int Base2 = 1000000 + rand() % 9000000;
    while (Base2 == Base1) {
        Base2 = 1000000 + rand() % 9000000;
    }
    pow1[0] = pow2[0] = 1;
    pre1[0] = pre2[0] = 0;
    pre1[1] = pre2[1] = s[0];
    for (int i = 1; i < n; ++i) {
        pow1[i] = (pow1[i - 1] * Base1) % MOD1;
        pow2[i] = (pow2[i - 1] * Base2) % MOD2;
        pre1[i + 1] = (pre1[i] * Base1 + s[i]) % MOD1;
        pre2[i + 1] = (pre2[i] * Base2 + s[i]) % MOD2;
    }
}

long long getHash(int l, int r, long long *pre1, long long *pre2, long long *pow1, long long *pow2) {
    int x = (pre1[r + 1] - ((pre1[l] * pow1[r + 1 - l]) % MOD1) + MOD1) % MOD1;
    int y = (pre2[r + 1] - ((pre2[l] * pow2[r + 1 - l]) % MOD2) + MOD2) % MOD2;
    return (long long) x << 32 | y;
}

int longestDecomposition(char * text) {
    int n = strlen(text);
    long long pre1[n + 1], pre2[n + 1];
    long long pow1[n], pow2[n];
    init(text, n, pre1, pre2, pow1, pow2);
    int res = 0;
    int l = 0, r = n - 1;
    while (l <= r) {
        int len = 1;
        while (l + len - 1 < r - len + 1) {
            if (getHash(l, l + len - 1, pre1, pre2, pow1, pow2) == getHash(r - len + 1, r, pre1, pre2, pow1, pow2)) {
                res += 2;
                break;
            }
            ++len;
        }
        if (l + len - 1 >= r - len + 1) {
            ++res;
        }
        l += len;
        r -= len;
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $\textit{text}$ 的长度，预处理字符串哈希的时间复杂度为 $O(n)$，双指针的时间复杂度为 $O(n)$。
- 空间复杂度：$O(n)$，其中 $n$ 为字符串 $\textit{text}$ 的长度，主要为预处理字符串哈希的空间开销。