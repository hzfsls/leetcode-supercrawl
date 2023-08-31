## [1625.执行操作后字典序最小的字符串 中文官方题解](https://leetcode.cn/problems/lexicographically-smallest-string-after-applying-operations/solutions/100000/zhi-xing-cao-zuo-hou-zi-dian-xu-zui-xiao-4jyr)
#### 方法一：枚举

**思路与算法**

题目有两种操作：
1. 累加，将 $s$ 的奇数位元素加上 $a$，超过 $9$ 则回到 $0$ 继续加。
2. 轮转，将 $s$ 向右轮转 $b$ 位。

以上操作可以进行无限次，问可以得到的字典序最小的字符串。

注意到条件中 $s$ 的长度是偶数，因此如果 $b$ 是偶数，那么无论轮转多少次，我们都只能给 $s$ 中奇数位的元素做累加操作。但如果 $b$ 是奇数的话，我们可以给 $s$ 中奇数位和偶数位的元素都做加法，并且可以做不同的次数。

从以上可以看出，做累加操作的次数和做轮转操作的次数是互相独立的，做轮转的次数并不会影响到能否对偶数位进行累加。因此我们可以先枚举做轮转的次数，然后再枚举做累加的次数，从而找到字典序最小的答案。

更具体的，我们按照如下步骤进行枚举：

1. 枚举做轮转的次数，然后令 $t$ 为 $s$ 轮转后的字符串。由于轮转最终会产生循环，且至多轮转 $n$ 次（$n$ 为 $s$ 的长度），因此我们用一个数组 $\textit{vis}$ 来记录每个位置是否被轮转过。如果遇到之前轮转过的位置，则枚举结束。
2. 对于每个 $t$，枚举对 $t$ 的奇数位做累加操作的次数 $j$，再枚举对 $t$ 的偶数位做累加操作的次数 $k$。这里因为元素值范围是 $[0,9]$，因此我们做累加操作的次数上限是 $9$，再多势必会产生循环。特殊的，如果 $b$ 是偶数，则 $k$ 的上限是 $0$，否则是 $9$。

**代码**

```C++ [sol1_1-C++]
class Solution {
public:
    string findLexSmallestString(string s, int a, int b) {
        int n = s.size();
        vector<int> vis(n);
        string res = s;
        // 将 s 延长一倍，方便截取轮转后的字符串 t
        s = s + s;
        for (int i = 0; vis[i] == 0; i = (i + b) % n) {
            vis[i] = 1;
            for (int j = 0; j < 10; j++) {
                int k_limit = b % 2 == 0 ? 0 : 9;
                for (int k = 0; k <= k_limit; k++) {
                    // 每次进行累加之前，重新截取 t
                    string t = s.substr(i, n);
                    for (int p = 1; p < n; p += 2) {
                        t[p] = '0' + (t[p] - '0' + j * a) % 10;
                    }
                    for (int p = 0; p < n; p += 2) {
                        t[p] = '0' + (t[p] - '0' + k * a) % 10;
                    }
                    res = min(res, t);
                }
            }
        }
        return res;
    }
};
```

```Java [sol1_1-Java]
class Solution {
    public String findLexSmallestString(String s, int a, int b) {
        int n = s.length();
        boolean[] vis = new boolean[n];
        String res = s;
        // 将 s 延长一倍，方便截取轮转后的字符串 t
        s = s + s;
        for (int i = 0; !vis[i]; i = (i + b) % n) {
            vis[i] = true;
            for (int j = 0; j < 10; j++) {
                int kLimit = b % 2 == 0 ? 0 : 9;
                for (int k = 0; k <= kLimit; k++) {
                    // 每次进行累加之前，重新截取 t
                    char[] t = s.substring(i, i + n).toCharArray();
                    for (int p = 1; p < n; p += 2) {
                        t[p] = (char) ('0' + (t[p] - '0' + j * a) % 10);
                    }
                    for (int p = 0; p < n; p += 2) {
                        t[p] = (char) ('0' + (t[p] - '0' + k * a) % 10);
                    }
                    String tStr = new String(t);
                    if (tStr.compareTo(res) < 0) {
                        res = tStr;
                    }
                }
            }
        }
        return res;
    }
}
```

