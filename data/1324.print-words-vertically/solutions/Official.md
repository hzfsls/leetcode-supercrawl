#### 方法一：模拟

我们只需要顺着题目的要求进行模拟即可：

- 第一步：将字符串 `s` 进行分词。在 `Python` 中可以直接使用 `split()` 函数对字符串进行分词，而在 `C++` 中没有相关的函数，但可以借助 `std::stringstream` 类，将字符串 `s` 作为输入流，从中依次读取单词；

- 第二步：统计最长的单词长度。对于我们返回的字符串列表，它的长度等于最长的单词长度，其中每个元素的长度等于单词的数量；

- 第三步：得到字符串列表中的每个元素。对于字符串列表中的第 `i` 个元素，它由所有单词的第 `i` 个字母组成。我们依次遍历所有的单词，若单词中有第 `i` 个字母，则将该字母加入元素的末尾；若没有第 `i` 个字母，则将空格加入元素的末尾；

- 第四步：去除尾随空格。在 `Python` 中可以直接使用 `rstrip()` 函数去除尾随空格，而在 `C++` 中没有相关的函数，可以使用循环将字符串末尾的空格依次弹出，或使用 `string::find_last_not_of()` 函数找到字符串最右侧的非空格字符，再使用 `string::substr()` 函数得到不包含尾随空格的字符串。

```C++ [sol1-C++]
class Solution {
public:
    vector<string> printVertically(string s) {
        stringstream in(s);
        vector<string> words;
        string _word;
        int maxlen = 0;
        while (in >> _word) {
            words.push_back(_word);
            maxlen = max(maxlen, (int)_word.size());
        }
        vector<string> ans;
        for (int i = 0; i < maxlen; ++i) {
            string concat;
            for (string& word: words) {
                concat += (i < word.size() ? word[i] : ' ');
            }
            while (concat.back() == ' ') {
                concat.pop_back();
            }
            ans.push_back(move(concat));
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def printVertically(self, s: str) -> List[str]:
        words = s.split()
        maxlen = max(len(word) for word in words)
        ans = list()
        for i in range(maxlen):
            concat = "".join([word[i] if i < len(word) else " " for word in words])
            ans.append(concat.rstrip())
        return ans

```

```Python [sol1-Python3-1Line]
class Solution:
    def printVertically(self, s: str) -> List[str]:
        return ["".join(x).rstrip() for x in itertools.zip_longest(*s.split(), fillvalue=" ")]
```

**复杂度分析**

- 时间复杂度：$O(N\max(|S|))$，其中 $N$ 是字符串 `s` 中的单词个数，$\max(|S|)$ 是最长的单词长度。

- 空间复杂度：$O(N\max(|S|))$。