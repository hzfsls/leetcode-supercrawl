## [1081.不同字符的最小子序列 中文官方题解](https://leetcode.cn/problems/smallest-subsequence-of-distinct-characters/solutions/100000/bu-tong-zi-fu-de-zui-xiao-zi-xu-lie-by-l-5qyk)

### 📺 视频题解  
![...081. 不同字符的最小子序列 .mp4](80f8a567-14de-4568-81b6-d23a6d676eef)

### 📖 文字题解
#### 方法一：贪心 + 单调栈

**思路与算法**

首先考虑一个简单的问题：给定一个字符串 $s$，如何去掉其中的一个字符 $\textit{ch}$，使得得到的字符串字典序最小呢？答案是：找出最小的满足 $s[i]>s[i+1]$ 的下标 $i$，并去除字符 $s[i]$。为了叙述方便，下文中称这样的字符为「关键字符」。

在理解这一点之后，就可以着手本题了。一个直观的思路是：我们在字符串 $s$ 中找到「关键字符」，去除它，然后不断进行这样的循环。但是这种朴素的解法会创建大量的中间字符串，我们有必要寻找一种更优的方法。

我们从前向后扫描原字符串。每扫描到一个位置，我们就尽可能地处理所有的「关键字符」。假定在扫描位置 $s[i-1]$ 之前的所有「关键字符」都已经被去除完毕，在扫描字符 $s[i]$ 时，新出现的「关键字符」只可能出现在 $s[i]$ 或者其后面的位置。

于是，我们使用单调栈来维护去除「关键字符」后得到的字符串，单调栈满足栈底到栈顶的字符递增。如果栈顶字符大于当前字符 $s[i]$，说明栈顶字符为「关键字符」，故应当被去除。去除后，新的栈顶字符就与 $s[i]$ 相邻了，我们继续比较新的栈顶字符与 $s[i]$ 的大小。重复上述操作，直到栈为空或者栈顶字符不大于 $s[i]$。

我们还遗漏了一个要求：原字符串 $s$ 中的每个字符都需要出现在新字符串中，且只能出现一次。为了让新字符串满足该要求，之前讨论的算法需要进行以下两点的更改。

- 在考虑字符 $s[i]$ 时，如果它已经存在于栈中，则不能加入字符 $s[i]$。为此，需要记录每个字符是否出现在栈中。

- 在弹出栈顶字符时，如果字符串在后面的位置上再也没有这一字符，则不能弹出栈顶字符。为此，需要记录每个字符的剩余数量，当这个值为 $0$ 时，就不能弹出栈顶字符了。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string smallestSubsequence(string s) {
        vector<int> vis(26), num(26);
        for (char ch : s) {
            num[ch - 'a']++;
        }

        string stk;
        for (char ch : s) {
            if (!vis[ch - 'a']) {
                while (!stk.empty() && stk.back() > ch) {
                    if (num[stk.back() - 'a'] > 0) {
                        vis[stk.back() - 'a'] = 0;
                        stk.pop_back();
                    } else {
                        break;
                    }
                }
                vis[ch - 'a'] = 1;
                stk.push_back(ch);
            }
            num[ch - 'a'] -= 1;
        }
        return stk;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String smallestSubsequence(String s) {
        boolean[] vis = new boolean[26];
        int[] num = new int[26];
        for (int i = 0; i < s.length(); i++) {
            num[s.charAt(i) - 'a']++;
        }

        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            if (!vis[ch - 'a']) {
                while (sb.length() > 0 && sb.charAt(sb.length() - 1) > ch) {
                    if (num[sb.charAt(sb.length() - 1) - 'a'] > 0) {
                        vis[sb.charAt(sb.length() - 1) - 'a'] = false;
                        sb.deleteCharAt(sb.length() - 1);
                    } else {
                        break;
                    }
                }
                vis[ch - 'a'] = true;
                sb.append(ch);
            }
            num[ch - 'a'] -= 1;
        }
        return sb.toString();
    }
}
```

```JavaScript [sol1-JavaScript]
var smallestSubsequence = function(s) {
    const vis = new Array(26).fill(0);
    const num = _.countBy(s);
    
    const sb = new Array();
    for (let i = 0; i < s.length; i++) {
        const ch = s[i];
        if (!vis[ch.charCodeAt() - 'a'.charCodeAt()]) {
            while (sb.length > 0 && sb[sb.length - 1] > ch) {
                if (num[sb[sb.length - 1]] > 0) {
                    vis[sb[sb.length - 1].charCodeAt() - 'a'.charCodeAt()] = 0;
                    sb.pop();
                } else {
                    break;
                }
            }
            vis[ch.charCodeAt() - 'a'.charCodeAt()] = 1;
            sb.push(ch);
        }
        num[ch]--;
    }
    return sb.join('');
};
```

```Go [sol1-Golang]
func smallestSubsequence(s string) string {
    left := [26]int{}
    for _, ch := range s {
        left[ch-'a']++
    }
    stack := []byte{}
    inStack := [26]bool{}
    for i := range s {
        ch := s[i]
        if !inStack[ch-'a'] {
            for len(stack) > 0 && ch < stack[len(stack)-1] {
                last := stack[len(stack)-1] - 'a'
                if left[last] == 0 {
                    break
                }
                stack = stack[:len(stack)-1]
                inStack[last] = false
            }
            stack = append(stack, ch)
            inStack[ch-'a'] = true
        }
        left[ch-'a']--
    }
    return string(stack)
}
```

```C [sol1-C]
char* smallestSubsequence(char* s) {
    int vis[26], num[26];
    memset(vis, 0, sizeof(vis));
    memset(num, 0, sizeof(num));

    int n = strlen(s);
    for (int i = 0; i < n; i++) {
        num[s[i] - 'a']++;
    }

    char* stk = malloc(sizeof(char) * 27);
    int stkTop = 0;
    for (int i = 0; i < n; i++) {
        if (!vis[s[i] - 'a']) {
            while (stkTop > 0 && stk[stkTop - 1] > s[i]) {
                if (num[stk[stkTop - 1] - 'a'] > 0) {
                    vis[stk[--stkTop] - 'a'] = 0;
                } else {
                    break;
                }
            }
            vis[s[i] - 'a'] = 1;
            stk[stkTop++] = s[i];
        }
        num[s[i] - 'a'] -= 1;
    }
    stk[stkTop] = '\0';
    return stk;
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为字符串长度。代码中虽然有双重循环，但是每个字符至多只会入栈、出栈各一次。

- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 为字符集合，本题中字符均为小写字母，所以 $|\Sigma|=26$。由于栈中的字符不能重复，因此栈中最多只能有 $|\Sigma|$ 个字符，另外需要维护两个数组，分别记录每个字符是否出现在栈中以及每个字符的剩余数量。