## [1122.数组的相对排序 中文官方题解](https://leetcode.cn/problems/relative-sort-array/solutions/100000/shu-zu-de-xiang-dui-pai-xu-by-leetcode-solution)
#### 方法一：自定义排序

一种容易想到的方法是使用排序并自定义比较函数。

由于数组 $\textit{arr}_2$ 规定了比较顺序，因此我们可以使用哈希表对该顺序进行映射：即对于数组 $\textit{arr}_2$ 中的第 $i$ 个元素，我们将 $(\textit{arr}_2[i], i)$ 这一键值对放入哈希表 $\textit{rank}$ 中，就可以很方便地对数组 $\textit{arr}_1$ 中的元素进行比较。

比较函数的写法有很多种，例如我们可以使用最基础的比较方法，对于元素 $x$ 和 $y$：

- 如果 $x$ 和 $y$ 都出现在哈希表中，那么比较它们对应的值 $\textit{rank}[x]$ 和 $\textit{rank}[y]$；

- 如果 $x$ 和 $y$ 都没有出现在哈希表中，那么比较它们本身；

- 对于剩余的情况，出现在哈希表中的那个元素较小。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> relativeSortArray(vector<int>& arr1, vector<int>& arr2) {
        unordered_map<int, int> rank;
        for (int i = 0; i < arr2.size(); ++i) {
            rank[arr2[i]] = i;
        }
        sort(arr1.begin(), arr1.end(), [&](int x, int y) {
            if (rank.count(x)) {
                return rank.count(y) ? rank[x] < rank[y] : true;
            }
            else {
                return rank.count(y) ? false : x < y;
            }
        });
        return arr1;
    }
};
```

```Golang [sol1-Golang]
func relativeSortArray(arr1 []int, arr2 []int) []int {
    rank := map[int]int{}
    for i, v := range arr2 {
        rank[v] = i
    }
    sort.Slice(arr1, func(i, j int) bool {
        x, y := arr1[i], arr1[j]
        rankX, hasX := rank[x]
        rankY, hasY := rank[y]
        if hasX && hasY {
            return rankX < rankY
        }
        if hasX || hasY {
            return hasX
        }
        return x < y
    })
    return arr1
}
```

```C [sol1-C]
struct hashTable {
    int key;
    int val;
    UT_hash_handle hh;
};

struct hashTable* hashtable;

struct hashTable* find(int ikey) {
    struct hashTable* tmp;
    HASH_FIND_INT(hashtable, &ikey, tmp);
    return tmp;
}

void insert(int ikey, int ival) {
    struct hashTable* tmp = malloc(sizeof(struct hashTable));
    tmp->key = ikey, tmp->val = ival;
    HASH_ADD_INT(hashtable, key, tmp);
}

int cmp(void* _a, void* _b) {
    int a = *((int*)_a), b = *((int*)_b);
    struct hashTable *fa = find(a), *fb = find(b);
    if (fa == NULL) {
        return fb == NULL ? a - b : 1;
    } else {
        return fb == NULL ? -1 : fa->val - fb->val;
    }
}

