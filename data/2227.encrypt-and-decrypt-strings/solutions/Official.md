## [2227.加密解密字符串 中文官方题解](https://leetcode.cn/problems/encrypt-and-decrypt-strings/solutions/100000/jia-mi-jie-mi-zi-fu-chuan-by-leetcode-so-mqga)

#### 方法一：直接加密 + 预处理解密

**思路与算法**

我们首先可以使用 $\textit{enc}$ 哈希映射存储单个字母的加密关系，即对于 $\textit{enc}$ 中的每个键值对，键表示单个字母，值表示该字母加密得到的长度为 $2$ 的字符串。这样一来，对于 $\texttt{encrypt(word)}$ 操作，我们只需要遍历字符串 $\textit{word}$，对每个字母分别根据哈希映射进行加密，再合并结果得到最终的字符串即可。

而对于 $\texttt{decrypt(word)}$ 操作，如果我们直接按照题目中的要求进行分组、解密、判断是否在字典中，那么必然会使用深度优先搜索或者更高级的数据结构（例如字典树）。一种更简单的方法是「逆向思考」：我们直接把字典中的所有单词进行加密，如果该单词可以被加密，那么我们就将加密的结果存储在另一个哈希映射 $\textit{dec\_count}$ 中，键表示加密的结果，值表示该结果出现的次数（因为多个单词可以被加密成相同的结果）。这样一来，我们只需要返回 $\textit{word}$ 作为键在哈希映射中对应的值即可。

**代码**

```C++ [sol1-C++]
class Encrypter {
private:
    unordered_map<char, string> enc;
    unordered_map<string, int> dec_count;
    
public:
    Encrypter(vector<char>& keys, vector<string>& values, vector<string>& dictionary) {
        int n = keys.size();
        for (int i = 0; i < n; ++i) {
            enc[keys[i]] = values[i];
        }
        
        for (const string& word: dictionary) {
            string result = encrypt(word);
            if (result != "") {
                ++dec_count[result];
            }
        }
    }
    
    string encrypt(string word1) {
        string result;
        for (char ch: word1) {
            if (enc.count(ch)) {
                result += enc[ch];
            }
            else {
                return "";
            }
        }
        return result;
    }
    
    int decrypt(string word2) {
        return dec_count.count(word2) ? dec_count[word2] : 0;
    }
};
```

```Python [sol1-Python3]
class Encrypter:

    def __init__(self, keys: List[str], values: List[str], dictionary: List[str]):
        self.enc = {key: value for key, value in zip(keys, values)}
        self.dec_count = Counter()
        for word in dictionary:
            if (result := self.encrypt(word)) != "":
                self.dec_count[result] += 1 

    def encrypt(self, word1: str) -> str:
        result = list()
        for ch in word1:
            if ch in self.enc:
                result.append(self.enc[ch])
            else:
                return ""
        return "".join(result)

    def decrypt(self, word2: str) -> int:
        return self.dec_count[word2] if word2 in self.dec_count else 0
```

**复杂度分析**

- 时间复杂度：

    - 初始化的时间复杂度为 $O(k + d \times l_d)$，其中 $k$ 分别是数组 $\textit{keys}$ 和 $\textit{values}$ 的长度，$d$ 是数组 $\textit{dictionary}$ 的长度，$l_d$ 是数组 $\textit{dictionary}$ 中单词的平均长度；

    - $\texttt{encrypt(word)}$ 的时间复杂度为 $O(|\textit{word}|)$；

    - $\texttt{decrypt(word)}$ 的时间复杂度为 $O(|\textit{word}|)$。

- 空间复杂度：$O(k + d \times l_d)$，即为两个哈希映射需要使用的空间。