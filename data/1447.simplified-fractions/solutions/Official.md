## [1447.最简分数 中文官方题解](https://leetcode.cn/problems/simplified-fractions/solutions/100000/zui-jian-fen-shu-by-leetcode-solution-98zy)

#### 方法一：数学

由于要保证分数在 $(0,1)$ 范围内，我们可以枚举分母 $\textit{denominator}\in [2,n]$ 和分子 $\textit{numerator}\in [1,\textit{denominator})$，若分子分母的最大公约数为 $1$，则我们找到了一个最简分数。

```Python [sol1-Python3]
class Solution:
    def simplifiedFractions(self, n: int) -> List[str]:
        return [f"{numerator}/{denominator}" for denominator in range(2, n + 1) for numerator in range(1, denominator) if gcd(denominator, numerator) == 1]
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> simplifiedFractions(int n) {
        vector<string> ans;
        for (int denominator = 2; denominator <= n; ++denominator) {
            for (int numerator = 1; numerator < denominator; ++numerator) {
                if (__gcd(numerator, denominator) == 1) {
                    ans.emplace_back(to_string(numerator) + "/" + to_string(denominator));
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> simplifiedFractions(int n) {
        List<String> ans = new ArrayList<String>();
        for (int denominator = 2; denominator <= n; ++denominator) {
            for (int numerator = 1; numerator < denominator; ++numerator) {
                if (gcd(numerator, denominator) == 1) {
                    ans.add(numerator + "/" + denominator);
                }
            }
        }
        return ans;
    }

    public int gcd(int a, int b) {
        return b != 0 ? gcd(b, a % b) : a;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> SimplifiedFractions(int n) {
        IList<string> ans = new List<string>();
        for (int denominator = 2; denominator <= n; ++denominator) {
            for (int numerator = 1; numerator < denominator; ++numerator) {
                if (GCD(numerator, denominator) == 1) {
                    ans.Add(numerator + "/" + denominator);
                }
            }
        }
        return ans;
    }

    public int GCD(int a, int b) {
        return b != 0 ? GCD(b, a % b) : a;
    }
}
```

```go [sol1-Golang]
func simplifiedFractions(n int) (ans []string) {
    for denominator := 2; denominator <= n; denominator++ {
        for numerator := 1; numerator < denominator; numerator++ {
            if gcd(numerator, denominator) == 1 {
                ans = append(ans, strconv.Itoa(numerator)+"/"+strconv.Itoa(denominator))
            }
        }
    }
    return
}

func gcd(a, b int) int {
    for a != 0 {
        a, b = b%a, a
    }
    return b
}
```

```C [sol1-C]
#define MAX_FRACTION_LEN 10

int gcd(int a, int b) {
    if (b == 0) {
        return a;
    }
    return gcd(b, a % b);
}

char ** simplifiedFractions(int n, int* returnSize) {
    char ** ans = (char **)malloc(sizeof(char *) * n * (n - 1) / 2 );
    int pos = 0;
    for (int denominator = 2; denominator <= n; denominator++) {
        for (int numerator = 1; numerator < denominator; numerator++) {
            if (gcd(numerator, denominator) == 1) {
                ans[pos] = (char *)malloc(sizeof(char) * MAX_FRACTION_LEN);
                snprintf(ans[pos++], MAX_FRACTION_LEN, "%d%c%d", numerator, '/', denominator);
            }
        }
    }
    *returnSize = pos;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var simplifiedFractions = function(n) {
    const ans = [];
    for (let denominator = 2; denominator <= n; ++denominator) {
        for (let numerator = 1; numerator < denominator; ++numerator) {
            if (gcd(numerator, denominator) == 1) {
                ans.push(numerator + "/" + denominator);
            }
        }
    }
    return ans;
};

const gcd = (a, b) => {
    if (b === 0) {
        return a;
    }
    return gcd(b, a % b);
}
```

**复杂度分析**

- 时间复杂度：$O(n^2\log n)$。需要枚举 $O(n^2)$ 对分子分母的组合，每对分子分母计算最大公因数和生成字符串的复杂度均为 $O(\log n)$。

- 空间复杂度：$O(1)$。除答案数组外，我们只需要常数个变量。