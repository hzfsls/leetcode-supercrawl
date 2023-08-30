#### 方法一：贪心

这道题是括号匹配的题目。每个左括号必须对应一个右括号，而且左括号必须在对应的右括号之前。

对于括号匹配的题目，常用的做法是使用栈进行匹配，栈具有后进先出的特点，因此可以保证右括号和最近的左括号进行匹配。其实，这道题可以使用计数代替栈，进行匹配时每次都取距离当前位置最近的括号，就可以确保平衡。

从左到右遍历字符串，在遍历过程中维护左括号的个数以及添加次数。

如果遇到左括号，则将左括号的个数加 $1$。

如果遇到右括号，则需要和前面的左括号进行匹配，具体做法如下：

- 如果左括号的个数大于 $0$，则前面有左括号可以匹配，因此将左括号的个数减 $1$，表示有一个左括号和当前右括号匹配；

- 如果左括号的个数等于 $0$，则前面没有左括号可以匹配，需要添加一个左括号才能匹配，因此将添加次数加 $1$。

遍历结束后，需要检查左括号的个数是否为 $0$。如果不为 $0$，则说明还有剩下的左括号没有匹配，对于每个剩下的左括号都需要添加一个右括号才能匹配，此时需要添加的右括号个数为剩下的左括号个数，将需要添加的右括号个数加到添加次数。

无论是哪种添加的情况，都是在遇到括号无法进行匹配的情况下才进行添加，因此上述做法得到的添加次数是最少的。

```Python [sol1-Python3]
class Solution:
    def minAddToMakeValid(self, s: str) -> int:
        ans = cnt = 0
        for c in s:
            if c == '(':
                cnt += 1
            elif cnt > 0:
                cnt -= 1
            else:
                ans += 1
        return ans + cnt
```

```Java [sol1-Java]
class Solution {
    public int minAddToMakeValid(String s) {
        int ans = 0;
        int leftCount = 0;
        int length = s.length();
        for (int i = 0; i < length; i++) {
            char c = s.charAt(i);
            if (c == '(') {
                leftCount++;
            } else {
                if (leftCount > 0) {
                    leftCount--;
                } else {
                    ans++;
                }
            }
        }
        ans += leftCount;
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinAddToMakeValid(string s) {
        int ans = 0;
        int leftCount = 0;
        int length = s.Length;
        for (int i = 0; i < length; i++) {
            char c = s[i];
            if (c == '(') {
                leftCount++;
            } else {
                if (leftCount > 0) {
                    leftCount--;
                } else {
                    ans++;
                }
            }
        }
        ans += leftCount;
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minAddToMakeValid(string s) {
        int ans = 0;
        int leftCount = 0;
        for (auto &c : s) {
            if (c == '(') {
                leftCount++;
            } else {
                if (leftCount > 0) {
                    leftCount--;
                } else {
                    ans++;
                }
            }
        }
        ans += leftCount;
        return ans;
    }
};
```

```C [sol1-C]
int minAddToMakeValid(char * s){
    int ans = 0;
    int leftCount = 0;
    int length = strlen(s);
    for (int i = 0; i < length; i++) {
        char c = s[i];
        if (c == '(') {
            leftCount++;
        } else {
            if (leftCount > 0) {
                leftCount--;
            } else {
                ans++;
            }
        }
    }
    ans += leftCount;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var minAddToMakeValid = function(s) {
    let ans = 0;
    let leftCount = 0;
    let length = s.length;
    for (let i = 0; i < length; i++) {
        const c = s[i];
        if (c === '(') {
            leftCount++;
        } else {
            if (leftCount > 0) {
                leftCount--;
            } else {
                ans++;
            }
        }
    }
    ans += leftCount;
    return ans;
};
```

```go [sol1-Golang]
func minAddToMakeValid(s string) (ans int) {
    cnt := 0
    for _, c := range s {
        if c == '(' {
            cnt++
        } else if cnt > 0 {
            cnt--
        } else {
            ans++
        }
    }
    return ans + cnt
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。遍历字符串一次。

- 空间复杂度：$O(1)$。只需要维护常量的额外空间。