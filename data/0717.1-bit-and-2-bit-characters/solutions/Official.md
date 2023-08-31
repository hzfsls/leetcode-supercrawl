## [717.1 比特与 2 比特字符 中文官方题解](https://leetcode.cn/problems/1-bit-and-2-bit-characters/solutions/100000/1bi-te-yu-2bi-te-zi-fu-by-leetcode-solut-rhrh)
#### 方法一：正序遍历

根据题意，第一种字符一定以 $0$ 开头，第二种字符一定以 $1$ 开头。

我们可以对 $\textit{bits}$ 数组从左到右遍历。当遍历到 $\textit{bits}[i]$ 时，如果 $\textit{bits}[i]=0$，说明遇到了第一种字符，将 $i$ 的值增加 $1$；如果 $\textit{bits}[i]=1$，说明遇到了第二种字符，可以跳过 $\textit{bits}[i+1]$（注意题目保证 $\textit{bits}$ 一定以 $0$ 结尾，所以 $\textit{bits}[i]$ 一定不是末尾比特，因此 $\textit{bits}[i+1]$ 必然存在），将 $i$ 的值增加 $2$。

上述流程也说明 $\textit{bits}$ 的编码方式是唯一确定的，因此若遍历到 $i=n-1$，那么说明最后一个字符一定是第一种字符。

```Python [sol1-Python3]
class Solution:
    def isOneBitCharacter(self, bits: List[int]) -> bool:
        i, n = 0, len(bits)
        while i < n - 1:
            i += bits[i] + 1
        return i == n - 1
```

```C++ [sol1-C++]
class Solution {
public:
    bool isOneBitCharacter(vector<int> &bits) {
        int n = bits.size(), i = 0;
        while (i < n - 1) {
            i += bits[i] + 1;
        }
        return i == n - 1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isOneBitCharacter(int[] bits) {
        int n = bits.length, i = 0;
        while (i < n - 1) {
            i += bits[i] + 1;
        }
        return i == n - 1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsOneBitCharacter(int[] bits) {
        int n = bits.Length, i = 0;
        while (i < n - 1) {
            i += bits[i] + 1;
        }
        return i == n - 1;
    }
}
```

```go [sol1-Golang]
func isOneBitCharacter(bits []int) bool {
    i, n := 0, len(bits)
    for i < n-1 {
        i += bits[i] + 1
    }
    return i == n-1
}
```

```JavaScript [sol1-JavaScript]
var isOneBitCharacter = function(bits) {
    let i = 0, n = bits.length;
    while (i < n - 1) {
        i += bits[i] + 1;
    }
    return i === n - 1;
};
```

```C [sol1-C]
bool isOneBitCharacter(int* bits, int bitsSize){
    int i = 0;
    while (i < bitsSize - 1) {
        i += bits[i] + 1;
    }
    return i == bitsSize - 1;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{bits}$ 的长度。

- 空间复杂度：$O(1)$。

#### 方法二：倒序遍历

根据题意，$0$ 一定是一个字符的结尾。

我们可以找到 $\textit{bits}$ 的倒数第二个 $0$ 的位置，记作 $i$（不存在时定义为 $-1$），那么 $\textit{bits}[i+1]$ 一定是一个字符的开头，且从 $\textit{bits}[i+1]$ 到 $\textit{bits}[n-2]$ 的这 $n-2-i$ 个比特均为 $1$。

- 如果 $n-2-i$ 为偶数，则这些比特 $1$ 组成了 $\dfrac{n-2-i}{2}$ 个第二种字符，所以 $\textit{bits}$ 的最后一个比特 $0$ 一定组成了第一种字符。
- 如果 $n-2-i$ 为奇数，则这些比特 $1$ 的前 $n-3-i$ 个比特组成了 $\dfrac{n-3-i}{2}$ 个第二种字符，多出的一个比特 $1$ 和 $\textit{bits}$ 的最后一个比特 $0$ 组成第二种字符。

由于 $n-i$ 和 $n-2-i$ 的奇偶性相同，我们可以通过判断 $n-i$ 是否为偶数来判断最后一个字符是否为第一种字符，若为偶数则返回 $\texttt{true}$，否则返回 $\texttt{false}$。

```Python [sol2-Python3]
class Solution:
    def isOneBitCharacter(self, bits: List[int]) -> bool:
        n = len(bits)
        i = n - 2
        while i >= 0 and bits[i]:
            i -= 1
        return (n - i) % 2 == 0
```

```C++ [sol2-C++]
class Solution {
public:
    bool isOneBitCharacter(vector<int> &bits) {
        int n = bits.size(), i = n - 2;
        while (i >= 0 and bits[i]) {
            --i;
        }
        return (n - i) % 2 == 0;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean isOneBitCharacter(int[] bits) {
        int n = bits.length, i = n - 2;
        while (i >= 0 && bits[i] == 1) {
            --i;
        }
        return (n - i) % 2 == 0;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool IsOneBitCharacter(int[] bits) {
        int n = bits.Length, i = n - 2;
        while (i >= 0 && bits[i] == 1) {
            --i;
        }
        return (n - i) % 2 == 0;
    }
}
```

```go [sol2-Golang]
func isOneBitCharacter(bits []int) bool {
    n := len(bits)
    i := n - 2
    for i >= 0 && bits[i] == 1 {
        i--
    }
    return (n-i)%2 == 0
}
```

```JavaScript [sol2-JavaScript]
var isOneBitCharacter = function(bits) {
    const n = bits.length;
    let i = n - 2;
    while (i >= 0 && bits[i]) {
        i--;
    }
    return (n - i) % 2 === 0;
};
```

```C [sol2-C]
bool isOneBitCharacter(int* bits, int bitsSize){
    int i = bitsSize - 2;
    while (i >= 0 && bits[i]) {
        --i;
    }
    return (bitsSize - i) % 2 == 0;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{bits}$ 的长度。

- 空间复杂度：$O(1)$。