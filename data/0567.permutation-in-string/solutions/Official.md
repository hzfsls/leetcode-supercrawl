#### 方法一：滑动窗口

由于排列不会改变字符串中每个字符的个数，所以只有当两个字符串每个字符的个数均相等时，一个字符串才是另一个字符串的排列。

根据这一性质，记 $s_1$ 的长度为 $n$，我们可以遍历 $s_2$ 中的每个长度为 $n$ 的子串，判断子串和 $s_1$ 中每个字符的个数是否相等，若相等则说明该子串是 $s_1$ 的一个排列。

使用两个数组 $\textit{cnt}_1$ 和 $\textit{cnt}_2$，$\textit{cnt}_1$ 统计 $s_1$ 中各个字符的个数，$\textit{cnt}_2$ 统计当前遍历的子串中各个字符的个数。

由于需要遍历的子串长度均为 $n$，我们可以使用一个固定长度为 $n$ 的**滑动窗口**来维护 $\textit{cnt}_2$：滑动窗口每向右滑动一次，就多统计一次进入窗口的字符，少统计一次离开窗口的字符。然后，判断 $\textit{cnt}_1$ 是否与 $\textit{cnt}_2$ 相等，若相等则意味着 $s_1$ 的排列之一是 $s_2$ 的子串。

```C++ [sol11-C++]
class Solution {
public:
    bool checkInclusion(string s1, string s2) {
        int n = s1.length(), m = s2.length();
        if (n > m) {
            return false;
        }
        vector<int> cnt1(26), cnt2(26);
        for (int i = 0; i < n; ++i) {
            ++cnt1[s1[i] - 'a'];
            ++cnt2[s2[i] - 'a'];
        }
        if (cnt1 == cnt2) {
            return true;
        }
        for (int i = n; i < m; ++i) {
            ++cnt2[s2[i] - 'a'];
            --cnt2[s2[i - n] - 'a'];
            if (cnt1 == cnt2) {
                return true;
            }
        }
        return false;
    }
};
```

```Java [sol11-Java]
class Solution {
    public boolean checkInclusion(String s1, String s2) {
        int n = s1.length(), m = s2.length();
        if (n > m) {
            return false;
        }
        int[] cnt1 = new int[26];
        int[] cnt2 = new int[26];
        for (int i = 0; i < n; ++i) {
            ++cnt1[s1.charAt(i) - 'a'];
            ++cnt2[s2.charAt(i) - 'a'];
        }
        if (Arrays.equals(cnt1, cnt2)) {
            return true;
        }
        for (int i = n; i < m; ++i) {
            ++cnt2[s2.charAt(i) - 'a'];
            --cnt2[s2.charAt(i - n) - 'a'];
            if (Arrays.equals(cnt1, cnt2)) {
                return true;
            }
        }
        return false;
    }
}
```

```go [sol11-Golang]
func checkInclusion(s1, s2 string) bool {
    n, m := len(s1), len(s2)
    if n > m {
        return false
    }
    var cnt1, cnt2 [26]int
    for i, ch := range s1 {
        cnt1[ch-'a']++
        cnt2[s2[i]-'a']++
    }
    if cnt1 == cnt2 {
        return true
    }
    for i := n; i < m; i++ {
        cnt2[s2[i]-'a']++
        cnt2[s2[i-n]-'a']--
        if cnt1 == cnt2 {
            return true
        }
    }
    return false
}
```

```C [sol11-C]
bool equals(int* cnt1, int* cnt2) {
    for (int i = 0; i < 26; i++) {
        if (cnt1[i] != cnt2[i]) {
            return false;
        }
    }
    return true;
}

bool checkInclusion(char* s1, char* s2) {
    int n = strlen(s1), m = strlen(s2);
    if (n > m) {
        return false;
    }
    int cnt1[26], cnt2[26];
    memset(cnt1, 0, sizeof(cnt1));
    memset(cnt2, 0, sizeof(cnt2));
    for (int i = 0; i < n; ++i) {
        ++cnt1[s1[i] - 'a'];
        ++cnt2[s2[i] - 'a'];
    }
    if (equals(cnt1, cnt2)) {
        return true;
    }
    for (int i = n; i < m; ++i) {
        ++cnt2[s2[i] - 'a'];
        --cnt2[s2[i - n] - 'a'];
        if (equals(cnt1, cnt2)) {
            return true;
        }
    }
    return false;
}
```

