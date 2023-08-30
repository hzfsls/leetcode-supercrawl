#### 方法一：枚举

由于 `minSize` 和 `maxSize` 都不超过 `26`，因此我们可以枚举所有长度在 `minSize` 与 `maxSize` 之间的字符串，选出其中字母数量小于等于的 `maxLetters` 的字符串并进行频数统计。

具体地，我们首先递增地枚举字符串的起始位置 `i` 以及结束位置 `j`。对于 `(i, j)` 对应的字符串，我们用一个集合 `exist` 存放其中出现的字母，并在递增地枚举 `j` 时，将对应位置的字母依次加入集合 `exist` 中。若集合中的字母数量不超过 `maxLetters`，并且字符串的长度在 `minSize` 与 `maxSize` 之间，那么我们就找到了一个满足条件的字符串。

我们使用一个无序映射（HashMap）存放所有满足条件的字符串。对于无序映射中的每个键值对，键表示字符串，值表示该字符串出现的次数。在枚举完所有的字符串后，无序映射中出现次数最多的那个字符串即为答案。

```C++ [sol1-C++]
class Solution {
public:
    int maxFreq(string s, int maxLetters, int minSize, int maxSize) {
        int n = s.size();
        unordered_map<string, int> occ;
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            unordered_set<char> exist;
            string cur;
            for (int j = i; j < min(n, i + maxSize); ++j) {
                exist.insert(s[j]);
                if (exist.size() > maxLetters) {
                    break;
                }
                cur += s[j];
                if (j - i + 1 >= minSize) {
                    ++occ[cur];
                    ans = max(ans, occ[cur]);
                }
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxFreq(self, s: str, maxLetters: int, minSize: int, maxSize: int) -> int:
        n = len(s)
        occ = collections.defaultdict(int)
        ans = 0
        for i in range(n):
            exist = set()
            cur = ""
            for j in range(i, min(n, i + maxSize)):
                exist.add(s[j])
                if len(exist) > maxLetters:
                    break
                cur += s[j]
                if j - i + 1 >= minSize:
                    occ[cur] += 1
                    ans = max(ans, occ[cur])
        return ans
```

**复杂度分析**

- 时间复杂度：$O(NS^2)$，其中 $N$ 是字符串的长度，$S$ 是 `minSize` 和 `maxSize` 的数量级，在本题中为 `26`。枚举 $i$ 的时间复杂度为 $O(N)$，枚举 $j$ 的时间复杂度为 $O(S)$，在这之后的操作会有两种情况：

  - 该语言的字符串类型允许对字符串进行修改，例如 `C++`。那么当 `i` 固定时，随着 `j` 的增加，得到 `(i, j)` 对应字符串的时间复杂度为 $O(1)$，即只要在结束位置为 `j - 1` 的字符串结尾添加一个字母，但我们需要 $O(S)$ 的时间将一个字符串无序映射中，这是因为无序映射中保存的是字符串的值；

  - 该语言的字符串类型不允许对字符串进行修改，例如 `Java` 和 `Python`。那么当 `i` 固定时，随着 `j` 的增加，我们每次都需要 $O(S)$ 的时间得到 `(i, j)` 对应的字符串，但只需要 $O(1)$ 的时间将一个字符串加入无序映射中，这是因为无序映射中保存的是字符串的引用。

  同时，由于无序映射的底层实现本质上是哈希算法，因此无论是哪一种情况（保存字符串的值或引用），在将字符串加入无序映射时，都需要花费一定的时间计算字符串的哈希值。不同的语言计算字符串哈希值的方法不同，但时间复杂度均为 $O(S)$，与字符串的长度成正比。综上所述，对于每一组 `(i, j)` 对应的字符串，我们需要 $O(S)$ 的时间进行相关的操作，总时间复杂度为 $O(NS^2)$。

- 空间复杂度：$O(NS^2)$。我们需要枚举所有长度在 `minSize` 与 `maxSize` 之间的字符串，在最坏情况下，这些字符串均满足条件且几乎不相同（即大部分字符串仅出现一次）。此时无序映射中需要存储所有字符串，数量为 $O(NS)$，而字符串的长度为 $O(S)$，因此总空间复杂度为 $O(NS^2)$。

#### 方法二：可行性优化

