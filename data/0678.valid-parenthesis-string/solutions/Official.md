## [678.有效的括号字符串 中文官方题解](https://leetcode.cn/problems/valid-parenthesis-string/solutions/100000/you-xiao-de-gua-hao-zi-fu-chuan-by-leetc-osi3)

#### 方法一：动态规划

要判断 $s$ 是否为有效的括号字符串，需要判断 $s$ 的首尾字符以及 $s$ 的中间字符是否符合有效的括号字符串的要求。可以使用动态规划求解。

假设字符串 $s$ 的长度为 $n$。定义 $\textit{dp}[i][j]$ 表示字符串 $s$ 从下标 $i$ 到 $j$ 的子串是否为有效的括号字符串，其中 $0 \le i \le j < n$。

动态规划的边界情况是子串的长度为 $1$ 或 $2$ 的情况。

- 当子串的长度为 $1$ 时，只有当该字符是 $\text{`*'}$ 时，才是有效的括号字符串，此时子串可以看成空字符串；

- 当子串的长度为 $2$ 时，只有当两个字符是 $\text{``()"}, \text{``(*"}, \text{``*)"}, \text{``**"}$ 中的一种情况时，才是有效的括号字符串，此时子串可以看成 $\text{``()"}$。

当子串的长度大于 $2$ 时，需要根据子串的首尾字符以及中间的字符判断子串是否为有效的括号字符串。字符串 $s$ 从下标 $i$ 到 $j$ 的子串的长度大于 $2$ 等价于 $j - i \ge 2$，此时 $\textit{dp}[i][j]$ 的计算如下，只要满足以下一个条件就有 $\textit{dp}[i][j] = \text{true}$：

- 如果 $s[i]$ 和 $s[j]$ 分别为左括号和右括号，或者为 $\text{`*'}$，则当 $\textit{dp}[i + 1][j - 1] = \text{true}$ 时，$\textit{dp}[i][j] = \text{true}$，此时 $s[i]$ 和 $s[j]$ 可以分别看成左括号和右括号；

- 如果存在 $i \le k < j$ 使得 $\textit{dp}[i][k]$ 和 $\textit{dp}[k + 1][j]$ 都为 $\textit{true}$，则 $\textit{dp}[i][j] = \text{true}$，因为字符串 $s$ 的下标范围 $[i, k]$ 和 $[k + 1, j]$ 的子串分别为有效的括号字符串，将两个子串拼接之后的子串也为有效的括号字符串，对应下标范围 $[i, j]$。

上述计算过程为从较短的子串的结果得到较长的子串的结果，因此需要注意动态规划的计算顺序。最终答案为 $\textit{dp}[0][n - 1]$。

```Java [sol1-Java]
class Solution {
    public boolean checkValidString(String s) {
        int n = s.length();
        boolean[][] dp = new boolean[n][n];
        for (int i = 0; i < n; i++) {
            if (s.charAt(i) == '*') {
                dp[i][i] = true;
            }
        }
        for (int i = 1; i < n; i++) {
            char c1 = s.charAt(i - 1), c2 = s.charAt(i);
            dp[i - 1][i] = (c1 == '(' || c1 == '*') && (c2 == ')' || c2 == '*');
        }
        for (int i = n - 3; i >= 0; i--) {
            char c1 = s.charAt(i);
            for (int j = i + 2; j < n; j++) {
                char c2 = s.charAt(j);
                if ((c1 == '(' || c1 == '*') && (c2 == ')' || c2 == '*')) {
                    dp[i][j] = dp[i + 1][j - 1];
                }
                for (int k = i; k < j && !dp[i][j]; k++) {
                    dp[i][j] = dp[i][k] && dp[k + 1][j];
                }
            }
        }
        return dp[0][n - 1];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CheckValidString(string s) {
        int n = s.Length;
        bool[,] dp = new bool[n, n];
        for (int i = 0; i < n; i++) {
            if (s[i] == '*') {
                dp[i, i] = true;
            }
        }
        for (int i = 1; i < n; i++) {
            char c1 = s[i - 1], c2 = s[i];
            dp[i - 1, i] = (c1 == '(' || c1 == '*') && (c2 == ')' || c2 == '*');
        }
        for (int i = n - 3; i >= 0; i--) {
            char c1 = s[i];
            for (int j = i + 2; j < n; j++) {
                char c2 = s[j];
                if ((c1 == '(' || c1 == '*') && (c2 == ')' || c2 == '*')) {
                    dp[i, j] = dp[i + 1, j - 1];
                }
                for (int k = i; k < j && !dp[i, j]; k++) {
                    dp[i, j] = dp[i, k] && dp[k + 1, j];
                }
            }
        }
        return dp[0, n - 1];
    }
}
```

```JavaScript [sol1-JavaScript]
var checkValidString = function(s) {
    const n = s.length;
    const dp = new Array(n).fill(0).map(() => new Array(n).fill(false));
    for (let i = 0; i < n; i++) {
        if (s[i] === '*') {
            dp[i][i] = true;
        }
    }
    for (let i = 1; i < n; i++) {
        const c1 = s[i - 1], c2 = s[i];
        dp[i - 1][i] = (c1 === '(' || c1 === '*') && (c2 === ')' || c2 === '*');
    }
    for (let i = n - 3; i >= 0; i--) {
        const c1 = s[i];
        for (let j = i + 2; j < n; j++) {
            const c2 = s[j];
            if ((c1 === '(' || c1 === '*') && (c2 === ')' || c2 === '*')) {
                dp[i][j] = dp[i + 1][j - 1];
            }
            for (let k = i; k < j && !dp[i][j]; k++) {
                dp[i][j] = dp[i][k] && dp[k + 1][j];
            }
        }
    }
    return dp[0][n - 1];
};
```

```C++ [sol1-C++]
class Solution {
public:
    bool checkValidString(string s) {
        int n = s.size();
        vector<vector<bool>> dp = vector<vector<bool>>(n,vector<bool>(n,false));

        for (int i = 0; i < n; i++) {
            if (s[i] == '*') {
                dp[i][i] = true;
            }
        }

        for (int i = 1; i < n; i++) {
            char c1 = s[i - 1]; 
            char c2 = s[i];
            dp[i - 1][i] = (c1 == '(' || c1 == '*') && (c2 == ')' || c2 == '*');
        }

        for (int i = n - 3; i >= 0; i--) {
            char c1 = s[i];
            for (int j = i + 2; j < n; j++) {
                char c2 = s[j];
                if ((c1 == '(' || c1 == '*') && (c2 == ')' || c2 == '*')) {
                    dp[i][j] = dp[i + 1][j - 1];
                }
                for (int k = i; k < j && !dp[i][j]; k++) {
                    dp[i][j] = dp[i][k] && dp[k + 1][j];
                }
            }
        }
        return dp[0][n - 1];
    }
};
```

```go [sol1-Golang]
func checkValidString(s string) bool {
    n := len(s)
    dp := make([][]bool, n)
    for i := range dp {
        dp[i] = make([]bool, n)
    }
    for i, ch := range s {
        if ch == '*' {
            dp[i][i] = true
        }
    }

    for i := 1; i < n; i++ {
        c1, c2 := s[i-1], s[i]
        dp[i-1][i] = (c1 == '(' || c1 == '*') && (c2 == ')' || c2 == '*')
    }

    for i := n - 3; i >= 0; i-- {
        c1 := s[i]
        for j := i + 2; j < n; j++ {
            c2 := s[j]
            if (c1 == '(' || c1 == '*') && (c2 == ')' || c2 == '*') {
                dp[i][j] = dp[i+1][j-1]
            }
            for k := i; k < j && !dp[i][j]; k++ {
                dp[i][j] = dp[i][k] && dp[k+1][j]
            }
        }
    }

    return dp[0][n-1]
}
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 是字符串 $s$ 的长度。动态规划的状态数是 $O(n^2)$，每个状态的计算时间最多为 $O(n)$。

- 空间复杂度：$O(n^2)$，其中 $n$ 是字符串 $s$ 的长度。创建了 $n$ 行 $n$ 列的二维数组 $\textit{dp}$。

#### 方法二：栈

括号匹配的问题可以用栈求解。

如果字符串中没有星号，则只需要一个栈存储左括号，在从左到右遍历字符串的过程中检查括号是否匹配。

在有星号的情况下，需要两个栈分别存储左括号和星号。从左到右遍历字符串，进行如下操作。

- 如果遇到左括号，则将当前下标存入左括号栈。

- 如果遇到星号，则将当前下标存入星号栈。

- 如果遇到右括号，则需要有一个左括号或星号和右括号匹配，由于星号也可以看成右括号或者空字符串，因此当前的右括号应优先和左括号匹配，没有左括号时和星号匹配：

   1. 如果左括号栈不为空，则从左括号栈弹出栈顶元素；

   2. 如果左括号栈为空且星号栈不为空，则从星号栈弹出栈顶元素；

   3. 如果左括号栈和星号栈都为空，则没有字符可以和当前的右括号匹配，返回 $\text{false}$。

遍历结束之后，左括号栈和星号栈可能还有元素。为了将每个左括号匹配，需要将星号看成右括号，且每个左括号必须出现在其匹配的星号之前。当两个栈都不为空时，每次从左括号栈和星号栈分别弹出栈顶元素，对应左括号下标和星号下标，判断是否可以匹配，匹配的条件是左括号下标小于星号下标，如果左括号下标大于星号下标则返回 $\text{false}$。

最终判断左括号栈是否为空。如果左括号栈为空，则左括号全部匹配完毕，剩下的星号都可以看成空字符串，此时 $s$ 是有效的括号字符串，返回 $\text{true}$。如果左括号栈不为空，则还有左括号无法匹配，此时 $s$ 不是有效的括号字符串，返回 $\text{false}$。

```Java [sol2-Java]
class Solution {
    public boolean checkValidString(String s) {
        Deque<Integer> leftStack = new LinkedList<Integer>();
        Deque<Integer> asteriskStack = new LinkedList<Integer>();
        int n = s.length();
        for (int i = 0; i < n; i++) {
            char c = s.charAt(i);
            if (c == '(') {
                leftStack.push(i);
            } else if (c == '*') {
                asteriskStack.push(i);
            } else {
                if (!leftStack.isEmpty()) {
                    leftStack.pop();
                } else if (!asteriskStack.isEmpty()) {
                    asteriskStack.pop();
                } else {
                    return false;
                }
            }
        }
        while (!leftStack.isEmpty() && !asteriskStack.isEmpty()) {
            int leftIndex = leftStack.pop();
            int asteriskIndex = asteriskStack.pop();
            if (leftIndex > asteriskIndex) {
                return false;
            }
        }
        return leftStack.isEmpty();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool CheckValidString(string s) {
        Stack<int> leftStack = new Stack<int>();
        Stack<int> asteriskStack = new Stack<int>();
        int n = s.Length;
        for (int i = 0; i < n; i++) {
            char c = s[i];
            if (c == '(') {
                leftStack.Push(i);
            } else if (c == '*') {
                asteriskStack.Push(i);
            } else {
                if (leftStack.Count > 0) {
                    leftStack.Pop();
                } else if (asteriskStack.Count > 0) {
                    asteriskStack.Pop();
                } else {
                    return false;
                }
            }
        }
        while (leftStack.Count > 0 && asteriskStack.Count > 0) {
            int leftIndex = leftStack.Pop();
            int asteriskIndex = asteriskStack.Pop();
            if (leftIndex > asteriskIndex) {
                return false;
            }
        }
        return leftStack.Count == 0;
    }
}
```

```JavaScript [sol2-JavaScript]
var checkValidString = function(s) {
    const leftStack = [];
    const asteriskStack = [];
    const n = s.length;
    for (let i = 0; i < n; i++) {
        const c = s[i];
        if (c === '(') {
            leftStack.push(i);
        } else if (c === '*') {
            asteriskStack.push(i);
        } else {
            if (leftStack.length) {
                leftStack.pop();
            } else if (asteriskStack.length) {
                asteriskStack.pop();
            } else {
                return false;
            }
        }
    }
    while (leftStack.length && asteriskStack.length) {
        const leftIndex = leftStack.pop();
        const asteriskIndex = asteriskStack.pop();
        if (leftIndex > asteriskIndex) {
            return false;
        }
    }
    return leftStack.length === 0;
};
```

```C++ [sol2-C++]
class Solution {
public:
    bool checkValidString(string s) {
        stack<int> leftStack;
        stack<int> asteriskStack;
        int n = s.size();

        for (int i = 0; i < n; i++) {
            char c = s[i];
            if (c == '(') {
                leftStack.push(i);
            } else if (c == '*') {
                asteriskStack.push(i);
            } else {
                if (!leftStack.empty()) {
                    leftStack.pop();
                } else if (!asteriskStack.empty()) {
                    asteriskStack.pop();
                } else {
                    return false;
                }
            }
        }

        while (!leftStack.empty() && !asteriskStack.empty()) {
            int leftIndex = leftStack.top();
            leftStack.pop();
            int asteriskIndex = asteriskStack.top();
            asteriskStack.pop();
            if (leftIndex > asteriskIndex) {
                return false;
            }
        }
        
        return leftStack.empty();
    }
};
```

```go [sol2-Golang]
func checkValidString(s string) bool {
    var leftStk, asteriskStk []int
    for i, ch := range s {
        if ch == '(' {
            leftStk = append(leftStk, i)
        } else if ch == '*' {
            asteriskStk = append(asteriskStk, i)
        } else if len(leftStk) > 0 {
            leftStk = leftStk[:len(leftStk)-1]
        } else if len(asteriskStk) > 0 {
            asteriskStk = asteriskStk[:len(asteriskStk)-1]
        } else {
            return false
        }
    }
    i := len(leftStk) - 1
    for j := len(asteriskStk) - 1; i >= 0 && j >= 0; i, j = i-1, j-1 {
        if leftStk[i] > asteriskStk[j] {
            return false
        }
    }
    return i < 0
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。需要遍历字符串一次，遍历过程中每个字符的操作时间都是 $O(1)$，遍历结束之后对左括号栈和星号栈弹出元素的操作次数不会超过 $n$。

- 空间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。空间复杂度主要取决于左括号栈和星号栈，两个栈的元素总数不会超过 $n$。

#### 方法三：贪心

使用贪心的思想，可以将空间复杂度降到 $O(1)$。

从左到右遍历字符串，遍历过程中，未匹配的左括号数量可能会出现如下变化：

- 如果遇到左括号，则未匹配的左括号数量加 $1$；

- 如果遇到右括号，则需要有一个左括号和右括号匹配，因此未匹配的左括号数量减 $1$；

- 如果遇到星号，由于星号可以看成左括号、右括号或空字符串，因此未匹配的左括号数量可能加 $1$、减 $1$ 或不变。

基于上述结论，可以在遍历过程中维护未匹配的左括号数量可能的最小值和最大值，根据遍历到的字符更新最小值和最大值：

- 如果遇到左括号，则将最小值和最大值分别加 $1$；

- 如果遇到右括号，则将最小值和最大值分别减 $1$；

- 如果遇到星号，则将最小值减 $1$，将最大值加 $1$。

任何情况下，未匹配的左括号数量必须非负，因此当最大值变成负数时，说明没有左括号可以和右括号匹配，返回 $\text{false}$。

当最小值为 $0$ 时，不应将最小值继续减少，以确保最小值非负。

遍历结束时，所有的左括号都应和右括号匹配，因此只有当最小值为 $0$ 时，字符串 $s$ 才是有效的括号字符串。

```Java [sol3-Java]
class Solution {
    public boolean checkValidString(String s) {
        int minCount = 0, maxCount = 0;
        int n = s.length();
        for (int i = 0; i < n; i++) {
            char c = s.charAt(i);
            if (c == '(') {
                minCount++;
                maxCount++;
            } else if (c == ')') {
                minCount = Math.max(minCount - 1, 0);
                maxCount--;
                if (maxCount < 0) {
                    return false;
                }
            } else {
                minCount = Math.max(minCount - 1, 0);
                maxCount++;
            }
        }
        return minCount == 0;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public bool CheckValidString(string s) {
        int minCount = 0, maxCount = 0;
        int n = s.Length;
        for (int i = 0; i < n; i++) {
            char c = s[i];
            if (c == '(') {
                minCount++;
                maxCount++;
            } else if (c == ')') {
                minCount = Math.Max(minCount - 1, 0);
                maxCount--;
                if (maxCount < 0) {
                    return false;
                }
            } else {
                minCount = Math.Max(minCount - 1, 0);
                maxCount++;
            }
        }
        return minCount == 0;
    }
}
```

```JavaScript [sol3-JavaScript]
var checkValidString = function(s) {
    let minCount = 0, maxCount = 0;
    const n = s.length;
    for (let i = 0; i < n; i++) {
        const c = s[i];
        if (c === '(') {
            minCount++;
            maxCount++;
        } else if (c === ')') {
            minCount = Math.max(minCount - 1, 0);
            maxCount--;
            if (maxCount < 0) {
                return false;
            }
        } else {
            minCount = Math.max(minCount - 1, 0);
            maxCount++;
        }
    }
    return minCount === 0;
};
```

```C++ [sol3-C++]
class Solution {
public:
    bool checkValidString(string s) {
        int minCount = 0, maxCount = 0;
        int n = s.size();
        for (int i = 0; i < n; i++) {
            char c = s[i];
            if (c == '(') {
                minCount++;
                maxCount++;
            } else if (c == ')') {
                minCount = max(minCount - 1, 0);
                maxCount--;
                if (maxCount < 0) {
                    return false;
                }
            } else {
                minCount = max(minCount - 1, 0);
                maxCount++;
            }
        }
        return minCount == 0;
    }
};
```

```go [sol3-Golang]
func checkValidString(s string) bool {
    minCount, maxCount := 0, 0
    for _, ch := range s {
        if ch == '(' {
            minCount++
            maxCount++
        } else if ch == ')' {
            minCount = max(minCount-1, 0)
            maxCount--
            if maxCount < 0 {
                return false
            }
        } else {
            minCount = max(minCount-1, 0)
            maxCount++
        }
    }
    return minCount == 0
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。需要遍历字符串一次。

- 空间复杂度：$O(1)$。