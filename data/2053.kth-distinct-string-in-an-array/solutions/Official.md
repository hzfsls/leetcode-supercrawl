#### 方法一：哈希表

**思路与算法**

我们可以用哈希表来统计数组 $\textit{arr}$ 中每种字符串的频数。

统计完成后，我们顺序遍历数组，如果遍历到的字符串在数组中出现频数为 $1$，则我们将计数 $k$ 减去 $1$。当上述操作后 $k$ 到达 $0$ 时，对应的字符串即为第 $k$ 个独一无二的字符串，我们返回该字符串作为答案。若遍历完成数组，$k$ 仍未到达 $0$，则该数组中不存在第 $k$ 个独一无二的字符串，此时我们返回 $-1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string kthDistinct(vector<string>& arr, int k) {
        // 维护 arr 中每个字符串的频数
        unordered_map<string, int> freq;
        for (const string& s: arr){
            if (!freq.count(s)){
                freq[s] = 0;
            }
            ++freq[s];
        }
        // 遍历 arr 寻找第 k 个独一无二的字符串
        for (const string& s: arr){
            if (freq[s] == 1){
                --k;
                if (k == 0){
                    return s;
                }
            }
        }
        return "";
    }
};
```


```Python [sol1-Python3]
class Solution:
    def kthDistinct(self, arr: List[str], k: int) -> str:
        # 维护 arr 中每个字符串的频数
        freq = Counter(arr)
        # 遍历 arr 寻找第 k 个独一无二的字符串
        for s in arr:
            if freq[s] == 1:
                k -= 1
                if k == 0:
                    return s
        return ""
```


**复杂度分析**

- 时间复杂度：$O(\sum_i n_i)$，即数组 $\textit{arr}$ 中字符串长度总和，其中 $n_i$ 为字符串 $\textit{arr}[i]$ 的长度。即为维护频数哈希表和寻找第 $k$ 个独一无二的字符串的时间复杂度。

- 空间复杂度：$O(\sum_i n_i)$，即为哈希集合的空间开销。