## [307.区域和检索 - 数组可修改 中文官方题解](https://leetcode.cn/problems/range-sum-query-mutable/solutions/100000/qu-yu-he-jian-suo-shu-zu-ke-xiu-gai-by-l-76xj)

#### 方法一：分块处理

**思路与算法**

设数组大小为 $n$，我们将数组 $\textit{nums}$ 分成多个块，每个块大小 $\textit{size}$，最后一个块的大小为剩余的不超过 $\textit{size}$ 的元素数目，那么块的总数为 $\Big  \lceil \dfrac{n}{\textit{size}} \Big \rceil$，用一个数组 $\textit{sum}$ 保存每个块的元素和。

+ 构造函数

    计算块大小 $\textit{size}$，初始化 $\textit{sum}$。

+ $\textit{update}$ 函数

    下标 $\textit{index}$ 对应的块下标为 $\Big \lfloor \dfrac{\textit{index}}{\textit{size}} \Big \rfloor$，更新 $\textit{nums}$ 和 $\textit{sum}$。

+ $\textit{sumRange}$ 函数

    设 $\textit{left}$ 位于第 $b_1$ 个块内的第 $i_1$ 个元素，$\textit{right}$ 位于第 $b_2$ 个块内的第 $i_2$ 个元素。如果 $b_1 = b_2$，那么直接返回第 $b_1$ 个块位于区间 $[i_1, i_2]$ 的元素之和；否则计算第 $b_1$ 个块位于区间 $[i_1, \textit{size} - 1)$的元素之和 $\textit{sum}_1$，第 $b_2$ 个块位于区间 $[0, i_2]$ 的元素之和 $\textit{sum}_2$，第 $b_1 + 1$ 个块到第 $b_2 - 1$ 个块的元素和的总和 $\textit{sum}_3$，返回 $\textit{sum}_1 + \textit{sum}_2 + \textit{sum}_3$。

对于块大小 $\textit{size}$ 的取值，我们从各个函数的时间复杂度入手。构造函数的时间复杂度为 $O(n)$，$\textit{update}$ 函数的时间复杂度为 $O(1)$，而 $\textit{sumRange}$ 函数的时间复杂度为 $O(\textit{size} + \dfrac{n}{size})$。因为 $\textit{size} + \dfrac{n}{\textit{size}} \ge 2\sqrt n$，仅当 $\textit{size} = \sqrt n$ 时等号成立。因此 $\textit{size}$ 取 $\lfloor \sqrt n \rfloor$，此时 $\textit{sumRange}$ 函数的时间复杂度为 $O(\sqrt n)$。

**代码**

```Python [sol1-Python3]
class NumArray:
    def __init__(self, nums: List[int]):
        n = len(nums)
        size = int(n ** 0.5)
        sums = [0] * ((n + size - 1) // size)  # n/size 向上取整
        for i, num in enumerate(nums):
            sums[i // size] += num
        self.nums = nums
        self.sums = sums
        self.size = size

    def update(self, index: int, val: int) -> None:
        self.sums[index // self.size] += val - self.nums[index]
        self.nums[index] = val

    def sumRange(self, left: int, right: int) -> int:
        m = self.size
        b1, b2 = left // m, right // m
        if b1 == b2:  # 区间 [left, right] 在同一块中
            return sum(self.nums[left:right + 1])
        return sum(self.nums[left:(b1 + 1) * m]) + sum(self.sums[b1 + 1:b2]) + sum(self.nums[b2 * m:right + 1])
```

```C++ [sol1-C++]
class NumArray {
private:
    vector<int> sum; // sum[i] 表示第 i 个块的元素和
    int size; // 块的大小
    vector<int> &nums;
public:
    NumArray(vector<int>& nums) : nums(nums) {
        int n = nums.size();
        size = sqrt(n);
        sum.resize((n + size - 1) / size); // n/size 向上取整
        for (int i = 0; i < n; i++) {
            sum[i / size] += nums[i];
        }
    }

    void update(int index, int val) {
        sum[index / size] += val - nums[index];
        nums[index] = val;
    }

    int sumRange(int left, int right) {
        int b1 = left / size, i1 = left % size, b2 = right / size, i2 = right % size;
        if (b1 == b2) { // 区间 [left, right] 在同一块中
            return accumulate(nums.begin() + b1 * size + i1, nums.begin() + b1 * size + i2 + 1, 0);
        }
        int sum1 = accumulate(nums.begin() + b1 * size + i1, nums.begin() + b1 * size + size, 0);
        int sum2 = accumulate(nums.begin() + b2 * size, nums.begin() + b2 * size + i2 + 1, 0);
        int sum3 = accumulate(sum.begin() + b1 + 1, sum.begin() + b2, 0);
        return sum1 + sum2 + sum3;
    }
};
```

