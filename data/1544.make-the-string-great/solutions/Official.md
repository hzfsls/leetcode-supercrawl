## [1544.整理字符串 中文官方题解](https://leetcode.cn/problems/make-the-string-great/solutions/100000/zheng-li-zi-fu-chuan-by-leetcode-solution)

#### 方法一：模拟

**思路与算法**

从左到右扫描字符串 `s` 的每个字符。扫描过程中，维护当前整理好的字符串，记为 `ret`。当扫描到字符 `ch` 时，有两种情况：
- 字符 `ch` 与字符串 `ret` 的最后一个字符互为同一个字母的大小写：根据题意，两个字符都要在整理过程中被删除，因此要弹出 `ret` 的最后一个字符；
- 否则：两个字符都需要被保留，因此要将字符 `ch` 附加在字符串 `ret` 的后面。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string makeGood(string s) {
        string ret;
        for (char ch: s) {
            if (!ret.empty() && tolower(ret.back()) == tolower(ch) && ret.back() != ch) {
                ret.pop_back();
            }
            else {
                ret.push_back(ch);
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String makeGood(String s) {
        StringBuffer ret = new StringBuffer();
        int retIndex = -1;
        int length = s.length();
        for (int i = 0; i < length; i++) {
            char ch = s.charAt(i);
            if (ret.length() > 0 && Character.toLowerCase(ret.charAt(retIndex)) == Character.toLowerCase(ch) && ret.charAt(retIndex) != ch) {
                ret.deleteCharAt(retIndex);
                retIndex--;
            } else {
                ret.append(ch);
                retIndex++;
            }
        }
        return ret.toString();
    }
}
```

```JavaScript [sol1-JavaScript]
var makeGood = function(s) {
    const len = s.length;
    const ret = [];
    let i = 0;
    while (i < len) {
        if (ret.length > 0
        && ret[ret.length - 1].toLowerCase() === s.charAt(i).toLowerCase()
        && ret[ret.length - 1] !== s.charAt(i)
        ) {
            ret.pop();
        } else {
            ret.push(s.charAt(i));
        }
        i += 1;
    }
    return ret.join('');
};
```

```Python [sol1-Python3]
class Solution:
    def makeGood(self, s: str) -> str:
        ret = list()
        for ch in s:
            if ret and ret[-1].lower() == ch.lower() and ret[-1] != ch:
                ret.pop()
            else:
                ret.append(ch)
        return "".join(ret)
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为字符串 `s` 的长度。我们要遍历字符串 `s` 的每一个字符，而对每个字符都只需要常数时间的操作。

- 空间复杂度：$O(N)$ 或 $O(1)$，取决于使用语言的字符串类型是否是可修改的。