#### 方法一：记忆化搜索

**思路与算法**

我们首先对 $\textit{expression}$ 做一个预处理，把全部的操作数（包括数字和算符）都放到 $\textit{ops}$ 数组中，因为题目数据满足每一个数字都是 $[0,99]$ 的范围中，且算符总共有 $3$ 个，所以我们分别用 $-1$，$-2$，$-3$ 来表示算符 $+$，$-$，$*$。因为对于表达式中的某一个算符 $\textit{op}$，我们将其左部可能的计算结果用 $\textit{left}$ 集合来表示，其右部可能的计算结果用 $\textit{right}$ 集合来表示。那么以该算符为该表达式的最后一步操作的情况的全部可能结果就是对应集合 $\textit{left}$ 和集合 $\textit{right}$ 中元素对应该算符操作的组合数。那么我们枚举表达式中的全部算符来作为 $\textit{left}$ 和 $\textit{right}$ 的分隔符来求得对应的集合，那么该表达式最终的可能结果就是这些集合的并集。

为了避免相同区间的重复计算，我们用 $\textit{dp}[l][r] = \{v_0,v_1,\ldots\}$ 来表示对应表达式 $\textit{ops}[l:r]$ 在按不同优先级组合数字和运算符的操作下能产生的全部可能结果。这样我们就可以通过记忆化搜索这种「自顶向下」的方式来进行求解原始的表达式的全部可能计算结果。而上面讨论的条件是需要计算的表达式中存在算符的情况，所以还需要讨论搜索结束的条件：当表达式不存在任何算符时，即 $l = r$ 时，对应的结果集合中就只有该一个数字。

$$\textit{dp}[l][r] = \{\textit{ops}[l]\} , l = r \And \textit{ops}[l] \ge 0$$

**代码**

```Python [sol1-Python3]
ADDITION = -1
SUBTRACTION = -2
MULTIPLICATION = -3

class Solution:
    def diffWaysToCompute(self, expression: str) -> List[int]:
        ops = []
        i, n = 0, len(expression)
        while i < n:
            if expression[i].isdigit():
                x = 0
                while i < n and expression[i].isdigit():
                    x = x * 10 + int(expression[i])
                    i += 1
                ops.append(x)
            else:
                if expression[i] == '+':
                    ops.append(ADDITION)
                elif expression[i] == '-':
                    ops.append(SUBTRACTION)
                else:
                    ops.append(MULTIPLICATION)
                i += 1

        @cache
        def dfs(l: int, r: int) -> List[int]:
            if l == r:
                return [ops[l]]
            res = []
            for i in range(l, r, 2):
                left = dfs(l, i)
                right = dfs(i + 2, r)
                for x in left:
                    for y in right:
                        if ops[i + 1] == ADDITION:
                            res.append(x + y)
                        elif ops[i + 1] == SUBTRACTION:
                            res.append(x - y)
                        else:
                            res.append(x * y)
            return res
        return dfs(0, len(ops) - 1)
```

