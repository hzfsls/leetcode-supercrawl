#### 方法一：双指针

**思路**

记字符串的长度为 $n$，分割的下标为 $k$，即下标 $k$ 之前的字符构成前缀，下标 $k$ 和之后的字符构成后缀，前缀长度为 $k$，后缀长度为 $n-k$，$0 \leq k \leq n$。

接下来需要判断 $a_\textit{prefix} + b_\textit{suffix}$ 或者 $b_\textit{prefix} + a_\textit{suffix}$ 能否构成回文字符串，首先判断 $a_\textit{prefix} + b_\textit{suffix}$ 能否构成回文字符串。这个字符串的起始位置是由 $a$ 组成的，末尾位置是由 $b$ 构成的。要想构成回文，起始的部分和末尾的部分必须是倒序相等的，这个可以用双指针来逐位判断。当遇到不相等的情况时，则说明遇到了分割点，分割的位置可能是左侧的指针，也可能是右侧的指针。如果分割点是左侧的指针，则需要 $b$ 在双指针之间的字符串构成回文；如果分割点是右侧的指针，则需要 $a$ 在双指针之间的字符串构成回文。这二者满足其一即可。

判断 $b_\textit{prefix} + a_\textit{suffix}$ 能否构成回文字符串也是类似的思路。

**代码**

```Python [sol1-Python3]
class Solution:
    def checkPalindromeFormation(self, a: str, b: str) -> bool:
        return self.checkConcatenation(a, b) or self.checkConcatenation(b, a)
    
    def checkConcatenation(self, a: str, b: str) -> bool:
        n = len(a)
        left, right = 0, n-1
        while left < right and a[left] == b[right]:
            left += 1
            right -= 1
        if left >= right:
            return True
        return self.checkSelfPalindrome(a, left, right) or self.checkSelfPalindrome(b, left, right)

    def checkSelfPalindrome(self, a: str, left: int, right: int) -> bool:
        while left < right and a[left] == a[right]:
            left += 1
            right -= 1
        return left >= right
```

```Java [sol1-Java]
class Solution {
    public boolean checkPalindromeFormation(String a, String b) {
        return checkConcatenation(a, b) || checkConcatenation(b, a);
    }

    public boolean checkConcatenation(String a, String b) {
        int n = a.length();
        int left = 0, right = n - 1;
        while (left < right && a.charAt(left) == b.charAt(right)) {
            left++;
            right--;
        }
        if (left >= right) {
            return true;
        }
        return checkSelfPalindrome(a, left, right) || checkSelfPalindrome(b, left, right);
    }

    public boolean checkSelfPalindrome(String a, int left, int right) {
        while (left < right && a.charAt(left) == a.charAt(right)) {
            left++;
            right--;
        }
        return left >= right;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CheckPalindromeFormation(string a, string b) {
        return checkConcatenation(a, b) || checkConcatenation(b, a);
    }

    public bool checkConcatenation(string a, string b) {
        int n = a.Length;
        int left = 0, right = n - 1;
        while (left < right && a[left] == b[right]) {
            left++;
            right--;
        }
        if (left >= right) {
            return true;
        }
        return CheckSelfPalindrome(a, left, right) || CheckSelfPalindrome(b, left, right);
    }

    public bool CheckSelfPalindrome(string a, int left, int right) {
        while (left < right && a[left] == a[right]) {
            left++;
            right--;
        }
        return left >= right;
    }
}
```

```go [sol1-Golang]
func checkPalindromeFormation(a, b string) bool {
    return checkConcatenation(a, b) || checkConcatenation(b, a)
}

func checkConcatenation(a, b string) bool {
    left, right := 0, len(a)-1
    for left < right && a[left] == b[right] {
        left++
        right--
    }
    if left >= right {
        return true
    }
    return checkSelfPalindrome(a[left:right+1]) || checkSelfPalindrome(b[left:right+1])
}

func checkSelfPalindrome(s string) bool {
    left, right := 0, len(s)-1
    for left < right && s[left] == s[right] {
        left++
        right--
    }
    return left >= right
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool checkSelfPalindrome(const string &a, int left, int right) {
        while (left < right && a[left] == a[right]) {
            left++;
            right--;
        }
        return left >= right;
    }

    bool checkConcatenation(const string &a, const string &b) {
        int n = a.size();
        int left = 0, right = n - 1;
        while (left < right && a[left] == b[right]) {
            left++;
            right--;
        }
        if (left >= right) {
            return true;
        }
        return checkSelfPalindrome(a, left, right) || checkSelfPalindrome(b, left, right);
    }

    bool checkPalindromeFormation(string a, string b) {
        return checkConcatenation(a, b) || checkConcatenation(b, a);
    }
};
```

```C [sol1-C]
bool checkSelfPalindrome(const char *a, int left, int right) {
    while (left < right && a[left] == a[right]) {
        left++;
        right--;
    }
    return left >= right;
}

bool checkConcatenation(const char *a, const char *b) {
    int n = strlen(a);
    int left = 0, right = n - 1;
    while (left < right && a[left] == b[right]) {
        left++;
        right--;
    }
    if (left >= right) {
        return true;
    }
    return checkSelfPalindrome(a, left, right) || checkSelfPalindrome(b, left, right);
}

bool checkPalindromeFormation(char * a, char * b){
    return checkConcatenation(a, b) || checkConcatenation(b, a);
}
```

```JavaScript [sol1-JavaScript]
var checkPalindromeFormation = function(a, b) {
    return checkConcatenation(a, b) || checkConcatenation(b, a);
}

const checkConcatenation = (a, b) => {
    const n = a.length;
    let left = 0, right = n - 1;
    while (left < right && a[left] === b[right]) {
        left++;
        right--;
    }
    if (left >= right) {
        return true;
    }
    return checkSelfPalindrome(a, left, right) || checkSelfPalindrome(b, left, right);
}

const checkSelfPalindrome = (a, left, right) => {
    while (left < right && a[left] === a[right]) {
        left++;
        right--;
    }
    return left >= right;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其实 $n$ 是输入字符串的长度。每个字符串最多遍历两遍。

- 空间复杂度：$O(1)$，仅使用常数空间。