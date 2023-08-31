## [2094.找出 3 位偶数 中文官方题解](https://leetcode.cn/problems/finding-3-digit-even-numbers/solutions/100000/zhao-chu-3-wei-ou-shu-by-leetcode-soluti-hptf)
#### 方法一：枚举数组中的元素组合

**思路与算法**

我们可以从数组中枚举目标整数的三个整数位，判断组成的整数是否满足以下条件：

- 整数为**偶数**；

- 整数**不包含前导零**（即整数不小于 $100$）；

- 三个整数位对应的数组下标**不能重复**。

为了避免重复，我们用一个哈希集合来维护符合要求的 $3$ 位偶数，如果枚举产生的整数满足上述三个条件，则我们将该整数加入哈希集合。

最终，我们将该哈希集合内的元素放入数组中，按照递增顺序排序并返回。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findEvenNumbers(vector<int>& digits) {
        unordered_set<int> nums;   // 目标偶数集合
        int n = digits.size();
        // 遍历三个数位的下标
        for (int i = 0; i < n; ++i){
            for (int j = 0; j < n; ++j){
                for (int k = 0; k < n; ++k){
                    // 判断是否满足目标偶数的条件
                    if (i == j || j == k || i == k){
                        continue;
                    }
                    int num = digits[i] * 100 + digits[j] * 10 + digits[k];
                    if (num >= 100 && num % 2 == 0){
                        nums.insert(num);
                    }
                }
            }
        }
        // 转化为升序排序的数组
        vector<int> res;
        for (const int num: nums){
            res.push_back(num);
        }
        sort(res.begin(), res.end());
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def findEvenNumbers(self, digits: List[int]) -> List[int]:
        nums = set()   # 目标偶数集合
        n = len(digits)
        # 遍历三个数位的下标
        for i in range(n):
            for j in range(n):
                for k in range(n):
                    # 判断是否满足目标偶数的条件
                    if i == j or j == k or i == k:
                        continue
                    num = digits[i] * 100 + digits[j] * 10 + digits[k]
                    if num >= 100 and num % 2 == 0:
                        nums.add(num)
        # 转化为升序排序的数组
        res = sorted(list(nums))
        return res
```


**复杂度分析**

- 时间复杂度：$O(n^3 + M \log M)$，其中 $M = \min(n^3, 10^k)$ 代表符合要求偶数的数量， $n$ 为 $\textit{digits}$ 的长度，$k$ 为目标偶数的位数。枚举所有元素组合的时间复杂度为 $O(n^3)$，对符合要求偶数集合排序的时间复杂度为 $O(M \log M)$。

- 空间复杂度：$O(M)$，即为符合要求整数的哈希集合的空间开销。



#### 方法二：遍历所有可能的 $3$ 位偶数

**思路与算法**

我们也可以从小到大遍历所有 $3$ 位偶数（即 $[100, 999]$ 闭区间内的所有偶数），并判断对应的三个整数位是否为 $\textit{digits}$ 数组中三个不同元素。如果是，则该偶数为目标偶数；反之亦然。

具体地，我们首先用哈希表 $\textit{freq}$ 维护 $\textit{digits}$ 数组中每个数出现的次数。在遍历偶数时，我们同样用哈希表 $\textit{freq}_1$ 维护每个偶数中每个数位出现的次数。此时，该偶数能够被数组中不重复元素表示的**充要条件**即为：

$\textit{freq}_1$ 中每个元素的出现次数都不大于它在 $\textit{freq}$ 中的出现次数。

我们按照上述条件判断每个偶数是否为目标偶数，并按顺序统计这些偶数。最终，我们返回目标偶数的数组作为答案。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findEvenNumbers(vector<int>& digits) {
        vector<int> res;   // 目标偶数数组
        unordered_map<int, int> freq;   // 整数数组中各数字的出现次数
        for (const int digit: digits){
            ++freq[digit];
        }
       // 枚举所有三位偶数，维护整数中各数位的出现次数并比较判断是否为目标偶数
        for (int i = 100; i < 1000; i += 2){
            unordered_map<int, int> freq1;
            int tmp = i;
            while (tmp){
                ++freq1[tmp%10];
                tmp /= 10;
            }
            if (all_of(freq1.begin(), freq1.end(), [&](const auto& x){
                    return freq[x.first] >= freq1[x.first]; 
                })){
                res.push_back(i);
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def findEvenNumbers(self, digits: List[int]) -> List[int]:
        res = []   # 目标偶数数组
        freq = Counter(digits)   # 整数数组中各数字的出现次数
        # 枚举所有三位偶数，维护整数中各数位的出现次数并比较判断是否为目标偶数
        for i in range(100, 1000, 2):
            freq1 = Counter([int(d) for d in str(i)])
            if all(freq[d] >= freq1[d] for d in freq1.keys()):
                res.append(i)
        return res
```


**复杂度分析**

- 时间复杂度：$O(k\cdot10^k)$，其中 $k$ 为目标偶数的位数。即为枚举所有给定位数偶数的时间复杂度。

- 空间复杂度：$O(1)$，输出数组不计入空间复杂度。