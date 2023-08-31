## [1216.验证回文字符串 III 中文官方题解](https://leetcode.cn/problems/valid-palindrome-iii/solutions/100000/yan-zheng-hui-wen-zi-fu-chuan-iii-by-lee-s4rc)

[TOC] 

 ## 解决方案

---

 #### 方法 1：自上而下的动态规划（二维） 

 **简述** 

 我们试着找出最少需要移除多少个字符，使字符串变成一个回文。如果我们发现最少移除的个数小于等于 `k`，我们可以断定它确实是一个 K-回文，否则就不是。 

 **相似题目：** 

 - [72. 编辑距离](https://leetcode.cn/problems/edit-distance/) 
 - [516. 最长回文子序列](https://leetcode.cn/problems/longest-palindromic-subsequence/) 

 **算法** 

 我们如何求出使字符串变成回文需要移除的最少字符数呢？我想你可能会想到，和回文匹配的字符都在字符串的起始和结束位置，我们用两个指针 `i` 和 `j` 从开头和结尾开始匹配。

 我们可能遇到以下两种情况：

 1. 在位置 `i` 处的字符与位置 `j` 处的字符匹配。
 2. 两个字符不匹配。

 对于第一种情况，我们只需要将指针 `i` 向右移动一位，指针 `j` 向左移动一位，也就是 `i++` 和 `j--`。 

 在第二种情况下，我们有两种选择： 

 * 移除位置 `j` 处的字符，看位置 `i` 处的字符是否与前一个字符匹配。 
 或者 
 * 移除位置 `i` 处的字符，看位置 `j` 处的字符是否与后一个字符匹配。 

 因为我们实际上并没有从字符串中移除字符，只是计算需要移除的字符数量。所以在第一种情况下，我们将指针 `j` 减 1，指针 `i` 保持不变，因为我们仍需要一个字符来匹配位置 `i` 处的字符；在第二种情况下，我们将指针 `i` 加1，指针 `j` 保持不变，因为我们仍需要一个字符来匹配位置 `j` 处的字符。在两种情况下，我们都移除了一个字符，所以代价加 1。

 然后，我们可以用这两对不同的新 `i` 和 `j` 值（`i+1, j` 和 `i, j-1`）再次重复这个过程，将结果中的最小值作为当前位置 `i, j` 的结果。 
 我们看到这是一个递归的过程，因此我们可以结合缓存来存储重复的值。 

 ```C++ [slu1]
 class Solution {
public:
    vector<vector<int>> memo;
    int isValidPalindrome(string &s, int i, int j) {

        // 边界条件 1，只有一个字母。
        if (i == j)
            return 0;

        // 边界条件 2，只有两个字母。
        if (i == j - 1)
            return s[i] != s[j];

        //  如果存在，则返回预计算值。
        if (memo[i][j] != -1)
            return memo[i][j];

        // 第一种情况：在 `i` 的字母和在 `j` 的字母相同
        if (s[i] == s[j])
            return memo[i][j] = isValidPalindrome(s, i + 1, j - 1);

        // 第二种情况：在 `i` 的字母和在 `j` 的字母不同
        // 要么删除在 `i` 的字母，要么删除在 `j` 的字母
        // 并尝试使用递归匹配两个指针。
        // 我们需要取两个结果中最小的并加 1
        // 表示删除的代价。
        return memo[i][j] = 1 + min(isValidPalindrome(s, i + 1, j), isValidPalindrome(s, i, j - 1));
    }
    bool isValidPalindrome(string s, int k) {
        memo.resize(s.length(), vector<int>(s.length(), -1));

        // 如果只删除字母来创建回文的最低成本，则返回 true
        // 小于或等于 `k`。
        return isValidPalindrome(s, 0, s.length() - 1) <= k;
    }
};
 ```

 ```Java [slu1]
 class Solution {
    Integer memo[][];
    int isValidPalindrome(String s, int i, int j) {

        // 边界条件 1，只有一个字母。
        if (i == j)
            return 0;

        // 边界条件 2，只有两个字母。
        if (i == j - 1)
            return s.charAt(i) != s.charAt(j) ? 1 : 0;

        // 如果存在，则返回预计算值。
        if (memo[i][j] != null)
            return memo[i][j];

        // 第一种情况：在 `i` 的字母和在 `j` 的字母相同
        if (s.charAt(i) == s.charAt(j))
            return memo[i][j] = isValidPalindrome(s, i + 1, j - 1);

        // 第二种情况：在 `i` 的字母和在 `j` 的字母不同
        // 要么删除在 `i` 的字母，要么删除在 `j` 的字母
        // 并尝试使用递归匹配两个指针。
        // 我们需要取两个结果中最小的并加 1
        // 表示删除的代价。
        return memo[i][j] = 1 + Math.min(isValidPalindrome(s, i + 1, j), isValidPalindrome(s, i, j - 1));
    }
public boolean isValidPalindrome(String s, int k) {
        memo = new Integer[s.length()][s.length()];

        // 如果只删除字母来创建回文的最低成本小于或等于 `k`，则返回 true
        return isValidPalindrome(s, 0, s.length() - 1) <= k;
    }
};
 ```

 **复杂性分析** 

 * 时间复杂度：$O(n^2)$. 其中 `n` 是字符串 `s` 的长度。这是因为我们尝试寻找所有 `i` 和 `j` 的组合，`i` 和 `j` 的范围都是 `0` 到 `n`。计算一个组合我们只需要进行 $O(1)$ 操作，因此最终的复杂度是 $O(n^2)$. 
 * 空间复杂度：$O(n^2)$. 其中 `n` 是字符串 `s` 的长度。这是因为我们在 `memo` 表中缓存所有的结果。递归栈的最大深度能达到 $O(n)$。因此，复杂度主要取决于 `memo` 所占的空间。 

---

 #### 方法 2：自下而上的动态规划（二维） 

 **算法** 

 与其从上到下的填写我们的 `memo` 表，不如试试从下到上的方法。我们只需要按正确的顺序填写所有的 `i` 和 `j` 组合，这样在我们转移到下一个状态（`i`,`j`的组合）之前，我们已经得到了所有需要的结果。 

 ```C++ [slu2]
 class Solution {
public:
    bool isValidPalindrome(string s, int k) {
        vector<vector<int>> memo(s.length(), vector<int>(s.length(), 0));

        // 按正确顺序生成`i`和`j`的所有组合。
        for (int i = s.length() - 2; i >= 0; i--)
            for (int j = i + 1; j < s.length(); j++) {

                // 第一种情况：在 `i` 的字母和在 `j` 的字母相同
                if (s[i] == s[j])
                    memo[i][j] = memo[i + 1][j - 1];

                // 第二种情况：在 `i` 的字母和在 `j` 的字母不同
                // 要么删除在 `i` 的字母，要么删除在 `j` 的字母
                // 并尝试使用递归匹配两个指针。
                // 我们需要取两个结果中最小的并加 1
                // 表示删除的代价。
                else
                    memo[i][j] = 1 + min(memo[i + 1][j], memo[i][j - 1]);
            }

        // 如果只删除字母来创建回文的最低成本，则返回 true
        // 小于或等于 `k`。
        return memo[0][s.length() - 1] <= k;
    }
};
 ```

 ```Java [slu2]
 class Solution {
public boolean isValidPalindrome(String s, int k) {
        int memo[][] = new int[s.length()][s.length()];

        // 按正确顺序生成`i`和`j`的所有组合。
        for (int i = s.length() - 2; i >= 0; i--)
            for (int j = i + 1; j < s.length(); j++) {
                // 第一种情况：在 `i` 的字母和在 `j` 的字母相同
                if (s.charAt(i) == s.charAt(j))
                    memo[i][j] = memo[i + 1][j - 1];

                // 第二种情况：在 `i` 的字母和在 `j` 的字母不同
                // 要么删除在 `i` 的字母，要么删除在 `j` 的字母
                // 并尝试使用递归匹配两个指针。
                // 我们需要取两个结果中最小的并加 1
                // 表示删除的代价。
                else
                    memo[i][j] = 1 + Math.min(memo[i + 1][j], memo[i][j - 1]);
            }

        // 如果只删除字母来创建回文的最低成本，则返回 true
        // 小于或等于 `k`。
        return memo[0][s.length() - 1] <= k;
    }
};
 ```

 **复杂性分析** 

 * 时间复杂度：$O(n^2)$. 其中 `n` 是字符串 `s` 的长度。这是因为我们尝试寻找所有 `i` 和 `j` 的组合，`i` 和 `j` 的范围都是 `0` 到 `n`。计算一个组合我们只需要进行 $O(1)$ 操作，因此最终的复杂度是 $O(n^2)$。
 * 空间复杂度：$O(n^2)$. 其中 `n` 是字符串 `s` 的长度。这是因为在这种情况下`memo`表格被完全填满。

---

 #### 方法 3：自下而上的动态规划（一维）

 **算法**

 仔细研究上述两种方法，你会发现对于任何 `i` 和 `j` 的组合，你实际上只需要第 `i+1` 行和第 `j-1` 列。因此，我们知道我们可以将空间复杂度从 $O(n^2)$ 减少到仅为 $O(n)$。

 实现这一目标的有效方法是，在将当前状态的结果存储到 `memo` 之前，使用 `memo` 中的前一个值，这个值代表之前的状态。这比管理两个数组（前一个和当前的）以及在每次计算后复制它们要好得多。

 ```C++ [slu3]
 class Solution {
public:
    bool isValidPalindrome(string s, int k) {
        vector<int> memo(s.length(), 0);

        // 存储 memo 中之前所需的值。
        int temp, prev;

        // 按正确顺序生成`i`和`j`的所有组合。
        for (int i = s.length() - 2; i >= 0; i--) {
            // 'prev' stores the value at memo[i+1][j-1];
            prev = 0;
            for (int j = i + 1; j < s.length(); j++) {
                // Store the value of memo[i+1][j] temporarily.
                temp = memo[j];

                // 第一种情况：在 `i` 的字母和在 `j` 的字母相同
                if (s[i] == s[j])
                    memo[j] = prev;

                // 第二种情况：在 `i` 的字母和在 `j` 的字母不同
                // 要么删除在 `i` 的字母，要么删除在 `j` 的字母
                // 并尝试使用递归匹配两个指针。
                // 我们需要取两个结果中最小的并加 1
                // 表示删除的代价。
                else

                    // memo[j] 将包含 memo[i+1][j] 的值
                    // memo[j-1] 将包含 memo[i][j-1] 的值
                    memo[j] = 1 + min(memo[j], memo[j - 1]);

                // 把 memo[i+1][j] 的值拷贝给 `prev`
                // 对于 j=j+1 的下一次迭代
                // `prev` 将保存 memo[i+1][j-1] 的值;
                prev = temp;
            }
        }

        // 如果只删除字母来创建回文的最低成本，则返回 true
        // 小于或等于 `k`。
        return memo[s.length() - 1] <= k;
    }
};
 ```

 ```Java [slu3]
 class Solution {
public boolean isValidPalindrome(String s, int k) {
        int memo[] = new int[s.length()];

        // 存储 memo 中之前所需的值。
        int temp, prev;

        // 按正确顺序生成`i`和`j`的所有组合。
        for (int i = s.length() - 2; i >= 0; i--) {
            // 'prev' stores the value at memo[i+1][j-1];
            prev = 0;
            for (int j = i + 1; j < s.length(); j++) {
                // Store the value of memo[i+1][j] temporarily.
                temp = memo[j];

                // 第一种情况：在 `i` 的字母和在 `j` 的字母相同
                if (s.charAt(i) == s.charAt(j))
                    memo[j] = prev;

                // 第二种情况：在 `i` 的字母和在 `j` 的字母不同
                // 要么删除在 `i` 的字母，要么删除在 `j` 的字母
                // 并尝试使用递归匹配两个指针。
                // 我们需要取两个结果中最小的并加 1
                // 表示删除的代价。
                else

                    // memo[j] 将包含 memo[i+1][j] 的值
                    // memo[j-1] 将包含 memo[i][j-1] 的值
                    memo[j] = 1 + Math.min(memo[j], memo[j - 1]);

                // 把 memo[i+1][j] 的值拷贝给 `prev`
                // 对于 j=j+1 的下一次迭代
                // `prev` 将保存 memo[i+1][j-1] 的值;
                prev = temp;
            }
        }

        // 如果只删除字母来创建回文的最低成本，则返回 true
        // 小于或等于 `k`。
        return memo[s.length() - 1] <= k;
    }
};
 ```

 **复杂性分析** 

 * 时间复杂度：$O(n^2)$。其中 `n` 是字符串 `s` 的长度。这是因为我们尝试寻找所有 `i` 和 `j` 的组合，`i` 和 `j` 的范围都是 `0` 到 `n`。计算一个组合我们只需要进行 $O(1)$ 操作，因此最终的复杂度是 $O(n^2)$。
 * 空间复杂度：$O(n)$。其中 `n` 是字符串 `s` 的长度。这是因为 `memo` 表格只存储一个行 `i` 的结果和所有它的列 `j` 的组合。