```Java [sol1-Java]
class NumArray {
    private int[] sum; // sum[i] 表示第 i 个块的元素和
    private int size; // 块的大小
    private int[] nums;

    public NumArray(int[] nums) {
        this.nums = nums;
        int n = nums.length;
        size = (int) Math.sqrt(n);
        sum = new int[(n + size - 1) / size]; // n/size 向上取整
        for (int i = 0; i < n; i++) {
            sum[i / size] += nums[i];
        }
    }

    public void update(int index, int val) {
        sum[index / size] += val - nums[index];
        nums[index] = val;
    }

    public int sumRange(int left, int right) {
        int b1 = left / size, i1 = left % size, b2 = right / size, i2 = right % size;
        if (b1 == b2) { // 区间 [left, right] 在同一块中
            int sum = 0;
            for (int j = i1; j <= i2; j++) {
                sum += nums[b1 * size + j];
            }
            return sum;
        }
        int sum1 = 0;
        for (int j = i1; j < size; j++) {
            sum1 += nums[b1 * size + j];
        }
        int sum2 = 0;
        for (int j = 0; j <= i2; j++) {
            sum2 += nums[b2 * size + j];
        }
        int sum3 = 0;
        for (int j = b1 + 1; j < b2; j++) {
            sum3 += sum[j];
        }
        return sum1 + sum2 + sum3;
    }
}
```

```C# [sol1-C#]
public class NumArray {
    private int[] sum; // sum[i] 表示第 i 个块的元素和
    private int size; // 块的大小
    private int[] nums;

    public NumArray(int[] nums) {
        this.nums = nums;
        int n = nums.Length;
        size = (int) Math.Sqrt(n);
        sum = new int[(n + size - 1) / size]; // n/size 向上取整
        for (int i = 0; i < n; i++) {
            sum[i / size] += nums[i];
        }
    }

    public void Update(int index, int val) {
        sum[index / size] += val - nums[index];
        nums[index] = val;
    }

    public int SumRange(int left, int right) {
        int b1 = left / size, i1 = left % size, b2 = right / size, i2 = right % size;
        if (b1 == b2) { // 区间 [left, right] 在同一块中
            int sum = 0;
            for (int j = i1; j <= i2; j++) {
                sum += nums[b1 * size + j];
            }
            return sum;
        }
        int sum1 = 0;
        for (int j = i1; j < size; j++) {
            sum1 += nums[b1 * size + j];
        }
        int sum2 = 0;
        for (int j = 0; j <= i2; j++) {
            sum2 += nums[b2 * size + j];
        }
        int sum3 = 0;
        for (int j = b1 + 1; j < b2; j++) {
            sum3 += sum[j];
        }
        return sum1 + sum2 + sum3;
    }
}
```

```C [sol1-C]
typedef struct {
    int * sum; // sum[i] 表示第 i 个块的元素和
    int * nums;
    int blockSize; // 块的大小
} NumArray;

NumArray* numArrayCreate(int* nums, int numsSize) {
    NumArray * obj = (NumArray *)malloc(sizeof(NumArray));
    obj->blockSize = sqrt(numsSize);
    obj->sum = (int *)malloc(sizeof(int) * (numsSize + obj->blockSize - 1) / obj->blockSize);
    obj->nums = (int *)malloc(sizeof(int) * numsSize);
    memset(obj->sum, 0, sizeof(int) * (numsSize + obj->blockSize - 1) / obj->blockSize);
    memcpy(obj->nums, nums, sizeof(int) * numsSize);
    for (int i = 0; i < numsSize; i++) {
        obj->sum[i / obj->blockSize] += nums[i];
    }
    return obj;
}

void numArrayUpdate(NumArray* obj, int index, int val) {
    obj->sum[index / obj->blockSize] += val - obj->nums[index];
    obj->nums[index] = val;
}

int numArraySumRange(NumArray* obj, int left, int right) {
    int b1 = left / obj->blockSize, i1 = left % obj->blockSize;
    int b2 = right / obj->blockSize, i2 = right % obj->blockSize;
    int ans = 0;
    if (b1 == b2) { // 区间 [left, right] 在同一块中
        for (int i = i1; i <= i2; i++) {
            ans += obj->nums[b1 * obj->blockSize + i];
        }
        return ans;
    }
    for (int i = i1; i < obj->blockSize; i++) {
        ans += obj->nums[b1 * obj->blockSize + i];
    }
    for (int i = 0; i <= i2; i++) {
        ans += obj->nums[b2 * obj->blockSize + i];
    }
    for (int i = b1 + 1; i < b2; i++) {
        ans += obj->sum[i];
    }
    return ans;
}

void numArrayFree(NumArray* obj) {
    free(obj->nums);
    free(obj->sum);
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var NumArray = function(nums) {
    this.nums = nums;
    const n = nums.length;
    size = Math.floor(Math.sqrt(n));
    this.sum = new Array(Math.floor((n + size - 1) / size)).fill(0); // n/size 向上取整
    for (let i = 0; i < n; i++) {
        this.sum[Math.floor(i / size)] += nums[i];
    }
};

NumArray.prototype.update = function(index, val) {
    this.sum[Math.floor(index / size)] += val - this.nums[index];
    this.nums[index] = val;
};

NumArray.prototype.sumRange = function(left, right) {
    const b1 = Math.floor(left / size), i1 = left % size, b2 = Math.floor(right / size), i2 = right % size;
    if (b1 === b2) { // 区间 [left, right] 在同一块中
        let sum = 0;
        for (let j = i1; j <= i2; j++) {
            sum += this.nums[b1 * size + j];
        }
        return sum;
    }
    let sum1 = 0;
    for (let j = i1; j < size; j++) {
        sum1 += this.nums[b1 * size + j];
    }
    let sum2 = 0;
    for (let j = 0; j <= i2; j++) {
        sum2 += this.nums[b2 * size + j];
    }
    let sum3 = 0;
    for (let j = b1 + 1; j < b2; j++) {
        sum3 += this.sum[j];
    }
    return sum1 + sum2 + sum3;
};
```

