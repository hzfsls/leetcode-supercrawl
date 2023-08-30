#### 方法一：降低搜索空间

**思路**

如果不进行任何优化进行搜索，需要按 $\textit{presses}$ 次，每次有 $4$ 种选择，那么一共有 $4^\textit{presses}$ 种按动选择，每种选择消耗 $O(n)$ 时间计算状态，则最终的时间复杂度为 $O(n \times 4^\textit{presses})$。经过思考，可以从以下角度降低搜索空间。

首先，不需要考虑按钮按动的顺序，而只需要考虑每个按钮被按了几次，在按钮按动次数一样的情况下，顺序不影响灯泡最后的状态。更进一步地，不需要考虑每个按钮具体被按了几次，而只需要考虑被按了奇数次还是偶数次即可，某个键每多按或少按 $2$ 次及其倍数次，也不影响最后的状态。

其次，观察每个按钮的效果，可以发现所有按钮可以根据编号划分为以下 $4$ 组，周期为 $6$，下列编号中 $k \geq 0$：
- 编号为 $6k+1$，受按钮 $1,3,4$ 影响；
- 编号为 $6k+2, 6k+6$，受按钮 $1,2$ 影响；
- 编号为 $6k+3, 6k+5$，受按钮 $1,3$ 影响；
- 编号为 $6k+4$，受按钮 $1,2,4$ 影响。

因此，只需要考虑四个灯泡，即可知道所有灯泡最后的状态了。

编写代码时，可以用一个长度为 $4$ 数组 $\textit{pressArr}$ 表示 $4$ 个按钮的按动情况。一个整数 $\textit{status}$ 表示四组灯泡亮灭的状态。最后计算遇到过几种不同的状态即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def flipLights(self, n: int, presses: int) -> int:
        seen = set()
        for i in range(2**4):
            pressArr = [(i >> j) & 1 for j in range(4)]
            if sum(pressArr) % 2 == presses % 2 and sum(pressArr) <= presses:
                status = pressArr[0] ^ pressArr[2] ^ pressArr[3]
                if n >= 2:
                    status |= (pressArr[0] ^ pressArr[1]) << 1
                if n >= 3:
                    status |= (pressArr[0] ^ pressArr[2]) << 2
                if n >= 4:
                    status |= (pressArr[0] ^ pressArr[1] ^ pressArr[3]) << 3
                seen.add(status)
        return len(seen)
