## [539.最小时间差 中文官方题解](https://leetcode.cn/problems/minimum-time-difference/solutions/100000/zui-xiao-shi-jian-chai-by-leetcode-solut-xolj)

#### 方法一：排序

将 $\textit{timePoints}$ 排序后，最小时间差必然出现在 $\textit{timePoints}$ 的两个相邻时间，或者 $\textit{timePoints}$ 的两个首尾时间中。因此排序后遍历一遍 $\textit{timePoints}$ 即可得到最小时间差。

```Python [sol1-Python3]
def getMinutes(t: str) -> int:
    return ((ord(t[0]) - ord('0')) * 10 + ord(t[1]) - ord('0')) * 60 + (ord(t[3]) - ord('0')) * 10 + ord(t[4]) - ord('0')

class Solution:
    def findMinDifference(self, timePoints: List[str]) -> int:
        timePoints.sort()
        ans = float('inf')
        t0Minutes = getMinutes(timePoints[0])
        preMinutes = t0Minutes
        for i in range(1, len(timePoints)):
            minutes = getMinutes(timePoints[i])
            ans = min(ans, minutes - preMinutes)  # 相邻时间的时间差
            preMinutes = minutes
        ans = min(ans, t0Minutes + 1440 - preMinutes)  # 首尾时间的时间差
        return ans
```

```C++ [sol1-C++]
class Solution {
    int getMinutes(string &t) {
        return (int(t[0] - '0') * 10 + int(t[1] - '0')) * 60 + int(t[3] - '0') * 10 + int(t[4] - '0');
    }

public:
    int findMinDifference(vector<string> &timePoints) {
        sort(timePoints.begin(), timePoints.end());
        int ans = INT_MAX;
        int t0Minutes = getMinutes(timePoints[0]);
        int preMinutes = t0Minutes;
        for (int i = 1; i < timePoints.size(); ++i) {
            int minutes = getMinutes(timePoints[i]);
            ans = min(ans, minutes - preMinutes); // 相邻时间的时间差
            preMinutes = minutes;
        }
        ans = min(ans, t0Minutes + 1440 - preMinutes); // 首尾时间的时间差
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findMinDifference(List<String> timePoints) {
        Collections.sort(timePoints);
        int ans = Integer.MAX_VALUE;
        int t0Minutes = getMinutes(timePoints.get(0));
        int preMinutes = t0Minutes;
        for (int i = 1; i < timePoints.size(); ++i) {
            int minutes = getMinutes(timePoints.get(i));
            ans = Math.min(ans, minutes - preMinutes); // 相邻时间的时间差
            preMinutes = minutes;
        }
        ans = Math.min(ans, t0Minutes + 1440 - preMinutes); // 首尾时间的时间差
        return ans;
    }

    public int getMinutes(String t) {
        return ((t.charAt(0) - '0') * 10 + (t.charAt(1) - '0')) * 60 + (t.charAt(3) - '0') * 10 + (t.charAt(4) - '0');
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindMinDifference(IList<string> timePoints) {
        timePoints = timePoints.OrderBy(x => x).ToList();
        int ans = int.MaxValue;
        int t0Minutes = getMinutes(timePoints[0]);
        int preMinutes = t0Minutes;
        for (int i = 1; i < timePoints.Count; ++i) {
            int minutes = getMinutes(timePoints[i]);
            ans = Math.Min(ans, minutes - preMinutes); // 相邻时间的时间差
            preMinutes = minutes;
        }
        ans = Math.Min(ans, t0Minutes + 1440 - preMinutes); // 首尾时间的时间差
        return ans;
    }

    public int getMinutes(string t) {
        return ((t[0] - '0') * 10 + (t[1] - '0')) * 60 + (t[3] - '0') * 10 + (t[4] - '0');
    }
}
```

