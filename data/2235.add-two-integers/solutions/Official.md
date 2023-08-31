## [2235.两整数相加 中文官方题解](https://leetcode.cn/problems/add-two-integers/solutions/100000/liang-zheng-shu-xiang-jia-by-leetcode-so-6cq1)
#### 方法一：直接计算

计算整数 $\textit{num}_1$ 与 $\textit{num}_2$ 之和，返回 $\textit{num}_1 + \textit{num}_2$ 即可。

```Java [sol1-Java]
class Solution {
    public int sum(int num1, int num2) {
        return num1 + num2;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int Sum(int num1, int num2) {
        return num1 + num2;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int sum(int num1, int num2) {
        return num1 + num2;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def sum(self, num1: int, num2: int) -> int:
        return num1 + num2
```

```C [sol1-C]
int sum(int num1, int num2) {
    return num1 + num2;
}
```

```Go [sol1-Golang]
func sum(num1 int, num2 int) int {
    return num1 + num2
}
```

```JavaScript [sol1-JavaScript]
var sum = function(num1, num2) {
    return num1 + num2;
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。