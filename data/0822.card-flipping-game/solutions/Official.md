## [822.翻转卡片游戏 中文官方题解](https://leetcode.cn/problems/card-flipping-game/solutions/100000/fan-zhuan-qia-pian-you-xi-by-leetcode-so-acbj)
#### 方法一：哈希集

**思路与算法**

如果一张卡片正反两面有相同的数字，那么这张卡片无论怎么翻转，正面都是这个数字，这个数字即不能是最后所选的数字 $x$。

按照这个思路，我们首先遍历所有卡片，如果卡片上的两个数字相同，则加入哈希集合 $\textit{same}$ 中，除此集合外的所有数字，都可以被选做 $x$， 我们只需要再次遍历所有数字，找到最小值即可。

最后，我们返回找到的最小值，如果没有则返回 $0$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int flipgame(vector<int>& fronts, vector<int>& backs) {
        int res = 3000, n = fronts.size();
        unordered_set<int> same;
        for (int i = 0; i < n; ++i) {
            if (fronts[i] == backs[i]) {
                same.insert(fronts[i]);
            }
        }
        for (int &x : fronts) {
            if (x < res && same.count(x) == 0) {
                res = x;
            }
        }
        for (int &x : backs) {
            if (x < res && same.count(x) == 0) {
                res = x;
            }
        }
        return res % 3000;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int flipgame(int[] fronts, int[] backs) {
        Set<Integer> same = new HashSet();
        for (int i = 0; i < fronts.length; ++i) {
            if (fronts[i] == backs[i]) {
                same.add(fronts[i]);
            }
        }
        int res = 3000;
        for (int x : fronts) {
            if (x < res && !same.contains(x)){
                res = x;
            }
        }
        for (int x : backs) {
            if (x < res && !same.contains(x)) {
                res = x;
            }
        }
        return res % 3000;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def flipgame(self, fronts: List[int], backs: List[int]) -> int:
        n = len(fronts)
        same = set()
        for i in range(n):
            if fronts[i] == backs[i]:
                same.add(fronts[i])
        res = 3000
        for a in fronts:
            if a < res and a not in same:
                res = a
        for a in backs:
            if a < res and a not in same:
                res = a
        return res if res < 3000 else 0
```

```Go [sol1-Go]
func flipgame(fronts, backs []int) int {
    same := make(map[int]bool)
    for i := range fronts {
        if fronts[i] == backs[i] {
            same[fronts[i]] = true
        }
    }
    res := 3000
    for _, x := range fronts {
        if x < res && !same[x] {
        	res = x
        }
    }
    for _, x := range backs {
        if x < res && !same[x] {
            res = x
        }
    }
    return res % 3000
}
```

```JavaScript [sol1-JavaScript]
var flipgame = function(fronts, backs) {
    const same = new Set();
    for (let i = 0; i < fronts.length; i++) {
        if (fronts[i] === backs[i]) {
            same.add(fronts[i]);
        }
    }
    let res = 3000;
    for (let x of fronts) {
        if (x < res && !same.has(x)) {
            res = x;
        }
    }
    for (let x of backs) {
        if (x < res && !same.has(x)) {
            res = x;
        }
    }
    return res % 3000;
};
```

```C# [sol1-C#]
public class Solution {
    public int Flipgame(int[] fronts, int[] backs) {
        var same = new HashSet<int>();
        for (int i = 0; i < fronts.Length; i++) {
            if (fronts[i] == backs[i]) {
                same.Add(fronts[i]);
            }
        }
        int res = 3000;
        foreach (var x in fronts) {
            if (x < res && !same.Contains(x)) {
                res = x;
            }
        }
        foreach (var x in backs) {
            if (x < res && !same.Contains(x)) {
                res = x;
            }
        }
        return res % 3000;
    }
}
```

```C [sol1-C]
int flipgame(int* fronts, int frontsSize, int* backs, int backsSize){
    int res = 3000, n = backsSize;
    bool same[2001];
    memset(same, false, sizeof(same));
    for (int i = 0; i < n; i++) {
        if (fronts[i] == backs[i]) {
            same[fronts[i]] = true;
        }
    }
    for (int i = 0; i < n; ++i) {
        if (fronts[i] < res && !same[fronts[i]]) {
            res = fronts[i];
        }
        if (backs[i] < res && !same[backs[i]]) {
            res = backs[i];
        }
    }
    return res % 3000;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是卡片个数。

- 空间复杂度：$O(n)$，其中 $n$ 是卡片个数。