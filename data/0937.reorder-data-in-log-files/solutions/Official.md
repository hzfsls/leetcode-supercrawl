## [937.重新排列日志文件 中文官方题解](https://leetcode.cn/problems/reorder-data-in-log-files/solutions/100000/zhong-xin-pai-lie-ri-zhi-wen-jian-by-lee-egtm)
#### 方法一：自定义排序

**思路**

根据题意自定义排序的比较方式。比较时，先将数组日志按照第一个空格分成两部分字符串，其中第一部分为标识符。第二部分的首字符可以用来判断该日志的类型。两条日志进行比较时，需要先确定待比较的日志的类型，然后按照以下规则进行比较：
- 字母日志始终小于数字日志。
- 数字日志保留原来的相对顺序。当使用稳定的排序算法时，可以认为所有数字日志大小一样。当使用不稳定的排序算法时，可以用日志在原数组中的下标进行比较。
- 字母日志进行相互比较时，先比较第二部分的大小；如果相等，则比较标识符大小。比较时都使用字符串的比较方式进行比较。

定义比较函数 $\textit{logCompare}$ 时，有两个输入 $\textit{log}_1$ 和 $\textit{log}_2$ 。当相等时，返回 $0$；当 $\textit{log}_1$ 大时，返回正数；当 $\textit{log}_2$ 大时，返回负数。

**代码**

```Python [sol1-Python3]
class Solution:
    def reorderLogFiles(self, logs: List[str]) -> List[str]:
        def trans(log: str) -> tuple:
            a, b = log.split(' ', 1)
            return (0, b, a) if b[0].isalpha() else (1,)

        logs.sort(key=trans)  # sort 是稳定排序
        return logs
```

```Java [sol1-Java]
class Solution {
    public String[] reorderLogFiles(String[] logs) {
        int length = logs.length;
        Pair[] arr = new Pair[length];
        for (int i = 0; i < length; i++) {
            arr[i] = new Pair(logs[i], i);
        }
        Arrays.sort(arr, (a, b) -> logCompare(a, b));
        String[] reordered = new String[length];
        for (int i = 0; i < length; i++) {
            reordered[i] = arr[i].log;
        }
        return reordered;
    }

    public int logCompare(Pair pair1, Pair pair2) {
        String log1 = pair1.log, log2 = pair2.log;
        int index1 = pair1.index, index2 = pair2.index;
        String[] split1 = log1.split(" ", 2);
        String[] split2 = log2.split(" ", 2);
        boolean isDigit1 = Character.isDigit(split1[1].charAt(0));
        boolean isDigit2 = Character.isDigit(split2[1].charAt(0));
        if (isDigit1 && isDigit2) {
            return index1 - index2;
        }
        if (!isDigit1 && !isDigit2) {
            int sc = split1[1].compareTo(split2[1]);
            if (sc != 0) {
                return sc;
            }
            return split1[0].compareTo(split2[0]);
        }
        return isDigit1 ? 1 : -1;
    }
}

class Pair {
    String log;
    int index;

    public Pair(String log, int index) {
        this.log = log;
        this.index = index;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string[] ReorderLogFiles(string[] logs) {
        int length = logs.Length;
        Pair[] arr = new Pair[length];
        for (int i = 0; i < length; i++) {
            arr[i] = new Pair(logs[i], i);
        }
        Array.Sort(arr, (a, b) => LogCompare(a, b));
        string[] reordered = new string[length];
        for (int i = 0; i < length; i++) {
            reordered[i] = arr[i].log;
        }
        return reordered;
    }

    public int LogCompare(Pair pair1, Pair pair2) {
        string log1 = pair1.log, log2 = pair2.log;
        int index1 = pair1.index, index2 = pair2.index;
        string[] split1 = log1.Split(" ", 2);
        string[] split2 = log2.Split(" ", 2);
        bool isDigit1 = char.IsDigit(split1[1][0]);
        bool isDigit2 = char.IsDigit(split2[1][0]);
        if (isDigit1 && isDigit2) {
            return index1 - index2;
        }
        if (!isDigit1 && !isDigit2) {
            int sc = split1[1].CompareTo(split2[1]);
            if (sc != 0) {
                return sc;
            }
            return split1[0].CompareTo(split2[0]);
        }
        return isDigit1 ? 1 : -1;
    }
}

public class Pair {
    public string log;
    public int index;

    public Pair(string log, int index) {
        this.log = log;
        this.index = index;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> reorderLogFiles(vector<string>& logs) {
        stable_sort(logs.begin(), logs.end(), [&](const string & log1, const string & log2) {
            int pos1 = log1.find_first_of(" ");
            int pos2 = log2.find_first_of(" ");
            bool isDigit1 = isdigit(log1[pos1 + 1]);
            bool isDigit2 = isdigit(log2[pos2 + 1]);
            if (isDigit1 && isDigit2) {
                return false;
            }
            if (!isDigit1 && !isDigit2) {
                string s1 = log1.substr(pos1);
                string s2 = log2.substr(pos2);
                if (s1 != s2) {
                    return s1 < s2;
                }
                return log1 < log2;
            }
            return isDigit1 ? false : true;
        });
        return logs;
    }
};
```

