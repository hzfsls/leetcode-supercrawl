#### 方法一：堆

**思路与算法**

首先遍历整个数组，并使用哈希表记录每个数字出现的次数，并形成一个「出现次数数组」。找出原数组的前 $k$ 个高频元素，就相当于找出「出现次数数组」的前 $k$ 大的值。

最简单的做法是给「出现次数数组」排序。但由于可能有 $O(N)$ 个不同的出现次数（其中 $N$ 为原数组长度），故总的算法复杂度会达到 $O(N\log N)$，不满足题目的要求。

在这里，我们可以利用堆的思想：建立一个小顶堆，然后遍历「出现次数数组」：
- 如果堆的元素个数小于 $k$，就可以直接插入堆中。
- 如果堆的元素个数等于 $k$，则检查堆顶与当前出现次数的大小。如果堆顶更大，说明至少有 $k$ 个数字的出现次数比当前值大，故舍弃当前值；否则，就弹出堆顶，并将当前值插入堆中。

遍历完成后，堆中的元素就代表了「出现次数数组」中前 $k$ 大的值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    static bool cmp(pair<int, int>& m, pair<int, int>& n) {
        return m.second > n.second;
    }

    vector<int> topKFrequent(vector<int>& nums, int k) {
        unordered_map<int, int> occurrences;
        for (auto& v : nums) {
            occurrences[v]++;
        }

        // pair 的第一个元素代表数组的值，第二个元素代表了该值出现的次数
        priority_queue<pair<int, int>, vector<pair<int, int>>, decltype(&cmp)> q(cmp);
        for (auto& [num, count] : occurrences) {
            if (q.size() == k) {
                if (q.top().second < count) {
                    q.pop();
                    q.emplace(num, count);
                }
            } else {
                q.emplace(num, count);
            }
        }
        vector<int> ret;
        while (!q.empty()) {
            ret.emplace_back(q.top().first);
            q.pop();
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] topKFrequent(int[] nums, int k) {
        Map<Integer, Integer> occurrences = new HashMap<Integer, Integer>();
        for (int num : nums) {
            occurrences.put(num, occurrences.getOrDefault(num, 0) + 1);
        }

        // int[] 的第一个元素代表数组的值，第二个元素代表了该值出现的次数
        PriorityQueue<int[]> queue = new PriorityQueue<int[]>(new Comparator<int[]>() {
            public int compare(int[] m, int[] n) {
                return m[1] - n[1];
            }
        });
        for (Map.Entry<Integer, Integer> entry : occurrences.entrySet()) {
            int num = entry.getKey(), count = entry.getValue();
            if (queue.size() == k) {
                if (queue.peek()[1] < count) {
                    queue.poll();
                    queue.offer(new int[]{num, count});
                }
            } else {
                queue.offer(new int[]{num, count});
            }
        }
        int[] ret = new int[k];
        for (int i = 0; i < k; ++i) {
            ret[i] = queue.poll()[0];
        }
        return ret;
    }
}
```

```C [sol1-C]
struct hash_table {
    int key;
    int val;
    UT_hash_handle hh;
};

typedef struct hash_table* hash_ptr;

struct pair {
    int first;
    int second;
};

struct pair* heap;
int heapSize;

void swap(struct pair* a, struct pair* b) {
    struct pair t = *a;
    *a = *b, *b = t;
}

bool cmp(struct pair* a, struct pair* b) {
    return a->second < b->second;
}

struct pair top() {
    return heap[1];
}

int push(hash_ptr x) {
    heap[++heapSize].first = x->key;
    heap[heapSize].second = x->val;
    int p = heapSize, s;
    while (p > 1) {
        s = p >> 1;
        if (cmp(&heap[s], &heap[p])) return;
        swap(&heap[p], &heap[s]);
        p = s;
    }
}

int pop() {
    heap[1] = heap[heapSize--];
    int p = 1, s;
    while ((p << 1) <= heapSize) {
        s = p << 1;
        if (s < heapSize && cmp(&heap[s + 1], &heap[s])) s++;
        if (cmp(&heap[p], &heap[s])) return;
        swap(&heap[p], &heap[s]);
        p = s;
    }
}

