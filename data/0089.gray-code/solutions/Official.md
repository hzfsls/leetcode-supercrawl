## [89.格雷编码 中文官方题解](https://leetcode.cn/problems/gray-code/solutions/100000/ge-lei-bian-ma-by-leetcode-solution-cqi7)

#### 前言

关于格雷编码的知识，读者可以查阅百度百科「[格雷码](https://baike.baidu.com/item/%E6%A0%BC%E9%9B%B7%E7%A0%81)」。

#### 方法一：归纳法

**思路与算法**

当 $n=0$ 时，格雷码序列为 $[0]$。

如果我们获取到了 $n-1$ 位的格雷码序列，记为 $G_{n-1}$，我们可以使用它构造出 $n$ 位的格雷码序列 $G_n$。具体的方法如下：

- 我们将 $G_{n-1}$ 复制一份并翻转，记为 $G_{n-1}^T$；

- 我们给 $G_{n-1}^T$ 中的每个元素的第 $n-1$ 个二进制位都从 $0$ 变为 $1$，得到 $(G_{n-1}^T)'$。这里最低的二进制位为第 $0$ 个二进制位；

- 我们将 $G_{n-1}$ 和 $(G_{n-1}^T)'$ 进行拼接，得到 $G_n$。

上述方法的正确性也可以通过直观的证明得到：

- 由于 $G_{n-1}$ 是 $[0, 2^{n-1})$ 的一个排列，那么其中每个元素的第 $n-1$ 个二进制位都是 $0$。因此，$(G_{n-1}^T)'$ 就是 $[2^{n-1}, 2^n)$ 的一个排列，$G_n = G_{n-1} + (G_{n-1}^T)'$ 就是 $[0, 2^n)$ 的一个排列；

- 对于 $G_{n-1}$ 和 $(G_{n-1}^T)'$ 的内部，每对相邻整数的二进制恰好有一位不同。对于 $G_{n-1}$ 的最后一个数和 $(G_{n-1}^T)'$ 的第一个数，它们仅有第 $n-1$ 个二进制位不同。对于 $G_{n-1}$ 的第一个数和 $(G_{n-1}^T)'$ 的最后一个数，它们也仅有第 $n-1$ 个二进制位不同。

因此 $G_n$ 就是满足要求的 $n$ 位格雷码序列。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> grayCode(int n) {
        vector<int> ret;
        ret.reserve(1 << n);
        ret.push_back(0);
        for (int i = 1; i <= n; i++) {
            int m = ret.size();
            for (int j = m - 1; j >= 0; j--) {
                ret.push_back(ret[j] | (1 << (i - 1)));
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> grayCode(int n) {
        List<Integer> ret = new ArrayList<Integer>();
        ret.add(0);
        for (int i = 1; i <= n; i++) {
            int m = ret.size();
            for (int j = m - 1; j >= 0; j--) {
                ret.add(ret.get(j) | (1 << (i - 1)));
            }
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> GrayCode(int n) {
        IList<int> ret = new List<int>();
        ret.Add(0);
        for (int i = 1; i <= n; i++) {
            int m = ret.Count;
            for (int j = m - 1; j >= 0; j--) {
                ret.Add(ret[j] | (1 << (i - 1)));
            }
        }
        return ret;
    }
}
```

```C [sol1-C]
int* grayCode(int n, int* returnSize) {
    int *ret = (int *)malloc((1 << n) * sizeof(int));
    ret[0] = 0;
    int ret_size = 1;
    for (int i = 1; i <= n; i++) {
        for (int j = ret_size - 1; j >= 0; j--) {
            ret[2 * ret_size - 1 - j] = ret[j] | (1 << (i - 1));
        }
        ret_size <<= 1;
    }
    *returnSize = ret_size;
    return ret;
}
```

```go [sol1-Golang]
func grayCode(n int) []int {
    ans := make([]int, 1, 1<<n)
    for i := 1; i <= n; i++ {
        for j := len(ans) - 1; j >= 0; j-- {
            ans = append(ans, ans[j]|1<<(i-1))
        }
    }
    return ans
}
```

```Python [sol1-Python3]
class Solution:
    def grayCode(self, n: int) -> List[int]:
        ans = [0]
        for i in range(1, n + 1):
            for j in range(len(ans) - 1, -1, -1):
                ans.append(ans[j] | (1 << (i - 1)))
        return ans
```

```JavaScript [sol1-JavaScript]
var grayCode = function(n) {
    const ret = [0];
    for (let i = 1; i <= n; i++) {
        const m = ret.length;
        for (let j = m - 1; j >= 0; j--) {
            ret.push(ret[j] | (1 << (i - 1)));
        }
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(2^n)$。每一个格雷码生成的时间为 $O(1)$，总时间为 $O(2^n)$。

- 空间复杂度：$O(1)$。这里返回值不计入空间复杂度。

#### 方法二：公式法

**思路与算法**

格雷码也可以使用公式直接求出。第 $i~(i \geq 0)$ 个格雷码即为：

$$
g_i = i \oplus \lfloor \frac{i}{2} \rfloor
$$

其中 $\oplus$ 表示按位异或运算。其正确性证明如下：

- 当 $i$ 为偶数时，$i$ 和 $i+1$ 只有最低的一个二进制位不同，而 $\lfloor \dfrac{i}{2} \rfloor$ 和 $\lfloor \dfrac{i+1}{2} \rfloor$ 相等，因此 $g_i$ 和 $g_{i+1}$ 也只有最低的一个二进制位不同；

- 当 $i$ 为奇数时，我们记 $i$ 的二进制表示为 $(\cdots01\cdots11)_2$，$i+1$ 的二进制表示为 $(\cdots10\cdots00)_2$，即：

    - $i$ 和 $i+1$ 的二进制表示的若干个最高位是相同的；

    - $i$ 和 $i+1$ 的二进制表示从高到低的第一个不同的二进制位，$i$ 中的二进制位为 $0$，而 $i+1$ 中的二进制位为 $1$。在这之后，$i$ 的所有二进制位均为 $1$，$i+1$ 的所有二进制位均为 $0$。

    那么，$\lfloor \dfrac{i}{2} \rfloor$ 和 $\lfloor \dfrac{i+1}{2} \rfloor$ 的二进制表示分别为 $(\cdots01\cdots1)_2$ 和 $(\cdots10\cdots0)_2$。因此有：

    $$
    g_i = (\cdots01\cdots11)_2 \oplus (\cdots01\cdots1)_2 = (\cdots010\cdots0)_2
    $$

    以及：

    $$
    g_{i+1} = (\cdots10\cdots00)_2 \oplus (\cdots10\cdots0)_2 = (\cdots 110\cdots0)_2
    $$

    也只有一个二进制位不同。

    注意到，当我们在表示 $i+1$ 时，使用的的是 $(\cdots10\cdots00)_2$，默认了其二进制表示的低位至少有两个 $0$。事实上，当 $i+1$ 是 $2$ 的倍数而不是 $4$ 的倍数时，结论是相同的。读者可以自行推导这种特殊情况。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<int> grayCode(int n) {
        vector<int> ret(1 << n);
        for (int i = 0; i < ret.size(); i++) {
            ret[i] = (i >> 1) ^ i;
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> grayCode(int n) {
        List<Integer> ret = new ArrayList<Integer>();
        for (int i = 0; i < 1 << n; i++) {
            ret.add((i >> 1) ^ i);
        }
        return ret;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<int> GrayCode(int n) {
        IList<int> ret = new List<int>();
        for (int i = 0; i < 1 << n; i++) {
            ret.Add((i >> 1) ^ i);
        }
        return ret;
    }
}
```

```C [sol2-C]
int* grayCode(int n, int* returnSize) {
    int ret_size = 1 << n;
    int *ret = (int *)malloc(ret_size * sizeof(int));
    for (int i = 0; i < ret_size; i++) {
        ret[i] = (i >> 1) ^ i;
    }
    *returnSize = ret_size;
    return ret;
}
```

```go [sol2-Golang]
func grayCode(n int) []int {
    ans := make([]int, 1<<n)
    for i := range ans {
        ans[i] = i>>1 ^ i
    }
    return ans
}
```

```Python [sol2-Python3]
class Solution:
    def grayCode(self, n: int) -> List[int]:
        ans = [0] * (1 << n)
        for i in range(1 << n):
            ans[i] = (i >> 1) ^ i
        return ans
```

```JavaScript [sol2-JavaScript]
var grayCode = function(n) {
    const ret = [];
    for (let i = 0; i < 1 << n; i++) {
        ret.push((i >> 1) ^ i);
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(2^n)$。每一个格雷码生成的时间为 $O(1)$，总时间为 $O(2^n)$。

- 空间复杂度：$O(1)$。这里返回值不计入空间复杂度。