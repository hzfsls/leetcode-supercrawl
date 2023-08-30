#### 方法一：贪心算法

在每一步操作中，我们需要选择一个数 `x`，并且删除数组 `arr` 中所有的 `x`。显然选择的数 `x` 在数组 `arr` 中出现的次数越多越好。因此我们可以统计数组 `arr` 中每个数出现的次数，并进行降序排序。在得到了排序的结果之后，我们依次选择这些数进行删除，直到删除了至少一半的数。

在统计数组 `arr` 中每个数出现的次数时，我们可以借助哈希映射（HashMap），对于其中的每个键值对，键表示数 `x`，值表示数 `x` 出现的次数。在统计结束后，我们只要取出哈希映射中的所有值进行降序排序即可。在进行删除时，我们实际上也只需要将删除的数的个数进行累加，直到累加的值达到数组 `arr` 长度的一半，而不需要真正地将数组 `arr` 中的数删除。

```C++ [sol1-C++]
class Solution {
public:
    int minSetSize(vector<int>& arr) {
        unordered_map<int, int> freq;
        for (int num: arr) {
            ++freq[num];
        }
        vector<int> occ;
        for (auto& [k, v]: freq) {
            occ.push_back(v);
        }
        sort(occ.begin(), occ.end(), greater<int>());
        int cnt = 0, ans = 0;
        for (int c: occ) {
            cnt += c;
            ans += 1;
            if (cnt * 2 >= arr.size()) {
                break;
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minSetSize(self, arr: List[int]) -> int:
        freq = collections.Counter(arr)
        cnt, ans = 0, 0
        for num, occ in freq.most_common():
            cnt += occ
            ans += 1
            if cnt * 2 >= len(arr):
                break
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$，其中 $N$ 是数组 `arr` 的长度。

- 空间复杂度：$O(N)$。