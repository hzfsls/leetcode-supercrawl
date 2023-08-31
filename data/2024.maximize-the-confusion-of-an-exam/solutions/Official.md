## [2024.考试的最大困扰度 中文官方题解](https://leetcode.cn/problems/maximize-the-confusion-of-an-exam/solutions/100000/kao-shi-de-zui-da-kun-rao-du-by-leetcode-qub5)
#### 方法一：滑动窗口

**思路和算法**

只要求最大连续指定字符的数目时，本题和「[1004. 最大连续1的个数 III](https://leetcode-cn.com/problems/max-consecutive-ones-iii/)」完全一致。

在指定字符的情况下，我们可以计算其最大连续数目。具体地，我们使用滑动窗口的方法，从左到右枚举右端点，维护区间中另一种字符的数量为 $\textit{sum}$，当 $\textit{sum}$ 超过 $k$，我们需要让左端点右移，直到 $\textit{sum} \leq k$。移动过程中，我们记录滑动窗口的最大长度，即为指定字符的最大连续数目。

本题的答案为分别指定字符为 $T$ 和 $F$ 时的最大连续数目的较大值。

**代码**

```Python [sol1-Python3]
class Solution:
    def maxConsecutiveAnswers(self, answerKey: str, k: int) -> int:
        def maxConsecutiveChar(ch: str) -> int:
            ans, left, sum = 0, 0, 0
            for right in range(len(answerKey)):
                sum += answerKey[right] != ch
                while sum > k:
                    sum -= answerKey[left] != ch
                    left += 1
                ans = max(ans, right - left + 1)
            return ans
        return max(maxConsecutiveChar('T'), maxConsecutiveChar('F'))
```

```C++ [sol1-C++]
class Solution {
public:
    int maxConsecutiveChar(string& answerKey, int k, char ch) {
        int n = answerKey.length();
        int ans = 0;
        for (int left = 0, right = 0, sum = 0; right < n; right++) {
            sum += answerKey[right] != ch;
            while (sum > k) {
                sum -= answerKey[left++] != ch;
            }
            ans = max(ans, right - left + 1);
        }
        return ans;
    }

    int maxConsecutiveAnswers(string answerKey, int k) {
        return max(maxConsecutiveChar(answerKey, k, 'T'),
                   maxConsecutiveChar(answerKey, k, 'F'));
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxConsecutiveAnswers(String answerKey, int k) {
        return Math.max(maxConsecutiveChar(answerKey, k, 'T'), maxConsecutiveChar(answerKey, k, 'F'));
    }

    public int maxConsecutiveChar(String answerKey, int k, char ch) {
        int n = answerKey.length();
        int ans = 0;
        for (int left = 0, right = 0, sum = 0; right < n; right++) {
            sum += answerKey.charAt(right) != ch ? 1 : 0;
            while (sum > k) {
                sum -= answerKey.charAt(left++) != ch ? 1 : 0;
            }
            ans = Math.max(ans, right - left + 1);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxConsecutiveAnswers(string answerKey, int k) {
        return Math.Max(MaxConsecutiveChar(answerKey, k, 'T'), MaxConsecutiveChar(answerKey, k, 'F'));
    }

    public int MaxConsecutiveChar(string answerKey, int k, char ch) {
        int n = answerKey.Length;
        int ans = 0;
        for (int left = 0, right = 0, sum = 0; right < n; right++) {
            sum += answerKey[right] != ch ? 1 : 0;
            while (sum > k) {
                sum -= answerKey[left++] != ch ? 1 : 0;
            }
            ans = Math.Max(ans, right - left + 1);
        }
        return ans;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxConsecutiveChar(const char * answerKey, int k, char ch) {
    int n = strlen(answerKey);
    int ans = 0;
    for (int left = 0, right = 0, sum = 0; right < n; right++) {
        sum += answerKey[right] != ch;
        while (sum > k) {
            sum -= answerKey[left++] != ch;
        }
        ans = MAX(ans, right - left + 1);
    }
    return ans;
}

int maxConsecutiveAnswers(char * answerKey, int k) {
    int cnt1 = maxConsecutiveChar(answerKey, k, 'T');
    int cnt2 = maxConsecutiveChar(answerKey, k, 'F');
    return MAX(cnt1, cnt2);
}
```

```JavaScript [sol1-JavaScript]
var maxConsecutiveAnswers = function(answerKey, k) {
    return Math.max(maxConsecutiveChar(answerKey, k, 'T'), maxConsecutiveChar(answerKey, k, 'F'));
}

const maxConsecutiveChar = (answerKey, k, ch) => {
    const n = answerKey.length;
    let ans = 0;
    for (let left = 0, right = 0, sum = 0; right < n; right++) {
        sum += answerKey.charAt(right) !== ch ? 1 : 0;
        while (sum > k) {
            sum -= answerKey[left++] !== ch ? 1 : 0;
        }
        ans = Math.max(ans, right - left + 1);
    }
    return ans;
};
```

```go [sol1-Golang]
func maxConsecutiveChar(answerKey string, k int, ch byte) (ans int) {
    left, sum := 0, 0
    for right := range answerKey {
        if answerKey[right] != ch {
            sum++
        }
        for sum > k {
            if answerKey[left] != ch {
                sum--
            }
            left++
        }
        ans = max(ans, right-left+1)
    }
    return
}

func maxConsecutiveAnswers(answerKey string, k int) int {
    return max(maxConsecutiveChar(answerKey, k, 'T'),
               maxConsecutiveChar(answerKey, k, 'F'))
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串长度，我们只需要遍历该字符串两次。

- 空间复杂度：$O(1)$，我们只需要常数的空间保存若干变量。