## [1520.最多的不重叠子字符串 中文官方题解](https://leetcode.cn/problems/maximum-number-of-non-overlapping-substrings/solutions/100000/zui-duo-de-bu-zhong-die-zi-zi-fu-chuan-by-leetcode)
#### 方法一：贪心

**思路与算法**

由于题目要求「如果一个子字符串包含字符 $c$，那么 $s$ 中所有 $c$ 字符都应该在这个子字符串中」，且我们要使最后的总长度尽可能的小，因此最多不会有超过字符集大小 $\Sigma$ 数量的子字符串。假设当前找到了包含字符 $a$ 的符合条件的最短字符串 $s[l_a, r_a]$，看起来 $s[l_a-1,r_a]$ 或者 $s[l_a,r_a +1]$ 也可能作为一个符合条件的字符串，但是我们要使最后的「长度和最小」，因此我们只需要关注包含每个字符的「最短字符串」即可。

所以解决问题的第一步是需要预处理出字符集中每个字符对应的最短字符串，由于字符集很小，我们可以暴力处理这一部分的答案。我们先遍历字符串，确定字符 $i$ 第一次出现的位置 $l_i$ 和最后一次出现的位置 $r_i$，由于 $[l_i,r_i]$ 中间可能存在其他字符，因此为了满足题目的第二点要求，我们需要遍历 $[l_i,r_i]$ 中的所有字符，利用它们的左右端点来更新 $l_i$ 和 $r_i$，保证「如果一个子字符串包含字符 $c$，那么 $s$ 中所有 $c$ 字符都应该在这个子字符串中」。

预处理完以后，我们将每个字符串的起始位置看作一个个线段 $[l_i,r_i]$，问题就转化成了**有一个 $[0, n-1]$ 的一维数轴，其中 $n=s.\textit{length}$，我们需要用尽可能多的线段去覆盖这个数轴，且线段间互不相交，线段之和最小**。这是一个很经典的贪心问题，我们只需要将得到的线段按右端点为第一关键字，长度为第二关键字排序，然后从前往后遍历线段，每次遇到可以加入答案的线段，就贪心地将其加入答案数组即可。贪心思路的正确性可以考虑如下例子：对于两个线段 $[l_1,r_1]$ 和 $[l_2,r_2]$，其中 $r_2>r_1$ 且 $l_2 \leq r_1$，如果我们选择 $[l_2,r_2]$ 这个线段，那么剩下可分配的数轴就变少了，这对于最后得到的答案一定是不会更优的，因此最佳的策略是贪心地选择第一个线段 $[l_1,r_1]$。

