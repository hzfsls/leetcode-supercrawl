## [327.区间和的个数 中文官方题解](https://leetcode.cn/problems/count-of-range-sum/solutions/100000/qu-jian-he-de-ge-shu-by-leetcode-solution)
#### 前言

本题目的方法二至方法五均用到了较高级的数据结构，读者一般只需掌握方法一即可，感兴趣的读者可以学习其他四种解法。

在某些方法的 C++ 代码中，我们没有将开辟的堆空间进行释放。维护树型结构的动态内存较为困难，而这些方法的重点在于算法和数据结构本身。

#### 方法一：归并排序

**思路与算法**

设前缀和数组为 $\textit{preSum}$，则问题等价于求所有的下标对 $(i,j)$，满足
$$
\textit{preSum}[j] - \textit{preSum}[i] \in [\textit{lower}, \textit{upper}]
$$

我们先考虑如下的问题：给定两个**升序排列**的数组 $n_1, n_2$，试找出所有的下标对 $(i,j)$，满足
$$
n_2[j] - n_1[i] \in [\textit{lower}, \textit{upper}]
$$

在已知两个数组均为升序的情况下，这一问题是相对简单的：我们在 $n_2$ 中维护两个指针 $l,r$。起初，它们都指向 $n_2$ 的起始位置。

随后，我们考察 $n_1$ 的第一个元素。首先，不断地将指针 $l$ 向右移动，直到 $n_2[l] \ge n_1[0] + \textit{lower}$ 为止，此时， $l$ 及其右边的元素均大于或等于 $n_1[0] + \textit{lower}$；随后，再不断地将指针 $r$ 向右移动，直到 $n_2[r] > n_1[0] + \textit{upper}$ 为止，则 $r$ 左边的元素均小于或等于 $n_1[0] + \textit{upper}$。故区间 $[l,r)$ 中的所有下标 $j$，都满足 
$$
n_2[j] - n_1[0] \in [\textit{lower}, \textit{upper}]
$$

接下来，我们考察 $n_1$ 的第二个元素。由于 $n_1$ 是递增的，不难发现 $l,r$ 只可能向右移动。因此，我们不断地进行上述过程，并对于 $n_1$ 中的每一个下标，都记录相应的区间 $[l,r)$ 的大小。最终，我们就统计得到了满足条件的下标对 $(i,j)$ 的数量。

