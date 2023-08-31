## [131.分割回文串 中文官方题解](https://leetcode.cn/problems/palindrome-partitioning/solutions/100000/fen-ge-hui-wen-chuan-by-leetcode-solutio-6jkv)

#### 方法一：回溯 + 动态规划预处理

**思路与算法**

由于需要求出字符串 $s$ 的所有分割方案，因此我们考虑使用搜索 + 回溯的方法枚举所有可能的分割方法并进行判断。

假设我们当前搜索到字符串的第 $i$ 个字符，且 $s[0..i-1]$ 位置的所有字符已经被分割成若干个回文串，并且分割结果被放入了答案数组 $\textit{ans}$ 中，那么我们就需要枚举下一个回文串的右边界 $j$，使得 $s[i..j]$ 是一个回文串。

因此，我们可以从 $i$ 开始，从小到大依次枚举 $j$。对于当前枚举的 $j$ 值，我们使用双指针的方法判断 $s[i..j]$ 是否为回文串：如果 $s[i..j]$ 是回文串，那么就将其加入答案数组 $\textit{ans}$ 中，并以 $j+1$ 作为新的 $i$ 进行下一层搜索，并在未来的回溯时将 $s[i..j]$ 从 $\textit{ans}$ 中移除。

如果我们已经搜索完了字符串的最后一个字符，那么就找到了一种满足要求的分割方法。

**细节**

当我们在判断 $s[i..j]$ 是否为回文串时，常规的方法是使用双指针分别指向 $i$ 和 $j$，每次判断两个指针指向的字符是否相同，直到两个指针相遇。然而这种方法会产生重复计算，例如下面这个例子：

> 当 $s = \texttt{aaba}$ 时，对于前 $2$ 个字符 $\texttt{aa}$，我们有 $2$ 种分割方法 $[\texttt{aa}]$ 和 $[\texttt{a}, \texttt{a}]$，当我们每一次搜索到字符串的第 $i=2$ 个字符 $\texttt{b}$ 时，都需要对于每个 $s[i..j]$ 使用双指针判断其是否为回文串，这就产生了重复计算。

因此，我们可以将字符串 $s$ 的每个子串 $s[i..j]$ 是否为回文串预处理出来，使用动态规划即可。设 $f(i, j)$ 表示 $s[i..j]$ 是否为回文串，那么有状态转移方程：

$$
f(i, j) = \begin{cases}
\texttt{True}, & \quad i \geq j \\
f(i+1,j-1) \wedge (s[i]=s[j]), & \quad \text{otherwise}
\end{cases}
$$

其中 $\wedge$ 表示逻辑与运算，即 $s[i..j]$ 为回文串，当且仅当其为空串（$i>j$），其长度为 $1$（$i=j$），或者首尾字符相同且 $s[i+1..j-1]$ 为回文串。

预处理完成之后，我们只需要 $O(1)$ 的时间就可以判断任意 $s[i..j]$ 是否为回文串了。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    vector<vector<int>> f;
    vector<vector<string>> ret;
    vector<string> ans;
    int n;

