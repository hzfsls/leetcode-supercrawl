#### 方法一：直接模拟

根据题意可知返回主文件夹的操作为连续退回到上一层目录，直到返回主目录为止，在这种操作下使用的操作数最少。我们用一个变量记录 $\textit{depth}$ 当前目录的层次深度，$\textit{depth}$ 初始化为 $0$，根据题意可知：
+ 如果当前的操作为 $\texttt{"../"}$：移动到当前文件夹的父文件夹。如果已经在主文件夹下，则继续停留在当前文件夹。则此时如果层次深度 $\textit{depth} > 0$ 则将 $\textit{depth}$ 减 $1$，否则 $\textit{depth}$ 保持不变；
+ 如果当前的操作为 $\texttt{"./"}$：继续停留在当前文件夹，此时 $\textit{depth}$ 保持不变；
+ 如果当前的操作为 $\texttt{"x/"}$：移动到下一层名为 $\textit{x}$ 的子文件夹中。则此时将 $\textit{depth}$ 加 $1$。

最终返回当前的文件层次深度 $\textit{depth}$ 即可。

```Python [sol1-Python3]
class Solution:
    def minOperations(self, logs: List[str]) -> int:
        depth = 0
        for log in logs:
            if log == "./":
                continue
            if log != "../":
                depth += 1
            elif depth:
                depth -= 1
        return depth
```

```C++ [sol1-C++]
class Solution {
public:
    int minOperations(vector<string>& logs) {
        int depth = 0;
        for (auto & log : logs) {
            if (log == "./") {
                continue;
            } else if (log == "../") {
                if (depth > 0) {
                    depth--;
                }
            } else {
                depth++;
            }
        }
        return depth;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minOperations(String[] logs) {
        int depth = 0;
        for (String log : logs) {
            if ("./".equals(log)) {
                continue;
            } else if ("../".equals(log)) {
                if (depth > 0) {
                    depth--;
                }
            } else {
                depth++;
            }
        }
        return depth;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinOperations(string[] logs) {
        int depth = 0;
        foreach (string log in logs) {
            if ("./".Equals(log)) {
                continue;
            } else if ("../".Equals(log)) {
                if (depth > 0) {
                    depth--;
                }
            } else {
                depth++;
            }
        }
        return depth;
    }
}
```

```C [sol1-C]
int minOperations(char ** logs, int logsSize) {
    int depth = 0;
    for (int i = 0; i < logsSize; i++) {
        if (!strcmp(logs[i], "./")) {
            continue;
        } else if (!strcmp(logs[i], "../")) {
            if (depth > 0) {
                depth--;
            }
        } else {
            depth++;
        }
    }
    return depth;
}
```

```JavaScript [sol1-JavaScript]
var minOperations = function(logs) {
    let depth = 0;
    for (const log of logs) {
        if ('./' === log) {
            continue;
        } else if ('../' === log) {
            if (depth > 0) {
                depth--;
            }
        } else {
            depth++;
        }
    }
    return depth;
};
```

```go [sol1-Golang]
func minOperations(logs []string) (depth int) {
    for _, log := range logs {
        if log == "./" {
            continue
        }
        if log != "../" {
            depth++
        } else if depth > 0 {
            depth--
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串数组的长度。只需遍历一遍字符串数组即可。

- 空间复杂度：$O(1)$。