方法一的时间复杂度较高，上文给出的代码刚好可以在规定时间内通过所有数据，那么我们是否可以进行一些优化呢？

假设字符串 `T` 在给定的字符串 `S` 中出现的次数为 `k`，那么 `T` 的任意一个子串出现的次数至少也为 `k`，即 `T` 的任意一个子串在 `S` 中出现的次数不会少于 `T` 本身。这样我们就可以断定，在所有满足条件且出现次数最多的的字符串中，一定有一个的长度恰好为 `minSize`。

我们可以使用反证法证明上述的结论：假设所有满足条件且出现次数最多的字符串中没有长度为 `minSize` 的，不妨任取其中的一个长度为 `l` 的字符串，根据假设，有 `l > minSize`。此时我们再任取该字符串的一个长度为 `minSize` 的子串，子串出现的次数不会少于原字符串出现的次数，与假设相矛盾。

这样以来，我们只需要枚举所有长度为 `minSize` 的字符串即可，时空复杂度均减少了 $O(S)$。

```C++ [sol2-C++]
class Solution {
public:
    int maxFreq(string s, int maxLetters, int minSize, int maxSize) {
        int n = s.size();
        unordered_map<string, int> occ;
        int ans = 0;
        for (int i = 0; i < n - minSize + 1; ++i) {
            string cur = s.substr(i, minSize);
            unordered_set<char> exist(cur.begin(), cur.end());
            if (exist.size() <= maxLetters) {
                string cur = s.substr(i, minSize);
                ++occ[cur];
                ans = max(ans, occ[cur]);
            }
        }
        return ans;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def maxFreq(self, s: str, maxLetters: int, minSize: int, maxSize: int) -> int:
        n = len(s)
        occ = collections.defaultdict(int)
        ans = 0
        for i in range(n - minSize + 1):
            cur = s[i : i + minSize]
            exist = set(cur)
            if len(exist) <= maxLetters:
                occ[cur] += 1
                ans = max(ans, occ[cur])
        return ans
```

**复杂度分析**

- 时间复杂度：$O(NS)$，其中 $N$ 是字符串的长度，$S$ 是 `minSize` 和 `maxSize` 的数量级。

- 空间复杂度：$O(NS)$。

#### 方法三：滚动哈希

**说明**

方法二的时空复杂度已经较为优秀，且无论在竞赛还是面试中，能够将方法二实现都是值得称赞的。而方法三可以忽略题目中 `1 <= minSize <= maxSize <= min(26, s.length)` 的条件，在 `minSize` 和 `maxSize` 为任意值的情况下，均可以在合理的时间得到答案。

方法三需要一些关于「滚动哈希」或「Rabin-Karp 算法」的预备知识，其核心是将字符串看成一个 `k` 进制的整数，其中 `k` 是字符串中可能出现的字符种类，本题中字符串只包含小写字母，即 `k = 26`。这样做的好处是绕开了字符串操作，将字符串看成整数进行比较，使得无论语言的字符串类型是否允许对字符串进行修改，都可以在常数时间内将字符串加入无序映射中。

