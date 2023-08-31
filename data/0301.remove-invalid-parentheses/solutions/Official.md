## [301.删除无效的括号 中文官方题解](https://leetcode.cn/problems/remove-invalid-parentheses/solutions/100000/shan-chu-wu-xiao-de-gua-hao-by-leetcode-9w8au)
#### 背景知识

1. **有效的「括号」**：题目输入的字符串由一系列「左括号」和「右括号」组成，但是有一些额外的括号，使得括号不能正确配对。对于括号配对规则如果还不太清楚的读者，可以先完成问题「[20. 有效的括号](https://leetcode-cn.com/problems/valid-parentheses/)」。

2. **可以一次遍历计算出多余的「左括号」和「右括号」**：
根据括号匹配规则和根据求解「[22. 括号生成](https://leetcode-cn.com/problems/generate-parentheses/)」的经验，我们知道：如果当前遍历到的「左括号」的数目严格小于「右括号」的数目则表达式无效。因此，我们可以遍历一次输入字符串，统计「左括号」和「右括号」出现的次数。
+ 当遍历到「左括号」的时候：
    + 「左括号」数量加 $1$。
+ 当遍历到「右括号」的时候：
    + 如果此时「左括号」的数量不为 $0$，因为「右括号」可以与之前遍历到的「左括号」匹配，此时「左括号」出现的次数 $-1$；
    + 如果此时「左括号」的数量为 $0$，「右括号」数量加 $1$。

通过这样的计数规则，得到的「左括号」和「右括号」的数量就是各自最少应该删除的数量。

#### 方法一：回溯 + 剪枝

**思路与算法**

题目让我们删除括号使得剩下的括号匹配，要求我们删除最少的括号数，并且要求得到所有的结果。我们可以使用回溯算法，尝试遍历所有可能的去掉非法括号的方案。

首先我们利用括号匹配的规则求出该字符串 $s$ 中最少需要去掉的左括号的数目 $\textit{lremove}$ 和右括号的数目 $\textit{rremove}$，然后我们尝试在原字符串 $s$ 中去掉 $\textit{lremove}$ 个左括号和 $\textit{rremove}$ 个右括号，然后检测剩余的字符串是否合法匹配，如果合法匹配则我们则认为该字符串为可能的结果，我们利用回溯算法来尝试搜索所有可能的去除括号的方案。

在进行回溯时可以利用以下的剪枝技巧来增加搜索的效率：
+ 我们从字符串中每去掉一个括号，则更新 $\textit{lremove}$ 或者 $\textit{rremove}$，当我们发现剩余未尝试的字符串的长度小于 $\textit{lremove} + \textit{rremove}$ 时，则停止本次搜索。
+ 当 $\textit{lremove}$ 和 $\textit{rremove}$ 同时为 $0$ 时，则我们检测当前的字符串是否合法匹配，如果合法匹配则我们将其记录下来。

由于记录的字符串可能存在重复，因此需要对重复的结果进行去重，去重的办法有如下两种：
+ 利用哈希表对最终生成的字符串去重。
+ 我们在每次进行搜索时，如果遇到连续相同的括号我们只需要搜索一次即可，比如当前遇到的字符串为 $\texttt{"(((())"}$，去掉前四个左括号中的任意一个，生成的字符串是一样的，均为 $\texttt{"((())"}$，因此我们在尝试搜索时，只需去掉一个左括号进行下一轮搜索，不需要将前四个左括号都尝试一遍。

**代码**

```Java [sol1-Java]
class Solution {
    private List<String> res = new ArrayList<String>();

    public List<String> removeInvalidParentheses(String s) {
        int lremove = 0;
        int rremove = 0;

        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == '(') {
                lremove++;
            } else if (s.charAt(i) == ')') {
                if (lremove == 0) {
                    rremove++;
                } else {
                    lremove--;
                }
            }
        }
        helper(s, 0, lremove, rremove);

        return res;
    }

    private void helper(String str, int start, int lremove, int rremove) {
        if (lremove == 0 && rremove == 0) {
            if (isValid(str)) {
                res.add(str);
            }
            return;
        }

        for (int i = start; i < str.length(); i++) {
            if (i != start && str.charAt(i) == str.charAt(i - 1)) {
                continue;
            }
            // 如果剩余的字符无法满足去掉的数量要求，直接返回
            if (lremove + rremove > str.length() - i) {
                return;
            }
            // 尝试去掉一个左括号
            if (lremove > 0 && str.charAt(i) == '(') {
                helper(str.substring(0, i) + str.substring(i + 1), i, lremove - 1, rremove);
            }
            // 尝试去掉一个右括号
            if (rremove > 0 && str.charAt(i) == ')') {
                helper(str.substring(0, i) + str.substring(i + 1), i, lremove, rremove - 1);
            }
        }
    }

    private boolean isValid(String str) {
        int cnt = 0;
        for (int i = 0; i < str.length(); i++) {
            if (str.charAt(i) == '(') {
                cnt++;
            } else if (str.charAt(i) == ')') {
                cnt--;
                if (cnt < 0) {
                    return false;
                }
            }
        }

        return cnt == 0;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> res;
    vector<string> removeInvalidParentheses(string s) {
        int lremove = 0;
        int rremove = 0;

        for (char c : s) {
            if (c == '(') {
                lremove++;
            } else if (c == ')') {
                if (lremove == 0) {
                    rremove++;
                } else {
                    lremove--;
                }
            }
        }
        helper(s, 0, lremove, rremove);
        return res;
    }

    void helper(string str, int start, int lremove, int rremove) {
        if (lremove == 0 && rremove == 0) {
            if (isValid(str)) {
                res.push_back(str);
            }
            return;
        }
        for (int i = start; i < str.size(); i++) {
            if (i != start && str[i] == str[i - 1]) {
                continue;
            }
            // 如果剩余的字符无法满足去掉的数量要求，直接返回
            if (lremove + rremove > str.size() - i) {
                return;
            } 
            // 尝试去掉一个左括号
            if (lremove > 0 && str[i] == '(') {
                helper(str.substr(0, i) + str.substr(i + 1), i, lremove - 1, rremove);
            }
            // 尝试去掉一个右括号
            if (rremove > 0 && str[i] == ')') {
                helper(str.substr(0, i) + str.substr(i + 1), i, lremove, rremove - 1);
            }
        }
    }

    inline bool isValid(const string & str) {
        int cnt = 0;

        for (int i = 0; i < str.size(); i++) {
            if (str[i] == '(') {
                cnt++;
            } else if (str[i] == ')') {
                cnt--;
                if (cnt < 0) {
                    return false;
                }
            }
        }

        return cnt == 0;
    }
};
```

```C# [sol1-C#]
public class Solution {
    private IList<string> res = new List<string>();

    public IList<string> RemoveInvalidParentheses(string s) {
        int lremove = 0;
        int rremove = 0;

        for (int i = 0; i < s.Length; i++) {
            if (s[i] == '(') {
                lremove++;
            } else if (s[i] == ')') {
                if (lremove == 0) {
                    rremove++;
                } else {
                    lremove--;
                }
            }
        }
        Helper(s, 0, lremove, rremove);

        return res;
    }

    private void Helper(String str, int start, int lremove, int rremove) {
        if (lremove == 0 && rremove == 0) {
            if (IsValid(str)) {
                res.Add(str);
            }
            return;
        }

        for (int i = start; i < str.Length; i++) {
            if (i != start && str[i] == str[i - 1]) {
                continue;
            }
            // 如果剩余的字符无法满足去掉的数量要求，直接返回
            if (lremove + rremove > str.Length - i) {
                return;
            }
            // 尝试去掉一个左括号
            if (lremove > 0 && str[i] == '(') {
                Helper(str.Substring(0, i) + str.Substring(i + 1), i, lremove - 1, rremove);
            }
            // 尝试去掉一个右括号
            if (rremove > 0 && str[i] == ')') {
                Helper(str.Substring(0, i) + str.Substring(i + 1), i, lremove, rremove - 1);
            }
        }
    }

    private bool IsValid(String str) {
        int cnt = 0;
        for (int i = 0; i < str.Length; i++) {
            if (str[i] == '(') {
                cnt++;
            } else if (str[i] == ')') {
                cnt--;
                if (cnt < 0) {
                    return false;
                }
            }
        }

        return cnt == 0;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def removeInvalidParentheses(self, s: str) -> List[str]:
        res = []
        lremove, rremove = 0, 0
        for c in s:
            if c == '(':
                lremove += 1
            elif c == ')':
                if lremove == 0:
                    rremove += 1
                else:
                    lremove -= 1

        def isValid(str):
            cnt = 0
            for c in str:
                if c == '(':
                    cnt += 1
                elif c == ')':
                    cnt -= 1
                    if cnt < 0:
                        return False
            return cnt == 0

        def helper(s, start, lremove, rremove):
            if lremove == 0 and rremove == 0:
                if isValid(s):
                    res.append(s)
                return

            for  i in range(start, len(s)):
                if i > start and s[i] == s[i - 1]:
                    continue
                # 如果剩余的字符无法满足去掉的数量要求，直接返回
                if lremove + rremove > len(s) - i:
                    break
                # 尝试去掉一个左括号
                if lremove > 0 and s[i] == '(':
                    helper(s[:i] + s[i + 1:], i, lremove - 1, rremove);
                # 尝试去掉一个右括号
                if rremove > 0 and s[i] == ')':
                    helper(s[:i] + s[i + 1:], i, lremove, rremove - 1);
                # 统计当前字符串中已有的括号数量

        helper(s, 0, lremove, rremove)
        return res
```

```JavaScript [sol1-JavaScript]
var removeInvalidParentheses = function(s) {

    const helper = (str, start, lremove, rremove) => {
        if (lremove === 0 && rremove === 0) {
            if (isValid(str)) {
                res.push(str);
            }
            return;
        }

        for (let i = start; i < str.length; i++) {
            if (i !== start && str[i] === str[i - 1]) {
                continue;
            }
            // 如果剩余的字符无法满足去掉的数量要求，直接返回
            if (lremove + rremove > str.length - i) {
                return;
            } 
            // 尝试去掉一个左括号
            if (lremove > 0 && str[i] === '(') {
                helper(str.substr(0, i) + str.substr(i + 1), i, lremove - 1, rremove);
            }
            // 尝试去掉一个右括号
            if (rremove > 0 && str[i] === ')') {
                helper(str.substr(0, i) + str.substr(i + 1), i, lremove, rremove - 1);
            }
        }
    }

    const res = [];
    let lremove = 0;
    let rremove = 0;

    for (const c of s) {
        if (c === '(') {
            lremove++;
        } else if (c === ')') {
            if (lremove === 0) {
                rremove++;
            } else {
                lremove--;
            }
        }
    }
    helper(s, 0, lremove, rremove);
    return res;
}

const isValid = (str) => {
    let cnt = 0;

    for (let i = 0; i < str.length; i++) {
        if (str[i] === '(') {
            cnt++;
        } else if (str[i] === ')') {
            cnt--;
            if (cnt < 0) {
                return false;
            }
        }
    }

    return cnt === 0;
}
```

```go [sol1-Golang]
func isValid(str string) bool {
    cnt := 0
    for _, ch := range str {
        if ch == '(' {
            cnt++
        } else if ch == ')' {
            cnt--
            if cnt < 0 {
                return false
            }
        }
    }
    return cnt == 0
}

func helper(ans *[]string, str string, start, lremove, rremove int) {
    if lremove == 0 && rremove == 0 {
        if isValid(str) {
            *ans = append(*ans, str)
        }
        return
    }

    for i := start; i < len(str); i++ {
        if i != start && str[i] == str[i-1] {
            continue
        }
        // 如果剩余的字符无法满足去掉的数量要求，直接返回
        if lremove+rremove > len(str)-i {
            return
        }
        // 尝试去掉一个左括号
        if lremove > 0 && str[i] == '(' {
            helper(ans, str[:i]+str[i+1:], i, lremove-1, rremove)
        }
        // 尝试去掉一个右括号
        if rremove > 0 && str[i] == ')' {
            helper(ans, str[:i]+str[i+1:], i, lremove, rremove-1)
        }
    }
}

func removeInvalidParentheses(s string) (ans []string) {
    lremove, rremove := 0, 0
    for _, ch := range s {
        if ch == '(' {
            lremove++
        } else if ch == ')' {
            if lremove == 0 {
                rremove++
            } else {
                lremove--
            }
        }
    }

    helper(&ans, s, 0, lremove, rremove)
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 为字符串的长度。考虑到一个字符串最多可能有 $2^n$ 个子序列，每个子序列可能需要进行一次合法性检测，因此时间复杂度为 $O(n \times 2^n)$。

- 空间复杂度：$O(n^2)$，其中 $n$ 为字符串的长度。返回结果不计入空间复杂度，考虑到递归调用栈的深度，并且每次递归调用时需要复制字符串一次，因此空间复杂度为 $O(n^2)$。

#### 方法二：广度优先搜索

**思路与算法**

注意到题目中要求最少删除，这样的描述正是广度优先搜索算法应用的场景，并且题目也要求我们输出所有的结果。我们在进行广度优先搜索时每一轮删除字符串中的 $1$ 个括号，直到出现合法匹配的字符串为止，此时进行轮转的次数即为最少需要删除括号的个数。

我们进行广度优先搜索时，每次保存上一轮搜索的结果，然后对上一轮已经保存的结果中的每一个字符串尝试所有可能的删除一个括号的方法，然后将保存的结果进行下一轮搜索。在保存结果时，我们可以利用哈希表对上一轮生成的结果去重，从而提高效率。

**代码**

```Java [sol2-Java]
class Solution {
    public List<String> removeInvalidParentheses(String s) {
        List<String> ans = new ArrayList<String>();
        Set<String> currSet = new HashSet<String>();

        currSet.add(s);
        while (true) {
            for (String str : currSet) {
                if (isValid(str)) {
                    ans.add(str);
                }
            }
            if (ans.size() > 0) {
                return ans;
            }
            Set<String> nextSet = new HashSet<String>();
            for (String str : currSet) {
                for (int i = 0; i < str.length(); i ++) {
                    if (i > 0 && str.charAt(i) == str.charAt(i - 1)) {
                        continue;
                    }
                    if (str.charAt(i) == '(' || str.charAt(i) == ')') {
                        nextSet.add(str.substring(0, i) + str.substring(i + 1));
                    }
                }
            }
            currSet = nextSet;
        }
    }

    private boolean isValid(String str) {
        char[] ss = str.toCharArray();
        int count = 0;

        for (char c : ss) {
            if (c == '(') {
                count++;
            } else if (c == ')') {
                count--;
                if (count < 0) {
                    return false;
                }
            }
        }

        return count == 0;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    bool isValid(string str) {
        int count = 0;

        for (char c : str) {
            if (c == '(') {
                count++;
            } else if (c == ')') {
                count--;
                if (count < 0) {
                    return false;
                }
            }
        }

        return count == 0;
    }

    vector<string> removeInvalidParentheses(string s) {
        vector<string> ans;
        unordered_set<string> currSet;

        currSet.insert(s);
        while (true) {
            for (auto & str : currSet) {
                if (isValid(str))
                    ans.emplace_back(str);
            }
            if (ans.size() > 0) {
                return ans;
            }
            unordered_set<string> nextSet;
            for (auto & str : currSet) {
                for (int i = 0; i < str.size(); i++) {
                    if (i > 0 && str[i] == str[i - 1]) {
                        continue;
                    }
                    if (str[i] == '(' || str[i] == ')') {
                        nextSet.insert(str.substr(0, i) + str.substr(i + 1, str.size()));
                    }
                }
            }
            currSet = nextSet;
        }
    }
};
```

```C# [sol2-C#]
public class Solution {
    public IList<string> RemoveInvalidParentheses(string s) {
        List<string> ans = new List<string>();
        ISet<string> currSet = new HashSet<string>();

        currSet.Add(s);
        while (true) {
            foreach (String str in currSet) {
                if (IsValid(str)) {
                    ans.Add(str);
                }
            }
            if (ans.Count > 0) {
                return ans;
            }
            ISet<string> nextSet = new HashSet<string>();
            foreach (string str in currSet) {
                for (int i = 0; i < str.Length; i++) {
                    if (i > 0 && str[i] == str[i - 1]) {
                        continue;
                    }
                    if (str[i] == '(' || str[i] == ')') {
                        nextSet.Add(str.Substring(0, i) + str.Substring(i + 1));
                    }
                }
            }
            currSet = nextSet;
        }
    }

    private bool IsValid(String str) {
        int count = 0;

        foreach (char c in str) {
            if (c == '(') {
                count++;
            } else if (c == ')') {
                count--;
                if (count < 0) {
                    return false;
                }
            }
        }

        return count == 0;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def removeInvalidParentheses(self, s: str) -> List[str]:
        def isValid(s):
            count = 0
            for c in s:
                if c == '(':
                    count += 1
                elif c == ')':
                    count -= 1
                    if count < 0:
                        return False
            return count == 0

        ans = []
        currSet = set([s])

        while True:
            for ss in currSet:
                if isValid(ss):
                    ans.append(ss)
            if len(ans) > 0:
                return ans
            nextSet = set()
            for ss in currSet:
                for i in range(len(ss)):
                    if i > 0 and ss[i] == s[i - 1]:
                        continue
                    if ss[i] == '(' or ss[i] == ')':
                        nextSet.add(ss[:i] + ss[i + 1:])
            currSet = nextSet
        return ans
```

```JavaScript [sol2-JavaScript]
var removeInvalidParentheses = function(s) {
    const ans = [];
    let currSet = new Set();

    currSet.add(s);
    while (true) {
        for (const str of currSet) {
            if (isValid(str)) {
                ans.push(str);
            }
        }
        if (ans.length > 0) {
            return ans;
        }
        const nextSet = new Set();
        for (const str of currSet) {
            for (let i = 0; i < str.length; i ++) {
                if (i > 0 && str[i] === str[i - 1]) {
                    continue;
                }
                if (str[i] === '(' || str[i] === ')') {
                    nextSet.add(str.substring(0, i) + str.substring(i + 1));
                }
            }
        }
        currSet = nextSet;
    }
}

const isValid = (str) => {
    let count = 0;

    for (const c of str) {
        if (c === '(') {
            count++;
        } else if (c === ')') {
            count--;
            if (count < 0) {
                return false;
            }
        }
    }

    return count === 0;
}
```

```go [sol2-Golang]
func isValid(str string) bool {
    cnt := 0
    for _, ch := range str {
        if ch == '(' {
            cnt++
        } else if ch == ')' {
            cnt--
            if cnt < 0 {
                return false
            }
        }
    }
    return cnt == 0
}

func removeInvalidParentheses(s string) (ans []string) {
    curSet := map[string]struct{}{s: {}}
    for {
        for str := range curSet {
            if isValid(str) {
                ans = append(ans, str)
            }
        }
        if len(ans) > 0 {
            return
        }
        nextSet := map[string]struct{}{}
        for str := range curSet {
            for i, ch := range str {
                if i > 0 && byte(ch) == str[i-1] {
                    continue
                }
                if ch == '(' || ch == ')' {
                    nextSet[str[:i]+str[i+1:]] = struct{}{}
                }
            }
        }
        curSet = nextSet
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 为字符串的长度。考虑到一个字符串最多可能有 $2^n$ 个子序列，因此时间复杂度为 $O(n \times 2^n)$。

- 空间复杂度：$O(n \times C_n^\frac{n}{2})$，其中 $n$ 为字符串的长度。我们在进行第 $i$ 轮迭代时，会从原始字符串中删除 $i$ 个括号，因此第 $i$ 轮迭代产生的字符串最多有 $C_n^i$ 个，当 $i = \frac{n}{2}$ 时组合数最大，此时迭代生成的字符串个数最多，因此空间复杂度为 $O(n \times C_n^\frac{n}{2})$。

#### 方法三：枚举状态子集

**思路与算法**

首先我们利用括号匹配的规则求出该字符串 $s$ 中最少需要去掉的左括号的数目 $\textit{lremove}$ 和右括号的数目 $\textit{rremove}$，然后我们利用状态子集求出字符串 $s$ 中所有的左括号去掉 $\textit{lremove}$ 的左括号的子集，和所有的右括号去掉 $\textit{rremove}$ 个右括号的子集，依次枚举这两种子集的组合，检测组合后的字符串是否合法匹配，如果字符串合法则记录，最后我们利用哈希表对结果进行去重。

**代码**

```Java [sol3-Java]
class Solution {
    public List<String> removeInvalidParentheses(String s) {
        int lremove = 0;
        int rremove = 0;
        List<Integer> left = new ArrayList<Integer>();
        List<Integer> right = new ArrayList<Integer>();
        List<String> ans = new ArrayList<String>();
        Set<String> cnt = new HashSet<String>();

        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == '(') {
                left.add(i);
                lremove++;
            } else if (s.charAt(i) == ')') {
                right.add(i);
                if (lremove == 0) {
                    rremove++;
                } else {
                    lremove--;
                }
            }
        }

        int m = left.size();
        int n = right.size();
        List<Integer> maskArr1 = new ArrayList<Integer>();
        List<Integer> maskArr2 = new ArrayList<Integer>();
        for (int i = 0; i < (1 << m); i++) {
            if (Integer.bitCount(i) != lremove) {
                continue;
            }
            maskArr1.add(i);
        }
        for (int i = 0; i < (1 << n); i++) {
            if (Integer.bitCount(i) != rremove) {
                continue;
            }
            maskArr2.add(i);
        }
        for (int mask1 : maskArr1) {
            for (int mask2 : maskArr2) {
                if (checkValid(s, mask1, left, mask2, right)) {
                    cnt.add(recoverStr(s, mask1, left, mask2, right));
                }
            }
        }
        for (String v : cnt) {
            ans.add(v);
        }

        return ans;
    }

    private boolean checkValid(String str, int lmask, List<Integer> left, int rmask, List<Integer> right) {
        int pos1 = 0;
        int pos2 = 0;
        int cnt = 0;

        for (int i = 0; i < str.length(); i++) {
            if (pos1 < left.size() && i == left.get(pos1)) {
                if ((lmask & (1 << pos1)) == 0) {
                    cnt++;
                }
                pos1++;
            } else if (pos2 < right.size() && i == right.get(pos2)) {
                if ((rmask & (1 << pos2)) == 0) {
                    cnt--;
                    if (cnt < 0) {
                        return false;
                    }
                }
                pos2++;
            }
        }

        return cnt == 0;
    }

    private String recoverStr(String str, int lmask, List<Integer> left, int rmask, List<Integer> right) {
        StringBuilder sb = new StringBuilder();
        int pos1 = 0;
        int pos2 = 0;

        for (int i = 0; i < str.length(); i++) {
            if (pos1 < left.size() && i == left.get(pos1)) {
                if ((lmask & (1 << pos1)) == 0) {
                    sb.append(str.charAt(i));
                }
                pos1++;
            } else if (pos2 < right.size() && i == right.get(pos2)) {
                if ((rmask & (1 << pos2)) == 0) {
                    sb.append(str.charAt(i));
                }
                pos2++;
            } else {
                sb.append(str.charAt(i));
            }
        }

        return sb.toString();
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    bool checkValid(const string & str, int lmask, vector<int> & left, int rmask, vector<int> & right) {
        int pos1 = 0;
        int pos2 = 0;
        int cnt = 0;

        for (int i = 0; i < str.size(); i++) {
            if (pos1 < left.size() && i == left[pos1]) {
                if (!(lmask & (1 << pos1))) {
                    cnt++;
                }
                pos1++;
            } else if (pos2 < right.size() && i == right[pos2]) {
                if (!(rmask & (1 << pos2))) {
                    cnt--;
                    if (cnt < 0) {
                        return false;
                    }
                }
                pos2++;
            }
        }

        return cnt == 0;
    }

    string recoverStr(const string & str, int lmask, vector<int> & left, int rmask, vector<int> & right){
        string ans;
        int pos1 = 0;
        int pos2 = 0;

        for (int i = 0; i < str.size(); i++) {
            if (pos1 < left.size() && i == left[pos1]) {
                if (!(lmask & (1 << pos1))){
                    ans.push_back(str[i]);
                }
                pos1++;
            } else if (pos2 < right.size() && i == right[pos2]) {
                if (!(rmask & (1 << pos2))) {
                    ans.push_back(str[i]);
                }
                pos2++;
            } else {
                ans.push_back(str[i]);
            }
        }

        return ans;
    }

    vector<string> removeInvalidParentheses(string s) {
        int lremove = 0;
        int rremove = 0;
        vector<int> left;
        vector<int> right;
        vector<string> ans;
        unordered_set<string> cnt;

        for (int i = 0; i < s.size(); i++) {
            if (s[i] == '(') {
                left.push_back(i);
                lremove++;
            } else if (s[i] == ')') {
                right.push_back(i);
                if (lremove == 0) {
                    rremove++;
                } else {
                    lremove--;
                }
            }
        }

        int m = left.size();
        int n = right.size();
        vector<int> maskArr1;
        vector<int> maskArr2;
        for (int i = 0; i < (1 << m); i++) {
            if (__builtin_popcount(i) != lremove) {
                continue;
            }
            maskArr1.push_back(i);
        }
        for (int j = 0; j < (1 << n); j++) {
            if (__builtin_popcount(j) != rremove) {
                continue;
            }
            maskArr2.push_back(j);
        }
        for (auto mask1 : maskArr1) {
            for (auto mask2 : maskArr2) {
                if (checkValid(s, mask1, left, mask2, right)) {
                    cnt.insert(recoverStr(s, mask1, left, mask2, right));
                }
            }
        }
        for (auto v : cnt) {
            ans.emplace_back(v);
        }

        return ans;
    }
};
```

```C# [sol3-C#]
public class Solution {
    public IList<string> RemoveInvalidParentheses(string s) {
        int lremove = 0;
        int rremove = 0;
        IList<int> left = new List<int>();
        IList<int> right = new List<int>();
        IList<string> ans = new List<string>();
        ISet<string> cnt = new HashSet<string>();

        for (int i = 0; i < s.Length; i++) {
            if (s[i] == '(') {
                left.Add(i);
                lremove++;
            } else if (s[i] == ')') {
                right.Add(i);
                if (lremove == 0) {
                    rremove++;
                } else {
                    lremove--;
                }
            }
        }

        int m = left.Count;
        int n = right.Count;
        IList<int> maskArr1 = new List<int>();
        IList<int> maskArr2 = new List<int>();
        for (int i = 0; i < (1 << m); i++) {
            if (CountBit(i) != lremove) {
                continue;
            }
            maskArr1.Add(i);
        }
        for (int i = 0; i < (1 << n); i++) {
            if (CountBit(i) != rremove) {
                continue;
            }
            maskArr2.Add(i);
        }
        foreach (int mask1 in maskArr1) {
            foreach (int mask2 in maskArr2) {
                if (CheckValid(s, mask1, left, mask2, right)) {
                    cnt.Add(RecoverStr(s, mask1, left, mask2, right));
                }
            }
        }
        foreach (string v in cnt) {
            ans.Add(v);
        }

        return ans;
    }

    private bool CheckValid(string str, int lmask, IList<int> left, int rmask, IList<int> right) {
        int pos1 = 0;
        int pos2 = 0;
        int cnt = 0;

        for (int i = 0; i < str.Length; i++) {
            if (pos1 < left.Count && i == left[pos1]) {
                if ((lmask & (1 << pos1)) == 0) {
                    cnt++;
                }
                pos1++;
            } else if (pos2 < right.Count && i == right[pos2]) {
                if ((rmask & (1 << pos2)) == 0) {
                    cnt--;
                    if (cnt < 0) {
                        return false;
                    }
                }
                pos2++;
            }
        }

        return cnt == 0;
    }

    private string RecoverStr(String str, int lmask, IList<int> left, int rmask, IList<int> right) {
        StringBuilder sb = new StringBuilder();
        int pos1 = 0;
        int pos2 = 0;

        for (int i = 0; i < str.Length; i++) {
            if (pos1 < left.Count && i == left[pos1]) {
                if ((lmask & (1 << pos1)) == 0) {
                    sb.Append(str[i]);
                }
                pos1++;
            } else if (pos2 < right.Count && i == right[pos2]) {
                if ((rmask & (1 << pos2)) == 0) {
                    sb.Append(str[i]);
                }
                pos2++;
            } else {
                sb.Append(str[i]);
            }
        }

        return sb.ToString();
    }

    private int CountBit(int x) {
        int res = 0;
        while (x != 0) {
            x &= (x - 1);
            res++;
        }
        return res;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def removeInvalidParentheses(self, s: str) -> List[str]:
        def checkValid(str, lmask, left, rmask, right):
            pos1, pos2 = 0, 0
            cnt = 0

            for i in range(len(str)):
                if pos1 < len(left) and i == left[pos1]:
                    if lmask & (1 << pos1) == 0:
                        cnt += 1
                    pos1 += 1
                elif pos2 < len(right) and i == right[pos2]:
                    if rmask & (1 << pos2) == 0:
                        cnt -= 1
                        if cnt < 0:
                            return False
                    pos2 += 1

            return cnt == 0

        def recoverStr(lmask, left, rmask, right):
            pos1, pos2 = 0, 0
            res = ""

            for i in range(len(s)):
                if pos1 < len(left) and i == left[pos1]:
                    if lmask & (1 << pos1) == 0:
                        res += s[i]
                    pos1 += 1
                elif pos2 < len(right) and i == right[pos2]:
                    if rmask & (1 << pos2) == 0:
                        res += s[i]
                    pos2 += 1
                else:
                    res += s[i]

            return res

        def countBit(x):
            res = 0
            while x != 0:
                x = x & (x - 1)
                res += 1
            return res

        lremove, rremove = 0, 0
        left, right = [], []
        ans = []
        cnt = set()

        for i in range(len(s)):
            if s[i] == '(':
                left.append(i)
                lremove += 1
            elif s[i] == ')':
                right.append(i)
                if lremove == 0:
                    rremove += 1
                else:
                    lremove -= 1

        m, n = len(left), len(right)
        maskArr1, maskArr2 = [], []
        for i in range(1 << m):
            if countBit(i) != lremove:
                continue
            maskArr1.append(i)
        for i in range(1 << n):
            if countBit(i) != rremove:
                continue
            maskArr2.append(i)
        for mask1 in maskArr1:
            for mask2 in maskArr2:
                if checkValid(s, mask1, left, mask2, right):
                    cnt.add(recoverStr(mask1, left, mask2, right))
            
        return [val for val in cnt]
```

```JavaScript [sol3-JavaScript]
var removeInvalidParentheses = function(s) {
    let lremove = 0;
    let rremove = 0;
    const left = [];
    const right = [];
    const ans = [];
    const cnt = new Set();

    for (let i = 0; i < s.length; i++) {
        if (s[i] === '(') {
            left.push(i);
            lremove++;
        } else if (s[i] === ')') {
            right.push(i);
            if (lremove === 0) {
                rremove++;
            } else {
                lremove--;
            }
        }
    }

    const m = left.length;
    const n = right.length;
    const maskArr1 = [];
    const maskArr2 = [];
    for (let i = 0; i < (1 << m); i++) {
        if (bitCount(i) !== lremove) {
            continue;
        }
        maskArr1.push(i);
    }
    for (let i = 0; i < (1 << n); i++) {
        if (bitCount(i) !== rremove) {
            continue;
        }
        maskArr2.push(i);
    }
    for (const mask1 of maskArr1) {
        for (const mask2 of maskArr2) {
            if (checkValid(s, mask1, left, mask2, right)) {
                cnt.add(recoverStr(s, mask1, left, mask2, right));
            }
        }
    }
    for (const v of cnt) {
        ans.push(v);
    }

    return ans;
}

const bitCount = (n) => {
    let ret = 0;
    while (n) {
        n &= n - 1;
        ret++;
    }
    return ret;
};

const checkValid = (str, lmask, left, rmask, right) => {
    let pos1 = 0;
    let pos2 = 0;
    let cnt = 0;

    for (let i = 0; i < str.length; i++) {
        if (pos1 < left.length && i === left[pos1]) {
            if ((lmask & (1 << pos1)) === 0) {
                cnt++;
            }
            pos1++;
        } else if (pos2 < right.length && i === right[pos2]) {
            if ((rmask & (1 << pos2)) === 0) {
                cnt--;
                if (cnt < 0) {
                    return false;
                }
            }
            pos2++;
        }
    }

    return cnt === 0;
}

const recoverStr = (str, lmask, left, rmask, right) => {
    const sb = [];
    let pos1 = 0;
    let pos2 = 0;

    for (let i = 0; i < str.length; i++) {
        if (pos1 < left.length && i === left[pos1]) {
            if ((lmask & (1 << pos1)) === 0) {
                sb.push(str[i]);
            }
            pos1++;
        } else if (pos2 < right.length && i === right[pos2]) {
            if ((rmask & (1 << pos2)) === 0) {
                sb.push(str[i]);
            }
            pos2++;
        } else {
            sb.push(str[i]);
        }
    }

    return sb.join('');
}
```

```go [sol3-Golang]
func checkValid(str string, lmask, rmask int, left, right []int) bool {
    cnt := 0
    pos1, pos2 := 0, 0
    for i := range str {
        if pos1 < len(left) && i == left[pos1] {
            if lmask>>pos1&1 == 0 {
                cnt++
            }
            pos1++
        } else if pos2 < len(right) && i == right[pos2] {
            if rmask>>pos2&1 == 0 {
                cnt--
                if cnt < 0 {
                    return false
                }
            }
            pos2++
        }
    }
    return cnt == 0
}

func recoverStr(str string, lmask, rmask int, left, right []int) string {
    res := []rune{}
    pos1, pos2 := 0, 0
    for i, ch := range str {
        if pos1 < len(left) && i == left[pos1] {
            if lmask>>pos1&1 == 0 {
                res = append(res, ch)
            }
            pos1++
        } else if pos2 < len(right) && i == right[pos2] {
            if rmask>>pos2&1 == 0 {
                res = append(res, ch)
            }
            pos2++
        } else {
            res = append(res, ch)
        }
    }
    return string(res)
}

func removeInvalidParentheses(s string) (ans []string) {
    var left, right []int
    lremove, rremove := 0, 0
    for i, ch := range s {
        if ch == '(' {
            left = append(left, i)
            lremove++
        } else if ch == ')' {
            right = append(right, i)
            if lremove == 0 {
                rremove++
            } else {
                lremove--
            }
        }
    }

    var maskArr1, maskArr2 []int
    for i := 0; i < 1<<len(left); i++ {
        if bits.OnesCount(uint(i)) == lremove {
            maskArr1 = append(maskArr1, i)
        }
    }
    for i := 0; i < 1<<len(right); i++ {
        if bits.OnesCount(uint(i)) == rremove {
            maskArr2 = append(maskArr2, i)
        }
    }

    res := map[string]struct{}{}
    for _, mask1 := range maskArr1 {
        for _, mask2 := range maskArr2 {
            if checkValid(s, mask1, mask2, left, right) {
                res[recoverStr(s, mask1, mask2, left, right)] = struct{}{}
            }
        }
    }
    for str := range res {
        ans = append(ans, str)
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 为字符串的长度。考虑到一个字符串最多可能有 $2^n$ 个子序列，每个子序列可能需要进行一次合法性检测，因此时间复杂度为 $O(n \times 2^n)$。

- 空间复杂度：$O(n \times C_n^m)$，其中 $n$ 为字符串的长度，$m$ 为字符串中非法括号的数目。空间复杂度主要为集合 $\texttt{cnt}$ 占用的空间。