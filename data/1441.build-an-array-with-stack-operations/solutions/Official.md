## [1441.用栈操作构建数组 中文官方题解](https://leetcode.cn/problems/build-an-array-with-stack-operations/solutions/100000/yong-zhan-cao-zuo-gou-jian-shu-zu-by-lee-omde)
#### 方法一：模拟

**思路**

操作的对象是 $1$ 到 $n$ 按顺序排列的数字，每次操作一个数字时，如果它在 $\textit{target}$ 中，则只需要将它 $\texttt{Push}$ 入栈即可。如果不在 $\textit{target}$ 中，可以先将其 $\texttt{Push}$ 入栈，紧接着 $\texttt{Pop}$ 出栈。因为 $\textit{target}$ 中数字是严格递增的，因此只要遍历 $\textit{target}$，在 $\textit{target}$ 中每两个连续的数字 $\textit{prev}$ 和 $\textit{number}$ 中插入 $\textit{number} - \textit{prev} - 1$ 个 $\texttt{Push}$ 和 $\texttt{Pop}$，再多加一个 $\texttt{Push}$ 来插入当前数字即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def buildArray(self, target: List[int], n: int) -> List[str]:
        res = []
        prev = 0
        for number in target:
            for _ in range(number - prev - 1):
                res.append('Push')
                res.append('Pop')
            res.append('Push')
            prev = number
        return res
```

```Java [sol1-Java]
class Solution {
    public List<String> buildArray(int[] target, int n) {
        List<String> res = new ArrayList<String>();
        int prev = 0;
        for (int number : target) {
            for (int i = 0; i < number - prev - 1; i++) {
                res.add("Push");
                res.add("Pop");
            }
            res.add("Push");
            prev = number;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> BuildArray(int[] target, int n) {
        IList<string> res = new List<string>();
        int prev = 0;
        foreach (int number in target) {
            for (int i = 0; i < number - prev - 1; i++) {
                res.Add("Push");
                res.Add("Pop");
            }
            res.Add("Push");
            prev = number;
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> buildArray(vector<int>& target, int n) {
        vector<string> res;
        int prev = 0;
        for (int number : target) {
            for (int i = 0; i < number - prev - 1; i++) {
                res.emplace_back("Push");
                res.emplace_back("Pop");
            }
            res.emplace_back("Push");
            prev = number;
        }
        return res;
    }
};
```

```C [sol1-C]
char ** buildArray(int* target, int targetSize, int n, int* returnSize) {
    char **res = (char **)malloc(sizeof(char *) * n * 2);
    int prev = 0, pos = 0;
    for (int j = 0; j < targetSize; j++) {
        for (int i = 0; i < target[j] - prev - 1; i++) {
            res[pos] = (char *)malloc(sizeof(char) * 8);
            strcpy(res[pos++], "Push");
            res[pos] = (char *)malloc(sizeof(char) * 8);
            strcpy(res[pos++], "Pop");
        }
        res[pos] = (char *)malloc(sizeof(char) * 8);
        strcpy(res[pos++], "Push");
        prev = target[j];
    }
    *returnSize = pos;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var buildArray = function(target, n) {
    const res = [];
    let prev = 0;
    for (const number of target) {
        for (let i = 0; i < number - prev - 1; i++) {
            res.push("Push");
            res.push("Pop");
        }
        res.push("Push");
        prev = number;
    }
    return res;
};
```

```go [sol1-Golang]
func buildArray(target []int, n int) (ans []string) {
    prev := 0
    for _, number := range target {
        for i := 0; i < number-prev-1; i++ {
            ans = append(ans, "Push", "Pop")
        }
        ans = append(ans, "Push")
        prev = number
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。$\texttt{Push}$ 需要添加 $O(n)$ 次。

- 空间复杂度：$O(1)$。除了保存结果的数组，其他只消耗常数空间。