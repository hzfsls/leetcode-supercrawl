## [686.重复叠加字符串匹配 中文官方题解](https://leetcode.cn/problems/repeated-string-match/solutions/100000/zhong-fu-die-jia-zi-fu-chuan-pi-pei-by-l-vnye)

#### 方法一：Rabin-Karp 算法

**思路与算法**

命题「存在重复叠加字符串 $s_1=a \ldots a$，使得字符串 $b$ 成为叠加后的字符串 $s_1$ 的子串」等价于「字符串 $b$ 成为无限重复叠加字符串 $s_2=aa \ldots$ 的子串」。而后者成立的前提是任一 $s_2[i:\infty], 0 \le i < \textit{len}(a)$ 以 $b$ 为前缀，即 $b$ 可以从第一个叠加的 $a$ 开始匹配成功。

因此我们可以分两种情况：

+ $b$ 可以从第一个叠加的 $a$ 开始匹配成功，则明显匹配的下标越小，最终需要的叠加数目 $k$ 越小，记成功匹配的最小下标为 $\textit{index}$，$0 \le \textit{index} < \textit{len}(a)$，于是：

    $$
    k =
    \begin{cases}
    1, & \textit{len}(b) \le \textit{len}(a) - \textit{index} \\
    \displaystyle{\Big\lceil \frac{\textit{len}(b) - [\textit{len}(a) - \textit{index}]}{\textit{len}(a)} \Big\rceil} + 1, & \textit{len}(b) > \textit{len}(a) - \textit{index}
    \end{cases}
    $$

+ $b$ 无法从第一个叠加的 $a$ 开始匹配成功，说明不存在重复叠加字符串 $s_1=a \ldots a$，使得字符串 $b$ 成为叠加后的字符串 $s_1=a \ldots a$ 的子串。

