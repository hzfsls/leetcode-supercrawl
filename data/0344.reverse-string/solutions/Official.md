## [344.反转字符串 中文官方题解](https://leetcode.cn/problems/reverse-string/solutions/100000/fan-zhuan-zi-fu-chuan-by-leetcode-solution)

####  方法一：双指针

**思路与算法**

对于长度为 `N` 的待被反转的字符数组，我们可以观察反转前后下标的变化，假设反转前字符数组为 `s[0] s[1] s[2] ... s[N - 1]`，那么反转后字符数组为 `s[N - 1] s[N - 2] ... s[0]`。比较反转前后下标变化很容易得出 `s[i]` 的字符与 `s[N - 1 - i]` 的字符发生了交换的规律，因此我们可以得出如下双指针的解法：

- 将 `left` 指向字符数组首元素，`right` 指向字符数组尾元素。
- 当 `left < right`：
	- 交换  `s[left]`  和  `s[right]`；
	- `left` 指针右移一位，即 `left = left + 1`；
	- `right` 指针左移一位，即 `right = right - 1`。
- 当 `left >= right`，反转结束，返回字符数组即可。

![fig1](https://assets.leetcode-cn.com/solution-static/344/344_fig1.png)

**代码**

```C++ [sol1-C++]
class Solution {
public:
    void reverseString(vector<char>& s) {
        int n = s.size();
        for (int left = 0, right = n - 1; left < right; ++left, --right) {
            swap(s[left], s[right]);
        }
    }
};
```

```JavaScript [sol1-JavaScript]
var reverseString = function(s) {
    const n = s.length;
    for (let left = 0, right = n - 1; left < right; ++left, --right) {
        [s[left], s[right]] = [s[right], s[left]];
    }
};
```

```Java [sol1-Java]
class Solution {
    public void reverseString(char[] s) {
        int n = s.length;
        for (int left = 0, right = n - 1; left < right; ++left, --right) {
            char tmp = s[left];
            s[left] = s[right];
            s[right] = tmp;
        }
    }
}
```

```Golang [sol1-Golang]
func reverseString(s []byte) {
    for left, right := 0, len(s)-1; left < right; left++ {
        s[left], s[right] = s[right], s[left]
        right--
    }
}
```

```C [sol1-C]
void swap(char *a, char *b) {
    char t = *a;
    *a = *b, *b = t;
}

void reverseString(char *s, int sSize) {
    for (int left = 0, right = sSize - 1; left < right; ++left, --right) {
        swap(s + left, s + right);
    }
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为字符数组的长度。一共执行了 $N/2$ 次的交换。
- 空间复杂度：$O(1)$。只使用了常数空间来存放若干变量。