```C# [sol1_1-C#]
public class Solution {
    public string FindLexSmallestString(string s, int a, int b) {
        int n = s.Length;
        bool[] vis = new bool[n];
        string res = s;
        // 将 s 延长一倍，方便截取轮转后的字符串 t
        s = s + s;
        for (int i = 0; !vis[i]; i = (i + b) % n) {
            vis[i] = true;
            for (int j = 0; j < 10; j++) {
                int kLimit = b % 2 == 0 ? 0 : 9;
                for (int k = 0; k <= kLimit; k++) {
                    // 每次进行累加之前，重新截取 t
                    char[] t = s.Substring(i, n).ToCharArray();
                    for (int p = 1; p < n; p += 2) {
                        t[p] = (char) ('0' + (t[p] - '0' + j * a) % 10);
                    }
                    for (int p = 0; p < n; p += 2) {
                        t[p] = (char) ('0' + (t[p] - '0' + k * a) % 10);
                    }
                    string tStr = new string(t);
                    if (tStr.CompareTo(res) < 0) {
                        res = tStr;
                    }
                }
            }
        }
        return res;
    }
}
```

```C [sol1_1-C]
char * findLexSmallestString(char * s, int a, int b) {
    int n = strlen(s);
    int vis[n];
    memset(vis, 0, sizeof(vis));
    char *res = (char *)calloc(sizeof(char), n + 1);
    strcpy(res, s);
    // 将 s 延长一倍，方便截取轮转后的字符串 t
    char str[2 * n + 1];
    sprintf(str, "%s%s", s, s);
    for (int i = 0; vis[i] == 0; i = (i + b) % n) {
        vis[i] = 1;
        for (int j = 0; j < 10; j++) {
            int k_limit = b % 2 == 0 ? 0 : 9;
            for (int k = 0; k <= k_limit; k++) {
                // 每次进行累加之前，重新截取 t
                char t[n + 1];
                strncpy(t, str + i, n);
                t[n] = '\0';
                for (int p = 1; p < n; p += 2) {
                    t[p] = '0' + (t[p] - '0' + j * a) % 10;
                }
                for (int p = 0; p < n; p += 2) {
                    t[p] = '0' + (t[p] - '0' + k * a) % 10;
                }
                if (strcmp(t, res) < 0) {
                    strcpy(res, t);
                }
            }
        }
    }
    return res;
}
```

```JavaScript [sol1_1-JavaScript]
var findLexSmallestString = function(s, a, b) {
    const n = s.length;
    const vis = new Array(n).fill(false);
    let res = s;
    // 将 s 延长一倍，方便截取轮转后的字符串 t
    s = s + s;
    for (let i = 0; !vis[i]; i = (i + b) % n) {
        vis[i] = true;
        for (let j = 0; j < 10; j++) {
            let kLimit = b % 2 === 0 ? 0 : 9;
            for (let k = 0; k <= kLimit; k++) {
                // 每次进行累加之前，重新截取 t
                const t = [...s.slice(i, i + n)];
                for (let p = 1; p < n; p += 2) {
                    t[p] = String.fromCharCode('0'.charCodeAt() + (t[p].charCodeAt() - '0'.charCodeAt() + j * a) % 10);
                }
                for (let p = 0; p < n; p += 2) {
                    t[p] = String.fromCharCode('0'.charCodeAt() + (t[p].charCodeAt() - '0'.charCodeAt() + k * a) % 10);
                }
                const tStr = t.join('');
                if (tStr < res) {
                    res = tStr;
                }
            }
        }
    }
    return res;
};
```

枚举轮转次数过程中，我们依次考虑了如下位置：$0 \times b \pmod n,~1 \times b \pmod n,~2 \times b \pmod n,\cdots, x \times b\pmod n$。我们可以用一个表达式来计算最终到达的位置：

$$xb - yn = z$$

其中 $x$ 是轮转次数，$y$ 是取模过程减去 $n$ 的次数，而 $z$ 是最终到达的位置。