```JavaScript [sol11-JavaScript]
var checkInclusion = function(s1, s2) {
    const n = s1.length, m = s2.length;
    if (n > m) {
        return false;
    }
    const cnt1 = new Array(26).fill(0);
    const cnt2 = new Array(26).fill(0);
    for (let i = 0; i < n; ++i) {
        ++cnt1[s1[i].charCodeAt() - 'a'.charCodeAt()];
        ++cnt2[s2[i].charCodeAt() - 'a'.charCodeAt()];
    }
    if (cnt1.toString() === cnt2.toString()) {
        return true;
    }
    for (let i = n; i < m; ++i) {
        ++cnt2[s2[i].charCodeAt() - 'a'.charCodeAt()];
        --cnt2[s2[i - n].charCodeAt() - 'a'.charCodeAt()];
        if (cnt1.toString() === cnt2.toString()) {
            return true;
        }
    }
    return false;
};
```

**优化**

注意到每次窗口滑动时，只统计了一进一出两个字符，却比较了整个 $\textit{cnt}_1$ 和 $\textit{cnt}_2$ 数组。

从这个角度出发，我们可以用一个变量 $\textit{diff}$ 来记录 $\textit{cnt}_1$ 与 $\textit{cnt}_2$ 的不同值的个数，这样判断 $\textit{cnt}_1$ 和 $\textit{cnt}_2$ 是否相等就转换成了判断 $\textit{diff}$ 是否为 $0$.

每次窗口滑动，记一进一出两个字符为 $x$ 和 $y$.

若 $x=y$ 则对 $\textit{cnt}_2$ 无影响，可以直接跳过。

若 $x\ne y$，对于字符 $x$，在修改 $\textit{cnt}_2$ 之前若有 $\textit{cnt}_2[x]=\textit{cnt}_1[x]$，则将 $\textit{diff}$ 加一；在修改 $\textit{cnt}_2$ 之后若有 $\textit{cnt}_2[x]=\textit{cnt}_1[x]$，则将 $\textit{diff}$ 减一。字符 $y$ 同理。

此外，为简化上述逻辑，我们可以只用一个数组 $\textit{cnt}$，其中 $\textit{cnt}[x]=\textit{cnt}_2[x]-\textit{cnt}_1[x]$，将 $\textit{cnt}_1[x]$ 与 $\textit{cnt}_2[x]$ 的比较替换成 $\textit{cnt}[x]$ 与 $0$ 的比较。

```C++ [sol12-C++]
class Solution {
public:
    bool checkInclusion(string s1, string s2) {
        int n = s1.length(), m = s2.length();
        if (n > m) {
            return false;
        }
        vector<int> cnt(26);
        for (int i = 0; i < n; ++i) {
            --cnt[s1[i] - 'a'];
            ++cnt[s2[i] - 'a'];
        }
        int diff = 0;
        for (int c: cnt) {
            if (c != 0) {
                ++diff;
            }
        }
        if (diff == 0) {
            return true;
        }
        for (int i = n; i < m; ++i) {
            int x = s2[i] - 'a', y = s2[i - n] - 'a';
            if (x == y) {
                continue;
            }
            if (cnt[x] == 0) {
                ++diff;
            }
            ++cnt[x];
            if (cnt[x] == 0) {
                --diff;
            }
            if (cnt[y] == 0) {
                ++diff;
            }
            --cnt[y];
            if (cnt[y] == 0) {
                --diff;
            }
            if (diff == 0) {
                return true;
            }
        }
        return false;
    }
};
```

```Java [sol12-Java]
class Solution {
    public boolean checkInclusion(String s1, String s2) {
        int n = s1.length(), m = s2.length();
        if (n > m) {
            return false;
        }
        int[] cnt = new int[26];
        for (int i = 0; i < n; ++i) {
            --cnt[s1.charAt(i) - 'a'];
            ++cnt[s2.charAt(i) - 'a'];
        }
        int diff = 0;
        for (int c : cnt) {
            if (c != 0) {
                ++diff;
            }
        }
        if (diff == 0) {
            return true;
        }
        for (int i = n; i < m; ++i) {
            int x = s2.charAt(i) - 'a', y = s2.charAt(i - n) - 'a';
            if (x == y) {
                continue;
            }
            if (cnt[x] == 0) {
                ++diff;
            }
            ++cnt[x];
            if (cnt[x] == 0) {
                --diff;
            }
            if (cnt[y] == 0) {
                ++diff;
            }
            --cnt[y];
            if (cnt[y] == 0) {
                --diff;
            }
            if (diff == 0) {
                return true;
            }
        }
        return false;
    }
}
```