在应用 Rabin-Karp 算法时，被匹配字符串是循环叠加的字符串，所以下标要进行取余操作，并且匹配终止的条件为 $b$ 开始匹配的位置超过第一个叠加的 $a$。我们采用随机数来生成 Rabin-Karp 算法的哈希函数，希望避免后续哈希冲突的发生。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int strStr(string haystack, string needle) {
        int n = haystack.size(), m = needle.size();
        if (m == 0) {
            return 0;
        }

        long long k1 = 1e9 + 7;
        long long k2 = 1337;
        srand((unsigned)time(NULL));
        long long kMod1 = rand() % k1 + k1;
        long long kMod2 = rand() % k2 + k2;

        long long hash_needle = 0;
        for (auto c : needle) {
            hash_needle = (hash_needle * kMod2 + c) % kMod1;
        }
        long long hash_haystack = 0, extra = 1;
        for (int i = 0; i < m - 1; i++) {
            hash_haystack = (hash_haystack * kMod2 + haystack[i % n]) % kMod1;
            extra = (extra * kMod2) % kMod1;
        }
        for (int i = m - 1; (i - m + 1) < n; i++) {
            hash_haystack = (hash_haystack * kMod2 + haystack[i % n]) % kMod1;
            if (hash_haystack == hash_needle) {
                return i - m + 1;
            }
            hash_haystack = (hash_haystack - extra * haystack[(i - m + 1) % n]) % kMod1;
            hash_haystack = (hash_haystack + kMod1) % kMod1;
        }
        return -1;
    }

    int repeatedStringMatch(string a, string b) {
        int an = a.size(), bn = b.size();
        int index = strStr(a, b);
        if (index == -1) {
            return -1;
        }
        if (an - index >= bn) {
            return 1;
        }
        return (bn + index - an - 1) / an + 2;
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int kMod1 = 1000000007;
    static final int kMod2 = 1337;

    public int repeatedStringMatch(String a, String b) {
        int an = a.length(), bn = b.length();
        int index = strStr(a, b);
        if (index == -1) {
            return -1;
        }
        if (an - index >= bn) {
            return 1;
        }
        return (bn + index - an - 1) / an + 2;
    }

    public int strStr(String haystack, String needle) {
        int n = haystack.length(), m = needle.length();
        if (m == 0) {
            return 0;
        }

        int k1 = 1000000009;
        int k2 = 1337;
        Random random = new Random();
        int kMod1 = random.nextInt(k1) + k1;
        int kMod2 = random.nextInt(k2) + k2;

        long hashNeedle = 0;
        for (int i = 0; i < m; i++) {
            char c = needle.charAt(i);
            hashNeedle = (hashNeedle * kMod2 + c) % kMod1;
        }
        long hashHaystack = 0, extra = 1;
        for (int i = 0; i < m - 1; i++) {
            hashHaystack = (hashHaystack * kMod2 + haystack.charAt(i % n)) % kMod1;
            extra = (extra * kMod2) % kMod1;
        }
        for (int i = m - 1; (i - m + 1) < n; i++) {
            hashHaystack = (hashHaystack * kMod2 + haystack.charAt(i % n)) % kMod1;
            if (hashHaystack == hashNeedle) {
                return i - m + 1;
            }
            hashHaystack = (hashHaystack - extra * haystack.charAt((i - m + 1) % n)) % kMod1;
            hashHaystack = (hashHaystack + kMod1) % kMod1;
        }
        return -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int RepeatedStringMatch(string a, string b) {
        int an = a.Length, bn = b.Length;
        int index = StrStr(a, b);
        if (index == -1) {
            return -1;
        }
        if (an - index >= bn) {
            return 1;
        }
        return (bn + index - an - 1) / an + 2;
    }

    public int StrStr(string haystack, string needle) {
        int n = haystack.Length, m = needle.Length;
        if (m == 0) {
            return 0;
        }

        int k1 = 1000000009;
        int k2 = 1337;
        Random random = new Random();
        int kMod1 = random.Next(k1, k1 * 2);
        int kMod2 = random.Next(k2, k2 * 2);

        long hashNeedle = 0;
        for (int i = 0; i < m; i++) {
            char c = needle[i];
            hashNeedle = (hashNeedle * kMod2 + c) % kMod1;
        }
        long hashHaystack = 0, extra = 1;
        for (int i = 0; i < m - 1; i++) {
            hashHaystack = (hashHaystack * kMod2 + haystack[i % n]) % kMod1;
            extra = (extra * kMod2) % kMod1;
        }
        for (int i = m - 1; (i - m + 1) < n; i++) {
            hashHaystack = (hashHaystack * kMod2 + haystack[i % n]) % kMod1;
            if (hashHaystack == hashNeedle) {
                return i - m + 1;
            }
            hashHaystack = (hashHaystack - extra * haystack[(i - m + 1) % n]) % kMod1;
            hashHaystack = (hashHaystack + kMod1) % kMod1;
        }
        return -1;
    }
}
```

```C [sol1-C]
int strStr(char *haystack, int n, char *needle, int m) {
    if (m == 0) {
        return 0;
    }

    long long k1 = 1e9 + 7;
    long long k2 = 1337;
    srand((unsigned)time(NULL));
    long long kMod1 = rand() % k1 + k1;
    long long kMod2 = rand() % k2 + k2;

    long long hash_needle = 0;
    for (int i = 0; i < m; i++) {
        hash_needle = (hash_needle * kMod2 + needle[i]) % kMod1;
    }
    long long hash_haystack = 0, extra = 1;
    for (int i = 0; i < m - 1; i++) {
        hash_haystack = (hash_haystack * kMod2 + haystack[i % n]) % kMod1;
        extra = (extra * kMod2) % kMod1;
    }
    for (int i = m - 1; (i - m + 1) < n; i++) {
        hash_haystack = (hash_haystack * kMod2 + haystack[i % n]) % kMod1;
        if (hash_haystack == hash_needle) {
            return i - m + 1;
        }
        hash_haystack = (hash_haystack - extra * haystack[(i - m + 1) % n]) % kMod1;
        hash_haystack = (hash_haystack + kMod1) % kMod1;
    }
    return -1;
}

int repeatedStringMatch(char * a, char * b){
    int an = strlen(a), bn = strlen(b);
    int index = strStr(a, an, b, bn);
    if (index == -1) {
        return -1;
    }
    if (an - index >= bn) {
        return 1;
    }
    return (bn + index - an - 1) / an + 2;
}
```

```Go [sol1-Golang]
func strStr(haystack, needle string) int {
    n, m := len(haystack), len(needle)
    if m == 0 {
        return 0
    }

    var k1 int = 1000000000 + 7
    var k2 int = 1337
    rand.Seed(time.Now().Unix())
    var kMod1 int64 = int64(rand.Intn(k1)) + int64(k1)
    var kMod2 int64 = int64(rand.Intn(k2)) + int64(k2)

    var hash_needle int64 = 0
    for i := 0; i < m; i++ {
        hash_needle = (hash_needle*kMod2 + int64(needle[i])) % kMod1
    }
    var hash_haystack int64 = 0
    var extra int64 = 1
    for i := 0; i < m-1; i++ {
        hash_haystack = (hash_haystack*kMod2 + int64(haystack[i%n])) % kMod1
        extra = (extra * kMod2) % kMod1
    }
    for i := m - 1; (i - m + 1) < n; i++ {
        hash_haystack = (hash_haystack*kMod2 + int64(haystack[i%n])) % kMod1
        if hash_haystack == hash_needle {
            return i - m + 1
        }
        hash_haystack = (hash_haystack - extra*int64(haystack[(i-m+1)%n])) % kMod1
        hash_haystack = (hash_haystack + kMod1) % kMod1
    }
    return -1
}

func repeatedStringMatch(a string, b string) int {
    an, bn := len(a), len(b)
    index := strStr(a, b)
    if index == -1 {
        return -1
    }
    if an-index >= bn {
        return 1
    }
    return (bn+index-an-1)/an + 2
}
```

```JavaScript [sol1-JavaScript]
const repeatedStringMatch = (a, b) => {
    const an = a.length, bn = b.length;
    const index = strStr(a, b);
    if (index === -1) {
        return -1;
    }
    if (an - index >= bn) {
        return 1;
    }
    return Math.floor((bn + index - an - 1) / an) + 2;
}

const strStr = (haystack, needle) => {
    const n = haystack.length, m = needle.length;
    if (m === 0) {
        return 0;
    }

    let k1 = 1000000009;
    let k2 = 1337;
    let kMod1 = Math.floor(Math.random() * k1) + k1;
    let kMod2 = Math.floor(Math.random() * k2) + k2;

    let hashNeedle = 0;
    for (let i = 0; i < m; i++) {
        const c = needle[i].charCodeAt();
        hashNeedle = (hashNeedle * kMod2 + c) % kMod1;
    }
    let hashHaystack = 0, extra = 1;
    for (let i = 0; i < m - 1; i++) {
        hashHaystack = (hashHaystack * kMod2 + haystack[i % n].charCodeAt()) % kMod1;
        extra = (extra * kMod2) % kMod1;
    }
    for (let i = m - 1; (i - m + 1) < n; i++) {
        hashHaystack = (hashHaystack * kMod2 + haystack[i % n].charCodeAt()) % kMod1;
        if (hashHaystack === hashNeedle) {
            return i - m + 1;
        }
        hashHaystack = (hashHaystack - extra * haystack[(i - m + 1) % n].charCodeAt()) % kMod1;
        hashHaystack = (hashHaystack + kMod1) % kMod1;
    }
    return -1;
}
```

```Python [sol1-Python3]
class Solution:
    def strstr(self, haystack: str, needle: str) -> int:
        n, m = len(haystack), len(needle)
        if m == 0:
            return 0

        k1 = 10 ** 9 + 7
        k2 = 1337
        mod1 = randrange(k1) + k1
        mod2 = randrange(k2) + k2

        hash_needle = 0
        for c in needle:
            hash_needle = (hash_needle * mod2 + ord(c)) % mod1
        hash_haystack = 0
        for i in range(m - 1):
            hash_haystack = (hash_haystack * mod2 + ord(haystack[i % n])) % mod1
        extra = pow(mod2, m - 1, mod1)
        for i in range(m - 1, n + m - 1):
            hash_haystack = (hash_haystack * mod2 + ord(haystack[i % n])) % mod1
            if hash_haystack == hash_needle:
                return i - m + 1
            hash_haystack = (hash_haystack - extra * ord(haystack[(i - m + 1) % n])) % mod1
            hash_haystack = (hash_haystack + mod1) % mod1
        return -1

    def repeatedStringMatch(self, a: str, b: str) -> int:
        n, m = len(a), len(b)
        index = self.strstr(a, b)
        if index == -1:
            return -1
        if n - index >= m:
            return 1
        return (m + index - n - 1) // n + 2
```

**复杂度分析**

+ 时间复杂度：$O(n + m)$, 其中 $n$ 为 $a$ 的长度，$m$ 为 $b$ 的长度。Rabin-Karp 算法的时间复杂度为 $O(n + m)$。

+ 空间复杂度：$O(1)$。只需要常数空间保存参数。

#### 方法二：Knuth-Morris-Pratt 算法

**前言**

关于 Knuth-Morris-Pratt 算法的具体实现，读者可以参阅官方题解「[28. 实现 strStr()](https://leetcode-cn.com/problems/implement-strstr/solution/shi-xian-strstr-by-leetcode-solution-ds6y/)」，笔者就不作详细介绍了。

**思路与算法**

类似于方法一，我们也可以使用 Knuth-Morris-Pratt 算法来实现字符串匹配的功能。在应用 Knuth-Morris-Pratt 算法时，被匹配字符串是循环叠加的字符串，所以下标要进行取余操作，并且匹配终止的条件为 $b$ 开始匹配的位置超过第一个叠加的 $a$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int strStr(string &haystack, string &needle) {
        int n = haystack.size(), m = needle.size();
        if (m == 0) {
            return 0;
        }
        vector<int> pi(m);
        for (int i = 1, j = 0; i < m; i++) {
            while (j > 0 && needle[i] != needle[j]) {
                j = pi[j - 1];
            }
            if (needle[i] == needle[j]) {
                j++;
            }
            pi[i] = j;
        }
        for (int i = 0, j = 0; i - j < n; i++) { // b 开始匹配的位置是否超过第一个叠加的 a
            while (j > 0 && haystack[i % n] != needle[j]) { // haystack 是循环叠加的字符串，所以取 i % n
                j = pi[j - 1];
            }
            if (haystack[i % n] == needle[j]) {
                j++;
            }
            if (j == m) {
                return i - m + 1;
            }
        }
        return -1;
    }

    int repeatedStringMatch(string a, string b) {
        int an = a.size(), bn = b.size();
        int index = strStr(a, b);
        if (index == -1) {
            return -1;
        }
        if (an - index >= bn) {
            return 1;
        }
        return (bn + index - an - 1) / an + 2;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int repeatedStringMatch(String a, String b) {
        int an = a.length(), bn = b.length();
        int index = strStr(a, b);
        if (index == -1) {
            return -1;
        }
        if (an - index >= bn) {
            return 1;
        }
        return (bn + index - an - 1) / an + 2;
    }

    public int strStr(String haystack, String needle) {
        int n = haystack.length(), m = needle.length();
        if (m == 0) {
            return 0;
        }
        int[] pi = new int[m];
        for (int i = 1, j = 0; i < m; i++) {
            while (j > 0 && needle.charAt(i) != needle.charAt(j)) {
                j = pi[j - 1];
            }
            if (needle.charAt(i) == needle.charAt(j)) {
                j++;
            }
            pi[i] = j;
        }
        for (int i = 0, j = 0; i - j < n; i++) { // b 开始匹配的位置是否超过第一个叠加的 a
            while (j > 0 && haystack.charAt(i % n) != needle.charAt(j)) { // haystack 是循环叠加的字符串，所以取 i % n
                j = pi[j - 1];
            }
            if (haystack.charAt(i % n) == needle.charAt(j)) {
                j++;
            }
            if (j == m) {
                return i - m + 1;
            }
        }
        return -1;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int RepeatedStringMatch(string a, string b) {
        int an = a.Length, bn = b.Length;
        int index = StrStr(a, b);
        if (index == -1) {
            return -1;
        }
        if (an - index >= bn) {
            return 1;
        }
        return (bn + index - an - 1) / an + 2;
    }

    public int StrStr(string haystack, string needle) {
        int n = haystack.Length, m = needle.Length;
        if (m == 0) {
            return 0;
        }
        int[] pi = new int[m];
        for (int i = 1, j = 0; i < m; i++) {
            while (j > 0 && needle[i] != needle[j]) {
                j = pi[j - 1];
            }
            if (needle[i] == needle[j]) {
                j++;
            }
            pi[i] = j;
        }
        for (int i = 0, j = 0; i - j < n; i++) { // b 开始匹配的位置是否超过第一个叠加的 a
            while (j > 0 && haystack[i % n] != needle[j]) { // haystack 是循环叠加的字符串，所以取 i % n
                j = pi[j - 1];
            }
            if (haystack[i % n] == needle[j]) {
                j++;
            }
            if (j == m) {
                return i - m + 1;
            }
        }
        return -1;
    }
}
```

```C [sol2-C]
int strStr(char * haystack, int n, char * needle, int m) {
    if (m == 0) {
        return 0;
    }
    int pi[m];
    pi[0] = 0;
    for (int i = 1, j = 0; i < m; i++) {
        while (j > 0 && needle[i] != needle[j]) {
            j = pi[j - 1];
        }
        if (needle[i] == needle[j]) {
            j++;
        }
        pi[i] = j;
    }
    for (int i = 0, j = 0; i - j < n; i++) { // b 开始匹配的位置是否超过第一个叠加的 a
        while (j > 0 && haystack[i % n] != needle[j]) { // haystack 是循环叠加的字符串，所以取 i % n
            j = pi[j - 1];
        }
        if (haystack[i % n] == needle[j]) {
            j++;
        }
        if (j == m) {
            return i - m + 1;
        }
    }
    return -1;
}
int repeatedStringMatch(char * a, char * b){
    int an = strlen(a), bn = strlen(b);
    int index = strStr(a, an, b, bn);
    if (index == -1) {
        return -1;
    }
    if (an - index >= bn) {
        return 1;
    }
    return (bn + index - an - 1) / an + 2;
}
```

```Go [sol2-Golang]
func strStr(haystack, needle string) int {
    n, m := len(haystack), len(needle)
    if m == 0 {
        return 0
    }
    pi := make([]int, m)
    for i, j := 1, 0; i < m; i++ {
        for j > 0 && needle[i] != needle[j] {
            j = pi[j-1]
        }
        if needle[i] == needle[j] {
            j++
        }
        pi[i] = j
    }
    for i, j := 0, 0; i-j < n; i++ { // b 开始匹配的位置是否超过第一个叠加的 a
        for j > 0 && haystack[i%n] != needle[j] { // haystack 是循环叠加的字符串，所以取 i % n
            j = pi[j-1]
        }
        if haystack[i%n] == needle[j] {
            j++
        }
        if j == m {
            return i - m + 1
        }
    }
    return -1
}

func repeatedStringMatch(a string, b string) int {
    an, bn := len(a), len(b)
    index := strStr(a, b)
    if index == -1 {
        return -1
    }
    if an-index >= bn {
        return 1
    }
    return (bn+index-an-1)/an + 2
}
```

```JavaScript [sol2-JavaScript]
const repeatedStringMatch = (a, b) => {
    const an = a.length, bn = b.length;
    const index = strStr(a, b);
    if (index === -1) {
        return -1;
    }
    if (an - index >= bn) {
        return 1;
    }
    return Math.floor((bn + index - an - 1) / an) + 2;
}

const strStr = (haystack, needle) => {
    const n = haystack.length, m = needle.length;
    if (m === 0) {
        return 0;
    }
    const pi = new Array(m).fill(0);
    for (let i = 1, j = 0; i < m; i++) {
        while (j > 0 && needle[i] !== needle[j]) {
            j = pi[j - 1];
        }
        if (needle[i] === needle[j]) {
            j++;
        }
        pi[i] = j;
    }
    for (let i = 0, j = 0; i - j < n; i++) { // b 开始匹配的位置是否超过第一个叠加的 a
        while (j > 0 && haystack[i % n] !== needle[j]) { // haystack 是循环叠加的字符串，所以取 i % n
            j = pi[j - 1];
        }
        if (haystack[i % n] == needle[j]) {
            j++;
        }
        if (j === m) {
            return i - m + 1;
        }
    }
    return -1;
}
```

```Python [sol2-Python3]
class Solution:
    def strstr(self, haystack: str, needle: str) -> int:
        n, m = len(haystack), len(needle)
        if m == 0:
            return 0

        pi = [0] * m
        j = 0
        for i in range(1, m):
            while j > 0 and needle[i] != needle[j]:
                j = pi[j - 1]
            if needle[i] == needle[j]:
                j += 1
            pi[i] = j

        i, j = 0, 0
        while i - j < n:
            while j > 0 and haystack[i % n] != needle[j]:
                j = pi[j - 1]
            if haystack[i % n] == needle[j]:
                j += 1
            if j == m:
                return i - m + 1
            i += 1
        return -1

    def repeatedStringMatch(self, a: str, b: str) -> int:
        n, m = len(a), len(b)
        index = self.strstr(a, b)
        if index == -1:
            return -1
        if n - index >= m:
            return 1
        return (m + index - n - 1) // n + 2
```

**复杂度分析**

+ 时间复杂度：$O(n + m)$，其中 $n$ 为 $a$ 的长度，$m$ 为 $b$ 的长度。Knuth-Morris-Pratt 算法的时间复杂度为 $O(n + m)$。

+ 空间复杂度：$O(m)$。Knuth-Morris-Pratt 算法需要 $O(m)$ 的空间来保存 $\pi$ 数组。