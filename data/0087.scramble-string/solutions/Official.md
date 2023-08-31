## [87.扰乱字符串 中文官方题解](https://leetcode.cn/problems/scramble-string/solutions/100000/rao-luan-zi-fu-chuan-by-leetcode-solutio-8r9t)
#### 方法一：动态规划

**思路与算法**

显然「扰乱字符串」的关系是具有对称性的，即如果 $s_1$ 是 $s_2$ 的扰乱字符串，那么 $s_2$ 也是 $s_1$ 的扰乱字符串。为了叙述方便，我们称这种情况下，$s_1$ 和 $s_2$ 是「和谐」的。

那么如何判断 $s_1$ 和 $s_2$ 是否「和谐」呢？我们首先可以想到几个简单的判断方法：

- 如果 $s_1 = s_2$，那么它们是「和谐」的；

- 如果 $s_1$ 和 $s_2$ 的长度不同，那么它们一定不是「和谐」的；

- 如果 $s_1$ 中某个字符 $c$ 出现了 $x_1$ 次，而 $c$ 在 $s_2$ 中出现了 $x_2$ 次，且 $x_1 \neq x_2$，那么它们一定不是「和谐」的。这是因为任意操作都不会改变一个字符串中的字符种类以及数量。

那么对于剩下的情况，我们该如何判断呢？我们可以从 $s_1$ 的分割方法入手。假设 $s_1$ 作为根节点时被分割成了 $l(s_1)$ 以及 $r(s_1)$ 两个子串，那么：

- 如果 $l(s_1)$ 和 $r(s_1)$ 没有被交换，那么 $s_2$ 需要存在一种分割方法 $s_2 = l(s_2) + r(s_2)$，使得 $l(s_1)$ 和 $l(s_2)$ 是「和谐」的，并且 $r(s_1)$ 和 $r(s_2)$ 也是「和谐」的；

- 如果 $l(s_1)$ 和 $r(s_1)$ 被交换了，那么 $s_2$ 需要存在一种分割方法 $s_2 = l(s_2) + r(s_2)$，使得 $l(s_1)$ 和 $r(s_2)$ 是「和谐」的，并且 $r(s_1)$ 和 $l(s_2)$ 也是「和谐」的。

