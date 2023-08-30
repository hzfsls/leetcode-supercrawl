#### 方法一：模拟

**思路与算法**

由于马拉松全程只会按照同一个方向跑，中间不论跑了多少圈，对所有扇区的经过次数的贡献都是相同的。因此此题的答案仅与起点和终点相关。从起点沿着逆时针方向走到终点的这部分扇区，就是经过次数最多的扇区。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> mostVisited(int n, vector<int>& rounds) {
        vector<int> ret;
        int size = rounds.size();
        int start = rounds[0], end = rounds[size - 1];
        if (start <= end) {
            for (int i = start; i <= end; i++) {
                ret.push_back(i);
            }
        } else { // 由于题目要求按扇区大小排序，因此我们要将区间分成两部分
            for (int i = 1; i <= end; i++) {
                ret.push_back(i);
            }
            for (int i = start; i <= n; i++) {
                ret.push_back(i);
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> mostVisited(int n, int[] rounds) {
        List<Integer> ret = new ArrayList<Integer>();
        int length = rounds.length;
        int start = rounds[0], end = rounds[length - 1];
        if (start <= end) {
            for (int i = start; i <= end; i++) {
                ret.add(i);
            }
        } else { // 由于题目要求按扇区大小排序，因此我们要将区间分成两部分
            for (int i = 1; i <= end; i++) {
                ret.add(i);
            }
            for (int i = start; i <= n; i++) {
                ret.add(i);
            }
        }
        return ret;
    }
}
```

```JavaScript [sol1-JavaScript]
var mostVisited = function(n, rounds) {
    const ret = [];
    const size = rounds.length;
    const start = rounds[0], end = rounds[size - 1];
    if (start <= end) {
        for (let i = start; i <= end; i++) {
            ret.push(i);
        }
    } else { // 由于题目要求按扇区大小排序，因此我们要将区间分成两部分
        for (let i = 1; i <= end; i++) {
            ret.push(i);
        }
        for (let i = start; i <= n; i++) {
            ret.push(i);
        }
    }
    return ret;
};
```

```Python [sol1-Python3]
class Solution:
    def mostVisited(self, n: int, rounds: List[int]) -> List[int]:
        start, end = rounds[0], rounds[-1]
        if start <= end:
            return list(range(start, end + 1))
        else:
            leftPart = range(1, end + 1)
            rightPart = range(start, n + 1)
            return list(itertools.chain(leftPart, rightPart))
```

**复杂度分析**

- 时间复杂度：$O(N)$。起点和终点之间最多相距 $N-1$ 个扇区。

- 空间复杂度：$O(1)$。除答案数组外，我们只需常数的空间来存放若干变量。