```go [sol1-Golang]
func getMinutes(t string) int {
    return (int(t[0]-'0')*10+int(t[1]-'0'))*60 + int(t[3]-'0')*10 + int(t[4]-'0')
}

func findMinDifference(timePoints []string) int {
    sort.Strings(timePoints)
    ans := math.MaxInt32
    t0Minutes := getMinutes(timePoints[0])
    preMinutes := t0Minutes
    for _, t := range timePoints[1:] {
        minutes := getMinutes(t)
        ans = min(ans, minutes-preMinutes) // 相邻时间的时间差
        preMinutes = minutes
    }
    ans = min(ans, t0Minutes+1440-preMinutes) // 首尾时间的时间差
    return ans
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int getMinutes(const char * t) {
    return ((t[0] - '0') * 10 + (t[1] - '0')) * 60 + (t[3] - '0') * 10 + (t[4] - '0');
}

int cmp(const void * pa, const void * pb) {
    return strcmp(*(char **)pa, *(char **)pb);
}

int findMinDifference(char ** timePoints, int timePointsSize) {
    qsort(timePoints, timePointsSize, sizeof(char *), cmp);
    int ans = 1440;
    int t0Minutes = getMinutes(timePoints[0]);
    int preMinutes = t0Minutes;
    for (int i = 1; i < timePointsSize; ++i) {
        int minutes = getMinutes(timePoints[i]);
        ans = MIN(ans, minutes - preMinutes); // 相邻时间的时间差
        preMinutes = minutes;
    }
    ans = MIN(ans, t0Minutes + 1440 - preMinutes); // 首尾时间的时间差
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var findMinDifference = function(timePoints) {
    timePoints.sort();
    let ans = Number.MAX_VALUE;
    let t0Minutes = getMinutes(timePoints[0]);
    let preMinutes = t0Minutes;
    for (let i = 1; i < timePoints.length; ++i) {
        const minutes = getMinutes(timePoints[i]);
        ans = Math.min(ans, minutes - preMinutes); // 相邻时间的时间差
        preMinutes = minutes;
    }
    ans = Math.min(ans, t0Minutes + 1440 - preMinutes); // 首尾时间的时间差
    return ans;
};

const getMinutes = (t) => {
    return ((t[0].charCodeAt() - '0'.charCodeAt()) * 10 + (t[1].charCodeAt() - '0'.charCodeAt())) * 60 + (t[3].charCodeAt() - '0'.charCodeAt()) * 10 + (t[4].charCodeAt() - '0'.charCodeAt());
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是数组 $\textit{timePoints}$ 的长度。排序需要 $O(n\log n)$ 的时间。

- 空间复杂度：$O(n)$ 或 $O(\log n)$。为排序需要的空间，取决于具体语言的实现。

#### 方法二：鸽巢原理

根据题意，一共有 $24 \times 60=1440$ 种不同的时间。由鸽巢原理可知，如果 $\textit{timePoints}$ 的长度超过 $1440$，那么必然会有两个相同的时间，此时可以直接返回 $0$。

```Python [sol2-Python3]
def getMinutes(t: str) -> int:
    return ((ord(t[0]) - ord('0')) * 10 + ord(t[1]) - ord('0')) * 60 + (ord(t[3]) - ord('0')) * 10 + ord(t[4]) - ord('0')

class Solution:
    def findMinDifference(self, timePoints: List[str]) -> int:
        n = len(timePoints)
        if n > 1440:
            return 0
        timePoints.sort()
        ans = float('inf')
        t0Minutes = getMinutes(timePoints[0])
        preMinutes = t0Minutes
        for i in range(1, n):
            minutes = getMinutes(timePoints[i])
            ans = min(ans, minutes - preMinutes)  # 相邻时间的时间差
            preMinutes = minutes
        ans = min(ans, t0Minutes + 1440 - preMinutes)  # 首尾时间的时间差
        return ans
