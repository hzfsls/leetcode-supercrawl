#### 方法一：两次哈希计数

题目要求制造字母异位词，所以字母的位置不需要考虑，只需要考虑每种字母的数量。使用哈希表对字母进行计数。计数结束后，检查字符串 $s$ 的哪些字母比字符串 $t$ 中的少，那么 $s$ 需要通过变换补齐这些字母来构造 $t$ 的字母异位词。$s$ 需要补的字母的数量即为需要的步数。

```python []
class Solution:
    def minSteps(self, s: str, t: str) -> int:
        s_cnt = collections.Counter(s)
        t_cnt = collections.Counter(t)
        ans = 0
        for c in set(s_cnt.keys()).union(set(t_cnt.keys())):
            if s_cnt[c] < t_cnt[c]:
                ans += t_cnt[c] - s_cnt[c]
        return ans
```

```C++ []
class Solution {
public:
    int minSteps(string s, string t) {
        int s_cnt[26] = {0};
        int t_cnt[26] = {0};
        for (char c : s)
            ++s_cnt[c - 'a'];
        for (char c : t)
            ++t_cnt[c - 'a'];
        int ans = 0;
        for (int i = 0; i != 26; ++i)
            if (s_cnt[i] < t_cnt[i])
                ans += t_cnt[i] - s_cnt[i];
        return ans;
    }
};
```

##### 复杂度分析：

  * 时间复杂度：$O(n)$，$n$ 为字符串 $s$ 与 $t$ 的长度之和
    哈希表的查询时间复杂度为 $O(1)$，查询次数为 $O(n)$，综合起来，时间复杂度为 $O(n)$。
  * 空间复杂度：$O(1)$
    哈希表中存放的元素至多为 26 个，因此内存需求不会随着字符串的变长而增加。

#### 方法二：单次哈希计数

观察方法一，可以发现，两个次数器之间只有求差值的操作。因此，可以将 $t$ 的计数过程直接改为与 $s$ 的计数求差值，而不需要对 $t$ 进行完整的计数。这样做可以进一步减少哈希表的内存消耗。

```python []
class Solution:
    def minSteps(self, s: str, t: str) -> int:
        s_cnt = collections.Counter(s)
        ans = 0
        for char in t:
            if s_cnt[char] > 0:
                s_cnt[char] -= 1
            else:
                ans += 1
        return ans
```

```C++ []
class Solution {
public:
    int minSteps(string s, string t) {
        int s_cnt[26] = {0};
        for (char c : s)
            ++s_cnt[c - 'a'];
        int ans = 0;
        for (char c : t)
            if (s_cnt[c - 'a'] == 0)
                ++ans;
            else
                --s_cnt[c - 'a'];
        return ans;
    }
};
```

##### 复杂度分析：

  * 时间复杂度：$O(n)$，$n$ 为字符串 $s$ 与 $t$ 的长度之和
    哈希表的查询时间复杂度为 $O(1)$，查询次数为 $O(n)$，综合起来，时间复杂度为 $O(n)$。
  * 空间复杂度：$O(1)$
    哈希表中存放的元素至多为 26 个，因此内存需求不会随着字符串的变长而增加。