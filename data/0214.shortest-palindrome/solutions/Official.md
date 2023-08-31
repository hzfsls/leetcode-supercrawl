## [214.最短回文串 中文官方题解](https://leetcode.cn/problems/shortest-palindrome/solutions/100000/zui-duan-hui-wen-chuan-by-leetcode-solution)
#### 前言

我们需要在给定的字符串 $s$ 的前面添加字符串 $s'$，得到**最短的**回文串。这里我们用 $s'+s$ 表示得到的回文串。显然，这等价于找到**最短的**字符串 $s'$，使得 $s'+s$ 是一个回文串。

由于我们一定可以将 $s$ 去除第一个字符后得到的字符串反序地添加在 $s$ 的前面得到一个回文串，因此一定有 $|s'| < |s|$，其中 $|s|$ 表示字符串 $s$ 的长度。

> 例如当 $s = \text{abccda}$ 时，我们可以将 $\text{bccda}$ 的反序 $\text{adccb}$ 添加在前面得到回文串 $\text{adccbabccda}$。

这样一来，我们可以将 $s$ 分成两部分：

- 长度为 $|s| - |s'|$ 的前缀 $s_1$；

- 长度为 $|s'|$ 的后缀 $s_2$。

由于 $s'+s$ 是一个回文串，那么 $s'$ 的反序就必然与 $s_2$ 相同，并且 $s_1$ 本身就是一个回文串。因此，要找到**最短的** $s'$，等价于找到**最长的** $s_1$。也就是说，我们需要在字符串 $s$ 中超出一个**最长的**前缀 $s_1$，它是一个回文串。当我们找到 $s_1$ 后，剩余的部分即为 $s_2$，其反序即为 $s'$。

要想找到 $s_1$，最简单的方法就是暴力地枚举 $s_1$ 的结束位置，并判断其是否是一个回文串。但该方法的时间复杂度为 $O(|s|^2)$，无法通过本题。因此，我们需要使用更优秀的方法。

#### 方法一：字符串哈希

**思路**

我们可以用 Rabin-Karp 字符串哈希算法来找出最长的回文串。

在该方法中，我们将字符串看成一个 $\textit{base}$ 进制的数，它对应的十进制值就是哈希值。显然，两个字符串的哈希值相等，当且仅当这两个字符串本身相同。然而如果字符串本身很长，其对应的十进制值在大多数语言中无法使用内置的整数类型进行存储。因此，我们会将十进制值对一个大质数 $\textit{mod}$ 进行取模。此时：

- 如果两个字符串的哈希值在取模后不相等，那么这两个字符串本身一定不相同；

- 如果两个字符串的哈希值在取模后相等，并不能代表这两个字符串本身一定相同。例如两个字符串的哈希值分别为 $2$ 和 $15$，模数为 $13$，虽然 $2 \equiv 15 ~~ (\bmod~13)$，但它们不相同。

然而，我们在编码中使用的 $\textit{base}$ 和 $\textit{mod}$ 对于测试数据本身是「黑盒」的，也就是说，并不存在一组测试数据，使得对于任意的 $\textit{base}$ 和 $\textit{mod}$，都会产生哈希碰撞，导致错误的判断结果。因此，我们可以「投机取巧」地尝试不同的 $\textit{base}$ 和 $\textit{mod}$，使之可以通过所有的测试数据。

> **注意：在工程代码中，千万不能投机取巧。**

一般来说，我们选取一个大于字符集大小（即字符串中可能出现的字符种类的数目）的质数作为 $\textit{base}$，再选取一个在字符串长度平方级别左右的质数作为 $\textit{mod}$，产生哈希碰撞的概率就会很低。

**算法**

一个字符串是回文串，当且仅当该字符串与它的反序相同。因此，我们仍然暴力地枚举 $s_1$ 的结束位置，并计算 $s_1$ 与 $s_1$ 反序的哈希值。如果这两个哈希值相等，说明我们找到了一个 $s$ 的前缀回文串。

在枚举 $s_1$ 的结束位置时，我们可以从小到大地进行枚举，这样就可以很容易地维护 $s_1$ 与 $s_1$ 反序的哈希值：

设当前枚举到的结束位置为 $i$，对应的 $s_1$ 记为 $s_1^i$，其反序记为 $\hat{s}_1^i$。我们可以通过递推的方式，在 $O(1)$ 的时间通过 $s_1^{i-1}$ 和 $\hat{s}_1^{i-1}$ 的哈希值得到 $s_1^i$ 和 $\hat{s}_1^i$ 的哈希值：

- $\text{hash}(s_1^i) = \text{hash}(s_1^{i-1}) \times \textit{base} + \text{ASCII}(s[i])$

- $\text{hash}(\hat{s}_1^i) = \text{hash}(\hat{s}_1^{i-1}) + \text{ASCII}(s[i]) \times \text{base}^i$

其中 $\text{ASCII}(x)$ 表示字符 $x$ 的 $\text{ASCII}$ 码。注意需要将结果对 $\textit{mod}$ 取模。

