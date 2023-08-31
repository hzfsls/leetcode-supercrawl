## [1160.拼写单词 中文官方题解](https://leetcode.cn/problems/find-words-that-can-be-formed-by-characters/solutions/100000/pin-xie-dan-ci-by-leetcode-solution)

### 📺 视频题解  
![1160. 拼写单词 1.mp4](00067219-da0f-4f84-9d10-7a13053bf870)

### 📖 文字题解

#### 方法一：哈希表记数

**思路和算法**

显然，对于一个单词 `word`，只要其中的每个字母的数量都不大于 `chars` 中对应的字母的数量，那么就可以用 `chars` 中的字母拼写出 `word`。所以我们只需要用一个哈希表存储 `chars` 中每个字母的数量，再用一个哈希表存储 `word` 中每个字母的数量，最后将这两个哈希表的键值对逐一进行比较即可。

```C++ [sol1-C++]
class Solution {
public:
    int countCharacters(vector<string>& words, string chars) {
        unordered_map<char, int> chars_cnt;
        for (char c : chars) {
            ++chars_cnt[c];
        }
        int ans = 0;
        for (string word : words) {
            unordered_map<char, int> word_cnt;
            for (char c : word) {
                ++word_cnt[c];
            }
            bool is_ans = true;
            for (char c : word) {
                if (chars_cnt[c] < word_cnt[c]) {
                    is_ans = false;
                    break;
                }
            }
            if (is_ans) {
                ans += word.size();
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countCharacters(String[] words, String chars) {
        Map<Character, Integer> charsCnt = new HashMap<Character, Integer>();
        int length = chars.length();
        for (int i = 0; i < length; ++i) {
            char c = chars.charAt(i);
            charsCnt.put(c, charsCnt.getOrDefault(c, 0) + 1);
        }
        int ans = 0;
        for (String word : words) {
            Map<Character, Integer> wordCnt = new HashMap<Character, Integer>();
            int wordLength = word.length();
            for (int i = 0; i < wordLength; ++i) {
                char c = word.charAt(i);
                wordCnt.put(c, wordCnt.getOrDefault(c, 0) + 1);
            }
            boolean isAns = true;
            for (int i = 0; i < wordLength; ++i) {
                char c = word.charAt(i);
                if (charsCnt.getOrDefault(c, 0) < wordCnt.getOrDefault(c, 0)) {
                    isAns = false;
                    break;
                }
            }
            if (isAns) {
                ans += word.length();
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def countCharacters(self, words: List[str], chars: str) -> int:
        chars_cnt = collections.Counter(chars)
        ans = 0
        for word in words:
            word_cnt = collections.Counter(word)
            for c in word_cnt:
                if chars_cnt[c] < word_cnt[c]:
                    break
            else:
                ans += len(word)
        return ans
```

**复杂度分析**

  - 时间复杂度：$O(n)$，其中 $n$ 为所有字符串的长度和。我们需要遍历每个字符串，包括 `chars` 以及数组 `words` 中的每个单词。

  - 空间复杂度：$O(S)$，其中 $S$ 为字符集大小，在本题中 $S$ 的值为 $26$（所有字符串仅包含小写字母）。程序运行过程中，最多同时存在两个哈希表，使用的空间均不超过字符集大小 $S$，因此空间复杂度为 $O(S)$。