```go [sol12-Golang]
func checkInclusion(s1, s2 string) bool {
    n, m := len(s1), len(s2)
    if n > m {
        return false
    }
    cnt := [26]int{}
    for i, ch := range s1 {
        cnt[ch-'a']--
        cnt[s2[i]-'a']++
    }
    diff := 0
    for _, c := range cnt[:] {
        if c != 0 {
            diff++
        }
    }
    if diff == 0 {
        return true
    }
    for i := n; i < m; i++ {
        x, y := s2[i]-'a', s2[i-n]-'a'
        if x == y {
            continue
        }
        if cnt[x] == 0 {
            diff++
        }
        cnt[x]++
        if cnt[x] == 0 {
            diff--
        }
        if cnt[y] == 0 {
            diff++
        }
        cnt[y]--
        if cnt[y] == 0 {
            diff--
        }
        if diff == 0 {
            return true
        }
    }
    return false
}
```

```C [sol12-C]
bool checkInclusion(char* s1, char* s2) {
    int n = strlen(s1), m = strlen(s2);
    if (n > m) {
        return false;
    }
    int cnt[26];
    memset(cnt, 0, sizeof(cnt));
    for (int i = 0; i < n; ++i) {
        --cnt[s1[i] - 'a'];
        ++cnt[s2[i] - 'a'];
    }
    int diff = 0;
    for (int i = 0; i < 26; ++i) {
        if (cnt[i] != 0) {
            ++diff;
        }
    }
    if (diff == 0) {
        return true;
    }
    for (int i = n; i < m; ++i) {
        int x = s2[i] - 'a', y = s2[i - n] - 'a';
        if (x == y) {
            continue;
        }
        if (cnt[x] == 0) {
            ++diff;
        }
        ++cnt[x];
        if (cnt[x] == 0) {
            --diff;
        }
        if (cnt[y] == 0) {
            ++diff;
        }
        --cnt[y];
        if (cnt[y] == 0) {
            --diff;
        }
        if (diff == 0) {
            return true;
        }
    }
    return false;
}
```

```JavaScript [sol12-JavaScript]
var checkInclusion = function(s1, s2) {
    const n = s1.length, m = s2.length;
    if (n > m) {
        return false;
    }
    const cnt = new Array(26).fill(0);
    for (let i = 0; i < n; ++i) {
        --cnt[s1[i].charCodeAt() - 'a'.charCodeAt()];
        ++cnt[s2[i].charCodeAt() - 'a'.charCodeAt()];
    }
    let diff = 0;
    for (const c of cnt) {
        if (c !== 0) {
            ++diff;
        }
    }
    if (diff == 0) {
        return true;
    }
    for (let i = n; i < m; ++i) {
        const x = s2[i].charCodeAt() - 'a'.charCodeAt(), y = s2[i - n].charCodeAt() - 'a'.charCodeAt();
        if (x == y) {
            continue;
        }
        if (cnt[x] == 0) {
            ++diff;
        }
        ++cnt[x];
        if (cnt[x] == 0) {
            --diff;
        }
        if (cnt[y] == 0) {
            ++diff;
        }
        --cnt[y];
        if (cnt[y] == 0) {
            --diff;
        }
        if (diff == 0) {
            return true;
        }
    }
    return false;
};
```

**复杂度分析**

- 时间复杂度：$O(n+m+|\Sigma|)$，其中 $n$ 是字符串 $s_1$ 的长度，$m$ 是字符串 $s_2$ 的长度，$\Sigma$ 是字符集，这道题中的字符集是小写字母，$|\Sigma|=26$。

- 空间复杂度：$O(|\Sigma|)$。

#### 方法二：双指针

回顾方法一的思路，我们在保证区间长度为 $n$ 的情况下，去考察是否存在一个区间使得 $\textit{cnt}$ 的值全为 $0$。

反过来，还可以在保证 $\textit{cnt}$ 的值不为正的情况下，去考察是否存在一个区间，其长度恰好为 $n$。

初始时，仅统计 $s_1$ 中的字符，则 $\textit{cnt}$ 的值均不为正，且元素值之和为 $-n$。

