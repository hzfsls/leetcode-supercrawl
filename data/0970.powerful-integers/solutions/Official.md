#### 方法一：枚举

**思路**

枚举 $i$ 和 $j$ 所有的可能性，然后计算 $x^i+y^j$，判断是否小于等于 $\textit{bound}$。若满足，则放入一个哈希集合，最后将集合转成数组返回。

当 $x=1$ 时，$i$ 无论取什么值都等效于 $i$ 取 $0$。当 $x > 1$ 时，因为 $\textit{bound}$ 的上限是 $10^6$，因此 $i$ 的上限为 $20$。可以将这个作为一个粗略的上限，$j$ 同理。

**代码**

```Python [sol1-Python3]
class Solution:
    def powerfulIntegers(self, x: int, y: int, bound: int) -> List[int]:
        res = set()
        value1 = 1
        for i in range(21):
            value2 = 1
            for j in range(21):
                value = value1 + value2
                if value <= bound:
                    res.add(value)
                else:
                    break
                value2 *= y
            if value1 > bound:
                break
            value1 *= x
        return list(res)
```

```Go [sol1-Go]
func powerfulIntegers(x int, y int, bound int) []int {
    res := make(map[int]bool)
    value1 := 1
    for i := 0; i < 21; i++ {
        value2 := 1
        for j := 0; j < 21; j++ {
            value := value1 + value2
            if value <= bound {
                res[value] = true
            } else {
                break
            }
            value2 *= y
        }
        if value1 > bound {
            break
        }
        value1 *= x
    }
    var result []int
    for k := range res {
        result = append(result, k)
    }
    return result
}
```

```Java [sol1-Java]
class Solution {
    public List<Integer> powerfulIntegers(int x, int y, int bound) {
        Set<Integer> set = new HashSet<Integer>();
        int value1 = 1;
        for (int i = 0; i < 21; i++) {
            int value2 = 1;
            for (int j = 0; j < 21; j++) {
                int value = value1 + value2;
                if (value <= bound) {
                    set.add(value);
                } else {
                    break;
                }
                value2 *= y;
            }
            if (value1 > bound) {
                break;
            }
            value1 *= x;
        }
        return new ArrayList<Integer>(set);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> PowerfulIntegers(int x, int y, int bound) {
        ISet<int> set = new HashSet<int>();
        int value1 = 1;
        for (int i = 0; i < 21; i++) {
            int value2 = 1;
            for (int j = 0; j < 21; j++) {
                int value = value1 + value2;
                if (value <= bound) {
                    set.Add(value);
                } else {
                    break;
                }
                value2 *= y;
            }
            if (value1 > bound) {
                break;
            }
            value1 *= x;
        }
        return new List<int>(set);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> powerfulIntegers(int x, int y, int bound) {
        unordered_set<int> cnt;
        int value1 = 1;
        for (int i = 0; i < 21; i++) {
            int value2 = 1;
            for (int j = 0; j < 21; j++) {
                int value = value1 + value2;
                if (value <= bound) {
                    cnt.emplace(value);
                } else {
                    break;
                }
                value2 *= y;
            }
            if (value1 > bound) {
                break;
            }
            value1 *= x;
        }
        return vector<int>(cnt.begin(), cnt.end());
    }
};
```

```C [sol1-C]
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);
    }
}

int* powerfulIntegers(int x, int y, int bound, int* returnSize){
    HashItem *set = NULL;
    int value1 = 1;
    for (int i = 0; i < 21; i++) {
        int value2 = 1;
        for (int j = 0; j < 21; j++) {
            int value = value1 + value2;
            if (value <= bound) {
                hashAddItem(&set, value);
            } else {
                break;
            }
            value2 *= y;
        }
        if (value1 > bound) {
            break;
        }
        value1 *= x;
    }
    int n = HASH_COUNT(set);
    int *res = (int *)malloc(sizeof(int) * n);
    int pos = 0;
    for (HashItem *pEntry = set; pEntry != NULL; pEntry = pEntry->hh.next) {
        res[pos++] = pEntry->key;
    }
    hashFree(&set);
    *returnSize = n;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var powerfulIntegers = function(x, y, bound) {
    const set = new Set();
    let value1 = 1;
    for (let i = 0; i < 21; i++) {
        let value2 = 1;
        for (let j = 0; j < 21; j++) {
            let value = value1 + value2;
            if (value <= bound) {
                set.add(value);
            } else {
                break;
            }
            value2 *= y;
        }
        if (value1 > bound) {
            break;
        }
        value1 *= x;
    }
    return [...set];
};
```

**复杂度分析**

- 时间复杂度：$O(\log^2(\textit{bound}))$，双层循环的时间复杂度是 $O(\log^2(\textit{bound}))$。

- 空间复杂度：$O(\log^2(\textit{bound}))$，是哈希集合的空间复杂度。