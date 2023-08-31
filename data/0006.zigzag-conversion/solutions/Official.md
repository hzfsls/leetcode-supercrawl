## [6.N 字形变换 中文官方题解](https://leetcode.cn/problems/zigzag-conversion/solutions/100000/z-zi-xing-bian-huan-by-leetcode-solution-4n3u)
#### 方法一：利用二维矩阵模拟

设 $n$ 为字符串 $s$ 的长度，$r=\textit{numRows}$。对于 $r=1$（只有一行）或者 $r\ge n$（只有一列）的情况，答案与 $s$ 相同，我们可以直接返回 $s$。对于其余情况，考虑创建一个二维矩阵，然后在矩阵上按 Z 字形填写字符串 $s$，最后逐行扫描矩阵中的非空字符，组成答案。

根据题意，当我们在矩阵上填写字符时，会向下填写 $r$ 个字符，然后向右上继续填写 $r-2$ 个字符，最后回到第一行，因此 Z 字形变换的周期 $t=r+r-2=2r-2$，每个周期会占用矩阵上的 $1+r-2=r-1$ 列。

因此我们有 $\Big\lceil\dfrac{n}{t}\Big\rceil$ 个周期（最后一个周期视作完整周期），乘上每个周期的列数，得到矩阵的列数 $c=\Big\lceil\dfrac{n}{t}\Big\rceil\cdot(r-1)$。

创建一个 $r$ 行 $c$ 列的矩阵，然后遍历字符串 $s$ 并按 Z 字形填写。具体来说，设当前填写的位置为 $(x,y)$，即矩阵的 $x$ 行 $y$ 列。初始 $(x,y)=(0,0)$，即矩阵左上角。若当前字符下标 $i$ 满足 $i\bmod t<r-1$，则向下移动，否则向右上移动。

填写完成后，逐行扫描矩阵中的非空字符，组成答案。

```Python [sol1-Python3]
class Solution:
    def convert(self, s: str, numRows: int) -> str:
        n, r = len(s), numRows
        if r == 1 or r >= n:
            return s
        t = r * 2 - 2
        c = (n + t - 1) // t * (r - 1)
        mat = [[''] * c for _ in range(r)]
        x, y = 0, 0
        for i, ch in enumerate(s):
            mat[x][y] = ch
            if i % t < r - 1:
                x += 1  # 向下移动
            else:
                x -= 1
                y += 1  # 向右上移动
        return ''.join(ch for row in mat for ch in row if ch)
```

```C++ [sol1-C++]
class Solution {
public:
    string convert(string s, int numRows) {
        int n = s.length(), r = numRows;
        if (r == 1 || r >= n) {
            return s;
        }
        int t = r * 2 - 2;
        int c = (n + t - 1) / t * (r - 1);
        vector<string> mat(r, string(c, 0));
        for (int i = 0, x = 0, y = 0; i < n; ++i) {
            mat[x][y] = s[i];
            if (i % t < r - 1) {
                ++x; // 向下移动
            } else {
                --x;
                ++y; // 向右上移动
            }
        }
        string ans;
        for (auto &row : mat) {
            for (char ch : row) {
                if (ch) {
                    ans += ch;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String convert(String s, int numRows) {
        int n = s.length(), r = numRows;
        if (r == 1 || r >= n) {
            return s;
        }
        int t = r * 2 - 2;
        int c = (n + t - 1) / t * (r - 1);
        char[][] mat = new char[r][c];
        for (int i = 0, x = 0, y = 0; i < n; ++i) {
            mat[x][y] = s.charAt(i);
            if (i % t < r - 1) {
                ++x; // 向下移动
            } else {
                --x;
                ++y; // 向右上移动
            }
        }
        StringBuffer ans = new StringBuffer();
        for (char[] row : mat) {
            for (char ch : row) {
                if (ch != 0) {
                    ans.append(ch);
                }
            }
        }
        return ans.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string Convert(string s, int numRows) {
        int n = s.Length, r = numRows;
        if (r == 1 || r >= n) {
            return s;
        }
        int t = r * 2 - 2;
        int c = (n + t - 1) / t * (r - 1);
        char[][] mat = new char[r][];
        for (int i = 0; i < r; ++i) {
            mat[i] = new char[c];
        }
        for (int i = 0, x = 0, y = 0; i < n; ++i) {
            mat[x][y] = s[i];
            if (i % t < r - 1) {
                ++x; // 向下移动
            } else {
                --x;
                ++y; // 向右上移动
            }
        }
        StringBuilder ans = new StringBuilder();
        foreach (char[] row in mat) {
            foreach (char ch in row) {
                if (ch != 0) {
                    ans.Append(ch);
                }
            }
        }
        return ans.ToString();
    }
}
```