```

```Java [sol1-Java]
class Solution {
    public int flipLights(int n, int presses) {
        Set<Integer> seen = new HashSet<Integer>();
        for (int i = 0; i < 1 << 4; i++) {
            int[] pressArr = new int[4];
            for (int j = 0; j < 4; j++) {
                pressArr[j] = (i >> j) & 1;
            }
            int sum = Arrays.stream(pressArr).sum();
            if (sum % 2 == presses % 2 && sum <= presses) {
                int status = pressArr[0] ^ pressArr[2] ^ pressArr[3];
                if (n >= 2) {
                    status |= (pressArr[0] ^ pressArr[1]) << 1;
                }
                if (n >= 3) {
                    status |= (pressArr[0] ^ pressArr[2]) << 2;
                }
                if (n >= 4) {
                    status |= (pressArr[0] ^ pressArr[1] ^ pressArr[3]) << 3;
                }
                seen.add(status);
            }
        }
        return seen.size();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FlipLights(int n, int presses) {
        ISet<int> seen = new HashSet<int>();
        for (int i = 0; i < 1 << 4; i++) {
            int[] pressArr = new int[4];
            for (int j = 0; j < 4; j++) {
                pressArr[j] = (i >> j) & 1;
            }
            int sum = pressArr.Sum();
            if (sum % 2 == presses % 2 && sum <= presses) {
                int status = pressArr[0] ^ pressArr[2] ^ pressArr[3];
                if (n >= 2) {
                    status |= (pressArr[0] ^ pressArr[1]) << 1;
                }
                if (n >= 3) {
                    status |= (pressArr[0] ^ pressArr[2]) << 2;
                }
                if (n >= 4) {
                    status |= (pressArr[0] ^ pressArr[1] ^ pressArr[3]) << 3;
                }
                seen.Add(status);
            }
        }
        return seen.Count;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int flipLights(int n, int presses) {
        unordered_set<int> seen;
        for (int i = 0; i < 1 << 4; i++) {
            vector<int> pressArr(4);
            for (int j = 0; j < 4; j++) {
                pressArr[j] = (i >> j) & 1;
            }
            int sum = accumulate(pressArr.begin(), pressArr.end(), 0);
            if (sum % 2 == presses % 2 && sum <= presses) {
                int status = pressArr[0] ^ pressArr[2] ^ pressArr[3];
                if (n >= 2) {
                    status |= (pressArr[0] ^ pressArr[1]) << 1;
                }
                if (n >= 3) {
                    status |= (pressArr[0] ^ pressArr[2]) << 2;
                }
                if (n >= 4) {
                    status |= (pressArr[0] ^ pressArr[1] ^ pressArr[3]) << 3;
                }
                seen.emplace(status);
            }
        }
        return seen.size();
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

int flipLights(int n, int presses){
    HashItem *seen = NULL;
    for (int i = 0; i < 1 << 4; i++) {
        int pressArr[4], sum = 0;
        for (int j = 0; j < 4; j++) {
            pressArr[j] = (i >> j) & 1;
            sum += pressArr[j];
        }
        if (sum % 2 == presses % 2 && sum <= presses) {
            int status = pressArr[0] ^ pressArr[2] ^ pressArr[3];
            if (n >= 2) {
                status |= (pressArr[0] ^ pressArr[1]) << 1;
            }
            if (n >= 3) {
                status |= (pressArr[0] ^ pressArr[2]) << 2;
            }
            if (n >= 4) {
                status |= (pressArr[0] ^ pressArr[1] ^ pressArr[3]) << 3;
            }
            hashAddItem(&seen, status);
        }
    }
    int ret = HASH_COUNT(seen);
    hashFree(&seen);
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var flipLights = function(n, presses) {
    const seen = new Set();
    for (let i = 0; i < 1 << 4; i++) {
        const pressArr = new Array(4).fill(0);
        for (let j = 0; j < 4; j++) {
            pressArr[j] = (i >> j) & 1;
        }
        const sum = _.sum(pressArr);
        if (sum % 2 === presses % 2 && sum <= presses) {
            let status = pressArr[0] ^ pressArr[2] ^ pressArr[3];
            if (n >= 2) {
                status |= (pressArr[0] ^ pressArr[1]) << 1;
            }
            if (n >= 3) {
                status |= (pressArr[0] ^ pressArr[2]) << 2;
            }
            if (n >= 4) {
                status |= (pressArr[0] ^ pressArr[1] ^ pressArr[3]) << 3;
            }
            seen.add(status);
        }
    }
    return seen.size;
};
```

```go [sol1-Golang]
func flipLights(n, presses int) int {
    seen := map[int]struct{}{}
    for i := 0; i < 1<<4; i++ {
        pressArr := [4]int{}
        sum := 0
        for j := 0; j < 4; j++ {
            pressArr[j] = i >> j & 1
            sum += pressArr[j]
        }
        if sum%2 == presses%2 && sum <= presses {
            status := pressArr[0] ^ pressArr[2] ^ pressArr[3]
            if n >= 2 {
                status |= (pressArr[0] ^ pressArr[1]) << 1
            }
            if n >= 3 {
                status |= (pressArr[0] ^ pressArr[2]) << 2
            }
            if n >= 4 {
                status |= (pressArr[0] ^ pressArr[1] ^ pressArr[3]) << 3
            }
            seen[status] = struct{}{}
        }
    }
    return len(seen)
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。只需要使用常数时间即可完成计算。

- 空间复杂度：$O(1)$。只需要使用常数空间即可完成计算。