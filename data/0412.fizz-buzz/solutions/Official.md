## [412.Fizz Buzz 中文官方题解](https://leetcode.cn/problems/fizz-buzz/solutions/100000/fizz-buzz-by-leetcode-solution-s0s5)

### 📺 视频题解  
![....Fizz Buzz-栗子小笼包.mp4](4f7068a3-a78d-4962-8597-c6260e87544f)

### 📖 文字题解
#### 方法一：模拟 + 字符串拼接

题目要求返回数组 $\textit{answer}$，对于每个 $1 \le i \le n$，$\textit{answer}[i]$ 为 $i$ 的转化。注意下标 $i$ 从 $1$ 开始。

根据题目描述，当 $i$ 是 $3$ 的倍数时 $\textit{answer}[i]$ 包含 $\text{``Fizz"}$，当 $i$ 是 $5$ 的倍数时 $\textit{answer}[i]$ 包含 $\text{``Buzz"}$，当 $i$ 同时是 $3$ 的倍数和 $5$ 的倍数时 $\textit{answer}[i]$ 既包含 $\text{``Fizz"}$ 也包含 $\text{``Fuzz"}$，且 $\text{``Fizz"}$ 在 $\text{``Buzz"}$ 前面。

基于上述规则，对于每个 $1 \le i \le n$，可以使用字符串拼接的方式得到 $\textit{answer}[i]$，具体操作如下：

1. 如果 $i$ 是 $3$ 的倍数，则将 $\text{``Fizz"}$ 拼接到 $\textit{answer}[i]$；

2. 如果 $i$ 是 $5$ 的倍数，则将 $\text{``Buzz"}$ 拼接到 $\textit{answer}[i]$；

3. 如果 $\textit{answer}[i]$ 为空，则 $i$ 既不是 $3$ 的倍数也不是 $5$ 的倍数，将 $i$ 拼接到 $\textit{answer}[i]$。

```Java [sol1-Java]
class Solution {
    public List<String> fizzBuzz(int n) {
        List<String> answer = new ArrayList<String>();
        for (int i = 1; i <= n; i++) {
            StringBuffer sb = new StringBuffer();
            if (i % 3 == 0) {
                sb.append("Fizz");
            }
            if (i % 5 == 0) {
                sb.append("Buzz");
            }
            if (sb.length() == 0) {
                sb.append(i);
            }
            answer.add(sb.toString());
        }
        return answer;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> FizzBuzz(int n) {
        IList<string> answer = new List<string>();
        for (int i = 1; i <= n; i++) {
            StringBuilder sb = new StringBuilder();
            if (i % 3 == 0) {
                sb.Append("Fizz");
            }
            if (i % 5 == 0) {
                sb.Append("Buzz");
            }
            if (sb.Length == 0) {
                sb.Append(i);
            }
            answer.Add(sb.ToString());
        }
        return answer;
    }
}
```

```JavaScript [sol1-JavaScript]
var fizzBuzz = function(n) {
    const answer = [];
    for (let i = 1; i <= n; i++) {
        const sb = [];
        if (i % 3 === 0) {
            sb.push("Fizz");
        }
        if (i % 5 === 0) {
            sb.push("Buzz");
        }
        if (sb.length === 0) {
            sb.push(i);
        }
        answer.push(sb.join(''));
    }
    return answer;
};
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> fizzBuzz(int n) {
        vector<string> answer;
        for (int i = 1; i <= n; i++) {
            string curr;
            if (i % 3 == 0) {
                curr　+= "Fizz";
            }
            if (i % 5 == 0) {
                curr += "Buzz";
            }
            if (curr.size() == 0) {
                curr += to_string(i);
            }            
            answer.emplace_back(curr);
        }
        return answer;
    }
};
```

```go [sol1-Golang]
func fizzBuzz(n int) (ans []string) {
    for i := 1; i <= n; i++ {
        sb := &strings.Builder{}
        if i%3 == 0 {
            sb.WriteString("Fizz")
        }
        if i%5 == 0 {
            sb.WriteString("Buzz")
        }
        if sb.Len() == 0 {
            sb.WriteString(strconv.Itoa(i))
        }
        ans = append(ans, sb.String())
    }
    return
}
```

```Python [sol1-Python3]
class Solution:
    def fizzBuzz(self, n: int) -> List[str]:
        ans = []
        for i in range(1, n + 1):
            s = ""
            if i % 3 == 0:
                s += "Fizz"
            if i % 5 == 0:
                s += "Buzz"
            if s == "":
                s = str(i)
            ans.append(s)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$。需要遍历从 $1$ 到 $n$ 的每个整数，对于每个整数 $i$，生成 $\textit{answer}[i]$ 的时间复杂度是 $O(1)$。

- 空间复杂度：$O(1)$。注意返回值不计入空间复杂度。