## [1629.按键持续时间最长的键 中文官方题解](https://leetcode.cn/problems/slowest-key/solutions/100000/an-jian-chi-xu-shi-jian-zui-chang-de-jia-yn7u)
#### 方法一：一次遍历

对于 $0 \le i < n$，第 $i$ 个按下的键是 $\textit{keysPressed}[i]$，按键持续时间是 $\textit{releaseTimes}[i] - \textit{releaseTimes}[i - 1]$，这里规定 $\textit{releaseTimes}[-1] = 0$，因为第 $0$ 个键在时间 $0$ 被按下。

为了得到按键持续时间最长的键，需要遍历 $\textit{keysPressed}$ 和 $\textit{releaseTimes}$，计算每个按键持续的时间并记录按键持续的最长时间和对应的按键。

为了避免处理下标越界问题，首先记录第 $0$ 个按键，按键持续时间是 $\textit{releaseTimes}[0]$，按下的键是 $\textit{keysPressed}[0]$，将其记为按键持续的最长时间和对应的按键。然后遍历其余的按键，对于每个按键，当以下两个条件之一成立时，使用当前按键更新按键持续的最长时间和对应的按键：

- 当前按键持续时间大于按键持续的最长时间；

- 当前按键持续时间等于按键持续的最长时间且当前按键大于按键持续时间最长的键。

遍历结束之后，即可得到按键持续时间最长的键。

```Java [sol1-Java]
class Solution {
    public char slowestKey(int[] releaseTimes, String keysPressed) {
        int n = releaseTimes.length;
        char ans = keysPressed.charAt(0);
        int maxTime = releaseTimes[0];
        for (int i = 1; i < n; i++) {
            char key = keysPressed.charAt(i);
            int time = releaseTimes[i] - releaseTimes[i - 1];
            if (time > maxTime || (time == maxTime && key > ans)) {
                ans = key;
                maxTime = time;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public char SlowestKey(int[] releaseTimes, string keysPressed) {
        int n = releaseTimes.Length;
        char ans = keysPressed[0];
        int maxTime = releaseTimes[0];
        for (int i = 1; i < n; i++) {
            char key = keysPressed[i];
            int time = releaseTimes[i] - releaseTimes[i - 1];
            if (time > maxTime || (time == maxTime && key > ans)) {
                ans = key;
                maxTime = time;
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    char slowestKey(vector<int>& releaseTimes, string keysPressed) {
        int n = releaseTimes.size();
        char ans = keysPressed[0];
        int maxTime = releaseTimes[0];
        for (int i = 1; i < n; i++) {
            char key = keysPressed[i];
            int time = releaseTimes[i] - releaseTimes[i - 1];
            if (time > maxTime || (time == maxTime && key > ans)) {
                ans = key;
                maxTime = time;
            }
        }
        return ans;
    }
};
```

```C [sol1-C]
char slowestKey(int* releaseTimes, int releaseTimesSize, char * keysPressed){
    char ans = keysPressed[0];
    int maxTime = releaseTimes[0];
    for (int i = 1; i < releaseTimesSize; i++) {
        char key = keysPressed[i];
        int time = releaseTimes[i] - releaseTimes[i - 1];
        if (time > maxTime || (time == maxTime && key > ans)) {
            ans = key;
            maxTime = time;
        }
    }
    return ans;
}
```

```go [sol1-Golang]
func slowestKey(releaseTimes []int, keysPressed string) byte {
    ans := keysPressed[0]
    maxTime := releaseTimes[0]
    for i := 1; i < len(keysPressed); i++ {
        key := keysPressed[i]
        time := releaseTimes[i] - releaseTimes[i-1]
        if time > maxTime || time == maxTime && key > ans {
            ans = key
            maxTime = time
        }
    }
    return ans
}
```

```Python [sol1-Python3]
class Solution:
    def slowestKey(self, releaseTimes: List[int], keysPressed: str) -> str:
        ans = keysPressed[0]
        maxTime = releaseTimes[0]
        for i in range(1, len(keysPressed)):
            key = keysPressed[i]
            time = releaseTimes[i] - releaseTimes[i - 1]
            if time > maxTime or time == maxTime and key > ans:
                ans = key
                maxTime = time
        return ans
```

```JavaScript [sol1-JavaScript]
var slowestKey = function(releaseTimes, keysPressed) {
    const n = releaseTimes.length;
    let ans = keysPressed[0];
    let maxTime = releaseTimes[0];
    for (let i = 1; i < n; i++) {
        const key = keysPressed[i];
        const time = releaseTimes[i] - releaseTimes[i - 1];
        if (time > maxTime || (time === maxTime && key > ans)) {
            ans = key;
            maxTime = time;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{releaseTimes}$ 和字符串 $\textit{keysPressed}$ 的长度。需要同时遍历数组和字符串一次。

- 空间复杂度：$O(1)$。