```go [sol1-Golang]
type NumArray struct {
    nums, sums []int // sums[i] 表示第 i 个块的元素和
    size       int   // 块的大小
}

func Constructor(nums []int) NumArray {
    n := len(nums)
    size := int(math.Sqrt(float64(n)))
    sums := make([]int, (n+size-1)/size) // n/size 向上取整
    for i, num := range nums {
        sums[i/size] += num
    }
    return NumArray{nums, sums, size}
}

func (na *NumArray) Update(index, val int) {
    na.sums[index/na.size] += val - na.nums[index]
    na.nums[index] = val
}

func (na *NumArray) SumRange(left, right int) (ans int) {
    size := na.size
    b1, b2 := left/size, right/size
    if b1 == b2 { // 区间 [left, right] 在同一块中
        for i := left; i <= right; i++ {
            ans += na.nums[i]
        }
        return
    }
    for i := left; i < (b1+1)*size; i++ {
        ans += na.nums[i]
    }
    for i := b1 + 1; i < b2; i++ {
        ans += na.sums[i]
    }
    for i := b2 * size; i <= right; i++ {
        ans += na.nums[i]
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：构造函数为 $O(n)$，$\textit{update}$ 函数为 $O(1)$，$\textit{sumRange}$ 函数为 $O(\sqrt n)$，其中 $n$ 为数组 $\textit{nums}$ 的大小。对于 $\textit{sumRange}$ 函数，我们最多遍历两个块以及 $\textit{sum}$ 数组，因此时间复杂度为 $O(\sqrt n)$。

+ 空间复杂度：$O(\sqrt n)$。保存 $\textit{sum}$ 数组需要 $O(\sqrt n)$ 的空间。

#### 方法二：线段树

**思路与算法**

线段树 $\textit{segmentTree}$ 是一个二叉树，每个结点保存数组 $\textit{nums}$ 在区间 $[s, e]$ 的最小值、最大值或者总和等信息。线段树可以用树也可以用数组（堆式存储）来实现。对于数组实现，假设根结点的下标为 $0$，如果一个结点在数组的下标为 $\textit{node}$，那么它的左子结点下标为 $\textit{node} \times 2 + 1$，右子结点下标为 $\textit{node} \times 2 + 2$。

+ 建树 $\textit{build}$ 函数

    我们在结点 $\textit{node}$ 保存数组 $\textit{nums}$ 在区间 $[s, e]$ 的总和。

    + $s = e$ 时，结点 $\textit{node}$ 是叶子结点，它保存的值等于 $\textit{nums}[s]$。
    
    + $s < e$ 时，结点 $\textit{node}$ 的左子结点保存区间 $\Big [ s, \Big \lfloor \dfrac{s + e}{2} \Big \rfloor \Big ]$ 的总和，右子结点保存区间 $\Big [ \Big \lfloor \dfrac{s + e}{2} \Big  \rfloor + 1, e \Big ]$ 的总和，那么结点 $\textit{node}$ 保存的值等于它的两个子结点保存的值之和。

    假设 $\textit{nums}$ 的大小为 $n$，我们规定根结点 $\textit{node} = 0$ 保存区间 $[0, n - 1]$ 的总和，然后自下而上递归地建树。

+ 单点修改 $\textit{change}$ 函数

    当我们要修改 $\textit{nums}[\textit{index}]$ 的值时，我们找到对应区间 $[\textit{index}, \textit{index}]$ 的叶子结点，直接修改叶子结点的值为 $\textit{val}$，并自下而上递归地更新父结点的值。

+ 范围求和 $\textit{range}$ 函数

    给定区间 $[\textit{left}, \textit{right}]$ 时，我们将区间 $[\textit{left}, \textit{right}]$ 拆成多个结点对应的区间。

    + 如果结点 $\textit{node}$ 对应的区间与 $[\textit{left}, \textit{right}]$ 相同，可以直接返回该结点的值，即当前区间和。

    + 如果结点 $\textit{node}$ 对应的区间与 $[\textit{left}, \textit{right}]$ 不同，设左子结点对应的区间的右端点为 $m$，那么将区间 $[\textit{left}, \textit{right}]$ 沿点 $m$ 拆成两个区间，分别计算左子结点和右子结点。

    我们从根结点开始递归地拆分区间 $[\textit{left}, \textit{right}]$。

**代码**

```Python [sol2-Python3]
class NumArray:
    def __init__(self, nums: List[int]):
        n = len(nums)
        self.n = n
        self.seg = [0] * (n * 4)
        self.build(nums, 0, 0, n - 1)

    def build(self, nums: List[int], node: int, s: int, e: int):
        if s == e:
            self.seg[node] = nums[s]
            return
        m = s + (e - s) // 2
        self.build(nums, node * 2 + 1, s, m)
        self.build(nums, node * 2 + 2, m + 1, e)
        self.seg[node] = self.seg[node * 2 + 1] + self.seg[node * 2 + 2]

    def change(self, index: int, val: int, node: int, s: int, e: int):
        if s == e:
            self.seg[node] = val
            return
        m = s + (e - s) // 2
        if index <= m:
            self.change(index, val, node * 2 + 1, s, m)
        else:
            self.change(index, val, node * 2 + 2, m + 1, e)
        self.seg[node] = self.seg[node * 2 + 1] + self.seg[node * 2 + 2]

    def range(self, left: int, right: int, node: int, s: int, e: int) -> int:
        if left == s and right == e:
            return self.seg[node]
        m = s + (e - s) // 2
        if right <= m:
            return self.range(left, right, node * 2 + 1, s, m)
        if left > m:
            return self.range(left, right, node * 2 + 2, m + 1, e)
        return self.range(left, m, node * 2 + 1, s, m) + self.range(m + 1, right, node * 2 + 2, m + 1, e)

    def update(self, index: int, val: int) -> None:
        self.change(index, val, 0, 0, self.n - 1)

    def sumRange(self, left: int, right: int) -> int:
        return self.range(left, right, 0, 0, self.n - 1)