```go [sol1-Golang]
func convert(s string, numRows int) string {
    n, r := len(s), numRows
    if r == 1 || r >= n {
        return s
    }
    t := r*2 - 2
    c := (n + t - 1) / t * (r - 1)
    mat := make([][]byte, r)
    for i := range mat {
        mat[i] = make([]byte, c)
    }
    x, y := 0, 0
    for i, ch := range s {
        mat[x][y] = byte(ch)
        if i%t < r-1 {
            x++ // 向下移动
        } else {
            x--
            y++ // 向右上移动
        }
    }
    ans := make([]byte, 0, n)
    for _, row := range mat {
        for _, ch := range row {
            if ch > 0 {
                ans = append(ans, ch)
            }
        }
    }
    return string(ans)
}
```

```C [sol1-C]
char * convert(char * s, int numRows){
    int n = strlen(s), r = numRows;
    if (r == 1 || r >= n) {
        return s;
    }
    int t = r * 2 - 2;
    int c = (n + t - 1) / t * (r - 1);
    char ** mat = (char **)malloc(sizeof(char *) * r);
    for (int i = 0; i < r; i++) {
        mat[i] = (char *)malloc(sizeof(char) * c); 
        memset(mat[i], 0, sizeof(char) * c);                       
    }
    for (int i = 0, x = 0, y = 0; i < n; ++i) {
        mat[x][y] = s[i];
        if (i % t < r - 1) {
            ++x; // 向下移动
        } else {
            --x;
            ++y; // 向右上移动
        }
    }
    int pos = 0;
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            if(mat[i][j]) {
                s[pos++] = mat[i][j];
            }
        }
        free(mat[i]);
    }
    free(mat);
    return s;
}
```

```JavaScript [sol1-JavaScript]
var convert = function(s, numRows) {
    const n = s.length, r = numRows;
    if (r === 1 || r >= n) {
        return s;
    }
    const t = r * 2 - 2;
    const c = Math.floor((n + t - 1) / t) * (r - 1);
    const mat = new Array(r).fill(0).map(() => new Array(c).fill(0));
    for (let i = 0, x = 0, y = 0; i < n; ++i) {
        mat[x][y] = s[i];
        if (i % t < r - 1) {
            ++x; // 向下移动
        } else {
            --x;
            ++y; // 向右上移动
        }
    }
    const ans = [];
    for (const row of mat) {
        for (const ch of row) {
            if (ch !== 0) {
                ans.push(ch);
            }
        }
    }
    return ans.join('');
};
```

**复杂度分析**

- 时间复杂度：$O(r\cdot n)$，其中 $r=\textit{numRows}$，$n$ 为字符串 $s$ 的长度。时间主要消耗在矩阵的创建和遍历上，矩阵的行数为 $r$，列数可以视为 $O(n)$。

- 空间复杂度：$O(r\cdot n)$。矩阵需要 $O(r\cdot n)$ 的空间。

#### 方法二：压缩矩阵空间

方法一中的矩阵有大量的空间没有被使用，能否优化呢？

注意到每次往矩阵的某一行添加字符时，都会添加到该行上一个字符的右侧，且最后组成答案时只会用到每行的非空字符。因此我们可以将矩阵的每行初始化为一个空列表，每次向某一行添加字符时，添加到该行的列表末尾即可。

```Python [sol2-Python3]
class Solution:
    def convert(self, s: str, numRows: int) -> str:
        r = numRows
        if r == 1 or r >= len(s):
            return s
        mat = [[] for _ in range(r)]
        t, x = r * 2 - 2, 0
        for i, ch in enumerate(s):
            mat[x].append(ch)
            x += 1 if i % t < r - 1 else -1
        return ''.join(chain(*mat))
```

