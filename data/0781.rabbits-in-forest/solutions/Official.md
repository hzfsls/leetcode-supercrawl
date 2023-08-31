## [781.森林中的兔子 中文官方题解](https://leetcode.cn/problems/rabbits-in-forest/solutions/100000/sen-lin-zhong-de-tu-zi-by-leetcode-solut-kvla)
#### 方法一：贪心

**思路**

两只相同颜色的兔子看到的其他同色兔子数必然是相同的。反之，若两只兔子看到的其他同色兔子数不同，那么这两只兔子颜色也不同。

因此，将 $\textit{answers}$ 中值相同的元素分为一组，对于每一组，计算出兔子的最少数量，然后将所有组的计算结果累加，就是最终的答案。

例如，现在有 $13$ 只兔子回答 $5$。假设其中有一只红色的兔子，那么森林中必然有 $6$ 只红兔子。再假设其中还有一只蓝色的兔子，同样的道理森林中必然有 $6$ 只蓝兔子。为了最小化可能的兔子数量，我们假设这 $12$ 只兔子都在这 $13$ 只兔子中。那么还有一只额外的兔子回答 $5$，这只兔子只能是其他的颜色，这一颜色的兔子也有 $6$ 只。因此这种情况下最少会有 $18$ 只兔子。

一般地，如果有 $x$ 只兔子都回答 $y$，则至少有 $\lceil\dfrac{x}{y+1}\rceil$ 种不同的颜色，且每种颜色有 $y+1$ 只兔子，因此兔子数至少为 

$$\lceil\dfrac{x}{y+1}\rceil\cdot(y+1)$$

我们可以用哈希表统计 $\textit{answers}$ 中各个元素的出现次数，对每个元素套用上述公式计算，并将计算结果累加，即为最终答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numRabbits(vector<int> &answers) {
        unordered_map<int, int> count;
        for (int y : answers) {
            ++count[y];
        }
        int ans = 0;
        for (auto &[y, x] : count) {
            ans += (x + y) / (y + 1) * (y + 1);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numRabbits(int[] answers) {
        Map<Integer, Integer> count = new HashMap<Integer, Integer>();
        for (int y : answers) {
            count.put(y, count.getOrDefault(y, 0) + 1);
        }
        int ans = 0;
        for (Map.Entry<Integer, Integer> entry : count.entrySet()) {
            int y = entry.getKey(), x = entry.getValue();
            ans += (x + y) / (y + 1) * (y + 1);
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func numRabbits(answers []int) (ans int) {
    count := map[int]int{}
    for _, y := range answers {
        count[y]++
    }
    for y, x := range count {
        ans += (x + y) / (y + 1) * (y + 1)
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var numRabbits = function(answers) {
    const count = new Map();
    for (const y of answers) {
        count.set(y, (count.get(y) || 0) + 1);
    }
    let ans = 0;
    for (const [y, x] of count.entries()) {
        ans += Math.floor((x + y) / (y + 1)) * (y + 1);
    }
    return ans;
};
```

```Python [sol1-Python3]
class Solution:
    def numRabbits(self, answers: List[int]) -> int:
        count = Counter(answers)
        ans = sum((x + y) // (y + 1) * (y + 1) for y, x in count.items())
        return ans
```

```C [sol1-C]
struct HashTable {
    int key;
    int val;
    UT_hash_handle hh;
};

int numRabbits(int* answers, int answersSize) {
    struct HashTable* hashTable = NULL;
    for (int i = 0; i < answersSize; i++) {
        struct HashTable* tmp;
        HASH_FIND_INT(hashTable, &answers[i], tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct HashTable));
            tmp->key = answers[i];
            tmp->val = 1;
            HASH_ADD_INT(hashTable, key, tmp);
        } else {
            tmp->val++;
        }
    }
    int ans = 0;
    struct HashTable *iter, *tmp;
    HASH_ITER(hh, hashTable, iter, tmp) {
        int x = iter->val, y = iter->key;
        ans += (x + y) / (y + 1) * (y + 1);
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{answers}$ 的长度。

- 空间复杂度：$O(n)$。最坏情况下，哈希表中含有 $n$ 个元素。