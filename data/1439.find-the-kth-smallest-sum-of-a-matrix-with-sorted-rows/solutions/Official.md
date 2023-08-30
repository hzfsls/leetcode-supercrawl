#### 前言

本题是[「373. 查找和最小的 K 对数字」](https://leetcode.cn/problems/find-k-pairs-with-smallest-sums/description/)的进阶版本。当 $m = 2$ 时，有如下两种可行的做法：

- 使用小根堆（优先队列）；
- 使用二分查找 + 双指针。

对于本题而言，我们可以首先求出第 $0$ 行和第 $1$ 行的前 $k$ 个最小数组和，将该结果与第 $2$ 行再求出前 $k$ 个最小数组和，再将该结果与第 $3$ 行再求出前 $k$ 个最小数组和，以此类推。当使用完最后一行后，就可以得到整个矩阵的前 $k$ 个最小数组和，也就得到了第 $k$ 个最小数组和。

> 在求解的过程中，如果数组和的数量不够 $k$ 个，就求出所有可能的数组和。

这样做的时间复杂度为 $O(m \times F(k, n))$，其中 $F(k, n)$ 表示当两个数组的长度分别是 $k$ 和 $n$ 时，求出前 $k$ 个最小数组和的时间复杂度。下面的题解部分只会讲解 $m = 2$ 时的做法，读者也可以直接参考[「373. 查找和最小的 K 对数字」的官方题解](https://leetcode.cn/problems/find-k-pairs-with-smallest-sums/solutions/1208350/cha-zhao-he-zui-xiao-de-kdui-shu-zi-by-l-z526/)。为了叙述方便，记这两行分别为 $f$ 和 $g$，长度分别为 $l_f$ 和 $l_g$。

#### 方法一：小根堆

**思路与算法**

我们可以将两个数组 $f$ 和 $g$ 求解前 $k$ 个最小数组和的问题转换成类似「归并排序」的问题：

- 我们构造 $l_g$ 个序列，第 $i$ 个序列包含了 $f[0] + g[i], f[1] + g[i], \cdots, f[l_f - 1] + g[i]$。由于 $f$ 是非递减的，因此这个这个序列也是非递减的；

- 所有序列的并集恰好就是所有的 $l_f \times l_g$ 个数组和。要想求出前 $k$ 个最小数组和，我们就可以使用小根堆。初始时，我们将所有的 $l_g$ 个序列的**首项**放入堆中，随后进行 $k$ 次操作，每次操作我们从堆顶取出当前的最小值，再将它后面的那一项（如果有）放回堆中。这样一来，第 $j~(j \geq 1)$ 次操作时我们得到的就是第 $j$ 个最小数组和。

**细节**

上述做法的时间复杂度为 $O(l_g + k \log l_g)$，与 $l_f$ 无关。在实际的代码编写中，我们可以交换 $f$ 和 $g$ 使得 $l_g$ 一定小于等于 $l_f$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int kthSmallest(vector<vector<int>>& mat, int k) {
        int m = mat.size();
        vector<int> prev = mat[0];
        for (int i = 1; i < m; ++i) {
            prev = move(merge(prev, mat[i], k));
        }
        return prev[k - 1];
    }

    vector<int> merge(const vector<int>& f, const vector<int>& g, int k) {
        if (g.size() > f.size()) {
            return merge(g, f, k);
        }

        priority_queue<Entry> q;
        for (int i = 0; i < g.size(); ++i) {
            q.emplace(0, i, f[0] + g[i]);
        }

        vector<int> ans;
        while (k && !q.empty()) {
            Entry entry = q.top();
            q.pop();
            ans.push_back(entry.sum);
            if (entry.i + 1 < f.size()) {
                q.emplace(entry.i + 1, entry.j, f[entry.i + 1] + g[entry.j]);
            }
            --k;
        }

        return ans;
    }

private:
    struct Entry {
        int i, j, sum;
        Entry(int _i, int _j, int _sum): i(_i), j(_j), sum(_sum) {}
        bool operator< (const Entry& that) const {
            return sum > that.sum;
        }
    };
};
```

```Java [sol1-Java]
class Solution {
    public int kthSmallest(int[][] mat, int k) {
        int m = mat.length;
        int[] prev = mat[0];
        for (int i = 1; i < m; ++i) {
            prev = merge(prev, mat[i], k);
        }
        return prev[k - 1];
    }

    public int[] merge(int[] f, int[] g, int k) {
        if (g.length > f.length) {
            return merge(g, f, k);
        }

        PriorityQueue<int[]> pq = new PriorityQueue<int[]>((a, b) -> a[2] - b[2]);
        for (int i = 0; i < g.length; ++i) {
            pq.offer(new int[]{0, i, f[0] + g[i]});
        }

        List<Integer> list = new ArrayList<Integer>();
        while (k > 0 && !pq.isEmpty()) {
            int[] entry = pq.poll();
            list.add(entry[2]);
            if (entry[0] + 1 < f.length) {
                pq.offer(new int[]{entry[0] + 1, entry[1], f[entry[0] + 1] + g[entry[1]]});
            }
            --k;
        }

        int[] ans = new int[list.size()];
        for (int i = 0; i < list.size(); ++i) {
            ans[i] = list.get(i);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int KthSmallest(int[][] mat, int k) {
        int m = mat.Length;
        int[] prev = mat[0];
        for (int i = 1; i < m; ++i) {
            prev = Merge(prev, mat[i], k);
        }
        return prev[k - 1];
    }

    public int[] Merge(int[] f, int[] g, int k) {
        if (g.Length > f.Length) {
            return Merge(g, f, k);
        }

        PriorityQueue<int[], int> pq = new PriorityQueue<int[], int>();
        for (int i = 0; i < g.Length; ++i) {
            pq.Enqueue(new int[]{0, i, f[0] + g[i]}, f[0] + g[i]);
        }

        IList<int> list = new List<int>();
        while (k > 0 && pq.Count > 0) {
            int[] entry = pq.Dequeue();
            list.Add(entry[2]);
            if (entry[0] + 1 < f.Length) {
                pq.Enqueue(new int[]{entry[0] + 1, entry[1], f[entry[0] + 1] + g[entry[1]]}, f[entry[0] + 1] + g[entry[1]]);
            }
            --k;
        }

        return list.ToArray();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def kthSmallest(self, mat: List[List[int]], k: int) -> int:
        def merge(f: List[int], g: List[int], k: int) -> List[int]:
            if len(g) > len(f):
                return merge(g, f, k)
            
            q = [(f[0] + g[i], 0, i) for i in range(len(g))]
            heapq.heapify(q)

            ans = list()
            while k and q:
                entry = heapq.heappop(q)
                ans.append(entry[0])
                if entry[1] + 1 < len(f):
                    heapq.heappush(q, (f[entry[1] + 1] + g[entry[2]], entry[1] + 1, entry[2]))
                k -= 1
            
            return ans
        
        prev = mat[0]
        for i in range(1, len(mat)):
            prev = merge(prev, mat[i], k)
        return prev[k - 1]
```

```JavaScript [sol1-JavaScript]
var kthSmallest = function(mat, k) {
    const m = mat.length;
    let prev = mat[0];
    for (let i = 1; i < m; ++i) {
        prev = merge(prev, mat[i], k);
    }
    return prev[k - 1];
}

const merge = (f, g, k) => {
    if (g.length > f.length) {
        return merge(g, f, k);
    }

    const pq = new MinHeap((a, b) => a[2] < b[2]);
    for (let i = 0; i < g.length; ++i) {
        pq.add([0, i, f[0] + g[i]]);
    }

    const list = [];
    while (k > 0 && pq.size !== 0) {
        const entry = pq.poll();
        list.push(entry[2]);
        if (entry[0] + 1 < f.length) {
            pq.add([entry[0] + 1, entry[1], f[entry[0] + 1] + g[entry[1]]]);
        }
        --k;
    }

    const ans = new Array(list.length).fill(0);
    for (let i = 0; i < list.length; ++i) {
        ans[i] = list[i];
    }
    return ans;
};

class MinHeap {
    constructor(compareFunc = (a, b) => a < b) {
        this.compare = compareFunc;
        this.heap = [];
    }

    get size() {
        return this.heap.length;
    }

    peek() {
        return this.heap[0];
    }

    add(value) {
        this.heap.push(value);
        this.heapifyUp();
    }

    poll() {
        if (this.size === 0) {
            return null;
        }
        if (this.size === 1) {
            return this.heap.pop();
        }
        const max = this.heap[0];
        this.heap[0] = this.heap.pop();
        this.heapifyDown();
        return max;
    }

    heapifyUp() {
        let currentIndex = this.size - 1;
        while (currentIndex > 0) {
            const parentIndex = Math.floor((currentIndex - 1) / 2);
            if (this.compare(this.heap[currentIndex], this.heap[parentIndex])) {
                [this.heap[currentIndex], this.heap[parentIndex]] = [this.heap[parentIndex], this.heap[currentIndex]];
                currentIndex = parentIndex;
            } else {
                break;
            }
        }
    }

    heapifyDown() {
        let currentIndex = 0;
        while (currentIndex < this.size) {
            let largestIndex = currentIndex;
            const leftChildIndex = 2 * currentIndex + 1;
            const rightChildIndex = 2 * currentIndex + 2;
            if (leftChildIndex < this.size && this.compare(this.heap[leftChildIndex], this.heap[largestIndex])) {
                largestIndex = leftChildIndex;
            }
            if (rightChildIndex < this.size && this.compare(this.heap[rightChildIndex], this.heap[largestIndex])) {
                largestIndex = rightChildIndex;
            }
            if (largestIndex !== currentIndex) {
                [this.heap[currentIndex], this.heap[largestIndex]] = [this.heap[largestIndex], this.heap[currentIndex]];
                currentIndex = largestIndex;
            } else {
                break;
            }
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(m \times (\min(k, n) + k \log \min(k, n)))$。

- 空间复杂度：$O(k)$，即为小根堆需要使用的空间 $O(\min(k, n))$ 以及存储前 $k$ 个最小数组和需要使用的空间 $O(k)$。

#### 方法二：二分查找 + 双指针

**思路与算法**

我们也可以通过二分查找的方法确定第 $k$ 个最小的数组和 $\textit{thres}$，再遍历找出前 $k$ 个最小的数组和。

二分查找的下界为数组 $f$ 和 $g$ 的首元素之和，上界为尾元素之和。在二分查找的过程中，对于当前二分的值 $\textit{mid}$，我们需要统计小于等于 $\textit{mid}$ 的二元组个数，如果其小于 $k$，我们需要调整下界；否则，我们需要调整上界。

那么如何进行统计呢？由于 $f$ 和 $g$ 都是非递减的，我们就可以通过双指针的方法来得到二元组的个数。具体地，初始时指针 $\textit{lptr}$ 指向 $f$ 的首元素，表示固定选择 $f$ 中的对应元素；另一个指针 $\textit{rptr}$ 指向 $g$ 的尾元素。显然，如果 $f[\textit{lptr}] + g[\textit{rptr}] \leq \textit{mid}$，那么所以在 $\textit{rptr}$ 之前的元素也是满足要求的，因此 $\textit{rptr}$ 表示：当 $\textit{lptr}$ 固定时，满足要求的二元组的范围，并且满足要求的二元组个数是 $\textit{rptr} + 1$，即 $g[0], g[1], \cdots, g[\textit{rptr}]$。

当我们将 $\textit{lptr}$ 向右移动一个位置后，对应的 $f[\textit{lptr}]$ 不会变小，因此 $\textit{rptr}$ 的范围也要继续缩减：我们需要不断向左移动 $\textit{rptr}$，直到 $f[\textit{lptr}] + g[\textit{rptr}] \leq \textit{mid}$ 重新满足，或者 $\textit{rptr}$ 移出了边界。这样一来，在 $\textit{lptr}$ 向右移动的过程中，我们就可以计算出每个 $f[\textit{lptr}]$ 固定时，满足要求的二元组个数，累加即可得到 $f$ 和 $g$ 中满足要求的二元组个数。

**细节**

如果 $l_f \times l_g < k$，我们需要将 $k$ 减少至 $l_f \times l_g$，因为二元组的数量并没有 $k$ 个。

当二分查找完成并得到 $\textit{thres}$ 后，我们可以使用二重循环遍历数组 $f$ 和 $g$，找出所有和小于等于 $\textit{thres}$ 的二元组。需要注意的是：

- 时间复杂度为 $O(l_f \times l_g)$，较高；
- 和小于等于 $\textit{thres}$ 的二元组数量可能会大于 $k$，因为有若干个和恰好等于 $\textit{thres}$ 的二元组。

为了解决上面的这些问题，我们可以对二重循环遍历进行优化：当内层遍历 $g$ 的循环已经不满足要求时，可以直接退出，因为后续 $g$ 中的元素只会更大。并且在遍历的过程中，我们的判断条件改为「和小于 $\textit{thres}$」而不是「和小于等于 $\textit{thres}$」，这样二重循环最多只会添加 $k$ 个二元组，时间复杂度减少至 $O(k)$。在这之后，如果答案的长度没有到 $k$，我们再补上对应数量的 $\textit{thres}$ 即可。

在得到二元组的过程中，它们不是有序被加入答案的，因此最后需要进行一次排序。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int kthSmallest(vector<vector<int>>& mat, int k) {
        int m = mat.size();
        vector<int> prev = mat[0];
        for (int i = 1; i < m; ++i) {
            prev = move(merge(prev, mat[i], k));
        }
        return prev[k - 1];
    }

    vector<int> merge(const vector<int>& f, const vector<int>& g, int k) {
        int left = f[0] + g[0], right = f.back() + g.back(), thres = 0;
        k = min(k, static_cast<int>(f.size() * g.size()));
        while (left <= right) {
            int mid = (left + right) / 2;
            int rptr = g.size() - 1, cnt = 0;
            for (int lptr = 0; lptr < f.size(); ++lptr) {
                while (rptr >= 0 && f[lptr] + g[rptr] > mid) {
                    --rptr;
                }
                cnt += rptr + 1;
            }
            if (cnt >= k) {
                thres = mid;
                right = mid - 1;
            }
            else {
                left = mid + 1;
            }
        }

        vector<int> ans;
        for (int i = 0; i < f.size(); ++i) {
            for (int j = 0; j < g.size(); ++j) {
                if (int sum = f[i] + g[j]; sum < thres) {
                    ans.push_back(sum);
                }
                else {
                    break;
                }
            }
        }
        while (ans.size() < k) {
            ans.push_back(thres);
        }
        sort(ans.begin(), ans.end());
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int kthSmallest(int[][] mat, int k) {
        int m = mat.length;
        int[] prev = mat[0];
        for (int i = 1; i < m; ++i) {
            prev = merge(prev, mat[i], k);
        }
        return prev[k - 1];
    }

    public int[] merge(int[] f, int[] g, int k) {
        int left = f[0] + g[0], right = f[f.length - 1] + g[g.length - 1], thres = 0;
        k = Math.min(k, f.length * g.length);
        while (left <= right) {
            int mid = (left + right) / 2;
            int rptr = g.length - 1, cnt = 0;
            for (int lptr = 0; lptr < f.length; ++lptr) {
                while (rptr >= 0 && f[lptr] + g[rptr] > mid) {
                    --rptr;
                }
                cnt += rptr + 1;
            }
            if (cnt >= k) {
                thres = mid;
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }

        List<Integer> list = new ArrayList<Integer>();
        int index = 0;
        for (int i = 0; i < f.length; ++i) {
            for (int j = 0; j < g.length; ++j) {
                int sum = f[i] + g[j];
                if (sum < thres) {
                    list.add(sum);
                } else {
                    break;
                }
            }
        }
        while (list.size() < k) {
            list.add(thres);
        }
        int[] ans = new int[list.size()];
        for (int i = 0; i < list.size(); ++i) {
            ans[i] = list.get(i);
        }
        Arrays.sort(ans);
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int KthSmallest(int[][] mat, int k) {
        int m = mat.Length;
        int[] prev = mat[0];
        for (int i = 1; i < m; ++i) {
            prev = Merge(prev, mat[i], k);
        }
        return prev[k - 1];
    }

    public int[] Merge(int[] f, int[] g, int k) {
        int left = f[0] + g[0], right = f[f.Length - 1] + g[g.Length - 1], thres = 0;
        k = Math.Min(k, f.Length * g.Length);
        while (left <= right) {
            int mid = (left + right) / 2;
            int rptr = g.Length - 1, cnt = 0;
            for (int lptr = 0; lptr < f.Length; ++lptr) {
                while (rptr >= 0 && f[lptr] + g[rptr] > mid) {
                    --rptr;
                }
                cnt += rptr + 1;
            }
            if (cnt >= k) {
                thres = mid;
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }

        IList<int> list = new List<int>();
        int index = 0;
        for (int i = 0; i < f.Length; ++i) {
            for (int j = 0; j < g.Length; ++j) {
                int sum = f[i] + g[j];
                if (sum < thres) {
                    list.Add(sum);
                } else {
                    break;
                }
            }
        }
        while (list.Count < k) {
            list.Add(thres);
        }
        int[] ans = list.ToArray();
        Array.Sort(ans);
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def kthSmallest(self, mat: List[List[int]], k: int) -> int:
        def merge(f: List[int], g: List[int], k: int) -> List[int]:
            left, right, thres = f[0] + g[0], f[-1] + g[-1], 0
            k = min(k, len(f) * len(g))
            while left <= right:
                mid = (left + right) // 2
                rptr, cnt = len(g) - 1, 0
                for lptr, x in enumerate(f):
                    while rptr >= 0 and x + g[rptr] > mid:
                        rptr -= 1
                    cnt += rptr + 1
            
                if cnt >= k:
                    thres = mid;
                    right = mid - 1;
                else:
                    left = mid + 1;

            ans = list()
            for i, fi in enumerate(f):
                for j, gj in enumerate(g):
                    if (total := fi + gj) < thres:
                        ans.append(total)
                    else:
                        break
            
            ans += [thres] * (k - len(ans))
            ans.sort()
            return ans
        
        prev = mat[0]
        for i in range(1, len(mat)):
            prev = merge(prev, mat[i], k)
        return prev[k - 1]
```

```C [sol2-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int *merge(const int *f, int fSize, const int *g, int gSize, int k, int *returnSize) {
    int left = f[0] + g[0], right = f[fSize - 1] + g[gSize - 1], thres = 0;
    k = MIN(k, fSize * gSize);
    while (left <= right) {
        int mid = (left + right) / 2;
        int rptr = gSize - 1, cnt = 0;
        for (int lptr = 0; lptr < fSize; ++lptr) {
            while (rptr >= 0 && f[lptr] + g[rptr] > mid) {
                --rptr;
            }
            cnt += rptr + 1;
        }
        if (cnt >= k) {
            thres = mid;
            right = mid - 1;
        }
        else {
            left = mid + 1;
        }
    }

    int *ans = (int *)calloc(k, sizeof(int));
    int pos = 0;
    for (int i = 0; i < fSize; ++i) {
        for (int j = 0; j < gSize; ++j) {
            int sum = f[i] + g[j];
            if (sum < thres) {
                ans[pos++] = sum;
            } else {
                break;
            }
        }
    }
    while (pos < k) {
        ans[pos++] = thres;
    }
    qsort(ans, k, sizeof(int), cmp);
    *returnSize = k;
    return ans;
}

int kthSmallest(int** mat, int matSize, int* matColSize, int k) {
    int m = matSize;
    int n = matColSize[0];
    int *prev = mat[0];
    int prevSize = n;
    for (int i = 1; i < m; i++) {
        int arrSize = 0;
        int *arr = merge(prev, prevSize, mat[i], n, k, &arrSize);
        prevSize = arrSize;
        prev = (int *)malloc(sizeof(int) * prevSize);
        memcpy(prev, arr, sizeof(int) * prevSize);
        free(arr);
    }
    return prev[k - 1];
}  
```

```JavaScript [sol2-JavaScript]
var kthSmallest = function(mat, k) {
    const m = mat.length;
    let prev = mat[0];
    for (let i = 1; i < m; ++i) {
        prev = merge(prev, mat[i], k);
    }
    return prev[k - 1];
}

const merge = (f, g, k) => {
    let left = f[0] + g[0], right = f[f.length - 1] + g[g.length - 1], thres = 0;
    k = Math.min(k, f.length * g.length);
    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        let rptr = g.length - 1, cnt = 0;
        for (let lptr = 0; lptr < f.length; ++lptr) {
            while (rptr >= 0 && f[lptr] + g[rptr] > mid) {
                --rptr;
            }
            cnt += rptr + 1;
        }
        if (cnt >= k) {
            thres = mid;
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }

    const list = [];
    let index = 0;
    for (let i = 0; i < f.length; ++i) {
        for (let j = 0; j < g.length; ++j) {
            let sum = f[i] + g[j];
            if (sum < thres) {
                list.push(sum);
            } else {
                break;
            }
        }
    }
    while (list.length < k) {
        list.push(thres);
    }
    const ans = new Array(list.length).fill(0);
    for (let i = 0; i < list.length; ++i) {
        ans[i] = list[i];
    }
    ans.sort((a, b) => a - b);
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(m \times (k \log k + n) \times \log C)$。在一次二分查找的过程中：

    - 双指针部分需要的时间为 $O(k + n)$；
    - 二重循环遍历需要的时间为 $O(k)$；
    - 排序需要的时间为 $O(k \log k)$。

    它们的和为 $O(k \log k + n)$。二分查找需要 $O(\log C)$ 次，其中 $C$ 是和的上界与下界之差，它的范围不会超过 $5000 \cdot m$。

- 空间复杂度：$O(k)$，即为存储前 $k$ 个最小数组和需要使用的空间 $O(k)$。