```

```C++ [sol2-C++]
class NumArray {
private:
    vector<int> segmentTree;
    int n;

    void build(int node, int s, int e, vector<int> &nums) {
        if (s == e) {
            segmentTree[node] = nums[s];
            return;
        }
        int m = s + (e - s) / 2;
        build(node * 2 + 1, s, m, nums);
        build(node * 2 + 2, m + 1, e, nums);
        segmentTree[node] = segmentTree[node * 2 + 1] + segmentTree[node * 2 + 2];
    }

    void change(int index, int val, int node, int s, int e) {
        if (s == e) {
            segmentTree[node] = val;
            return;
        }
        int m = s + (e - s) / 2;
        if (index <= m) {
            change(index, val, node * 2 + 1, s, m);
        } else {
            change(index, val, node * 2 + 2, m + 1, e);
        }
        segmentTree[node] = segmentTree[node * 2 + 1] + segmentTree[node * 2 + 2];
    }

    int range(int left, int right, int node, int s, int e) {
        if (left == s && right == e) {
            return segmentTree[node];
        }
        int m = s + (e - s) / 2;
        if (right <= m) {
            return range(left, right, node * 2 + 1, s, m);
        } else if (left > m) {
            return range(left, right, node * 2 + 2, m + 1, e);
        } else {
            return range(left, m, node * 2 + 1, s, m) + range(m + 1, right, node * 2 + 2, m + 1, e);
        }
    }

public:
    NumArray(vector<int>& nums) : n(nums.size()), segmentTree(nums.size() * 4) {
        build(0, 0, n - 1, nums);
    }

    void update(int index, int val) {
        change(index, val, 0, 0, n - 1);
    }

    int sumRange(int left, int right) {
        return range(left, right, 0, 0, n - 1);
    }
};
```

```Java [sol2-Java]
class NumArray {
    private int[] segmentTree;
    private int n;

    public NumArray(int[] nums) {
        n = nums.length;
        segmentTree = new int[nums.length * 4];
        build(0, 0, n - 1, nums);
    }

    public void update(int index, int val) {
        change(index, val, 0, 0, n - 1);
    }

    public int sumRange(int left, int right) {
        return range(left, right, 0, 0, n - 1);
    }

