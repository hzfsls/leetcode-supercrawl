## [1337.矩阵中战斗力最弱的 K 行 中文官方题解](https://leetcode.cn/problems/the-k-weakest-rows-in-a-matrix/solutions/100000/fang-zhen-zhong-zhan-dou-li-zui-ruo-de-k-xing-by-l)
#### 前言

由于本题中的矩阵行数 $m$ 和列数 $n$ 均不超过 $100$，数据规模较小，因此我们可以设计出一些时间复杂度较高的方法，例如直接对整个矩阵进行一次遍历，计算出每一行的战斗力，再进行排序并返回最弱的 $k$ 行的索引。

下面我们根据矩阵的性质，给出一种时间复杂度较为优秀的方法。

#### 方法一：二分查找 + 堆

**思路与算法**

题目描述中有一条重要的保证：

> 军人**总是**排在一行中的靠前位置，也就是说 $1$ 总是出现在 $0$ 之前。

因此，我们可以通过二分查找的方法，找出一行中最后的那个 $1$ 的位置。如果其位置为 $\textit{pos}$，那么这一行 $1$ 的个数就为 $\textit{pos} + 1$。特别地，如果这一行没有 $1$，那么令 $\textit{pos}=-1$。

当我们得到每一行的战斗力后，我们可以将它们全部放入一个小根堆中，并不断地取出堆顶的元素 $k$ 次，这样我们就得到了最弱的 $k$ 行的索引。

