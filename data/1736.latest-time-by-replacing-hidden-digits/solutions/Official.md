## [1736.替换隐藏数字得到的最晚时间 中文官方题解](https://leetcode.cn/problems/latest-time-by-replacing-hidden-digits/solutions/100000/ti-huan-yin-cang-shu-zi-de-dao-de-zui-wa-0s7r)

#### 方法一：贪心

**思路与算法**

为了得到最晚有效时间，我们可以从高位向低位枚举，在保证时间有效的情况下，使得每一位尽可能取最大值。

因为本题中时间的位数较少，我们依次考虑每一位的规则即可。

- 第一位：若第二位的值已经确定，且值落在区间 $[4,9]$ 中时，第一位的值最大只能为 $1$，否则最大可以为 $2$；
- 第二位：若第一位的值已经确定，且值为 $2$ 时，第二位的值最大为 $3$，否则为 $9$；
- 第三位：第三位的值的选取与其它位无关，最大为 $5$；
- 第四位：第四位的值的选取与其它位无关，最大为 $9$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string maximumTime(string time) {
        if (time[0] == '?') {
            time[0] = ('4' <= time[1] && time[1] <= '9') ? '1' : '2';
        }
        if (time[1] == '?') {
            time[1] = (time[0] == '2') ? '3' : '9';
        }
        if (time[3] == '?') {
            time[3] = '5';
        }
        if (time[4] == '?') {
            time[4] = '9';
        }
        return time;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String maximumTime(String time) {
        char[] arr = time.toCharArray();
        if (arr[0] == '?') {
            arr[0] = ('4' <= arr[1] && arr[1] <= '9') ? '1' : '2';
        }
        if (arr[1] == '?') {
            arr[1] = (arr[0] == '2') ? '3' : '9';
        }
        if (arr[3] == '?') {
            arr[3] = '5';
        }
        if (arr[4] == '?') {
            arr[4] = '9';
        }
        return new String(arr);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string MaximumTime(string time) {
        char[] arr = time.ToCharArray();
        if (arr[0] == '?') {
            arr[0] = ('4' <= arr[1] && arr[1] <= '9') ? '1' : '2';
        }
        if (arr[1] == '?') {
            arr[1] = (arr[0] == '2') ? '3' : '9';
        }
        if (arr[3] == '?') {
            arr[3] = '5';
        }
        if (arr[4] == '?') {
            arr[4] = '9';
        }
        return new string(arr);
    }
}
```

```go [sol1-Golang]
func maximumTime(time string) string {
    t := []byte(time)
    if t[0] == '?' {
        if '4' <= t[1] && t[1] <= '9' {
            t[0] = '1'
        } else {
            t[0] = '2'
        }
    }
    if t[1] == '?' {
        if t[0] == '2' {
            t[1] = '3'
        } else {
            t[1] = '9'
        }
    }
    if t[3] == '?' {
        t[3] = '5'
    }
    if t[4] == '?' {
        t[4] = '9'
    }
    return string(t)
}
```

```C [sol1-C]
char* maximumTime(char* time) {
    if (time[0] == '?') {
        time[0] = ('4' <= time[1] && time[1] <= '9') ? '1' : '2';
    }
    if (time[1] == '?') {
        time[1] = (time[0] == '2') ? '3' : '9';
    }
    if (time[3] == '?') {
        time[3] = '5';
    }
    if (time[4] == '?') {
        time[4] = '9';
    }
    return time;
}
```

```JavaScript [sol1-JavaScript]
var maximumTime = function(time) {
    const arr = Array.from(time);
    if (arr[0] === '?') {
        arr[0] = ('4' <= arr[1] && arr[1] <= '9') ? '1' : '2';
    }
    if (arr[1] === '?') {
        arr[1] = (arr[0] == '2') ? '3' : '9';
    }
    if (arr[3] === '?') {
        arr[3] = '5';
    }
    if (arr[4] === '?') {
        arr[4] = '9';
    }
    return arr.join('');
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。