int* topKFrequent(int* nums, int numsSize, int k, int* returnSize) {
    hash_ptr head = NULL;
    hash_ptr p = NULL, tmp = NULL;

    for (int i = 0; i < numsSize; i++) {
        HASH_FIND_INT(head, &nums[i], p);
        if (p == NULL) {
            p = malloc(sizeof(struct hash_table));
            p->key = nums[i];
            p->val = 1;
            HASH_ADD_INT(head, key, p);
        } else {
            p->val++;
        }
    }

    heap = malloc(sizeof(struct pair) * (k + 1));
    heapSize = 0;

    HASH_ITER(hh, head, p, tmp) {
        if (heapSize == k) {
            struct pair tmp = top();
            if (tmp.second < p->val) {
                pop();
                push(p);
            }
        } else {
            push(p);
        }
    }
    *returnSize = k;
    int* ret = malloc(sizeof(int) * k);
    for (int i = 0; i < k; i++) {
        struct pair tmp = top();
        pop();
        ret[i] = tmp.first;
    }
    return ret;
}
```

```golang [sol1-Golang]
func topKFrequent(nums []int, k int) []int {
    occurrences := map[int]int{}
    for _, num := range nums {
        occurrences[num]++
    }
    h := &IHeap{}
    heap.Init(h)
    for key, value := range occurrences {
        heap.Push(h, [2]int{key, value})
        if h.Len() > k {
            heap.Pop(h)
        }
    }
    ret := make([]int, k)
    for i := 0; i < k; i++ {
        ret[k - i - 1] = heap.Pop(h).([2]int)[0]
    }
    return ret
}

type IHeap [][2]int

func (h IHeap) Len() int           { return len(h) }
func (h IHeap) Less(i, j int) bool { return h[i][1] < h[j][1] }
func (h IHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *IHeap) Push(x interface{}) {
    *h = append(*h, x.([2]int))
}

