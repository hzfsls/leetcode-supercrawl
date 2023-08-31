## [159.至多包含两个不同字符的最长子串 中文官方题解](https://leetcode.cn/problems/longest-substring-with-at-most-two-distinct-characters/solutions/100000/zhi-duo-bao-han-liang-ge-bu-tong-zi-fu-d-dqii)

[TOC]

 ## 解决方案

---

 #### 方法 1：滑动窗口

 **思路**
 为了一次性解决问题， 我们使用滑动窗口方法，设定两个指针 `left` 和 `right` 作为窗口的边界。
 思路是，将两个指针都设定在位置 `0`， 然后向右移动 `right` 指针，直到 窗口内不超过两个不同的字符。 如果某一点我们得到了 `3` 个不同的字符， 那么需要移动 `left` 指针，窗口里最多只能有 `2` 个不同的字符。

 ![image.png](https://pic.leetcode.cn/1691999851-LpXfnv-image.png){:width=600}

这就是算法概括：沿着字符窗口移动，窗口中不超过 `2` 个不同的字符，并在每一步更新最大子字符串长度。
 > 还有一个问题需要回答 —— 如何移动左指针以保证字符串中只有 `2` 个不同的字符？

 我们可以建立一个哈希表，键是滑动窗口中的所有字符，值是它们最右端的位置。在每一刻，这个哈希表最多只能包含 `3` 个元素。

 ![image.png](https://pic.leetcode.cn/1691999973-jMlnpv-image.png){:width=600}

 比如，使用此哈希表，我们知道字符 `e` 在 `"eeeeeeeet"` 窗口的最右位置是 `8`，所以需要将 `left` 指针移动到 `8 + 1 = 9` 的位置，从滑动窗口中排除字符 `e`。
 这个算法的最优时间复杂度？——当它只需要一次穿越长度为 `N` 的字符串，时间复杂度是 $\mathcal{O}(N)$。

 **算法**
 现在我们可以写出算法。

 - 如果字符串长度`N`小于`3`，则返回`N`。 
 -  将两个指针都设置在字符串开始`left = 0` 和 `right = 0` 的位置，初始化最大子字符串长度`max_len = 2`。 
 -  当`right`指针小于 `N` 时：  
    * 如果哈希表包含少于 `3` 个不同的字符， 将当前字符`s[right]` 添加到哈希表中， 并将 `right` 指针向右移动。  
    *  如果哈希表包含 `3` 个不同的字符， 从哈希表中删除最左侧的字符 并移动 `left` 指针，使得滑动窗口再次仅包含 `2` 个不同的字符。  
    *  更新 `max_len`。

**代码实现**

 <![image.png](https://pic.leetcode.cn/1692002034-xiKyRd-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002037-etmJPM-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002040-LhXyDh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002042-ppVTkS-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002046-fexiHh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002049-RmjWSX-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002051-VlnjDv-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002054-zAknoB-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002057-twsJfC-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002061-TPeQkU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002064-NkfrmJ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002067-YLhezS-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002070-vHyuSY-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002073-GRMGDr-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002076-OezKuP-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002078-MaBqWW-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002082-heCwHl-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002085-WgPSxL-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002088-ImdOOF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002091-DdhtuS-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002094-ecqfHN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002097-tIwLSj-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002100-RKcCaD-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002103-AiapEF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002108-DfLHXg-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002111-CykZxL-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002114-abMaWE-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002117-PacZrD-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692002121-cZIvPX-image.png){:width=400}>

 ```C++ [slu]
 class Solution {
public:
    int lengthOfLongestSubstringTwoDistinct(string s) {
        size_t n = s.length();
        if (n < 3) {
            return n;
        }

        // 滑动窗口的左右指针
        int left = 0, right = 0;
        // hashmap 中的字符 -> 它在滑动窗口中最靠右的位置
        map<char, int> hashmap;

        int max_len = 2;

        while (right < n) {
            // 当滑动窗口包含小于 3 个字符
            hashmap[s[right]] = right;
            right++;

            // 滑动窗口包含 3 个字符
            if (hashmap.size() == 3) {
                int del_idx = INT_MAX;
                for (pair<char, int> element : hashmap) {
                    del_idx = min(del_idx, element.second);
                }
                // 删除最左边的字符
                hashmap.erase(s[del_idx]);
                left = del_idx + 1;
            }
            max_len = max(max_len, right - left);
        }
        return max_len;
    }
};
 ```

 ```Java [slu]
 class Solution {
  public int lengthOfLongestSubstringTwoDistinct(String s) {
    int n = s.length();
    if (n < 3) return n;

    // 滑动窗口的左右指针
    int left = 0;
    int right = 0;
    // hashmap 中的字符 -> 它在滑动窗口中最靠右的位置
    HashMap<Character, Integer> hashmap = new HashMap<Character, Integer>();

    int max_len = 2;

    while (right < n) {
      // 当滑动窗口包含小于 3 个字符
      hashmap.put(s.charAt(right), right++);

      // 滑动窗口包含 3 个字符
      if (hashmap.size() == 3) {
        // 删除最左边的字符
        int del_idx = Collections.min(hashmap.values());
        hashmap.remove(s.charAt(del_idx));
        // 删除滑动窗口的左指针
        left = del_idx + 1;
      }

      max_len = Math.max(max_len, right - left);
    }
    return max_len;
  }
}
 ```

 ```Python [slu]
 from collections import defaultdict
class Solution:
    def lengthOfLongestSubstringTwoDistinct(self, s: 'str') -> 'int':
        n = len(s)
        if n < 3:
            return n

        # 滑动窗口的左右指针
        left, right = 0, 0
        # hashmap 中的字符 -> 它在滑动窗口中最靠右的位置
        hashmap = defaultdict()

        max_len = 2

        while right < n:
            # 当滑动窗口包含小于 3 个字符
            hashmap[s[right]] = right
            right += 1

            # 滑动窗口包含 3 个字符
            if len(hashmap) == 3:
                # 删除最左边的字符
                del_idx = min(hashmap.values())
                del hashmap[s[del_idx]]
                # 删除滑动窗口的左指针
                left = del_idx + 1

            max_len = max(max_len, right - left)

        return max_len
 ```

 **复杂度分析**

 * 时间复杂度：$\mathcal{O}(N)$，其中`N` 是输入字符串中的字符数量。
 * 空间复杂度：$\mathcal{O}(1)$，因为额外 的空间只用于最多含有 `3` 个元素的哈希表。

**相似题**
 同样的滑动窗口方法可以用来解决 **泛化** 问题：
 [至多包含 K 个不同字符的最长子串](https://leetcode.cn/problems/longest-substring-with-at-most-k-distinct-characters/)