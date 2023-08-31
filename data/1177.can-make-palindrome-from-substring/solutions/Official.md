## [1177.构建回文串检测 中文官方题解](https://leetcode.cn/problems/can-make-palindrome-from-substring/solutions/100000/gou-jian-hui-wen-chuan-jian-ce-by-leetco-e9i1)

#### 方法一：前缀数组 + 位运算

将 $26$ 个英文字母，对应 $26$ 个位来表示。比如字母 $\text{a}$ 对应 $1 << 0$, 字母 $\text{b}$ 对应 $1 << 1$，字母 $\text{c}$ 对应 $1 << 2$，以此类推。
这样可以将字符串 $s$ 看成一个数组，然后统计数组的异或前缀和 $\textit{count}$，这样就可以统计每一个字母的奇偶性。

遍历所有 $\textit{queries}$，待检子串都可以表示为 $[\textit{left}, \textit{right}, k]$。利用异或前缀和数组，可以得到待检子串每一个字母的奇偶性。出现偶数次的字母，可以对称放在字符串两侧，构成回文串，剩下的出现奇数次字母配对后，还会剩余，需要从中选择最多 $k$ 项替换成任何小写英文字母。替换 $k$ 次，可以保证使得长度最长为 $2\times k + 1$ 的字符串变成回文串。所以我们只需要判断，待检子串的为 $1$ 数位，是否小于 $2\times k + 1$ 即可。

关于计算位 $1$ 的个数，可以参考题解 [191. 位1的个数](https://leetcode.cn/problems/number-of-1-bits/solution/wei-1de-ge-shu-by-leetcode-solution-jnwf/)。

最后返回所有 $\textit{queries}$ 的结果作为答案。

```C++ [sol1-C++]
class Solution {
public:
    vector<bool> canMakePaliQueries(string s, vector<vector<int>>& queries) {
        int n = s.size();
        vector<int> count(n + 1);
        for (int i = 0; i < n; i++) {
            count[i + 1] = count[i] ^ (1 << (s[i] - 'a'));
        }
        vector<bool> res;
        for (auto& query : queries) {
            int l = query[0], r = query[1], k = query[2];
            int bits = 0, x = count[r + 1] ^ count[l];
            while (x > 0) {
                x &= x - 1;
                bits++;
            }
            res.push_back(bits <= k * 2 + 1);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Boolean> canMakePaliQueries(String s, int[][] queries) {
        int n = s.length();
        int[] count = new int[n + 1];
        for (int i = 0; i < n; i++) {
            count[i + 1] = count[i] ^ (1 << (s.charAt(i) - 'a'));
        }
        List<Boolean> res = new ArrayList<>();
        for (int i = 0; i < queries.length; i++) {
            int l = queries[i][0], r = queries[i][1], k = queries[i][2];
            int bits = 0, x = count[r + 1] ^ count[l];
            while (x > 0) {
                x &= x - 1;
                bits++;
            }
            res.add(bits <= k * 2 + 1);
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<bool> CanMakePaliQueries(string s, int[][] queries) {
        int n = s.Length;
        int[] count = new int[n + 1];
        for (int i = 0; i < n; i++) {
            count[i + 1] = count[i] ^ (1 << (s[i] - 'a'));
        }
        List<Boolean> res = new List<Boolean>();
        for (int i = 0; i < queries.Length; i++) {
            int l = queries[i][0], r = queries[i][1], k = queries[i][2];
            int bits = 0, x = count[r + 1] ^ count[l];
            while (x > 0) {
                x &= x - 1;
                bits++;
            }
            res.Add(bits <= k * 2 + 1);
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def canMakePaliQueries(self, s: str, queries: List[List[int]]) -> List[bool]:
        n = len(s)
        count = [0] * (n + 1)
        for i in range(n):
            count[i + 1] = count[i] ^ (1 << (ord(s[i]) - ord('a')))
        res = []
        for l, r, k in queries:
            bits = (count[r + 1] ^ count[l]).bit_count()
            res.append(bits <= k * 2 + 1)
        return res
```

```JavaScript [sol1-JavaScript]
var canMakePaliQueries = function(s, queries) {
    const n = s.length;
    const count = Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) {
        count[i + 1] = count[i] ^ (1 << (s[i].charCodeAt(0) - 'a'.charCodeAt(0)));
    }
    const res = [];
    for (const query of queries) {
        const l = query[0], r = query[1], k = query[2];
        let bits = 0, x = count[r + 1] ^ count[l];
        while (x > 0) {
            x &= x - 1;
            bits++;
        }
        res.push(bits <= k * 2 + 1);
    }
    return res;
}
```

```Go [sol1-Go]
func canMakePaliQueries(s string, queries [][]int) []bool {
    n := len(s)
    count := make([]int, n + 1)
    for i := 0; i < n; i++ {
        count[i + 1] = count[i] ^ (1 << (s[i] - 'a'))
    }
    res := make([]bool, len(queries))
    for i, query := range queries {
        l := query[0]
        r := query[1]
        k := query[2]
        bits := 0
        x := count[r + 1] ^ count[l]
        for x > 0 {
            x &= x - 1
            bits++
        }
        res[i] = bits <= k * 2 + 1
    }
    return res
}
```

```C [sol1-C]
bool* canMakePaliQueries(char * s, int** queries, int queriesSize, int* queriesColSize, int* returnSize) {
    int n = strlen(s);
    int* count = (int*)malloc((n + 1) * sizeof(int));
    memset(count, 0, (n + 1) * sizeof(int));
    for (int i = 0; i < n; i++) {
        count[i + 1] = count[i] ^ (1 << (s[i] - 'a'));
    }
    bool* res = (bool*)malloc(queriesSize * sizeof(bool));
    for (int i = 0; i < queriesSize; i++) {
        int l = queries[i][0], r = queries[i][1], k = queries[i][2];
        int bits = 0, x = count[r + 1] ^ count[l];
        while (x > 0) {
            x &= x - 1;
            bits++;
        }
        res[i] = bits / 2 <= k;
    }
    *returnSize = queriesSize;
    free(count);
    return res;
}
```

**复杂度分析**

+ 时间复杂度：$O(n + m)$，其中 $n$ 是字符串 $s$ 的长度，$m$ 是 $\textit{queries}$ 的长度。忽略统计位 $1$ 的个数的时间复杂度。

+ 空间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。结果不计入空间复杂度。