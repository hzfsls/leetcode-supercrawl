#### 方法一：深度优先搜索

**思路与算法**

题目要求设计一个时间复杂度为 $O(n)$ 且使用 $O(1)$ 额外空间的算法，因此我们不能使用直接排序的方法。

那么对于一个整数 $\textit{number}$，它的下一个字典序整数对应下面的规则：

+ 尝试在 $\textit{number}$ 后面附加一个零，即 $\textit{number} \times 10$，如果 $\textit{number} \times 10 \le n$，那么说明 $\textit{number} \times 10$ 是下一个字典序整数；

+ 如果 $\textit{number} \bmod 10 = 9$ 或 $\textit{number} + 1 \gt n$，那么说明末尾的数位已经搜索完成，退回上一位，即 $\textit{number} = \Big \lfloor \dfrac{\textit{number}}{10} \Big \rfloor$，然后继续判断直到 $\textit{number} \bmod 10 \ne 9$ 且 $\textit{number} + 1 \le n$ 为止，那么 $\textit{number} + 1$ 是下一个字典序整数。

字典序最小的整数为 $\textit{number} = 1$，我们从它开始，然后依次获取下一个字典序整数，加入结果中，结束条件为已经获取到 $n$ 个整数。

**代码**

```Python [sol1-Python3]
class Solution:
    def lexicalOrder(self, n: int) -> List[int]:
        ans = [0] * n
        num = 1
        for i in range(n):
            ans[i] = num
            if num * 10 <= n:
                num *= 10
            else:
                while num % 10 == 9 or num + 1 > n:
                    num //= 10
                num += 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> lexicalOrder(int n) {
        vector<int> ret(n);
        int number = 1;
        for (int i = 0; i < n; i++) {
            ret[i] = number;
            if (number * 10 <= n) {
                number *= 10;
            } else {
                while (number % 10 == 9 || number + 1 > n) {
                    number /= 10;
                }
                number++;
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> lexicalOrder(int n) {
        List<Integer> ret = new ArrayList<Integer>();
        int number = 1;
        for (int i = 0; i < n; i++) {
            ret.add(number);
            if (number * 10 <= n) {
                number *= 10;
            } else {
                while (number % 10 == 9 || number + 1 > n) {
                    number /= 10;
                }
                number++;
            }
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> LexicalOrder(int n) {
        IList<int> ret = new List<int>();
        int number = 1;
        for (int i = 0; i < n; i++) {
            ret.Add(number);
            if (number * 10 <= n) {
                number *= 10;
            } else {
                while (number % 10 == 9 || number + 1 > n) {
                    number /= 10;
                }
                number++;
            }
        }
        return ret;
    }
}
```

```C [sol1-C]
int* lexicalOrder(int n, int* returnSize){
    int *ret = (int *)malloc(sizeof(int) * n);
    int number = 1;
    for (int i = 0; i < n; i++) {
        ret[i] = number;
        if (number * 10 <= n) {
            number *= 10;
        } else {
            while (number % 10 == 9 || number + 1 > n) {
                number /= 10;
            }
            number++;
        }
    }
    *returnSize = n;
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var lexicalOrder = function(n) {
    const ret = [];
    let number = 1;
    for (let i = 0; i < n; i++) {
        ret.push(number);
        if (number * 10 <= n) {
            number *= 10;
        } else {
            while (number % 10 === 9 || number + 1 > n) {
                number = Math.floor(number / 10);
            }
            number++;
        }
    }
    return ret;
};
```

```go [sol1-Golang]
func lexicalOrder(n int) []int {
    ans := make([]int, n)
    num := 1
    for i := range ans {
        ans[i] = num
        if num*10 <= n {
            num *= 10
        } else {
            for num%10 == 9 || num+1 > n {
                num /= 10
            }
            num++
        }
    }
    return ans
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 为整数的数目。获取下一个字典序整数的最坏时间复杂度为 $O(\log n)$，但 $\texttt{while}$ 循环的迭代次数与 $\textit{number}$ 的末尾连续的 $9$ 的数目有关，在整数区间 $[1, n]$ 中，末尾连续的 $9$ 的数目为 $k$ 的整数不超过 $\Big \lceil \dfrac{n}{10^k} \Big \rceil$ 个，其中 $1 \le k \le \lceil \log_{10} n \rceil$，因此总迭代次数不超过 $\sum_k k \Big \lceil \dfrac{n}{10^k} \Big \rceil \le 2n$，总时间复杂度为 $O(n)$。

+ 空间复杂度：$O(1)$。返回值不计入空间复杂度。