#### 方法一：回溯

**思路与算法**

由于字符串 $\textit{time}$ 中的 $\text{`?'}$ 可以被 $\text{`0'}$ 到 $\text{`9'}$ 中的任意字符替换，则依次尝试将字符串中的每个 $\text{`?'}$ 替换为 $\text{`0'}$ 到 $\text{`9'}$ 后，并检测该时间的合法性即可，此时合法的时间需要满足如下:
+ $\text{“00"} \le \text{hh} \le \text{“23"}$；
+ $\text{“00"} \le \text{mm} \le \text{“59"}$；
统计合法的时间数目并返回即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool check(const string &time) {
        int hh = stoi(time);
        int mm = stoi(time.substr(3));
        if (hh < 24 && mm < 60) {
            return true;
        } else {
            return false;
        }
    }

    int countTime(string time) {
        int res = 0;
        function<void(int)> dfs = [&](int pos) {
            if (pos == time.size()) {
                if (check(time)) {
                    res++;
                }
                return;
            }
            if (time[pos] == '?') {
                for (int i = 0; i <= 9; i++) {
                    time[pos] = '0' + i;
                    dfs(pos + 1);
                    time[pos] = '?';
                }
            } else {
                dfs(pos + 1);
            }
        };
        dfs(0);
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    int res = 0;

    public int countTime(String time) {
        char[] arr = time.toCharArray();
        dfs(arr, 0);
        return res;
    }

    public void dfs(char[] arr, int pos) {
        if (pos == arr.length) {
            if (check(arr)) {
                res++;
            }
            return;
        }
        if (arr[pos] == '?') {
            for (int i = 0; i <= 9; i++) {
                arr[pos] = (char) ('0' + i);
                dfs(arr, pos + 1);
                arr[pos] = '?';
            }
        } else {
            dfs(arr, pos + 1);
        }
    }

    public boolean check(char[] arr) {
        int hh = (arr[0] - '0') * 10 + arr[1] - '0';
        int mm = (arr[3] - '0') * 10 + arr[4] - '0';
        return hh < 24 && mm < 60;
    }
}
```

```C# [sol1-C#]
public class Solution {
    int res = 0;

    public int CountTime(string time) {
        char[] arr = time.ToCharArray();
        DFS(arr, 0);
        return res;
    }

    public void DFS(char[] arr, int pos) {
        if (pos == arr.Length) {
            if (Check(arr)) {
                res++;
            }
            return;
        }
        if (arr[pos] == '?') {
            for (int i = 0; i <= 9; i++) {
                arr[pos] = (char) ('0' + i);
                DFS(arr, pos + 1);
                arr[pos] = '?';
            }
        } else {
            DFS(arr, pos + 1);
        }
    }

    public bool Check(char[] arr) {
        int hh = (arr[0] - '0') * 10 + arr[1] - '0';
        int mm = (arr[3] - '0') * 10 + arr[4] - '0';
        return hh < 24 && mm < 60;
    }
}
```

```C [sol1-C]
bool check(const char *time) {
    int hh = atoi(time);
    int mm = atoi(time + 3);
    if (hh < 24 && mm < 60) {
        return true;
    } else {
        return false;
    }
}

void dfs(char *time, int pos, int *res) {
    if (time[pos] == '\0') {
        if (check(time)) {
            (*res)++;
        }
        return;
    }
    if (time[pos] == '?') {
        for (int i = 0; i <= 9; i++) {
            time[pos] = '0' + i;
            dfs(time, pos + 1, res);
            time[pos] = '?';
        }
    } else {
        dfs(time, pos + 1, res);
    }
}