在解决这一问题后，原问题就迎刃而解了：我们采用归并排序的方式，能够得到左右两个数组排序后的形式，以及对应的下标对数量。对于原数组而言，若要找出全部的下标对数量，只需要再额外找出左端点在左侧数组，同时右端点在右侧数组的下标对数量，而这正是我们此前讨论的问题。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countRangeSumRecursive(vector<long>& sum, int lower, int upper, int left, int right) {
        if (left == right) {
            return 0;
        } else {
            int mid = (left + right) / 2;
            int n1 = countRangeSumRecursive(sum, lower, upper, left, mid);
            int n2 = countRangeSumRecursive(sum, lower, upper, mid + 1, right);
            int ret = n1 + n2;

            // 首先统计下标对的数量
            int i = left;
            int l = mid + 1;
            int r = mid + 1;
            while (i <= mid) {
                while (l <= right && sum[l] - sum[i] < lower) l++;
                while (r <= right && sum[r] - sum[i] <= upper) r++;
                ret += (r - l);
                i++;
            }

            // 随后合并两个排序数组
            vector<long> sorted(right - left + 1);
            int p1 = left, p2 = mid + 1;
            int p = 0;
            while (p1 <= mid || p2 <= right) {
                if (p1 > mid) {
                    sorted[p++] = sum[p2++];
                } else if (p2 > right) {
                    sorted[p++] = sum[p1++];
                } else {
                    if (sum[p1] < sum[p2]) {
                        sorted[p++] = sum[p1++];
                    } else {
                        sorted[p++] = sum[p2++];
                    }
                }
            }
            for (int i = 0; i < sorted.size(); i++) {
                sum[left + i] = sorted[i];
            }
            return ret;
        }
    }

    int countRangeSum(vector<int>& nums, int lower, int upper) {
        long s = 0;
        vector<long> sum{0};
        for(auto& v: nums) {
            s += v;
            sum.push_back(s);
        }
        return countRangeSumRecursive(sum, lower, upper, 0, sum.size() - 1);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countRangeSum(int[] nums, int lower, int upper) {
        long s = 0;
        long[] sum = new long[nums.length + 1];
        for (int i = 0; i < nums.length; ++i) {
            s += nums[i];
            sum[i + 1] = s;
        }
        return countRangeSumRecursive(sum, lower, upper, 0, sum.length - 1);
    }

    public int countRangeSumRecursive(long[] sum, int lower, int upper, int left, int right) {
        if (left == right) {
            return 0;
        } else {
            int mid = (left + right) / 2;
            int n1 = countRangeSumRecursive(sum, lower, upper, left, mid);
            int n2 = countRangeSumRecursive(sum, lower, upper, mid + 1, right);
            int ret = n1 + n2;

            // 首先统计下标对的数量
            int i = left;
            int l = mid + 1;
            int r = mid + 1;
            while (i <= mid) {
                while (l <= right && sum[l] - sum[i] < lower) {
                    l++;
                }
                while (r <= right && sum[r] - sum[i] <= upper) {
                    r++;
                }
                ret += r - l;
                i++;
            }

            // 随后合并两个排序数组
            long[] sorted = new long[right - left + 1];
            int p1 = left, p2 = mid + 1;
            int p = 0;
            while (p1 <= mid || p2 <= right) {
                if (p1 > mid) {
                    sorted[p++] = sum[p2++];
                } else if (p2 > right) {
                    sorted[p++] = sum[p1++];
                } else {
                    if (sum[p1] < sum[p2]) {
                        sorted[p++] = sum[p1++];
                    } else {
                        sorted[p++] = sum[p2++];
                    }
                }
            }
            for (int j = 0; j < sorted.length; j++) {
                sum[left + j] = sorted[j];
            }
            return ret;
        }
    }
}
```

```JavaScript [sol1-JavaScript]
const countRangeSumRecursive = (sum, lower, upper, left, right) => {
    if (left === right) {
        return 0;
    } else {
        const mid = Math.floor((left + right) / 2);
        const n1 = countRangeSumRecursive(sum, lower, upper, left, mid);
        const n2 = countRangeSumRecursive(sum, lower, upper, mid + 1, right);
        let ret = n1 + n2;

        // 首先统计下标对的数量
        let i = left;
        let l = mid + 1;
        let r = mid + 1;
        while (i <= mid) {
            while (l <= right && sum[l] - sum[i] < lower) l++;
            while (r <= right && sum[r] - sum[i] <= upper) r++;
            ret += (r - l);
            i++;
        }

        // 随后合并两个排序数组
        const sorted = new Array(right - left + 1);
        let p1 = left, p2 = mid + 1;
        let p = 0;
        while (p1 <= mid || p2 <= right) {
            if (p1 > mid) {
                sorted[p++] = sum[p2++];
            } else if (p2 > right) {
                sorted[p++] = sum[p1++];
            } else {
                if (sum[p1] < sum[p2]) {
                    sorted[p++] = sum[p1++];
                } else {
                    sorted[p++] = sum[p2++];
                }
            }
        }
        for (let i = 0; i < sorted.length; i++) {
            sum[left + i] = sorted[i];
        }
        return ret;
    }
}
var countRangeSum = function(nums, lower, upper) {
    let s = 0;
    const sum = [0];
    for(const v of nums) {
        s += v;
        sum.push(s);
    }
    return countRangeSumRecursive(sum, lower, upper, 0, sum.length - 1);
};
```

```C [sol1-C]
int countRangeSumRecursive(long long* sum, int lower, int upper, int left, int right) {
    if (left == right) {
        return 0;
    } else {
        int mid = (left + right) / 2;
        int n1 = countRangeSumRecursive(sum, lower, upper, left, mid);
        int n2 = countRangeSumRecursive(sum, lower, upper, mid + 1, right);
        int ret = n1 + n2;

        // 首先统计下标对的数量
        int i = left;
        int l = mid + 1;
        int r = mid + 1;
        while (i <= mid) {
            while (l <= right && sum[l] - sum[i] < lower) l++;
            while (r <= right && sum[r] - sum[i] <= upper) r++;
            ret += (r - l);
            i++;
        }

        // 随后合并两个排序数组
        long sorted[right - left + 1];
        memset(sorted, 0, sizeof(sorted));
        int p1 = left, p2 = mid + 1;
        int p = 0;
        while (p1 <= mid || p2 <= right) {
            if (p1 > mid) {
                sorted[p++] = sum[p2++];
            } else if (p2 > right) {
                sorted[p++] = sum[p1++];
            } else {
                if (sum[p1] < sum[p2]) {
                    sorted[p++] = sum[p1++];
                } else {
                    sorted[p++] = sum[p2++];
                }
            }
        }
        for (int i = 0; i < right - left + 1; i++) {
            sum[left + i] = sorted[i];
        }
        return ret;
    }
}

int countRangeSum(int* nums, int numsSize, int lower, int upper) {
    long long s = 0;
    long long sum[numsSize + 1];
    sum[0] = 0;
    for (int i = 1; i <= numsSize; i++) {
        sum[i] = sum[i - 1] + nums[i - 1];
    }
    return countRangeSumRecursive(sum, lower, upper, 0, numsSize);
}
```

```Golang [sol1-Golang]
func countRangeSum(nums []int, lower, upper int) int {
    var mergeCount func([]int) int
    mergeCount = func(arr []int) int {
        n := len(arr)
        if n <= 1 {
            return 0
        }

        n1 := append([]int(nil), arr[:n/2]...)
        n2 := append([]int(nil), arr[n/2:]...)
        cnt := mergeCount(n1) + mergeCount(n2) // 递归完毕后，n1 和 n2 均为有序

        // 统计下标对的数量
        l, r := 0, 0
        for _, v := range n1 {
            for l < len(n2) && n2[l]-v < lower {
                l++
            }
            for r < len(n2) && n2[r]-v <= upper {
                r++
            }
            cnt += r - l
        }

        // n1 和 n2 归并填入 arr
        p1, p2 := 0, 0
        for i := range arr {
            if p1 < len(n1) && (p2 == len(n2) || n1[p1] <= n2[p2]) {
                arr[i] = n1[p1]
                p1++
            } else {
                arr[i] = n2[p2]
                p2++
            }
        }
        return cnt
    }

    prefixSum := make([]int, len(nums)+1)
    for i, v := range nums {
        prefixSum[i+1] = prefixSum[i] + v
    }
    return mergeCount(prefixSum)
}
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$，其中 $N$ 为数组的长度。设执行时间为 $T(N)$，则两次递归调用的时间均为 $T(N/2)$，最后需要 $O(N)$ 的时间求出下标对数量以及合并数组，故有
    $$
    T(N) = 2 \cdot T(N/2) + O(N)
    $$
    根据主定理，有 $T(N) = O(N\log N)$。

