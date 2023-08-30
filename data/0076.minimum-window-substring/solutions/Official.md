### 📺视频题解  

![76. 最小覆盖子串.mp4](37fa6129-0eb2-4c1f-a75b-152e1d6b2f5e)

### 📖文字题解

#### 方法一：滑动窗口

**思路和算法**

本问题要求我们返回字符串 $s$ 中包含字符串 $t$ 的全部字符的最小窗口。我们称包含 $t$ 的全部字母的窗口为「可行」窗口。

我们可以用滑动窗口的思想解决这个问题。在滑动窗口类型的问题中都会有两个指针，一个用于「延伸」现有窗口的 $r$ 指针，和一个用于「收缩」窗口的 $l$ 指针。在任意时刻，只有一个指针运动，而另一个保持静止。**我们在 $s$ 上滑动窗口，通过移动 $r$ 指针不断扩张窗口。当窗口包含 $t$ 全部所需的字符后，如果能收缩，我们就收缩窗口直到得到最小窗口。**

![fig1](https://assets.leetcode-cn.com/solution-static/76/76_fig1.gif)

如何判断当前的窗口包含所有 $t$ 所需的字符呢？我们可以用一个哈希表表示 $t$ 中所有的字符以及它们的个数，用一个哈希表动态维护窗口中所有的字符以及它们的个数，如果这个动态表中包含 $t$ 的哈希表中的所有字符，并且对应的个数都不小于 $t$ 的哈希表中各个字符的个数，那么当前的窗口是「可行」的。

**注意：这里 $t$ 中可能出现重复的字符，所以我们要记录字符的个数。**

**考虑如何优化？** 如果 $s = {\rm XX \cdots XABCXXXX}$，$t = {\rm ABC}$，那么显然 ${\rm [XX \cdots XABC]}$ 是第一个得到的「可行」区间，得到这个可行区间后，我们按照「收缩」窗口的原则更新左边界，得到最小区间。我们其实做了一些无用的操作，就是更新右边界的时候「延伸」进了很多无用的 $\rm X$，更新左边界的时候「收缩」扔掉了这些无用的 $\rm X$，做了这么多无用的操作，只是为了得到短短的 $\rm ABC$。没错，其实在 $s$ 中，有的字符我们是不关心的，我们只关心 $t$ 中出现的字符，我们可不可以先预处理 $s$，扔掉那些 $t$ 中没有出现的字符，然后再做滑动窗口呢？也许你会说，这样可能出现 $\rm XXABXXC$ 的情况，在统计长度的时候可以扔掉前两个 $\rm X$，但是不扔掉中间的 $\rm X$，怎样解决这个问题呢？优化后的时空复杂度又是多少？**这里代码给出没有优化的版本，以上的三个问题留给读者思考，欢迎大家在评论区给出答案哟。**

**代码**

```cpp [sol1-C++]
class Solution {
public:
    unordered_map <char, int> ori, cnt;

    bool check() {
        for (const auto &p: ori) {
            if (cnt[p.first] < p.second) {
                return false;
            }
        }
        return true;
    }

    string minWindow(string s, string t) {
        for (const auto &c: t) {
            ++ori[c];
        }

        int l = 0, r = -1;
        int len = INT_MAX, ansL = -1, ansR = -1;

        while (r < int(s.size())) {
            if (ori.find(s[++r]) != ori.end()) {
                ++cnt[s[r]];
            }
            while (check() && l <= r) {
                if (r - l + 1 < len) {
                    len = r - l + 1;
                    ansL = l;
                }
                if (ori.find(s[l]) != ori.end()) {
                    --cnt[s[l]];
                }
                ++l;
            }
        }

        return ansL == -1 ? string() : s.substr(ansL, len);
    }
};
```

```Java [sol1-Java]
class Solution {
    Map<Character, Integer> ori = new HashMap<Character, Integer>();
    Map<Character, Integer> cnt = new HashMap<Character, Integer>();

    public String minWindow(String s, String t) {
        int tLen = t.length();
        for (int i = 0; i < tLen; i++) {
            char c = t.charAt(i);
            ori.put(c, ori.getOrDefault(c, 0) + 1);
        }
        int l = 0, r = -1;
        int len = Integer.MAX_VALUE, ansL = -1, ansR = -1;
        int sLen = s.length();
        while (r < sLen) {
            ++r;
            if (r < sLen && ori.containsKey(s.charAt(r))) {
                cnt.put(s.charAt(r), cnt.getOrDefault(s.charAt(r), 0) + 1);
            }
            while (check() && l <= r) {
                if (r - l + 1 < len) {
                    len = r - l + 1;
                    ansL = l;
                    ansR = l + len;
                }
                if (ori.containsKey(s.charAt(l))) {
                    cnt.put(s.charAt(l), cnt.getOrDefault(s.charAt(l), 0) - 1);
                }
                ++l;
            }
        }
        return ansL == -1 ? "" : s.substring(ansL, ansR);
    }

    public boolean check() {
        Iterator iter = ori.entrySet().iterator(); 
        while (iter.hasNext()) { 
            Map.Entry entry = (Map.Entry) iter.next(); 
            Character key = (Character) entry.getKey(); 
            Integer val = (Integer) entry.getValue(); 
            if (cnt.getOrDefault(key, 0) < val) {
                return false;
            }
        } 
        return true;
    }
}
```

```golang [sol1-Golang]
func minWindow(s string, t string) string {
    ori, cnt := map[byte]int{}, map[byte]int{}
    for i := 0; i < len(t); i++ {
        ori[t[i]]++
    }

    sLen := len(s)
    len := math.MaxInt32
    ansL, ansR := -1, -1

    check := func() bool {
        for k, v := range ori {
            if cnt[k] < v {
                return false
            }
        }
        return true
    }
    for l, r := 0, 0; r < sLen; r++ {
        if r < sLen && ori[s[r]] > 0 {
            cnt[s[r]]++
        }
        for check() && l <= r {
            if (r - l + 1 < len) {
                len = r - l + 1
                ansL, ansR = l, l + len
            }
            if _, ok := ori[s[l]]; ok {
                cnt[s[l]] -= 1
            }
            l++
        }
    }
    if ansL == -1 {
        return ""
    }
    return s[ansL:ansR]
}
```

**复杂度分析**

+ 时间复杂度：最坏情况下左右指针对 $s$ 的每个元素各遍历一遍，哈希表中对 $s$ 中的每个元素各插入、删除一次，对 $t$ 中的元素各插入一次。每次检查是否可行会遍历整个 $t$ 的哈希表，哈希表的大小与字符集的大小有关，设字符集大小为 $C$，则渐进时间复杂度为 $O(C\cdot |s| + |t|)$。
+ 空间复杂度：这里用了两张哈希表作为辅助空间，每张哈希表最多不会存放超过字符集大小的键值对，我们设字符集大小为 $C$ ，则渐进空间复杂度为 $O(C)$。