int countTime(char * time){
    int res = 0;
    dfs(time, 0, &res);
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(|\Sigma|^4)$，其中 $|\Sigma|$ 表示字符集的大小，在此字符 $|\Sigma| = 10$。我们依次枚举 $\text{`?'}$ 所有替换数字的方案，最多替换替换 $4$ 个 $\text{`?'}$，因此时间复杂度为 $O(|\Sigma|^4)$。

- 空间复杂度：$O(1)$。由于题目给定数目的现在，递归深度最多为 $4$，因此空间复杂度为 $O(1)$。 

#### 方法二：分开枚举

**思路与算法**

由于题目中小时和分钟的限制不同，因此没有必要枚举所有可能的数字，由于小时和分钟限制如下：
+ $\text{“00"} \le \text{hh} \le \text{“23"}$；
+ $\text{“00"} \le \text{mm} \le \text{“59"}$；

我们检测所有符合当前字符串 $\textit{time}$ 匹配的小时 $\text{hh}$ 的数目为 $\textit{countHour}$，同时检测检测所有符合当前字符串 $\textit{time}$ 匹配的分钟 $\text{hh}$ 的数目为 $\textit{countMinute}$，则合法有效的时间数目为 $\textit{countHour} \times \textit{countMinute}$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int countTime(string time) {
        int countHour = 0;
        int countMinute = 0;
        for (int i = 0; i < 24; i++) {
            int hiHour = i / 10;
            int loHour = i % 10;
            if ((time[0] == '?' || time[0] == hiHour + '0') && 
                (time[1] == '?' || time[1] == loHour + '0')) {
                countHour++;
            }
        } 
        for (int i = 0; i < 60; i++) {
            int hiMinute = i / 10;
            int loMinute = i % 10;
            if ((time[3] == '?' || time[3] == hiMinute + '0') && 
                (time[4] == '?' || time[4] == loMinute + '0')) {
                countMinute++;
            }
        }
        return countHour * countMinute;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int countTime(String time) {
        int countHour = 0;
        int countMinute = 0;
        for (int i = 0; i < 24; i++) {
            int hiHour = i / 10;
            int loHour = i % 10;
            if ((time.charAt(0) == '?' || time.charAt(0) == hiHour + '0') && 
                (time.charAt(1) == '?' || time.charAt(1) == loHour + '0')) {
                countHour++;
            }
        } 
        for (int i = 0; i < 60; i++) {
            int hiMinute = i / 10;
            int loMinute = i % 10;
            if ((time.charAt(3) == '?' || time.charAt(3) == hiMinute + '0') && 
                (time.charAt(4) == '?' || time.charAt(4) == loMinute + '0')) {
                countMinute++;
            }
        }
        return countHour * countMinute;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int CountTime(string time) {
        int countHour = 0;
        int countMinute = 0;
        for (int i = 0; i < 24; i++) {
            int hiHour = i / 10;
            int loHour = i % 10;
            if ((time[0] == '?' || time[0] == hiHour + '0') && 
                (time[1] == '?' || time[1] == loHour + '0')) {
                countHour++;
            }
        } 
        for (int i = 0; i < 60; i++) {
            int hiMinute = i / 10;
            int loMinute = i % 10;
            if ((time[3] == '?' || time[3] == hiMinute + '0') && 
                (time[4] == '?' || time[4] == loMinute + '0')) {
                countMinute++;
            }
        }
        return countHour * countMinute;
    }
}
```

```C [sol2-C]
int countTime(char * time) {
    int countHour = 0;
    int countMinute = 0;
    for (int i = 0; i < 24; i++) {
        int hiHour = i / 10;
        int loHour = i % 10;
        if ((time[0] == '?' || time[0] == hiHour + '0') && 
            (time[1] == '?' || time[1] == loHour + '0')) {
            countHour++;
        }
    } 
    for (int i = 0; i < 60; i++) {
        int hiMinute = i / 10;
        int loMinute = i % 10;
        if ((time[3] == '?' || time[3] == hiMinute + '0') && 
            (time[4] == '?' || time[4] == loMinute + '0')) {
            countMinute++;
        }
    }
    return countHour * countMinute;
}
```

```Python [sol2-Python3]
class Solution:
    def countTime(self, time: str) -> int:
        countHour = 0
        countMinute = 0
        for i in range(24):
            hiHour = i // 10
            loHour = i % 10
            if ((time[0] == '?' or int(time[0]) == hiHour) and
                    (time[1] == '?' or int(time[1]) == loHour)):
                countHour += 1

        for i in range(60):
            hiMinute = i // 10
            loMinute = i % 10
            if ((time[3] == '?' or int(time[3]) == hiMinute) and
                    (time[4] == '?' or int(time[4]) == loMinute)):
                countMinute += 1

        return countHour * countMinute
```

```JavaScript [sol2-JavaScript]
var countTime = function(time) {
    let res = 0;
        const dfs = (arr, pos) => {
        if (pos === arr.length) {
            if (check(arr)) {
                res++;
            }
            return;
        }
        if (arr[pos] === '?') {
            for (let i = 0; i <= 9; i++) {
                arr[pos] = String.fromCharCode('0'.charCodeAt() + i);
                dfs(arr, pos + 1);
                arr[pos] = '?';
            }
        } else {
            dfs(arr, pos + 1);
        }
    }

    const check = (arr) => {
        const hh = (arr[0].charCodeAt() - '0'.charCodeAt()) * 10 + arr[1].charCodeAt() - '0'.charCodeAt();
        const mm = (arr[3].charCodeAt() - '0'.charCodeAt()) * 10 + arr[4].charCodeAt() - '0'.charCodeAt();
        return hh < 24 && mm < 60;
    };
    const arr = [...time];
    dfs(arr, 0);
    return res;
}
```

```go [sol2-Golang]
func countTime(time string) int {
    countHour := 0
    countMinute := 0
    for i := 0; i < 24; i++ {
        hiHour := byte(i / 10)
        loHour := byte(i % 10)
        if (time[0] == '?' || time[0] == hiHour+'0') &&
            (time[1] == '?' || time[1] == loHour+'0') {
            countHour++
        }
    }
    for i := 0; i < 60; i++ {
        hiMinute := byte(i / 10)
        loMinute := byte(i % 10)
        if (time[3] == '?' || time[3] == hiMinute+'0') &&
            (time[4] == '?' || time[4] == loMinute+'0') {
            countMinute++
        }
    }
    return countHour * countMinute
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。由于时钟的最大值为 $24$，分钟的最大值为 $60$，在此题解中分别枚举所可能的时钟，以及所有可能分钟，时间复杂度为 $O(24 + 60) = O(1)$。

- 空间复杂度：$O(1)$。