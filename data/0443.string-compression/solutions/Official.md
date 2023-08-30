#### 方法一：双指针

**思路和算法**

为了实现原地压缩，我们可以使用双指针分别标志我们在字符串中读和写的位置。每次当读指针 $\textit{read}$ 移动到某一段连续相同子串的最右侧，我们就在写指针 $\textit{write}$ 处依次写入该子串对应的字符和子串长度即可。

在实际代码中，当读指针 $\textit{read}$ 位于字符串的末尾，或读指针 $\textit{read}$ 指向的字符不同于下一个字符时，我们就认为读指针 $\textit{read}$ 位于某一段连续相同子串的最右侧。该子串对应的字符即为读指针 $\textit{read}$ 指向的字符串。我们使用变量 $\textit{left}$ 记录该子串的最左侧的位置，这样子串长度即为 $\textit{read} - \textit{left} + 1$。

特别地，为了达到 $O(1)$ 空间复杂度，我们需要自行实现将数字转化为字符串写入到原字符串的功能。这里我们采用短除法将子串长度倒序写入原字符串中，然后再将其反转即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int compress(vector<char>& chars) {
        int n = chars.size();
        int write = 0, left = 0;
        for (int read = 0; read < n; read++) {
            if (read == n - 1 || chars[read] != chars[read + 1]) {
                chars[write++] = chars[read];
                int num = read - left + 1;
                if (num > 1) {
                    int anchor = write;
                    while (num > 0) {
                        chars[write++] = num % 10 + '0';
                        num /= 10;
                    }
                    reverse(&chars[anchor], &chars[write]);
                }
                left = read + 1;
            }
        }
        return write;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int compress(char[] chars) {
        int n = chars.length;
        int write = 0, left = 0;
        for (int read = 0; read < n; read++) {
            if (read == n - 1 || chars[read] != chars[read + 1]) {
                chars[write++] = chars[read];
                int num = read - left + 1;
                if (num > 1) {
                    int anchor = write;
                    while (num > 0) {
                        chars[write++] = (char) (num % 10 + '0');
                        num /= 10;
                    }
                    reverse(chars, anchor, write - 1);
                }
                left = read + 1;
            }
        }
        return write;
    }

    public void reverse(char[] chars, int left, int right) {
        while (left < right) {
            char temp = chars[left];
            chars[left] = chars[right];
            chars[right] = temp;
            left++;
            right--;
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int Compress(char[] chars) {
        int n = chars.Length;
        int write = 0, left = 0;
        for (int read = 0; read < n; read++) {
            if (read == n - 1 || chars[read] != chars[read + 1]) {
                chars[write++] = chars[read];
                int num = read - left + 1;
                if (num > 1) {
                    int anchor = write;
                    while (num > 0) {
                        chars[write++] = (char) (num % 10 + '0');
                        num /= 10;
                    }
                    Reverse(chars, anchor, write - 1);
                }
                left = read + 1;
            }
        }
        return write;
    }

    public void Reverse(char[] chars, int left, int right) {
        while (left < right) {
            char temp = chars[left];
            chars[left] = chars[right];
            chars[right] = temp;
            left++;
            right--;
        }
    }
}
```

```C [sol1-C]
void swap(char *a, char *b) {
    char t = *a;
    *a = *b, *b = t;
}

void reverse(char *a, char *b) {
    while (a < b) {
        swap(a++, --b);
    }
}

int compress(char *chars, int charsSize) {
    int write = 0, left = 0;
    for (int read = 0; read < charsSize; read++) {
        if (read == charsSize - 1 || chars[read] != chars[read + 1]) {
            chars[write++] = chars[read];
            int num = read - left + 1;
            if (num > 1) {
                int anchor = write;
                while (num > 0) {
                    chars[write++] = num % 10 + '0';
                    num /= 10;
                }
                reverse(&chars[anchor], &chars[write]);
            }
            left = read + 1;
        }
    }
    return write;
}
```

```Python [sol1-Python3]
class Solution:
    def compress(self, chars: List[str]) -> int:
        def reverse(left: int, right: int) -> None:
            while left < right:
                chars[left], chars[right] = chars[right], chars[left]
                left += 1
                right -= 1

        n = len(chars)
        write = left = 0
        for read in range(n):
            if read == n - 1 or chars[read] != chars[read + 1]:
                chars[write] = chars[read]
                write += 1
                num = read - left + 1
                if num > 1:
                    anchor = write
                    while num > 0:
                        chars[write] = str(num % 10)
                        write += 1
                        num //= 10
                    reverse(anchor, write - 1)
                left = read + 1
        return write
```

```go [sol1-Golang]
func compress(chars []byte) int {
    write, left := 0, 0
    for read, ch := range chars {
        if read == len(chars)-1 || ch != chars[read+1] {
            chars[write] = ch
            write++
            num := read - left + 1
            if num > 1 {
                anchor := write
                for ; num > 0; num /= 10 {
                    chars[write] = '0' + byte(num%10)
                    write++
                }
                s := chars[anchor:write]
                for i, n := 0, len(s); i < n/2; i++ {
                    s[i], s[n-1-i] = s[n-1-i], s[i]
                }
            }
            left = read + 1
        }
    }
    return write
}
```

```JavaScript [sol1-JavaScript]
var compress = function(chars) {
    const n = chars.length;
    let write = 0, left = 0;
    for (let read = 0; read < n; read++) {
        if (read === n - 1 || chars[read] !== chars[read + 1]) {
            chars[write++] = chars[read];
            let num = read - left + 1;
            if (num > 1) {
                const anchor = write;
                while (num > 0) {
                    chars[write++] = '' + num % 10;
                    num = Math.floor(num / 10);
                }
                reverse(chars, anchor, write - 1);
            }
            left = read + 1;
        }
    }
    return write;
};

const reverse = (chars, left, right) => {
    while (left < right) {
        const temp = chars[left];
        chars[left] = chars[right];
        chars[right] = temp;
        left++;
        right--;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串长度，我们只需要遍历该字符串一次。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量。