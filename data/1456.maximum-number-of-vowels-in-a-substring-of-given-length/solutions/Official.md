#### 方法一：滑动窗口

我们可以遍历字符串 $s$ 每个长度为 $k$ 的子串，求出其中包含的元音字母个数，并找出最大值。

对于任意一个子串，假设它的长度为 $k$，结束位置为 $r$，我们用 $s_k(r)$ 来表示。如果 $s_k(r)$ 中包含了 $x$ 个元音字母，那么下一个相同长度的字符串（结束位置为 $k+1$）包含的元音字母个数即为

$$
s_k(r+1)~包含元音字母的个数 = x + (s[r+1]~为元音字母) - (s[r+1-k]~为元音字母)
$$

也就是说，$s_k(r+1)$ 比 $s_k(r)$ 少了字母 $s[r+1-k]$ 而多了字母 $s[r+1]$，因此上面的等式是成立的。

因此，我们可以首先求出 $s$ 的前 $k$ 个字母组成的子串包含的元音字母个数，随后我们使用上面的等式，不断地求出下一个长度为 $k$ 的子串包含的元音字母个数，直到子串与 $s$ 的结尾重合。这样以来，我们就遍历了每一个长度为 $k$ 的子串，也就得到了答案。

```C++ [sol1-C++]
class Solution {
public:
    bool isVowel(char ch) {
        return ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u'; 
    }
    
    int maxVowels(string s, int k) {
        int n = s.size();
        int vowel_count = 0;
        for (int i = 0; i < k; ++i) {
            vowel_count += isVowel(s[i]);
        }
        int ans = vowel_count;
        for (int i = k; i < n; ++i) {
            vowel_count += isVowel(s[i]) - isVowel(s[i - k]);
            ans = max(ans, vowel_count);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxVowels(self, s: str, k: int) -> int:
        def isVowel(ch):
            return int(ch in "aeiou")
        
        n = len(s)
        vowel_count = sum(1 for i in range(k) if isVowel(s[i]))
        ans = vowel_count
        for i in range(k, n):
            vowel_count += isVowel(s[i]) - isVowel(s[i - k])
            ans = max(ans, vowel_count)
        return ans
```

```Java [sol1-Java]
class Solution {
    public int maxVowels(String s, int k) {
        int n = s.length();
        int vowel_count = 0;
        for (int i = 0; i < k; ++i) {
            vowel_count += isVowel(s.charAt(i));
        }
        int ans = vowel_count;
        for (int i = k; i < n; ++i) {
            vowel_count += isVowel(s.charAt(i)) - isVowel(s.charAt(i - k));
            ans = Math.max(ans, vowel_count);
        }
        return ans;
    }

    public int isVowel(char ch) {
        return ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u' ? 1 : 0;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(|s|)$，其中 $|s|$ 是字符串 $s$ 的长度。我们首先需要 $O(k)$ 的时间求出前 $k$ 个字母组成的子串包含的元音字母个数，在这之后还有 $O(|s|-k)$ 个子串，每个子串包含的元音字母个数可以在 $O(1)$ 的时间计算出，因此总时间复杂度为 $O(|s|)$。

- 空间复杂度：$O(1)$。