- 空间复杂度：$O(N)$。设空间占用为 $M(N)$，递归调用所需空间为 $M(N/2)$，而合并数组所需空间为 $O(N)$，故
    $$
    M(N) = \max\big\{M(N/2), O(N)\big\} = M(N/2) + O(N)
    $$
    根据主定理，有 $M(N) = O(N)$。

#### 方法二：线段树

**思路与算法**

依然考虑前缀和数组 $\textit{preSum}$。

对于每个下标 $j$，以 $j$ 为右端点的下标对的数量，就等于数组 $\textit{preSum}[0..j-1]$ 中的所有整数，出现在区间 $[\textit{preSum}[j]-\textit{upper}, \textit{preSum}[j]-\textit{lower}]$ 的次数。故很容易想到基于线段树的解法。

我们从左到右扫描前缀和数组。每遇到一个数 $\textit{preSum}[j]$，我们就在线段树中查询区间 $[\textit{preSum}[j]-\textit{upper}, \textit{preSum}[j]-\textit{lower}]$ 内的整数数量，随后，将 $\textit{preSum}[j]$ 插入到线段树当中。

注意到整数的范围可能很大，故需要利用哈希表将所有可能出现的整数，映射到连续的整数区间内。

**代码**

```C++ [sol2-C++]
struct SegNode {
    int lo, hi, add;
    SegNode* lchild, *rchild;
    SegNode(int left, int right): lo(left), hi(right), add(0), lchild(nullptr), rchild(nullptr) {}
};

class Solution {
public:
    SegNode* build(int left, int right) {
        SegNode* node = new SegNode(left, right);
        if (left == right) {
            return node;
        }
        int mid = (left + right) / 2;
        node->lchild = build(left, mid);
        node->rchild = build(mid + 1, right);
        return node;
    }

    void insert(SegNode* root, int val) {
        root->add++;
        if (root->lo == root->hi) {
            return;
        }
        int mid = (root->lo + root->hi) / 2;
        if (val <= mid) {
            insert(root->lchild, val);
        }
        else {
            insert(root->rchild, val);
        }
    }

    int count(SegNode* root, int left, int right) const {
        if (left > root->hi || right < root->lo) {
            return 0;
        }
        if (left <= root->lo && root->hi <= right) {
            return root->add;
        }
        return count(root->lchild, left, right) + count(root->rchild, left, right);
    }

    int countRangeSum(vector<int>& nums, int lower, int upper) {
        long long sum = 0;
        vector<long long> preSum = {0};
        for (int v: nums) {
            sum += v;
            preSum.push_back(sum);
        }
        
        set<long long> allNumbers;
        for (long long x: preSum) {
            allNumbers.insert(x);
            allNumbers.insert(x - lower);
            allNumbers.insert(x - upper);
        }
        // 利用哈希表进行离散化
        unordered_map<long long, int> values;
        int idx = 0;
        for (long long x: allNumbers) {
            values[x] = idx;
            idx++;
        }

        SegNode* root = build(0, values.size() - 1);
        int ret = 0;
        for (long long x: preSum) {
            int left = values[x - upper], right = values[x - lower];
            ret += count(root, left, right);
            insert(root, values[x]);
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int countRangeSum(int[] nums, int lower, int upper) {
        long sum = 0;
        long[] preSum = new long[nums.length + 1];
        for (int i = 0; i < nums.length; ++i) {
            sum += nums[i];
            preSum[i + 1] = sum;
        }
        
        Set<Long> allNumbers = new TreeSet<Long>();
        for (long x : preSum) {
            allNumbers.add(x);
            allNumbers.add(x - lower);
            allNumbers.add(x - upper);
        }
        // 利用哈希表进行离散化
        Map<Long, Integer> values = new HashMap<Long, Integer>();
        int idx = 0;
        for (long x : allNumbers) {
            values.put(x, idx);
            idx++;
        }

        SegNode root = build(0, values.size() - 1);
        int ret = 0;
        for (long x : preSum) {
            int left = values.get(x - upper), right = values.get(x - lower);
            ret += count(root, left, right);
            insert(root, values.get(x));
        }
        return ret;
    }

    public SegNode build(int left, int right) {
        SegNode node = new SegNode(left, right);
        if (left == right) {
            return node;
        }
        int mid = (left + right) / 2;
        node.lchild = build(left, mid);
        node.rchild = build(mid + 1, right);
        return node;
    }

    public int count(SegNode root, int left, int right) {
        if (left > root.hi || right < root.lo) {
            return 0;
        }
        if (left <= root.lo && root.hi <= right) {
            return root.add;
        }
        return count(root.lchild, left, right) + count(root.rchild, left, right);
    }

    public void insert(SegNode root, int val) {
        root.add++;
        if (root.lo == root.hi) {
            return;
        }
        int mid = (root.lo + root.hi) / 2;
        if (val <= mid) {
            insert(root.lchild, val);
        } else {
            insert(root.rchild, val);
        }
    }
}

class SegNode {
    int lo, hi, add;
    SegNode lchild, rchild;

    public SegNode(int left, int right) {
        lo = left;
        hi = right;
        add = 0;
        lchild = null;
        rchild = null;
    }
}
```

