## [2191.将杂乱无章的数字排序 中文官方题解](https://leetcode.cn/problems/sort-the-jumbled-numbers/solutions/100000/jiang-za-luan-wu-zhang-de-shu-zi-pai-xu-9zrmp)
#### 方法一：自定义排序

**思路与算法**

对于每一个数而言，我们可以先把它转换成数位列表，例如将 $345$ 变为 $[3,4,5]$，然后通过给定的映射规则 $\textit{mapping}$ 将其映射，最后再从数位列表恢复成一个数。

记上述的转换过程为函数 $\textit{transfer}$，那么对于数组 $\textit{nums}$ 中的每一个元素 $\textit{nums}[i]$，我们构建二元组 $(\textit{transfer}(\textit{nums}[i]), \textit{nums}[i])$，那么在排序时，我们只需要根据二元组中 $\textit{transfer}(\textit{nums}[i])$ 进行升序排序即可。

注意到题目中要求「如果两个数字映射后对应的数字大小相同，则将它们按照输入中的**相对顺序**排序」，因此如果使用的语言中提供了稳定排序，那么我们可以直接使用稳定排序；如果没有提供稳定排序，那么需要使用三元组 $(\textit{transfer}(\textit{nums}[i]), i, \textit{nums}[i])$ 代替之前的二元组，并按照 $\textit{transfer}(\textit{nums}[i])$ 为第一关键字、$i$ 为第二关键字进行升序排序，这样就能满足题目中的要求。

在排序结束后，我们从二元组（或三元组）中提取出原始的元素并组成列表，即可得到最终的答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> sortJumbled(vector<int>& mapping, vector<int>& nums) {
        auto transfer = [&](int x) -> int {
            if (x == 0) {
                return mapping[0];
            }
            
            vector<int> digits;
            while (x) {
                digits.push_back(x % 10);
                x /= 10;
            }
            int num = 0;
            for (int i = digits.size() - 1; i >= 0; --i) {
                num = num * 10 + mapping[digits[i]];
            }
            return num;
        };
        
        vector<pair<int, int>> num_pairs;
        for (int num: nums) {
            num_pairs.emplace_back(transfer(num), num);
        }
        stable_sort(num_pairs.begin(), num_pairs.end(), [](const auto& lhs, const auto& rhs) {
            return lhs.first < rhs.first;
        });

        vector<int> ans;
        for (const auto& [_, num]: num_pairs) {
            ans.push_back(num);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def sortJumbled(self, mapping: List[int], nums: List[int]) -> List[int]:
        def transfer(x: int) -> int:
            return int("".join(str(mapping[int(digit)]) for digit in str(x)))
        
        num_pairs = [(transfer(num), num) for num in nums]
        num_pairs.sort(key=lambda pair: pair[0])
        
        ans = [num for (_, num) in num_pairs]
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n (\log n + \log C))$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是数组 $\textit{nums}$ 中的元素范围，$\log C$ 即为元素的位数。

    - 计算所有映射需要的时间为 $O(n \log C)$；
    
    - 排序需要的时间为 $O(n \log n)$；

    - 构造答案需要的时间为 $O(n)$。

- 空间复杂度：$O(n)$，即为存储二元组（或三元组）需要的空间。