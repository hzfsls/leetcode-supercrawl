#### 方法一：使用额外空间

**思路与算法**

开辟一个新字符串。然后从头到尾遍历原字符串，直到找到空格为止，此时找到了一个单词，并能得到单词的起止位置。随后，根据单词的起止位置，可以将该单词逆序放到新字符串当中。如此循环多次，直到遍历完原字符串，就能得到翻转后的结果。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string reverseWords(string s) {
        string ret;
        int length = s.length();
        int i = 0;
        while (i < length) {
            int start = i;
            while (i < length && s[i] != ' ') {
                i++;
            }
            for (int p = start; p < i; p++) {
                ret.push_back(s[start + i - 1 - p]);
            }
            while (i < length && s[i] == ' ') {
                i++;
                ret.push_back(' ');
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String reverseWords(String s) {
        StringBuffer ret = new StringBuffer();
        int length = s.length();
        int i = 0;
        while (i < length) {
            int start = i;
            while (i < length && s.charAt(i) != ' ') {
                i++;
            }
            for (int p = start; p < i; p++) {
                ret.append(s.charAt(start + i - 1 - p));
            }
            while (i < length && s.charAt(i) == ' ') {
                i++;
                ret.append(' ');
            }
        }
        return ret.toString();
    }
}
```

```JavaScript [sol1-JavaScript]
var reverseWords = function(s) {
    const ret = [];
    const length = s.length;
    let i = 0;
    while (i < length) {
        let start = i;
        while (i < length && s.charAt(i) != ' ') {
            i++;
        }
        for (let p = start; p < i; p++) {
            ret.push(s.charAt(start + i - 1 - p));
        }
        while (i < length && s.charAt(i) == ' ') {
            i++;
            ret.push(' ');
        }
    }
    return ret.join('');
};
```

```C [sol1-C]
char* reverseWords(char* s) {
    int length = strlen(s);
    char* ret = (char*)malloc(sizeof(char) * (length + 1));
    ret[length] = 0;
    int i = 0;
    while (i < length) {
        int start = i;
        while (i < length && s[i] != ' ') {
            i++;
        }
        for (int p = start; p < i; p++) {
            ret[p] = s[start + i - 1 - p];
        }
        while (i < length && s[i] == ' ') {
            ret[i] = ' ';
            i++;
        }
    }
    return ret;
}
```

```golang [sol1-Golang]
func reverseWords(s string) string {
    length := len(s)
    ret := []byte{}
    for i := 0; i < length; {
        start := i
        for i < length && s[i] != ' ' {
            i++
        }
        for p := start; p < i; p++ {
            ret = append(ret, s[start + i - 1 - p])
        }
        for i < length && s[i] == ' ' {
            i++
            ret = append(ret, ' ')
        }
    }
    return string(ret)
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为字符串的长度。原字符串中的每个字符都会在 $O(1)$ 的时间内放入新字符串中。

- 空间复杂度：$O(N)$。我们开辟了与原字符串等大的空间。

#### 方法二：原地解法

**思路与算法**

此题也可以直接在原字符串上进行操作，避免额外的空间开销。当找到一个单词的时候，我们交换字符串第一个字符与倒数第一个字符，随后交换第二个字符与倒数第二个字符……如此反复，就可以在原空间上翻转单词。

需要注意的是，原地解法在某些语言（比如 Java，JavaScript）中不适用，因为在这些语言中 `String` 类型是一个不可变的类型。

**代码**

```C++ [sol2-C++]
class Solution {
public: 
    string reverseWords(string s) {
        int length = s.length();
        int i = 0;
        while (i < length) {
            int start = i;
            while (i < length && s[i] != ' ') {
                i++;
            }

            int left = start, right = i - 1;
            while (left < right) {
                swap(s[left], s[right]);
                left++;
                right--;
            }
            while (i < length && s[i] == ' ') {
                i++;
            }
        }
        return s;
    }
};
```

```C [sol2-C]
char* reverseWords(char* s) {
    int length = strlen(s);
    int i = 0;
    while (i < length) {
        int start = i;
        while (i < length && s[i] != ' ') {
            i++;
        }

        int left = start, right = i - 1;
        while (left < right) {
            char tmp = s[left];
            s[left] = s[right], s[right] = tmp;
            left++;
            right--;
        }
        while (i < length && s[i] == ' ') {
            i++;
        }
    }
    return s;
}
```

**复杂度分析**

- 时间复杂度：$O(N)$。字符串中的每个字符要么在 $O(1)$ 的时间内被交换到相应的位置，要么因为是空格而保持不动。

- 空间复杂度：$O(1)$。因为不需要开辟额外的数组。