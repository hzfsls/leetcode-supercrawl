## [1078.Bigram 分词 中文官方题解](https://leetcode.cn/problems/occurrences-after-bigram/solutions/100000/bigram-fen-ci-by-leetcode-solution-7q3e)

#### 方法一：遍历

**思路与算法**

我们将文本 $\textit{text}$ 按空格分割成单词数组 $\textit{words}$，然后遍历 $\textit{words}$ 数组，如果一个单词的前两个单词分别按顺序等于 $\textit{first}$ 和 $\textit{second}$，则该单词符合第三个单词 $\textit{third}$ 的定义, 将其加入结果中。

**代码**

```C [sol1-C]
char ** findOcurrences(char * text, char * first, char * second, int* returnSize){
    int s = 0, e = 0, len = strlen(text);
    char **words = (char **)malloc(sizeof(char *) * len);
    memset(words, 0, sizeof(char *) * len);
    int nwords = 0;
    while (true) {
        while (s < len && text[s] == ' ') {
            s++;
        }
        if (s >= len) {
            break;
        }
        e = s + 1;
        while (e < len && text[e] != ' ') {
            e++;
        }
        words[nwords++] = strndup(text + s, e - s);
        s = e + 1;
    }
    char **ret = (char **)malloc(sizeof(char *) * (nwords + 1));
    memset(ret, 0, sizeof(char *) * (nwords + 1));
    int nret = 0;
    for (int i = 2; i < nwords; i++) {
        if (strcmp(words[i - 2], first) == 0 && strcmp(words[i - 1], second) == 0) {
            ret[nret++] = strdup(words[i]);
        }
    }
    for (int i = 0; i < nwords; i++) {
        free(words[i]);
    }
    free(words);
    *returnSize = nret;
    return ret;
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> findOcurrences(string text, string first, string second) {
        vector<string> words;
        int s = 0, e = 0, len = text.length();
        while (true) {
            while (s < len && text[s] == ' ') {
                s++;
            }
            if (s >= len) {
                break;
            }
            e = s + 1;
            while (e < len && text[e] != ' ') {
                e++;
            }
            words.push_back(text.substr(s, e - s));
            s = e + 1;
        }
        vector<string> ret;
        for (int i = 2; i < words.size(); i++) {
            if (words[i - 2] == first && words[i - 1] == second) {
                ret.push_back(words[i]);
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String[] findOcurrences(String text, String first, String second) {
        String[] words = text.split(" ");
        List<String> list = new ArrayList<String>();
        for (int i = 2; i < words.length; i++) {
            if (words[i - 2].equals(first) && words[i - 1].equals(second)) {
                list.add(words[i]);
            }
        }
        int size = list.size();
        String[] ret = new String[size];
        for (int i = 0; i < size; i++) {
            ret[i] = list.get(i);
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string[] FindOcurrences(string text, string first, string second) {
        string[] words = text.Split(" ");
        IList<string> list = new List<string>();
        for (int i = 2; i < words.Length; i++) {
            if (words[i - 2].Equals(first) && words[i - 1].Equals(second)) {
                list.Add(words[i]);
            }
        }
        int size = list.Count;
        string[] ret = new string[size];
        for (int i = 0; i < size; i++) {
            ret[i] = list[i];
        }
        return ret;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findOcurrences(self, text: str, first: str, second: str) -> List[str]:
        words = text.split()
        return [words[i] for i in range(2, len(words)) if words[i - 2] == first and words[i - 1] == second]
```

```Go [sol1-Golang]
func findOcurrences(text, first, second string) (ans []string) {
    words := strings.Split(text, " ")
    for i := 2; i < len(words); i++ {
        if words[i-2] == first && words[i-1] == second {
            ans = append(ans, words[i])
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var findOcurrences = function(text, first, second) {
    const words = text.split(" ");
    const list = [];
    for (let i = 2; i < words.length; i++) {
        if (words[i - 2] === first && words[i - 1] === second) {
            list.push(words[i]);
        }
    }
    const size = list.length;
    const ret = Array(size).fill('');
    for (let i = 0; i < size; i++) {
        ret[i] = list[i];
    }
    return ret;
};
```

**复杂度分析**

+ 时间复杂度：$O(N)$，其中 $N$ 为 $\textit{text}$ 的长度。分割 $\textit{text}$ 需要 $O(N)$，$\textit{words}$ 每个元素最多访问两次，需要 $O(N)$，所以总的时间复杂度为 $O(N)$。

+ 空间复杂度：$O(N)$。需要 $O(N)$ 的空间来保存 $\textit{words}$ 数组。