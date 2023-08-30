#### 前言

线段树是一个二叉树，每个结点保存数组 $\textit{nums}$ 在区间 $[s,e]$ 的最小值、最大值或者总和等信息。线段树可以用树也可以用数组（堆式存储）来实现。对于数组实现，假设根结点的下标为 $1$，如果一个结点在数组的下标为 $\textit{node}$，那么它的左子结点下标为 $\textit{node} \times 2$，右子结点下标为 $\textit{node} \times 2 + 1$，线段树可以在 $O(\log N)$ 的时间复杂度内实现单点修改、区间修改、区间查询（区间求和，求区间最大值，求区间最小值）等操作，关于线段树的详细描述可以参考「[线段树](https://oi-wiki.org/ds/seg)」。

区间更新的线段树，需要借助「[懒惰标记]([11](https://oi-wiki.org/ds/seg/#%E7%BA%BF%E6%AE%B5%E6%A0%91%E7%9A%84%E5%8C%BA%E9%97%B4%E4%BF%AE%E6%94%B9%E4%B8%8E%E6%87%92%E6%83%B0%E6%A0%87%E8%AE%B0))」来标记当前结点所在区间是否需要更新。

+ 建树 $\textit{build}$ 函数：

    我们在结点 $\textit{node}$ 保存数组 $\textit{nums}$ 在区间 $[s, e]$ 的总和。

    + $s = e$ 时，结点 $\textit{node}$ 是叶子结点，它保存的值等于 $\textit{nums}[s]$。
    
    + $s < e$ 时，结点 $\textit{node}$ 的左子结点保存区间 $\Big [ s, \Big \lfloor \dfrac{s + e}{2} \Big \rfloor \Big ]$ 的总和，右子结点保存区间 $\Big [ \Big \lfloor \dfrac{s + e}{2} \Big  \rfloor + 1, e \Big ]$ 的总和，那么结点 $\textit{node}$ 保存的值等于它的两个子结点保存的值之和。

    假设 $\textit{nums}$ 的大小为 $n$，我们规定根结点 $\textit{node} = 1$ 保存区间 $[0, n - 1]$ 的总和，然后自下而上递归地建树。

+ 区间修改 $\textit{modify}$ 函数：

    当我们要修改区间 $\textit{nums}[\textit{left}\cdots{right}]$ 的值时，查看当前区间的结点此前是否已经「更新」过。如果更新过，那么我们通过将 $\text{pushdown}$ 函数将更新标记传递到子结点，对之前的操作进行更新，同时更新每个结点的懒标记 $\textit{lazytag}$，后续该位置便可以认为无需进行更新操作。

+ 区间查询 $\textit{query}$ 函数
    
    给定区间 $[\textit{left}, \textit{right}]$ 时，也需要像区间更新操作一样，需要使用 $\text{pushdown}$ 函数将更新标记往下传递到子结点，否则区间本身的数值实际上没有更新，懒标记只在区间修改或者区间查询时会往下传递，否则只是标记该区间需要更新。将区间 $[\textit{left}, \textit{right}]$ 拆成多个结点对应的区间。

    + 如果结点 $\textit{node}$ 对应的区间与 $[\textit{left}, \textit{right}]$ 相同，可以直接返回该结点的值，即当前区间和。

    + 如果结点 $\textit{node}$ 对应的区间与 $[\textit{left}, \textit{right}]$ 不同，设左子结点对应的区间的右端点为 $m$，那么将区间 $[\textit{left}, \textit{right}]$ 沿点 $m$ 拆成两个区间，分别向下传递懒标记，并计算左子结点和右子结点。

    从根结点开始递归地拆分区间 $[\textit{left}, \textit{right}]$，变拆分边计算并返回最终结果即可。

#### 方法一：线段树

**思路与算法**

本题目中含有三种操作：

+ 第一种操作是将给定区间 $[\textit{left}, \textit{right}]$ 内的所有数据进行反转，实际为是区间更新，此时我们可以利用线段树进行区间更新，此时需要用到「[线段树的区间修改与懒惰标记](https://oi-wiki.org/ds/seg/#%E7%BA%BF%E6%AE%B5%E6%A0%91%E7%9A%84%E5%8C%BA%E9%97%B4%E4%BF%AE%E6%94%B9%E4%B8%8E%E6%87%92%E6%83%B0%E6%A0%87%E8%AE%B0)」。

+ 第二种操作是唯一对 $\textit{nums}_2$ 中的元素进行更新，此时 $\textit{nums}'_2[i] = \textit{nums}_2[i] + \textit{nums}_1[i] \times p$，设数组 $\textit{nums}_2$ 更新之前的和为 $\textit{sum}$，更新之后的和为 $\textit{sum}'$，计算过程如下：

  $$
  \begin{aligned}
  \textit{sum}' &= \sum\limits_{i=0}^{n-1}{\textit{nums}'_2[i]}  \\ 
  &= \sum\limits_{i=0}^{n-1}(\textit{nums}_2[i] + \textit{nums}_1[i] \times p) \\
  &=\sum\limits_{i=0}^{n-1}\textit{nums}_2[i] + p \times \sum\limits_{i=0}^{n-1}\textit{nums}_1[i] \\ 
  &= \textit{sum} + p \times \sum\limits_{i=0}^{n-1}\textit{nums}_1[i]
  \end{aligned}
  $$

  根据上述等式可以看到，每次执行操作二时，实际 $\textit{nums}_2$ 的和会加上 $p$ 倍 $\textit{nums}_1$ 的元素之和，可在每次更新时维护数组 $\textit{nums}_2$ 的和。由于 $\textit{nums}_1$ 初始化时全部为 $0$，经过第一种操作时部分元素会进行反转，因此只需用线段树维护区间内 $1$ 的个数，每次进行区间查询即可得到数组 $\textit{nums}_1$ 的元素之和。

+ 第三种操作是求数组 $\textit{nums}_2$ 的元素之和，此时返回操作二中维护的 $\textit{nums}_2$ 的和即可。

根据以上分析，我们可以建立区间更新的线段树，可以参考「[线段树的区间修改与懒惰标记](https://oi-wiki.org/ds/seg/#%E7%BA%BF%E6%AE%B5%E6%A0%91%E7%9A%84%E5%8C%BA%E9%97%B4%E4%BF%AE%E6%94%B9%E4%B8%8E%E6%87%92%E6%83%B0%E6%A0%87%E8%AE%B0)」，当遇到操作一时进行区间更新，遇到操作二时进行区间查询即可。

**代码**

```C++ [sol1-C++]
struct SegNode {
    int l, r, sum;
    bool lazytag;
    SegNode() {
        this->l = 0;
        this->r = 0;
        this->sum = 0;
        this->lazytag = false;
    }
};

class SegTree {
private:
    vector<SegNode> arr;

public:
    SegTree(vector<int>& nums) {
        int n = nums.size();
        arr = vector<SegNode>(n * 4 + 1);
        build(1, 0, n - 1, nums);
    }

    int sumRange(int left, int right) {
        return query(1, left, right);
    }

    void reverseRange(int left, int right) {
        modify(1, left, right);
    }

    void build(int id, int l, int r, const vector<int> &nums) {
        arr[id].l = l;
        arr[id].r = r;
        arr[id].lazytag = false;
        if(l == r) {
            arr[id].sum = nums[l];
            return;
        }
        int mid = (l + r) >> 1;
        build(2 * id, l, mid, nums);
        build(2 * id + 1, mid + 1, r, nums);
        arr[id].sum = arr[2 * id].sum + arr[2 * id + 1].sum;
    }

    /* pushdown函数：下传懒标记，即将当前区间的修改情况下传到其左右孩子结点 */
    void pushdown(int x) {
        if(arr[x].lazytag) {
            arr[2 * x].lazytag = !arr[2 * x].lazytag;
            arr[2 * x].sum = arr[2 * x].r - arr[2 * x].l + 1 - arr[2 * x].sum;
            arr[2 * x + 1].lazytag = !arr[2 * x + 1].lazytag;
            arr[2 * x + 1].sum = arr[2 * x + 1].r - arr[2 * x + 1].l + 1 - arr[2 * x + 1].sum;
            arr[x].lazytag = false;
        }
    }

    /* 区间修改 */
    void modify(int id, int l, int r) {
        if (arr[id].l >= l && arr[id].r <= r) {
            arr[id].sum = (arr[id].r - arr[id].l + 1) - arr[id].sum;
            arr[id].lazytag = !arr[id].lazytag;
            return;
        }
        pushdown(id);
        int mid = (arr[id].l + arr[id].r) >> 1;
        if (arr[2 * id].r >= l) {
            modify(2 * id, l, r);
        }
        if(arr[2 * id + 1].l <= r) {
            modify(2 * id + 1, l, r);
        }
        arr[id].sum = arr[2 * id].sum + arr[2 * id + 1].sum;
    }
    
    /* 区间查询 */
    int query(int id, int l, int r) {
        if (arr[id].l >= l && arr[id].r <= r) {
            return arr[id].sum;
        }
        if (arr[id].r < l || arr[id].l > r) {
            return 0;
        }
        pushdown(id);
        int res = 0;
        if (arr[2 * id].r >= l) {
            res += query(2 * id, l, r);
        }
        if (arr[2 * id + 1].l <= r) {
            res += query(2 * id + 1, l, r);
        }
        return res;
    }
};


class Solution {
public:
    vector<long long> handleQuery(vector<int>& nums1, vector<int>& nums2, vector<vector<int>>& queries) {
        int n = nums1.size();
        int m = queries.size();
        SegTree tree(nums1);
        
        long long sum = accumulate(nums2.begin(), nums2.end(), 0LL);
        vector<long long> ans;
        for (int i = 0; i < m; i++) {
            if (queries[i][0] == 1) {
                int l = queries[i][1];
                int r = queries[i][2];
                tree.reverseRange(l, r);
            } else if (queries[i][0] == 2) {
                sum += (long long)tree.sumRange(0, n - 1) * queries[i][1];
            } else if (queries[i][0] == 3) {
                ans.emplace_back(sum);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public long[] handleQuery(int[] nums1, int[] nums2, int[][] queries) {
        int n = nums1.length;
        int m = queries.length;
        SegTree tree = new SegTree(nums1);
        
        long sum = 0;
        for (int num : nums2) {
            sum += num;
        }
        List<Long> list = new ArrayList<Long>();
        for (int i = 0; i < m; i++) {
            if (queries[i][0] == 1) {
                int l = queries[i][1];
                int r = queries[i][2];
                tree.reverseRange(l, r);
            } else if (queries[i][0] == 2) {
                sum += (long) tree.sumRange(0, n - 1) * queries[i][1];
            } else if (queries[i][0] == 3) {
                list.add(sum);
            }
        }
        long[] ans = new long[list.size()];
        for (int i = 0; i < list.size(); i++) {
            ans[i] = list.get(i);
        }
        return ans;
    }
}

class SegTree {
    private SegNode[] arr;

    public SegTree(int[] nums) {
        int n = nums.length;
        arr = new SegNode[n * 4 + 1];
        build(1, 0, n - 1, nums);
    }

    public int sumRange(int left, int right) {
        return query(1, left, right);
    }

    public void reverseRange(int left, int right) {
        modify(1, left, right);
    }

    public void build(int id, int l, int r, int[] nums) {
        arr[id] = new SegNode();
        arr[id].l = l;
        arr[id].r = r;
        arr[id].lazytag = false;
        if(l == r) {
            arr[id].sum = nums[l];
            return;
        }
        int mid = (l + r) >> 1;
        build(2 * id, l, mid, nums);
        build(2 * id + 1, mid + 1, r, nums);
        arr[id].sum = arr[2 * id].sum + arr[2 * id + 1].sum;
    }

    /* pushdown函数：下传懒标记，即将当前区间的修改情况下传到其左右孩子结点 */
    public void pushdown(int x) {
        if(arr[x].lazytag) {
            arr[2 * x].lazytag = !arr[2 * x].lazytag;
            arr[2 * x].sum = arr[2 * x].r - arr[2 * x].l + 1 - arr[2 * x].sum;
            arr[2 * x + 1].lazytag = !arr[2 * x + 1].lazytag;
            arr[2 * x + 1].sum = arr[2 * x + 1].r - arr[2 * x + 1].l + 1 - arr[2 * x + 1].sum;
            arr[x].lazytag = false;
        }
    }

    /* 区间修改 */
    public void modify(int id, int l, int r) {
        if (arr[id].l >= l && arr[id].r <= r) {
            arr[id].sum = (arr[id].r - arr[id].l + 1) - arr[id].sum;
            arr[id].lazytag = !arr[id].lazytag;
            return;
        }
        pushdown(id);
        int mid = (arr[id].l + arr[id].r) >> 1;
        if (arr[2 * id].r >= l) {
            modify(2 * id, l, r);
        }
        if(arr[2 * id + 1].l <= r) {
            modify(2 * id + 1, l, r);
        }
        arr[id].sum = arr[2 * id].sum + arr[2 * id + 1].sum;
    }
    
    /* 区间查询 */
    public int query(int id, int l, int r) {
        if (arr[id].l >= l && arr[id].r <= r) {
            return arr[id].sum;
        }
        if (arr[id].r < l || arr[id].l > r) {
            return 0;
        }
        pushdown(id);
        int res = 0;
        if (arr[2 * id].r >= l) {
            res += query(2 * id, l, r);
        }
        if (arr[2 * id + 1].l <= r) {
            res += query(2 * id + 1, l, r);
        }
        return res;
    }
}

class SegNode {
    public int l, r, sum;
    public boolean lazytag;

    public SegNode() {
        this.l = 0;
        this.r = 0;
        this.sum = 0;
        this.lazytag = false;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def handleQuery(self, nums1: List[int], nums2: List[int], queries: List[List[int]]) -> List[int]:
        n = len(nums1)
        m = len(queries)
        seg_tree = SegTree(nums1)

        total = sum(nums2)
        ans = []
        for i in range(m):
            if queries[i][0] == 1:
                l = queries[i][1]
                r = queries[i][2]
                seg_tree.reverse_range(l, r)
            elif queries[i][0] == 2:
                total += seg_tree.sum_range(0, n - 1) * queries[i][1]
            elif queries[i][0] == 3:
                ans.append(total)
        return ans


class SegTree:
    def __init__(self, nums):
        n = len(nums)
        self.arr = [SegNode() for _ in range(n * 4 + 1)]
        self.build(1, 0, n - 1, nums)

    def sum_range(self, left, right):
        return self.query(1, left, right)

    def reverse_range(self, left, right):
        self.modify(1, left, right)

    def build(self, id, l, r, nums):
        arr = self.arr
        arr[id] = SegNode()
        arr[id].l = l
        arr[id].r = r
        arr[id].lazytag = False
        if l == r:
            arr[id].sum = nums[l]
            return
        mid = (l + r) >> 1
        self.build(2 * id, l, mid, nums)
        self.build(2 * id + 1, mid + 1, r, nums)
        arr[id].sum = arr[2 * id].sum + arr[2 * id + 1].sum

    # pushdown函数：下传懒标记，即将当前区间的修改情况下传到其左右孩子结点
    def pushdown(self, x):
        arr = self.arr
        if arr[x].lazytag:
            arr[2 * x].lazytag = not arr[2 * x].lazytag
            arr[2 * x].sum = arr[2 * x].r - arr[2 * x].l + 1 - arr[2 * x].sum
            arr[2 * x + 1].lazytag = not arr[2 * x + 1].lazytag
            arr[2 * x + 1].sum = arr[2 * x + 1].r - arr[2 * x + 1].l + 1 - arr[2 * x + 1].sum
            arr[x].lazytag = False
    # 区间修改
    def modify(self, id, l, r):
        arr = self.arr
        if arr[id].l >= l and arr[id].r <= r:
            arr[id].sum = (arr[id].r - arr[id].l + 1) - arr[id].sum
            arr[id].lazytag = not arr[id].lazytag
            return
        self.pushdown(id)
        mid = (arr[id].l + arr[id].r) >> 1
        if arr[2 * id].r >= l:
            self.modify(2 * id, l, r)
        if arr[2 * id + 1].l <= r:
            self.modify(2 * id + 1, l, r)
        arr[id].sum = arr[2 * id].sum + arr[2 * id + 1].sum

    # 区间查询
    def query(self, id, l, r):
        arr = self.arr
        if arr[id].l >= l and arr[id].r <= r:
            return arr[id].sum
        if arr[id].r < l or arr[id].l > r:
            return 0
        self.pushdown(id)
        mid = (arr[id].l + arr[id].r) >> 1
        res = 0
        if arr[2 * id].r >= l:
            res += self.query(2 * id, l, r)
        if arr[2 * id + 1].l <= r:
            res += self.query(2 * id + 1, l, r)
        return res

class SegNode:
    def __init__(self):
        self.l = 0
        self.r = 0
        self.sum = 0
        self.lazytag = False
```

```C# [sol1-C#]
public class Solution {
    public long[] HandleQuery(int[] nums1, int[] nums2, int[][] queries) {
        int n = nums1.Length;
        int m = queries.Length;
        SegTree tree = new SegTree(nums1);
        
        long sum = 0;
        foreach (int num in nums2) {
            sum += num;
        }
        IList<long> list = new List<long>();
        for (int i = 0; i < m; i++) {
            if (queries[i][0] == 1) {
                int l = queries[i][1];
                int r = queries[i][2];
                tree.ReverseRange(l, r);
            } else if (queries[i][0] == 2) {
                sum += (long) tree.SumRange(0, n - 1) * queries[i][1];
            } else if (queries[i][0] == 3) {
                list.Add(sum);
            }
        }
        long[] ans = new long[list.Count];
        for (int i = 0; i < list.Count; i++) {
            ans[i] = list[i];
        }
        return ans;
    }
}

class SegTree {
    private SegNode[] arr;

    public SegTree(int[] nums) {
        int n = nums.Length;
        arr = new SegNode[n * 4 + 1];
        Build(1, 0, n - 1, nums);
    }

    public int SumRange(int left, int right) {
        return Query(1, left, right);
    }

    public void ReverseRange(int left, int right) {
        Modify(1, left, right);
    }

    public void Build(int id, int l, int r, int[] nums) {
        arr[id] = new SegNode();
        arr[id].l = l;
        arr[id].r = r;
        arr[id].lazytag = false;
        if(l == r) {
            arr[id].sum = nums[l];
            return;
        }
        int mid = (l + r) >> 1;
        Build(2 * id, l, mid, nums);
        Build(2 * id + 1, mid + 1, r, nums);
        arr[id].sum = arr[2 * id].sum + arr[2 * id + 1].sum;
    }

    /* pushdown函数：下传懒标记，即将当前区间的修改情况下传到其左右孩子结点 */
    public void Pushdown(int x) {
        if(arr[x].lazytag) {
            arr[2 * x].lazytag = !arr[2 * x].lazytag;
            arr[2 * x].sum = arr[2 * x].r - arr[2 * x].l + 1 - arr[2 * x].sum;
            arr[2 * x + 1].lazytag = !arr[2 * x + 1].lazytag;
            arr[2 * x + 1].sum = arr[2 * x + 1].r - arr[2 * x + 1].l + 1 - arr[2 * x + 1].sum;
            arr[x].lazytag = false;
        }
    }

    /* 区间修改 */
    public void Modify(int id, int l, int r) {
        if (arr[id].l >= l && arr[id].r <= r) {
            arr[id].sum = (arr[id].r - arr[id].l + 1) - arr[id].sum;
            arr[id].lazytag = !arr[id].lazytag;
            return;
        }
        Pushdown(id);
        int mid = (arr[id].l + arr[id].r) >> 1;
        if (arr[2 * id].r >= l) {
            Modify(2 * id, l, r);
        }
        if(arr[2 * id + 1].l <= r) {
            Modify(2 * id + 1, l, r);
        }
        arr[id].sum = arr[2 * id].sum + arr[2 * id + 1].sum;
    }
    
    /* 区间查询 */
    public int Query(int id, int l, int r) {
        if (arr[id].l >= l && arr[id].r <= r) {
            return arr[id].sum;
        }
        if (arr[id].r < l || arr[id].l > r) {
            return 0;
        }
        Pushdown(id);
        int res = 0;
        if (arr[2 * id].r >= l) {
            res += Query(2 * id, l, r);
        }
        if (arr[2 * id + 1].l <= r) {
            res += Query(2 * id + 1, l, r);
        }
        return res;
    }
}

class SegNode {
    public int l, r, sum;
    public bool lazytag;

    public SegNode() {
        this.l = 0;
        this.r = 0;
        this.sum = 0;
        this.lazytag = false;
    }
}
```

```C [sol1-C]
typedef struct SegNode {
    int l, r, sum;
    bool lazytag;
} SegNode;

typedef struct SegTree {
    SegNode *arr;
    int arrSize;
} SegTree;

void build(SegTree *obj, int id, int l, int r, const int *nums) {
    obj->arr[id].l = l;
    obj->arr[id].r = r;
    obj->arr[id].lazytag = false;
    if (l == r) {
        obj->arr[id].sum = nums[l];
        return;
    }
    int mid = (l + r) >> 1;
    build(obj, 2 * id, l, mid, nums);
    build(obj, 2 * id + 1, mid + 1, r, nums);
    obj->arr[id].sum = obj->arr[2 * id].sum + obj->arr[2 * id + 1].sum;
}

/* pushdown函数：下传懒标记，即将当前区间的修改情况下传到其左右孩子结点 */
void pushdown(SegTree *obj, int x)
{
    if (obj->arr[x].lazytag) {
        obj->arr[2 * x].lazytag = !obj->arr[2 * x].lazytag;
        obj->arr[2 * x].sum = obj->arr[2 * x].r - obj->arr[2 * x].l + 1 - obj->arr[2 * x].sum;
        obj->arr[2 * x + 1].lazytag = !obj->arr[2 * x + 1].lazytag;
        obj->arr[2 * x + 1].sum = obj->arr[2 * x + 1].r - obj->arr[2 * x + 1].l + 1 - obj->arr[2 * x + 1].sum;
        obj->arr[x].lazytag = false;
    }
}

/* 区间修改 */
void modify(SegTree *obj, int id, int l, int r) {
    if (obj->arr[id].l >= l && obj->arr[id].r <= r) {
        obj->arr[id].sum = (obj->arr[id].r - obj->arr[id].l + 1) - obj->arr[id].sum;
        obj->arr[id].lazytag = !obj->arr[id].lazytag;
        return;
    }
    pushdown(obj, id);
    int mid = (obj->arr[id].l + obj->arr[id].r) >> 1;
    if (obj->arr[2 * id].r >= l) {
        modify(obj, 2 * id, l, r);
    }
    if (obj->arr[2 * id + 1].l <= r) {
        modify(obj, 2 * id + 1, l, r);
    }
    obj->arr[id].sum = obj->arr[2 * id].sum + obj->arr[2 * id + 1].sum;
}

/* 区间查询 */
int query(SegTree *obj, int id, int l, int r) {
    if (obj->arr[id].l >= l && obj->arr[id].r <= r) {
        return obj->arr[id].sum;
    }
    if (obj->arr[id].r < l || obj->arr[id].l > r) {
        return 0;
    }
    pushdown(obj, id);
    int res = 0;
    if (obj->arr[2 * id].r >= l) {
        res += query(obj, 2 * id, l, r);
    }
    if (obj->arr[2 * id + 1].l <= r) {
        res += query(obj, 2 * id + 1, l, r);
    }
    return res;
}

SegTree* createSegTree(const int *nums, int numsSize) {
    SegTree *obj = (SegTree *)malloc(sizeof(SegTree));
    obj->arrSize = 4 * numsSize + 1;
    obj->arr = (SegNode *)malloc(sizeof(SegNode) * obj->arrSize);
    build(obj, 1, 0, numsSize - 1, nums);
    return obj;
}

void freeSegTree(SegTree *obj) {
    free(obj->arr);
    free(obj);
}

int sumRange(SegTree *obj, int left, int right) {
    return query(obj, 1, left, right);
}

void reverseRange(SegTree *obj, int left, int right) {
    modify(obj, 1, left, right);
}

long long* handleQuery(int* nums1, int nums1Size, int* nums2, int nums2Size, int** queries, int queriesSize, int* queriesColSize, int* returnSize) {
    int n = nums1Size;
    int m = queriesSize;
    SegTree *tree = createSegTree(nums1, nums1Size);
    long long sum = 0;
    for (int i = 0; i < n; i++) {
        sum += nums2[i];
    }
    long long *ans = (long long *)malloc(sizeof(long long) * m);
    int pos = 0;
    for (int i = 0; i < m; i++) {
        if (queries[i][0] == 1) {
            int l = queries[i][1];
            int r = queries[i][2];
            reverseRange(tree, l, r);
        } else if (queries[i][0] == 2) {
            sum += (long long)sumRange(tree, 0, n - 1) * queries[i][1];
        } else if (queries[i][0] == 3) {
            ans[pos++] = sum;
        }
    }
    *returnSize = pos;
    freeSegTree(tree);
    return ans;
}
```

```Golang [sol1-Golang]
type SegNode struct {
    l, r, sum int
    lazytag bool
}

type SegTree struct {
    arr []SegNode
}

func NewSegTree(nums []int) *SegTree {
    st := &SegTree{
        arr: make([]SegNode, len(nums) * 4 + 1),
    }
    st.build(1, 0, len(nums) - 1, nums)
    return st
}

func (this *SegTree) build(id, l, r int, nums []int) {
    this.arr[id].l, this.arr[id].r, this.arr[id].lazytag = l, r, false
    if l == r {
        this.arr[id].sum = nums[l]
        return
    }
    mid := (l + r) >> 1
    this.build(2 * id, l, mid, nums)
    this.build(2 * id + 1, mid + 1, r, nums)
    this.arr[id].sum = this.arr[2 * id].sum + this.arr[2 * id + 1].sum
}

func (this *SegTree) sumRange(left, right int) int {
    return this.query(1, left, right)
}

func (this *SegTree) reverseRange(left, right int) {
    this.modify(1, left, right)
}

func (this *SegTree) pushdown(x int) {
    if this.arr[x].lazytag {
        this.arr[2 * x].lazytag = !this.arr[2 * x].lazytag
        this.arr[2 * x].sum = this.arr[2 * x].r - this.arr[2 * x].l + 1 - this.arr[2 * x].sum
        this.arr[2 * x + 1].lazytag = !this.arr[2 * x + 1].lazytag
        this.arr[2 * x + 1].sum = this.arr[2 * x + 1].r - this.arr[2 * x + 1].l + 1 - this.arr[2 * x + 1].sum
        this.arr[x].lazytag = false
    }
}

func (this *SegTree) modify(id, l, r int) {
    if this.arr[id].l >= l && this.arr[id].r <= r {
        this.arr[id].sum = this.arr[id].r - this.arr[id].l + 1 - this.arr[id].sum
        this.arr[id].lazytag = !this.arr[id].lazytag
        return
    }
    this.pushdown(id)
    if this.arr[2 * id].r >= l {
        this.modify(2 * id, l, r)
    }
    if this.arr[2 * id + 1].l <= r {
        this.modify(2 * id + 1, l, r)
    }
    this.arr[id].sum = this.arr[2 * id].sum + this.arr[2 * id + 1].sum
}

func (this *SegTree) query(id, l, r int) int {
    if this.arr[id].l >= l && this.arr[id].r <= r {
        return this.arr[id].sum
    }
    if this.arr[id].r < l || this.arr[id].l > r {
        return 0
    }
    this.pushdown(id)
    res := 0
    if this.arr[2 * id].r >= l {
        res += this.query(2 * id, l, r)
    }
    if this.arr[2 * id + 1].l <= r {
        res += this.query(2 * id + 1, l, r)
    }
    return res
}

func handleQuery(nums1 []int, nums2 []int, queries [][]int) []int64 {
    n, m := len(nums1), len(queries)
    tree := NewSegTree(nums1)
    sum := int64(0)
    for _, x := range nums2 {
        sum = sum + int64(x)
    }
    res := []int64{}
    for i := 0; i < m; i++ {
        if queries[i][0] == 1 {
            l, r := queries[i][1], queries[i][2]
            tree.reverseRange(l, r)
        } else if queries[i][0] == 2 {
            sum += int64(tree.sumRange(0, n - 1)) * int64(queries[i][1])
        } else if queries[i][0] == 3 {
            res = append(res, sum)
        }
    }
    return res
}
```

```JavaScript [sol1-JavaScript]

var handleQuery = function(nums1, nums2, queries) {
    const n = nums1.length;
    const m = queries.length;
    const tree = new SegTree(nums1);
    
    let sum = 0;
    for (const num of nums2) {
        sum += num;
    }
    const list = [];
    for (let i = 0; i < m; i++) {
        if (queries[i][0] === 1) {
            let l = queries[i][1];
            let r = queries[i][2];
            tree.reverseRange(l, r);
        } else if (queries[i][0] === 2) {
            sum += tree.sumRange(0, n - 1) * queries[i][1];
        } else if (queries[i][0] === 3) {
            list.push(sum);
        }
    }
    const ans = new Array(list.length).fill(0);
    for (let i = 0; i < list.length; i++) {
        ans[i] = list[i];
    }
    return ans;
}

class SegTree {
    constructor(nums) {
        const n = nums.length;
        this.arr = new Array(n * 4 + 1);
        this.build(1, 0, n - 1, nums);
    }

    sumRange(left, right) {
        return this.query(1, left, right);
    }

    reverseRange(left, right) {
        this.modify(1, left, right);
    }

    build(id, l, r, nums) {
        this.arr[id] = new SegNode();
        this.arr[id].l = l;
        this.arr[id].r = r;
        this.arr[id].lazytag = false;
        if(l === r) {
            this.arr[id].sum = nums[l];
            return;
        }
        let mid = (l + r) >> 1;
        this.build(2 * id, l, mid, nums);
        this.build(2 * id + 1, mid + 1, r, nums);
        this.arr[id].sum = this.arr[2 * id].sum + this.arr[2 * id + 1].sum;
    }

    /* pushdown函数：下传懒标记，即将当前区间的修改情况下传到其左右孩子结点 */
    pushdown(x) {
        if(this.arr[x].lazytag) {
            this.arr[2 * x].lazytag = !this.arr[2 * x].lazytag;
            this.arr[2 * x].sum = this.arr[2 * x].r - this.arr[2 * x].l + 1 - this.arr[2 * x].sum;
            this.arr[2 * x + 1].lazytag = !this.arr[2 * x + 1].lazytag;
            this.arr[2 * x + 1].sum = this.arr[2 * x + 1].r - this.arr[2 * x + 1].l + 1 - this.arr[2 * x + 1].sum;
            this.arr[x].lazytag = false;
        }
    }

    /* 区间修改 */
    modify(id, l, r) {
        if (this.arr[id].l >= l && this.arr[id].r <= r) {
            this.arr[id].sum = (this.arr[id].r - this.arr[id].l + 1) - this.arr[id].sum;
            this.arr[id].lazytag = !this.arr[id].lazytag;
            return;
        }
        this.pushdown(id);
        let mid = (this.arr[id].l + this.arr[id].r) >> 1;
        if (this.arr[2 * id].r >= l) {
            this.modify(2 * id, l, r);
        }
        if(this.arr[2 * id + 1].l <= r) {
            this.modify(2 * id + 1, l, r);
        }
        this.arr[id].sum = this.arr[2 * id].sum + this.arr[2 * id + 1].sum;
    }
    
    /* 区间查询 */
    query(id, l, r) {
        if (this.arr[id].l >= l && this.arr[id].r <= r) {
            return this.arr[id].sum;
        }
        if (this.arr[id].r < l || this.arr[id].l > r) {
            return 0;
        }
        this.pushdown(id);
        let res = 0;
        if (this.arr[2 * id].r >= l) {
            res += this.query(2 * id, l, r);
        }
        if (this.arr[2 * id + 1].l <= r) {
            res += this.query(2 * id + 1, l, r);
        }
        return res;
    }
}

class SegNode {
    constructor() {
        this.l = 0;
        this.r = 0;
        this.sum = 0;
        this.lazytag = false;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(m \log n)$，其中 $m$ 表示操作 $1$ 与操作 $2$ 的次数之和，$n$ 表示数组的长度。每次遇到操作类型 $1$ 与操作类型 $2$ 时需要更新线段树，线段树每次更新与查询的时间复杂度均为 $O(\log n)$，一共最多有 $m$ 次操作，因此总的时间复杂度为 $O(m \log n)$。

- 空间复杂度：$O(Cn)$，其中 $n$ 表示数组的长度。本题解中线段树采用堆式存储，假设当前数组的长度为 $n$，由于线段树是一棵完全二叉树，此时该树的最大深度为 $\lceil \log n \rceil$，则其叶子结点的总数为 $2^{\lceil \log n \rceil}$，该树中含有的结点总数为 $2^{\lceil \log n \rceil + 1} - 1$，此时可以知道 $2^{\lceil \log n \rceil + 1} - 1 \le 2^{\log n + 2} - 1 \le 4n - 1$，因此本题中取 $C = 4$ 即可。