## [527.单词缩写 中文官方题解](https://leetcode.cn/problems/word-abbreviation/solutions/100000/dan-ci-suo-xie-by-leetcode-solution-oxaq)
[TOC]

#### 方法 1：贪心

 **概述**
 我们为每个单词选择最短的缩写。然后，当我们有重复时，我们会增加所有重复的长度。
 **算法**
 例如，我们有 `"aabaaa", "aacaaa", "aacdaa"`，然后我们开始用 `"a4a", "a4a", "a4a"`。由于这些都是重复的，我们将它们延长到 `"aa3a", "aa3a", "aa3a"`。它们仍然是重复的，所以我们将它们延长到 `"aab2a", "aac2a", "aac2a"`。最后两个仍然是重复的，所以我们将它们延长到 `"aacaaa", "aacdaa"`。
 在整个过程中，我们正在追踪一个索引 `prefix[i]`，它告诉我们要把前缀取到哪个索引。例如，`prefix[i] = 2` 意味着取 `word[0], word[1], word[2]` 的前缀。

 ```Java [slu1]
 class Solution {
    public List<String> wordsAbbreviation(List<String> words) {
        int N = words.size();
        String[] ans = new String[N];
        int[] prefix = new int[N];

        for (int i = 0; i < N; ++i)
            ans[i] = abbrev(words.get(i), 0);

        for (int i = 0; i < N; ++i) {
            while (true) {
                Set<Integer> dupes = new HashSet();
                for (int j = i+1; j < N; ++j)
                    if (ans[i].equals(ans[j]))
                        dupes.add(j);

                if (dupes.isEmpty()) break;
                dupes.add(i);
                for (int k: dupes)
                    ans[k] = abbrev(words.get(k), ++prefix[k]);
            }
        }

        return Arrays.asList(ans);
    }

    public String abbrev(String word, int i) {
        int N = word.length();
        if (N - i <= 3) return word;
        return word.substring(0, i+1) + (N - i - 2) + word.charAt(N-1);
    }
}
 ```

 ```Python [slu1]
 class Solution(object):
    def wordsAbbreviation(self, words):
        def abbrev(word, i = 0):
            if (len(word) - i <= 3): return word
            return word[:i+1] + str(len(word) - i - 2) + word[-1]

        N = len(words)
        ans = map(abbrev, words)
        prefix = [0] * N

        for i in xrange(N):
            while True:
                dupes = set()
                for j in xrange(i+1, N):
                    if ans[i] == ans[j]:
                        dupes.add(j)

                if not dupes: break
                dupes.add(i)
                for k in dupes:
                    prefix[k] += 1
                    ans[k] = abbrev(words[k], prefix[k])

        return ans
 ```

 **复杂性分析**

 * 时间复杂度：$O(C^2)$，其中 $C$ 是给定数组中所有单词的字符数。
 * 空间复杂度：$O(C)$。

---

 #### 方法 2：分组 + 最少公共前缀

 **概述**
 只有当两个单词有相同的第一个字母、最后一个字母和长度时，它们才有资格有相同的缩写。让我们根据这些属性对每个词进行分组，然后解决冲突。
 在每个组 `G` 中，如果一个词 `W` 和 `G` 中的任何其他词 `X` 有一个最长的公共前缀 `P`，那么我们的缩写必须包含超过 `|P|` 个字符的前缀。最长的公共前缀必须与 `W` 相邻的单词（按字典顺序）一起出现，所以我们可以只对 `G` 进行排序，然后查看相邻的单词。

