#### 方法一：双指针

**思路与算法**

首先题目给出神奇字符串 $s$ 的定义：

- 仅由 $1$ 和 $2$ 组成。
- 串联字符串中 $1$ 和 $2$ 的连续出现的次数可以生成该字符串。

并给出了字符串 $s$ 的前几个元素：$1221121221221121122 \dots$。现在要求求出 $s$ 的前 $n$ 个数字中 $1$ 的数目，$1 \le n \le 10^5$，那么我们可以按照定义来构造长度为 $n$ 的字符串 $s$，然后统计 $s$ 中 $1$ 的个数即可。那么如何通过现有的开头字符串来构造剩下的字符串呢——我们可以初始化字符串 $s = 122$，用指针 $i$ 来指向现在需要构造的对应的组的大小，用指针 $j$ 来指向现在需要构造的对应组的位置，此时 $i = 2$，$j = 3$。因为相邻组中的数字一定不会相同，所以我们可以通过 $j$ 的前一个位置的数来判断当前需要填入的组中的数字。又因为每组的大小只为 $1$ 或者 $2$，这保证了 $j > i$ 在构造的过程中一定成立，即在指针 $j$ 处填入组时一定能确定此时需要填入的组的大小。这样我们就可以不断往下进行构造直到字符串长度到达 $n$。

上述的过程中我们初始化字符串 $s = 122$，所以当 $n < 4$ 时我们无需再往下构造，此时直接返回 $1$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def magicalString(self, n: int) -> int:
        if n < 4:
            return 1
        s = [''] * n
        s[:3] = "122"
        res = 1
        i, j = 2, 3
        while j < n:
            size = int(s[i])
            num = 3 - int(s[j - 1])
            while size and j < n:
                s[j] = str(num)
                if num == 1:
                    res += 1
                j += 1
                size -= 1
            i += 1
        return res
```

```C++ [sol1-C++]
class Solution {
public:
    int magicalString(int n) {
        if (n < 4) {
            return 1;
        }
        string s(n, '0');
        s[0] = '1', s[1] = '2', s[2] = '2';
        int res = 1;
        int i = 2;
        int j = 3;
        while (j < n) {
            int size = s[i] - '0';
            int num = 3 - (s[j - 1] - '0');
            while (size > 0 && j < n) {
                s[j] = '0' + num;
                if (num == 1) {
                    ++res;
                }
                ++j;
                --size;
            }
            ++i;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int magicalString(int n) {
        if (n < 4) {
            return 1;
        }
        char[] s = new char[n];
        s[0] = '1';
        s[1] = '2';
        s[2] = '2';
        int res = 1;
        int i = 2;
        int j = 3;
        while (j < n) {
            int size = s[i] - '0';
            int num = 3 - (s[j - 1] - '0');
            while (size > 0 && j < n) {
                s[j] = (char) ('0' + num);
                if (num == 1) {
                    ++res;
                }
                ++j;
                --size;
            }
            ++i;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MagicalString(int n) {
        if (n < 4) {
            return 1;
        }
        char[] s = new char[n];
        s[0] = '1';
        s[1] = '2';
        s[2] = '2';
        int res = 1;
        int i = 2;
        int j = 3;
        while (j < n) {
            int size = s[i] - '0';
            int num = 3 - (s[j - 1] - '0');
            while (size > 0 && j < n) {
                s[j] = (char) ('0' + num);
                if (num == 1) {
                    ++res;
                }
                ++j;
                --size;
            }
            ++i;
        }
        return res;
    }
}
```

```C [sol1-C]
int magicalString(int n){
    if (n < 4) {
        return 1;
    }
    char s[n + 1];
    memset(s, '0', sizeof(s));
    s[0] = '1', s[1] = '2', s[2] = '2';
    int res = 1;
    int i = 2;
    int j = 3;
    while (j < n) {
        int size = s[i] - '0';
        int num = 3 - (s[j - 1] - '0');
        while (size > 0 && j < n) {
            s[j] = '0' + num;
            if (num == 1) {
                ++res;
            }
            ++j;
            --size;
        }
        ++i;
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var magicalString = function(n) {
    if (n < 4) {
        return 1;
    }
    const s = new Array(n).fill(0);
    s[0] = '1';
    s[1] = '2';
    s[2] = '2';
    let res = 1;
    let i = 2;
    let j = 3;
    while (j < n) {
        let size = s[i].charCodeAt() - '0'.charCodeAt();
        const num = 3 - (s[j - 1].charCodeAt() - '0'.charCodeAt());
        while (size > 0 && j < n) {
            s[j] = String.fromCharCode('0'.charCodeAt() + num);
            if (num === 1) {
                ++res;
            }
            ++j;
            --size;
        }
        ++i;
    }
    return res;
};
```

```go [sol1-Golang]
func magicalString(n int) int {
    if n < 4 {
        return 1
    }
    s := make([]byte, n)
    copy(s, "122")
    res := 1
    i, j := 2, 3
    for j < n {
        size := s[i] - '0'
        num := 3 - (s[j-1] - '0')
        for size > 0 && j < n {
            s[j] = '0' + num
            if num == 1 {
                res++
            }
            j++
            size--
        }
        i++
    }
    return res
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度。
- 空间复杂度：$O(n)$。需要构造长度为 $n$ 的字符串。