```C++ [sol2-C++]
class Solution {
public:
    string convert(string s, int numRows) {
        int n = s.length(), r = numRows;
        if (r == 1 || r >= n) {
            return s;
        }
        vector<string> mat(r);
        for (int i = 0, x = 0, t = r * 2 - 2; i < n; ++i) {
            mat[x] += s[i];
            i % t < r - 1 ? ++x : --x;
        }
        string ans;
        for (auto &row : mat) {
            ans += row;
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public String convert(String s, int numRows) {
        int n = s.length(), r = numRows;
        if (r == 1 || r >= n) {
            return s;
        }
        StringBuffer[] mat = new StringBuffer[r];
        for (int i = 0; i < r; ++i) {
            mat[i] = new StringBuffer();
        }
        for (int i = 0, x = 0, t = r * 2 - 2; i < n; ++i) {
            mat[x].append(s.charAt(i));
            if (i % t < r - 1) {
                ++x;
            } else {
                --x;
            }
        }
        StringBuffer ans = new StringBuffer();
        for (StringBuffer row : mat) {
            ans.append(row);
        }
        return ans.toString();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string Convert(string s, int numRows) {
        int n = s.Length, r = numRows;
        if (r == 1 || r >= n) {
            return s;
        }
        StringBuilder[] mat = new StringBuilder[r];
        for (int i = 0; i < r; ++i) {
            mat[i] = new StringBuilder();
        }
        for (int i = 0, x = 0, t = r * 2 - 2; i < n; ++i) {
            mat[x].Append(s[i]);
            if (i % t < r - 1) {
                ++x;
            } else {
                --x;
            }
        }
        StringBuilder ans = new StringBuilder();
        foreach (StringBuilder row in mat) {
            ans.Append(row);
        }
        return ans.ToString();
    }
}
```

```go [sol2-Golang]
func convert(s string, numRows int) string {
    r := numRows
    if r == 1 || r >= len(s) {
        return s
    }
    mat := make([][]byte, r)
    t, x := r*2-2, 0
    for i, ch := range s {
        mat[x] = append(mat[x], byte(ch))
        if i%t < r-1 {
            x++
        } else {
            x--
        }
    }
    return string(bytes.Join(mat, nil))
}
```

```C [sol2-C]
char * convert(char * s, int numRows){
    int n = strlen(s), r = numRows;
    if (r == 1 || r >= n) {
        return s;
    }
    char ** mat = (char **)malloc(sizeof(char *) * r);
    int * columSize = (int *)malloc(sizeof(int) * numRows);
    memset(columSize, 0, sizeof(int) * numRows);
    for (int i = 0; i < r; i++) {
        mat[i] = (char *)malloc(sizeof(char) * (n + 1)); 
        memset(mat[i], 0, sizeof(char) * (n + 1));                       
    }
    for (int i = 0, x = 0, t = r * 2 - 2; i < n; ++i) {
        mat[x][columSize[x]++] = s[i];
        i % t < r - 1 ? ++x : --x;
    }
    int pos = 0;
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < columSize[i]; j++) {
            s[pos++] = mat[i][j];
        }
        free(mat[i]);
    }
    free(columSize);
    free(mat);
    return s;
}
```

