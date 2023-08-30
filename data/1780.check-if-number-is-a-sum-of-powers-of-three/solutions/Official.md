#### 方法一：进制转换

**思路与算法**

我们可以将 $n$ 转换成 $3$ 进制。如果 $n$ 的 $3$ 进制表示中每一位均不为 $2$，那么答案为 $\text{True}$，否则为 $\text{False}$。

例如当 $n=12$ 时，$12 = (110)_3$，满足要求；当 $n=21$ 时，$21 = (210)_3$，不满足要求。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool checkPowersOfThree(int n) {
        while (n) {
            if (n % 3 == 2) {
                return false;
            }
            n /= 3;
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean checkPowersOfThree(int n) {
        while (n != 0) {
            if (n % 3 == 2) {
                return false;
            }
            n /= 3;
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CheckPowersOfThree(int n) {
        while (n != 0) {
            if (n % 3 == 2) {
                return false;
            }
            n /= 3;
        }
        return true;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def checkPowersOfThree(self, n: int) -> bool:
        while n > 0:
            if n % 3 == 2:
                return False
            n //= 3
        return True
```

```C [sol1-C]
bool checkPowersOfThree(int n) {
    while (n) {
        if (n % 3 == 2) {
            return false;
        }
        n /= 3;
    }
    return true;
}
```

```JavaScript [sol1-JavaScript]
var checkPowersOfThree = function(n) {
    while (n !== 0) {
        if (n % 3 === 2) {
            return false;
        }
        n = Math.floor(n / 3);
    }
    return true;
};
```

```go [sol1-Golang]
func checkPowersOfThree(n int) bool {
    for ; n > 0; n /= 3 {
        if n%3 == 2 {
            return false
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，即为进制转换需要的时间。

- 空间复杂度：$O(1)$。