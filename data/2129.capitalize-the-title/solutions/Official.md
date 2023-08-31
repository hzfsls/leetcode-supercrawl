## [2129.将标题首字母大写 中文官方题解](https://leetcode.cn/problems/capitalize-the-title/solutions/100000/jiang-biao-ti-shou-zi-mu-da-xie-by-leetc-lhn7)
#### 方法一：按要求遍历

**思路与算法**

我们顺序遍历 $\textit{title}$ 字符串，对于其中每个以空格为分界的单词，我们首先找出它的起始与末尾下标，判断它的长度以进行相应操作：

- 如果长度小于等于 $2$，则我们将该单词全部转化为小写；

- 如果长度大于 $2$，则我们将该单词首字母转化为大写，其余字母转化为小写。

最终，我们将转化后的字符串返回作为答案。

另外，对于 $\texttt{Python}$ 等无法直接对字符串特定字符进行修改的语言，我们可以先将字符串分割为单词，并用数组按顺序储存这些单词。随后，我们逐单词进行上述操作生成新的单词并替换。最后，我们将替换后的单词数组拼接为空格连接的字符串并返回作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string capitalizeTitle(string title) {
        int n = title.size();
        int l = 0, r = 0;   // 单词左右边界（左闭右开）
        title.push_back(' ');   // 避免处理末尾的边界条件
        while (r < n) {
            while (title[r] != ' ') {
                ++r;
            }
            // 对于每个单词按要求处理
            if (r - l > 2) {
                title[l] = toupper(title[l]);
                ++l;
            }
            while (l < r) {
                title[l] = tolower(title[l]);
                ++l;
            }
            l = r + 1;
            ++r;
        }
        title.pop_back();
        return title;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def capitalizeTitle(self, title: str) -> str:
        res = []   # 辅助数组
        for word in title.split():
            # 对于分割的每个单词按要求处理
            if len(word) <= 2:
                res.append(word.lower())
            else:
                res.append(word[0].upper() + word[1:].lower())
        return ' '.join(res)
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{title}$ 的长度。即为遍历字符串完成操作的时间复杂度。

- 空间复杂度：由于不同语言的字符串相关方法实现有所不同，因此空间复杂度也有所不同：

  -  $\texttt{C++}：$O(1)$。
  -  $\texttt{Python}：$O(n)$，即为辅助数组的空间开销。