int* relativeSortArray(int* arr1, int arr1Size, int* arr2, int arr2Size, int* returnSize) {
    hashtable = NULL;
    for (int i = 0; i < arr2Size; ++i) {
        insert(arr2[i], i);
    }
    qsort(arr1, arr1Size, sizeof(int), cmp);
    *returnSize = arr1Size;
    return arr1;
}
```

很多语言支持对「元组」进行排序，即依次比较元组中每一个对应位置的元素，直到比较出大小关系为止。因此，对于元素 $x$，如果它出现在哈希表中，我们使用二元组 $(0, \textit{rank}[x])$；如果它没有出现在哈希表中，我们使用二元组 $(1, x)$，就可以得到正确的排序结果。

```C++ [sol2-C++]
class Solution {
public:
    vector<int> relativeSortArray(vector<int>& arr1, vector<int>& arr2) {
        unordered_map<int, int> rank;
        for (int i = 0; i < arr2.size(); ++i) {
            rank[arr2[i]] = i;
        }
        auto mycmp = [&](int x) -> pair<int, int> {
            return rank.count(x) ? pair{0, rank[x]} : pair{1, x};
        };
        sort(arr1.begin(), arr1.end(), [&](int x, int y) {
            return mycmp(x) < mycmp(y);
        });
        return arr1;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def relativeSortArray(self, arr1: List[int], arr2: List[int]) -> List[int]:
        def mycmp(x: int) -> (int, int):
            return (0, rank[x]) if x in rank else (1, x)
        
        rank = {x: i for i, x in enumerate(arr2)}
        arr1.sort(key=mycmp)
        return arr1
```

此外，由于题目中给定的元素都是正数，因此我们可以用 $\textit{rank}[x]-n$ 和 $x$ 分别代替 $(0, \textit{rank}[x])$ 和 $(1, x)$，其中 $n$ 是数组 $\textit{arr}_2$ 的长度（同时也是哈希表 $\textit{rank}$ 的大小）。这样做的正确性在于，$\textit{rank}[x]-n$ 一定是负数，而 $x$ 一定是正数。

```C++ [sol3-C++]
class Solution {
public:
    vector<int> relativeSortArray(vector<int>& arr1, vector<int>& arr2) {
        unordered_map<int, int> rank;
        int n = arr2.size();
        for (int i = 0; i < n; ++i) {
            rank[arr2[i]] = i - n;
        }
        sort(arr1.begin(), arr1.end(), [&](int x, int y) {
            return (rank.count(x) ? rank[x] : x) < (rank.count(y) ? rank[y] : y);
        });
        return arr1;
    }
};
```

```Python [sol3-Python3]
class Solution:
    def relativeSortArray(self, arr1: List[int], arr2: List[int]) -> List[int]:
        def mycmp(x: int) -> (int, int):
            return rank[x] if x in rank else x
        
        n = len(arr2)
        rank = {x: i - n for i, x in enumerate(arr2)}
        arr1.sort(key=mycmp)
        return arr1
```

```Golang [sol3-Golang]
func relativeSortArray(arr1 []int, arr2 []int) []int {
    rank := map[int]int{}
    for i, v := range arr2 {
        rank[v] = i - len(arr2)
    }
    sort.Slice(arr1, func(i, j int) bool {
        x, y := arr1[i], arr1[j]
        if r, has := rank[x]; has {
            x = r
        }
        if r, has := rank[y]; has {
            y = r
        }
        return x < y
    })
    return arr1
}
```

```C [sol3-C]
struct hashTable {
    int key;
    int val;
    UT_hash_handle hh;
};

struct hashTable* hashtable;

struct hashTable* find(int ikey) {
    struct hashTable* tmp;
    HASH_FIND_INT(hashtable, &ikey, tmp);
    return tmp;
}

void insert(int ikey, int ival) {
    struct hashTable* tmp = malloc(sizeof(struct hashTable));
    tmp->key = ikey, tmp->val = ival;
    HASH_ADD_INT(hashtable, key, tmp);
}

int cmp(void* _a, void* _b) {
    int a = *((int*)_a), b = *((int*)_b);
    struct hashTable *fa = find(a), *fb = find(b);
    return (fa == NULL ? a : fa->val) - (fb == NULL ? b : fb->val);
}

int* relativeSortArray(int* arr1, int arr1Size, int* arr2, int arr2Size, int* returnSize) {
    hashtable = NULL;
    for (int i = 0; i < arr2Size; ++i) {
        insert(arr2[i], i - arr2Size);
    }
    qsort(arr1, arr1Size, sizeof(int), cmp);
    *returnSize = arr1Size;
    return arr1;
}
```

**复杂度分析**

- 时间复杂度：$O(m \log m + n)$，其中 $m$ 和 $n$ 分别是数组 $\textit{arr}_1$ 和 $\textit{arr}_2$ 的长度。构造哈希表 $\textit{rank}$ 的时间复杂度为 $O(n)$，排序的时间复杂度为 $O(m \log m)$。

- 空间复杂度：$O(\log m + n)$，哈希表 $\textit{rank}$ 需要的空间为 $O(n)$，排序需要的栈空间为 $O(\log m)$。

#### 方法二：计数排序

**思路与算法**

注意到本题中元素的范围为 $[0, 1000]$，这个范围不是很大，我们也可以考虑不基于比较的排序，例如「计数排序」。

具体地，我们使用一个长度为 $1001$（下标从 $0$ 到 $1000$）的数组 $\textit{frequency}$，记录每一个元素在数组 $\textit{arr}_1$ 中出现的次数。随后我们遍历数组 $\textit{arr}_2$，当遍历到元素 $x$ 时，我们将 $\textit{frequency}[x]$ 个 $x$ 加入答案中，并将 $\textit{frequency}[x]$ 清零。当遍历结束后，所有在 $\textit{arr}_2$ 中出现过的元素就已经有序了。

此时还剩下没有在 $\textit{arr}_2$ 中出现过的元素，因此我们还需要对整个数组 $\textit{frequency}$ 进行一次遍历。当遍历到元素 $x$ 时，如果 $\textit{frequency}[x]$ 不为 $0$，我们就将 $\textit{frequency}[x]$ 个 $x$ 加入答案中。

**细节**

我们可以对空间复杂度进行一个小优化。实际上，我们不需要使用长度为 $1001$ 的数组，而是可以找出数组 $\textit{arr}_1$ 中的最大值 $\textit{upper}$，使用长度为 $\textit{upper}+1$ 的数组即可。

**代码**

```C++ [sol4-C++]
class Solution {
public:
    vector<int> relativeSortArray(vector<int>& arr1, vector<int>& arr2) {
        int upper = *max_element(arr1.begin(), arr1.end());
        vector<int> frequency(upper + 1);
        for (int x: arr1) {
            ++frequency[x];
        }
        vector<int> ans;
        for (int x: arr2) {
            for (int i = 0; i < frequency[x]; ++i) {
                ans.push_back(x);
            }
            frequency[x] = 0;
        }
        for (int x = 0; x <= upper; ++x) {
            for (int i = 0; i < frequency[x]; ++i) {
                ans.push_back(x);
            }
        }
        return ans;
    }
};
```

```Java [sol4-Java]
class Solution {
    public int[] relativeSortArray(int[] arr1, int[] arr2) {
        int upper = 0;
        for (int x : arr1) {
            upper = Math.max(upper, x);
        }
        int[] frequency = new int[upper + 1];
        for (int x : arr1) {
            ++frequency[x];
        }
        int[] ans = new int[arr1.length];
        int index = 0;
        for (int x : arr2) {
            for (int i = 0; i < frequency[x]; ++i) {
                ans[index++] = x;
            }
            frequency[x] = 0;
        }
        for (int x = 0; x <= upper; ++x) {
            for (int i = 0; i < frequency[x]; ++i) {
                ans[index++] = x;
            }
        }
        return ans;
    }
}
```

```Python [sol4-Python3]
class Solution:
    def relativeSortArray(self, arr1: List[int], arr2: List[int]) -> List[int]:
        upper = max(arr1)
        frequency = [0] * (upper + 1)
        for x in arr1:
            frequency[x] += 1
        
        ans = list()
        for x in arr2:
            ans.extend([x] * frequency[x])
            frequency[x] = 0
        for x in range(upper + 1):
            if frequency[x] > 0:
                ans.extend([x] * frequency[x])
        return ans
```

```Golang [sol4-Golang]
func relativeSortArray(arr1 []int, arr2 []int) []int {
    upper := 0
    for _, v := range arr1 {
        if v > upper {
            upper = v
        }
    }
    frequency := make([]int, upper+1)
    for _, v := range arr1 {
        frequency[v]++
    }

    ans := make([]int, 0, len(arr1))
    for _, v := range arr2 {
        for ; frequency[v] > 0; frequency[v]-- {
            ans = append(ans, v)
        }
    }
    for v, freq := range frequency {
        for ; freq > 0; freq-- {
            ans = append(ans, v)
        }
    }
    return ans
}
```

```C [sol4-C]
int* relativeSortArray(int* arr1, int arr1Size, int* arr2, int arr2Size, int* returnSize) {
    int upper = 0;
    for (int i = 0; i < arr1Size; i++) {
        upper = fmax(upper, arr1[i]);
    }
    int frequency[upper + 1];
    memset(frequency, 0, sizeof(frequency));
    for (int i = 0; i < arr1Size; i++) {
        frequency[arr1[i]]++;
    }
    int* ans = malloc(sizeof(int) * arr1Size);
    *returnSize = 0;
    for (int i = 0; i < arr2Size; i++) {
        int x = arr2[i];
        for (int j = 0; j < frequency[x]; j++) {
            ans[(*returnSize)++] = x;
        }
        frequency[x] = 0;
    }
    for (int x = 0; x <= upper; x++) {
        for (int i = 0; i < frequency[x]; i++) {
            ans[(*returnSize)++] = x;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(m + n + \textit{upper})$，其中 $m$ 和 $n$ 分别是数组 $\textit{arr}_1$ 和 $\textit{arr}_2$ 的长度，$\textit{upper}$ 是数组 $\textit{arr}_1$ 中的最大值，在本题中 $\textit{upper}$ 不会超过 $1000$。遍历数组 $\textit{arr}_2$ 的时间复杂度为 $O(n)$，遍历数组 $\textit{frequency}$ 的时间复杂度为 $O(\textit{upper})$，而在遍历的过程中，我们一共需要 $O(m)$ 的时间得到答案数组。

- 空间复杂度：$O(\textit{upper})$，即为数组 $\textit{frequency}$ 需要使用的空间。注意到与方法一不同的是，方法二的代码使用了额外的空间（而不是直接覆盖数组 $\textit{arr}_1$）存放答案，但我们一般不将存储返回答案的数组计入空间复杂度，并且在我们得到数组 $\textit{frequency}$ 之后，实际上也是可以将返回答案覆盖在数组 $\textit{arr}_1$ 上的。如果在面试中遇到了本题，这些细节都可以和面试官进行确认。