func (h *IHeap) Pop() interface{} {
    old := *h
    n := len(old)
    x := old[n-1]
    *h = old[0 : n-1]
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(N\log k)$，其中 $N$ 为数组的长度。我们首先遍历原数组，并使用哈希表记录出现次数，每个元素需要 $O(1)$ 的时间，共需 $O(N)$ 的时间。随后，我们遍历「出现次数数组」，由于堆的大小至多为 $k$，因此每次堆操作需要 $O(\log k)$ 的时间，共需 $O(N\log k)$ 的时间。二者之和为 $O(N\log k)$。
- 空间复杂度：$O(N)$。哈希表的大小为 $O(N)$，而堆的大小为 $O(k)$，共计为 $O(N)$。

#### 方法二：基于快速排序

**思路与算法**

我们可以使用基于快速排序的方法，求出「出现次数数组」的前 $k$ 大的值。

在对数组 $\textit{arr}[l \ldots r]$ 做快速排序的过程中，我们首先将数组划分为两个部分 $\textit{arr}[i \ldots q-1]$ 与 $\textit{arr}[q+1 \ldots j]$，并使得 $\textit{arr}[i \ldots q-1]$ 中的每一个值都不超过 $\textit{arr}[q]$，且 $\textit{arr}[q+1 \ldots j]$ 中的每一个值都大于 $\textit{arr}[q]$。

于是，我们根据 $k$ 与左侧子数组 $\textit{arr}[i \ldots q-1]$ 的长度（为 $q-i$）的大小关系：
- 如果 $k \le q-i$，则数组 $\textit{arr}[l \ldots r]$ 前 $k$ 大的值，就等于子数组 $\textit{arr}[i \ldots q-1]$ 前 $k$ 大的值。
- 否则，数组 $\textit{arr}[l \ldots r]$ 前 $k$ 大的值，就等于左侧子数组全部元素，加上右侧子数组 $\textit{arr}[q+1 \ldots j]$ 中前 $k - (q - i)$ 大的值。

原版的快速排序算法的平均时间复杂度为 $O(N\log N)$。我们的算法中，每次只需在其中的一个分支递归即可，因此算法的平均时间复杂度降为 $O(N)$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    void qsort(vector<pair<int, int>>& v, int start, int end, vector<int>& ret, int k) {
        int picked = rand() % (end - start + 1) + start;
        swap(v[picked], v[start]);

        int pivot = v[start].second;
        int index = start;
        for (int i = start + 1; i <= end; i++) {
            // 使用双指针把不小于基准值的元素放到左边，
            // 小于基准值的元素放到右边
            if (v[i].second >= pivot) {
                swap(v[index + 1], v[i]);
                index++;
            }
        }
        swap(v[start], v[index]);

        if (k <= index - start) {
            // 前 k 大的值在左侧的子数组里
            qsort(v, start, index - 1, ret, k);
        } else {
            // 前 k 大的值等于左侧的子数组全部元素
            // 加上右侧子数组中前 k - (index - start + 1) 大的值
            for (int i = start; i <= index; i++) {
                ret.push_back(v[i].first);
            }
            if (k > index - start + 1) {
                qsort(v, index + 1, end, ret, k - (index - start + 1));
            }
        }
    }

    vector<int> topKFrequent(vector<int>& nums, int k) {
        // 获取每个数字出现次数
        unordered_map<int, int> occurrences;
        for (auto& v: nums) {
            occurrences[v]++;
        }

        vector<pair<int, int>> values;
        for (auto& kv: occurrences) {
            values.push_back(kv);
        }
        vector<int> ret;
        qsort(values, 0, values.size() - 1, ret, k);
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] topKFrequent(int[] nums, int k) {
        Map<Integer, Integer> occurrences = new HashMap<Integer, Integer>();
        for (int num : nums) {
            occurrences.put(num, occurrences.getOrDefault(num, 0) + 1);
        }
        // 获取每个数字出现次数
        List<int[]> values = new ArrayList<int[]>();
        for (Map.Entry<Integer, Integer> entry : occurrences.entrySet()) {
            int num = entry.getKey(), count = entry.getValue();
            values.add(new int[]{num, count});
        }
        int[] ret = new int[k];
        qsort(values, 0, values.size() - 1, ret, 0, k);
        return ret;
    }

    public void qsort(List<int[]> values, int start, int end, int[] ret, int retIndex, int k) {
        int picked = (int) (Math.random() * (end - start + 1)) + start;
        Collections.swap(values, picked, start);
        
        int pivot = values.get(start)[1];
        int index = start;
        for (int i = start + 1; i <= end; i++) {
            // 使用双指针把不小于基准值的元素放到左边，
            // 小于基准值的元素放到右边
            if (values.get(i)[1] >= pivot) {
                Collections.swap(values, index + 1, i);
                index++;
            }
        }
        Collections.swap(values, start, index);

        if (k <= index - start) {
            // 前 k 大的值在左侧的子数组里
            qsort(values, start, index - 1, ret, retIndex, k);
        } else {
            // 前 k 大的值等于左侧的子数组全部元素
            // 加上右侧子数组中前 k - (index - start + 1) 大的值
            for (int i = start; i <= index; i++) {
                ret[retIndex++] = values.get(i)[0];
            }
            if (k > index - start + 1) {
                qsort(values, index + 1, end, ret, retIndex, k - (index - start + 1));
            }
        }
    }
}
```

```C [sol2-C]
struct hash_table {
    int key;
    int val;
    // 查看 https://troydhanson.github.io/uthash/ 了解更多
    UT_hash_handle hh;
};

typedef struct hash_table* hash_ptr;

struct pair {
    int first;
    int second;
};

void swap(struct pair* a, struct pair* b) {
    struct pair t = *a;
    *a = *b, *b = t;
}

