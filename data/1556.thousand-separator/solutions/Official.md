## [1556.千位分隔数 中文官方题解](https://leetcode.cn/problems/thousand-separator/solutions/100000/qian-wei-fen-ge-shu-by-leetcode-solution)
#### 方法一：模拟

**思路与算法**

我们需要把 $n$ 从低位向高位遍历，每三位加一个分隔符。

我们可以借鉴数位分离的方法从低位向高位遍历，即对于十进制数 $n$，每次取出 $n$ 的最后一位，然后把 $n$ 整除 $10$，得到该数除去最后数字以外的部分。每次我们把取出的这个数字加入到一个字符串的末尾，用一个计数器记录当前已经分离出的数位的个数，如果它是 $3$ 的倍数并且当前的 $n$ 大于 $0$，就在字符串末尾加分隔符。最后我们把这个字符串反转就可以得到答案。

例如数字 $123456789$，经过数位分离后得到的字符串为 $987.654.321$，反转后为 $123.456.789$。这里也可以看出为什么需要当前的 $n$ 大于 $0$ 才能在字符串末尾加分隔符，如果不判断这个条件，分离后的字符串就是 $987.654.321.$，反转后得到 $.123.456.789$，最前面的分隔符显然是多余的。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    string thousandSeparator(int n) {
        int count = 0;
        string ans;
        do {
            int cur = n % 10;
            n /= 10;
            ans += to_string(cur);
            ++count;
            if (count % 3 == 0 && n) {
                ans += '.';
            }
        } while (n);
        reverse(ans.begin(), ans.end());
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String thousandSeparator(int n) {
        int count = 0;
        StringBuffer ans = new StringBuffer();
        do {
            int cur = n % 10;
            n /= 10;
            ans.append(cur);
            ++count;
            if (count % 3 == 0 && n != 0) {
                ans.append('.');
            }
        } while (n != 0);
        ans.reverse();
        return ans.toString();
    }
}
```

```JavaScript [sol1-JavaScript]
var thousandSeparator = function(n) {
    let count = 0;
    let ans = "";
    do {
        let cur = n % 10;
        n = Math.floor(n / 10);
        ans += cur.toString();
        ++count;
        if (count % 3 == 0 && n) {
            ans += '.';
        }
    } while (n);
    return ans.split('').reverse().join('');
};
```

```Python [sol1-Python3]
class Solution:
    def thousandSeparator(self, n: int) -> str:
        count = 0
        ans = list()
        while True:
            cur = n % 10
            n //= 10
            ans.append(str(cur))
            count += 1
            if count % 3 == 0 and n > 0:
                ans.append(".")
            if n == 0:
                break
        return "".join(ans[::-1])
```

**复杂度分析**

+ 时间复杂度：$O(\log n)$。
+ 空间复杂度：$O(\log n)$。