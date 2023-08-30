#### 方法一：排序 + 贪心

对于数组 $\textit{arr}$ 中的任意一个整数 $x$，如果它一共出现了 $y$ 次，那么我们必须将这 $y$ 个 $x$ 全部移除，才能使得数组 $\textit{arr}$ 中不同整数的数目减少 $1$。因此，要想使得不同整数的数目最少，我们应当优先删除出现次数少的那些整数。

我们首先使用哈希映射（HashMap）统计每个整数出现的次数，在这之后，我们将每个键值对（键表示一个整数，值表示该整数出现的次数）按照值从小到大进行排序。我们遍历排序的结果，并进行移除，一旦剩余可以移除的次数小于遍历到的值，就结束遍历并返回结果。

```C++ [sol1-C++]
class Solution {
public:
    int findLeastNumOfUniqueInts(vector<int>& arr, int k) {
        unordered_map<int, int> group;
        for (int num: arr) {
            ++group[num];
        }
        
        vector<pair<int, int>> freq(group.begin(), group.end());
        sort(freq.begin(), freq.end(), [](const auto& u, const auto& v) {return u.second < v.second;});
        
        int ans = freq.size();
        for (auto [_, occ]: freq) {
            if (k >= occ) {
                --ans;
                k -= occ;
            } else {
                break;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findLeastNumOfUniqueInts(int[] arr, int k) {
        Map<Integer, Integer> group = new HashMap<Integer, Integer>();
        for (int num : arr) {
            int count = group.getOrDefault(num, 0) + 1;
            group.put(num, count);
        }

        List<int[]> freq = new ArrayList<int[]>();
        for (Map.Entry<Integer, Integer> entry : group.entrySet()) {
            int[] keyValue = {entry.getKey(), entry.getValue()};
            freq.add(keyValue);
        }
        Collections.sort(freq, new Comparator<int[]>() {
            public int compare(int[] keyValue1, int[] keyValue2) {
                return keyValue1[1] - keyValue2[1];
            }
        });

        int ans = freq.size();
        for (int i = 0; i < freq.size(); i++) {
            int occ = freq.get(i)[1];
            if (k >= occ) {
                --ans;
                k -= occ;
            } else {
                break;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findLeastNumOfUniqueInts(self, arr: List[int], k: int) -> int:
        group = collections.Counter(arr)
        freq = group.most_common()[::-1]
        ans = len(freq)
        for _, occ in freq:
            if k >= occ:
                ans -= 1
                k -= occ
            else:
                break
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。构造哈希映射的时间复杂度为 $O(n)$，在最坏情况下，数组 $\textit{arr}$ 中的数互不相同，哈希映射中有 $n$ 个键值对，因此排序的时间复杂度为 $O(n \log n)$。最后遍历的时间复杂度也为 $O(n)$，因此总时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$，在最坏情况下，哈希表需要 $O(n)$ 的空间，同时也需要 $O(n)$ 的空间存放排序的结果。