然后用两个指针 $\textit{left}$ 和 $\textit{right}$ 表示考察的区间 $[\textit{left},\textit{right}]$。$\textit{right}$ 每向右移动一次，就统计一次进入区间的字符 $x$。为保证 $\textit{cnt}$ 的值不为正，若此时 $\textit{cnt}[x]>0$，则向右移动左指针，减少离开区间的字符的 $\textit{cnt}$ 值直到 $\textit{cnt}[x] \le 0$。

注意到 $[\textit{left},\textit{right}]$ 的长度每增加 $1$，$\textit{cnt}$ 的元素值之和就增加 $1$。当 $[\textit{left},\textit{right}]$ 的长度恰好为 $n$ 时，就意味着 $\textit{cnt}$ 的元素值之和为 $0$。由于 $\textit{cnt}$ 的值不为正，元素值之和为 $0$ 就意味着所有元素均为 $0$，这样我们就找到了一个目标子串。

```C++ [sol2-C++]
class Solution {
public:
    bool checkInclusion(string s1, string s2) {
        int n = s1.length(), m = s2.length();
        if (n > m) {
            return false;
        }
        vector<int> cnt(26);
        for (int i = 0; i < n; ++i) {
            --cnt[s1[i] - 'a'];
        }
        int left = 0;
        for (int right = 0; right < m; ++right) {
            int x = s2[right] - 'a';
            ++cnt[x];
            while (cnt[x] > 0) {
                --cnt[s2[left] - 'a'];
                ++left;
            }
            if (right - left + 1 == n) {
                return true;
            }
        }
        return false;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean checkInclusion(String s1, String s2) {
        int n = s1.length(), m = s2.length();
        if (n > m) {
            return false;
        }
        int[] cnt = new int[26];
        for (int i = 0; i < n; ++i) {
            --cnt[s1.charAt(i) - 'a'];
        }
        int left = 0;
        for (int right = 0; right < m; ++right) {
            int x = s2.charAt(right) - 'a';
            ++cnt[x];
            while (cnt[x] > 0) {
                --cnt[s2.charAt(left) - 'a'];
                ++left;
            }
            if (right - left + 1 == n) {
                return true;
            }
        }
        return false;
    }
}
```

```go [sol2-Golang]
func checkInclusion(s1, s2 string) bool {
    n, m := len(s1), len(s2)
    if n > m {
        return false
    }
    cnt := [26]int{}
    for _, ch := range s1 {
        cnt[ch-'a']--
    }
    left := 0
    for right, ch := range s2 {
        x := ch - 'a'
        cnt[x]++
        for cnt[x] > 0 {
            cnt[s2[left]-'a']--
            left++
        }
        if right-left+1 == n {
            return true
        }
    }
    return false
}
```

```C [sol2-C]
bool checkInclusion(char* s1, char* s2) {
    int n = strlen(s1), m = strlen(s2);
    if (n > m) {
        return false;
    }
    int cnt[26];
    memset(cnt, 0, sizeof(cnt));
    for (int i = 0; i < n; ++i) {
        --cnt[s1[i] - 'a'];
    }
    int left = 0;
    for (int right = 0; right < m; ++right) {
        int x = s2[right] - 'a';
        ++cnt[x];
        while (cnt[x] > 0) {
            --cnt[s2[left] - 'a'];
            ++left;
        }
        if (right - left + 1 == n) {
            return true;
        }
    }
    return false;
}
```

```JavaScript [sol2-JavaScript]
var checkInclusion = function(s1, s2) {
    const n = s1.length, m = s2.length;
    if (n > m) {
        return false;
    }
    const cnt = new Array(26).fill(0);
    for (let i = 0; i < n; ++i) {
        --cnt[s1[i].charCodeAt() - 'a'.charCodeAt()];
    }
    let left = 0;
    for (let right = 0; right < m; ++right) {
        const x = s2[right].charCodeAt() - 'a'.charCodeAt();
        ++cnt[x];
        while (cnt[x] > 0) {
            --cnt[s2[left].charCodeAt() - 'a'.charCodeAt()];
            ++left;
        }
        if (right - left + 1 === n) {
            return true;
        }
    }
    return false;
};
```

**复杂度分析**

- 时间复杂度：$O(n+m+|\Sigma|)$。
  创建 $\textit{cnt}$ 需要 $O(|\Sigma|)$ 的时间。
  遍历 $s_1$ 需要 $O(n)$ 的时间。
  双指针遍历 $s_2$ 时，由于 $\textit{left}$ 和 $\textit{right}$ 都只会向右移动，故这一部分需要 $O(m)$ 的时间。

- 空间复杂度：$O(|\Sigma|)$。