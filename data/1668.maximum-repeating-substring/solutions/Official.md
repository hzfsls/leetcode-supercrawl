#### 方法一：简单枚举 + 动态规划

**思路与算法**

我们可以将给定字符串 $\textit{sequence}$ 的每一个位置作为结束位置，判断前面的若干个字符是否恰好是字符串 $\textit{word}$。如果第 $i$ 个位置是，那么可以记录 $\textit{valid}[i]$ 的值为 $1$，否则为 $0$。

当我们得到了数组 $\textit{valid}$ 后，就可以计算最大重复值了。我们可以得到递推式：

$$
f[i] = \begin{cases}
f[i-|\textit{word}|] + 1, & \textit{valid}[i]=1 \wedge i \geq |\textit{word}| \\
1, & \textit{valid}[i]=1 \wedge i < |\textit{word}| \\
0, & \text{otherwise}
\end{cases}
$$

这里 $f[i]$ 表示字符串 $\textit{word}$ 在第 $i$ 个位置最后一次出现时的最大重复值，那么只有在 $\textit{valid}[i]$ 为 $1$ 时最大重复值才不为 $0$，需要进行递推。字符串 $\textit{word}$ 在第 $i$ 个位置前出现的最大重复值可以通过 $f[i-|\textit{word}|]$ 获得（其中 $|\textit{word}|$ 表示字符串 $\textit{word}$ 的长度），如果该项没有意义，那么它的值为 $0$。