```C++ [sol1-C++]
class Solution {
public:
    struct Seg {
        int left, right;
        bool operator < (const Seg& rhs) const {
            if (right == rhs.right) {
            	return left > rhs.left;
            }
            return right < rhs.right;
        }
    };

    vector<string> maxNumOfSubstrings(string s) {
        vector<Seg> seg(26, (Seg){-1, -1});
        // 预处理左右端点
        for (int i = 0; i < s.length(); ++i) {
            int char_idx = s[i] - 'a';
            if (seg[char_idx].left == -1) {
                seg[char_idx].left = seg[char_idx].right = i;
            } else {
                seg[char_idx].right = i;
            }
        }
        for (int i = 0; i < 26; ++i) {
            if (seg[i].left != -1) {
                for (int j = seg[i].left; j <= seg[i].right; ++j) {
                    int char_idx = s[j] - 'a';
                    if (seg[i].left <= seg[char_idx].left && seg[char_idx].right <= seg[i].right) {
                        continue;
                    }
                    seg[i].left = min(seg[i].left, seg[char_idx].left);
                    seg[i].right = max(seg[i].right, seg[char_idx].right);
                    j = seg[i].left;
                }
            }
        }
        // 贪心选取
        sort(seg.begin(), seg.end());
        vector<string> ans;
        int end = -1;
        for (auto& segment: seg) {
            int left = segment.left, right = segment.right;
            if (left == -1) {
                continue;
            }
            if (end == -1 || left > end) {
                end = right;
                ans.emplace_back(s.substr(left, right - left + 1));
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> maxNumOfSubstrings(String s) {
        Seg[] seg = new Seg[26];
        for (int i = 0; i < 26; ++i) {
            seg[i] = new Seg(-1, -1);
        }
        // 预处理左右端点
        for (int i = 0; i < s.length(); ++i) {
            int char_idx = s.charAt(i) - 'a';
            if (seg[char_idx].left == -1) {
                seg[char_idx].left = seg[char_idx].right = i;
            } else {
                seg[char_idx].right = i;
            }
        }
        for (int i = 0; i < 26; ++i) {
            if (seg[i].left != -1) {
                for (int j = seg[i].left; j <= seg[i].right; ++j) {
                    int char_idx = s.charAt(j) - 'a';
                    if (seg[i].left <= seg[char_idx].left && seg[char_idx].right <= seg[i].right) {
                        continue;
                    }
                    seg[i].left = Math.min(seg[i].left, seg[char_idx].left);
                    seg[i].right = Math.max(seg[i].right, seg[char_idx].right);
                    j = seg[i].left;
                }
            }
        }
        // 贪心选取
        Arrays.sort(seg);
        List<String> ans = new ArrayList<String>();
        int end = -1;
        for (Seg segment : seg) {
            int left = segment.left, right = segment.right;
            if (left == -1) {
                continue;
            }
            if (end == -1 || left > end) {
                end = right;
                ans.add(s.substring(left, right + 1));
            }
        }
        return ans;
    }

    class Seg implements Comparable<Seg> {
        int left, right;

        public Seg(int left, int right) {
            this.left = left;
            this.right = right;
        }

        public int compareTo(Seg rhs) {
            if (right == rhs.right) {
                return rhs.left - left;
            }
            return right - rhs.right;
        }
    }
}
```

```Python [sol1-Python3]
class Seg:
    def __init__(self, left=-1, right=-1):
        self.left = left
        self.right = right
    
    def __lt__(self, rhs):
        return self.left > rhs.left if self.right == rhs.right else self.right < rhs.right


class Solution:
    def maxNumOfSubstrings(self, s: str) -> List[str]:
        seg = [Seg() for _ in range(26)]
        # 预处理左右端点
        for i in range(len(s)):
            charIdx = ord(s[i]) - ord('a')
            if seg[charIdx].left == -1:
                seg[charIdx].left = seg[charIdx].right = i
            else:
                seg[charIdx].right = i

        for i in range(26):
            if seg[i].left != -1:
                j = seg[i].left
                while j <= seg[i].right:
                    charIdx = ord(s[j]) - ord('a')
                    if seg[i].left <= seg[charIdx].left and seg[charIdx].right <= seg[i].right:
                        pass
                    else:
                        seg[i].left = min(seg[i].left, seg[charIdx].left)
                        seg[i].right = max(seg[i].right, seg[charIdx].right)
                        j = seg[i].left
                    j += 1

        # 贪心选取
        seg.sort()
        ans = list()
        end = -1
        for segment in seg:
            left, right = segment.left, segment.right
            if left == -1:
                continue
            if end == -1 or left > end:
                end = right
                ans.append(s[left:right+1])
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n\Sigma + \Sigma \log \Sigma)$，其中 $n$ 表示字符串的长度，$\Sigma$ 表示字符串字符集的大小。预处理每个线段的左右端点需要 $O(n\Sigma)$ 的时间，贪心选取需要 $O(\Sigma \log \Sigma + \Sigma)$ 的时间，因此总时间复杂度为 $O(n\Sigma + \Sigma \log \Sigma)$。

- 空间复杂度：$O(\Sigma)$。我们需要 $O(\Sigma)$ 大小的空间来记录每个字符被包含的线段的左右端点。