#### 方法一：枚举 + 哈希集合去重

**思路与算法**

为了方便起见，我们可以首先考虑子数组**不会重复出现**的情况。

对于一个确定的整数数组 $\textit{nums}$，它的子数组可以由左边界和右边界唯一决定。因此我们可以通过枚举左边界和右边界来遍历 $\textit{nums}$ 的所有子数组，并检查它们是否至多含 $k$ 个可被 $p$ 整除的元素。

具体地，我们用 $\textit{res}$ 来维护符合要求子数组的个数。我们首先枚举左边界 $i$，对于某个左边界 $i$，我们在枚举右边界 $j$ 的同时用 $\textit{cnt}$ 统计子数组 $\textit{nums}[i..j]$ （闭区间）中可被 $p$ 整除的元素的个数。$\textit{cnt}$ 的初值为 $0$，如果 $\textit{nums}[j]$ 可以被 $p$ 整除，则我们将 $\textit{cnt}$ 加上 $1$。此时根据 $\textit{cnt}$ 和 $k$ 的大小关系，有两种情况：

- 如果此时 $\textit{cnt} \le k$，则说明子数组 $\textit{nums}[i..j]$ 符合要求，我们将 $\textit{res}$ 加上 $1$，并继续枚举右边界；

- 如果此时 $\textit{cnt} > k$，则说明子数组 $\textit{nums}[i..j]$ 不符合要求，同时后续即将遍历到的满足 $j_1 > j$ 的子数组 $\textit{nums}[i..j_1]$ 由于包含 $\textit{nums}[i..j]$ 显然也不符合要求，因此我们可以停止枚举右边界。

最终我们返回 $\textit{res}$ 作为答案即可。

随后我们考虑子数组**会重复出现**的情况。此时我们不能直接按照上文的方法统计个数，而需要对符合要求的子数组进行去重后计算。

我们可以用哈希集合来完成对应的去重操作。具体地，我们用哈希集合 $\textit{arrs}$ 来维护符合要求的子数组，按照与上文一致的遍历方法进行遍历，每当遍历到符合要求的子数组，我们将该子数组**序列化**（即通过**一一映射**转化为可哈希的元素）并放入哈希集合中。最终，我们返回 $\textit{arrs}$ 中的**元素个数**作为答案。

对于序列化的具体方式，对于 $\texttt{Python}$ 等语言，我们可以将子数组转化为可哈希的**元组**放入哈希表；而对于 $\texttt{C++}$ 等语言，我们可以将子数组转化为**字符串**后放入哈希表。

具体地，我们用 $s$ 表示序列化后的字符串。在每次开始遍历右边界前，我们初始化字符串。当遍历到对应下标时，我们将右边界对应的元素转化为字符串，并在末尾加上**分隔符** $\texttt{`\#'}$ 后添加进 $s$ 的尾部。可以证明，上述的序列化方式是一一映射。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countDistinct(vector<int>& nums, int k, int p) {
        unordered_set<string> arrs;   // 不同的（序列化后）子数组
        int n = nums.size();
        // 枚举左右边界
        for (int i = 0; i < n; ++i) {
            int cnt = 0;   // 当前被 p 整除的元素个数
            string s;   // 当前子数组序列胡后的字符串
            for (int j = i; j < n; ++j) {
                if (nums[j] % p == 0) {
                    ++cnt;
                    if (cnt > k) {
                        break;
                    }
                }
                // 序列化后放入哈希集合
                s.append(to_string(nums[j]));
                s.push_back('#');
                arrs.insert(s);
            }
        }
        return arrs.size();
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countDistinct(self, nums: List[int], k: int, p: int) -> int:
        arrs = set()   # 不同的（序列化后）子数组
        n = len(nums)
        # 枚举左右边界
        for i in range(n):
            cnt = 0   # 当前被 p 整除的元素个数
            arr = []   # 当前子数组
            for j in range(i, n):
                if nums[j] % p == 0:
                    cnt += 1
                    if cnt > k:
                        break
                arr.append(nums[j])
                # 序列化后放入哈希集合
                arrs.add(tuple(arr))
        return len(arrs)
```


**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。我们共需遍历 $O(n^2)$ 个子数组，序列化每个子数组并放入哈希集合的时间复杂度为 $O(n)$。

- 空间复杂度：$O(n^3)$，即为哈希集合的空间开销。