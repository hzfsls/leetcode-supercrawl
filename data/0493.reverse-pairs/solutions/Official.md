## [493.翻转对 中文官方题解](https://leetcode.cn/problems/reverse-pairs/solutions/100000/fan-zhuan-dui-by-leetcode-solution)

#### 前言

本题与「[327. 区间和的个数](https://leetcode-cn.com/problems/count-of-range-sum/)」非常相像。

在 327 题中，我们要对前缀和数组的每一个元素 $\textit{preSum}[i]$，找出所有位于 $i$ 左侧的下标 $j$ 的数量，要求 $j$ 满足 $\textit{preSum}[j] \in [\textit{preSum}[i]-\textit{upper}, \textit{preSum}[i]-\textit{lower}]$。而在此题中，我们则要对数组中的每一个元素 $\textit{sum}[i]$，找出位于 $i$ 左侧，且满足 $\textit{nums}[j] > 2\cdot \textit{nums}[i]$ 的下标 $j$。

不难发现，二者都是要对数组中的每一个元素，统计「在它左侧，且取值位于某个区间」的元素数量。两个问题唯一的区别仅仅在于取值区间的不同，因此可以用相似的方法解决这两个问题。

在「[327 题的题解：区间和的个数](https://leetcode-cn.com/problems/count-of-range-sum/solution/qu-jian-he-de-ge-shu-by-leetcode-solution/)」中，我们介绍了归并排序、线段树、树状数组以及平衡搜索树等多种解法。对于本题，我们只给出基于归并排序与树状数组的方法，感兴趣的读者可以参照前面给出的链接，自行完成其他方法的代码。

#### 方法一：归并排序

**思路及解法**

在归并排序的过程中，假设对于数组 $\textit{nums}[l..r]$ 而言，我们已经分别求出了子数组 $\textit{nums}[l..m]$ 与 $\textit{nums}[m+1..r]$ 的翻转对数目，**并已将两个子数组分别排好序**，则 $\textit{nums}[l..r]$ 中的翻转对数目，就等于两个子数组的翻转对数目之和，加上左右端点分别位于两个子数组的翻转对数目。

我们可以为两个数组分别维护指针 $i,j$。对于任意给定的 $i$ 而言，我们不断地向右移动 $j$，直到 $\textit{nums}[i] \le 2\cdot \textit{nums}[j]$。此时，意味着以 $i$ 为左端点的翻转对数量为 $j-m-1$。随后，我们再将 $i$ 向右移动一个单位，并用相同的方式计算以 $i$ 为左端点的翻转对数量。不断重复这样的过程，就能够求出所有左右端点分别位于两个子数组的翻转对数目。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int reversePairsRecursive(vector<int>& nums, int left, int right) {
        if (left == right) {
            return 0;
        } else {
            int mid = (left + right) / 2;
            int n1 = reversePairsRecursive(nums, left, mid);
            int n2 = reversePairsRecursive(nums, mid + 1, right);
            int ret = n1 + n2;

            // 首先统计下标对的数量
            int i = left;
            int j = mid + 1;
            while (i <= mid) {
                while (j <= right && (long long)nums[i] > 2 * (long long)nums[j]) j++;
                ret += (j - mid - 1);
                i++;
            }

            // 随后合并两个排序数组
            vector<int> sorted(right - left + 1);
            int p1 = left, p2 = mid + 1;
            int p = 0;
            while (p1 <= mid || p2 <= right) {
                if (p1 > mid) {
                    sorted[p++] = nums[p2++];
                } else if (p2 > right) {
                    sorted[p++] = nums[p1++];
                } else {
                    if (nums[p1] < nums[p2]) {
                        sorted[p++] = nums[p1++];
                    } else {
                        sorted[p++] = nums[p2++];
                    }
                }
            }
            for (int i = 0; i < sorted.size(); i++) {
                nums[left + i] = sorted[i];
            }
            return ret;
        }
    }

    int reversePairs(vector<int>& nums) {
        if (nums.size() == 0) return 0;
        return reversePairsRecursive(nums, 0, nums.size() - 1);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int reversePairs(int[] nums) {
        if (nums.length == 0) {
            return 0;
        }
        return reversePairsRecursive(nums, 0, nums.length - 1);
    }

    public int reversePairsRecursive(int[] nums, int left, int right) {
        if (left == right) {
            return 0;
        } else {
            int mid = (left + right) / 2;
            int n1 = reversePairsRecursive(nums, left, mid);
            int n2 = reversePairsRecursive(nums, mid + 1, right);
            int ret = n1 + n2;

            // 首先统计下标对的数量
            int i = left;
            int j = mid + 1;
            while (i <= mid) {
                while (j <= right && (long) nums[i] > 2 * (long) nums[j]) {
                    j++;
                }
                ret += j - mid - 1;
                i++;
            }

            // 随后合并两个排序数组
            int[] sorted = new int[right - left + 1];
            int p1 = left, p2 = mid + 1;
            int p = 0;
            while (p1 <= mid || p2 <= right) {
                if (p1 > mid) {
                    sorted[p++] = nums[p2++];
                } else if (p2 > right) {
                    sorted[p++] = nums[p1++];
                } else {
                    if (nums[p1] < nums[p2]) {
                        sorted[p++] = nums[p1++];
                    } else {
                        sorted[p++] = nums[p2++];
                    }
                }
            }
            for (int k = 0; k < sorted.length; k++) {
                nums[left + k] = sorted[k];
            }
            return ret;
        }
    }
}
```

```Golang [sol1-Golang]
func reversePairs(nums []int) int {
    n := len(nums)
    if n <= 1 {
        return 0
    }

    n1 := append([]int(nil), nums[:n/2]...)
    n2 := append([]int(nil), nums[n/2:]...)
    cnt := reversePairs(n1) + reversePairs(n2) // 递归完毕后，n1 和 n2 均为有序

    // 统计重要翻转对 (i,j) 的数量
    // 由于 n1 和 n2 均为有序，可以用两个指针同时遍历
    j := 0
    for _, v := range n1 {
        for j < len(n2) && v > 2*n2[j] {
            j++
        }
        cnt += j
    }

    // n1 和 n2 归并填入 nums
    p1, p2 := 0, 0
    for i := range nums {
        if p1 < len(n1) && (p2 == len(n2) || n1[p1] <= n2[p2]) {
            nums[i] = n1[p1]
            p1++
        } else {
            nums[i] = n2[p2]
            p2++
        }
    }
    return cnt
}
```

```C [sol1-C]
int reversePairsRecursive(int* nums, int left, int right) {
    if (left == right) {
        return 0;
    } else {
        int mid = (left + right) / 2;
        int n1 = reversePairsRecursive(nums, left, mid);
        int n2 = reversePairsRecursive(nums, mid + 1, right);
        int ret = n1 + n2;

        // 首先统计下标对的数量
        int i = left;
        int j = mid + 1;
        while (i <= mid) {
            while (j <= right && (long long)nums[i] > 2 * (long long)nums[j]) j++;
            ret += (j - mid - 1);
            i++;
        }

        // 随后合并两个排序数组
        int sorted[right - left + 1];
        int p1 = left, p2 = mid + 1;
        int p = 0;
        while (p1 <= mid || p2 <= right) {
            if (p1 > mid) {
                sorted[p++] = nums[p2++];
            } else if (p2 > right) {
                sorted[p++] = nums[p1++];
            } else {
                if (nums[p1] < nums[p2]) {
                    sorted[p++] = nums[p1++];
                } else {
                    sorted[p++] = nums[p2++];
                }
            }
        }
        for (int i = 0; i < right - left + 1; i++) {
            nums[left + i] = sorted[i];
        }
        return ret;
    }
}

int reversePairs(int* nums, int numsSize) {
    if (numsSize == 0) {
        return 0;
    }
    return reversePairsRecursive(nums, 0, numsSize - 1);
}
```

```JavaScript [sol1-JavaScript]
var reversePairs = function(nums) {
    if (nums.length === 0) {
        return 0;
    }
    return reversePairsRecursive(nums, 0, nums.length - 1);
};

const reversePairsRecursive = (nums, left, right) => {
    if (left === right) {
        return 0;
    } else {
        const mid = Math.floor((left + right) / 2);
        const n1 = reversePairsRecursive(nums, left, mid);
        const n2 = reversePairsRecursive(nums, mid + 1, right);
        let ret = n1 + n2;

        let i = left;
        let j = mid + 1;
        while (i <= mid) {
            while (j <= right && nums[i] > 2 * nums[j]) {
                j++;
            }
            ret += j - mid - 1;
            i++;
        }

        const sorted = new Array(right - left + 1);
        let p1 = left, p2 = mid + 1;
        let p = 0;
        while (p1 <= mid || p2 <= right) {
            if (p1 > mid) {
                sorted[p++] = nums[p2++];
            } else if (p2 > right) {
                sorted[p++] = nums[p1++];
            } else {
                if (nums[p1] < nums[p2]) {
                    sorted[p++] = nums[p1++];
                } else {
                    sorted[p++] = nums[p2++];
                }
            }
        }
        for (let k = 0; k < sorted.length; k++) {
            nums[left + k] = sorted[k];
        }
        return ret;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$，其中 $N$ 为数组的长度。

- 空间复杂度：$O(N)$，其中 $N$ 为数组的长度。

#### 方法二：树状数组

**思路及解法**

树状数组支持的基本查询为求出 $[1, \textit{val}]$ 之间的整数数量。因此，对于 $\textit{nums}[i]$ 而言，我们首先查询 $[1,2\cdot\textit{nums}[i]]$ 的数量，再求出 $[1,\textit{maxValue}]$ 的数量（其中 $\textit{maxValue}$ 为数组中最大元素的二倍）。二者相减，就能够得到以 $i$ 为右端点的翻转对数量。

由于数组中整数的范围可能很大，故在使用树状数组解法之前，需要利用哈希表将所有可能出现的整数，映射到连续的整数区间内。

**代码**

```C++ [sol2-C++]
class BIT {
private:
    vector<int> tree;
    int n;

public:
    BIT(int _n) : n(_n), tree(_n + 1) {}

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
    int reversePairs(vector<int>& nums) {
        set<long long> allNumbers;
        for (int x : nums) {
            allNumbers.insert(x);
            allNumbers.insert((long long)x * 2);
        }
        // 利用哈希表进行离散化
        unordered_map<long long, int> values;
        int idx = 0;
        for (long long x : allNumbers) {
            values[x] = ++idx;
        }

        int ret = 0;
        BIT bit(values.size());
        for (int i = 0; i < nums.size(); i++) {
            int left = values[(long long)nums[i] * 2], right = values.size();
            ret += bit.query(right) - bit.query(left);
            bit.update(values[nums[i]], 1);
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int reversePairs(int[] nums) {
        Set<Long> allNumbers = new TreeSet<Long>();
        for (int x : nums) {
            allNumbers.add((long) x);
            allNumbers.add((long) x * 2);
        }
        // 利用哈希表进行离散化
        Map<Long, Integer> values = new HashMap<Long, Integer>();
        int idx = 0;
        for (long x : allNumbers) {
            values.put(x, idx);
            idx++;
        }

        int ret = 0;
        BIT bit = new BIT(values.size());
        for (int i = 0; i < nums.length; i++) {
            int left = values.get((long) nums[i] * 2), right = values.size() - 1;
            ret += bit.query(right + 1) - bit.query(left + 1);
            bit.update(values.get((long) nums[i]) + 1, 1);
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

```Golang [sol2-Golang]
type fenwick struct {
    tree []int
}

func newFenwickTree(n int) fenwick {
    return fenwick{make([]int, n+1)}
}

func (f fenwick) add(i int) {
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

func reversePairs(nums []int) (cnt int) {
    n := len(nums)
    if n <= 1 {
        return
    }

    // 离散化所有下面统计时会出现的元素
    allNums := make([]int, 0, 2*n)
    for _, v := range nums {
        allNums = append(allNums, v, 2*v)
    }
    sort.Ints(allNums)
    k := 1
    kth := map[int]int{allNums[0]: k}
    for i := 1; i < 2*n; i++ {
        if allNums[i] != allNums[i-1] {
            k++
            kth[allNums[i]] = k
        }
    }

    t := newFenwickTree(k)
    for i, v := range nums {
        // 统计之前插入了多少个比 2*v 大的数
        cnt += i - t.sum(kth[2*v])
        t.add(kth[v])
    }
    return
}
```

```C [sol2-C]
int lowbit(int x) {
    return x & (-x);
}

void update(int* tree, int treeSize, int x, int d) {
    while (x <= treeSize) {
        tree[x] += d;
        x += lowbit(x);
    }
}

int query(int* tree, int x) {
    int ans = 0;
    while (x) {
        ans += tree[x];
        x -= lowbit(x);
    }
    return ans;
}

int cmp(void* _a, void* _b) {
    long long a = *((long long*)_a), b = *((long long*)_b);
    return a < b ? -1 : 1;
}

int lower_bound(long long* a, int aSize, long long target) {
    int left = 0, right = aSize;
    while (left < right) {
        int mid = (left + right) / 2;
        if (a[mid] < target) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }
    return left;
}

int discrete(int* nums, int numsSize, int* ret) {
    long long rec[numsSize * 2];
    for (int i = 0; i < numsSize; i++) {
        rec[i * 2] = nums[i], rec[i * 2 + 1] = (long long)nums[i] * 2;
    }
    qsort(rec, numsSize * 2, sizeof(long long), cmp);
    int retSize = 0;
    for (int i = 0; i < numsSize * 2; i++) {
        if (retSize == 0 || rec[retSize - 1] != rec[i]) {
            rec[retSize++] = rec[i];
        }
    }
    for (int i = 0; i < numsSize; i++) {
        ret[i * 2] = lower_bound(rec, retSize, nums[i]) + 1;
        ret[i * 2 + 1] = lower_bound(rec, retSize, (long long)nums[i] * 2) + 1;
    }
    return retSize;
}

int reversePairs(int* nums, int numsSize) {
    if (numsSize == 0) {
        return 0;
    }

    int values[numsSize * 2];
    int valuesSize = discrete(nums, numsSize, values);
    int ret = 0;
    int tree[valuesSize + 2];
    memset(tree, 0, sizeof(tree));
    for (int i = 0; i < numsSize; i++) {
        int left = values[i * 2 + 1], right = valuesSize + 1;
        ret += query(tree, right) - query(tree, left);
        update(tree, valuesSize + 1, values[i * 2], 1);
    }
    return ret;
}
```

```JavaScript [sol2-JavaScript]
var reversePairs = function(nums) {
    const allNumbers = Array.from(
        new Set([...nums, ...nums.map(x => 2 * x)]
        .sort((x, y) => x - y))
    );
    // 利用哈希表进行优化
    const values = new Map();
    let idx = 0;
    allNumbers.forEach(x => values.set(x, ++idx));

    let ret = 0;
    const bit = new BIT(values.size);
    for (let i = 0; i < nums.length; i++) {
        let left = values.get(nums[i] * 2), right = values.size;
        ret += bit.query(right) - bit.query(left);
        bit.update(values.get(nums[i]), 1);
    }
    return ret;
};

let BIT = class {
    constructor(n) {
        this.n = n;
        this.tree = new Array(n + 1).fill(0);
    }

    lowbit(x) {
        return x & (-x);
    }

    update(x, d) {
        while (x <= this.n) {
            this.tree[x] += d;
            x += this.lowbit(x);
        }
    }

    query(x) {
        let ans = 0;
        while (x > 0) {
            ans += this.tree[x];
            x -= this.lowbit(x);
        }
        return ans;
    }
}

```

**复杂度分析**

- 时间复杂度：$O(N\log N)$，其中 $N$ 为数组的长度。

- 空间复杂度：$O(N)$，其中 $N$ 为数组的长度。