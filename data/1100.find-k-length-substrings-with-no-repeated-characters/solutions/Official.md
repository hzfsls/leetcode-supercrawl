## 题解

#### 方法 1：暴力法 

**思路** 

题目中的限制条件指出，输入的字符串中只包含小写的英文字母。因此，不含有重复字符的最长子字符串最多只有 26 个字符。如果再添加任何其他字符，就会有一个重复的字符。这意味着，对于任何 $k > 26$ 的情况，都不存在不含有重复字符的子字符串。因此，我们只需要检查 $k <= 26$ 的情况，这可以通过暴力求解的方法在给定的限制条件下进行。 

**算法** 

正如我们刚才讨论过的，如果 $k > 26$，那么我们可以简单地返回 0，因为不可能存在长度超过 26 且所有字符均唯一的字符串。对于所有满足 $k <= 26$ 的情况，我们可以逐个检查每个长度为 $k$ 的子字符串，检查它是否有重复字符。我们可以使用哈希表或频率数组去检查一个子字符串是否有重复字符。那该如何具体的使用它们呢？对于每个子字符串，我们将元素插入到哈希表或频率数组中。在执行此操作时，如果我们发现当前元素已经存在，就表明它是一个重复元素。 

让我们来总结一下这个算法。 

1. 从索引 0 开始迭代 $s$，直到索引 $n - k$ (包含)，其中 $n$ 是 $s$ 的长度。我们在索引 $n - k$ 处停止，因为任何在此索引之后开始的子字符串将包含少于 $k$ 的字符。 