```Golang [sol2-Golang]
type segTree []struct {
    l, r, val int
}

func (t segTree) build(o, l, r int) {
    t[o].l, t[o].r = l, r
    if l == r {
        return
    }
    m := (l + r) >> 1
    t.build(o<<1, l, m)
    t.build(o<<1|1, m+1, r)
}

func (t segTree) inc(o, i int) {
    if t[o].l == t[o].r {
        t[o].val++
        return
    }
    if i <= (t[o].l+t[o].r)>>1 {
        t.inc(o<<1, i)
    } else {
        t.inc(o<<1|1, i)
    }
    t[o].val = t[o<<1].val + t[o<<1|1].val
}

func (t segTree) query(o, l, r int) (res int) {
    if l <= t[o].l && t[o].r <= r {
        return t[o].val
    }
    m := (t[o].l + t[o].r) >> 1
    if r <= m {
        return t.query(o<<1, l, r)
    }
    if l > m {
        return t.query(o<<1|1, l, r)
    }
    return t.query(o<<1, l, r) + t.query(o<<1|1, l, r)
}

func countRangeSum(nums []int, lower, upper int) (cnt int) {
    n := len(nums)

    // 计算前缀和 preSum，以及后面统计时会用到的所有数字 allNums
    allNums := make([]int, 1, 3*n+1)
    preSum := make([]int, n+1)
    for i, v := range nums {
        preSum[i+1] = preSum[i] + v
        allNums = append(allNums, preSum[i+1], preSum[i+1]-lower, preSum[i+1]-upper)
    }

    // 将 allNums 离散化
    sort.Ints(allNums)
    k := 1
    kth := map[int]int{allNums[0]: k}
    for i := 1; i <= 3*n; i++ {
        if allNums[i] != allNums[i-1] {
            k++
            kth[allNums[i]] = k
        }
    }

    // 遍历 preSum，利用线段树计算每个前缀和对应的合法区间数
    t := make(segTree, 4*k)
    t.build(1, 1, k)
    t.inc(1, kth[0])
    for _, sum := range preSum[1:] {
        left, right := kth[sum-upper], kth[sum-lower]
        cnt += t.query(1, left, right)
        t.inc(1, kth[sum])
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$。使用哈希离散化之后，线段树维护的区间大小为 $O(N)$，故其深度、单次查询或插入的时间复杂度均为 $O(\log N)$。而离散化本身的复杂度也为 $O(N\log N)$。

- 空间复杂度：$O(N)$。线段树的深度为 $O(N)$，而第 $i$ 层拥有的节点数量为 $2^{i-1}$，故线段树总的节点数量为 $2^{O(\log N)} = O(N)$。

#### 方法三：动态增加节点的线段树

**思路与算法**

与方法二类似，但我们可以不实用哈希表进行映射，而是只在线段树的插入操作过程中**动态地**增加树中的节点。而当我们进行查询操作时，如果到达一个空节点，那么说明对应的区间中暂时还没有值，就可以直接返回 $0$。

**代码**

```C++ [sol3-C++]
struct SegNode {
    long long lo, hi;
    int add;
    SegNode* lchild, *rchild;
    SegNode(long long left, long long right): lo(left), hi(right), add(0), lchild(nullptr), rchild(nullptr) {}
};

class Solution {
public:
    void insert(SegNode* root, long long val) {
        root->add++;
        if (root->lo == root->hi) {
            return;
        }
        long long mid = (root->lo + root->hi) >> 1;
        if (val <= mid) {
            if (!root->lchild) {
                root->lchild = new SegNode(root->lo, mid);
            }
            insert(root->lchild, val);
        }
        else {
            if (!root->rchild) {
                root->rchild = new SegNode(mid + 1, root->hi);
            }
            insert(root->rchild, val);
        }
    }

    int count(SegNode* root, long long left, long long right) const {
        if (!root) {
            return 0;
        }
        if (left > root->hi || right < root->lo) {
            return 0;
        }
        if (left <= root->lo && root->hi <= right) {
            return root->add;
        }
        return count(root->lchild, left, right) + count(root->rchild, left, right);
    }

