## [454.四数相加 II 中文官方题解](https://leetcode.cn/problems/4sum-ii/solutions/100000/si-shu-xiang-jia-ii-by-leetcode-solution)

#### 方法一：分组 + 哈希表

**思路与算法**

我们可以将四个数组分成两部分，$A$ 和 $B$ 为一组，$C$ 和 $D$ 为另外一组。

对于 $A$ 和 $B$，我们使用二重循环对它们进行遍历，得到所有 $A[i]+B[j]$ 的值并存入哈希映射中。对于哈希映射中的每个键值对，每个键表示一种 $A[i]+B[j]$，对应的值为 $A[i]+B[j]$ 出现的次数。

对于 $C$ 和 $D$，我们同样使用二重循环对它们进行遍历。当遍历到 $C[k]+D[l]$ 时，如果 $-(C[k]+D[l])$ 出现在哈希映射中，那么将 $-(C[k]+D[l])$ 对应的值累加进答案中。

最终即可得到满足 $A[i]+B[j]+C[k]+D[l]=0$ 的四元组数目。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int fourSumCount(vector<int>& A, vector<int>& B, vector<int>& C, vector<int>& D) {
        unordered_map<int, int> countAB;
        for (int u: A) {
            for (int v: B) {
                ++countAB[u + v];
            }
        }
        int ans = 0;
        for (int u: C) {
            for (int v: D) {
                if (countAB.count(-u - v)) {
                    ans += countAB[-u - v];
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int fourSumCount(int[] A, int[] B, int[] C, int[] D) {
        Map<Integer, Integer> countAB = new HashMap<Integer, Integer>();
        for (int u : A) {
            for (int v : B) {
                countAB.put(u + v, countAB.getOrDefault(u + v, 0) + 1);
            }
        }
        int ans = 0;
        for (int u : C) {
            for (int v : D) {
                if (countAB.containsKey(-u - v)) {
                    ans += countAB.get(-u - v);
                }
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def fourSumCount(self, A: List[int], B: List[int], C: List[int], D: List[int]) -> int:
        countAB = collections.Counter(u + v for u in A for v in B)
        ans = 0
        for u in C:
            for v in D:
                if -u - v in countAB:
                    ans += countAB[-u - v]
        return ans
```

```JavaScript [sol1-JavaScript]
var fourSumCount = function(A, B, C, D) {
    const countAB = new Map();
    A.forEach(u => B.forEach(v => countAB.set(u + v, (countAB.get(u + v) || 0) + 1)));
    let ans = 0; 
    for (let u of C) {
        for (let v of D) {
            if (countAB.has(-u - v)) {
                ans += countAB.get(-u - v);
            }
        }
    }
    return ans;
};
```

```Golang [sol1-Golang]
func fourSumCount(a, b, c, d []int) (ans int) {
    countAB := map[int]int{}
    for _, v := range a {
        for _, w := range b {
            countAB[v+w]++
        }
    }
    for _, v := range c {
        for _, w := range d {
            ans += countAB[-v-w]
        }
    }
    return
}
```

```C [sol1-C]
struct hashTable {
    int key;
    int val;
    UT_hash_handle hh;
};

int fourSumCount(int* A, int ASize, int* B, int BSize, int* C, int CSize, int* D, int DSize) {
    struct hashTable* hashtable = NULL;
    for (int i = 0; i < ASize; ++i) {
        for (int j = 0; j < BSize; ++j) {
            int ikey = A[i] + B[j];
            struct hashTable* tmp;
            HASH_FIND_INT(hashtable, &ikey, tmp);
            if (tmp == NULL) {
                struct hashTable* tmp = malloc(sizeof(struct hashTable));
                tmp->key = ikey, tmp->val = 1;
                HASH_ADD_INT(hashtable, key, tmp);
            } else {
                tmp->val++;
            }
        }
    }
    int ans = 0;
    for (int i = 0; i < CSize; ++i) {
        for (int j = 0; j < DSize; ++j) {
            int ikey = -C[i] - D[j];
            struct hashTable* tmp;
            HASH_FIND_INT(hashtable, &ikey, tmp);
            if (tmp != NULL) {
                ans += tmp->val;
            }
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$。我们使用了两次二重循环，时间复杂度均为 $O(n^2)$。在循环中对哈希映射进行的修改以及查询操作的期望时间复杂度均为 $O(1)$，因此总时间复杂度为 $O(n^2)$。

- 空间复杂度：$O(n^2)$，即为哈希映射需要使用的空间。在最坏的情况下，$A[i]+B[j]$ 的值均不相同，因此值的个数为 $n^2$，也就需要 $O(n^2)$ 的空间。