如果 $\text{hash}(s_1^i) = \text{hash}(\hat{s}_1^i)$，那么 $s_1^i$ 就是一个回文串。我们将最长的回文串作为最终的 $s_1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string shortestPalindrome(string s) {
        int n = s.size();
        int base = 131, mod = 1000000007;
        int left = 0, right = 0, mul = 1;
        int best = -1;
        for (int i = 0; i < n; ++i) {
            left = ((long long)left * base + s[i]) % mod;
            right = (right + (long long)mul * s[i]) % mod;
            if (left == right) {
                best = i;
            }
            mul = (long long)mul * base % mod;
        }
        string add = (best == n - 1 ? "" : s.substr(best + 1, n));
        reverse(add.begin(), add.end());
        return add + s;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String shortestPalindrome(String s) {
        int n = s.length();
        int base = 131, mod = 1000000007;
        int left = 0, right = 0, mul = 1;
        int best = -1;
        for (int i = 0; i < n; ++i) {
            left = (int) (((long) left * base + s.charAt(i)) % mod);
            right = (int) ((right + (long) mul * s.charAt(i)) % mod);
            if (left == right) {
                best = i;
            }
            mul = (int) ((long) mul * base % mod);
        }
        String add = (best == n - 1 ? "" : s.substring(best + 1));
        StringBuffer ans = new StringBuffer(add).reverse();
        ans.append(s);
        return ans.toString();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def shortestPalindrome(self, s: str) -> str:
        n = len(s)
        base, mod = 131, 10**9 + 7
        left = right = 0
        mul = 1
        best = -1
        
        for i in range(n):
            left = (left * base + ord(s[i])) % mod
            right = (right + mul * ord(s[i])) % mod
            if left == right:
                best = i
            mul = mul * base % mod
        
        add = ("" if best == n - 1 else s[best+1:])
        return add[::-1] + s
```

```C [sol1-C]
char* shortestPalindrome(char* s) {
    int n = strlen(s);
    int base = 131, mod = 1000000007;
    int left = 0, right = 0, mul = 1;
    int best = -1;
    for (int i = 0; i < n; ++i) {
        left = ((long long)left * base + s[i]) % mod;
        right = (right + (long long)mul * s[i]) % mod;
        if (left == right) {
            best = i;
        }
        mul = (long long)mul * base % mod;
    }
    int ret_len = n - best - 1;
    char* ret = malloc(sizeof(char) * (ret_len + n + 1));
    for (int i = 0; i < ret_len; i++) ret[i] = s[n - i - 1];
    for (int i = 0; i < n; i++) ret[i + ret_len] = s[i];
    ret[ret_len + n] = 0;
    return ret;
}
```

```golang [sol1-Golang]
func shortestPalindrome(s string) string {
    n := len(s)
    base, mod := 131, 1000000007
    left, right, mul := 0, 0, 1
    best := -1
    for i := 0; i < n; i++ {
        left = (left * base + int(s[i] - '0')) % mod
        right = (right + mul * int(s[i] - '0')) % mod
        if left == right {
            best = i
        }
        mul = mul * base % mod
    }
    add := ""
    if best != n - 1 {
        add = s[best + 1:]
    }
    b := []byte(add)
    for i := 0; i < len(b) / 2; i++ {
        b[i], b[len(b) - 1 -i] = b[len(b) - 1 -i], b[i]
    }
    return string(b) + s
}
```

**复杂度分析**

- 时间复杂度：$O(|s|)$。

- 空间复杂度：$O(1)$。

#### 方法二：KMP 算法

**思路与算法**

我们也可以不「投机取巧」，而是使用 KMP 字符串匹配算法来找出这个最长的前缀回文串。

具体地，记 $\hat{s}$ 为 $s$ 的反序，由于 $s_1$ 是 $s$ 的前缀，那么 $\hat{s}_1$ 就是 $\hat{s}$ 的后缀。

考虑到 $s_1$ 是一个回文串，因此 $s_1 = \hat{s}_1$，$s_1$ 同样是 $\hat{s}$ 的后缀。

这样一来，我们将 $s$ 作为模式串，$\hat{s}$ 作为查询串进行匹配。当遍历到 $\hat{s}$ 的末尾时，如果匹配到 $s$ 中的第 $i$ 个字符，那么说明 $s$ 的前 $i$ 个字符与 $\hat{s}$ 的后 $i$ 个字符相匹配（即相同），$s$ 的前 $i$ 个字符对应 $s_1$，$\hat{s}$ 的后 $i$ 个字符对应 $\hat{s}_1$，由于 $s_1 = \hat{s}_1$，因此 $s_1$ 就是一个回文串。

> 如果存在更长的回文串，那么 KMP 算法的匹配结果也会大于 $i$，因此 $s_1$ 就是最长的前缀回文串。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    string shortestPalindrome(string s) {
        int n = s.size();
        vector<int> fail(n, -1);
        for (int i = 1; i < n; ++i) {
            int j = fail[i - 1];
            while (j != -1 && s[j + 1] != s[i]) {
                j = fail[j];
            }
            if (s[j + 1] == s[i]) {
                fail[i] = j + 1;
            }
        }
        int best = -1;
        for (int i = n - 1; i >= 0; --i) {
            while (best != -1 && s[best + 1] != s[i]) {
                best = fail[best];
            }
            if (s[best + 1] == s[i]) {
                ++best;
            }
        }
        string add = (best == n - 1 ? "" : s.substr(best + 1, n));
        reverse(add.begin(), add.end());
        return add + s;
    }
};
```

```Java [sol2-Java]
class Solution {
    public String shortestPalindrome(String s) {
        int n = s.length();
        int[] fail = new int[n];
        Arrays.fill(fail, -1);
        for (int i = 1; i < n; ++i) {
            int j = fail[i - 1];
            while (j != -1 && s.charAt(j + 1) != s.charAt(i)) {
                j = fail[j];
            }
            if (s.charAt(j + 1) == s.charAt(i)) {
                fail[i] = j + 1;
            }
        }
        int best = -1;
        for (int i = n - 1; i >= 0; --i) {
            while (best != -1 && s.charAt(best + 1) != s.charAt(i)) {
                best = fail[best];
            }
            if (s.charAt(best + 1) == s.charAt(i)) {
                ++best;
            }
        }
        String add = (best == n - 1 ? "" : s.substring(best + 1));
        StringBuffer ans = new StringBuffer(add).reverse();
        ans.append(s);
        return ans.toString();
    }
}
```

```Python [sol2-Python3]
class Solution:
    def shortestPalindrome(self, s: str) -> str:
        n = len(s)
        fail = [-1] * n
        for i in range(1, n):
            j = fail[i - 1]
            while j != -1 and s[j + 1] != s[i]:
                j = fail[j]
            if s[j + 1] == s[i]:
                fail[i] = j + 1
        
        best = -1
        for i in range(n - 1, -1, -1):
            while best != -1 and s[best + 1] != s[i]:
                best = fail[best]
            if s[best + 1] == s[i]:
                best += 1

        add = ("" if best == n - 1 else s[best+1:])
        return add[::-1] + s
```

```C [sol2-C]
char* shortestPalindrome(char* s) {
    int n = strlen(s);
    int fail[n + 1];
    memset(fail, -1, sizeof(fail));
    for (int i = 1; i < n; ++i) {
        int j = fail[i - 1];
        while (j != -1 && s[j + 1] != s[i]) {
            j = fail[j];
        }
        if (s[j + 1] == s[i]) {
            fail[i] = j + 1;
        }
    }
    int best = -1;
    for (int i = n - 1; i >= 0; --i) {
        while (best != -1 && s[best + 1] != s[i]) {
            best = fail[best];
        }
        if (s[best + 1] == s[i]) {
            ++best;
        }
    }
    int ret_len = n - best - 1;
    char* ret = malloc(sizeof(char) * (ret_len + n + 1));
    for (int i = 0; i < ret_len; i++) ret[i] = s[n - i - 1];
    for (int i = 0; i < n; i++) ret[i + ret_len] = s[i];
    ret[ret_len + n] = 0;
    return ret;
}
```

```golang [sol2-Golang]
func shortestPalindrome(s string) string {
    n := len(s)
    fail := make([]int, n)
    for i := 0; i < n; i++ {
        fail[i] = -1
    }
    for i := 1; i < n; i++ {
        j := fail[i - 1]
        for j != -1 && s[j + 1] != s[i] {
            j = fail[j]
        }
        if s[j + 1] == s[i] {
            fail[i] = j + 1
        }
    }
    best := -1
    for i := n - 1; i >= 0; i-- {
        for best != -1 && s[best + 1] != s[i] {
            best = fail[best]
        }
        if s[best + 1] == s[i] {
            best++
        }
    }
    add := ""
    if best != n - 1 {
        add = s[best + 1:]
    }
    b := []byte(add)
    for i := 0; i < len(b) / 2; i++ {
        b[i], b[len(b) - 1 -i] = b[len(b) - 1 -i], b[i]
    }
    return string(b) + s
}
```

**复杂度分析**

- 时间复杂度：$O(|s|)$。

- 空间复杂度：$O(|s|)$。

**结语**

如果读者对 KMP 算法不熟悉，可以自行查阅资料进行学习。KMP 算法在笔试或面试中也是非常罕见的考点，读者可以参考「[459. 重复的子字符串的官方题解](https://leetcode-cn.com/problems/repeated-substring-pattern/solution/zhong-fu-de-zi-zi-fu-chuan-by-leetcode-solution/)」中的对应部分检验自己的学习成果。

本题也可以用 Manacher 算法找出回文串，但该方法已经达到竞赛难度，读者可以参考「[5. 最长回文子串的官方题解](https://leetcode-cn.com/problems/longest-palindromic-substring/solution/zui-chang-hui-wen-zi-chuan-by-leetcode-solution/)」中的对应部分汲取一些灵感，并尝试用该算法解决本题。