    private void build(int node, int s, int e, int[] nums) {
        if (s == e) {
            segmentTree[node] = nums[s];
            return;
        }
        int m = s + (e - s) / 2;
        build(node * 2 + 1, s, m, nums);
        build(node * 2 + 2, m + 1, e, nums);
        segmentTree[node] = segmentTree[node * 2 + 1] + segmentTree[node * 2 + 2];
    }

    private void change(int index, int val, int node, int s, int e) {
        if (s == e) {
            segmentTree[node] = val;
            return;
        }
        int m = s + (e - s) / 2;
        if (index <= m) {
            change(index, val, node * 2 + 1, s, m);
        } else {
            change(index, val, node * 2 + 2, m + 1, e);
        }
        segmentTree[node] = segmentTree[node * 2 + 1] + segmentTree[node * 2 + 2];
    }

    private int range(int left, int right, int node, int s, int e) {
        if (left == s && right == e) {
            return segmentTree[node];
        }
        int m = s + (e - s) / 2;
        if (right <= m) {
            return range(left, right, node * 2 + 1, s, m);
        } else if (left > m) {
            return range(left, right, node * 2 + 2, m + 1, e);
        } else {
            return range(left, m, node * 2 + 1, s, m) + range(m + 1, right, node * 2 + 2, m + 1, e);
        }
    }
}
```

```C# [sol2-C#]
public class NumArray {
    private int[] segmentTree;
    private int n;

    public NumArray(int[] nums) {
        n = nums.Length;
        segmentTree = new int[nums.Length * 4];
        Build(0, 0, n - 1, nums);
    }

    public void Update(int index, int val) {
        Change(index, val, 0, 0, n - 1);
    }

    public int SumRange(int left, int right) {
        return Range(left, right, 0, 0, n - 1);
    }

    private void Build(int node, int s, int e, int[] nums) {
        if (s == e) {
            segmentTree[node] = nums[s];
            return;
        }
        int m = s + (e - s) / 2;
        Build(node * 2 + 1, s, m, nums);
        Build(node * 2 + 2, m + 1, e, nums);
        segmentTree[node] = segmentTree[node * 2 + 1] + segmentTree[node * 2 + 2];
    }

    private void Change(int index, int val, int node, int s, int e) {
        if (s == e) {
            segmentTree[node] = val;
            return;
        }
        int m = s + (e - s) / 2;
        if (index <= m) {
            Change(index, val, node * 2 + 1, s, m);
        } else {
            Change(index, val, node * 2 + 2, m + 1, e);
        }
        segmentTree[node] = segmentTree[node * 2 + 1] + segmentTree[node * 2 + 2];
    }

    private int Range(int left, int right, int node, int s, int e) {
        if (left == s && right == e) {
            return segmentTree[node];
        }
        int m = s + (e - s) / 2;
        if (right <= m) {
            return Range(left, right, node * 2 + 1, s, m);
        } else if (left > m) {
            return Range(left, right, node * 2 + 2, m + 1, e);
        } else {
            return Range(left, m, node * 2 + 1, s, m) + Range(m + 1, right, node * 2 + 2, m + 1, e);
        }
    }
}
```

```C [sol2-C]
typedef struct {
    int * segmentTree;
    int numsSize; 
} NumArray;

void build(int * segmentTree, int node, int s, int e, const int * nums) {
    if (s == e) {
        segmentTree[node] = nums[s];
        return;
    }
    int m = s + (e - s) / 2;
    build(segmentTree, node * 2 + 1, s, m, nums);
    build(segmentTree, node * 2 + 2, m + 1, e, nums);
    segmentTree[node] = segmentTree[node * 2 + 1] + segmentTree[node * 2 + 2];
}

void change(int * segmentTree, int index, int val, int node, int s, int e) {
    if (s == e) {
        segmentTree[node] = val;
        return;
    }
    int m = s + (e - s) / 2;
    if (index <= m) {
        change(segmentTree, index, val, node * 2 + 1, s, m);
    } else {
        change(segmentTree, index, val, node * 2 + 2, m + 1, e);
    }
    segmentTree[node] = segmentTree[node * 2 + 1] + segmentTree[node * 2 + 2];
}

int range(const int * segmentTree, int left, int right, int node, int s, int e) {
    if (left == s && right == e) {
        return segmentTree[node];
    }
    int m = s + (e - s) / 2;
    if (right <= m) {
        return range(segmentTree, left, right, node * 2 + 1, s, m);
    } else if (left > m) {
        return range(segmentTree, left, right, node * 2 + 2, m + 1, e);
    } else {
        return range(segmentTree, left, m, node * 2 + 1, s, m) + \
               range(segmentTree, m + 1, right, node * 2 + 2, m + 1, e);
    }
}


