## [2080.区间内查询数字的频率 中文官方题解](https://leetcode.cn/problems/range-frequency-queries/solutions/100000/qu-jian-nei-cha-xun-shu-zi-de-pin-lu-by-wh4ez)
#### 方法一：哈希表 + 二分查找

**思路与算法**

我们假设数组 $\textit{arr}$ 的长度为 $n$。对于单次查询，一种朴素的方法是遍历数组下标在闭区间 $[\textit{left}, \textit{right}]$ 内的所有数，维护目标数 $\textit{value}$ 的出现次数，但这样的时间复杂度为 $O(n)$，假设查询总数为 $q$，则总时间复杂度为 $O(nq)$，这样的复杂度无法通过本题。因此我们需要优化单次查询的时间复杂度。

我们可以将单次查询分解为两个部分：

- 第一步，得到目标数 $\textit{value}$ 在数组 $\textit{arr}$ 中出现的所有下标；

- 第二步，在这些下标中计算位于闭区间 $[\textit{left}, \textit{right}]$ 的下标个数并返回。

对于第一步，由于在本题中数组 $\textit{arr}$ 在生成后**不会发生改变**，因此我们可以预处理数组中每个数的出现下标，并对于每个数用相应**数组**维护。同时，为了优化查询每个数对应下标的时间复杂度，我们可以用数值为键，对应下标数组为值的**哈希表**来维护。这样，我们可以在 $\textit{RangeFreqQuery}$ 类初始化时，以 $O(n)$ 的时间复杂度完成哈希表的初始化，并在每次查询时以 $O(1)$ 的时间复杂度查询到该数值对应的（如有）下标数组。

对于第二步，只要我们可以保证下标数组的**有序性**，就可以利用两次二分查找，$O(\log n)$ 的时间复杂度下计算出位于闭区间 $[\textit{left}, \textit{right}]$ 的下标个数。事实上，只需要我们在第一步中提到的初始化过程中，**顺序遍历**数组 $\textit{arr}$，并始终将新的下标放入对应下标数组的末尾，那么哈希表中所有的下标数组都可以保证有序。

根据上文的分析，我们首先在 $\textit{RangeFreqQuery}$ 类初始化时建立以数值为键，对应出现下标数组为值的哈希表 $\textit{occurence}$，随后顺序遍历数组 $\textit{arr}$，将数值与对应下标加入哈希表。具体地：

- 如果该数值不存在，我们在哈希表 $\textit{occurence}$ 中建立该数值为键，空数组为值的键值对，并将当前下标加入该空数组末尾；

- 如果该数值存在，我们直接将当前下标加入该数值在 $\textit{occurence}$ 中对应的下标数组的末尾。

处理每次查询时，我们首先检查目标数 $\textit{value}$ 是否存在于哈希表中：如果不存在，则出现次数为 $0$；如果存在，则我们通过两次二分查找寻找到数组中**第一个大于等于** $\textit{left}$ 的位置 $l$ 与**第一个大于** $\textit{right}$ 的位置 $r$，此时 $r - l$ 即为符合要求的下标个数（子数组中目标数的出现次数），我们返回该数作为答案。

**代码**

```C++ [sol1-C++]
class RangeFreqQuery {
private: 
    // 数值为键，出现下标数组为值的哈希表
    unordered_map<int, vector<int>> occurence;
    
public:
    RangeFreqQuery(vector<int>& arr) {
        // 顺序遍历数组初始化哈希表
        int n = arr.size();
        for (int i = 0; i < n; ++i){
            occurence[arr[i]].push_back(i);
        }
    }
    
    int query(int left, int right, int value) {
        // 查找对应的出现下标数组，不存在则为空
        const vector<int>& pos = occurence[value];
        // 两次二分查找计算子数组内出现次数
        auto l = lower_bound(pos.begin(), pos.end(), left);
        auto r = upper_bound(pos.begin(), pos.end(), right);
        return r - l;
    }
};
```


```Python [sol1-Python3]
class RangeFreqQuery:

    def __init__(self, arr: List[int]):
        # 数值为键，出现下标数组为值的哈希表
        self.occurence = defaultdict(list)
        # 顺序遍历数组初始化哈希表
        n = len(arr)
        for i in range(n):
            self.occurence[arr[i]].append(i)

    def query(self, left: int, right: int, value: int) -> int:
        # 查找对应的出现下标数组，不存在则为空
        pos = self.occurence[value]
        # 两次二分查找计算子数组内出现次数
        l = bisect_left(pos, left)
        r = bisect_right(pos, right)
        return r - l
```


**复杂度分析**

- 时间复杂度：$O(n + q \log n)$，其中 $n$ 为 $\textit{arr}$ 的长度, $q$ 为调用 $\textit{query}$ 的次数。初始化哈希表的时间复杂度为 $O(n)$，每次查询的时间复杂度为 $O(\log n)$。

- 空间复杂度：$O(n)$，即为哈希表的空间开销。