```C++ [sol1-C++]
class Solution {
public:
    const int ADDITION = -1;
    const int SUBTRACTION = -2;
    const int MULTIPLICATION = -3;

    vector<int> dfs(vector<vector<vector<int>>>& dp, int l, int r, const vector<int>& ops) {
        if (dp[l][r].empty()) {
            if (l == r) {
                dp[l][r].push_back(ops[l]);
            } else {
                for (int i = l; i < r; i += 2) {
                    auto left = dfs(dp, l, i, ops);
                    auto right = dfs(dp, i + 2, r, ops);
                    for (auto& lv : left) {
                        for (auto& rv : right) {
                            if (ops[i + 1] == ADDITION) {
                                dp[l][r].push_back(lv + rv);
                            } else if (ops[i + 1] == SUBTRACTION) {
                                dp[l][r].push_back(lv - rv);
                            } else {
                                dp[l][r].push_back(lv * rv);
                            }
                        }
                    }
                }
            }
        }
        return dp[l][r];
    }

    vector<int> diffWaysToCompute(string expression) {
        vector<int> ops;
        for (int i = 0; i < expression.size();) {
            if (!isdigit(expression[i])) {
                if (expression[i] == '+') {
                    ops.push_back(ADDITION);
                } else if (expression[i] == '-') {
                    ops.push_back(SUBTRACTION);
                } else {
                    ops.push_back(MULTIPLICATION);
                }
                i++;
            } else {
                int t = 0;
                while (i < expression.size() && isdigit(expression[i])) {
                    t = t * 10 + expression[i] - '0';
                    i++;
                }
                ops.push_back(t);
            }
        }
        vector<vector<vector<int>>> dp((int) ops.size(), vector<vector<int>>((int) ops.size()));
        return dfs(dp, 0, ops.size() - 1, ops);
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int ADDITION = -1;
    static final int SUBTRACTION = -2;
    static final int MULTIPLICATION = -3;

    public List<Integer> diffWaysToCompute(String expression) {
        List<Integer> ops = new ArrayList<Integer>();
        for (int i = 0; i < expression.length();) {
            if (!Character.isDigit(expression.charAt(i))) {
                if (expression.charAt(i) == '+') {
                    ops.add(ADDITION);
                } else if (expression.charAt(i) == '-') {
                    ops.add(SUBTRACTION);
                } else {
                    ops.add(MULTIPLICATION);
                }
                i++;
            } else {
                int t = 0;
                while (i < expression.length() && Character.isDigit(expression.charAt(i))) {
                    t = t * 10 + expression.charAt(i) - '0';
                    i++;
                }
                ops.add(t);
            }
        }
        List<Integer>[][] dp = new List[ops.size()][ops.size()];
        for (int i = 0; i < ops.size(); i++) {
            for (int j = 0; j < ops.size(); j++) {
                dp[i][j] = new ArrayList<Integer>();
            }
        }
        return dfs(dp, 0, ops.size() - 1, ops);
    }

    public List<Integer> dfs(List<Integer>[][] dp, int l, int r, List<Integer> ops) {
        if (dp[l][r].isEmpty()) {
            if (l == r) {
                dp[l][r].add(ops.get(l));
            } else {
                for (int i = l; i < r; i += 2) {
                    List<Integer> left = dfs(dp, l, i, ops);
                    List<Integer> right = dfs(dp, i + 2, r, ops);
                    for (int lv : left) {
                        for (int rv : right) {
                            if (ops.get(i + 1) == ADDITION) {
                                dp[l][r].add(lv + rv);
                            } else if (ops.get(i + 1) == SUBTRACTION) {
                                dp[l][r].add(lv - rv);
                            } else {
                                dp[l][r].add(lv * rv);
                            }
                        }
                    }
                }
            }
        }
        return dp[l][r];
    }
}
```

```C# [sol1-C#]
public class Solution {
    const int ADDITION = -1;
    const int SUBTRACTION = -2;
    const int MULTIPLICATION = -3;

    public IList<int> DiffWaysToCompute(string expression) {
        IList<int> ops = new List<int>();
        for (int i = 0; i < expression.Length;) {
            if (!char.IsDigit(expression[i])) {
                if (expression[i] == '+') {
                    ops.Add(ADDITION);
                } else if (expression[i] == '-') {
                    ops.Add(SUBTRACTION);
                } else {
                    ops.Add(MULTIPLICATION);
                }
                i++;
            } else {
                int t = 0;
                while (i < expression.Length && char.IsDigit(expression[i])) {
                    t = t * 10 + expression[i] - '0';
                    i++;
                }
                ops.Add(t);
            }
        }
        IList<int>[][] dp = new IList<int>[ops.Count][];
        for (int i = 0; i < ops.Count; i++) {
            dp[i] = new IList<int>[ops.Count];
        }
        for (int i = 0; i < ops.Count; i++) {
            for (int j = 0; j < ops.Count; j++) {
                dp[i][j] = new List<int>();
            }
        }
        return DFS(dp, 0, ops.Count - 1, ops);
    }

    public IList<int> DFS(IList<int>[][] dp, int l, int r, IList<int> ops) {
        if (dp[l][r].Count == 0) {
            if (l == r) {
                dp[l][r].Add(ops[l]);
            } else {
                for (int i = l; i < r; i += 2) {
                    IList<int> left = DFS(dp, l, i, ops);
                    IList<int> right = DFS(dp, i + 2, r, ops);
                    foreach (int lv in left) {
                        foreach (int rv in right) {
                            if (ops[i + 1] == ADDITION) {
                                dp[l][r].Add(lv + rv);
                            } else if (ops[i + 1] == SUBTRACTION) {
                                dp[l][r].Add(lv - rv);
                            } else {
                                dp[l][r].Add(lv * rv);
                            }
                        }
                    }
                }
            }
        }
        return dp[l][r];
    }
}
```