```

```C++ [sol2-C++]
class Solution {
    int getMinutes(string &t) {
        return (int(t[0] - '0') * 10 + int(t[1] - '0')) * 60 + int(t[3] - '0') * 10 + int(t[4] - '0');
    }

public:
    int findMinDifference(vector<string> &timePoints) {
        int n = timePoints.size();
        if (n > 1440) {
            return 0;
        }
        sort(timePoints.begin(), timePoints.end());
        int ans = INT_MAX;
        int t0Minutes = getMinutes(timePoints[0]);
        int preMinutes = t0Minutes;
        for (int i = 1; i < n; ++i) {
            int minutes = getMinutes(timePoints[i]);
            ans = min(ans, minutes - preMinutes); // 相邻时间的时间差
            preMinutes = minutes;
        }
        ans = min(ans, t0Minutes + 1440 - preMinutes); // 首尾时间的时间差
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int findMinDifference(List<String> timePoints) {
        int n = timePoints.size();
        if (n > 1440) {
            return 0;
        }
        Collections.sort(timePoints);
        int ans = Integer.MAX_VALUE;
        int t0Minutes = getMinutes(timePoints.get(0));
        int preMinutes = t0Minutes;
        for (int i = 1; i < n; ++i) {
            int minutes = getMinutes(timePoints.get(i));
            ans = Math.min(ans, minutes - preMinutes); // 相邻时间的时间差
            preMinutes = minutes;
        }
        ans = Math.min(ans, t0Minutes + 1440 - preMinutes); // 首尾时间的时间差
        return ans;
    }

    public int getMinutes(String t) {
        return ((t.charAt(0) - '0') * 10 + (t.charAt(1) - '0')) * 60 + (t.charAt(3) - '0') * 10 + (t.charAt(4) - '0');
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int FindMinDifference(IList<string> timePoints) {
        int n = timePoints.Count;
        if (n > 1440) {
            return 0;
        }
        timePoints = timePoints.OrderBy(x => x).ToList();
        int ans = int.MaxValue;
        int t0Minutes = getMinutes(timePoints[0]);
        int preMinutes = t0Minutes;
        for (int i = 1; i < n; ++i) {
            int minutes = getMinutes(timePoints[i]);
            ans = Math.Min(ans, minutes - preMinutes); // 相邻时间的时间差
            preMinutes = minutes;
        }
        ans = Math.Min(ans, t0Minutes + 1440 - preMinutes); // 首尾时间的时间差
        return ans;
    }

    public int getMinutes(string t) {
        return ((t[0] - '0') * 10 + (t[1] - '0')) * 60 + (t[3] - '0') * 10 + (t[4] - '0');
    }
}
```

```go [sol2-Golang]
func getMinutes(t string) int {
    return (int(t[0]-'0')*10+int(t[1]-'0'))*60 + int(t[3]-'0')*10 + int(t[4]-'0')
}

func findMinDifference(timePoints []string) int {
    if len(timePoints) > 1440 {
        return 0
    }
    sort.Strings(timePoints)
    ans := math.MaxInt32
    t0Minutes := getMinutes(timePoints[0])
    preMinutes := t0Minutes
    for _, t := range timePoints[1:] {
        minutes := getMinutes(t)
        ans = min(ans, minutes-preMinutes) // 相邻时间的时间差
        preMinutes = minutes
    }
    ans = min(ans, t0Minutes+1440-preMinutes) // 首尾时间的时间差
    return ans
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```C [sol2-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int getMinutes(const char * t) {
    return ((t[0] - '0') * 10 + (t[1] - '0')) * 60 + (t[3] - '0') * 10 + (t[4] - '0');
}

int cmp(const void * pa, const void * pb) {
    return strcmp(*(char **)pa, *(char **)pb);
}

int findMinDifference(char ** timePoints, int timePointsSize) {
    if (timePointsSize > 1440) {
        return 0;
    }
    qsort(timePoints, timePointsSize, sizeof(char *), cmp);
    int ans = 1440;
    int t0Minutes = getMinutes(timePoints[0]);
    int preMinutes = t0Minutes;
    for (int i = 1; i < timePointsSize; ++i) {
        int minutes = getMinutes(timePoints[i]);
        ans = MIN(ans, minutes - preMinutes); // 相邻时间的时间差
        preMinutes = minutes;
    }
    ans = MIN(ans, t0Minutes + 1440 - preMinutes); // 首尾时间的时间差
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var findMinDifference = function(timePoints) {
    const n = timePoints.length;
    if (n > 1440) {
        return 0;
    }
    timePoints.sort();
    let ans = Number.MAX_VALUE;
    let t0Minutes = getMinutes(timePoints[0]);
    let preMinutes = t0Minutes;
    for (let i = 1; i < n; ++i) {
        const minutes = getMinutes(timePoints[i]);
        ans = Math.min(ans, minutes - preMinutes); // 相邻时间的时间差
        preMinutes = minutes;
    }
    ans = Math.min(ans, t0Minutes + 1440 - preMinutes); // 首尾时间的时间差
    return ans;
};

const getMinutes = (t) => {
    return ((t[0].charCodeAt() - '0'.charCodeAt()) * 10 + (t[1].charCodeAt() - '0'.charCodeAt())) * 60 + (t[3].charCodeAt() - '0'.charCodeAt()) * 10 + (t[4].charCodeAt() - '0'.charCodeAt());
}
```

**复杂度分析**

- 时间复杂度：$O(\min(n,C)\log\min(n,C))$，其中 $n$ 是数组 $\textit{timePoints}$ 的长度，$C=24 \times 60=1440$。由于当 $n>C$ 时直接返回 $0$，排序时的 $n$ 不会超过 $C$，因此排序需要 $O(\min(n,C)\log\min(n,C))$ 的时间。

- 空间复杂度：$O(\min(n,C))$ 或 $O(\log\min(n,C))$。为排序需要的空间，取决于具体语言的实现。