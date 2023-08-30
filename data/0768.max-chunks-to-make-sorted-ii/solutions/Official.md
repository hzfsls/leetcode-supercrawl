#### 方法一：排序 + 哈希表

**思路**

记数组 $\textit{arr}$ 长度为 $n$，排完序的数组为 $\textit{sortedArr}$。首先，将原数组分为一块，肯定是可行的。原数组直接排序，和将它分为一块后再排序，得到的数组是相同的。那么，如何判断一个数组是否能分为符合题意的两块呢？如果一个数组能分为两块，那么一定能找到一个下标 $k$，这个下标将数组分为两个非空子数组 $arr[0, \ldots, k]$ 和 $arr[k+1, \ldots, n-1]$，使得 $arr[0, \ldots, k]$ 和 $sortedArr[0, \ldots, k]$ 的元素频次相同，$arr[k+1, \ldots, n-1]$ 和 $sortedArr[k+1, \ldots, n-1]$ 的元素频次相同。判断能否分为更多的块时同理。这个判断过程可以从左至右同时遍历 $\textit{arr}$ 和 $\textit{sortedArr}$，并用一个哈希表 $\textit{cnt}$ 来记录两个数组元素频次之差。当遍历到某个下标时，如果 $\textit{cnt}$ 内所有键的值均为 $0$，则表示划分出了一个新的块，最后记录有多少下标可以使得 $\textit{cnt}$ 内所有键的值均为 $0$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def maxChunksToSorted(self, arr: List[int]) -> int:
        cnt = Counter()
        res = 0
        for x, y in zip(arr, sorted(arr)):
            cnt[x] += 1
            if cnt[x] == 0:
                del cnt[x]
            cnt[y] -= 1
            if cnt[y] == 0:
                del cnt[y]
            if len(cnt) == 0:
                res += 1
        return res
