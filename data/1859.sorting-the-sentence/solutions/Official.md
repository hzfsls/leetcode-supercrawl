## [1859.将句子排序 中文官方题解](https://leetcode.cn/problems/sorting-the-sentence/solutions/100000/jiang-ju-zi-pai-xu-by-leetcode-solution-wnts)
#### 方法一：维护有序的单词数组

**思路与算法**

我们用字符串数组 $\textit{arr}$ 来保存每个位置的单词，并遍历乱序字符串 $s$。每当遍历到数字时，我们会将数字前的单词填入 $\textit{arr}$ 的对应位置。

与此同时，我们统计单词的数量。最终，我们按要求从 $\textit{arr}$ 中构造顺序的句子并返回。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string sortSentence(string s) {
        vector<string> arr(9);   // 单词数组
        string tmp = "";   // 当前单词
        int n = 0;   // 单词数量
        // 遍历字符串
        for (auto c: s){
            if (c >= '0' && c <= '9'){
                // 如果为数字，计算对应的单词数组下标，将单词放入对应位置，并清空当前单词
                // 数组下标为 0 开头，位置索引为 1 开头
                arr[c-'0'-1] = tmp;
                tmp.clear();
                ++n;
            }
            else if (c != ' '){
                // 如果为字母，更新当前单词
                tmp.push_back(c);
            }
        }
        string res = arr[0];   // 原本顺序的句子 
        for (int i = 1; i < n; ++i){
            res += " " + arr[i];
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def sortSentence(self, s: str) -> str:
        s = s.split()
        n = len(s)   # 单词数量
        arr = ["" for _ in range(n)]   # 单词数组
        for wd in s:
            # 计算位置索引对应的单词数组下标，并将单词放入对应位置
            # 数组下标为 0 开头，位置索引为 1 开头
            arr[int(wd[-1])-1] = wd[:-1]
        return " ".join(arr)
```

**复杂度分析**

- 时间复杂度：$O(m)$，其中 $m$ 为 $s$ 的长度。遍历字符串、维护单词数组、输出结果的时间复杂度均为 $O(m)$。

- 空间复杂度：$O(m)$，其中 $m$ 为 $s$ 的长度。即为建立并维护单词数组所需的空间。