```C [sol1-C]
#define ADDITION -1
#define SUBTRACTION -2
#define MULTIPLICATION -3

struct ListNode * dfs(struct ListNode ***dp, int l, int r, const int *ops) {
    if (!dp[l][r]) {
        if (l == r) {
            struct ListNode *node = (struct ListNode *)malloc(sizeof(struct ListNode));
            node->val = ops[l];
            node->next = dp[l][r];
            dp[l][r] = node;
        } else {
            for (int i = l; i < r; i += 2) {
                for (struct ListNode *left = dfs(dp, l, i, ops); left; left = left->next) {
                    for (struct ListNode *right = dfs(dp, i + 2, r, ops); right; right = right->next) {
                        struct ListNode *node = (struct ListNode *)malloc(sizeof(struct ListNode));
                        if (ops[i + 1] == ADDITION) {
                            node->val = left->val + right->val;
                        } else if (ops[i + 1] == SUBTRACTION) {
                            node->val = left->val - right->val;
                        } else {
                            node->val = left->val * right->val;
                        }
                        node->next = dp[l][r];
                        dp[l][r] = node;
                    }
                }
            }
        }
    }
    return dp[l][r];
}

int* diffWaysToCompute(char * expression, int* returnSize) {
    int len = strlen(expression);
    int *ops = (int *)malloc(sizeof(int) * len);
    int opsSize = 0;
    for (int i = 0; i < len;) {
        if (!isdigit(expression[i])) {
            if (expression[i] == '+') {
                ops[opsSize++] = ADDITION;
            } else if (expression[i] == '-') {
                ops[opsSize++] = SUBTRACTION;
            } else {
                ops[opsSize++] = MULTIPLICATION;
            }
            i++;
        } else {
            int t = 0;
            while (i < len && isdigit(expression[i])) {
                t = t * 10 + expression[i] - '0';
                i++;
            }
            ops[opsSize++] = t;
        }
    }
    struct ListNode ***dp = NULL;
    dp = (struct ListNode ***)malloc(sizeof(struct ListNode **) * opsSize);
    for (int i = 0; i < opsSize; i++) {
        dp[i] = (struct ListNode **)malloc(sizeof(struct ListNode *) * opsSize);
        for (int j = 0; j < opsSize; j++) {
            dp[i][j] = NULL;
        }
    }
    int *ans = (int *)malloc(sizeof(int) * (1 << opsSize));
    int pos = 0;
    struct ListNode *node = dfs(dp, 0, opsSize - 1, ops);
    while (node) {
        ans[pos++] = node->val;
        node = node->next;
    }
    *returnSize = pos;
    for (int i = 0; i < opsSize; i++) {
        for (int j = 0; j < opsSize; j++) {
            struct ListNode *curr, *tmp;
            curr = dp[i][j];
            while (curr) {
                tmp = curr;
                curr = curr->next;
                free(tmp);
            }
        }
        free(dp[i]);
    }
    free(dp);
    free(ops);
    return ans;
}
```

```go [sol1-Golang]
const addition, subtraction, multiplication = -1, -2, -3

func diffWaysToCompute(expression string) []int {
    ops := []int{}
    for i, n := 0, len(expression); i < n; {
        if unicode.IsDigit(rune(expression[i])) {
            x := 0
            for ; i < n && unicode.IsDigit(rune(expression[i])); i++ {
                x = x*10 + int(expression[i]-'0')
            }
            ops = append(ops, x)
        } else {
            if expression[i] == '+' {
                ops = append(ops, addition)
            } else if expression[i] == '-' {
                ops = append(ops, subtraction)
            } else {
                ops = append(ops, multiplication)
            }
            i++
        }
    }

    n := len(ops)
    dp := make([][][]int, n)
    for i := range dp {
        dp[i] = make([][]int, n)
    }
    var dfs func(int, int) []int
    dfs = func(l, r int) []int {
        res := dp[l][r]
        if res != nil {
            return res
        }
        if l == r {
            dp[l][r] = []int{ops[l]}
            return dp[l][r]
        }
        for i := l; i < r; i += 2 {
            left := dfs(l, i)
            right := dfs(i+2, r)
            for _, x := range left {
                for _, y := range right {
                    if ops[i+1] == addition {
                        dp[l][r] = append(dp[l][r], x+y)
                    } else if ops[i+1] == subtraction {
                        dp[l][r] = append(dp[l][r], x-y)
                    } else {
                        dp[l][r] = append(dp[l][r], x*y)
                    }
                }
            }
        }
        return dp[l][r]
    }
    return dfs(0, n-1)
}
```