2. 对于每个索引 $i$:  

   i. 初始化一个标志 $isUnique = true$，表示我们还没有遇到任何重复的字符，并初始化一个大小为 26 的频率数组，以计数我们每次看到每个字符的次数。 

   - 请注意，我们也可以使用一个集合而不是频率数组。

   - 请注意，Python 提供了一个 [else子句](https://docs.python.org/3/tutorial/controlflow.html?highlight=else%20clause#break-and-continue-statements-and-else-clauses-on-loops) 功能，我们将用此作为标志。 

   ii. 迭代遍历接下来的 $k$ 个字符，并在频率数组中持续增加每个遇到的字符的频率。 

   iii. 如果任何字符的频率超过 1，将 $isUnique$ 设置为 $false$，表示当前的子字符串有重复的字符，并从迭代中中断。 

   iv. 在迭代遍历了 $k$ 个字符之后，如果 $isUnique$ 标志仍然为 $true$，那么当前的子字符串没有重复的字符，因此将答案增加 1。 

3. 在从 0 到 $n - k$ 的所有索引迭代完成后，返回不含重复字符的子字符串的数量。 

    

**代码实现** 
```C++ [slu1]
class Solution {
public:
    int numKLenSubstrNoRepeats(string s, int k) {
        if (k > 26)
            return 0;
        
        int answer = 0;
        int n = s.size();
        
        for (int i = 0; i <= n - k; i++) {
            // 初始化空频率数组
            int freq[26] = {0};
            bool isUnique = true;
            
            for (int j = i; j < i + k; j++) {
                // 增加当前字符的次数
                freq[s[j] - 'a']++;
                
                // 如果发现重复字符，则停止循环
                if (freq[s[j] - 'a'] > 1) {
                    isUnique = false;
                    break;
                }
            }
            
            // 如果子字符串没有任何重复字符，更新答案
            if (isUnique) {
                answer++;
            }
        }
        
        return answer;
    }
};
```
```Java [slu1]
class Solution {
    public int numKLenSubstrNoRepeats(String s, int k) {
        if (k > 26)
            return 0;
        int n = s.length();
        int answer = 0;
        
        for (int i = 0; i <= n - k; i++) {
             // 初始化空频率数组
            int freq[] = new int[26];
            boolean isUnique = true;
            
            for (int j = i; j < i + k; j++) {
                char ch = s.charAt(j);
                
                // 增加当前字符的次数
                freq[ch - 'a']++;
                
                // 如果发现重复字符，则停止循环
                if (freq[ch - 'a'] > 1) {
                    isUnique = false;
                    break;
                }
            }
            
            // 如果子字符串没有任何重复字符，更新答案
            if (isUnique) {
                answer++;
            }
        }
        
        return answer;
    }
}
```
```Python3 [slu1]
class Solution:
    def numKLenSubstrNoRepeats(self, s: str, k: int) -> int:
        if k > 26:
            return 0
        answer = 0
        n = len(s)
        
        for i in range(n - k + 1):
             # 初始化空频率数组
            freq = [0] * 26
            
            for j in range(i, i + k):
                curr_char = ord(s[j]) - ord('a')
                
                # 增加当前字符的次数
                freq[curr_char] += 1
                
                # 如果发现重复字符，则停止循环
                if freq[curr_char] > 1:
                    break
            else:
                # 如果子字符串没有任何重复字符，更新答案
                answer += 1
        
        return answer
```


**复杂度分析** 

设 $n$ 为 $s$ 的长度，$k$ 为给定的子字符串长度，且 $m$ 为字符串中允许出现的唯一字符的数量。在这个例子中，$m = 26$。 

- 时间复杂度：$O(n \cdot \min(m, k))$。 
  - 你可能觉得复杂度应该为 $O(n \cdot k)$，因为对于每个索引，我们都在检查从这个索引开始的长度为 $k$ 的子字符串是否包含重复的字符。但是需要考虑到的是，我们只有在 $k <= m$ 的情况下才会进行这些操作。在其它所有的情况下，即，当 $k > m$ 时，我们直接返回 0。因此我们可以说 $k$ 被 $m$ 所限制，所以时间复杂度为 $O(n \cdot \min(m, k))$。
  - 此外，因为在这里 $m = 26$，我们可以将其视为一个常量，所以时间复杂度可以认为是 $O(n)$。 

- 空间复杂度：$O(m)$。 
  - 这里使用的额外空间仅由大小为 $m$ 的频率数组使用，其在这个案例中等于26。因此，这可以被视为常数空间，即，$O(1)$。  

#### 方法 2：滑动窗口 

**思路** 

本题需要我们统计具有 $k$ 长度且无重复字符的子字符串的数量。我们可以重新描述一下这个问题。即我们需要统计字符串中长度为 $k$ 且仅包含唯一字符的窗口的数量。因此，我们可以在字符串中滑动，并对包含长度为 $k$ 且仅包含唯一字符的窗口数量进行计数。总结一下这个并不太巧妙的文字游戏，我们也可以使用滑动窗口的技巧来解决这个问题！ 

**算法** 

滑动窗口使用两个指针 $left$ 和 $right$ 来遍历字符串。$left$ 和 $right$ 指针实际上分别代表窗口（或子串）的最左索引和最右索引。我们需要通过增加（通过递增 $right$ 指针）和缩小（通过递增 $left$ 指针）窗口，确保算法运行时符合下列规则。 

- 窗口（或子串）只包含唯一的字符。
- 窗口的大小不超过 $k$，即 $right - left + 1 <= k$ 

我们可以使用一个哈希表或频率数组来实现第一条规则，如前一种方法所述。我们将扩展我们的窗口，并在频率数组中持续插入元素。如果我们发现一个元素已经在数组中存在，那么我们需要缩小我们的窗口，并从数组中删除元素，直到重复的元素被删除。这将确保当前的窗口，即由 $s[left, right]$ (包括)表示的子串，只包含唯一的字符。窗口的大小将为 $right - left + 1$。这个大小可以小于或等于 $k$。如果它等于 $k$，那么我们可以将答案加1，并通过增加 $left$ 并从频率数组中移除最左边的元素来缩小窗口。这将确保窗口的大小从不超过 $k$，从而也遵守第二条规则。 

总结一下这个算法。 

1. 初始化一个大小为 26 的频率数组和两个指针 $left$ 和 $right$，它们最初都指向 0 索引。

2. 当 $right$ 小于 $n$ 时，其中 $n$ 是字符串的长度，执行以下操作： 
   1. 将当前字符添加到频率数组中，即，在数组中增加它的频率。 
   2. 如果当前字符在频率数组中的频率大于 1，那么它就是一个重复的字符。增加 $left$ 指针，并从频率数组中持续删除元素，直到重复的字符被删除。以 $left$ 和 $right$ (包括)表示的窗口现在将只包含唯一的字符。 
   3. 如果当前窗口的大小等于 $k$，那么增加答案的值，并通过增加 $left$ 并从频率数组中删除最左边的字符来缩小窗口。这样做是为了确保窗口的大小不超过 $k$。 
   4. 通过增加 $right$ 指针来扩大窗口，这样可以处理后续的字符。 

3. 当 $right$ 到达字符串的尾部，返回答案。  

**代码实现** 
```C++ [slu2]
class Solution {
public:
    int numKLenSubstrNoRepeats(string s, int k) {
        // 复用第一种方法中的条件
        // 对于k > 26，不存在只有唯一字符的子字符串
        if (k > 26)
            return 0;
        
        int answer = 0;
        int n = s.size();
        
        // 初始化左、右指针
        int left = 0, right = 0;
        // 初始化频率数组
        int freq[26] = {0};
        
        while (right < n) {

            // 在频率数组中添加当前字符
            freq[s[right] - 'a']++;
            
            //如果当前字符在频率数组中出现多次
            //继续收缩窗口并从频率数组中删除字符，直到当前字符的频率变为1。
            while (freq[s[right] - 'a'] > 1) {
                freq[s[left] - 'a']--;
                left++;
            }
            
            // 检查当前唯一子字符串的长度是否等于k
            if (right - left + 1 == k) {
                answer++;
                
                // 收缩窗口并从频率数组中移除最左边的字符
                freq[s[left] - 'a']--;
                left++;
            }
            
            // 拓展窗口
            right++;
        }
        
        return answer;
    }
};
```
```Java [slu2]
class Solution {
    public int numKLenSubstrNoRepeats(String s, int k) {
        // 复用第一种方法中的条件
        // 对于k > 26，不存在只有唯一字符的子字符串
        if (k > 26)
            return 0;
        
        int answer = 0;
        int n = s.length();
        
        // 初始化左、右指针
        int left = 0, right = 0;
        // 初始化频率数组
        int freq[] = new int[26];
        
        while (right < n) {
            
            // 在频率数组中添加当前字符
            freq[s.charAt(right) - 'a']++;
            
            // 如果当前字符在频率数组中出现多次
            // 继续收缩窗口并从频率数组中删除字符，直到当前字符的频率变为1。
            while (freq[s.charAt(right) - 'a'] > 1) {
                freq[s.charAt(left) - 'a']--;
                left++;
            }
            
            
            // 检查当前唯一子字符串的长度是否等于k
            if (right - left + 1 == k) {
                answer++;
                
                // 收缩窗口并从频率数组中移除最左边的字符
                freq[s.charAt(left) - 'a']--;
                left++;
            }
            
            // 拓展窗口
            right++;
        }
        
        return answer;
    }
}
```
```Python3 [slu2]
class Solution:
    def numKLenSubstrNoRepeats(self, s: str, k: int) -> int:
        # 复用第一种方法中的条件
        # 对于k > 26，不存在只有唯一字符的子字符串
        if k > 26:
            return 0
        answer = 0
        n = len(s)
        
        # 初始化左右指针
        left = right = 0
        
        # 初始化频率数组
        freq = [0] * 26
        
        # 函数根据字母表获取字符的索引
        def get_val(ch: str) -> int:
            return ord(ch) - ord('a')
        
        while right < n:
            
            # 在频率数组中添加当前字符
            freq[get_val(s[right])] += 1
            
            # 如果当前字符在频率数组中出现多次。
            # 继续收缩窗口并从频率数组中删除字符，直到当前字符的频率变为1。
            while freq[get_val(s[right])] > 1:
                freq[get_val(s[left])] -= 1
                left += 1
            
            # 检查当前唯一子字符串的长度是否等于 k
            if right - left + 1 == k:
                answer += 1
                
                # 收缩窗口并从频率数组中移除最左边的字符
                freq[get_val(s[left])] -= 1
                left += 1
            
            # 拓展窗口
            right += 1
        
        return answer
```


**复杂度分析** 

设 $n$ 为 $s$ 的长度，且 $m$ 为字符串中允许出现的唯一字符的数量。在这个例子中，$m = 26$。 

- 时间复杂度：$O(n)$。 
  - 我们可能会认为嵌套循环应该产生 $O(n^2)$ 的复杂度，但是注意到两个循环只有在 $right$ 小于 $n$ 的时候才会递增 $left$ 或 $right$。因此，每个字符最多只会被访问两次：一次是通过 $left$ 指针，一次是通过 $right$ 指针。这导致了 $O(2n)$ 的复杂度，它相当于 $O(n)$。 

- 空间复杂度：$O(m)$ 
  - 这里使用的额外空间仅由大小为 $m$ 的频率数组使用，其在这个案例中等于 26。因此，这可以被视为常数空间，即，$O(1)$。