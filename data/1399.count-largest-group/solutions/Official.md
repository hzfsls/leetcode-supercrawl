#### 方法一：哈希表

**思路**

对于 $[1, n]$ 中的每一个整数 $i$，我们可以计算出它的数位和 $s_i$。建立一个从数位和到原数字的哈希映射，对每一个数字 $i$，使键 $s_i$ 对应的值自增一。然后我们在值的集合中找到最大的值 $m$，再遍历哈希表，统计值为 $m$ 的个数即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def countLargestGroup(self, n: int) -> int:
        hashMap = collections.Counter()
        for i in range(1, n + 1): 
            key = sum([int(x) for x in str(i)])
            hashMap[key] += 1
        maxValue = max(hashMap.values())
        count = sum(1 for v in hashMap.values() if v == maxValue)
        return count
```

```C++ [sol1-C++]
class Solution {
public:
    int countLargestGroup(int n) {
        unordered_map<int, int> hashMap;
        int maxValue = 0;
        for (int i = 1; i <= n; ++i) {
            int key = 0, i0 = i;
            while (i0) {
                key += i0 % 10;
                i0 /= 10;
            }
            ++hashMap[key];
            maxValue = max(maxValue, hashMap[key]);
        }
        int count = 0;
        for (auto& kvpair: hashMap) {
            if (kvpair.second == maxValue) {
                ++count;
            }
        }
        return count;
    }
};
```

```C++ [sol1-C++17]
class Solution {
public:
    int countLargestGroup(int n) {
        unordered_map<int, int> hashMap;
        int maxValue = 0;
        for (int i = 1; i <= n; ++i) {
            int key = 0, i0 = i;
            while (i0) {
                key += i0 % 10;
                i0 /= 10;
            }
            ++hashMap[key];
            maxValue = max(maxValue, hashMap[key]);
        }
        int count = 0;
        for (auto& [_, value]: hashMap) {
            if (value == maxValue) {
                ++count;
            }
        }
        return count;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countLargestGroup(int n) {
        Map<Integer, Integer> hashMap = new HashMap<Integer, Integer>();
        int maxValue = 0;
        for (int i = 1; i <= n; ++i) {
            int key = 0, i0 = i;
            while (i0 != 0) {
                key += i0 % 10;
                i0 /= 10;
            }
            hashMap.put(key, hashMap.getOrDefault(key, 0) + 1);
            maxValue = Math.max(maxValue, hashMap.get(key));
        }
        int count = 0;
        for (Map.Entry<Integer, Integer> kvpair : hashMap.entrySet()) {
            if (kvpair.getValue() == maxValue) {
                ++count;
            }
        }
        return count;
    }
}
```

**复杂度分析**

- 时间复杂度：对数 $x$ 求数位和的时间为 $O(\log_{10} x) = O(\log x)$，因此总时间代价为 $O(n \log n)$，选出最大元素和遍历哈希表的时间代价均为 $O(n)$，故渐渐时间复杂度 $O(n \log n) + O(n) = O(n \log n)$。

- 空间复杂度：使用哈希表作为辅助空间，$n$ 的数位个数为 $O(\log_{10} n) = O(\log n)$，每一个数位都在 $[0, 9]$ 之间，故哈希表最多包含的键的个数为 $O(10 \log n) = O(\log n)$，渐进空间复杂度为 $O(\log n)$。