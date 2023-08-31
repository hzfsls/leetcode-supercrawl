## [2481.分割圆的最少切割次数 中文官方题解](https://leetcode.cn/problems/minimum-cuts-to-divide-a-circle/solutions/100000/fen-ge-yuan-de-zui-shao-qie-ge-ci-shu-by-fsrb)

#### 方法一：分情况讨论

**思路**

如果要分成一等分，则不需要切割。其他情况下，如果 $n$ 为奇数，则需要画 $n$ 条半径来将它平均分成 $n$ 份。如果 $n$ 为偶数，则需要画 $\dfrac{n}{2}$ 条直径来将它平均分成 $n$ 份。

**代码**

```Python [sol1-Python3]
class Solution:
    def numberOfCuts(self, n: int) -> int:
        if n == 1:
            return 0
        if n % 2 == 0:
            return n // 2
        return n
```

```Java [sol1-Java]
class Solution {
    public int numberOfCuts(int n) {
        if (n == 1) {
            return 0;
        }
        if (n % 2 == 0) {
            return n / 2;
        }
        return n;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumberOfCuts(int n) {
        if (n == 1) {
            return 0;
        }
        if (n % 2 == 0) {
            return n / 2;
        }
        return n;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int numberOfCuts(int n) {
        if (n == 1) {
            return 0;
        }
        if (n % 2 == 0) {
            return n / 2;
        }
        return n;
    }
};
```

```C++ [sol1-C++]
class Solution {
public:
    int numberOfCuts(int n) {
        if (n == 1) {
            return 0;
        }
        if (n % 2 == 0) {
            return n / 2;
        }
        return n;
    }
};
```

```C [sol1-C]
int numberOfCuts(int n) {
    if (n == 1) {
        return 0;
    }
    if (n % 2 == 0) {
        return n / 2;
    }
    return n;
}
```

```JavaScript [sol1-JavaScript]
var numberOfCuts = function(n) {
    if (n === 1) {
        return 0;
    }
    if (n % 2 === 0) {
        return n / 2;
    }
    return n;
};
```

```Go [sol1-Go]
func numberOfCuts(n int) int {
    if n == 1 {
        return 0
    }
    if n % 2 == 0 {
        return n / 2
    }
    return n
}

```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。