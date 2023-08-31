## [575.分糖果 中文官方题解](https://leetcode.cn/problems/distribute-candies/solutions/100000/fen-tang-guo-by-leetcode-solution-l4f6)

#### 方法一：贪心

一方面，设糖果数量为 $n$，由于妹妹只能分到一半的糖果，所以答案不会超过 $\dfrac{n}{2}$；另一方面，设这些糖果一共有 $m$ 种，答案也不会超过 $m$。

若 $m\le\dfrac{n}{2}$，则可以每种糖果至少分一颗给妹妹，此时答案为 $m$；若 $m>\dfrac{n}{2}$，则妹妹只能分到 $\dfrac{n}{2}$ 种糖果，每种糖果分一颗，此时答案为 $\dfrac{n}{2}$。

综上所述，答案为 $\min\Big(m,\dfrac{n}{2}\Big)$。

```Python [sol1-Python3]
class Solution:
    def distributeCandies(self, candyType: List[int]) -> int:
        return min(len(set(candyType)), len(candyType) // 2)
```

```C++ [sol1-C++]
class Solution {
public:
    int distributeCandies(vector<int> &candyType) {
        return min(unordered_set<int>(candyType.begin(), candyType.end()).size(), candyType.size() / 2);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int distributeCandies(int[] candyType) {
        Set<Integer> set = new HashSet<Integer>();
        for (int candy : candyType) {
            set.add(candy);
        }
        return Math.min(set.size(), candyType.length / 2);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int DistributeCandies(int[] candyType) {
        ISet<int> set = new HashSet<int>();
        foreach (int candy in candyType) {
            set.Add(candy);
        }
        return Math.Min(set.Count, candyType.Length / 2);
    }
}
```

```go [sol1-Golang]
func distributeCandies(candyType []int) int {
    set := map[int]struct{}{}
    for _, t := range candyType {
        set[t] = struct{}{}
    }
    ans := len(candyType) / 2
    if len(set) < ans {
        ans = len(set)
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var distributeCandies = function(candyType) {
    const set = new Set(candyType);
    return Math.min(set.size, candyType.length / 2);
};
```

```TypeScript [sol1-TypeScript]
var distributeCandies = function(candyType) {
    const set = new Set(candyType);
    return Math.min(set.size, candyType.length / 2);
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{candies}$ 的长度。

- 空间复杂度：$O(n)$。哈希表需要 $O(n)$ 的空间。