```JavaScript [sol2-JavaScript]
var convert = function(s, numRows) {
    const n = s.length, r = numRows;
    if (r === 1 || r >= n) {
        return s;
    }
    const mat = new Array(r).fill(0);
    for (let i = 0; i < r; ++i) {
        mat[i] = [];
    }
    for (let i = 0, x = 0, t = r * 2 - 2; i < n; ++i) {
        mat[x].push(s[i]);
        if (i % t < r - 1) {
            ++x;
        } else {
            --x;
        }
    }
    const ans = [];
    for (const row of mat) {
        ans.push(row.join(''));
    }
    return ans.join('');
};
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(n)$。压缩后的矩阵需要 $O(n)$ 的空间。


#### 方法三：直接构造

我们来研究方法一中矩阵的每个非空字符会对应到 $s$ 的哪个下标（记作 $\textit{idx}$），从而直接构造出答案。

由于 Z 字形变换的周期为 $t=2r-2$，因此对于矩阵第一行的非空字符，其对应的 $\textit{idx}$ 均为 $t$ 的倍数，即 $\textit{idx}\equiv 0\pmod t$；同理，对于矩阵最后一行的非空字符，应满足 $\textit{idx}\equiv r-1\pmod t$。

对于矩阵的其余行（行号设为 $i$），每个周期内有两个字符，第一个字符满足 $\textit{idx}\equiv i\pmod t$，第二个字符满足 $\textit{idx}\equiv t-i\pmod t$。

```Python [sol3-Python3]
class Solution:
    def convert(self, s: str, numRows: int) -> str:
        n, r = len(s), numRows
        if r == 1 or r >= n:
            return s
        t = r * 2 - 2
        ans = []
        for i in range(r):  # 枚举矩阵的行
            for j in range(0, n - i, t):  # 枚举每个周期的起始下标
                ans.append(s[j + i])  # 当前周期的第一个字符
                if 0 < i < r - 1 and j + t - i < n:
                    ans.append(s[j + t - i])  # 当前周期的第二个字符
        return ''.join(ans)
```

```C++ [sol3-C++]
class Solution {
public:
    string convert(string s, int numRows) {
        int n = s.length(), r = numRows;
        if (r == 1 || r >= n) {
            return s;
        }
        string ans;
        int t = r * 2 - 2;
        for (int i = 0; i < r; ++i) { // 枚举矩阵的行
            for (int j = 0; j + i < n; j += t) { // 枚举每个周期的起始下标
                ans += s[j + i]; // 当前周期的第一个字符
                if (0 < i && i < r - 1 && j + t - i < n) {
                    ans += s[j + t - i]; // 当前周期的第二个字符
                }
            }
        }
        return ans;
    }
};
```

```go [sol3-Golang]
func convert(s string, numRows int) string {
    n, r := len(s), numRows
    if r == 1 || r >= n {
        return s
    }
    t := r*2 - 2
    ans := make([]byte, 0, n)
    for i := 0; i < r; i++ { // 枚举矩阵的行
        for j := 0; j+i < n; j += t { // 枚举每个周期的起始下标
            ans = append(ans, s[j+i]) // 当前周期的第一个字符
            if 0 < i && i < r-1 && j+t-i < n {
                ans = append(ans, s[j+t-i]) // 当前周期的第二个字符
            }
        }
    }
    return string(ans)
}
```

```C [sol3-C]
char * convert(char * s, int numRows){
    int n = strlen(s), r = numRows;
    if (r == 1 || r >= n) {
        return s;
    }
    int t = r * 2 - 2;
    char * ans = (char *)malloc(sizeof(char) * (n + 1));
    int pos = 0;
    for (int i = 0; i < r; ++i) { // 枚举矩阵的行
        for (int j = 0; j + i < n; j += t) { // 枚举每个周期的起始下标
            ans[pos++] = s[j + i]; // 当前周期的第一个字符
            if (0 < i && i < r - 1 && j + t - i < n) {
                ans[pos++] = s[j + t - i]; // 当前周期的第二个字符
            }
        }
    }
    ans[pos] = '\0';
    return ans;
}
```

```JavaScript [sol3-JavaScript]
var convert = function(s, numRows) {
    const n = s.length, r = numRows;
    if (r === 1 || r >= n) {
        return s;
    }
    const t = r * 2 - 2;
    const ans = [];
    for (let i = 0; i < r; i++) { // 枚举矩阵的行
        for (let j = 0; j < n - i; j += t) { // 枚举每个周期的起始下标
            ans.push(s[j + i]); // 当前周期的第一个字符
            if (0 < i && i < r - 1 && j + t - i < n) {
                ans.push(s[j + t - i]); // 当前周期的第二个字符
            }
        }
    }
    return ans.join('');
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度。$s$ 中的每个字符仅会被访问一次，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。返回值不计入空间复杂度。