NumArray* numArrayCreate(int* nums, int numsSize) {
    NumArray * obj = (int *)malloc(sizeof(NumArray));
    obj->numsSize = numsSize;
    obj->segmentTree = (int *)malloc(sizeof(int) * 4 * numsSize);
    build(obj->segmentTree, 0, 0, numsSize - 1, nums);
    return obj;
}

void numArrayUpdate(NumArray* obj, int index, int val) {
    change(obj->segmentTree, index, val, 0, 0, obj->numsSize - 1);
}

int numArraySumRange(NumArray* obj, int left, int right) {
    return range(obj->segmentTree, left, right, 0, 0, obj->numsSize - 1);
}

void numArrayFree(NumArray* obj) {
    free(obj->segmentTree);
    free(obj);
}
```

```JavaScript [sol2-JavaScript]
var NumArray = function(nums) {
    n = nums.length;
    this.segmentTree = new Array(nums.length * 4).fill(0);
    this.build(0, 0, n - 1, nums);
};

NumArray.prototype.update = function(index, val) {
    this.change(index, val, 0, 0, n - 1);
};

NumArray.prototype.sumRange = function(left, right) {
    return this.range(left, right, 0, 0, n - 1);
};

NumArray.prototype.build = function(node, s, e, nums) {
    if (s === e) {
        this.segmentTree[node] = nums[s];
        return;
    }
    const m = s + Math.floor((e - s) / 2);
    this.build(node * 2 + 1, s, m, nums);
    this.build(node * 2 + 2, m + 1, e, nums);
    this.segmentTree[node] = this.segmentTree[node * 2 + 1] + this.segmentTree[node * 2 + 2];
}

NumArray.prototype.change = function(index, val, node, s, e) {
    if (s === e) {
        this.segmentTree[node] = val;
        return;
    }
    const m = s + Math.floor((e - s) / 2);
    if (index <= m) {
        this.change(index, val, node * 2 + 1, s, m);
    } else {
        this.change(index, val, node * 2 + 2, m + 1, e);
    }
    this.segmentTree[node] = this.segmentTree[node * 2 + 1] + this.segmentTree[node * 2 + 2];
}

NumArray.prototype.range = function(left, right, node, s, e) {
    if (left === s && right === e) {
        return this.segmentTree[node];
    }
    const m = s + Math.floor((e - s) / 2);
    if (right <= m) {
        return this.range(left, right, node * 2 + 1, s, m);
    } else if (left > m) {
        return this.range(left, right, node * 2 + 2, m + 1, e);
    } else {
        return this.range(left, m, node * 2 + 1, s, m) + this.range(m + 1, right, node * 2 + 2, m + 1, e);
    }
}
```

```go [sol2-Golang]
type NumArray []int

func Constructor(nums []int) NumArray {
    n := len(nums)
    seg := make(NumArray, n*4)
    seg.build(nums, 0, 0, n-1)
    return seg
}

func (seg NumArray) build(nums []int, node, s, e int) {
    if s == e {
        seg[node] = nums[s]
        return
    }
    m := s + (e-s)/2
    seg.build(nums, node*2+1, s, m)
    seg.build(nums, node*2+2, m+1, e)
    seg[node] = seg[node*2+1] + seg[node*2+2]
}

func (seg NumArray) change(index, val, node, s, e int) {
    if s == e {
        seg[node] = val
        return
    }
    m := s + (e-s)/2
    if index <= m {
        seg.change(index, val, node*2+1, s, m)
    } else {
        seg.change(index, val, node*2+2, m+1, e)
    }
    seg[node] = seg[node*2+1] + seg[node*2+2]
}

func (seg NumArray) range_(left, right, node, s, e int) int {
    if left == s && right == e {
        return seg[node]
    }
    m := s + (e-s)/2
    if right <= m {
        return seg.range_(left, right, node*2+1, s, m)
    }
    if left > m {
        return seg.range_(left, right, node*2+2, m+1, e)
    }
    return seg.range_(left, m, node*2+1, s, m) + seg.range_(m+1, right, node*2+2, m+1, e)
}

func (seg NumArray) Update(index, val int) {
    seg.change(index, val, 0, 0, len(seg)/4-1)
}