关于「滚动哈希」或「Rabin-Karp 算法」的知识，可以参考 [1044. 最长重复子串的官方题解](https://leetcode-cn.com/problems/longest-duplicate-substring/solution/zui-chang-zhong-fu-zi-chuan-by-leetcode/) 或使用搜索引擎，这里对算法本身的流程不再赘述。

**使用滚动哈希**

我们在方法二的基础上进行优化，在枚举长度为 `minSize` 的子串时，使用一个长度为 `minSize` 的滑动窗口表示当前的子串。这样在窗口向右滑动时，我们可以使用 Rabin-Karp 算法在 $O(1)$ 的时间计算出子串对应的整数值。

同时我们也需要优化维护 `exist` 的时间成本。在方法一和方法二中，由于得到一个子串需要 $O(S)$ 的时间，而通过将子串中的字母依次加入 `exist` 中来判断不同字母数目的做法同样需要 $O(S)$ 的时间，两者的时间复杂度相加，仍然为 $O(S)$。而在方法三中，由于得到一个子串需要的时间减少至 $O(1)$，因此我们需要借助滑动窗口，将维护 `exist` 需要的时间减少至 $O(1)$，才能降低总时间复杂度。

我们可以将 `exist` 从集合改为无序映射，对于其中的每个键值对，键表示字母，值表示字母出现的次数。当滑动窗口向右滑动一个字母时，头部的一个字母被移除窗口，尾部的一个字母被加入窗口，则：

- 当一个字母 `c` 被移除窗口时，我们将 `c` 对应的值减 `1`，如果值变为 `0`，说明子串中不同字母的数量也减少 `1`；

- 当一个字母 `c` 被加入窗口时，我们将 `c` 对应的值加 `1`，如果值变为 `1`，说明子串中不同字母的数量也增加 `1`。

这样我们就可以在滑动窗口向右滑动一个字母时，使用 $O(1)$ 的时间同时得到子串对应的整数值以及其包含不同字符的数量。整个算法的时间复杂度与 `minSize` 无关。

**注意事项**

由于 Rabin-Karp 算法会将字符串对应的整数值进行取模，那么：

- 如果字符串 `S1` 和 `S2` 对应的整数值 `I1` 和 `I2` 不相等，那么 `S1` 和 `S2` 一定不相等；

- 如果字符串 `S1` 和 `S2` 对应的整数值 `I1` 和 `I2` 相等，并不代表 `S1` 和 `S2` 一定相等；

这与实际应用中使用的哈希算法也是一致的，即先判断两个实例的哈希值是否相等，再判断它们本质上是否相等。而在竞赛题目中，由于数据量较少，几乎不会产生哈希冲突，因此我们可以直接用 `I1` 和 `I2` 的相等代替 `S1` 和 `S2` 的相等，减少时间复杂度。但需要牢记在实际应用中，这样做是不严谨的。

```C++ [sol3-C++]
using LL = long long;

class Solution {
private:
    static constexpr int mod = 1000000007;

public:
    int maxFreq(string s, int maxLetters, int minSize, int maxSize) {
        int n = s.size();
        unordered_map<int, int> occ;
        unordered_map<char, int> exist;
        int ans = 0, exist_cnt = 0;
        int rabin = 0, base = 26, base_mul = base;
        
        for (int i = 0; i < minSize - 1; ++i) {
            ++exist[s[i]];
            if (exist[s[i]] == 1) {
                ++exist_cnt;
            }
            rabin = ((LL)rabin * base + (s[i] - 97)) % mod;
            base_mul = (LL)base_mul * base % mod;
        }

        for (int i = minSize - 1; i < n; ++i) {
            ++exist[s[i]];
            if (exist[s[i]] == 1) {
                ++exist_cnt;
            }
            rabin = ((LL)rabin * base + (s[i] - 97)) % mod;
            if (i >= minSize) {
                --exist[s[i - minSize]];
                if (exist[s[i - minSize]] == 0) {
                    --exist_cnt;
                }
                rabin = (rabin - (LL)base_mul * (s[i - minSize] - 97) % mod + mod) % mod;
            }
            if (exist_cnt <= maxLetters) {
                ++occ[rabin];
                ans = max(ans, occ[rabin]);
            }
        }
        return ans;
    }
};
```

```Python [sol3-Python3]
class Solution:
    def maxFreq(self, s: str, maxLetters: int, minSize: int, maxSize: int) -> int:
        n = len(s)
        occ = collections.defaultdict(int)
        exist = collections.defaultdict(int)
        mod = 1e9 + 7
        ans, exist_cnt = 0, 0
        rabin, base, base_mul = 0, 26, 26

        for i in range(minSize - 1):
            exist[s[i]] += 1
            if exist[s[i]] == 1:
                exist_cnt += 1
            rabin = (rabin * base + (ord(s[i]) - 97)) % mod
            base_mul = base_mul * base % mod

        for i in range(minSize - 1, n):
            exist[s[i]] += 1
            if exist[s[i]] == 1:
                exist_cnt += 1
            rabin = (rabin * base + (ord(s[i]) - 97)) % mod
            if i >= minSize:
                exist[s[i - minSize]] -= 1
                if exist[s[i - minSize]] == 0:
                    exist_cnt -= 1
                rabin = (rabin - base_mul * (ord(s[i - minSize]) - 97) % mod + mod) % mod
            if exist_cnt <= maxLetters:
                occ[rabin] += 1
                ans = max(ans, occ[rabin])
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是字符串的长度。

- 空间复杂度：$O(N)$。