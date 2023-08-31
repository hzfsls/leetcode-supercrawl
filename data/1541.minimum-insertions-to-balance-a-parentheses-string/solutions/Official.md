## [1541.平衡括号字符串的最少插入次数 中文官方题解](https://leetcode.cn/problems/minimum-insertions-to-balance-a-parentheses-string/solutions/100000/ping-heng-gua-hao-zi-fu-chuan-de-zui-shao-cha-ru-2)

#### 方法一：贪心

这道题是括号匹配的题目。每个左括号必须对应两个连续的右括号，而且左括号必须在对应的连续两个右括号之前。

对于括号匹配的题目，常用的做法是使用栈进行匹配，栈具有后进先出的特点，因此可以保证右括号和最近的左括号进行匹配。其实，这道题可以使用计数代替栈，进行匹配时每次都取距离当前位置最近的括号，就可以确保平衡。

由于每个左括号要匹配两个连续的右括号，显然维护左括号的个数更为方便。从左到右遍历字符串，在遍历过程中维护左括号的个数以及插入次数。

如果遇到左括号，则将左括号的个数加 $1$，并将下标加 $1$。

如果遇到右括号，则需要进行两步操作，一是和前面的左括号进行匹配，二是需要确保有两个连续的右括号。具体做法如下：

- 和前面的左括号进行匹配，如果左括号的个数大于 $0$，则说明前面有左括号可以匹配，因此将左括号的个数减 $1$，否则说明前面没有左括号可以匹配，需要插入一个左括号才能匹配，因此将插入次数加 $1$；

- 确保有两个连续的右括号，如果当前下标的后面的一个字符是右括号，则当前下标和后一个下标是两个连续的右括号，因此将下标加 $2$，否则就需要在当前位置的后面插入一个右括号，才有两个连续的右括号，因此将插入次数加 $1$，并将下标加 $1$。

遍历结束后，需要检查左括号的个数是否为 $0$。如果不为 $0$，则说明还有剩下的左括号没有匹配，对于每个剩下的左括号，需要插入两个右括号才能匹配，此时需要插入的右括号个数为剩下的左括号个数乘以 $2$，将需要插入的右括号个数加到插入次数。

无论是哪种插入的情况，都是在遇到括号无法进行匹配的情况下才进行插入，因此上述做法得到的插入次数是最少的。

```Java [sol1-Java]
class Solution {
    public int minInsertions(String s) {
        int insertions = 0;
        int leftCount = 0;
        int length = s.length();
        int index = 0;
        while (index < length) {
            char c = s.charAt(index);
            if (c == '(') {
                leftCount++;
                index++;
            } else {
                if (leftCount > 0) {
                    leftCount--;
                } else {
                    insertions++;
                }
                if (index < length - 1 && s.charAt(index + 1) == ')') {
                    index += 2;
                } else {
                    insertions++;
                    index++;
                }
            }
        }
        insertions += leftCount * 2;
        return insertions;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinInsertions(string s) {
        int insertions = 0;
        int leftCount = 0;
        int length = s.Length;
        int index = 0;
        while (index < length) {
            char c = s[index];
            if (c == '(') {
                leftCount++;
                index++;
            } else {
                if (leftCount > 0) {
                    leftCount--;
                } else {
                    insertions++;
                }
                if (index < length - 1 && s[index + 1] == ')') {
                    index += 2;
                } else {
                    insertions++;
                    index++;
                }
            }
        }
        insertions += leftCount * 2;
        return insertions;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minInsertions(string s) {
        int insertions = 0;
        int leftCount = 0;
        int length = s.size();
        int index = 0;
        while (index < length) {
            char c = s[index];
            if (c == '(') {
                leftCount++;
                index++;
            } else {
                if (leftCount > 0) {
                    leftCount--;
                } else {
                    insertions++;
                }
                if (index < length - 1 && s[index + 1] == ')') {
                    index += 2;
                } else {
                    insertions++;
                    index++;
                }
            }
        }
        insertions += leftCount * 2;
        return insertions;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minInsertions(self, s: str) -> int:
        length = len(s)
        insertions = leftCount = index = 0

        while index < length:
            if s[index] == "(":
                leftCount += 1
                index += 1
            else:
                if leftCount > 0:
                    leftCount -= 1
                else:
                    insertions += 1
                if index < length - 1 and s[index + 1] == ")":
                    index += 2
                else:
                    insertions += 1
                    index += 1
        
        insertions += leftCount * 2
        return insertions
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。遍历字符串一次。

- 空间复杂度：$O(1)$。只需要维护常量的额外空间。