#### 方法一：模拟

我们直接按题意进行模拟：反转每个下标从 $2k$ 的倍数开始的，长度为 $k$ 的子串。若该子串长度不足 $k$，则反转整个子串。

```Python [sol1-Python3]
class Solution:
    def reverseStr(self, s: str, k: int) -> str:
        t = list(s)
        for i in range(0, len(t), 2 * k):
            t[i: i + k] = reversed(t[i: i + k])
        return "".join(t)
```

```C++ [sol1-C++]
class Solution {
public:
    string reverseStr(string s, int k) {
        int n = s.length();
        for (int i = 0; i < n; i += 2 * k) {
            reverse(s.begin() + i, s.begin() + min(i + k, n));
        }
        return s;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String reverseStr(String s, int k) {
        int n = s.length();
        char[] arr = s.toCharArray();
        for (int i = 0; i < n; i += 2 * k) {
            reverse(arr, i, Math.min(i + k, n) - 1);
        }
        return new String(arr);
    }

    public void reverse(char[] arr, int left, int right) {
        while (left < right) {
            char temp = arr[left];
            arr[left] = arr[right];
            arr[right] = temp;
            left++;
            right--;
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ReverseStr(string s, int k) {
        int n = s.Length;
        char[] arr = s.ToCharArray();
        for (int i = 0; i < n; i += 2 * k) {
            Reverse(arr, i, Math.Min(i + k, n) - 1);
        }
        return new string(arr);
    }

    public void Reverse(char[] arr, int left, int right) {
        while (left < right) {
            char temp = arr[left];
            arr[left] = arr[right];
            arr[right] = temp;
            left++;
            right--;
        }
    }
}
```

```go [sol1-Golang]
func reverseStr(s string, k int) string {
    t := []byte(s)
    for i := 0; i < len(s); i += 2 * k {
        sub := t[i:min(i+k, len(s))]
        for j, n := 0, len(sub); j < n/2; j++ {
            sub[j], sub[n-1-j] = sub[n-1-j], sub[j]
        }
    }
    return string(t)
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var reverseStr = function(s, k) {
    const n = s.length;
    const arr = Array.from(s);
    for (let i = 0; i < n; i += 2 * k) {
        reverse(arr, i, Math.min(i + k, n) - 1);
    }
    return arr.join('');
};

const reverse = (arr, left, right) => {
    while (left < right) {
        const temp = arr[left];
        arr[left] = arr[right];
        arr[right] = temp;
        left++;
        right--;
    }
}
```

```C [sol1-C]
void swap(char* a, char* b) {
    char tmp = *a;
    *a = *b, *b = tmp;
}

void reverse(char* l, char* r) {
    while (l < r) {
        swap(l++, --r);
    }
}

int min(int a, int b) {
    return a < b ? a : b;
}

char* reverseStr(char* s, int k) {
    int n = strlen(s);
    for (int i = 0; i < n; i += 2 * k) {
        reverse(&s[i], &s[min(i + k, n)]);
    }
    return s;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(1)$ 或 $O(n)$，取决于使用的语言中字符串类型的性质。如果字符串是可修改的，那么我们可以直接在原字符串上修改，空间复杂度为 $O(1)$，否则需要使用 $O(n)$ 的空间将字符串临时转换为可以修改的数据结构（例如数组），空间复杂度为 $O(n)$。