func (seg NumArray) SumRange(left, right int) int {
    return seg.range_(left, right, 0, 0, len(seg)/4-1)
}
```

**复杂度分析**

+ 时间复杂度：
  
    + 构造函数：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的大小。二叉树的高度不超过 $\lceil \log n \rceil + 1$，那么 $\textit{segmentTree}$ 的大小不超过 $2 ^ {\lceil \log n \rceil + 1} - 1 \le 4n$，所以 $\textit{build}$ 的时间复杂度为 $O(n)$。
    
    + $\textit{update}$ 函数：$O(\log n)$。因为树的高度不超过 $\lceil \log n \rceil + 1$，所以涉及更新的结点数不超过 $\lceil \log n \rceil + 1$。
    
    + $\textit{sumRange}$ 函数：$O(\log n)$。每层结点最多访问四个，总共访问的结点数不超过 $4 \times (\lceil \log n \rceil + 1)$。

+ 空间复杂度：$O(n)$。保存 $\textit{segmentTree}$ 需要 $O(n)$ 的空间。

#### 方法三：树状数组

**思路与算法**

关于树状数组的详细介绍可以参考百度百科「[树状数组](https://baike.baidu.com/item/%E6%A0%91%E7%8A%B6%E6%95%B0%E7%BB%84)」，本文不作过多介绍。

树状数组是一种可以动态维护序列前缀和的数据结构（序列下标从 $1$ 开始），它的功能是：

+ 单点修改 $\textit{add}(\textit{index}, \textit{val})$：把序列第 $\textit{index}$ 个数增加 $\textit{val}$；

+ 区间查询 $\textit{prefixSum}(\textit{index})$：查询前 $\textit{index}$ 个元素的前缀和。

因为题目要求实现更新 $\textit{nums}$ 在某个位置的值，因此我们保存原始的 $\textit{nums}$ 数组。

+ 构造函数

    树状数组初始对应一个零序列，因此我们遍历 $\textit{nums}$ 数组，调用 $\textit{add}$ 函数来更新树状数组。

+ $\textit{update}$ 函数

    获取 $\textit{nums}$ 在 $\textit{index}$ 的增加值， 调用 $\textit{add}$ 函数更新树状数组，并更新 $\textit{nums}[\textit{index}] = \textit{val}$。

+ $\textit{sumRange}$ 函数

    区间和 $[\textit{left}, \textit{right}]$ 可以转化为两个前缀和之差，调用树状数组的 $\textit{prefixSum}$ 函数获取前 $\textit{right} + 1$ 个元素的前缀和 $\textit{sum}_1$ 和前 $\textit{left}$ 个元素的前缀和 $\textit{sum}_2$，返回 $\textit{sum}_1 - \textit{sum}_2$。 

**代码**

```Python [sol3-Python3]
class NumArray:
    def __init__(self, nums: List[int]):
        self.nums = nums
        self.tree = [0] * (len(nums) + 1)
        for i, num in enumerate(nums, 1):
            self.add(i, num)

    def add(self, index: int, val: int):
        while index < len(self.tree):
            self.tree[index] += val
            index += index & -index

    def prefixSum(self, index) -> int:
        s = 0
        while index:
            s += self.tree[index]
            index &= index - 1
        return s

    def update(self, index: int, val: int) -> None:
        self.add(index + 1, val - self.nums[index])
        self.nums[index] = val

    def sumRange(self, left: int, right: int) -> int:
        return self.prefixSum(right + 1) - self.prefixSum(left)
```

```C++ [sol3-C++]
class NumArray {
private:
    vector<int> tree;
    vector<int> &nums;

    int lowBit(int x) {
        return x & -x;
    }

    void add(int index, int val) {
        while (index < tree.size()) {
            tree[index] += val;
            index += lowBit(index);
        }
    }

    int prefixSum(int index) {
        int sum = 0;
        while (index > 0) {
            sum += tree[index];
            index -= lowBit(index);
        }
        return sum;
    }

public:
    NumArray(vector<int>& nums) : tree(nums.size() + 1), nums(nums) {
        for (int i = 0; i < nums.size(); i++) {
            add(i + 1, nums[i]);
        }
    }

    void update(int index, int val) {
        add(index + 1, val - nums[index]);
        nums[index] = val;
    }

    int sumRange(int left, int right) {
        return prefixSum(right + 1) - prefixSum(left);
    }
};
```

```Java [sol3-Java]
class NumArray {
    private int[] tree;
    private int[] nums;

    public NumArray(int[] nums) {
        this.tree = new int[nums.length + 1];
        this.nums = nums;
        for (int i = 0; i < nums.length; i++) {
            add(i + 1, nums[i]);
        }
    }

    public void update(int index, int val) {
        add(index + 1, val - nums[index]);
        nums[index] = val;
    }

    public int sumRange(int left, int right) {
        return prefixSum(right + 1) - prefixSum(left);
    }

    private int lowBit(int x) {
        return x & -x;
    }

    private void add(int index, int val) {
        while (index < tree.length) {
            tree[index] += val;
            index += lowBit(index);
        }
    }

    private int prefixSum(int index) {
        int sum = 0;
        while (index > 0) {
            sum += tree[index];
            index -= lowBit(index);
        }
        return sum;
    }
}
```

```C# [sol3-C#]
public class NumArray {
    private int[] tree;
    private int[] nums;