    int countRangeSum(vector<int>& nums, int lower, int upper) {
        long long sum = 0;
        vector<long long> preSum = {0};
        for(int v: nums) {
            sum += v;
            preSum.push_back(sum);
        }
        
        long long lbound = LLONG_MAX, rbound = LLONG_MIN;
        for (long long x: preSum) {
            lbound = min({lbound, x, x - lower, x - upper});
            rbound = max({rbound, x, x - lower, x - upper});
        }
        
        SegNode* root = new SegNode(lbound, rbound);
        int ret = 0;
        for (long long x: preSum) {
            ret += count(root, x - upper, x - lower);
            insert(root, x);
        }
        return ret;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int countRangeSum(int[] nums, int lower, int upper) {
        long sum = 0;
        long[] preSum = new long[nums.length + 1];
        for (int i = 0; i < nums.length; ++i) {
            sum += nums[i];
            preSum[i + 1] = sum;
        }
        
        long lbound = Long.MAX_VALUE, rbound = Long.MIN_VALUE;
        for (long x : preSum) {
            lbound = Math.min(Math.min(lbound, x), Math.min(x - lower, x - upper));
            rbound = Math.max(Math.max(rbound, x), Math.max(x - lower, x - upper));
        }
        
        SegNode root = new SegNode(lbound, rbound);
        int ret = 0;
        for (long x : preSum) {
            ret += count(root, x - upper, x - lower);
            insert(root, x);
        }
        return ret;
    }

    public int count(SegNode root, long left, long right) {
        if (root == null) {
            return 0;
        }
        if (left > root.hi || right < root.lo) {
            return 0;
        }
        if (left <= root.lo && root.hi <= right) {
            return root.add;
        }
        return count(root.lchild, left, right) + count(root.rchild, left, right);
    }

    public void insert(SegNode root, long val) {
        root.add++;
        if (root.lo == root.hi) {
            return;
        }
        long mid = (root.lo + root.hi) >> 1;
        if (val <= mid) {
            if (root.lchild == null) {
                root.lchild = new SegNode(root.lo, mid);
            }
            insert(root.lchild, val);
        } else {
            if (root.rchild == null) {
                root.rchild = new SegNode(mid + 1, root.hi);
            }
            insert(root.rchild, val);
        }
    }
}

class SegNode {
    long lo, hi;
    int add;
    SegNode lchild, rchild;

    public SegNode(long left, long right) {
        lo = left;
        hi = right;
        add = 0;
        lchild = null;
        rchild = null;
    }
}
```

```Golang [sol3-Golang]
type node struct {
    l, r, val int
    lo, ro    *node
}

func (o *node) insert(val int) {
    o.val++
    if o.l == o.r {
        return
    }
    m := (o.l + o.r) >> 1
    if val <= m {
        if o.lo == nil {
            o.lo = &node{l: o.l, r: m}
        }
        o.lo.insert(val)
    } else {
        if o.ro == nil {
            o.ro = &node{l: m + 1, r: o.r}
        }
        o.ro.insert(val)
    }
}

func (o *node) query(l, r int) (res int) {
    if o == nil || l > o.r || r < o.l {
        return
    }
    if l <= o.l && o.r <= r {
        return o.val
    }
    return o.lo.query(l, r) + o.ro.query(l, r)
}

func countRangeSum(nums []int, lower, upper int) (cnt int) {
    preSum := make([]int, len(nums)+1)
    for i, v := range nums {
        preSum[i+1] = preSum[i] + v
    }

    lbound, rbound := math.MaxInt64, -math.MaxInt64
    for _, sum := range preSum {
        lbound = min(lbound, sum, sum-lower, sum-upper)
        rbound = max(rbound, sum, sum-lower, sum-upper)
    }

    root := &node{l: lbound, r: rbound}
    for _, sum := range preSum {
        left, right := sum-upper, sum-lower
        cnt += root.query(left, right)
        root.insert(sum)
    }
    return
}

func min(a ...int) int {
    res := a[0]
    for _, v := range a[1:] {
        if v < res {
            res = v
        }
    }
    return res
}

func max(a ...int) int {
    res := a[0]
    for _, v := range a[1:] {
        if v > res {
            res = v
        }
    }
    return res
}
```

**复杂度分析**

- 时间复杂度：$O(N \log C)$，其中 $C$ 是线段树根节点对应的区间长度。由于我们使用 $64$ 位整数类型进行存储，因此 $\log C$ 不会超过 $64$。使用动态增加节点的线段树，单次查询或插入的时间复杂度均为 $O(\log C)$。
- 空间复杂度：$O(N \log C)$。需要进行 $N$ 次线段树的插入操作，每次会添加不超过 $\log C$ 个新节点。

#### 方法四：树状数组

**思路与算法**

树状数组与线段树基于类似的思想，不过树状数组支持的基本查询为求出 $[0, \textit{val}]$ 之间的整数数量。为了查询区间 $[\textit{preSum}[j]-\textit{upper}, \textit{preSum}[j]-\textit{lower}]$ 内的整数数量，需要执行两次查询，即分别查询 $[0, \textit{preSum}[j]-\textit{upper}-1]$ 区间的整数数量 $L$ 和$[0,\textit{preSum}[j]-\textit{lower}]$ 区间的整数数量 $R$，答案即为两者作差 $R-L$。

**代码**

```C++ [sol4-C++]
class BIT {
private:
    vector<int> tree;
    int n;

public:
    BIT(int _n): n(_n), tree(_n + 1) {}

