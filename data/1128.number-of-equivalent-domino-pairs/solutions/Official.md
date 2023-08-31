## [1128.等价多米诺骨牌对的数量 中文官方题解](https://leetcode.cn/problems/number-of-equivalent-domino-pairs/solutions/100000/deng-jie-duo-mi-nuo-gu-pai-dui-de-shu-li-yjlz)

#### 方法一：二元组表示 + 计数

**思路及解法**

本题中我们需要统计所有等价的多米诺骨牌，其中多米诺骨牌使用二元对代表，「等价」的定义是，在允许翻转两个二元对的的情况下，使它们的元素一一对应相等。

于是我们不妨直接让每一个二元对都变为指定的格式，即第一维必须不大于第二维。这样两个二元对「等价」当且仅当两个二元对完全相同。

注意到二元对中的元素均不大于 $9$，因此我们可以将每一个二元对拼接成一个两位的正整数，即 $(x, y) \to 10x + y$。这样就无需使用哈希表统计元素数量，而直接使用长度为 $100$ 的数组即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numEquivDominoPairs(vector<vector<int>>& dominoes) {
        vector<int> num(100);
        int ret = 0;
        for (auto& it : dominoes) {
            int val = it[0] < it[1] ? it[0] * 10 + it[1] : it[1] * 10 + it[0];
            ret += num[val];
            num[val]++;
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numEquivDominoPairs(int[][] dominoes) {
        int[] num = new int[100];
        int ret = 0;
        for (int[] domino : dominoes) {
            int val = domino[0] < domino[1] ? domino[0] * 10 + domino[1] : domino[1] * 10 + domino[0];
            ret += num[val];
            num[val]++;
        }
        return ret;
    }
}
```

```JavaScript [sol1-JavaScript]
var numEquivDominoPairs = function(dominoes) {
    const num = new Array(100).fill(0);
    let ret = 0;
    for (const domino of dominoes) {
        const val = domino[0] < domino[1] ? domino[0] * 10 + domino[1] : domino[1] * 10 + domino[0];
        ret += num[val];
        num[val]++;
    }
    return ret;
};
```

```go [sol1-Golang]
func numEquivDominoPairs(dominoes [][]int) (ans int) {
    cnt := [100]int{}
    for _, d := range dominoes {
        if d[0] > d[1] {
            d[0], d[1] = d[1], d[0]
        }
        v := d[0]*10 + d[1]
        ans += cnt[v]
        cnt[v]++
    }
    return
}
```

```C [sol1-C]
int numEquivDominoPairs(int** dominoes, int dominoesSize, int* dominoesColSize) {
    int num[100];
    memset(num, 0, sizeof(num));
    int ret = 0;
    for (int i = 0; i < dominoesSize; i++) {
        int val = dominoes[i][0] < dominoes[i][1] ? dominoes[i][0] * 10 + dominoes[i][1] : dominoes[i][1] * 10 + dominoes[i][0];
        ret += num[val];
        num[val]++;
    }
    return ret;
}
```

```Python [sol1-Python3]
class Solution:
    def numEquivDominoPairs(self, dominoes: List[List[int]]) -> int:
        num = [0] * 100
        ret = 0
        for x, y in dominoes:
            val = (x * 10 + y if x <= y else y * 10 + x)
            ret += num[val]
            num[val] += 1
        return ret
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是多米诺骨牌的数量。我们至多只需要遍历一次该数组。

- 空间复杂度：$O(1)$，我们只需要常数的空间存储若干变量。