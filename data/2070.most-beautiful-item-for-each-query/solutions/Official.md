## [2070.每一个查询的最大美丽值 中文官方题解](https://leetcode.cn/problems/most-beautiful-item-for-each-query/solutions/100000/mei-yi-ge-cha-xun-de-zui-da-mei-li-zhi-b-d8jw)

#### 方法一：排序 + 二分查找

**思路与算法**

我们假设物品总数为 $n$，对于单次查询，一种朴素的方法是遍历整个数组，寻找价格符合要求的物品并维护其最大美丽值，但这样的时间复杂度为 $O(n)$，假设查询总数为 $q$，则总时间复杂度为 $O(nq)$，这样的复杂度无法通过本题。因此我们需要优化单次查询的时间复杂度。

我们可以将单次查询的过程分为两步：

- 第一步，寻找到所有价格小于等于查询价格的物品；

- 第二步，求出这些物品中的最大美丽值。

对于第一步，我们可以将 $\textit{items}$ 数组按照物品的价格升序排序，此时一定存在一个下标（可能不合法），下标大于它的物品（可能不存在）的价格高于查询价格，下标小于等于它的物品（可能不存在）的价格不高于查询价格。我们可以在 $O(n\log n)$ 的时间内完成上述预处理，同时我们可以通过二分查找在 $O(\log n)$ 的时间复杂度中查找到该下标。

对于第二步，在第一步的基础上，我们将排序后数组中每个物品的美丽值（$\textit{items}[i][1]$）修改为**下标小于等于 $i$ 的物品的最大美丽值**。这一过程可以在 $O(n)$ 的时间复杂度下，通过从左至右的一次遍历完成。这样，当我们找到第一步对应的下标时，如果下标合法，则该下标对应的**修改后的**美丽值即为价格小于等于查询价格中物品的最大美丽值，我们将该值作为查询值；如果下标不合法，那么说明所有物品的价格均高于查询价格，此时查询到结果应当为 $0$。

根据上文的分析，我们首先对 $\textit{items}$ 数组按照物品的价格升序排序，并遍历数组，将下标为 $i$ 物品的美丽值修改为下标小于等于 $i$ 的物品的最大美丽值。随后，对于每个查询，我们用函数 $\textit{query}(q)$ 求出价格小于等于 $q$ 的物品的最大美丽值。

在函数 $\textit{query}(q)$ 中，我们首先通过二分查找求出价格不高于 $q$ 的物品的下标最大值，如果该值合法，则返回 $\textit{items}$ 数组中该下标对应的修改后的美丽值作为查询结果；如果该值不合法，则返回 $0$ 作为查询结果。

我们按顺序处理查询，记录查询结果，并将最终的结果返回作为答案。

**细节**

在排序时，我们只需要将价格设为排序的**唯一关键字**，因为二分查找得到的下标（如果合法）一定为相同价格中**最大的**，因此该下标对应的修改后的美丽值一定为价格小于等于查询价格中物品的最大美丽值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> maximumBeauty(vector<vector<int>>& items, vector<int>& queries) {
        // 将物品按价格升序排序
        sort(items.begin(), items.end(), [](auto&& item1, auto&& item2) {
            return item1[0] < item2[0]; 
        });
        int n = items.size();
        // 按定义修改美丽值
        for (int i = 1; i < n; ++i){
            items[i][1] = max(items[i][1], items[i-1][1]);
        }
        // 二分查找处理查询
        auto query = [&](int q) -> int{
            int l = 0, r = n;
            while (l < r){
                int mid = l + (r - l) / 2;
                if (items[mid][0] > q){
                    r = mid;
                }
                else{
                    l = mid + 1;
                }
            }
            if (l == 0){
                // 此时所有物品价格均大于查询价格
                return 0;
            }
            else{
                // 返回小于等于查询价格的物品的最大美丽值
                return items[l-1][1];
            }
        };
        
        vector<int> res;
        for (int q: queries){
            res.push_back(query(q));
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def maximumBeauty(self, items: List[List[int]], queries: List[int]) -> List[int]:
        # 将物品按价格升序排序
        items.sort(key=lambda x: x[0])
        n = len(items)
        # 按定义修改美丽值
        for i in range(1, n):
            items[i][1] = max(items[i][1], items[i-1][1])
        # 二分查找处理查询
        def query(q: int) -> int:
            l, r = 0, n
            while l < r:
                mid = l + (r - l) // 2
                if items[mid][0] > q:
                    r = mid
                else:
                    l = mid + 1
            if l == 0:
                # 此时所有物品价格均大于查询价格
                return 0
            else:
                # 返回小于等于查询价格的物品的最大美丽值
                return items[l-1][1]
        
        res = [query(q) for q in queries]
        return res
```


**复杂度分析**

- 时间复杂度：$O(n\log n + q\log n)$，其中 $n$ 为 $\textit{items}$ 的长度，$q$ 为 $\textit{queries}$ 的长度。对 $\textit{items}$ 数组按价格排序并更新美丽值的时间复杂度为 $O(n\log n)$，单次二分查找查询最大美丽值的时间复杂度为 $O(\log n)$，共需进行 $q$ 次查询。

- 空间复杂度：$O(\log n)$，即为排序的栈空间开销。