**算法**

 ```Java [slu2]
 class Solution {
    public List<String> wordsAbbreviation(List<String> words) {
        Map<String, List<IndexedWord>> groups = new HashMap();
        String[] ans = new String[words.size()];

        int index = 0;
        for (String word: words) {
            String ab = abbrev(word, 0);
            if (!groups.containsKey(ab))
                groups.put(ab, new ArrayList());
            groups.get(ab).add(new IndexedWord(word, index));
            index++;
        }

        for (List<IndexedWord> group: groups.values()) {
            Collections.sort(group, (a, b) -> a.word.compareTo(b.word));

            int[] lcp = new int[group.size()];
            for (int i = 1; i < group.size(); ++i) {
                int p = longestCommonPrefix(group.get(i-1).word, group.get(i).word);
                lcp[i] = p;
                lcp[i-1] = Math.max(lcp[i-1], p);
            }

            for (int i = 0; i < group.size(); ++i)
                ans[group.get(i).index] = abbrev(group.get(i).word, lcp[i]);
        }

        return Arrays.asList(ans);
    }

    public String abbrev(String word, int i) {
        int N = word.length();
        if (N - i <= 3) return word;
        return word.substring(0, i+1) + (N - i - 2) + word.charAt(N-1);
    }

    public int longestCommonPrefix(String word1, String word2) {
        int i = 0;
        while (i < word1.length() && i < word2.length()
                && word1.charAt(i) == word2.charAt(i))
            i++;
        return i;
    }
}

class IndexedWord {
    String word;
    int index;
    IndexedWord(String w, int i) {
        word = w;
        index = i;
    }
}
 ```

 ```Python [slu2]
 class Solution(object):
    def wordsAbbreviation(self, words):
        def longest_common_prefix(a, b):
            i = 0
            while i < len(a) and i < len(b) and a[i] == b[i]:
                i += 1
            return i

        ans = [None for _ in words]

        groups = collections.defaultdict(list)
        for index, word in enumerate(words):
            groups[len(word), word[0], word[-1]].append((word, index))

        for (size, first, last), enum_words in groups.iteritems():
            enum_words.sort()
            lcp = [0] * len(enum_words)
            for i, (word, _) in enumerate(enum_words):
                if i:
                    word2 = enum_words[i-1][0]
                    lcp[i] = longest_common_prefix(word, word2)
                    lcp[i-1] = max(lcp[i-1], lcp[i])

            for (word, index), p in zip(enum_words, lcp):
                delta = size - 2 - p
                if delta <= 1:
                    ans[index] = word
                else:
                    ans[index] = word[:p+1] + str(delta) + last

        return ans
 ```

 **复杂性分析**

 * 时间复杂度：$O(C \log C)$，其中$C$是给定数组中所有单词的字符数。复杂度主要由排序步骤决定。
 * 空间复杂度：$O(C)$。

---



 #### 方法 3：分组 + 字典树

 **概述**

 如在 *方法 1* 中，我们根据长度，首字母，和尾字母将单词分组，并讨论组中的单词何时不共享最长的公共前缀。
 将一个组的单词放入字典树（前缀树），并在每个节点（表示一些前缀 `P`）计数有前缀 `P` 的词的数量。如果数目为 1，我们知道该前缀是唯一的。

**算法**

 ```Java [slu3]
 class Solution {
    public List<String> wordsAbbreviation(List<String> words) {
        Map<String, List<IndexedWord>> groups = new HashMap();
        String[] ans = new String[words.size()];

        int index = 0;
        for (String word: words) {
            String ab = abbrev(word, 0);
            if (!groups.containsKey(ab))
                groups.put(ab, new ArrayList());
            groups.get(ab).add(new IndexedWord(word, index));
            index++;
        }

        for (List<IndexedWord> group: groups.values()) {
            TrieNode trie = new TrieNode();
            for (IndexedWord iw: group) {
                TrieNode cur = trie;
                for (char letter: iw.word.substring(1).toCharArray()) {
                    if (cur.children[letter - 'a'] == null)
                        cur.children[letter - 'a'] = new TrieNode();
                    cur.count++;
                    cur = cur.children[letter - 'a'];
                }
            }

            for (IndexedWord iw: group) {
                TrieNode cur = trie;
                int i = 1;
                for (char letter: iw.word.substring(1).toCharArray()) {
                    if (cur.count == 1) break;
                    cur = cur.children[letter - 'a'];
                    i++;
                }
                ans[iw.index] = abbrev(iw.word, i-1);
            }
        }

        return Arrays.asList(ans);
    }

    public String abbrev(String word, int i) {
        int N = word.length();
        if (N - i <= 3) return word;
        return word.substring(0, i+1) + (N - i - 2) + word.charAt(N-1);
    }

}

class TrieNode {
    TrieNode[] children;
    int count;
    TrieNode() {
        children = new TrieNode[26];
        count = 0;
    }
}
class IndexedWord {
    String word;
    int index;
    IndexedWord(String w, int i) {
        word = w;
        index = i;
    }
}
 ```

 ```Python [slu3]
 class Solution(object):
    def wordsAbbreviation(self, words):
        groups = collections.defaultdict(list)
        for index, word in enumerate(words):
            groups[len(word), word[0], word[-1]].append((word, index))

        ans = [None] * len(words)
        Trie = lambda: collections.defaultdict(Trie)
        COUNT = False
        for group in groups.itervalues():
            trie = Trie()
            for word, _ in group:
                cur = trie
                for letter in word[1:]:
                    cur[COUNT] = cur.get(COUNT, 0) + 1
                    cur = cur[letter]

            for word, index in group:
                cur = trie
                for i, letter in enumerate(word[1:], 1):
                    if cur[COUNT] == 1: break
                    cur = cur[letter]
                if len(word) - i - 1 > 1:
                    ans[index] = word[:i] + str(len(word) - i - 1) + word[-1]
                else:
                    ans[index] = word
        return ans
 ```

 **复杂性分析**

 * 时间复杂度：$O(C)$，其中 $C$ 是给定数组中所有单词的字符数量。
 * 空间复杂度：$O(C)$。