```JavaScript [sol1-JavaScript]
const ADDITION = -1;
const SUBTRACTION = -2;
const MULTIPLICATION = -3;

var diffWaysToCompute = function(expression) {
    const ops = [];
    for (let i = 0; i < expression.length;) {
        if (!isDigit(expression[i])) {
            if (expression[i] === '+') {
                ops.push(ADDITION);
            } else if (expression[i] === '-') {
                ops.push(SUBTRACTION);
            } else {
                ops.push(MULTIPLICATION);
            }
            i++;
        } else {
            let t = 0;
            while (i < expression.length && isDigit(expression[i])) {
                t = t * 10 + expression[i].charCodeAt() - '0'.charCodeAt();
                i++;
            }
            ops.push(t);
        }
    }
    const dp = new Array(ops.length).fill(0).map(() => new Array(ops.length).fill(0));
    for (let i = 0; i < ops.length; i++) {
        for (let j = 0; j < ops.length; j++) {
            dp[i][j] = [];
        }
    }
    return dfs(dp, 0, ops.length - 1, ops);
};

const dfs = (dp, l, r, ops) => {
    if (dp[l][r].length === 0) {
        if (l == r) {
            dp[l][r].push(ops[l]);
        } else {
            for (let i = l; i < r; i += 2) {
                const left = dfs(dp, l, i, ops);
                const right = dfs(dp, i + 2, r, ops);
                for (const lv of left) {
                    for (const rv of right) {
                        if (ops[i + 1] === ADDITION) {
                            dp[l][r].push(lv + rv);
                        } else if (ops[i + 1] === SUBTRACTION) {
                            dp[l][r].push(lv - rv);
                        } else {
                            dp[l][r].push(lv * rv);
                        }
                    }
                }
            }
        }
    }
    return dp[l][r];
}

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}
```

**复杂度分析**