    public NumArray(int[] nums) {
        this.tree = new int[nums.Length + 1];
        this.nums = nums;
        for (int i = 0; i < nums.Length; i++) {
            Add(i + 1, nums[i]);
        }
    }
    
    public void Update(int index, int val) {
        Add(index + 1, val - nums[index]);
        nums[index] = val;
    }
    
    public int SumRange(int left, int right) {
        return PrefixSum(right + 1) - PrefixSum(left);
    }

    private int LowBit(int x) {
        return x & -x;
    }

    private void Add(int index, int val) {
        while (index < tree.Length) {
            tree[index] += val;
            index += LowBit(index);
        }
    }

    private int PrefixSum(int index) {
        int sum = 0;
        while (index > 0) {
            sum += tree[index];
            index -= LowBit(index);
        }
        return sum;
    }
}
```

```C [sol3-C]
typedef struct {
    int * nums;
    int * tree;
    int treeSize;
} NumArray;

int lowBit(int x) {
    return x & -x;
}

void add(int * tree, int treeSize, int index, int val) {
    while (index < treeSize) {
        tree[index] += val;
        index += lowBit(index);
    }
}

int prefixSum(const int * tree, int index) {
    int sum = 0;
    while (index > 0) {
        sum += tree[index];
        index -= lowBit(index);
    }
    return sum;
}

NumArray* numArrayCreate(int* nums, int numsSize) {
    NumArray * obj = (NumArray *)malloc(sizeof(NumArray));
    obj->nums = (int *)malloc(sizeof(int) * numsSize);
    memcpy(obj->nums, nums, sizeof(int) * numsSize);
    obj->treeSize = numsSize + 1;
    obj->tree = (int *)malloc(sizeof(int) * obj->treeSize);
    memset(obj->tree, 0, sizeof(int) * obj->treeSize);
    for (int i = 0; i < numsSize; i++) {
        add(obj->tree, obj->treeSize, i + 1, nums[i]);
    }
    return obj;
}

void numArrayUpdate(NumArray* obj, int index, int val) {
    add(obj->tree, obj->treeSize, index + 1, val - obj->nums[index]);
    obj->nums[index] = val;
}

int numArraySumRange(const NumArray* obj, int left, int right) {
    return prefixSum(obj->tree, right + 1) - prefixSum(obj->tree, left);
}

void numArrayFree(NumArray* obj) {
    free(obj->nums);
    free(obj->tree);
    free(obj);
}
```

```JavaScript [sol3-JavaScript]
var NumArray = function(nums) {
    this.tree = new Array(nums.length + 1).fill(0);
    this.nums = nums;
    for (let i = 0; i < nums.length; i++) {
        this.add(i + 1, nums[i]);
    }
};

NumArray.prototype.update = function(index, val) {
    this.add(index + 1, val - this.nums[index]);
    this.nums[index] = val;
};

NumArray.prototype.sumRange = function(left, right) {
    return this.prefixSum(right + 1) - this.prefixSum(left);
};

NumArray.prototype.lowBit = function(x) {
    return x & -x;
}

NumArray.prototype.add = function(index, val) {
    while (index < this.tree.length) {
        this.tree[index] += val;
        index += this.lowBit(index);
    }
}

NumArray.prototype.prefixSum = function(index) {
    let sum = 0;
    while (index > 0) {
        sum += this.tree[index];
        index -= this.lowBit(index);
    }
    return sum;
}
```

```go [sol3-Golang]
type NumArray struct {
    nums, tree []int
}

func Constructor(nums []int) NumArray {
    tree := make([]int, len(nums)+1)
    na := NumArray{nums, tree}
    for i, num := range nums {
        na.add(i+1, num)
    }
    return na
}

func (na *NumArray) add(index, val int) {
    for ; index < len(na.tree); index += index & -index {
        na.tree[index] += val
    }
}

func (na *NumArray) prefixSum(index int) (sum int) {
    for ; index > 0; index &= index - 1 {
        sum += na.tree[index]
    }
    return
}

func (na *NumArray) Update(index, val int) {
    na.add(index+1, val-na.nums[index])
    na.nums[index] = val
}

func (na *NumArray) SumRange(left, right int) int {
    return na.prefixSum(right+1) - na.prefixSum(left)
}
```

**复杂度分析**

+ 时间复杂度：
  
    + 构造函数：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的大小。$\textit{add}$ 函数的时间复杂度是 $O(\log n)$，总共调用 $n$ 次。
    
    + $\textit{update}$ 函数：$O(\log n)$。$\textit{add}$ 函数的时间复杂度是 $O(\log n)$。
    
    + $\textit{sumRange}$ 函数：$O(\log n)$。$\textit{prefixSum}$ 函数的时间复杂度是 $O(\log n)$。

+ 空间复杂度：$O(n)$。保存 $\textit{tree}$ 需要 $O(n)$ 的空间。