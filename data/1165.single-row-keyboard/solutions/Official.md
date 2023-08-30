[TOC]

 ## 解决方案

---

#### 方法 1：存储所有字母的索引

 **概述**
 一个简单的暴力解决方案是：遍历 `word`，在每次迭代中，将前一个键和当前键之间的距离加到 `sum` 变量中。为了找到这些距离，我们可以在键盘上搜索以获取前一个和当前键的索引。之后，距离就是它们之间的差的绝对值。

 ```Golang [slu]
 func calculateTime(keyboard string, word string) int {
    sum, pre := 0, 0 
    for i := 0; i < len(word); i++ {
        for j := 0; j < 26; j++ {
            if keyboard[j] == word[i] {
                sum += abs(j - pre) // 计算移动到当前字符的时间
                pre = j // 保存上一个位置
                break
            }
        }
    }
    return sum
}

func abs(x int) int {
    if x < 0 {
        return -1 * x
    }
    return x
}
 ```

 ```C++ [slu]
 class Solution {
public:
    int calculateTime(string keyboard, string word) {
        int sum = 0, pre = 0;
        for (int i = 0; i < word.size(); ++i) {
            for (int j = 0; j < 26; ++j) {
                if (keyboard[j] == word[i]) {
                    sum += abs(j - pre);
                    pre = j;
                    break;
                }
            }
        }
        return sum;
    }
};
 ```

 让我们看看能否改进上述算法。注意我们可以创建一个“反向”映射的数组，即每个键将被映射到它的索引。这样，找到两个键之间的距离就不再需要在键盘上遍历。相反，它将简单地是两个常数时间的查找索引。这对上述方法来说是一个重大的改进。
 每个字母可以被转换成数组的索引，通过指定 `a = 0, b = 1, c = 2 … z = 26`。

 <![image.png](https://pic.leetcode.cn/1692242402-gdkRsg-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242405-oldfaP-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242407-bfyGPy-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242410-gMHJLh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242413-JGzUoS-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242416-JFXECY-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242419-oDsrGG-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242422-QhpzeC-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242425-oLQbKx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242428-VAfxvl-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242430-aWplCN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242433-TiUxbj-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242437-lAHwvs-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242440-AKbgcV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242442-rTRWNm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242445-gwgOZp-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242448-UudbZG-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242451-wQwXuu-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242454-cyPqUL-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242458-DpRJYJ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242460-CyQdWP-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242463-XEXOyx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242467-yqFCmA-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242470-pjjptz-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242474-NxLzkv-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692242477-VEmKaq-image.png){:width=400}>

 *键盘字母映射到数组*

 **算法步骤**

 1. 键盘只有唯一的小写英文字母，所以我们可以将其映射到大小为 `26` 的数组。因此，我们将创建一个大小为 `26` 的数组，我们称之为 `keyIndices`。
 2. 通过遍历 `keyboard`，在此数组中存储每个字母的索引。
 3. 初始化 `result` 变量为 `0`，这将存储所有距离的总和。
 4. 声明一个变量 `prev`，这将存储前一个键的索引。由于起始位置为 `0`，所以将其初始化为 `0`。
 5. 逐字遍历 `word`。
 6. 对于每个字母 `c`，添加 $|\text{prev} - indexOf(\text{c})|$ 到 `result`。
 7. 将 `prev` 更新为 `c` 的索引。
 8. 所有字母都重复步骤 6 和 7。
 9. 遍历结束时，`result` 将是打字该单词所需的最终时间。

 ```C++ [slu1]
 class Solution {
public:
    int calculateTime(string keyboard, string word) {
        vector<int> keyIndices(26, -1);

        // 获取每一个键的索引
        for (int i = 0; i < keyboard.length(); i++)
            keyIndices[keyboard[i] - 'a'] = i;

        // 将上一个索引初始化为起始索引 0。
        int prev = 0;
        int result = 0;

        // 计算总次数。
        for (char &c : word) {
            // 将前一个索引到当前字母的索引的距离添加到结果中。
            result += abs(prev - keyIndices[c - 'a']);

            // 将上一个索引更新为下一个迭代的当前索引。
            prev = keyIndices[c - 'a'];
        }
        return result;
    }
};
 ```

 ```Java [slu1]
 class Solution {
    public int calculateTime(String keyboard, String word) {
        int[] keyIndices = new int[26];

        // 获取每一个键的索引
        for (int i = 0; i < keyboard.length(); i++)
            keyIndices[keyboard.charAt(i) - 'a'] = i;

        // 将上一个索引初始化为起始索引 0。
        int prev = 0;
        int result = 0;

        // 计算总次数。
        for (char c : word.toCharArray()) {
            // 将前一个索引到当前字母的索引的距离添加到结果中。
            result += Math.abs(prev - keyIndices[c - 'a']);

            // 将上一个索引更新为下一个迭代的当前索引。
            prev = keyIndices[c - 'a'];
        }
        return result;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：$O(n)$。其中 $n$ 是 `word` 的长度，因为我们需要遍历该单词。还需要一个 $O(26) = O(1)$ 的常数来遍历键盘。
 * 空间复杂度：$O(1)$。该算法需要常数空间来存储 `26` 个字母的索引。