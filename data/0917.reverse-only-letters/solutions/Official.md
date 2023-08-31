## [917.仅仅反转字母 中文官方题解](https://leetcode.cn/problems/reverse-only-letters/solutions/100000/jin-jin-fan-zhuan-zi-mu-by-leetcode-solu-db20)
#### 方法一：双指针

**思路与算法**

我们使用 $\textit{left}$ 指针从左边开始扫描字符串 $s$，$\textit{right}$ 指针从右边开始扫描字符串 $s$。如果两个指针都扫描到字母，且 $\textit{left} < \textit{right}$，那么交换 $s[\textit{left}]$ 和 $s[\textit{right}]$，然后继续进行扫描；否则表明反转过程结束，返回处理后的字符串。

**代码**

```Python [sol1-Python3]
class Solution:
    def reverseOnlyLetters(self, s: str) -> str:
        ans = list(s)
        left, right = 0, len(ans) - 1
        while True:
            while left < right and not ans[left].isalpha():  # 判断左边是否扫描到字母
                left += 1
            while right > left and not ans[right].isalpha():  # 判断右边是否扫描到字母
                right -= 1
            if left >= right:
                break
            ans[left], ans[right] = ans[right], ans[left]
            left += 1
            right -= 1
        return ''.join(ans)
```

```C++ [sol1-C++]
class Solution {
public:
    string reverseOnlyLetters(string s) {
        int n = s.size();
        int left = 0, right = n - 1;
        while (true) {
            while (left < right && !isalpha(s[left])) { // 判断左边是否扫描到字母
                left++;
            }
            while (right > left && !isalpha(s[right])) { // 判断右边是否扫描到字母
                right--;
            }
            if (left >= right) {
                break;
            }
            swap(s[left], s[right]);
            left++;
            right--;
        }
        return s;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String reverseOnlyLetters(String s) {
        int n = s.length();
        char[] arr = s.toCharArray();
        int left = 0, right = n - 1;
        while (true) {
            while (left < right && !Character.isLetter(s.charAt(left))) { // 判断左边是否扫描到字母
                left++;
            }
            while (right > left && !Character.isLetter(s.charAt(right))) { // 判断右边是否扫描到字母
                right--;
            }
            if (left >= right) {
                break;
            }
            swap(arr, left, right);
            left++;
            right--;
        }
        return new String(arr);
    }

    public void swap(char[] arr, int left, int right) {
        char temp = arr[left];
        arr[left] = arr[right];
        arr[right] = temp;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ReverseOnlyLetters(string s) {
        int n = s.Length;
        char[] arr = s.ToCharArray();
        int left = 0, right = n - 1;
        while (true) {
            while (left < right && !char.IsLetter(s[left])) { // 判断左边是否扫描到字母
                left++;
            }
            while (right > left && !char.IsLetter(s[right])) { // 判断右边是否扫描到字母
                right--;
            }
            if (left >= right) {
                break;
            }
            Swap(arr, left, right);
            left++;
            right--;
        }
        return new String(arr);
    }

    public void Swap(char[] arr, int left, int right) {
        char temp = arr[left];
        arr[left] = arr[right];
        arr[right] = temp;
    }
}
```

```C [sol1-C]
static inline void swap(char *c1, char *c2) {
    char tmp = *c1;
    *c1 = *c2;
    *c2 = tmp;
}

char *reverseOnlyLetters(char *s){
    int n = strlen(s);
    int left = 0, right = n - 1;
    while (true) {
        while (left < right && !isalpha(s[left])) { // 判断左边是否扫描到字母
            left++;
        }
        while (right > left && !isalpha(s[right])) { // 判断右边是否扫描到字母
            right--;
        }
        if (left >= right) {
            break;
        }
        swap(s + left, s + right);
        left++;
        right--;
    }
    return s;
}
```

```go [sol1-Golang]
func reverseOnlyLetters(s string) string {
    ans := []byte(s)
    left, right := 0, len(s)-1
    for {
        for left < right && !unicode.IsLetter(rune(s[left])) { // 判断左边是否扫描到字母
            left++
        }
        for right > left && !unicode.IsLetter(rune(s[right])) { // 判断右边是否扫描到字母
            right--
        }
        if left >= right {
            break
        }
        ans[left], ans[right] = ans[right], ans[left]
        left++
        right--
    }
    return string(ans)
}
```

```JavaScript [sol1-JavaScript]
var reverseOnlyLetters = function(s) {
    const n = s.length;
    const arr = [...s];
    let left = 0, right = n - 1;
    while (true) {
        while (left < right && !(/^[a-zA-Z]+$/.test(s[left]))) { // 判断左边是否扫描到字母
            left++;
        }
        while (right > left && !(/^[a-zA-Z]+$/.test(s[right]))) { // 判断右边是否扫描到字母
            right--;
        }
        if (left >= right) {
            break;
        }
        swap(arr, left, right);
        left++;
        right--;
    }
    return arr.join('');
};

const swap = (arr, left, right) => {
    const temp = arr[left];
    arr[left] = arr[right];
    arr[right] = temp;
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。反转过程需要 $O(n)$，C 语言计算字符串长度需要 $O(n)$。

+ 空间复杂度：$O(1)$ 或 $O(n)$。某些语言字符串不可变，需要 $O(n)$ 的额外空间。