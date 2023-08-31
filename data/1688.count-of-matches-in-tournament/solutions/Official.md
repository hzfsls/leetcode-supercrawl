## [1688.比赛中的配对次数 中文官方题解](https://leetcode.cn/problems/count-of-matches-in-tournament/solutions/100000/bi-sai-zhong-de-pei-dui-ci-shu-by-leetco-ugvj)
#### 方法一：模拟

**思路与算法**

我们直接模拟题目描述中的赛制即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numberOfMatches(int n) {
        int ans = 0;
        while (n > 1) {
            if (n % 2 == 0) {
                ans += n / 2;
                n /= 2;
            }
            else {
                ans += (n - 1) / 2;
                n = (n - 1) / 2 + 1;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numberOfMatches(int n) {
        int ans = 0;
        while (n > 1) {
            if (n % 2 == 0) {
                ans += n / 2;
                n /= 2;
            } else {
                ans += (n - 1) / 2;
                n = (n - 1) / 2 + 1;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumberOfMatches(int n) {
        int ans = 0;
        while (n > 1) {
            if (n % 2 == 0) {
                ans += n / 2;
                n /= 2;
            } else {
                ans += (n - 1) / 2;
                n = (n - 1) / 2 + 1;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numberOfMatches(self, n: int) -> int:
        ans = 0
        while n > 1:
            if n % 2 == 0:
                ans += n // 2
                n //= 2
            else:
                ans += (n - 1) // 2
                n = (n - 1) // 2 + 1
        return ans
```

```Golang [sol1-Golang]
func numberOfMatches(n int) int {
	ans := 0
	for n > 1 {
		if n%2 == 0 {
			ans += n / 2
			n /= 2
		} else {
			ans += (n - 1) / 2
			n = (n-1)/2 + 1
		}
	}
	return ans
}
```

```C [sol1-C]
int numberOfMatches(int n){
    int ans = 0;
    while (n > 1) {
        if (n % 2 == 0) {
            ans += n / 2;
            n /= 2;
        } else {
            ans += (n - 1) / 2;
            n = (n - 1) / 2 + 1;
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var numberOfMatches = function(n) {
    let ans = 0;
    while (n > 1) {
        if (n % 2 === 0) {
            ans += Math.floor(n / 2);
            n /= 2;
        } else {
            ans += Math.floor((n - 1) / 2);
            n = Math.floor((n - 1) / 2) + 1;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。每一轮后会有一半（向下取整）数量的队伍无法晋级，因此轮数为 $O(\log n)$。每一轮需要 $O(1)$ 的时间进行计算。

- 空间复杂度：$O(1)$。

#### 方法二：数学

**思路与算法**

在每一场比赛中，输的队伍无法晋级，且不会再参加后续的比赛。由于最后只决出一个获胜队伍，因此就有 $n-1$ 个无法晋级的队伍，也就是会有 $n-1$ 场比赛。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int numberOfMatches(int n) {
        return n - 1;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int numberOfMatches(int n) {
        return n - 1;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int NumberOfMatches(int n) {
        return n - 1;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def numberOfMatches(self, n: int) -> int:
        return n - 1
```

```Golang [sol2-Golang]
func numberOfMatches(n int) int {
	return n - 1
}
```

```C [sol2-C]
int numberOfMatches(int n){
    return n - 1;
}
```

```JavaScript [sol2-JavaScript]
var numberOfMatches = function(n) {
    return n - 1
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。