![fig1](https://assets.leetcode-cn.com/solution-static/87/1.png)

这样一来，我们就把原本需要解决的问题划分成了两个本质相同，但规模更小的子问题，因此可以考虑使用动态规划解决。

设 $f(s_1, s_2)$ 表示 $s_1$ 和 $s_2$ 是否「和谐」，那么我们可以写出状态转移方程：

$$
f(s_1, s_2) =
\begin{cases}
\text{True}, & \quad s_1=s_2 \\
\text{False}, & \quad 存在某个字符~c，它在~s_1~和~s_2~中的出现次数不同 \\
\end{cases}
$$

因为题目保证给定的原始字符串的长度相同，因此我们只需要判断上面的两种情况。如果 $s_1$ 和 $s_2$ 不符合这两种情况，那么我们需要枚举分割点。

设 $s_1$ 和 $s_2$ 的长度为 $n$，我们用 $s_1(x, y)$ 表示从 $s_1$ 从第 $x$ 个字符（从 $0$ 开始编号）开始，长度为 $y$ 的子串。由于分割出的两个字符串不能为空串，那么其中一个字符串就是 $s_1(0, i)$，另一个字符串是 $s_1(i, n-i)$。

- 对于 $l(s_1)$ 和 $r(s_1)$ 没有被交换的情况，$s_2$ 同样需要被分为 $s_2(0, i)$ 以及 $s_2(i, n-i)$，否则长度不同的字符串是不可能「和谐」的。因此我们可以写出状态转移方程：

    $$
    f(s_1, s_2) = \bigvee_{i=1}^{n-1} \big( f(s_1(0, i), s_2(0, i)) \wedge f(s_1(i, n-i), s_2(i, n-i)) \big)
    $$

    其中 $\wedge$ 表示与运算，即 $s_1$ 和 $s_2$ 分割出的两对字符串都要是「和谐」的；$\vee$ 表示或运算，即只要有一种满足要求的分割方法，$s_1$ 和 $s_2$ 就是和谐的。

- 对于 $l(s_1)$ 和 $r(s_1)$ 被交换的情况，$s_2$ 需要被分为 $s_2(0, n-i)$ 以及 $s_2(n-i, i)$，这样对应的长度才会相同。因此我们可以写出状态转移方程：

    $$
    f(s_1, s_2) = \bigvee_{i=1}^{n-1} \big( f(s_1(0, i), s_2(n-i, i)) \wedge f(s_1(i, n-i), s_2(0, n-i)) \big)
    $$

我们将上面两种状态转移方程用 $\vee$ 或运算拼在一起，即可得到最终的状态转移方程。

**细节**

细节部分比较长，希望读者仔细阅读，否则写出来的代码可能会较为复杂，或者使用较多不必要的空间。

1. 在进行状态转移时，我们需要**先计算出较短的字符串对应的 $f$ 值**，再去转移计算出较长的字符串对应的 $f$ 值，这是因为我们需要**保证在计算 $f(s_1, s_2)$ 时，所有它们的子串对应的状态都需要被计算过**。因此，如果我们使用常规的动态规划方法编写代码，可能会受到计算顺序的困扰，使得代码冗长。

    而我们可以考虑使用「记忆化搜索」自顶向下地进行动态规划，这样我们只需要用题目中给定的两个原始字符串开始，递归地计算所有的 $f$ 值，而无需考虑计算顺序。

2. 由于我们使用记忆化搜索，因此我们需要把 $s_1$ 和 $s_2$ 作为参数传入记忆化搜索使用的递归函数。这样一来，在递归传递参数的过程中，会使用到大量字符串的切片、拷贝等操作，使得时空复杂度不那么优。本题中，由于给定原始字符串的长度不超过 $30$，因此不会产生太大的影响，但我们还是要尽可能对代码进行优化。

    一种通用的优化方法是，我们将状态变更为 $f(i_1, i_2, \textit{length})$，表示第一个字符串是原始字符串从第 $i_1$ 个字符开始，长度为 $\textit{length}$ 的子串，第二个字符串是原始字符串从第 $i_2$ 个字符开始，长度为 $\textit{length}$ 的子串。可以发现，我们只是改变了表达 $s_1$ 和 $s_2$ 的方式，但此时我们只需要在递归时传递三个整数类型的变量，省去了字符串的操作；

**代码**

```C++ [sol1-C++]
class Solution {
private:
    // 记忆化搜索存储状态的数组
    // -1 表示 false，1 表示 true，0 表示未计算
    int memo[30][30][31];
    string s1, s2;

public:
    bool checkIfSimilar(int i1, int i2, int length) {
        unordered_map<int, int> freq;
        for (int i = i1; i < i1 + length; ++i) {
            ++freq[s1[i]];
        }
        for (int i = i2; i < i2 + length; ++i) {
            --freq[s2[i]];
        }
        if (any_of(freq.begin(), freq.end(), [](const auto& entry) {return entry.second != 0;})) {
            return false;
        }
        return true;
    }

    // 第一个字符串从 i1 开始，第二个字符串从 i2 开始，子串的长度为 length，是否和谐
    bool dfs(int i1, int i2, int length) {
        if (memo[i1][i2][length]) {
            return memo[i1][i2][length] == 1;
        }

        // 判断两个子串是否相等
        if (s1.substr(i1, length) == s2.substr(i2, length)) {
            memo[i1][i2][length] = 1;
            return true;
        }

        // 判断是否存在字符 c 在两个子串中出现的次数不同
        if (!checkIfSimilar(i1, i2, length)) {
            memo[i1][i2][length] = -1;
            return false;
        }
        
        // 枚举分割位置
        for (int i = 1; i < length; ++i) {
            // 不交换的情况
            if (dfs(i1, i2, i) && dfs(i1 + i, i2 + i, length - i)) {
                memo[i1][i2][length] = 1;
                return true;
            }
            // 交换的情况
            if (dfs(i1, i2 + length - i, i) && dfs(i1 + i, i2, length - i)) {
                memo[i1][i2][length] = 1;
                return true;
            }
        }

        memo[i1][i2][length] = -1;
        return false;
    }

    bool isScramble(string s1, string s2) {
        memset(memo, 0, sizeof(memo));
        this->s1 = s1;
        this->s2 = s2;
        return dfs(0, 0, s1.size());
    }
};
```

```Java [sol1-Java]
class Solution {
    // 记忆化搜索存储状态的数组
    // -1 表示 false，1 表示 true，0 表示未计算
    int[][][] memo;
    String s1, s2;

    public boolean isScramble(String s1, String s2) {
        int length = s1.length();
        this.memo = new int[length][length][length + 1];
        this.s1 = s1;
        this.s2 = s2;
        return dfs(0, 0, length);
    }

    // 第一个字符串从 i1 开始，第二个字符串从 i2 开始，子串的长度为 length，是否和谐
    public boolean dfs(int i1, int i2, int length) {
        if (memo[i1][i2][length] != 0) {
            return memo[i1][i2][length] == 1;
        }

        // 判断两个子串是否相等
        if (s1.substring(i1, i1 + length).equals(s2.substring(i2, i2 + length))) {
            memo[i1][i2][length] = 1;
            return true;
        }

        // 判断是否存在字符 c 在两个子串中出现的次数不同
        if (!checkIfSimilar(i1, i2, length)) {
            memo[i1][i2][length] = -1;
            return false;
        }
        
        // 枚举分割位置
        for (int i = 1; i < length; ++i) {
            // 不交换的情况
            if (dfs(i1, i2, i) && dfs(i1 + i, i2 + i, length - i)) {
                memo[i1][i2][length] = 1;
                return true;
            }
            // 交换的情况
            if (dfs(i1, i2 + length - i, i) && dfs(i1 + i, i2, length - i)) {
                memo[i1][i2][length] = 1;
                return true;
            }
        }

        memo[i1][i2][length] = -1;
        return false;
    }

    public boolean checkIfSimilar(int i1, int i2, int length) {
        Map<Character, Integer> freq = new HashMap<Character, Integer>();
        for (int i = i1; i < i1 + length; ++i) {
            char c = s1.charAt(i);
            freq.put(c, freq.getOrDefault(c, 0) + 1);
        }
        for (int i = i2; i < i2 + length; ++i) {
            char c = s2.charAt(i);
            freq.put(c, freq.getOrDefault(c, 0) - 1);
        }
        for (Map.Entry<Character, Integer> entry : freq.entrySet()) {
            int value = entry.getValue();
            if (value != 0) {
                return false;
            }
        }
        return true;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isScramble(self, s1: str, s2: str) -> bool:
        @cache
        def dfs(i1: int, i2: int, length: int) -> bool:
            """
            第一个字符串从 i1 开始，第二个字符串从 i2 开始，子串的长度为 length，是否和谐
            """

            # 判断两个子串是否相等
            if s1[i1:i1+length] == s2[i2:i2+length]:
                return True
            
            # 判断是否存在字符 c 在两个子串中出现的次数不同
            if Counter(s1[i1:i1+length]) != Counter(s2[i2:i2+length]):
                return False
            
            # 枚举分割位置
            for i in range(1, length):
                # 不交换的情况
                if dfs(i1, i2, i) and dfs(i1 + i, i2 + i, length - i):
                    return True
                # 交换的情况
                if dfs(i1, i2 + length - i, i) and dfs(i1 + i, i2, length - i):
                    return True
        
            return False

        ans = dfs(0, 0, len(s1))
        dfs.cache_clear()
        return ans
```

```go [sol1-Golang]
func isScramble(s1, s2 string) bool {
    n := len(s1)
    dp := make([][][]int8, n)
    for i := range dp {
        dp[i] = make([][]int8, n)
        for j := range dp[i] {
            dp[i][j] = make([]int8, n+1)
            for k := range dp[i][j] {
                dp[i][j][k] = -1
            }
        }
    }

    // 第一个字符串从 i1 开始，第二个字符串从 i2 开始，子串的长度为 length
    // 和谐返回 1，不和谐返回 0
    var dfs func(i1, i2, length int) int8
    dfs = func(i1, i2, length int) (res int8) {
        d := &dp[i1][i2][length]
        if *d != -1 {
            return *d
        }
        defer func() { *d = res }()

        // 判断两个子串是否相等
        x, y := s1[i1:i1+length], s2[i2:i2+length]
        if x == y {
            return 1
        }

        // 判断是否存在字符 c 在两个子串中出现的次数不同
        freq := [26]int{}
        for i, ch := range x {
            freq[ch-'a']++
            freq[y[i]-'a']--
        }
        for _, f := range freq[:] {
            if f != 0 {
                return 0
            }
        }

        // 枚举分割位置
        for i := 1; i < length; i++ {
            // 不交换的情况
            if dfs(i1, i2, i) == 1 && dfs(i1+i, i2+i, length-i) == 1 {
                return 1
            }
            // 交换的情况
            if dfs(i1, i2+length-i, i) == 1 && dfs(i1+i, i2, length-i) == 1 {
                return 1
            }
        }

        return 0
    }
    return dfs(0, 0, n) == 1
}
```

```C [sol1-C]
struct HashTable {
    int key;
    int val;
    UT_hash_handle hh;
};

void modifyHashTable(struct HashTable** hashTable, int x, int inc) {
    struct HashTable* tmp;
    HASH_FIND_INT(*hashTable, &x, tmp);
    if (tmp == NULL) {
        tmp = malloc(sizeof(struct HashTable));
        tmp->key = x;
        tmp->val = inc;
        HASH_ADD_INT(*hashTable, key, tmp);
    } else {
        tmp->val += inc;
    }
}

bool checkHashTable(struct HashTable** hashTable) {
    struct HashTable *iter, *tmp;
    HASH_ITER(hh, *hashTable, iter, tmp) {
        if (iter->val) {
            return false;
        }
    }
    return true;
}

void freeHashTable(struct HashTable** hashTable) {
    struct HashTable *iter, *tmp;
    HASH_ITER(hh, *hashTable, iter, tmp) {
        HASH_DEL(*hashTable, iter);
        free(iter);
    }
}

bool equals(char* s1, char* s2, int i1, int i2, int len) {
    for (int i = 0; i < len; i++) {
        if (s1[i + i1] != s2[i + i2]) {
            return false;
        }
    }
    return true;
}

// 记忆化搜索存储状态的数组
// -1 表示 false，1 表示 true，0 表示未计算
int memo[30][30][31];

// 第一个字符串从 i1 开始，第二个字符串从 i2 开始，子串的长度为 length，是否和谐
bool dfs(char* s1, char* s2, int i1, int i2, int length) {
    if (memo[i1][i2][length]) {
        return memo[i1][i2][length] == 1;
    }

    // 判断两个子串是否相等
    if (equals(s1, s2, i1, i2, length)) {
        memo[i1][i2][length] = 1;
        return true;
    }

    // 判断是否存在字符 c 在两个子串中出现的次数不同
    struct HashTable* hashTable = NULL;

    for (int i = i1; i < i1 + length; ++i) {
        modifyHashTable(&hashTable, s1[i], 1);
    }
    for (int i = i2; i < i2 + length; ++i) {
        modifyHashTable(&hashTable, s2[i], -1);
    }
    if (!checkHashTable(&hashTable)) {
        memo[i1][i2][length] = -1;
        return false;
    }
    freeHashTable(&hashTable);

    // 枚举分割位置
    for (int i = 1; i < length; ++i) {
        // 不交换的情况
        if (dfs(s1, s2, i1, i2, i) && dfs(s1, s2, i1 + i, i2 + i, length - i)) {
            memo[i1][i2][length] = 1;
            return true;
        }
        // 交换的情况
        if (dfs(s1, s2, i1, i2 + length - i, i) && dfs(s1, s2, i1 + i, i2, length - i)) {
            memo[i1][i2][length] = 1;
            return true;
        }
    }

    memo[i1][i2][length] = -1;
    return false;
}

bool isScramble(char* s1, char* s2) {
    memset(memo, 0, sizeof(memo));
    return dfs(s1, s2, 0, 0, strlen(s1));
}
```

```JavaScript [sol1-JavaScript]
var isScramble = function(s1, s2) {
    const length = s1.length;
    memo = new Array(length).fill(0).map(() => new Array(length).fill(0).map(() => new Array(length + 1).fill(0)));
    return dfs(0, 0, length, s1, s2, memo);
};

const dfs = function(i1, i2, length, s1, s2, memo) {
    if (memo[i1][i2][length] !== 0) {
        return memo[i1][i2][length] === 1;
    }

    // 判断两个子串是否相等
    if (s1.slice(i1, i1 + length) === s2.slice(i2, i2 + length)) {
        memo[i1][i2][length] = 1;
        return true;
    }

    // 判断是否存在字符 c 在两个子串中出现的次数不同
    if (!checkIfSimilar(i1, i2, length, s1, s2)) {
        memo[i1][i2][length] = -1;
        return false;
    }

    // 枚举分割位置
    for (let i = 1; i < length; ++i) {
        // 不交换的情况
        if (dfs(i1, i2, i, s1, s2, memo) && dfs(i1 + i, i2 + i, length - i, s1, s2, memo)) {
            memo[i1][i2][length] = 1;
            return true;
        }
        // 交换的情况
        if (dfs(i1, i2 + length - i, i, s1, s2, memo) && dfs(i1 + i, i2, length - i, s1, s2, memo)) {
            memo[i1][i2][length] = 1;
            return true;
        }
    }

    memo[i1][i2][length] = -1;
    return false;
}

const checkIfSimilar = function(i1, i2, length, s1, s2) {
    const freq = new Map();
    for (let i = i1; i < i1 + length; ++i) {
        const c = s1[i];
        freq.set(c, (freq.get(c) || 0) + 1);
    }
    for (let i = i2; i < i2 + length; ++i) {
        const c = s2[i];
        freq.set(c, (freq.get(c) || 0) - 1);
    }
    for (const value of freq.values()) {
        if (value !== 0) {
            return false;
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n^4)$，其中 $n$ 是给定的原始字符串的长度。动态规划中的状态 $f(i_1, i_2, \textit{length})$ 有 $3$ 个维度，对于每一个状态，我们需要 $O(n)$ 枚举分割位置，因此总时间复杂度为 $O(n^4)$。

- 空间复杂度：$O(n^3)$，即为存储所有动态规划状态需要的空间。