根据[裴蜀定理](https://oi-wiki.org/math/number-theory/bezouts/)可知 $z$ 一定是 $gcd(b, n)$ 的倍数，因此我们只需要枚举 $[0, n)$ 中 $gcd(b, n)$ 的倍数即可。

```C++ [sol1_2-C++]
class Solution {
public:
    string findLexSmallestString(string s, int a, int b) {
        int n = s.size();
        string res = s;
        s = s + s;
        int g = gcd(b, n);
        for (int i = 0; i < n; i += g) {
            for (int j = 0; j < 10; j++) {
                int k_limit = b % 2 == 0 ? 0 : 9;
                for (int k = 0; k <= k_limit; k++) {
                    string t = s.substr(i, n);
                    for (int p = 1; p < n; p += 2) {
                        t[p] = '0' + (t[p] - '0' + j * a) % 10;
                    }
                    for (int p = 0; p < n; p += 2) {
                        t[p] = '0' + (t[p] - '0' + k * a) % 10;
                    }
                    res = min(res, t);
                }
            }
        }
        return res;
    }
};
```

```Java [sol1_2-Java]
class Solution {
    public String findLexSmallestString(String s, int a, int b) {
        int n = s.length();
        String res = s;
        s = s + s;
        int g = gcd(b, n);
        for (int i = 0; i < n; i += g) {
            for (int j = 0; j < 10; j++) {
                int kLimit = b % 2 == 0 ? 0 : 9;
                for (int k = 0; k <= kLimit; k++) {
                    char[] t = s.substring(i, i + n).toCharArray();
                    for (int p = 1; p < n; p += 2) {
                        t[p] = (char) ('0' + (t[p] - '0' + j * a) % 10);
                    }
                    for (int p = 0; p < n; p += 2) {
                        t[p] = (char) ('0' + (t[p] - '0' + k * a) % 10);
                    }
                    String tStr = new String(t);
                    if (tStr.compareTo(res) < 0) {
                        res = tStr;
                    }
                }
            }
        }
        return res;
    }

    public int gcd(int num1, int num2) {
        while (num2 != 0) {
            int temp = num1;
            num1 = num2;
            num2 = temp % num2;
        }
        return num1;
    }
}
```

```C# [sol1_2-C#]
public class Solution {
    public string FindLexSmallestString(string s, int a, int b) {
        int n = s.Length;
        string res = s;
        s = s + s;
        int g = GCD(b, n);
        for (int i = 0; i < n; i += g) {
            for (int j = 0; j < 10; j++) {
                int kLimit = b % 2 == 0 ? 0 : 9;
                for (int k = 0; k <= kLimit; k++) {
                    char[] t = s.Substring(i, n).ToCharArray();
                    for (int p = 1; p < n; p += 2) {
                        t[p] = (char) ('0' + (t[p] - '0' + j * a) % 10);
                    }
                    for (int p = 0; p < n; p += 2) {
                        t[p] = (char) ('0' + (t[p] - '0' + k * a) % 10);
                    }
                    string tStr = new string(t);
                    if (tStr.CompareTo(res) < 0) {
                        res = tStr;
                    }
                }
            }
        }
        return res;
    }

    public int GCD(int num1, int num2) {
        while (num2 != 0) {
            int temp = num1;
            num1 = num2;
            num2 = temp % num2;
        }
        return num1;
    }
}
```

```C [sol1_2-C]
int gcd(int num1, int num2) {
    while (num2 != 0) {
        int temp = num1;
        num1 = num2;
        num2 = temp % num2;
    }
    return num1;
}

char * findLexSmallestString(char * s, int a, int b) {
    int n = strlen(s);
    int vis[n];
    memset(vis, 0, sizeof(vis));
    char *res = (char *)calloc(sizeof(char), n + 1);
    strcpy(res, s);
    // 将 s 延长一倍，方便截取轮转后的字符串 t
    char str[2 * n + 1];
    sprintf(str, "%s%s", s, s);
    int g = gcd(b, n);
    for (int i = 0; i < n; i += g) {
        vis[i] = 1;
        for (int j = 0; j < 10; j++) {
            int k_limit = b % 2 == 0 ? 0 : 9;
            for (int k = 0; k <= k_limit; k++) {
                // 每次进行累加之前，重新截取 t
                char t[n + 1];
                strncpy(t, str + i, n);
                t[n] = '\0';
                for (int p = 1; p < n; p += 2) {
                    t[p] = '0' + (t[p] - '0' + j * a) % 10;
                }
                for (int p = 0; p < n; p += 2) {
                    t[p] = '0' + (t[p] - '0' + k * a) % 10;
                }
                if (strcmp(t, res) < 0) {
                    strcpy(res, t);
                }
            }
        }
    }
    return res;
}
```

```JavaScript [sol1_2-JavaScript]
var findLexSmallestString = function(s, a, b) {
    const n = s.length;
    let res = s;
    s = s + s;
    const g = gcd(b, n);
    for (let i = 0; i < n; i += g) {
        for (let j = 0; j < 10; j++) {
            const kLimit = b % 2 === 0 ? 0 : 9;
            for (let k = 0; k <= kLimit; k++) {
                const t = [...s.slice(i, i + n)];
                for (let p = 1; p < n; p += 2) {
                    t[p] = String.fromCharCode('0'.charCodeAt() + (t[p].charCodeAt() - '0'.charCodeAt() + j * a) % 10);
                }
                for (let p = 0; p < n; p += 2) {
                    t[p] = String.fromCharCode('0'.charCodeAt() + (t[p].charCodeAt() - '0'.charCodeAt() + k * a) % 10);
                }
                const tStr = t.join('');
                if (tStr < res) {
                    res = tStr;
                }
            }
        }
    }
    return res;
}

const gcd = (num1, num2) => {
    while (num2 !== 0) {
        const temp = num1;
        num1 = num2;
        num2 = temp % num2;
    }
    return num1;
};
```

枚举累加次数的过程中，我们的目的是让字符串的字典序更小，由于奇偶位两组互相独立，组内累加次数相同，因此我们只需考虑 $t[0]$ 和 $t[1]$ 即可。

我们先要找到使得 $t[1]$ 最小的轮转次数，对奇数位进行累加。如果 $b$ 是奇数，我们还要找到让 $t[0]$ 最小的轮转次数，对偶数位进行累加。

```C++ [sol1_3-C++]
class Solution {
public:
    string findLexSmallestString(string s, int a, int b) {
        int n = s.size();
        string res = s;
        s = s + s;
        int g = gcd(b, n);
        
        auto add = [&](string& t, int start) {
            int minVal = 10, times = 0;
            for (int i = 0; i < 10; i++) {
                int added = ((t[start] - '0') + i * a) % 10;
                if (added < minVal) {
                    minVal = added;
                    times = i;
                }
            }
            for (int i = start; i < n; i += 2) {
                t[i] = '0' + ((t[i] - '0') + times * a) % 10;
            }
        };

        for (int i = 0; i < n; i += g) {
            string t = s.substr(i, n);
            add(t, 1);
            if (b % 2) {
                add(t, 0);
            }
            res = min(res, t);
        }
        return res;
    }
};
```

```Java [sol1_3-Java]
class Solution {
    public String findLexSmallestString(String s, int a, int b) {
        int n = s.length();
        String res = s;
        s = s + s;
        int g = gcd(b, n);

        for (int i = 0; i < n; i += g) {
            char[] t = s.substring(i, i + n).toCharArray();
            add(t, n, a, 1);
            if (b % 2 != 0) {
                add(t, n, a, 0);
            }
            String tStr = new String(t);
            if (tStr.compareTo(res) < 0) {
                res = tStr;
            }
        }
        return res;
    }

    public void add(char[] t, int n, int a, int start) {
        int minVal = 10, times = 0;
        for (int i = 0; i < 10; i++) {
            int added = ((t[start] - '0') + i * a) % 10;
            if (added < minVal) {
                minVal = added;
                times = i;
            }
        }
        for (int i = start; i < n; i += 2) {
            t[i] = (char) ('0' + ((t[i] - '0') + times * a) % 10);
        }
    }

    public int gcd(int num1, int num2) {
        while (num2 != 0) {
            int temp = num1;
            num1 = num2;
            num2 = temp % num2;
        }
        return num1;
    }
}
```

```C# [sol1_3-C#]
public class Solution {
    public string FindLexSmallestString(string s, int a, int b) {
        int n = s.Length;
        string res = s;
        s = s + s;
        int g = GCD(b, n);

        for (int i = 0; i < n; i += g) {
            char[] t = s.Substring(i, n).ToCharArray();
            Add(t, n, a, 1);
            if (b % 2 != 0) {
                Add(t, n, a, 0);
            }
            string tStr = new string(t);
            if (tStr.CompareTo(res) < 0) {
                res = tStr;
            }
        }
        return res;
    }

    public void Add(char[] t, int n, int a, int start) {
        int minVal = 10, times = 0;
        for (int i = 0; i < 10; i++) {
            int added = ((t[start] - '0') + i * a) % 10;
            if (added < minVal) {
                minVal = added;
                times = i;
            }
        }
        for (int i = start; i < n; i += 2) {
            t[i] = (char) ('0' + ((t[i] - '0') + times * a) % 10);
        }
    }

    public int GCD(int num1, int num2) {
        while (num2 != 0) {
            int temp = num1;
            num1 = num2;
            num2 = temp % num2;
        }
        return num1;
    }
}
```

```C [sol1_3-C]
int gcd(int num1, int num2) {
    while (num2 != 0) {
        int temp = num1;
        num1 = num2;
        num2 = temp % num2;
    }
    return num1;
}

void add(char *t, int n, int a, int start) {
    int minVal = 10, times = 0;
    for (int i = 0; i < 10; i++) {
        int added = ((t[start] - '0') + i * a) % 10;
        if (added < minVal) {
            minVal = added;
            times = i;
        }
    }
    for (int i = start; i < n; i += 2) {
        t[i] = '0' + ((t[i] - '0') + times * a) % 10;
    }
};

char * findLexSmallestString(char * s, int a, int b) {
    int n = strlen(s);
    int vis[n];
    memset(vis, 0, sizeof(vis));
    char *res = (char *)calloc(sizeof(char), n + 1);
    strcpy(res, s);
    // 将 s 延长一倍，方便截取轮转后的字符串 t
    char str[2 * n + 1];
    sprintf(str, "%s%s", s, s);
    int g = gcd(b, n);
    for (int i = 0; i < n; i += g) {
        char t[n + 1];
        strncpy(t, str + i, n);
        t[n] = '\0';
        add(t, n, a, 1);
        if (b % 2 != 0) {
            add(t, n, a, 0);
        }
        if (strcmp(t, res) < 0) {
            strcpy(res, t);
        }
    }
    return res;
}
```

```JavaScript [sol1_3-JavaScript]
var findLexSmallestString = function(s, a, b) {
    const n = s.length;
    let res = s;
    s = s + s;
    const g = gcd(b, n);

    for (let i = 0; i < n; i += g) {
        const t = [...s.slice(i, i + n)];
        add(t, n, a, 1);
        if (b % 2 !== 0) {
            add(t, n, a, 0);
        }
        const tStr = t.join('');
        if (tStr < res) {
            res = tStr;
        }
    }
    return res;
}

const add = (t, n, a, start) => {
    let minVal = 10, times = 0;
    for (let i = 0; i < 10; i++) {
        const added = ((t[start].charCodeAt() - '0'.charCodeAt()) + i * a) % 10;
        if (added < minVal) {
            minVal = added;
            times = i;
        }
    }
    for (let i = start; i < n; i += 2) {
        t[i] = String.fromCharCode('0'.charCodeAt() + ((t[i].charCodeAt() - '0'.charCodeAt()) + times * a) % 10);
    }
}

const gcd = (num1, num2) => {
    while (num2 !== 0) {
        const temp = num1;
        num1 = num2;
        num2 = temp % num2;
    }
    return num1;
};
```

**复杂度分析**

- 时间复杂度：$O(n^2d^2)$，其中 $n$ 是 $s$ 的长度，$d$ 是枚举累加次数的上限，本题中等于 $10$。优化枚举轮转次数后，算法复杂度常数级别降低，在最坏情况下仍然为 $O(n^2d^2)$。优化枚举累加次数后，时间复杂度降低为 $O(n^2d)$。

- 空间复杂度：$O(n)$，其中 $n$ 是 $s$ 的长度。