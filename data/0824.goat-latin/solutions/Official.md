## [824.山羊拉丁文 中文官方题解](https://leetcode.cn/problems/goat-latin/solutions/100000/shan-yang-la-ding-wen-by-leetcode-soluti-1l55)
#### 方法一：找到每一个单词 + 模拟

**思路与算法**

我们可以对给定的字符串 $\textit{sentence}$ 进行一次遍历，找出其中的每一个单词，并根据题目的要求进行操作。

在寻找单词时，我们可以使用语言自带的 $\texttt{split()}$ 函数，将空格作为分割字符，得到所有的单词。为了节省空间，我们也可以直接进行遍历：每当我们遍历到一个空格或者到达 $\textit{sentence}$ 的末尾时，我们就找到了一个单词。

当我们得到一个单词 $w$ 后，我们首先需要判断 $w$ 的首字母是否为元音字母。我们可以使用一个哈希集合 $\textit{vowels}$ 存储所有的元音字母 $\text{aeiouAEIOU}$，这样只需要判断 $w$ 的首字母是否在 $\textit{vowels}$ 中。如果是元音字母，那么单词本身保持不变；如果是辅音字母，那么需要首字母移到末尾，这里使用语言自带的字符串切片函数即可。在这之后，我们需要在末尾添加 $\text{m}$ 以及若干个 $\text{a}$，因此可以使用一个变量 $\textit{cnt}$ 记录需要添加的 $\text{a}$ 的个数，它的初始值为 $1$，每当我们得到一个单词，就将它的值增加 $1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string toGoatLatin(string sentence) {
        unordered_set<char> vowels = {'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'};

        int n = sentence.size();
        int i = 0, cnt = 1;
        string ans;

        while (i < n) {
            int j = i;
            while (j < n && sentence[j] != ' ') {
                ++j;
            }

            ++cnt;
            if (cnt != 2) {
                ans += ' ';
            }
            if (vowels.count(sentence[i])) {
                ans += sentence.substr(i, j - i) + 'm' + string(cnt, 'a');
            }
            else {
                ans += sentence.substr(i + 1, j - i - 1) + sentence[i] + 'm' + string(cnt, 'a');
            }

            i = j + 1;
        }

        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String toGoatLatin(String sentence) {
        Set<Character> vowels = new HashSet<Character>() {{
            add('a');
            add('e');
            add('i');
            add('o');
            add('u');
            add('A');
            add('E');
            add('I');
            add('O');
            add('U');
        }};

        int n = sentence.length();
        int i = 0, cnt = 1;
        StringBuffer ans = new StringBuffer();

        while (i < n) {
            int j = i;
            while (j < n && sentence.charAt(j) != ' ') {
                ++j;
            }

            ++cnt;
            if (cnt != 2) {
                ans.append(' ');
            }
            if (vowels.contains(sentence.charAt(i))) {
                ans.append(sentence.substring(i, j));
            } else {
                ans.append(sentence.substring(i + 1, j));
                ans.append(sentence.charAt(i));
            }
            ans.append('m');
            for (int k = 0; k < cnt; ++k) {
                ans.append('a');
            }

            i = j + 1;
        }

        return ans.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ToGoatLatin(string sentence) {
        ISet<char> vowels = new HashSet<char>();
        vowels.Add('a');
        vowels.Add('e');
        vowels.Add('i');
        vowels.Add('o');
        vowels.Add('u');
        vowels.Add('A');
        vowels.Add('E');
        vowels.Add('I');
        vowels.Add('O');
        vowels.Add('U');

        int n = sentence.Length;
        int i = 0, cnt = 1;
        StringBuilder ans = new StringBuilder();

        while (i < n) {
            int j = i;
            while (j < n && sentence[j] != ' ') {
                ++j;
            }

            ++cnt;
            if (cnt != 2) {
                ans.Append(' ');
            }
            if (vowels.Contains(sentence[i])) {
                ans.Append(sentence.Substring(i, j - i));
            } else {
                ans.Append(sentence.Substring(i + 1, j - i - 1));
                ans.Append(sentence[i]);
            }
            ans.Append('m');
            for (int k = 0; k < cnt; ++k) {
                ans.Append('a');
            }

            i = j + 1;
        }

        return ans.ToString();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def toGoatLatin(self, sentence: str) -> str:
        vowels = {"a", "e", "i", "o", "u", "A", "E", "I", "O", "U"}

        n = len(sentence)
        i, cnt = 0, 1
        words = list()

        while i < n:
            j = i
            while j < n and sentence[j] != " ":
                j += 1
            
            cnt += 1
            if sentence[i] in vowels:
                words.append(sentence[i:j] + "m" + "a" * cnt)
            else:
                words.append(sentence[i+1:j] + sentence[i] + "m" + "a" * cnt)
            
            i = j + 1
        
        return " ".join(words)

```

```JavaScript [sol1-JavaScript]
var toGoatLatin = function(sentence) {
    const vowels = new Set();
    vowels.add('a');
    vowels.add('e');
    vowels.add('i');
    vowels.add('o');
    vowels.add('u');
    vowels.add('A');
    vowels.add('E');
    vowels.add('I');
    vowels.add('O');
    vowels.add('U');

    const n = sentence.length;
    let i = 0, cnt = 1;
    ans = '';

    while (i < n) {
        let j = i;
        while (j < n && sentence[j] !== ' ') {
            ++j;
        }

        ++cnt;
        if (cnt !== 2) {
            ans += ' ';
        }
        if (vowels.has(sentence[i])) {
            ans += sentence.substring(i, j);
        } else {
            ans += sentence.slice(i + 1, j);
            ans += sentence[i];
        }
        ans += 'm';
        for (let k = 0; k < cnt; ++k) {
            ans += 'a';
        }

        i = j + 1;
    }

    return ans;
};
```

```C [sol1-C]
#define MAX_LATIN_LEN 2048

char * toGoatLatin(char * sentence){
    int vowels[256];
    memset(vowels, 0, sizeof(vowels));
    vowels['a'] = 1;
    vowels['e'] = 1;
    vowels['i'] = 1;
    vowels['o'] = 1;
    vowels['u'] = 1;
    vowels['A'] = 1;
    vowels['E'] = 1;
    vowels['I'] = 1;
    vowels['O'] = 1;
    vowels['U'] = 1;

    int n = strlen(sentence);
    int i = 0, cnt = 1;
    char * ans = (char *)malloc(sizeof(char) * MAX_LATIN_LEN);
    int pos = 0;

    while (i < n) {
        int j = i;
        while (j < n && sentence[j] != ' ') {
            ++j;
        }

        ++cnt;
        if (cnt != 2) {
            ans[pos++] = ' ';
        }
        if (vowels[sentence[i]]) {
            memcpy(ans + pos, sentence + i, sizeof(char) * (j - i));
            pos += j - i;
            ans[pos++] = 'm';
            memset(ans + pos, 'a', cnt);
            pos += cnt;
        } else {
            memcpy(ans + pos, sentence + i + 1, sizeof(char) * (j - i - 1));
            pos += j - i - 1;
            ans[pos++] = sentence[i];
            ans[pos++] = 'm';
            memset(ans + pos, 'a', cnt);
            pos += cnt;
        }
        i = j + 1;
    }
    ans[pos] = 0;
    return ans;
}
```

```go [sol1-Golang]
var vowels = map[byte]struct{}{'a': {}, 'e': {}, 'i': {}, 'o': {}, 'u': {}, 'A': {}, 'E': {}, 'I': {}, 'O': {}, 'U': {}}

func toGoatLatin(sentence string) string {
    ans := &strings.Builder{}
    for i, cnt, n := 0, 1, len(sentence); i < n; i++ {
        if cnt > 1 {
            ans.WriteByte(' ')
        }
        start := i
        for i++; i < n && sentence[i] != ' '; i++ {}
        cnt++
        if _, ok := vowels[sentence[start]]; ok {
            ans.WriteString(sentence[start:i])
        } else {
            ans.WriteString(sentence[start+1 : i])
            ans.WriteByte(sentence[start])
        }
        ans.WriteByte('m')
        ans.WriteString(strings.Repeat("a", cnt))
    }
    return ans.String()
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是字符串 $\textit{sentence}$ 的长度。虽然我们对字符串只进行了常数次遍历，但是返回的字符串长度的数量级是 $O(n^2)$ 的。考虑最坏的情况，字符串 $\textit{sentence}$ 包含 $75$ 个单词 $\text{a}$，此时返回的字符串的长度为：

    $$
    75 + 75 + \sum_{i=2}^{76} i + 74
    $$

    这四部分分别为：单词 $\text{a}$ 的长度，添加的 $\text{m}$ 的长度，添加的 $\text{a}$ 的长度，空格的长度。

- 空间复杂度：$O(n^2)$ 或 $O(n)$，取决于使用的语言的字符串是否可修改。如果可以修改，我们只需要 $O(n)$ 的空间临时存储字符串切片；如果不可以修改，我们需要 $O(n^2)$ 的空间临时存储所有单词修改后的结果。注意这里不计入返回字符串使用的空间。