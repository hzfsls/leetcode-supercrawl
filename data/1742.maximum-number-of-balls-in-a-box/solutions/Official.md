## [1742.盒子中小球的最大数量 中文官方题解](https://leetcode.cn/problems/maximum-number-of-balls-in-a-box/solutions/100000/he-zi-zhong-xiao-qiu-de-zui-da-shu-liang-9sfh)

#### 方法一：哈希表

遍历所有的小球，对于编号为 $i$ 的小球，计算它应该放入的盒子编号 $\textit{box}$，使用哈希表 $\textit{count}$ 记录每个盒子中的小球数量，返回遍历结束后 $\textit{count}$ 中小球数量最大的盒子对应的小球数量即可。

```Python [sol1-Python3]
class Solution:
    def countBalls(self, lowLimit: int, highLimit: int) -> int:
        count = Counter(sum(map(int, str(i))) for i in range(lowLimit, highLimit + 1))
        return max(count.values())
```

```C++ [sol1-C++]
class Solution {
public:
    int countBalls(int lowLimit, int highLimit) {
        unordered_map<int, int> count;
        int res = 0;
        for (int i = lowLimit; i <= highLimit; i++) {
            int box = 0, x = i;
            while (x) {
                box += x % 10;
                x /= 10;
            }
            count[box]++;
            res = max(res, count[box]);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countBalls(int lowLimit, int highLimit) {
        Map<Integer, Integer> count = new HashMap<Integer, Integer>();
        int res = 0;
        for (int i = lowLimit; i <= highLimit; i++) {
            int box = 0, x = i;
            while (x != 0) {
                box += x % 10;
                x /= 10;
            }
            count.put(box, count.getOrDefault(box, 0) + 1);
            res = Math.max(res, count.get(box));
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountBalls(int lowLimit, int highLimit) {
        IDictionary<int, int> count = new Dictionary<int, int>();
        int res = 0;
        for (int i = lowLimit; i <= highLimit; i++) {
            int box = 0, x = i;
            while (x != 0) {
                box += x % 10;
                x /= 10;
            }
            count.TryAdd(box, 0);
            count[box]++;
            res = Math.Max(res, count[box]);
        }
        return res;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, int key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, int key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

int countBalls(int lowLimit, int highLimit){
    HashItem *count = NULL;
    int res = 0;
    for (int i = lowLimit; i <= highLimit; i++) {
        int box = 0, x = i;
        while (x) {
            box += x % 10;
            x /= 10;
        }
        hashSetItem(&count, box, hashGetItem(&count, box, 0) + 1);
        res = MAX(res, hashGetItem(&count, box, 0));
    }
    hashFree(&count);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var countBalls = function(lowLimit, highLimit) {
    const count = new Map();
    let res = 0;
    for (let i = lowLimit; i <= highLimit; i++) {
        let box = 0, x = i;
        while (x !== 0) {
            box += x % 10;
            x = Math.floor(x / 10);
        }
        count.set(box, (count.get(box) || 0) + 1);
        res = Math.max(res, count.get(box));
    }
    return res;
};
```

```go [sol1-Golang]
func countBalls(lowLimit, highLimit int) (ans int) {
    count := map[int]int{}
    for i := lowLimit; i <= highLimit; i++ {
        sum := 0
        for x := i; x > 0; x /= 10 {
            sum += x % 10
        }
        count[sum]++
        ans = max(ans, count[sum])
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log \textit{highLimit})$，其中 $n = \textit{highLimit} - \textit{lowLimit} + 1$。

+ 空间复杂度：$O(\log \textit{highLimit})$。假设 $\textit{highLimit}$ 的十进制位数为 $x$，那么可能使用的盒子编号数目不超过 $10 \times x$，因此空间复杂度为 $O(\log \textit{highLimit})$。