- 时间复杂度：$O(2^n)$，其中 $n$ 为 $\textit{ops}$ 的大小。可以分析得到 $n$ 一定是奇数，令 $n = 2k+1$，最后的答案集合大小等于 $C_k$，第 $k$ 个[卡特兰数（Catalan Number）](https://baike.baidu.com/item/%E5%8D%A1%E7%89%B9%E5%85%B0%E6%95%B0/6125746)；以及 $\sum_{k<\frac{n}{2}}C_k$（计算中间结果所涉及的复杂度）限制在 $O(2^n)$。这里不具体证明，感兴趣的读者可以自行研究。

- 空间复杂度：$O(2^n)$，其中 $n$ 为 $\textit{ops}$ 的大小。

#### 方法二：动态规划

**思路与算法**

我们同样可以用「动态规划」这种「自底向上」的方法来求解原始的表达式的全部可能计算结果。同样我们用 $\textit{dp}[l][r] = \{v_0,v_1,\ldots\}$ 来表示对应表达式 $\textit{ops}[l:r]$ 在按不同优先级组合数字和运算符的操作下能产生的全部可能结果。此时边界情况就是当表达式不存在任何算符时，即 $l = r$ 时，对应的结果集合中就只有一个数字。

$$\textit{dp}[l][r] = \{\textit{ops}[l]\} , l = r \And \textit{ops}[l] \ge 0$$

**代码**

```Python [sol2-Python3]
ADDITION = -1
SUBTRACTION = -2
MULTIPLICATION = -3

class Solution:
    def diffWaysToCompute(self, expression: str) -> List[int]:
        ops = []
        i, n = 0, len(expression)
        while i < n:
            if expression[i].isdigit():
                x = 0
                while i < n and expression[i].isdigit():
                    x = x * 10 + int(expression[i])
                    i += 1
                ops.append(x)
            else:
                if expression[i] == '+':
                    ops.append(ADDITION)
                elif expression[i] == '-':
                    ops.append(SUBTRACTION)
                else:
                    ops.append(MULTIPLICATION)
                i += 1

        n = len(ops)
        dp = [[[] for _ in range(n)] for _ in range(n)]
        for i, x in enumerate(ops):
            dp[i][i] = [x]
        for sz in range(3, n + 1):
            for r in range(sz - 1, n, 2):
                l = r - sz + 1
                for k in range(l + 1, r, 2):
                    for x in dp[l][k - 1]:
                        for y in dp[k + 1][r]:
                            if ops[k] == ADDITION:
                                dp[l][r].append(x + y)
                            elif ops[k] == SUBTRACTION:
                                dp[l][r].append(x - y)
                            else:
                                dp[l][r].append(x * y)
        return dp[0][-1]
```

```C++ [sol2-C++]
class Solution {
public:
    const int ADDITION = -1;
    const int SUBTRACTION = -2;
    const int MULTIPLICATION = -3;

    vector<int> diffWaysToCompute(string expression) {
        vector<int> ops;
        for (int i = 0; i < expression.size();) {
            if (!isdigit(expression[i])) {
                if (expression[i] == '+') {
                    ops.push_back(ADDITION);
                } else if (expression[i] == '-') {
                    ops.push_back(SUBTRACTION);
                } else {
                    ops.push_back(MULTIPLICATION);
                }
                i++;
            } else {
                int t = 0;
                while (i < expression.size() && isdigit(expression[i])) {
                    t = t * 10 + expression[i] - '0';
                    i++;
                }
                ops.push_back(t);
            }
        }
        vector<vector<vector<int>>> dp((int) ops.size(), vector<vector<int>>((int) ops.size()));
        for (int i = 0; i < ops.size(); i += 2) {
            dp[i][i] = {ops[i]};
        }
        for (int i = 3; i <= ops.size(); i++) {
            for (int j = 0; j + i <= ops.size(); j += 2) {
                int l = j;
                int r = j + i - 1;
                for (int k = j + 1; k < r; k += 2) {
                    auto& left = dp[l][k - 1];
                    auto& right = dp[k + 1][r];
                    for (auto& num1 : left) {
                        for (auto& num2 : right) {
                            if (ops[k] == ADDITION) {
                                dp[l][r].push_back(num1 + num2);
                            }
                            else if (ops[k] == SUBTRACTION) {
                                dp[l][r].push_back(num1 - num2);
                            }
                            else if (ops[k] == MULTIPLICATION) {
                                dp[l][r].push_back(num1 * num2);
                            }
                        }
                    }
                }
            }
        }
        return dp[0][(int) ops.size() - 1];
    }
};
```

```Java [sol2-Java]
class Solution {
    static final int ADDITION = -1;
    static final int SUBTRACTION = -2;
    static final int MULTIPLICATION = -3;

    public List<Integer> diffWaysToCompute(String expression) {
        List<Integer> ops = new ArrayList<Integer>();
        for (int i = 0; i < expression.length();) {
            if (!Character.isDigit(expression.charAt(i))) {
                if (expression.charAt(i) == '+') {
                    ops.add(ADDITION);
                } else if (expression.charAt(i) == '-') {
                    ops.add(SUBTRACTION);
                } else {
                    ops.add(MULTIPLICATION);
                }
                i++;
            } else {
                int t = 0;
                while (i < expression.length() && Character.isDigit(expression.charAt(i))) {
                    t = t * 10 + expression.charAt(i) - '0';
                    i++;
                }
                ops.add(t);
            }
        }
        List<Integer>[][] dp = new List[ops.size()][ops.size()];
        for (int i = 0; i < ops.size(); i++) {
            for (int j = 0; j < ops.size(); j++) {
                dp[i][j] = new ArrayList<Integer>();
            }
        }
        for (int i = 0; i < ops.size(); i += 2) {
            dp[i][i].add(ops.get(i));
        }
        for (int i = 3; i <= ops.size(); i++) {
            for (int j = 0; j + i <= ops.size(); j += 2) {
                int l = j;
                int r = j + i - 1;
                for (int k = j + 1; k < r; k += 2) {
                    List<Integer> left = dp[l][k - 1];
                    List<Integer> right = dp[k + 1][r];
                    for (int num1 : left) {
                        for (int num2 : right) {
                            if (ops.get(k) == ADDITION) {
                                dp[l][r].add(num1 + num2);
                            } else if (ops.get(k) == SUBTRACTION) {
                                dp[l][r].add(num1 - num2);
                            } else if (ops.get(k) == MULTIPLICATION) {
                                dp[l][r].add(num1 * num2);
                            }
                        }
                    }
                }
            }
        }
        return dp[0][ops.size() - 1];
    }
};
```

```C# [sol2-C#]
public class Solution {
    const int ADDITION = -1;
    const int SUBTRACTION = -2;
    const int MULTIPLICATION = -3;

    public IList<int> DiffWaysToCompute(string expression) {
        IList<int> ops = new List<int>();
        for (int i = 0; i < expression.Length;) {
            if (!char.IsDigit(expression[i])) {
                if (expression[i] == '+') {
                    ops.Add(ADDITION);
                } else if (expression[i] == '-') {
                    ops.Add(SUBTRACTION);
                } else {
                    ops.Add(MULTIPLICATION);
                }
                i++;
            } else {
                int t = 0;
                while (i < expression.Length && char.IsDigit(expression[i])) {
                    t = t * 10 + expression[i] - '0';
                    i++;
                }
                ops.Add(t);
            }
        }
        IList<int>[][] dp = new IList<int>[ops.Count][];
        for (int i = 0; i < ops.Count; i++) {
            dp[i] = new IList<int>[ops.Count];
        }
        for (int i = 0; i < ops.Count; i++) {
            for (int j = 0; j < ops.Count; j++) {
                dp[i][j] = new List<int>();
            }
        }
        for (int i = 0; i < ops.Count; i += 2) {
            dp[i][i].Add(ops[i]);
        }
        for (int i = 3; i <= ops.Count; i++) {
            for (int j = 0; j + i <= ops.Count; j += 2) {
                int l = j;
                int r = j + i - 1;
                for (int k = j + 1; k < r; k += 2) {
                    IList<int> left = dp[l][k - 1];
                    IList<int> right = dp[k + 1][r];
                    foreach (int num1 in left) {
                        foreach (int num2 in right) {
                            if (ops[k] == ADDITION) {
                                dp[l][r].Add(num1 + num2);
                            } else if (ops[k] == SUBTRACTION) {
                                dp[l][r].Add(num1 - num2);
                            } else if (ops[k] == MULTIPLICATION) {
                                dp[l][r].Add(num1 * num2);
                            }
                        }
                    }
                }
            }
        }
        return dp[0][ops.Count - 1];
    }
}
```

```C [sol2-C]
#define ADDITION -1
#define SUBTRACTION -2
#define MULTIPLICATION -3

int* diffWaysToCompute(char * expression, int* returnSize) {
    int len = strlen(expression);
    int *ops = (int *)malloc(sizeof(int) * len);
    int opsSize = 0;
    for (int i = 0; i < len;) {
        if (!isdigit(expression[i])) {
            if (expression[i] == '+') {
                ops[opsSize++] = ADDITION;
            } else if (expression[i] == '-') {
                ops[opsSize++] = SUBTRACTION;
            } else {
                ops[opsSize++] = MULTIPLICATION;
            }
            i++;
        } else {
            int t = 0;
            while (i < len && isdigit(expression[i])) {
                t = t * 10 + expression[i] - '0';
                i++;
            }
            ops[opsSize++] = t;
        }
    }
    struct ListNode ***dp = NULL;
    dp = (struct ListNode ***)malloc(sizeof(struct ListNode **) * opsSize);
    for (int i = 0; i < opsSize; i++) {
        dp[i] = (struct ListNode **)malloc(sizeof(struct ListNode *) * opsSize);
        for (int j = 0; j < opsSize; j++) {
            dp[i][j] = NULL;
        }
    }
    for (int i = 0; i < opsSize; i += 2) {
        struct ListNode *node = (struct ListNode*)malloc(sizeof(struct ListNode));
        node->val = ops[i];
        node->next = NULL;
        dp[i][i] = node;
    }
    for (int i = 3; i <= opsSize; i++) {
        for (int j = 0; j + i <= opsSize; j += 2) {
            int l = j;
            int r = j + i - 1;
            for (int k = j + 1; k < r; k += 2) {
                struct ListNode *left = dp[l][k - 1];
                struct ListNode *right = dp[k + 1][r];
                for (struct ListNode *left = dp[l][k - 1]; left; left = left->next) {
                    for (struct ListNode *right = dp[k + 1][r]; right; right = right->next) {
                        struct ListNode *node = (struct ListNode *)malloc(sizeof(struct ListNode));
                        if (ops[k] == ADDITION) {
                            node->val = left->val + right->val;
                        }
                        else if (ops[k] == SUBTRACTION) {
                            node->val = left->val - right->val;
                        }
                        else if (ops[k] == MULTIPLICATION) {
                            node->val = left->val * right->val;
                        }
                        node->next = dp[l][r];
                        dp[l][r] = node;
                    }
                }
            }
        }
    }
    int *ans = (int *)malloc(sizeof(int) * (1 << opsSize));
    int pos = 0;
    for (struct ListNode *node = dp[0][opsSize - 1]; node; node = node->next) {
        ans[pos++] = node->val;
    }
    *returnSize = pos;
    for (int i = 0; i < opsSize; i++) {
        for (int j = 0; j < opsSize; j++) {
            struct ListNode *curr, *tmp;
            curr = dp[i][j];
            while (curr) {
                tmp = curr;
                curr = curr->next;
                free(tmp);
            }
        }
        free(dp[i]);
    }
    free(dp);
    free(ops);
    return ans;
}
```

```go [sol2-Golang]
const addition, subtraction, multiplication = -1, -2, -3

func diffWaysToCompute(expression string) []int {
    ops := []int{}
    for i, n := 0, len(expression); i < n; {
        if unicode.IsDigit(rune(expression[i])) {
            x := 0
            for ; i < n && unicode.IsDigit(rune(expression[i])); i++ {
                x = x*10 + int(expression[i]-'0')
            }
            ops = append(ops, x)
        } else {
            if expression[i] == '+' {
                ops = append(ops, addition)
            } else if expression[i] == '-' {
                ops = append(ops, subtraction)
            } else {
                ops = append(ops, multiplication)
            }
            i++
        }
    }

    n := len(ops)
    dp := make([][][]int, n)
    for i, x := range ops {
        dp[i] = make([][]int, n)
        dp[i][i] = []int{x}
    }
    for sz := 3; sz <= n; sz++ {
        for l, r := 0, sz-1; r < n; l += 2 {
            for k := l + 1; k < r; k += 2 {
                for _, x := range dp[l][k-1] {
                    for _, y := range dp[k+1][r] {
                        if ops[k] == addition {
                            dp[l][r] = append(dp[l][r], x+y)
                        } else if ops[k] == subtraction {
                            dp[l][r] = append(dp[l][r], x-y)
                        } else {
                            dp[l][r] = append(dp[l][r], x*y)
                        }
                    }
                }
            }
            r += 2
        }
    }
    return dp[0][n-1]
}
```

```JavaScript [sol2-JavaScript]
var diffWaysToCompute = function(expression) {
    const ADDITION = -1;
    const SUBTRACTION = -2;
    const MULTIPLICATION = -3;
    const ops = [];
    for (let i = 0; i < expression.length;) {
        if (!isDigit(expression[i])) {
            if (expression[i] === '+') {
                ops.push(ADDITION);
            } else if (expression[i] === '-') {
                ops.push(SUBTRACTION);
            } else {
                ops.push(MULTIPLICATION);
            }
            i++;
        } else {
            let t = 0;
            while (i < expression.length && isDigit(expression[i])) {
                t = t * 10 + expression[i].charCodeAt() - '0'.charCodeAt();
                i++;
            }
            ops.push(t);
        }
    }
    const dp = new Array(ops.length).fill(0).map(() => new Array(ops.length).fill(0));
    for (let i = 0; i < ops.length; i++) {
        for (let j = 0; j < ops.length; j++) {
            dp[i][j] = [];
        }
    }
    for (let i = 0; i < ops.length; i += 2) {
        dp[i][i].push(ops[i]);
    }
    for (let i = 3; i <= ops.length; i++) {
        for (let j = 0; j + i <= ops.length; j += 2) {
            let l = j;
            let r = j + i - 1;
            for (let k = j + 1; k < r; k += 2) {
                const left = dp[l][k - 1];
                const right = dp[k + 1][r];
                for (const num1 of left) {
                    for (const num2 of right) {
                        if (ops[k] === ADDITION) {
                            dp[l][r].push(num1 + num2);
                        } else if (ops[k] === SUBTRACTION) {
                            dp[l][r].push(num1 - num2);
                        } else if (ops[k] === MULTIPLICATION) {
                            dp[l][r].push(num1 * num2);
                        }
                    }
                }
            }
        }
    }
    return dp[0][ops.length - 1];
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}
```

**复杂度分析**

- 时间复杂度：$O(2^n)$，其中 $n$ 为 $\textit{ops}$ 的大小。分析同方法一的「记忆化搜索」。

- 空间复杂度：$O(2^n)$，其中 $n$ 为 $\textit{ops}$ 的大小。