```C [sol1-C]
struct Pair {
    char * log;
    int idx;
};

int logCompare(const void *log1, const void *log2) {
    char *s1 = ((struct Pair *)log1)->log;
    char *s2 = ((struct Pair *)log2)->log;
    char *split1 = strstr(s1, " ");
    char *split2 = strstr(s2, " ");
    bool isDigit1 = isdigit(split1[1]);
    bool isDigit2 = isdigit(split2[1]);
    if (isDigit1 && isDigit2) {
        return ((struct Pair *)log1)->idx - ((struct Pair *)log2)->idx;
    }
    if (!isDigit1 && !isDigit2) {
        int sc = strcmp(split1, split2);
        if (sc != 0) {
            return sc;
        }
        return strcmp(s1, s2);
    }
    return isDigit1 ? 1 : -1;
}

char ** reorderLogFiles(char ** logs, int logsSize, int* returnSize){
    struct Pair * arr = (struct Pair *)malloc(sizeof(struct Pair) * logsSize);
    for (int i = 0; i < logsSize; i++) {
        arr[i].log = logs[i];
        arr[i].idx = i;
    }
    qsort(arr, logsSize, sizeof(struct Pair), logCompare);
    char ** ans = (char **)malloc(sizeof(char *) * logsSize);
    for (int i = 0; i < logsSize; i++) {
        ans[i] = arr[i].log;
    }
    *returnSize = logsSize;
    free(arr);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var reorderLogFiles = function(logs) {
    const length = logs.length;
    const arr = new Array(length).fill(0);
    for (let i = 0; i < length; i++) {
        arr[i] = [logs[i], i];
    }
    arr.sort((a, b) => logCompare(a, b));
    const reordered = new Array(length).fill(0);
    for (let i = 0; i < length; i++) {
        reordered[i] = arr[i][0];
    }
    return reordered;
}

const logCompare = (log1, log2) => {
    const split1 = split(log1[0], " ");
    const split2 = split(log2[0], " ");
    const isDigit1 = isDigit(split1[1][0]);
    const isDigit2 = isDigit(split2[1][0]);
    if (isDigit1 && isDigit2) {
        return log1[1] - log2[1];
    }
    if (!isDigit1 && !isDigit2) {
        const sc = compareTo(split1[1], split2[1]);
        if (sc !== 0) {
            return sc;
        }
        return compareTo(split1[0], split2[0]);
    }
    return isDigit1 ? 1 : -1;
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}

const compareTo = (left, right) => {
    for (let i = 0; i < Math.min(left.length, right.length); i++) {
        if (left[i].charCodeAt() < right[i].charCodeAt()) {
            return -1;
        }
        if (left[i].charCodeAt() > right[i].charCodeAt()) {
            return 1;
        }
    }
    if (left.length === right.length) {
        return 0;
    }
    if (left.length > right.length) {
        return 1;
    }
    return -1;
}

const split = (str, separator) => {
    const firstItem = str.split(separator)[0];
    const ret = [firstItem];
    const index = str.indexOf(" ");
    ret.push(str.slice(index + 1, str.length));
    return ret;
}
```

```go [sol1-Golang]
func reorderLogFiles(logs []string) []string {
    sort.SliceStable(logs, func(i, j int) bool {
        s, t := logs[i], logs[j]
        s1 := strings.SplitN(s, " ", 2)[1]
        s2 := strings.SplitN(t, " ", 2)[1]
        isDigit1 := unicode.IsDigit(rune(s1[0]))
        isDigit2 := unicode.IsDigit(rune(s2[0]))
        if isDigit1 && isDigit2 {
            return false
        }
        if !isDigit1 && !isDigit2 {
            return s1 < s2 || s1 == s2 && s < t
        }
        return !isDigit1
    })
    return logs
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是 $\textit{logs}$ 的字符数，是平均情况下内置排序的时间复杂度。

- 空间复杂度：$O(n)$ 或 $O(1)$（取决于语言实现）。需要新建数组保存 $\textit{log}$ 和下标，需要将每条 $\textit{log}$ 进行拆分。