最终的答案即为数组 $f$ 中的最大值。注意到在求解 $f[i]$ 时，我们无需存储除了 $\textit{valid}[i]$ 以外的数组 $\textit{valid}$ 的项。因此可以省去数组 $\textit{valid}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxRepeating(string sequence, string word) {
        int n = sequence.size(), m = word.size();
        if (n < m) {
            return 0;
        }

        vector<int> f(n);
        for (int i = m - 1; i < n; ++i) {
            bool valid = true;
            for (int j = 0; j < m; ++j) {
                if (sequence[i - m + j + 1] != word[j]) {
                    valid = false;
                    break;
                }
            }
            if (valid) {
                f[i] = (i == m - 1 ? 0 : f[i - m]) + 1;
            }
        }
        
        return *max_element(f.begin(), f.end());
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxRepeating(String sequence, String word) {
        int n = sequence.length(), m = word.length();
        if (n < m) {
            return 0;
        }

        int[] f = new int[n];
        for (int i = m - 1; i < n; ++i) {
            boolean valid = true;
            for (int j = 0; j < m; ++j) {
                if (sequence.charAt(i - m + j + 1) != word.charAt(j)) {
                    valid = false;
                    break;
                }
            }
            if (valid) {
                f[i] = (i == m - 1 ? 0 : f[i - m]) + 1;
            }
        }

        return Arrays.stream(f).max().getAsInt();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxRepeating(string sequence, string word) {
        int n = sequence.Length, m = word.Length;
        if (n < m) {
            return 0;
        }

        int[] f = new int[n];
        for (int i = m - 1; i < n; ++i) {
            bool valid = true;
            for (int j = 0; j < m; ++j) {
                if (sequence[i - m + j + 1] != word[j]) {
                    valid = false;
                    break;
                }
            }
            if (valid) {
                f[i] = (i == m - 1 ? 0 : f[i - m]) + 1;
            }
        }

        return f.Max();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxRepeating(self, sequence: str, word: str) -> int:
        n, m = len(sequence), len(word)
        if n < m:
            return 0
        
        f = [0] * n
        for i in range(m - 1, n):
            valid = True
            for j in range(m):
                if sequence[i - m + j + 1] != word[j]:
                    valid = False
                    break
            if valid:
                f[i] = (0 if i == m - 1 else f[i - m]) + 1
        
        return max(f)
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxRepeating(char * sequence, char * word){
    int n = strlen(sequence), m = strlen(word);
    if (n < m) {
        return 0;
    }

    int f[n];
    memset(f, 0, sizeof(f));
    for (int i = m - 1; i < n; ++i) {
        bool valid = true;
        for (int j = 0; j < m; ++j) {
            if (sequence[i - m + j + 1] != word[j]) {
                valid = false;
                break;
            }
        }
        if (valid) {
            f[i] = (i == m - 1 ? 0 : f[i - m]) + 1;
        }
    }
    int res = 0;
    for (int i = 0; i < n; i++) {
        res = MAX(res, f[i]);
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var maxRepeating = function(sequence, word) {
    const n = sequence.length, m = word.length;
    if (n < m) {
        return 0;
    }

    const f = new Array(n).fill(0);
    for (let i = m - 1; i < n; ++i) {
        let valid = true;
        for (let j = 0; j < m; ++j) {
            if (sequence[i - m + j + 1] !== word[j]) {
                valid = false;
                break;
            }
        }
        if (valid) {
            f[i] = (i === m - 1 ? 0 : f[i - m]) + 1;
        }
    }

    return _.max(f);
};
```

```go [sol1-Golang]
func maxRepeating(sequence, word string) (ans int) {
    n, m := len(sequence), len(word)
    if n < m {
        return
    }
    f := make([]int, n)
    for i := m - 1; i < n; i++ {
        if sequence[i-m+1:i+1] == word {
            if i == m-1 {
                f[i] = 1
            } else {
                f[i] = f[i-m] + 1
            }
            if f[i] > ans {
                ans = f[i]
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $n$ 和 $m$ 分别是字符串 $\textit{sequence}$ 和 $\textit{word}$ 的长度。

- 空间复杂度：$O(n)$，即为数组 $f$ 需要使用的空间。

#### 方法二：KMP 算法 + 动态规划

**思路与算法**

方法一的数组 $\textit{valid}$ 本质上就是标记了字符串 $\textit{word}$ 在字符串 $\textit{sequence}$ 中所有出现的位置。而我们可以使用更高效的 [KMP 算法](https://oi-wiki.org/string/kmp/) 在 $O(m+n)$ 的时间内得到数组 $\textit{valid}$。对于 KMP 算法本身，本篇题解不再赘述，感兴趣的读者可以自行通过链接进行学习。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int maxRepeating(string sequence, string word) {
        int n = sequence.size(), m = word.size();
        if (n < m) {
            return 0;
        }

        vector<int> fail(m, -1);
        for (int i = 1; i < m; ++i) {
            int j = fail[i - 1];
            while (j != -1 && word[j + 1] != word[i]) {
                j = fail[j];
            }
            if (word[j + 1] == word[i]) {
                fail[i] = j + 1;
            }
        }

        vector<int> f(n);
        int j = -1;
        for (int i = 0; i < n; ++i) {
            while (j != -1 && word[j + 1] != sequence[i]) {
                j = fail[j];
            }
            if (word[j + 1] == sequence[i]) {
                ++j;
                if (j == m - 1) {
                    f[i] = (i >= m ? f[i - m] : 0) + 1;
                    j = fail[j];
                }
            }
        }

        return *max_element(f.begin(), f.end());
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxRepeating(String sequence, String word) {
        int n = sequence.length(), m = word.length();
        if (n < m) {
            return 0;
        }

        int[] fail = new int[m];
        Arrays.fill(fail, -1);
        for (int i = 1; i < m; ++i) {
            int j = fail[i - 1];
            while (j != -1 && word.charAt(j + 1) != word.charAt(i)) {
                j = fail[j];
            }
            if (word.charAt(j + 1) == word.charAt(i)) {
                fail[i] = j + 1;
            }
        }

        int[] f = new int[n];
        int j = -1;
        for (int i = 0; i < n; ++i) {
            while (j != -1 && word.charAt(j + 1) != sequence.charAt(i)) {
                j = fail[j];
            }
            if (word.charAt(j + 1) == sequence.charAt(i)) {
                ++j;
                if (j == m - 1) {
                    f[i] = (i >= m ? f[i - m] : 0) + 1;
                    j = fail[j];
                }
            }
        }

        return Arrays.stream(f).max().getAsInt();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxRepeating(string sequence, string word) {
        int n = sequence.Length, m = word.Length;
        if (n < m) {
            return 0;
        }

        int[] fail = new int[m];
        Array.Fill(fail, -1);
        int j;
        for (int i = 1; i < m; ++i) {
            j = fail[i - 1];
            while (j != -1 && word[j + 1] != word[i]) {
                j = fail[j];
            }
            if (word[j + 1] == word[i]) {
                fail[i] = j + 1;
            }
        }

        int[] f = new int[n];
        j = -1;
        for (int i = 0; i < n; ++i) {
            while (j != -1 && word[j + 1] != sequence[i]) {
                j = fail[j];
            }
            if (word[j + 1] == sequence[i]) {
                ++j;
                if (j == m - 1) {
                    f[i] = (i >= m ? f[i - m] : 0) + 1;
                    j = fail[j];
                }
            }
        }

        return f.Max();
    }
}
```

```Python [sol2-Python3]
class Solution:
    def maxRepeating(self, sequence: str, word: str) -> int:
        n, m = len(sequence), len(word)
        if n < m:
            return 0

        fail = [-1] * m
        for i in range(1, m):
            j = fail[i - 1]
            while j != -1 and word[j + 1] != word[i]:
                j = fail[j]
            if word[j + 1] == word[i]:
                fail[i] = j + 1
        
        f = [0] * n
        j = -1
        for i in range(n):
            while j != -1 and word[j + 1] != sequence[i]:
                j = fail[j]
            if word[j + 1] == sequence[i]:
                j += 1
                if j == m - 1:
                    f[i] = (0 if i == m - 1 else f[i - m]) + 1
                    j = fail[j]
        
        return max(f)
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxRepeating(char * sequence, char * word){
    int n = strlen(sequence), m = strlen(word);
    if (n < m) {
        return 0;
    }

    int fail[m];
    memset(fail, -1, sizeof(fail));
    for (int i = 1; i < m; ++i) {
        int j = fail[i - 1];
        while (j != -1 && word[j + 1] != word[i]) {
            j = fail[j];
        }
        if (word[j + 1] == word[i]) {
            fail[i] = j + 1;
        }
    }

    int f[n];
    memset(f, 0, sizeof(f));
    for (int i = 0, j = -1; i < n; ++i) {
        while (j != -1 && word[j + 1] != sequence[i]) {
            j = fail[j];
        }
        if (word[j + 1] == sequence[i]) {
            ++j;
            if (j == m - 1) {
                f[i] = (i >= m ? f[i - m] : 0) + 1;
                j = fail[j];
            }
        }
    }
    int res = 0;
    for (int i = 0; i < n; i++) {
        res = MAX(res, f[i]);
    }
    return res;
}
```

```JavaScript [sol2-JavaScript]
var maxRepeating = function(sequence, word) {
    const n = sequence.length, m = word.length;
    if (n < m) {
        return 0;
    }

    const fail = new Array(n).fill(-1);
    for (let i = 1; i < m; ++i) {
        let j = fail[i - 1];
        while (j !== -1 && word[j + 1] !== word[i]) {
            j = fail[j];
        }
        if (word[j + 1] === word[i]) {
            fail[i] = j + 1;
        }
    }

    const f = new Array(n).fill(0);
    let j = -1;
    for (let i = 0; i < n; ++i) {
        while (j !== -1 && word[j + 1] !== sequence[i]) {
            j = fail[j];
        }
        if (word[j + 1] === sequence[i]) {
            ++j;
            if (j === m - 1) {
                f[i] = (i >= m ? f[i - m] : 0) + 1;
                j = fail[j];
            }
        }
    }

    return _.max(f)
};
```

```go [sol2-Golang]
func maxRepeating(sequence, word string) (ans int) {
    n, m := len(sequence), len(word)
    if n < m {
        return
    }
    fail := make([]int, m)
    for i := range fail {
        fail[i] = -1
    }
    for i := 1; i < m; i++ {
        j := fail[i-1]
        for j != -1 && word[j+1] != word[i] {
            j = fail[j]
        }
        if word[j+1] == word[i] {
            fail[i] = j + 1
        }
    }

    f := make([]int, n)
    j := -1
    for i := 0; i < n; i++ {
        for j != -1 && word[j+1] != sequence[i] {
            j = fail[j]
        }
        if word[j+1] == sequence[i] {
            j++
            if j == m-1 {
                if i < m {
                    f[i] = 1
                } else {
                    f[i] = f[i-m] + 1
                }
                if f[i] > ans {
                    ans = f[i]
                }
                j = fail[j]
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(m + n)$，其中 $n$ 和 $m$ 分别是字符串 $\textit{sequence}$ 和 $\textit{word}$ 的长度。

- 空间复杂度：$O(m + n)$，即为 KMP 算法中的数组 $\textit{fail}$ 以及数组 $f$ 需要使用的空间。