需要注意的是，如果我们依次将每一行的战斗力以及索引（因为如果战斗力相同，索引较小的行更弱，所以我们需要在小根堆中存放战斗力和索引的二元组）放入小根堆中，那么这样做的时间复杂度是 $O(m \log m)$ 的。一种更好的方法是使用这 $m$ 个战斗力值直接初始化一个小根堆，时间复杂度为 $O(m)$。读者可以参考《算法导论》的 $\text{6.3}$ 节或者[「堆排序中建堆过程时间复杂度 $O(n)$ 怎么来的？」](https://www.zhihu.com/question/20729324)了解该过程时间复杂度的证明方法。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> kWeakestRows(vector<vector<int>>& mat, int k) {
        int m = mat.size(), n = mat[0].size();
        vector<pair<int, int>> power;
        for (int i = 0; i < m; ++i) {
            int l = 0, r = n - 1, pos = -1;
            while (l <= r) {
                int mid = (l + r) / 2;
                if (mat[i][mid] == 0) {
                    r = mid - 1;
                }
                else {
                    pos = mid;
                    l = mid + 1;
                }
            }
            power.emplace_back(pos + 1, i);
        }

        priority_queue q(greater<pair<int, int>>(), move(power));
        vector<int> ans;
        for (int i = 0; i < k; ++i) {
            ans.push_back(q.top().second);
            q.pop();
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] kWeakestRows(int[][] mat, int k) {
        int m = mat.length, n = mat[0].length;
        List<int[]> power = new ArrayList<int[]>();
        for (int i = 0; i < m; ++i) {
            int l = 0, r = n - 1, pos = -1;
            while (l <= r) {
                int mid = (l + r) / 2;
                if (mat[i][mid] == 0) {
                    r = mid - 1;
                } else {
                    pos = mid;
                    l = mid + 1;
                }
            }
            power.add(new int[]{pos + 1, i});
        }

        PriorityQueue<int[]> pq = new PriorityQueue<int[]>(new Comparator<int[]>() {
            public int compare(int[] pair1, int[] pair2) {
                if (pair1[0] != pair2[0]) {
                    return pair1[0] - pair2[0];
                } else {
                    return pair1[1] - pair2[1];
                }
            }
        });
        for (int[] pair : power) {
            pq.offer(pair);
        }
        int[] ans = new int[k];
        for (int i = 0; i < k; ++i) {
            ans[i] = pq.poll()[1];
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def kWeakestRows(self, mat: List[List[int]], k: int) -> List[int]:
        m, n = len(mat), len(mat[0])
        power = list()
        for i in range(m):
            l, r, pos = 0, n - 1, -1
            while l <= r:
                mid = (l + r) // 2
                if mat[i][mid] == 0:
                    r = mid - 1
                else:
                    pos = mid
                    l = mid + 1
            power.append((pos + 1, i))

        heapq.heapify(power)
        ans = list()
        for i in range(k):
            ans.append(heapq.heappop(power)[1])
        return ans
```

```go [sol1-Golang]
func kWeakestRows(mat [][]int, k int) []int {
    h := hp{}
    for i, row := range mat {
        pow := sort.Search(len(row), func(j int) bool { return row[j] == 0 })
        h = append(h, pair{pow, i})
    }
    heap.Init(&h)
    ans := make([]int, k)
    for i := range ans {
        ans[i] = heap.Pop(&h).(pair).idx
    }
    return ans
}

type pair struct{ pow, idx int }
type hp []pair

func (h hp) Len() int            { return len(h) }
func (h hp) Less(i, j int) bool  { a, b := h[i], h[j]; return a.pow < b.pow || a.pow == b.pow && a.idx < b.idx }
func (h hp) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(v interface{}) { *h = append(*h, v.(pair)) }
func (h *hp) Pop() interface{}   { a := *h; v := a[len(a)-1]; *h = a[:len(a)-1]; return v }
```

**复杂度分析**

- 时间复杂度：$O(m \log n + k \log m)$：

    - 我们需要 $O(m \log n)$ 的时间对每一行进行二分查找。

    - 我们需要 $O(m)$ 的时间建立小根堆。

    - 我们需要 $O(k \log m)$ 的时间从堆中取出 $k$ 个最小的元素。

- 空间复杂度：$O(m)$，即为堆需要使用的空间。

#### 方法二：二分查找 + 快速选择

**思路与算法**

我们也可以通过快速选择算法，在平均 $O(m)$ 的时间内不计顺序地内找出 $k$ 个最小的元素，再使用排序算法在 $O(k \log k)$ 的时间对这 $k$ 个最小的元素进行升序排序，就可以得到最终的答案。读者可以参考[「剑指 Offer 40. 最小的k个数」官方题解](https://leetcode-cn.com/problems/zui-xiao-de-kge-shu-lcof/solution/zui-xiao-de-kge-shu-by-leetcode-solution/)的方法三或者[「215. 数组中的第K个最大元素」的官方题解](https://leetcode-cn.com/problems/kth-largest-element-in-an-array/solution/shu-zu-zhong-de-di-kge-zui-da-yuan-su-by-leetcode-/)中的方法一了解快速选择算法，下面的代码将上述题解中的快速选择算法封装成一个 $\text{Helper}$ 类进行使用。

```C++ [sol2-C++]
template<typename T>
class Helper {
    static int partition(vector<T>& nums, int l, int r) {
        T pivot = nums[r];
        int i = l - 1;
        for (int j = l; j <= r - 1; ++j) {
            if (nums[j] <= pivot) {
                i = i + 1;
                swap(nums[i], nums[j]);
            }
        }
        swap(nums[i + 1], nums[r]);
        return i + 1;
    }

    // 基于随机的划分
    static int randomized_partition(vector<T>& nums, int l, int r) {
        int i = rand() % (r - l + 1) + l;
        swap(nums[r], nums[i]);
        return partition(nums, l, r);
    }

    static void randomized_selected(vector<T>& arr, int l, int r, int k) {
        if (l >= r) {
            return;
        }
        int pos = randomized_partition(arr, l, r);
        int num = pos - l + 1;
        if (k == num) {
            return;
        } else if (k < num) {
            randomized_selected(arr, l, pos - 1, k);
        } else {
            randomized_selected(arr, pos + 1, r, k - num);
        }
    }

public:
    static vector<T> getLeastNumbers(vector<T>& arr, int k) {
        srand((unsigned)time(NULL));
        randomized_selected(arr, 0, (int)arr.size() - 1, k);
        vector<T> vec;
        for (int i = 0; i < k; ++i) {
            vec.push_back(arr[i]);
        }
        return vec;
    }
};

class Solution {
public:
    vector<int> kWeakestRows(vector<vector<int>>& mat, int k) {
        int m = mat.size(), n = mat[0].size();
        vector<pair<int, int>> power;
        for (int i = 0; i < m; ++i) {
            int l = 0, r = n - 1, pos = -1;
            while (l <= r) {
                int mid = (l + r) / 2;
                if (mat[i][mid] == 0) {
                    r = mid - 1;
                }
                else {
                    pos = mid;
                    l = mid + 1;
                }
            }
            power.emplace_back(pos + 1, i);
        }

        vector<pair<int, int>> minimum = Helper<pair<int, int>>::getLeastNumbers(power, k);
        sort(minimum.begin(), minimum.begin() + k);
        vector<int> ans;
        for (int i = 0; i < k; ++i) {
            ans.push_back(minimum[i].second);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] kWeakestRows(int[][] mat, int k) {
        int m = mat.length, n = mat[0].length;
        int[][] power = new int[m][2];
        for (int i = 0; i < m; ++i) {
            int l = 0, r = n - 1, pos = -1;
            while (l <= r) {
                int mid = (l + r) / 2;
                if (mat[i][mid] == 0) {
                    r = mid - 1;
                } else {
                    pos = mid;
                    l = mid + 1;
                }
            }
            power[i][0] = pos + 1;
            power[i][1] = i;
        }

        int[][] minimum = Helper.getLeastNumbers(power, k);
        Arrays.sort(minimum, new Comparator<int[]>() {
            public int compare(int[] pair1, int[] pair2) {
                if (pair1[0] != pair2[0]) {
                    return pair1[0] - pair2[0];
                } else {
                    return pair1[1] - pair2[1];
                }
            }
        });
        int[] ans = new int[k];
        for (int i = 0; i < k; ++i) {
            ans[i] = minimum[i][1];
        }
        return ans;
    }
}

class Helper {
    public static int[][] getLeastNumbers(int[][] arr, int k) {
        randomizedSelected(arr, 0, arr.length - 1, k);
        int[][] vec = new int[k][2];
        for (int i = 0; i < k; ++i) {
            vec[i][0] = arr[i][0];
            vec[i][1] = arr[i][1];
        }
        return vec;
    }

    private static void randomizedSelected(int[][] arr, int l, int r, int k) {
        if (l >= r) {
            return;
        }
        int pos = randomizedPartition(arr, l, r);
        int num = pos - l + 1;
        if (k == num) {
            return;
        } else if (k < num) {
            randomizedSelected(arr, l, pos - 1, k);
        } else {
            randomizedSelected(arr, pos + 1, r, k - num);
        }
    }

    // 基于随机的划分
    private static int randomizedPartition(int[][] nums, int l, int r) {
        int i = (int) (Math.random() * (r - l + 1)) + l;
        swap(nums, r, i);
        return partition(nums, l, r);
    }

    private static int partition(int[][] nums, int l, int r) {
        int[] pivot = nums[r];
        int i = l - 1;
        for (int j = l; j <= r - 1; ++j) {
            if (compare(nums[j], pivot) <= 0) {
                i = i + 1;
                swap(nums, i, j);
            }
        }
        swap(nums, i + 1, r);
        return i + 1;
    }

    private static void swap(int[][] nums, int i, int j) {
        int[] temp = new int[nums[i].length];
        System.arraycopy(nums[i], 0, temp, 0, nums[i].length);
        System.arraycopy(nums[j], 0, nums[i], 0, nums[i].length);
        System.arraycopy(temp, 0, nums[j], 0, nums[i].length);
    }

    private static int compare(int[] pair, int[] pivot) {
        if (pair[0] != pivot[0]) {
            return pair[0] - pivot[0];
        } else {
            return pair[1] - pivot[1];
        }
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int[] KWeakestRows(int[][] mat, int k) {
        int m = mat.Length, n = mat[0].Length;
        Tuple<int, int>[] power = new Tuple<int, int>[m];
        for (int i = 0; i < m; ++i) {
            int l = 0, r = n - 1, pos = -1;
            while (l <= r) {
                int mid = (l + r) / 2;
                if (mat[i][mid] == 0) {
                    r = mid - 1;
                } else {
                    pos = mid;
                    l = mid + 1;
                }
            }
            power[i] = new Tuple<int, int>(pos + 1, i);
        }

        Tuple<int, int>[] minimum = Helper.GetLeastNumbers(power, k);
        Array.Sort(minimum);
        int[] ans = new int[k];
        for (int i = 0; i < k; ++i) {
            ans[i] = minimum[i].Item2;
        }
        return ans;
    }
}

class Helper {
    static Random random = new Random();
    
    public static Tuple<int, int>[] GetLeastNumbers(Tuple<int, int>[] arr, int k) {
        RandomizedSelected(arr, 0, arr.Length - 1, k);
        Tuple<int, int>[] vec = new Tuple<int, int>[k];
        for (int i = 0; i < k; ++i) {
            vec[i] = arr[i];
        }
        return vec;
    }

    static void RandomizedSelected(Tuple<int, int>[] arr, int l, int r, int k) {
        if (l >= r) {
            return;
        }
        int pos = RandomizedPartition(arr, l, r);
        int num = pos - l + 1;
        if (k == num) {
            return;
        } else if (k < num) {
            RandomizedSelected(arr, l, pos - 1, k);
        } else {
            RandomizedSelected(arr, pos + 1, r, k - num);
        }
    }

    // 基于随机的划分
    static int RandomizedPartition(Tuple<int, int>[] nums, int l, int r) {
        int i = random.Next(r - l + 1) + l;
        Swap(nums, r, i);
        return Partition(nums, l, r);
    }

    static int Partition(Tuple<int, int>[] nums, int l, int r) {
        Tuple<int, int> pivot = nums[r];
        int i = l - 1;
        for (int j = l; j <= r - 1; ++j) {
            if (Compare(nums[j], pivot) <= 0) {
                i = i + 1;
                Swap(nums, i, j);
            }
        }
        Swap(nums, i + 1, r);
        return i + 1;
    }

    static void Swap(Tuple<int, int>[] nums, int i, int j) {
        Tuple<int, int> temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }

    static int Compare(Tuple<int, int> pair, Tuple<int, int> pivot) {
        if (pair.Item1 != pivot.Item1) {
            return pair.Item1 - pivot.Item1;
        } else {
            return pair.Item2 - pivot.Item2;
        }
    }
}
```

```Python [sol2-Python3]
class Helper:
    @staticmethod
    def partition(nums: List, l: int, r: int) -> int:
        pivot = nums[r]
        i = l - 1
        for j in range(l, r):
            if nums[j] <= pivot:
                i += 1
                nums[i], nums[j] = nums[j], nums[i]
        nums[i + 1], nums[r] = nums[r], nums[i + 1]
        return i + 1

    @staticmethod
    def randomized_partition(nums: List, l: int, r: int) -> int:
        i = random.randint(l, r)
        nums[r], nums[i] = nums[i], nums[r]
        return Helper.partition(nums, l, r)

    @staticmethod
    def randomized_selected(arr: List, l: int, r: int, k: int) -> None:
        pos = Helper.randomized_partition(arr, l, r)
        num = pos - l + 1
        if k < num:
            Helper.randomized_selected(arr, l, pos - 1, k)
        elif k > num:
            Helper.randomized_selected(arr, pos + 1, r, k - num)

    @staticmethod
    def getLeastNumbers(arr: List, k: int) -> List:
        Helper.randomized_selected(arr, 0, len(arr) - 1, k)
        return arr[:k]


class Solution:
    def kWeakestRows(self, mat: List[List[int]], k: int) -> List[int]:
        m, n = len(mat), len(mat[0])
        power = list()
        for i in range(m):
            l, r, pos = 0, n - 1, -1
            while l <= r:
                mid = (l + r) // 2
                if mat[i][mid] == 0:
                    r = mid - 1
                else:
                    pos = mid
                    l = mid + 1
            power.append((pos + 1, i))

        minimum = Helper.getLeastNumbers(power, k)[:k]
        minimum.sort()
        ans = [entry[1] for entry in minimum]
        return ans
```

```go [sol2-Golang]
type pair struct{ pow, idx int }

func kWeakestRows(mat [][]int, k int) []int {
    m := len(mat)
    pairs := make([]pair, m)
    for i, row := range mat {
        pow := sort.Search(len(row), func(j int) bool { return row[j] == 0 })
        pairs[i] = pair{pow, i}
    }
    rand.Seed(time.Now().UnixNano())
    randomizedSelected(pairs, 0, m-1, k)
    pairs = pairs[:k]
    sort.Slice(pairs, func(i, j int) bool {
        a, b := pairs[i], pairs[j]
        return a.pow < b.pow || a.pow == b.pow && a.idx < b.idx
    })
    ans := make([]int, k)
    for i, p := range pairs {
        ans[i] = p.idx
    }
    return ans
}

func randomizedSelected(a []pair, l, r, k int) {
    if l >= r {
        return
    }
    pos := randomPartition(a, l, r)
    num := pos - l + 1
    if k == num {
        return
    }
    if k < num {
        randomizedSelected(a, l, pos-1, k)
    } else {
        randomizedSelected(a, pos+1, r, k-num)
    }
}

func randomPartition(a []pair, l, r int) int {
    i := rand.Intn(r-l+1) + l
    a[i], a[r] = a[r], a[i]
    return partition(a, l, r)
}

func partition(a []pair, l, r int) int {
    pivot := a[r]
    i := l - 1
    for j := l; j < r; j++ {
        if a[j].pow < pivot.pow || a[j].pow == pivot.pow && a[j].idx <= pivot.idx {
            i++
            a[i], a[j] = a[j], a[i]
        }
    }
    a[i+1], a[r] = a[r], a[i+1]
    return i + 1
}
```

**复杂度分析**

- 时间复杂度：$O(m \log n + k \log k)$：

    - 我们需要 $O(m \log n)$ 的时间对每一行进行二分查找。

    - 我们需要 $O(m)$ 的时间完成快速选择算法。

    - 我们需要 $O(k \log k)$ 的时间对这 $k$ 个最小的元素进行升序排序。

- 空间复杂度：$O(m)$，即为快速选择算法中的数组需要使用的空间。