void sort(struct pair* v, int start, int end, int* ret, int* retSize, int k) {
    int picked = rand() % (end - start + 1) + start;
    swap(&v[picked], &v[start]);

    int pivot = v[start].second;
    int index = start;
    for (int i = start + 1; i <= end; i++) {
        // 使用双指针把不小于基准值的元素放到左边，
        // 小于基准值的元素放到右边
        if (v[i].second >= pivot) {
            swap(&v[index + 1], &v[i]);
            index++;
        }
    }
    swap(&v[start], &v[index]);

    if (k <= index - start) {
        // 前 k 大的值在左侧的子数组里
        sort(v, start, index - 1, ret, retSize, k);
    } else {
        // 前 k 大的值等于左侧的子数组全部元素
        // 加上右侧子数组中前 k - (index - start + 1) 大的值
        for (int i = start; i <= index; i++) {
            ret[(*retSize)++] = v[i].first;
        }
        if (k > index - start + 1) {
            sort(v, index + 1, end, ret, retSize, k - (index - start + 1));
        }
    }
}

int* topKFrequent(int* nums, int numsSize, int k, int* returnSize) {
    hash_ptr head = NULL;
    hash_ptr p = NULL, tmp = NULL;

    // 获取每个数字出现次数
    for (int i = 0; i < numsSize; i++) {
        HASH_FIND_INT(head, &nums[i], p);
        if (p == NULL) {
            p = malloc(sizeof(struct hash_table));
            p->key = nums[i];
            p->val = 1;
            HASH_ADD_INT(head, key, p);
        } else {
            p->val++;
        }
    }
    struct pair values[numsSize];
    int valuesSize = 0;

    HASH_ITER(hh, head, p, tmp) {
        values[valuesSize].first = p->key;
        values[valuesSize++].second = p->val;
    }
    int* ret = malloc(sizeof(int) * k);
    *returnSize = 0;
    sort(values, 0, valuesSize - 1, ret, returnSize, k);
    return ret;
}
```

```golang [sol2-Golang]
func topKFrequent(nums []int, k int) []int {
    occurrences := map[int]int{}
    // 获取每个数字出现次数
    for _, num := range nums {
        occurrences[num]++
    }
    values := [][]int{}
    for key, value := range occurrences {
        values = append(values, []int{key, value})
    }
    ret := make([]int, k)
    qsort(values, 0, len(values) - 1, ret, 0, k)
    return ret
}

func qsort(values [][]int, start, end int, ret []int, retIndex, k int) {
    rand.Seed(time.Now().UnixNano())
    picked := rand.Int() % (end - start + 1) + start;
    values[picked], values[start] = values[start], values[picked]

    pivot := values[start][1]
    index := start

    for i := start + 1; i <= end; i++ {
        // 使用双指针把不小于基准值的元素放到左边，
        // 小于基准值的元素放到右边
        if values[i][1] >= pivot {
            values[index + 1], values[i] = values[i], values[index + 1]
            index++
        }
    }
    values[start], values[index] = values[index], values[start]
    if k <= index - start {
        // 前 k 大的值在左侧的子数组里
        qsort(values, start, index - 1, ret, retIndex, k)
    } else {
        // 前 k 大的值等于左侧的子数组全部元素
        // 加上右侧子数组中前 k - (index - start + 1) 大的值
        for i := start; i <= index; i++ {
            ret[retIndex] = values[i][0]
            retIndex++
        }
        if k > index - start + 1 {
            qsort(values, index + 1, end, ret, retIndex, k - (index - start + 1))
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 为数组的长度。
   设处理长度为 $N$ 的数组的时间复杂度为 $f(N)$。由于处理的过程包括一次遍历和一次子分支的递归，最好情况下，有 $f(N) = O(N) + f(N/2)$，根据 [主定理](https://baike.baidu.com/item/%E4%B8%BB%E5%AE%9A%E7%90%86/3463232)，能够得到 $f(N) = O(N)$。
   最坏情况下，每次取的中枢数组的元素都位于数组的两端，时间复杂度退化为 $O(N^2)$。但由于我们在每次递归的开始会先随机选取中枢元素，故出现最坏情况的概率很低。
   平均情况下，时间复杂度为 $O(N)$。
- 空间复杂度：$O(N)$。哈希表的大小为 $O(N)$，用于排序的数组的大小也为 $O(N)$，快速排序的空间复杂度最好情况为 $O(\log N)$，最坏情况为 $O(N)$。

#### 引申

本题与「[215. 数组中的第K个最大元素](https://leetcode-cn.com/problems/kth-largest-element-in-an-array)」具有诸多相似之处。