```

```Java [sol1-Java]
class Solution {
    public int maxChunksToSorted(int[] arr) {
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        int res = 0;
        int[] sortedArr = new int[arr.length];
        System.arraycopy(arr, 0, sortedArr, 0, arr.length);
        Arrays.sort(sortedArr);
        for (int i = 0; i < sortedArr.length; i++) {
            int x = arr[i], y = sortedArr[i];
            cnt.put(x, cnt.getOrDefault(x, 0) + 1);
            if (cnt.get(x) == 0) {
                cnt.remove(x);
            }
            cnt.put(y, cnt.getOrDefault(y, 0) - 1);
            if (cnt.get(y) == 0) {
                cnt.remove(y);
            }
            if (cnt.isEmpty()) {
                res++;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxChunksToSorted(int[] arr) {
        Dictionary<int, int> cnt = new Dictionary<int, int>();
        int res = 0;
        int[] sortedArr = new int[arr.Length];
        Array.Copy(arr, 0, sortedArr, 0, arr.Length);
        Array.Sort(sortedArr);
        for (int i = 0; i < sortedArr.Length; i++) {
            int x = arr[i], y = sortedArr[i];
            if (!cnt.ContainsKey(x)) {
                cnt.Add(x, 0);
            }
            cnt[x]++;
            if (cnt[x] == 0) {
                cnt.Remove(x);
            }
            if (!cnt.ContainsKey(y)) {
                cnt.Add(y, 0);
            }
            cnt[y]--;
            if (cnt[y] == 0) {
                cnt.Remove(y);
            }
            if (cnt.Count == 0) {
                res++;
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int maxChunksToSorted(vector<int>& arr) {
        unordered_map<int, int> cnt;
        int res = 0;
        vector<int> sortedArr = arr;
        sort(sortedArr.begin(), sortedArr.end());
        for (int i = 0; i < sortedArr.size(); i++) {
            int x = arr[i], y = sortedArr[i];
            cnt[x]++;
            if (cnt[x] == 0) {
                cnt.erase(x);
            }
            cnt[y]--;
            if (cnt[y] == 0) {
                cnt.erase(y);
            }
            if (cnt.size() == 0) {
                res++;
            }
        }
        return res;
    }
};
```

```C [sol1-C]
typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem;

static inline int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int maxChunksToSorted(int* arr, int arrSize){
    HashItem *cnt = NULL;
    int res = 0;
    int *sortedArr = (int *)malloc(sizeof(int) * arrSize);
    memcpy(sortedArr, arr, sizeof(int) * arrSize);
    qsort(sortedArr, arrSize, sizeof(int), cmp);
    for (int i = 0; i < arrSize; i++) {
        int x = arr[i], y = sortedArr[i];
        HashItem *pEntry = NULL;
        HASH_FIND_INT(cnt, &x, pEntry);
        if (pEntry == NULL) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = x;
            pEntry->val = 0;
            HASH_ADD_INT(cnt, key, pEntry);
        }
        pEntry->val++;
        if (pEntry->val == 0) {
            HASH_DEL(cnt, pEntry);
            free(pEntry);
        }
        pEntry = NULL;
        HASH_FIND_INT(cnt, &y, pEntry);
        if (pEntry == NULL) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = y;
            pEntry->val = 0;
            HASH_ADD_INT(cnt, key, pEntry);
        }
        pEntry->val--;
        if (pEntry->val == 0) {
            HASH_DEL(cnt, pEntry);
            free(pEntry);
        }
        if (HASH_COUNT(cnt) == 0) {
            res++;
        }
    }
    HashItem *cur = NULL, *tmp = NULL;
    HASH_ITER(hh, cnt, cur, tmp) {
        HASH_DEL(cnt, cur);  
        free(cur);  
    }
    return res;
}
```

```go [sol1-Golang]
func maxChunksToSorted(arr []int) (ans int) {
    cnt := map[int]int{}
    b := append([]int{}, arr...)
    sort.Ints(b)
    for i, x := range arr {
        cnt[x]++
        if cnt[x] == 0 {
            delete(cnt, x)
        }
        y := b[i]
        cnt[y]--
        if cnt[y] == 0 {
            delete(cnt, y)
        }
        if len(cnt) == 0 {
            ans++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var maxChunksToSorted = function(arr) {
    const cnt = new Map();
    let res = 0;
    const sortedArr = new Array(arr.length).fill(0);
    sortedArr.splice(0, arr.length, ...arr);
    sortedArr.sort((a, b) => a - b);
    for (let i = 0; i < sortedArr.length; i++) {
        const x = arr[i], y = sortedArr[i];
        cnt.set(x, (cnt.get(x) || 0) + 1);
        if (cnt.get(x) === 0) {
            cnt.delete(x);
        }
        cnt.set(y, (cnt.get(y) || 0) - 1);
        if (cnt.get(y) === 0) {
            cnt.delete(y);
        }
        if (cnt.size === 0) {
            res++;
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是输入数组 $\textit{arr}$ 的长度。排序需要消耗 $O(n \log n)$ 的时间复杂度，遍历一遍消耗 $O(n)$ 的时间复杂度。

- 空间复杂度：$O(n)$。排序完的数组和哈希表均需要消耗 $O(n)$ 的空间复杂度。

#### 方法二：单调栈

**思路**

对于已经分好块的数组，若块数大于 $1$，则可以得到以下结论：右边的块的所有数字均大于或等于左边的块的所有数字。考虑这个问题：对于已经分好块的数组，若在其末尾添加一个数字，如何求得新数组的分块方式？

新添加的数字可能会改变原数组的分块方式。如果新添加的数字大于或等于原数组最后一个块的最大值，则这个新添加的数字可以自己形成一个块。如果新添加的数字小于原数组最后一个块的最大值，则它必须融入最后一个块。如果它大于或等于原数组倒数第二个块（如果有）的最大值，那么这个过程可以停止，新数组的分块方式已经求得。否则，它将继续融合原数组倒数第二个块，直到遇到一个块，使得该块的最大值小于或等于这个新添加的数，或者这个数字已经融合了所有块。

上述分析过程中，我们只用到了块的最大值来进行比较，比较过程又是从右到左，符合栈的思想，因此可以用类似单调栈的数据结构来存储块的最大值。

**代码**

```Python [sol2-Python3]
class Solution:
    def maxChunksToSorted(self, arr: [int]) -> int:
        stack = []
        for a in arr:
            if len(stack) == 0 or a >= stack[-1]:
                stack.append(a)
            else:
                mx = stack.pop()
                while stack and stack[-1] > a:
                    stack.pop()
                stack.append(mx)
        return len(stack)
```

```Java [sol2-Java]
class Solution {
    public int maxChunksToSorted(int[] arr) {
        Deque<Integer> stack = new ArrayDeque<Integer>();
        for (int num : arr) {
            if (stack.isEmpty() || num >= stack.peek()) {
                stack.push(num);
            } else {
                int mx = stack.pop();
                while (!stack.isEmpty() && stack.peek() > num) {
                    stack.pop();
                }
                stack.push(mx);
            }
        }
        return stack.size();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxChunksToSorted(int[] arr) {
        Stack<int> stack = new Stack<int>();
        foreach (int num in arr) {
            if (stack.Count == 0 || num >= stack.Peek()) {
                stack.Push(num);
            } else {
                int mx = stack.Pop();
                while (stack.Count > 0 && stack.Peek() > num) {
                    stack.Pop();
                }
                stack.Push(mx);
            }
        }
        return stack.Count;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int maxChunksToSorted(vector<int>& arr) {
        stack<int> st;
        for (auto &num : arr) {
            if (st.empty() || num >= st.top()) {
                st.emplace(num);
            } else {
                int mx = st.top();
                st.pop();
                while (!st.empty() && st.top() > num) {
                    st.pop();
                }
                st.emplace(mx);
            }
        }
        return st.size();
    }
};
```

```C [sol2-C]
int maxChunksToSorted(int* arr, int arrSize){
    int *stack = (int *)malloc(sizeof(int) * arrSize);
    int top = 0;
    for (int i = 0; i < arrSize; i++) {
        int num = arr[i];
        if (top == 0 || num >= stack[top - 1]) {
            stack[top++] = num;
        } else {
            int mx = stack[top - 1];
            top--;
            while (top > 0 && stack[top - 1] > num) {
                top--;
            }
            stack[top++] = mx;
        }
    }
    free(stack);
    return top;
}
```

```go [sol2-Golang]
func maxChunksToSorted(arr []int) int {
    st := []int{}
    for _, x := range arr {
        if len(st) == 0 || x >= st[len(st)-1] {
            st = append(st, x)
        } else {
            mx := st[len(st)-1]
            st = st[:len(st)-1]
            for len(st) > 0 && st[len(st)-1] > x {
                st = st[:len(st)-1]
            }
            st = append(st, mx)
        }
    }
    return len(st)
}
```

```JavaScript [sol2-JavaScript]
var maxChunksToSorted = function(arr) {
    const stack = [];
    for (const num of arr) {
        if (stack.length === 0 || num >= stack[stack.length - 1]) {
            stack.push(num);
        } else {
            const mx = stack.pop();
            while (stack.length && stack[stack.length - 1] > num) {
                stack.pop();
            }
            stack.push(mx);
        }
    }
    return stack.length;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是输入数组 $\textit{arr}$ 的长度。需要遍历一遍数组，入栈的操作最多为 $n$ 次。

- 空间复杂度：$O(n)$。栈的长度最多为 $n$。