    static constexpr int lowbit(int x) {
        return x & (-x);
    }

    void update(int x, int d) {
        while (x <= n) {
            tree[x] += d;
            x += lowbit(x);
        }
    }

    int query(int x) const {
        int ans = 0;
        while (x) {
            ans += tree[x];
            x -= lowbit(x);
        }
        return ans;
    }
};

class Solution {
public:
    int countRangeSum(vector<int>& nums, int lower, int upper) {
        long long sum = 0;
        vector<long long> preSum = {0};
        for (int v: nums) {
            sum += v;
            preSum.push_back(sum);
        }
        
        set<long long> allNumbers;
        for (long long x: preSum) {
            allNumbers.insert(x);
            allNumbers.insert(x - lower);
            allNumbers.insert(x - upper);
        }
        // 利用哈希表进行离散化
        unordered_map<long long, int> values;
        int idx = 0;
        for (long long x: allNumbers) {
            values[x] = idx;
            idx++;
        }

        int ret = 0;
        BIT bit(values.size());
        for (int i = 0; i < preSum.size(); i++) {
            int left = values[preSum[i] - upper], right = values[preSum[i] - lower];
            ret += bit.query(right + 1) - bit.query(left);
            bit.update(values[preSum[i]] + 1, 1);
        }
        return ret;
    }
};
```

```Java [sol4-Java]
class Solution {
    public int countRangeSum(int[] nums, int lower, int upper) {
        long sum = 0;
        long[] preSum = new long[nums.length + 1];
        for (int i = 0; i < nums.length; ++i) {
            sum += nums[i];
            preSum[i + 1] = sum;
        }
        
        Set<Long> allNumbers = new TreeSet<Long>();
        for (long x : preSum) {
            allNumbers.add(x);
            allNumbers.add(x - lower);
            allNumbers.add(x - upper);
        }
        // 利用哈希表进行离散化
        Map<Long, Integer> values = new HashMap<Long, Integer>();
        int idx = 0;
        for (long x: allNumbers) {
            values.put(x, idx);
            idx++;
        }

        int ret = 0;
        BIT bit = new BIT(values.size());
        for (int i = 0; i < preSum.length; i++) {
            int left = values.get(preSum[i] - upper), right = values.get(preSum[i] - lower);
            ret += bit.query(right + 1) - bit.query(left);
            bit.update(values.get(preSum[i]) + 1, 1);
        }
        return ret;
    }
}

class BIT {
    int[] tree;
    int n;

    public BIT(int n) {
        this.n = n;
        this.tree = new int[n + 1];
    }

    public static int lowbit(int x) {
        return x & (-x);
    }

    public void update(int x, int d) {
        while (x <= n) {
            tree[x] += d;
            x += lowbit(x);
        }
    }

