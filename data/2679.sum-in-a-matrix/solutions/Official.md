## [2679.矩阵中的和 中文官方题解](https://leetcode.cn/problems/sum-in-a-matrix/solutions/100000/ju-zhen-zhong-de-he-by-leetcode-solution-88bx)
#### 方法一：模拟

**思路与算法**

设矩阵的行与列的数目分别为 $m,n$，题目要求每次选择每一行中的最大数并删除，每次操作的得分为删除数中的最大值，因此我们可以利用「大堆」进行模拟即可，具体过程如下：
+ 将每一行的元素都加入到一个「堆」中，设第 $i$ 行加入到优先队列 $\textit{pq}[i]$，堆顶元素即为当前行中的最大值；
+ 每次删除时，删除每一行的最大值即堆顶元素，用 $\textit{maxVal}$ 记录当前删除元素的最大值，此时即可得到当前删除时的得分；
+ 根据提议可以知道每次删除时都会删除掉每一行中的一个元素，一共需要 $n$ 次删除即可将矩阵中的所有元素删除完。
+ 最终返回所有删除得分之和即可；

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int matrixSum(vector<vector<int>>& nums) {
        int res = 0;
        int m = nums.size();
        int n = nums[0].size();
        vector<priority_queue<int>> pq(m);
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                pq[i].emplace(nums[i][j]);
            }
        }
        for (int j = 0; j < n; j++) {
            int maxVal = 0;
            for (int i = 0; i < m; i++) {
                maxVal = max(maxVal, pq[i].top());
                pq[i].pop();
            }
            res += maxVal;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int matrixSum(int[][] nums) {
        int res = 0;
        int m = nums.length;
        int n = nums[0].length;
        PriorityQueue<Integer>[] pq = new PriorityQueue[m];
        for (int i = 0; i < m; i++) {
            pq[i] = new PriorityQueue<Integer>((a, b) -> b - a);
            for (int j = 0; j < n; j++) {
                pq[i].offer(nums[i][j]);
            }
        }
        for (int j = 0; j < n; j++) {
            int maxVal = 0;
            for (int i = 0; i < m; i++) {
                maxVal = Math.max(maxVal, pq[i].poll());
            }
            res += maxVal;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MatrixSum(int[][] nums) {
        int res = 0;
        int m = nums.Length;
        int n = nums[0].Length;
        PriorityQueue<int, int>[] pq = new PriorityQueue<int, int>[m];
        for (int i = 0; i < m; i++) {
            pq[i] = new PriorityQueue<int, int>();
            for (int j = 0; j < n; j++) {
                pq[i].Enqueue(nums[i][j], -nums[i][j]);
            }
        }
        for (int j = 0; j < n; j++) {
            int maxVal = 0;
            for (int i = 0; i < m; i++) {
                maxVal = Math.Max(maxVal, pq[i].Dequeue());
            }
            res += maxVal;
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def matrixSum(self, nums: List[List[int]]) -> int:
        res = 0
        m = len(nums)
        n = len(nums[0])
        pq = []
        for i in range(m):
            pq.append([])
            for j in range(n):
                heapq.heappush(pq[i], -nums[i][j])
        for j in range(n):
            maxVal = 0
            for i in range(m):
                maxVal = max(maxVal, -heapq.heappop(pq[i]))
            res += maxVal
        return res
```

```Go [sol1-Go]
func matrixSum(nums [][]int) int {
    res := 0
    m := len(nums)
    n := len(nums[0])
    pq := make([]IntHeap, m)

    for i := 0; i < m; i++ {
        pq[i] = make(IntHeap, 0)
        heap.Init(&pq[i])

        for j := 0; j < n; j++ {
            heap.Push(&pq[i], -nums[i][j])
        }
    }

    for j := 0; j < n; j++ {
        maxVal := 0
        for i := 0; i < m; i++ {
            val := heap.Pop(&pq[i]).(int)
            maxVal = max(maxVal, -val)
        }
        res += maxVal
    }

    return res
}

type IntHeap []int

func (h IntHeap) Len() int {
    return len(h)
}

func (h IntHeap) Less(i, j int) bool {
    return h[i] < h[j]
}

func (h IntHeap) Swap(i, j int) {
    h[i], h[j] = h[j], h[i]
}

func (h *IntHeap) Push(x interface{}) {
    *h = append(*h, x.(int))
}

func (h *IntHeap) Pop() interface{} {
    old := *h
    n := len(old)
    x := old[n-1]
    *h = old[0 : n-1]
    return x
}

func max(a,b int) int {
    if a > b {
        return a
    }
    return b
}
```

**复杂度分析**

- 时间复杂度：$O(mn \log n)$，其中 $m,n$ 分别为矩阵的行数与列数。遍历矩阵中的所有元素需要的时间复杂度为 $O(mn)$，每个优先队列中最多有 $n$ 个元素，因此优先队列中每次压入元素或者弹出元素需要的时间复杂度为 $O(\log n)$，一共需要 $m \times n$ 次压入队列和弹出队列操作，因此总的时间复杂度为 $O(mn \log n)$。

- 空间复杂度：$O(mn)$，其中 $m,n$ 分别为矩阵的行数与列数。需要将矩阵中的所有元素存储到优先队列中，需要的空间为 $O(mn)$。

#### 方法二：排序

**思路与算法**

由于每次删除操作中，每行删除的元素即为当前行中的最大值，因此我们可以直接将每行的元素按照从大到小排序，然后按照列遍历矩阵，每次删除操作得分即为当前列的最大值，因此最终得分即为所有列中的最大值之和。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int matrixSum(vector<vector<int>>& nums) {
        int res = 0;
        int m = nums.size();
        int n = nums[0].size();
        for (int i = 0; i < m; i++) {
            sort(nums[i].begin(), nums[i].end());
        }
        for (int j = 0; j < n; j++) {
            int maxVal = 0;
            for (int i = 0; i < m; i++) {
                maxVal = max(maxVal, nums[i][j]);
            }
            res += maxVal;
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int matrixSum(int[][] nums) {
        int res = 0;
        int m = nums.length;
        int n = nums[0].length;
        for (int i = 0; i < m; i++) {
            Arrays.sort(nums[i]);
        }
        for (int j = 0; j < n; j++) {
            int maxVal = 0;
            for (int i = 0; i < m; i++) {
                maxVal = Math.max(maxVal, nums[i][j]);
            }
            res += maxVal;
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MatrixSum(int[][] nums) {
        int res = 0;
        int m = nums.Length;
        int n = nums[0].Length;
        for (int i = 0; i < m; i++) {
            Array.Sort(nums[i]);
        }
        for (int j = 0; j < n; j++) {
            int maxVal = 0;
            for (int i = 0; i < m; i++) {
                maxVal = Math.Max(maxVal, nums[i][j]);
            }
            res += maxVal;
        }
        return res;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def matrixSum(self, nums: List[List[int]]) -> int:
        res = 0
        m = len(nums)
        n = len(nums[0])
        for i in range(m):
            nums[i].sort()
        for j in range(n):
            max_val = 0
            for i in range(m):
                max_val = max(max_val, nums[i][j])
            res += max_val
        return res
```

```Go [sol2-Go]
func matrixSum(nums [][]int) int {
    res := 0
    m := len(nums)
    n := len(nums[0])
    for i := 0; i < m; i++ {
        sort.Ints(nums[i])
    }
    for j := 0; j < n; j++ {
        maxVal := 0
        for i := 0; i < m; i++ {
            if nums[i][j] > maxVal {
                maxVal = nums[i][j]
            }
        }
        res += maxVal
    }
    return res
}
```

```JavaScript [sol2-JavaScript]
var matrixSum = function(nums) {
    let res = 0;
    let m = nums.length;
    let n = nums[0].length;
    for (let i = 0; i < m; i++) {
        nums[i].sort((a, b) => a - b);
    }
    for (let j = 0; j < n; j++) {
        let maxVal = 0;
        for (let i = 0; i < m; i++) {
            maxVal = Math.max(maxVal, nums[i][j]);
        }
        res += maxVal;
    }
    return res;
}
```

```C [sol2-C]
static int cmp(const void *a, const void *b) {
    return *(int *)a - *(int *)b;
}

int matrixSum(int** nums, int numsSize, int* numsColSize) {
     int res = 0;
    int m = numsSize;
    int n = numsColSize[0];
    for (int i = 0; i < m; i++) {
        qsort(nums[i], n, sizeof(int), cmp);
    }
    for (int j = 0; j < n; j++) {
        int maxVal = 0;
        for (int i = 0; i < m; i++) {
            maxVal = fmax(maxVal, nums[i][j]);
        }
        res += maxVal;
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(mn \log n)$，其中 $m,n$ 分别为矩阵的行数与列数。对矩阵中一行元素进行排序需要的时间复杂度为 $n \log n$，一共有 $m$ 行，因此矩阵所有行排序的时间复杂度为 $O(mn \log n)$，遍历矩阵中的所有元素需要的时间复杂度为 $O(mn)$，因此总的时间复杂度为 $O(mn \log n + mn) = O(mn \log n)$。

- 空间复杂度：$O(m \log n)$，其中 $m,n$ 分别为矩阵的行数与列数。对矩阵中每一行进行排序需要的空间为 $\log n$，矩阵一共有 $m$ 行，因此总的空间复杂度为 $O(m \log n)$。