public:
    void dfs(const string& s, int i) {
        if (i == n) {
            ret.push_back(ans);
            return;
        }
        for (int j = i; j < n; ++j) {
            if (f[i][j]) {
                ans.push_back(s.substr(i, j - i + 1));
                dfs(s, j + 1);
                ans.pop_back();
            }
        }
    }

    vector<vector<string>> partition(string s) {
        n = s.size();
        f.assign(n, vector<int>(n, true));

        for (int i = n - 1; i >= 0; --i) {
            for (int j = i + 1; j < n; ++j) {
                f[i][j] = (s[i] == s[j]) && f[i + 1][j - 1];
            }
        }

        dfs(s, 0);
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    boolean[][] f;
    List<List<String>> ret = new ArrayList<List<String>>();
    List<String> ans = new ArrayList<String>();
    int n;

    public List<List<String>> partition(String s) {
        n = s.length();
        f = new boolean[n][n];
        for (int i = 0; i < n; ++i) {
            Arrays.fill(f[i], true);
        }

        for (int i = n - 1; i >= 0; --i) {
            for (int j = i + 1; j < n; ++j) {
                f[i][j] = (s.charAt(i) == s.charAt(j)) && f[i + 1][j - 1];
            }
        }

        dfs(s, 0);
        return ret;
    }

    public void dfs(String s, int i) {
        if (i == n) {
            ret.add(new ArrayList<String>(ans));
            return;
        }
        for (int j = i; j < n; ++j) {
            if (f[i][j]) {
                ans.add(s.substring(i, j + 1));
                dfs(s, j + 1);
                ans.remove(ans.size() - 1);
            }
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def partition(self, s: str) -> List[List[str]]:
        n = len(s)
        f = [[True] * n for _ in range(n)]

        for i in range(n - 1, -1, -1):
            for j in range(i + 1, n):
                f[i][j] = (s[i] == s[j]) and f[i + 1][j - 1]

        ret = list()
        ans = list()

        def dfs(i: int):
            if i == n:
                ret.append(ans[:])
                return
            
            for j in range(i, n):
                if f[i][j]:
                    ans.append(s[i:j+1])
                    dfs(j + 1)
                    ans.pop()

        dfs(0)
        return ret
```

```JavaScript [sol1-JavaScript]
var partition = function(s) {
    const dfs = (i) => {
        if (i === n) {
            ret.push(ans.slice());
            return;
        }
        for (let j = i; j < n; ++j) {
            if (f[i][j]) {
                ans.push(s.slice(i, j + 1));
                dfs(j + 1);
                ans.pop();
            }
        }
    }
    
    const n = s.length;
    const f = new Array(n).fill(0).map(() => new Array(n).fill(true));
    let ret = [], ans = [];
    
    for (let i = n - 1; i >= 0; --i) {
        for (let j = i + 1; j < n; ++j) {
            f[i][j] = (s[i] === s[j]) && f[i + 1][j - 1];
        }
    }
    dfs(0);
    return ret;
};
```

```go [sol1-Golang]
func partition(s string) (ans [][]string) {
    n := len(s)
    f := make([][]bool, n)
    for i := range f {
        f[i] = make([]bool, n)
        for j := range f[i] {
            f[i][j] = true
        }
    }
    for i := n - 1; i >= 0; i-- {
        for j := i + 1; j < n; j++ {
            f[i][j] = s[i] == s[j] && f[i+1][j-1]
        }
    }

    splits := []string{}
    var dfs func(int)
    dfs = func(i int) {
        if i == n {
            ans = append(ans, append([]string(nil), splits...))
            return
        }
        for j := i; j < n; j++ {
            if f[i][j] {
                splits = append(splits, s[i:j+1])
                dfs(j + 1)
                splits = splits[:len(splits)-1]
            }
        }
    }
    dfs(0)
    return
}
```

```C [sol1-C]
void dfs(char* s, int n, int i, int** f, char*** ret, int* retSize, int* retColSize, char** ans, int* ansSize) {
    if (i == n) {
        char** tmp = malloc(sizeof(char*) * (*ansSize));
        for (int j = 0; j < (*ansSize); j++) {
            int ansColSize = strlen(ans[j]);
            tmp[j] = malloc(sizeof(char) * (ansColSize + 1));
            strcpy(tmp[j], ans[j]);
        }
        ret[*retSize] = tmp;
        retColSize[(*retSize)++] = *ansSize;
        return;
    }
    for (int j = i; j < n; ++j) {
        if (f[i][j]) {
            char* sub = malloc(sizeof(char) * (j - i + 2));
            for (int k = i; k <= j; k++) {
                sub[k - i] = s[k];
            }
            sub[j - i + 1] = '\0';
            ans[(*ansSize)++] = sub;
            dfs(s, n, j + 1, f, ret, retSize, retColSize, ans, ansSize);
            --(*ansSize);
        }
    }
}

char*** partition(char* s, int* returnSize, int** returnColumnSizes) {
    int n = strlen(s);
    int retMaxLen = n * (1 << n);
    char*** ret = malloc(sizeof(char**) * retMaxLen);
    *returnSize = 0;
    *returnColumnSizes = malloc(sizeof(int) * retMaxLen);
    int* f[n];
    for (int i = 0; i < n; i++) {
        f[i] = malloc(sizeof(int) * n);
        for (int j = 0; j < n; j++) {
            f[i][j] = 1;
        }
    }
    for (int i = n - 1; i >= 0; --i) {
        for (int j = i + 1; j < n; ++j) {
            f[i][j] = (s[i] == s[j]) && f[i + 1][j - 1];
        }
    }
    char* ans[n];
    int ansSize = 0;
    dfs(s, n, 0, f, ret, returnSize, *returnColumnSizes, ans, &ansSize);
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n \cdot 2^n)$，其中 $n$ 是字符串 $s$ 的长度。在最坏情况下，$s$ 包含 $n$ 个完全相同的字符，因此它的任意一种划分方法都满足要求。而长度为 $n$ 的字符串的划分方案数为 $2^{n-1}=O(2^n)$，每一种划分方法需要 $O(n)$ 的时间求出对应的划分结果并放入答案，因此总时间复杂度为 $O(n \cdot 2^n)$。尽管动态规划预处理需要 $O(n^2)$ 的时间，但在渐进意义下小于 $O(n \cdot 2^n)$，因此可以忽略。

- 空间复杂度：$O(n^2)$，这里不计算返回答案占用的空间。数组 $f$ 需要使用的空间为 $O(n^2)$，而在回溯的过程中，我们需要使用 $O(n)$ 的栈空间以及 $O(n)$ 的用来存储当前字符串分割方法的空间。由于 $O(n)$ 在渐进意义下小于 $O(n^2)$，因此空间复杂度为 $O(n^2)$。

#### 方法二：回溯 + 记忆化搜索

**思路与算法**

方法一中的动态规划预处理计算出了任意的 $s[i..j]$ 是否为回文串，我们也可以将这一步改为记忆化搜索。

**代码**

```C++ [sol2-C++]
class Solution {
private:
    vector<vector<int>> f;
    vector<vector<string>> ret;
    vector<string> ans;
    int n;

public:
    void dfs(const string& s, int i) {
        if (i == n) {
            ret.push_back(ans);
            return;
        }
        for (int j = i; j < n; ++j) {
            if (isPalindrome(s, i, j) == 1) {
                ans.push_back(s.substr(i, j - i + 1));
                dfs(s, j + 1);
                ans.pop_back();
            }
        }
    }

    // 记忆化搜索中，f[i][j] = 0 表示未搜索，1 表示是回文串，-1 表示不是回文串
    int isPalindrome(const string& s, int i, int j) {
        if (f[i][j]) {
            return f[i][j];
        }
        if (i >= j) {
            return f[i][j] = 1;
        }
        return f[i][j] = (s[i] == s[j] ? isPalindrome(s, i + 1, j - 1) : -1);
    }

    vector<vector<string>> partition(string s) {
        n = s.size();
        f.assign(n, vector<int>(n));

        dfs(s, 0);
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    int[][] f;
    List<List<String>> ret = new ArrayList<List<String>>();
    List<String> ans = new ArrayList<String>();
    int n;

    public List<List<String>> partition(String s) {
        n = s.length();
        f = new int[n][n];

        dfs(s, 0);
        return ret;
    }

    public void dfs(String s, int i) {
        if (i == n) {
            ret.add(new ArrayList<String>(ans));
            return;
        }
        for (int j = i; j < n; ++j) {
            if (isPalindrome(s, i, j) == 1) {
                ans.add(s.substring(i, j + 1));
                dfs(s, j + 1);
                ans.remove(ans.size() - 1);
            }
        }
    }

    // 记忆化搜索中，f[i][j] = 0 表示未搜索，1 表示是回文串，-1 表示不是回文串
    public int isPalindrome(String s, int i, int j) {
        if (f[i][j] != 0) {
            return f[i][j];
        }
        if (i >= j) {
            f[i][j] = 1;
        } else if (s.charAt(i) == s.charAt(j)) {
            f[i][j] = isPalindrome(s, i + 1, j - 1);
        } else {
            f[i][j] = -1;
        }
        return f[i][j];
    }
}
```

```Python [sol2-Python3]
class Solution:
    def partition(self, s: str) -> List[List[str]]:
        n = len(s)

        ret = list()
        ans = list()

        @cache
        def isPalindrome(i: int, j: int) -> int:
            if i >= j:
                return 1
            return isPalindrome(i + 1, j - 1) if s[i] == s[j] else -1

        def dfs(i: int):
            if i == n:
                ret.append(ans[:])
                return
            
            for j in range(i, n):
                if isPalindrome(i, j) == 1:
                    ans.append(s[i:j+1])
                    dfs(j + 1)
                    ans.pop()

        dfs(0)
        isPalindrome.cache_clear()
        return ret
```

```JavaScript [sol2-JavaScript]
var partition = function(s) {
    const dfs = (i) => {
        if (i === n) {
            ret.push(ans.slice());
            return;
        }
        for (let j = i; j < n; ++j) {
            if (isPalindrome(i, j) === 1) {
                ans.push(s.slice(i, j + 1));
                dfs(j + 1);
                ans.pop();
            }
        }
    }

    // 记忆化搜索中，f[i][j] = 0 表示未搜索，1 表示是回文串，-1 表示不是回文串
    const isPalindrome = (i, j) => {
        if (f[i][j] !== 0) {
            return f[i][j];
        }
        if (i >= j) {
            f[i][j] = 1;
        } else if (s[i] === s[j]) {
            f[i][j] = isPalindrome(i + 1, j - 1);
        } else {
            f[i][j] = -1;
        }
        return f[i][j];
    }

    const n = s.length;
    const ret = [], ans = [];
    const f = new Array(n).fill(0).map(() => new Array(n).fill(0));

    dfs(0);
    return ret;
};
```

```go [sol2-Golang]
func partition(s string) (ans [][]string) {
    n := len(s)
    f := make([][]int8, n)
    for i := range f {
        f[i] = make([]int8, n)
    }

    // 0 表示尚未搜索，1 表示是回文串，-1 表示不是回文串
    var isPalindrome func(i, j int) int8
    isPalindrome = func(i, j int) int8 {
        if i >= j {
            return 1
        }
        if f[i][j] != 0 {
            return f[i][j]
        }
        f[i][j] = -1
        if s[i] == s[j] {
            f[i][j] = isPalindrome(i+1, j-1)
        }
        return f[i][j]
    }

    splits := []string{}
    var dfs func(int)
    dfs = func(i int) {
        if i == n {
            ans = append(ans, append([]string(nil), splits...))
            return
        }
        for j := i; j < n; j++ {
            if isPalindrome(i, j) > 0 {
                splits = append(splits, s[i:j+1])
                dfs(j + 1)
                splits = splits[:len(splits)-1]
            }
        }
    }
    dfs(0)
    return
}
```

```C [sol2-C]
// 记忆化搜索中，f[i][j] = 0 表示未搜索，1 表示是回文串，-1 表示不是回文串
int isPalindrome(char* s, int** f, int i, int j) {
    if (f[i][j]) {
        return f[i][j];
    }
    if (i >= j) {
        return f[i][j] = 1;
    }
    return f[i][j] = (s[i] == s[j] ? isPalindrome(s, f, i + 1, j - 1) : -1);
}

void dfs(char* s, int n, int i, int** f, char*** ret, int* retSize, int* retColSize, char** ans, int* ansSize) {
    if (i == n) {
        char** tmp = malloc(sizeof(char*) * (*ansSize));
        for (int j = 0; j < (*ansSize); j++) {
            int ansColSize = strlen(ans[j]);
            tmp[j] = malloc(sizeof(char) * (ansColSize + 1));
            strcpy(tmp[j], ans[j]);
        }
        ret[*retSize] = tmp;
        retColSize[(*retSize)++] = *ansSize;
        return;
    }
    for (int j = i; j < n; ++j) {
        if (isPalindrome(s, f, i, j) == 1) {
            char* sub = malloc(sizeof(char) * (j - i + 2));
            for (int k = i; k <= j; k++) {
                sub[k - i] = s[k];
            }
            sub[j - i + 1] = '\0';
            ans[(*ansSize)++] = sub;
            dfs(s, n, j + 1, f, ret, retSize, retColSize, ans, ansSize);
            --(*ansSize);
        }
    }
}

char*** partition(char* s, int* returnSize, int** returnColumnSizes) {
    int n = strlen(s);
    int retMaxLen = n * (1 << n);
    char*** ret = malloc(sizeof(char**) * retMaxLen);
    *returnSize = 0;
    *returnColumnSizes = malloc(sizeof(int) * retMaxLen);
    int* f[n];
    for (int i = 0; i < n; i++) {
        f[i] = malloc(sizeof(int) * n);
        for (int j = 0; j < n; j++) {
            f[i][j] = 1;
        }
    }
    for (int i = n - 1; i >= 0; --i) {
        for (int j = i + 1; j < n; ++j) {
            f[i][j] = (s[i] == s[j]) && f[i + 1][j - 1];
        }
    }
    char* ans[n];
    int ansSize = 0;
    dfs(s, n, 0, f, ret, returnSize, *returnColumnSizes, ans, &ansSize);
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n \cdot 2^n)$，其中 $n$ 是字符串 $s$ 的长度，与方法一相同。

- 空间复杂度：$O(n^2)$，与方法一相同。