    public int query(int x) {
        int ans = 0;
        while (x != 0) {
            ans += tree[x];
            x -= lowbit(x);
        }
        return ans;
    }
}
```

```Golang [sol4-Golang]
type fenwick struct {
    tree []int
}

func (f fenwick) inc(i int) {
    for ; i < len(f.tree); i += i & -i {
        f.tree[i]++
    }
}

func (f fenwick) sum(i int) (res int) {
    for ; i > 0; i &= i - 1 {
        res += f.tree[i]
    }
    return
}

func (f fenwick) query(l, r int) (res int) {
    return f.sum(r) - f.sum(l-1)
}

func countRangeSum(nums []int, lower, upper int) (cnt int) {
    n := len(nums)

    // 计算前缀和 preSum，以及后面统计时会用到的所有数字 allNums
    allNums := make([]int, 1, 3*n+1)
    preSum := make([]int, n+1)
    for i, v := range nums {
        preSum[i+1] = preSum[i] + v
        allNums = append(allNums, preSum[i+1], preSum[i+1]-lower, preSum[i+1]-upper)
    }

    // 将 allNums 离散化
    sort.Ints(allNums)
    k := 1
    kth := map[int]int{allNums[0]: k}
    for i := 1; i <= 3*n; i++ {
        if allNums[i] != allNums[i-1] {
            k++
            kth[allNums[i]] = k
        }
    }

    // 遍历 preSum，利用树状数组计算每个前缀和对应的合法区间数
    t := fenwick{make([]int, k+1)}
    t.inc(kth[0])
    for _, sum := range preSum[1:] {
        left, right := kth[sum-upper], kth[sum-lower]
        cnt += t.query(left, right)
        t.inc(kth[sum])
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$。离散化本身的复杂度为 $O(N\log N)$，而树状数组单次更新或查询的复杂度为 $O(\log N)$。

- 空间复杂度：$O(N)$。

#### 方法五：平衡二叉搜索树

**思路与算法**

考虑一棵平衡二叉搜索树。若其节点数量为 $N$，则深度为 $O(\log N)$。二叉搜索树能够在 $O(\log N)$ 的时间内，对任意给定的值 $\textit{val}$，查询树中所有小于或等于该值的数量。

因此，我们可以从左到右扫描前缀和数组。对于 $\textit{preSum}[j]$ 而言，首先进行两次查询，得到区间 $[\textit{preSum}[j]-\textit{upper}, \textit{preSum}[j]-\textit{lower}]$ 内的整数数量；随后再将 $\textit{preSum}[j]$ 插入到平衡树中。

平衡二叉搜索树有多种不同的实现，最经典的为 AVL 树与红黑树。此外，在算法竞赛中，还包括 Treap、SBT 等数据结构。

下面给出基于 Treap 的实现。

**代码**

```C++ [sol5-C++]
class BalancedTree {
private:
    struct BalancedNode {
        long long val;
        long long seed;
        int count;
        int size;
        BalancedNode* left;
        BalancedNode* right;

        BalancedNode(long long _val, long long _seed): val(_val), seed(_seed), count(1), size(1), left(nullptr), right(nullptr) {}

        BalancedNode* left_rotate() {
            int prev_size = size;
            int curr_size = (left ? left->size : 0) + (right->left ? right->left->size : 0) + count;
            BalancedNode* root = right;
            right = root->left;
            root->left = this;
            root->size = prev_size;
            size = curr_size;
            return root;
        }

        BalancedNode* right_rotate() {
            int prev_size = size;
            int curr_size = (right ? right->size : 0) + (left->right ? left->right->size : 0) + count;
            BalancedNode* root = left;
            left = root->right;
            root->right = this;
            root->size = prev_size;
            size = curr_size;
            return root;
        }
    };

private:
    BalancedNode* root;
    int size;
    mt19937 gen;
    uniform_int_distribution<long long> dis;

private:
    BalancedNode* insert(BalancedNode* node, long long x) {
        if (!node) {
            return new BalancedNode(x, dis(gen));
        }
        ++node->size;
        if (x < node->val) {
            node->left = insert(node->left, x);
            if (node->left->seed > node->seed) {
                node = node->right_rotate();
            }
        }
        else if (x > node->val) {
            node->right = insert(node->right, x);
            if (node->right->seed > node->seed) {
                node = node->left_rotate();
            }
        }
        else {
            ++node->count;
        }
        return node;
    }

public:
    BalancedTree(): root(nullptr), size(0), gen(random_device{}()), dis(LLONG_MIN, LLONG_MAX) {}

    long long get_size() const {
        return size;
    }

    void insert(long long x) {
        ++size;
        root = insert(root, x);
    }

    long long lower_bound(long long x) const {
        BalancedNode* node = root;
        long long ans = LLONG_MAX;
        while (node) {
            if (x == node->val) {
                return x;
            }
            if (x < node->val) {
                ans = node->val;
                node = node->left;
            }
            else {
                node = node->right;
            }
        }
        return ans;
    }

    long long upper_bound(long long x) const {
        BalancedNode* node = root;
        long long ans = LLONG_MAX;
        while (node) {
            if (x < node->val) {
                ans = node->val;
                node = node->left;
            }
            else {
                node = node->right;
            }
        }
        return ans;
    }

    pair<int, int> rank(long long x) const {
        BalancedNode* node = root;
        int ans = 0;
        while (node) {
            if (x < node->val) {
                node = node->left;
            }
            else {
                ans += (node->left ? node->left->size : 0) + node->count;
                if (x == node->val) {
                    return {ans - node->count + 1, ans};
                }
                node = node->right;
            }
        }
        return {INT_MIN, INT_MAX};
    }
};

class Solution {
public:
    int countRangeSum(vector<int>& nums, int lower, int upper) {
        long long sum = 0;
        vector<long long> preSum = {0};
        for (int v: nums) {
            sum += v;
            preSum.push_back(sum);
        }
        
        BalancedTree* treap = new BalancedTree();
        int ret = 0;
        for (long long x: preSum) {
            long long numLeft = treap->lower_bound(x - upper);
            int rankLeft = (numLeft == LLONG_MAX ? treap->get_size() + 1 : treap->rank(numLeft).first);
            long long numRight = treap->upper_bound(x - lower);
            int rankRight = (numRight == LLONG_MAX ? treap->get_size() : treap->rank(numRight).first - 1);
            ret += (rankRight - rankLeft + 1);
            treap->insert(x);
        }
        return ret;
    }
};
```

```Java [sol5-Java]
class Solution {
    public int countRangeSum(int[] nums, int lower, int upper) {
        long sum = 0;
        long[] preSum = new long[nums.length + 1];
        for (int i = 0; i < nums.length; ++i) {
            sum += nums[i];
            preSum[i + 1] = sum;
        }
        
        BalancedTree treap = new BalancedTree();
        int ret = 0;
        for (long x : preSum) {
            long numLeft = treap.lowerBound(x - upper);
            int rankLeft = (numLeft == Long.MAX_VALUE ? (int) (treap.getSize() + 1) : treap.rank(numLeft)[0]);
            long numRight = treap.upperBound(x - lower);
            int rankRight = (numRight == Long.MAX_VALUE ? (int) treap.getSize() : treap.rank(numRight)[0] - 1);
            ret += rankRight - rankLeft + 1;
            treap.insert(x);
        }
        return ret;
    }
}

class BalancedTree {
    private class BalancedNode {
        long val;
        long seed;
        int count;
        int size;
        BalancedNode left;
        BalancedNode right;

        BalancedNode(long val, long seed) {
            this.val = val;
            this.seed = seed;
            this.count = 1;
            this.size = 1;
            this.left = null;
            this.right = null;
        }

        BalancedNode leftRotate() {
            int prevSize = size;
            int currSize = (left != null ? left.size : 0) + (right.left != null ? right.left.size : 0) + count;
            BalancedNode root = right;
            right = root.left;
            root.left = this;
            root.size = prevSize;
            size = currSize;
            return root;
        }

        BalancedNode rightRotate() {
            int prevSize = size;
            int currSize = (right != null ? right.size : 0) + (left.right != null ? left.right.size : 0) + count;
            BalancedNode root = left;
            left = root.right;
            root.right = this;
            root.size = prevSize;
            size = currSize;
            return root;
        }
    }

    private BalancedNode root;
    private int size;
    private Random rand;

    public BalancedTree() {
        this.root = null;
        this.size = 0;
        this.rand = new Random();
    }

    public long getSize() {
        return size;
    }

    public void insert(long x) {
        ++size;
        root = insert(root, x);
    }

    public long lowerBound(long x) {
        BalancedNode node = root;
        long ans = Long.MAX_VALUE;
        while (node != null) {
            if (x == node.val) {
                return x;
            }
            if (x < node.val) {
                ans = node.val;
                node = node.left;
            } else {
                node = node.right;
            }
        }
        return ans;
    }

    public long upperBound(long x) {
        BalancedNode node = root;
        long ans = Long.MAX_VALUE;
        while (node != null) {
            if (x < node.val) {
                ans = node.val;
                node = node.left;
            } else {
                node = node.right;
            }
        }
        return ans;
    }

    public int[] rank(long x) {
        BalancedNode node = root;
        int ans = 0;
        while (node != null) {
            if (x < node.val) {
                node = node.left;
            } else {
                ans += (node.left != null ? node.left.size : 0) + node.count;
                if (x == node.val) {
                    return new int[]{ans - node.count + 1, ans};
                }
                node = node.right;
            }
        }
        return new int[]{Integer.MIN_VALUE, Integer.MAX_VALUE};
    }

    private BalancedNode insert(BalancedNode node, long x) {
        if (node == null) {
            return new BalancedNode(x, rand.nextInt());
        }
        ++node.size;
        if (x < node.val) {
            node.left = insert(node.left, x);
            if (node.left.seed > node.seed) {
                node = node.rightRotate();
            }
        } else if (x > node.val) {
            node.right = insert(node.right, x);
            if (node.right.seed > node.seed) {
                node = node.leftRotate();
            }
        } else {
            ++node.count;
        }
        return node;
    }
}
```

```Golang [sol5-Golang]
import "math/rand" // 默认导入的 rand 不是这个库，需要显式指明

type node struct {
    ch       [2]*node
    priority int
    key      int
    dupCnt   int
    sz       int
}

func (o *node) cmp(b int) int {
    switch {
    case b < o.key:
        return 0
    case b > o.key:
        return 1
    default:
        return -1
    }
}

func (o *node) size() int {
    if o != nil {
        return o.sz
    }
    return 0
}

func (o *node) maintain() {
    o.sz = o.dupCnt + o.ch[0].size() + o.ch[1].size()
}

func (o *node) rotate(d int) *node {
    x := o.ch[d^1]
    o.ch[d^1] = x.ch[d]
    x.ch[d] = o
    o.maintain()
    x.maintain()
    return x
}

type treap struct {
    root *node
}

func (t *treap) _insert(o *node, key int) *node {
    if o == nil {
        return &node{priority: rand.Int(), key: key, dupCnt: 1, sz: 1}
    }
    if d := o.cmp(key); d >= 0 {
        o.ch[d] = t._insert(o.ch[d], key)
        if o.ch[d].priority > o.priority {
            o = o.rotate(d ^ 1)
        }
    } else {
        o.dupCnt++
    }
    o.maintain()
    return o
}

func (t *treap) insert(key int) {
    t.root = t._insert(t.root, key)
}

// equal=false: 小于 key 的元素个数
// equal=true: 小于或等于 key 的元素个数
func (t *treap) rank(key int, equal bool) (cnt int) {
    for o := t.root; o != nil; {
        switch c := o.cmp(key); {
        case c == 0:
            o = o.ch[0]
        case c > 0:
            cnt += o.dupCnt + o.ch[0].size()
            o = o.ch[1]
        default:
            cnt += o.ch[0].size()
            if equal {
                cnt += o.dupCnt
            }
            return
        }
    }
    return
}

func countRangeSum(nums []int, lower, upper int) (cnt int) {
    preSum := make([]int, len(nums)+1)
    for i, v := range nums {
        preSum[i+1] = preSum[i] + v
    }

    t := &treap{}
    for _, sum := range preSum {
        left, right := sum-upper, sum-lower
        cnt += t.rank(right, true) - t.rank(left, false)
        t.insert(sum)
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$。

- 空间复杂度：$O(N)$。