#### 方法一：转化为整数

**思路与算法**

我们可以将长度为 $n$ 的二进制字符串看作 $[0, 2^n - 1]$ 闭区间内正整数的二进制表示，这样就建立起了字符串和整数之间的**一一映射**。

我们可以将 $\textit{nums}$ 中所有字符串转化为对应的整数放在哈希集合中。由于该哈希集合中有 $n$ 个元素，因此根据鸽巢原理，在 $[0, n]$ **闭区间**的 $n + 1$ 个整数中一定存在一个整数，它不在该哈希集合中。换言之，该整数对应的字符串一定没有在 $\textit{nums}$ 中出现。

因此，在预处理哈希集合后，我们只需要遍历 $[0, n]$ 闭区间中的整数，当找到第一个不在哈希集合中的整数时，我们将它转化为对应的二进制字符串返回即可。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    string findDifferentBinaryString(vector<string>& nums) {
        int n = nums.size();
        // 预处理对应整数的哈希集合
        unordered_set<int> vals;
        for (const string& num : nums){
            vals.insert(stoi(num, nullptr, 2));
        }
        // 寻找第一个不在哈希集合中的整数
        int val = 0;
        while (vals.count(val)){
            ++val;
        }
        // 将整数转化为二进制字符串返回
        return bitset<16>(val).to_string().substr(16 - n, 16);
    }
};
```


```Python [sol1-Python3]
class Solution:
    def findDifferentBinaryString(self, nums: List[str]) -> str:
        n = len(nums)
        # 预处理对应整数的哈希集合
        vals = {int(num, 2) for num in nums}
        # 寻找第一个不在哈希集合中的整数
        val = 0
        while val in vals:
            val += 1
        # 将整数转化为二进制字符串返回
        res = "{:b}".format(val)
        return '0' * (n - len(res)) + res
```


**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为 $\textit{nums}$ 的长度。预处理哈希集合的时间复杂度为 $O(n^2)$，寻找第一个不在哈希表中的整数与生成答案字符串的时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，即为哈希集合的空间复杂度。