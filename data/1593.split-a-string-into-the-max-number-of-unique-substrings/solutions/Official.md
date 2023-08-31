## [1593.拆分字符串使唯一子字符串的数目最大 中文官方题解](https://leetcode.cn/problems/split-a-string-into-the-max-number-of-unique-substrings/solutions/100000/chai-fen-zi-fu-chuan-shi-wei-yi-zi-zi-fu-chuan-de-)

#### 方法一：回溯

拆分给定的字符串，要求拆分后的每个子字符串唯一，求子字符串的最大数目，可以通过回溯算法实现。

对于长度为 $n$ 的字符串，有 $n-1$ 个拆分点。从左到右遍历字符串，对于每个拆分点，如果在此拆分之后，新得到的一个非空子字符串（即拆分点左侧的最后一个被拆分出的非空子字符串）与之前拆分出的非空子字符串都不相同，则当前的拆分点可以进行拆分，然后继续对剩下的部分（即拆分点右侧的部分）进行拆分。

判断拆分出的非空子字符串是否有重复时，可以使用哈希表。

当整个字符串拆分完毕时，计算拆分得到的非空子字符串的数目，并更新最大数目。

```Java [sol1-Java]
class Solution {
    int maxSplit = 1;

    public int maxUniqueSplit(String s) {
        Set<String> set = new HashSet<String>();
        backtrack(0, 0, s, set);
        return maxSplit;
    }

    public void backtrack(int index, int split, String s, Set<String> set) {
        int length = s.length();
        if (index >= length) {
            maxSplit = Math.max(maxSplit, split);
        } else {
            for (int i = index; i < length; i++) {
                String substr = s.substring(index, i + 1);
                if (set.add(substr)) {
                    backtrack(i + 1, split + 1, s, set);
                    set.remove(substr);
                }
            }
        }
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    int maxSplit;

    void backtrack(int index, int split, string &s, unordered_set<string> &us) {
        int length = s.size();
        if (index >= length) {
            maxSplit = max(maxSplit, split);
        } else {
            for (int i = index; i < length; i++) {
                string substr = s.substr(index, i - index + 1);
                if (us.find(substr) == us.end()) {
                    us.insert(substr);
                    backtrack(i + 1, split + 1, s, us);
                    us.erase(substr);
                }
            }
        }
    }

    int maxUniqueSplit(string s) {
        maxSplit = 1;
        unordered_set<string> us;
        backtrack(0, 0, s, us);
        return maxSplit;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxUniqueSplit(self, s: str) -> int:
        def backtrack(index: int, split: int):
            if index >= length:
                nonlocal maxSplit
                maxSplit = max(maxSplit, split)
            else:
                for i in range(index, length):
                    substr = s[index:i+1]
                    if substr not in seen:
                        seen.add(substr)
                        backtrack(i + 1, split + 1)
                        seen.remove(substr)

        length = len(s)
        seen = set()
        maxSplit = 1
        backtrack(0, 0)
        return maxSplit
```

**复杂度分析**

- 时间复杂度：$O(2^n \times n)$，其中 $n$ 是字符串的长度。
  回溯过程会遍历所有可能的拆分方案，长度为 $n$ 的字符串有 $n-1$ 个拆分点，每个拆分点都可以选择拆分或者不拆分，因此共有 $2^{n-1}$ 种拆分方案。
  对于每种拆分方案，都需要判断拆分出的非空子字符串是否有重复，时间复杂度是 $O(n)$。
  因此总时间复杂度是 $O(2^n \times n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是字符串的长度。空间复杂度取决于集合的大小以及回溯过程中的递归调用层数。集合中的元素个数不会超过 $n$，递归调用层数不会超过 $n$。