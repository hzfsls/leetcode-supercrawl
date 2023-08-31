## [1577.数的平方等于两数乘积的方法数 中文官方题解](https://leetcode.cn/problems/number-of-ways-where-square-of-number-is-equal-to-product-of-two-numbers/solutions/100000/shu-de-ping-fang-deng-yu-liang-shu-cheng-ji-de-fan)
#### 方法一：哈希表

直观的做法是暴力枚举符合规则的三元组的数目。寻找类型 $1$ 的三元组时，首先遍历数组 $\textit{nums}_1$，对于其中的每个元素，遍历数组 $\textit{nums}_2$ 中的**每一对**元素，找到符合规则的三元组的数目。然后使用同样的方法寻找类型 $2$ 的三元组。假设数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度分别为 $m$ 和 $n$，则暴力法的时间复杂度为 $O(mn^2+m^2n)$。

由于每个数组都可能包含重复元素，因此暴力法可能有大量重复计算，可以通过避免重复计算的做法降低时间复杂度。

考虑类型 $1$ 的三元组 $(i,j,k)$，满足 $\textit{nums}_1[i]^2==\textit{nums}_2[j] \times \textit{nums}_2[k]$，其中 $0 \le i \le m$ 和 $0 \le j < k < n$。如果 $\textit{nums}_1$ 中有和 $\textit{nums}_1[i]$ 重复的元素，$\textit{nums}_2$ 中有和 $\textit{nums}_2[j]$ 以及 $\textit{nums}_2[k]$ 重复的元素，则用重复元素替换对应的数字，规则仍然成立。因此，符合规则的三元组的数目与两个数组中的每个元素的出现次数有关。

使用两个哈希表分别存储数组 $\textit{nums}_1$ 中的每个元素出现的次数和数组 $\textit{nums}_2$ 中的每个元素出现的次数，并分别使用集合 $\textit{set}_1$ 和 $\textit{set}_2$ 存储数组 $\textit{nums}_1$ 中的元素和数组 $\textit{nums}_2$ 中的元素，在遍历元素时可以遍历两个集合，避免重复访问相同元素。

寻找类型 $1$ 的三元组时，遍历集合 $\textit{set}_1$ 中的每个元素，对于每个元素，遍历集合 $\textit{set}_2$ 找到类型 $1$ 的三元组个数。对于集合 $\textit{set}_1$ 中的元素 $\textit{num}_1$，需要在集合 $\textit{set}_2$ 中寻找到所有的二元组 $(\textit{num}_2,\textit{num}_3)$，满足 $\textit{num}_2 \le \textit{num}_3$ 且 $\textit{num}_1^2==\textit{num}_2 \times \textit{num}_3$。

假设 $\textit{num}_1$ 在数组 $\textit{nums}_1$ 中出现的次数是 $\textit{count}_1$，$\textit{num}_2$ 和 $\textit{num}_3$ 在数组 $\textit{nums}_2$ 中出现的次数分别是 $\textit{count}_2$ 和 $\textit{count}_3$，则这三个数对应的类型 $1$ 的三元组的数目计算方式如下：

- 如果 $\textit{num}_2==\textit{num}_3$，则三元组的数目是 $\textit{count}_1 \times \textit{count}_2 \times (\textit{count}_2 - 1) / 2$；

- 如果 $\textit{num}_2<\textit{num}_3$，则三元组的数目是 $\textit{count}_1 \times \textit{count}_2 \times \textit{count}_3$。

在计算类型 $1$ 的三元组数目之后，可以使用同样的方法计算类型 $2$ 的三元组数目。

```Java [sol1-Java]
class Solution {
    public int numTriplets(int[] nums1, int[] nums2) {
        Map<Integer, Integer> map1 = new HashMap<Integer, Integer>();
        Map<Integer, Integer> map2 = new HashMap<Integer, Integer>();
        for (int num : nums1) {
            int count = map1.getOrDefault(num, 0) + 1;
            map1.put(num, count);
        }
        for (int num : nums2) {
            int count = map2.getOrDefault(num, 0) + 1;
            map2.put(num, count);
        }
        return getTriplets(map1, map2) + getTriplets(map2, map1);
    }

    public int getTriplets(Map<Integer, Integer> map1, Map<Integer, Integer> map2) {
        int triplets = 0;
        Set<Integer> set1 = map1.keySet();
        Set<Integer> set2 = map2.keySet();
        for (int num1 : set1) {
            int count1 = map1.get(num1);
            long square = (long) num1 * num1;
            for (int num2 : set2) {
                if (square % num2 == 0 && square / num2 <= Integer.MAX_VALUE) {
                    int num3 = (int) (square / num2);
                    if (num2 == num3) {
                        int count2 = map2.get(num2);
                        int curTriplets = count1 * count2 * (count2 - 1) / 2;
                        triplets += curTriplets;
                    } else if (num2 < num3 && set2.contains(num3)) {
                        int count2 = map2.get(num2), count3 = map2.get(num3);
                        int curTriplets = count1 * count2 * count3;
                        triplets += curTriplets;
                    }
                }
            }
        }
        return triplets;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int getTriplets(const unordered_map<int, int>& map1, const unordered_map<int, int>& map2) {
        int triplets = 0;
        for (const auto& [num1, count1]: map1) {
            long long square = (long long)num1 * num1;
            for (const auto& [num2, count2]: map2) {
                if (square % num2 == 0 && square / num2 <= INT_MAX) {
                    int num3 = square / num2;
                    if (num2 == num3) {
                        int curTriplets = count1 * count2 * (count2 - 1) / 2;
                        triplets += curTriplets;
                    } else if (num2 < num3 && map2.count(num3)) {
                        int count3 = map2.at(num3);
                        int curTriplets = count1 * count2 * count3;
                        triplets += curTriplets;
                    }
                }
            }
        }
        return triplets;
    }

    int numTriplets(vector<int>& nums1, vector<int>& nums2) {
        unordered_map<int, int> map1, map2;
        for (int num: nums1) {
            ++map1[num];
        }
        for (int num: nums2) {
            ++map2[num];
        }
        return getTriplets(map1, map2) + getTriplets(map2, map1);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numTriplets(self, nums1: List[int], nums2: List[int]) -> int:
        def getTriplets(map1: Counter, map2: Counter):
            triplets = 0
            for num1, count1 in map1.items():
                square = num1 * num1
                for num2, count2 in map2.items():
                    if square % num2 == 0:
                        num3 = square // num2
                        if num2 == num3:
                            curTriplets = count1 * count2 * (count2 - 1) // 2
                            triplets += curTriplets
                        elif num2 < num3 and num3 in map2:
                            count3 = map2[num3]
                            curTriplets = count1 * count2 * count3
                            triplets += curTriplets
            return triplets

        map1 = collections.Counter(nums1)
        map2 = collections.Counter(nums2)
        return getTriplets(map1, map2) + getTriplets(map2, map1)
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度。
  遍历两个数组，分别将两个数组中的每个元素出现的次数存入两个哈希表，时间复杂度是 $O(m+n)$；
  寻找类型 $1$ 的三元组，需要不重复地遍历数组 $\textit{nums}_1$ 中的每个元素，并对每个元素不重复地遍历数组 $\textit{nums}_2$ 中的每个元素，时间复杂度是 $O(mn)$；
  寻找类型 $2$ 的三元组，时间复杂度也是 $O(mn)$。
  因此总时间复杂度是 $O(mn)$。

- 空间复杂度：$O(m+n)$，其中 $m$ 和 $n$ 分别是数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度。空间复杂度取决于两个哈希表，两个哈希表的大小都不会超过对应的数组的长度。