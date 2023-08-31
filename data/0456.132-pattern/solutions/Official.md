## [456.132 模式 中文官方题解](https://leetcode.cn/problems/132-pattern/solutions/100000/132mo-shi-by-leetcode-solution-ye89)

#### 前言

由于本题中 $n$ 的最大值可以到 $2 \times 10^5$，因此对于一个满足 $132$ 模式的三元组下标 $(i, j, k)$，枚举其中的 $2$ 个下标时间复杂度为 $O(n^2)$，会超出时间限制。

因此我们可以考虑枚举其中的 $1$ 个下标，并使用合适的数据结构维护另外的 $2$ 个下标的可能值。

#### 方法一：枚举 $3$

**思路与算法**

枚举 $3$ 是容易想到并且也是最容易实现的。由于 $3$ 是模式中的最大值，并且其出现在 $1$ 和 $2$ 的中间，因此我们只需要从左到右枚举 $3$ 的下标 $j$，那么：

- 由于 $1$ 是模式中的最小值，因此我们在枚举 $j$ 的同时，维护数组 $a$ 中左侧元素 $a[0..j-1]$ 的最小值，即为 $1$ 对应的元素 $a[i]$。需要注意的是，只有 $a[i] < a[j]$ 时，$a[i]$ 才能作为 $1$ 对应的元素；

- 由于 $2$ 是模式中的次小值，因此我们可以使用一个有序集合（例如平衡树）维护数组 $a$ 中右侧元素 $a[j+1..n-1]$ 中的所有值。当我们确定了 $a[i]$ 和 $a[j]$ 之后，只需要在有序集合中查询严格比 $a[i]$ 大的那个最小的元素，即为 $a[k]$。需要注意的是，只有 $a[k] < a[j]$ 时，$a[k]$ 才能作为 $3$ 对应的元素。

**代码**

下面的 $\texttt{Python}$ 代码需要手动导入 $\texttt{sortedcontainers}$ 库。

```C++ [sol1-C++]
class Solution {
public:
    bool find132pattern(vector<int>& nums) {
        int n = nums.size();
        if (n < 3) {
            return false;
        }

        // 左侧最小值
        int left_min = nums[0];
        // 右侧所有元素
        multiset<int> right_all;

        for (int k = 2; k < n; ++k) {
            right_all.insert(nums[k]);
        }

        for (int j = 1; j < n - 1; ++j) {
            if (left_min < nums[j]) {
                auto it = right_all.upper_bound(left_min);
                if (it != right_all.end() && *it < nums[j]) {
                    return true;
                }
            }
            left_min = min(left_min, nums[j]);
            right_all.erase(right_all.find(nums[j + 1]));
        }

        return false;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean find132pattern(int[] nums) {
        int n = nums.length;
        if (n < 3) {
            return false;
        }

        // 左侧最小值
        int leftMin = nums[0];
        // 右侧所有元素
        TreeMap<Integer, Integer> rightAll = new TreeMap<Integer, Integer>();

        for (int k = 2; k < n; ++k) {
            rightAll.put(nums[k], rightAll.getOrDefault(nums[k], 0) + 1);
        }

        for (int j = 1; j < n - 1; ++j) {
            if (leftMin < nums[j]) {
                Integer next = rightAll.ceilingKey(leftMin + 1);
                if (next != null && next < nums[j]) {
                    return true;
                }
            }
            leftMin = Math.min(leftMin, nums[j]);
            rightAll.put(nums[j + 1], rightAll.get(nums[j + 1]) - 1);
            if (rightAll.get(nums[j + 1]) == 0) {
                rightAll.remove(nums[j + 1]);
            }
        }

        return false;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def find132pattern(self, nums: List[int]) -> bool:
        n = len(nums)
        if n < 3:
            return False
        
        # 左侧最小值
        left_min = nums[0]
        # 右侧所有元素
        right_all = SortedList(nums[2:])
        
        for j in range(1, n - 1):
            if left_min < nums[j]:
                index = right_all.bisect_right(left_min)
                if index < len(right_all) and right_all[index] < nums[j]:
                    return True
            left_min = min(left_min, nums[j])
            right_all.remove(nums[j + 1])

        return False
```

```go [sol1-Golang]
import "math/rand"

type node struct {
    ch       [2]*node
    priority int
    val      int
    cnt      int
}

func (o *node) cmp(b int) int {
    switch {
    case b < o.val:
        return 0
    case b > o.val:
        return 1
    default:
        return -1
    }
}

func (o *node) rotate(d int) *node {
    x := o.ch[d^1]
    o.ch[d^1] = x.ch[d]
    x.ch[d] = o
    return x
}

type treap struct {
    root *node
}

func (t *treap) _put(o *node, val int) *node {
    if o == nil {
        return &node{priority: rand.Int(), val: val, cnt: 1}
    }
    if d := o.cmp(val); d >= 0 {
        o.ch[d] = t._put(o.ch[d], val)
        if o.ch[d].priority > o.priority {
            o = o.rotate(d ^ 1)
        }
    } else {
        o.cnt++
    }
    return o
}

func (t *treap) put(val int) {
    t.root = t._put(t.root, val)
}

func (t *treap) _delete(o *node, val int) *node {
    if o == nil {
        return nil
    }
    if d := o.cmp(val); d >= 0 {
        o.ch[d] = t._delete(o.ch[d], val)
        return o
    }
    if o.cnt > 1 {
        o.cnt--
        return o
    }
    if o.ch[1] == nil {
        return o.ch[0]
    }
    if o.ch[0] == nil {
        return o.ch[1]
    }
    d := 0
    if o.ch[0].priority > o.ch[1].priority {
        d = 1
    }
    o = o.rotate(d)
    o.ch[d] = t._delete(o.ch[d], val)
    return o
}

func (t *treap) delete(val int) {
    t.root = t._delete(t.root, val)
}

func (t *treap) upperBound(val int) (ub *node) {
    for o := t.root; o != nil; {
        if o.cmp(val) == 0 {
            ub = o
            o = o.ch[0]
        } else {
            o = o.ch[1]
        }
    }
    return
}

func find132pattern(nums []int) bool {
    n := len(nums)
    if n < 3 {
        return false
    }

    leftMin := nums[0]
    rights := &treap{}
    for _, v := range nums[2:] {
        rights.put(v)
    }

    for j := 1; j < n-1; j++ {
        if nums[j] > leftMin {
            ub := rights.upperBound(leftMin)
            if ub != nil && ub.val < nums[j] {
                return true
            }
        } else {
            leftMin = nums[j]
        }
        rights.delete(nums[j+1])
    }

    return false
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$。在初始化时，我们需要 $O(n \log n)$ 的时间将数组元素 $a[2..n-1]$ 加入有序集合中。在枚举 $j$ 时，维护左侧元素最小值的时间复杂度为 $O(1)$，将 $a[j+1]$ 从有序集合中删除的时间复杂度为 $O(\log n)$，总共需要枚举的次数为 $O(n)$，因此总时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$，即为有序集合存储右侧所有元素需要使用的空间。

#### 方法二：枚举 $1$

**思路与算法**

如果我们从左到右枚举 $1$ 的下标 $i$，那么 $j, k$ 的下标范围都是减少的，这样就不利于对它们进行维护。因此我们可以考虑从右到左枚举 $i$。

那么我们应该如何维护 $j, k$ 呢？在 $132$ 模式中，如果 $1<2$ 并且 $2<3$，那么根据传递性，$1<3$ 也是成立的，那么我们可以使用下面的方法进行维护：

- 我们使用一种数据结构维护所有遍历过的元素，它们作为 $2$ 的候选元素。每当我们遍历到一个新的元素时，就将其加入数据结构中；

- 在遍历到一个新的元素的同时，我们可以考虑其是否可以作为 $3$。如果它作为 $3$，那么**数据结构中所有严格小于它的元素都可以作为 $2$**，我们将这些元素全部从数据结构中移除，并且使用一个变量维护**所有被移除的元素的最大值**。这些被移除的元素都是可以真正作为 $2$ 的，并且元素的值越大，那么我们之后找到 $1$ 的机会也就越大。

那么这个「数据结构」是什么样的数据结构呢？我们尝试提取出它进行的操作：

- 它需要支持添加一个元素；

- 它需要支持移除所有严格小于给定阈值的所有元素；

- 上面两步操作是「依次进行」的，即我们先用给定的阈值移除元素，再将该阈值加入数据结构中。

这就是「单调栈」。在单调栈中，从栈底到栈顶的元素是严格单调递减的。当给定阈值 $x$ 时，我们只需要不断地弹出栈顶的元素，直到栈为空或者 $x$ 严格小于栈顶元素。此时我们再将 $x$ 入栈，这样就维护了栈的单调性。

因此，我们可以使用单调栈作为维护 $2$ 的数据结构，并给出下面的算法：

- 我们用单调栈维护所有可以作为 $2$ 的候选元素。初始时，单调栈中只有唯一的元素 $\textit{a}[n-1]$。我们还需要使用一个变量 $\textit{max\_k}$ 记录所有可以真正作为 $2$ 的元素的最大值；

- 随后我们从 $n-2$ 开始从右到左枚举元素 $a[i]$：

    - 首先我们判断 $a[i]$ 是否可以作为 $1$。如果 $a[i] < \textit{max\_k}$，那么它就可以作为 $1$，我们就找到了一组满足 $132$ 模式的三元组；

    - 随后我们判断 $a[i]$ 是否可以作为 $3$，以此找出哪些可以真正作为 $2$ 的元素。我们将 $a[i]$ 不断地与单调栈栈顶的元素进行比较，如果 $a[i]$ 较大，那么栈顶元素可以真正作为 $2$，将其弹出并更新 $\textit{max\_k}$；

    - 最后我们将 $a[i]$ 作为 $2$ 的候选元素放入单调栈中。这里可以进行一个优化，即如果 $a[i] \leq \textit{max\_k}$，那么我们也没有必要将 $a[i]$ 放入栈中，因为即使它在未来被弹出，也不会将 $\textit{max\_k}$ 更新为更大的值。

- 在枚举完所有的元素后，如果仍未找到满足 $132$ 模式的三元组，那就说明其不存在。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    bool find132pattern(vector<int>& nums) {
        int n = nums.size();
        stack<int> candidate_k;
        candidate_k.push(nums[n - 1]);
        int max_k = INT_MIN;

        for (int i = n - 2; i >= 0; --i) {
            if (nums[i] < max_k) {
                return true;
            }
            while (!candidate_k.empty() && nums[i] > candidate_k.top()) {
                max_k = candidate_k.top();
                candidate_k.pop();
            }
            if (nums[i] > max_k) {
                candidate_k.push(nums[i]);
            }
        }

        return false;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean find132pattern(int[] nums) {
        int n = nums.length;
        Deque<Integer> candidateK = new LinkedList<Integer>();
        candidateK.push(nums[n - 1]);
        int maxK = Integer.MIN_VALUE;

        for (int i = n - 2; i >= 0; --i) {
            if (nums[i] < maxK) {
                return true;
            }
            while (!candidateK.isEmpty() && nums[i] > candidateK.peek()) {
                maxK = candidateK.pop();
            }
            if (nums[i] > maxK) {
                candidateK.push(nums[i]);
            }
        }

        return false;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def find132pattern(self, nums: List[int]) -> bool:
        n = len(nums)
        candidate_k = [nums[n - 1]]
        max_k = float("-inf")

        for i in range(n - 2, -1, -1):
            if nums[i] < max_k:
                return True
            while candidate_k and nums[i] > candidate_k[-1]:
                max_k = candidate_k[-1]
                candidate_k.pop()
            if nums[i] > max_k:
                candidate_k.append(nums[i])

        return False
```

```JavaScript [sol2-JavaScript]
var find132pattern = function(nums) {
    const n = nums.length;
    const candidate_k = [nums[n - 1]];
    let max_k = -Number.MAX_SAFE_INTEGER;

    for (let i = n - 2; i >= 0; --i) {
        if (nums[i] < max_k) {
            return true;
        }
        while (candidate_k.length && nums[i] > candidate_k[candidate_k.length - 1]) {
            max_k = candidate_k[candidate_k.length - 1];
            candidate_k.pop();
        }
        if (nums[i] > max_k) {
            candidate_k.push(nums[i]);
        }
    }
    return false;
};
```

```go [sol2-Golang]
func find132pattern(nums []int) bool {
    n := len(nums)
    candidateK := []int{nums[n-1]}
    maxK := math.MinInt64

    for i := n - 2; i >= 0; i-- {
        if nums[i] < maxK {
            return true
        }
        for len(candidateK) > 0 && nums[i] > candidateK[len(candidateK)-1] {
            maxK = candidateK[len(candidateK)-1]
            candidateK = candidateK[:len(candidateK)-1]
        }
        if nums[i] > maxK {
            candidateK = append(candidateK, nums[i])
        }
    }

    return false
}
```

```C [sol2-C]
bool find132pattern(int* nums, int numsSize) {
    int n = numsSize;
    int candidate_k[n], top = 0;
    candidate_k[top++] = nums[n - 1];
    int max_k = INT_MIN;

    for (int i = n - 2; i >= 0; --i) {
        if (nums[i] < max_k) {
            return true;
        }
        while (top && nums[i] > candidate_k[top - 1]) {
            max_k = candidate_k[--top];
        }
        if (nums[i] > max_k) {
            candidate_k[top++] = nums[i];
        }
    }

    return false;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。枚举 $i$ 的次数为 $O(n)$，由于每一个元素最多被加入和弹出单调栈各一次，因此操作单调栈的时间复杂度一共为 $O(n)$，总时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，即为单调栈需要使用的空间。

#### 方法三：枚举 $2$

**说明**

方法三思路难度较大，需要在单调栈上进行二分查找。建议读者在完全理解方法二之后，再尝试阅读该方法。

**思路与算法**

当我们枚举 $2$ 的下标 $k$ 时，与方法二相反，从左到右进行枚举的方法是十分合理的：在枚举的过程中，$i, j$ 的下标范围都是增加的。

由于我们需要保证 $1<2$ 并且 $2<3$，那么我们需要维护一系列尽可能小的元素作为 $1$ 的候选元素，并且维护一系列尽可能大的元素作为 $3$ 的候选元素。

我们可以分情况进行讨论，假设当前有一个小元素 $x_i$ 以及一个大元素 $x_j$ 表示一个二元组，而我们当前遍历到了一个新的元素 $x=a[k]$，那么：

- 如果 $x > x_j$，那么让 $x$ 作为 $3$ 显然是比 $x_j$ 作为 $3$ 更优，因此我们可以用 $x$ 替代 $x_j$；

- 如果 $x < x_i$，那么让 $x$ 作为 $1$ 显然是比 $x_i$ 作为 $3$ 更优，然而我们必须要满足 $132$ 模式中的顺序，即 $1$ 出现在 $3$ 之前，这里如果我们简单地用 $x$ 替代 $x_i$，那么 $x_i=x$ 作为 $1$ 是出现在 $x_j$ 作为 $3$ 之后的，这并不满足要求。因此我们需要为 $x$ 找一个新的元素作为 $3$。由于我们还没有遍历到后面的元素，因此可以简单地将 $x$ 同时看作一个二元组的 $x_i$ 和 $x_j$；

- 对于其它的情况，$x_i \leq x \leq x_j$，$x$ 无论作为 $1$ 还是 $3$ 都没有当前二元组对应的要优，因此我们可以不用考虑 $x$ 作为 $1$ 或者 $3$ 的情况。

这样一来，与方法二类似，我们使用两个单调递减的单调栈维护一系列二元组 $(x_i, x_j)$，表示一个可以选择的 $1-3$ 区间，并且从栈底到栈顶 $x_i$ 和 $x_j$ 分别严格单调递减，因为根据上面的讨论，我们只有在 $x < x_i$ 时才会增加一个新的二元组。

然而与方法二不同的是，如果我们想让 $x$ 作为 $2$，那么我们并不知道到底应该选择单调栈中的哪个 $1-3$ 区间，因此我们只能根据单调性进行二分查找：

- 对于单调栈中的 $x_i$，我们需要找出第一个满足 $x_i < x$ 的位置 $\textit{idx}_i$，这样从该位置到栈顶的所有二元组都满足 $x_i < x$；

- 对于单调栈中的 $x_j$，我们需要找出最后一个满足 $x_j > x$ 的位置 $\textit{idx}_j$，这样从栈底到该位置的所有二元组都满足 $x_j > x$；

- 如果 $\textit{idx}_i$ 和 $\textit{idx}_j$ 都存在，并且 $\textit{idx}_i \leq \textit{idx}_j$，那么就存在至少一个二元组 $(x_i, x_j)$ 满足 $x_i < x < x_j$，$x$ 就可以作为 $2$，我们就找到了一组满足 $132$ 模式的三元组。

在枚举完所有的元素后，如果仍未找到满足 $132$ 模式的三元组，那就说明其不存在。

**代码**

需要注意的是，我们是在**单调递减的栈上进行二分查找**，因此大部分语言都需要实现一个自定义比较函数，或者将栈中的元素取相反数后再使用默认的比较函数。

```C++ [sol3-C++]
class Solution {
public:
    bool find132pattern(vector<int>& nums) {
        int n = nums.size();
        vector<int> candidate_i = {nums[0]};
        vector<int> candidate_j = {nums[0]};

        for (int k = 1; k < n; ++k) {
            auto it_i = upper_bound(candidate_i.begin(), candidate_i.end(), nums[k], greater<int>());
            auto it_j = lower_bound(candidate_j.begin(), candidate_j.end(), nums[k], greater<int>());
            if (it_i != candidate_i.end() && it_j != candidate_j.begin()) {
                int idx_i = it_i - candidate_i.begin();
                int idx_j = it_j - candidate_j.begin() - 1;
                if (idx_i <= idx_j) {
                    return true;
                }
            }
            
            if (nums[k] < candidate_i.back()) {
                candidate_i.push_back(nums[k]);
                candidate_j.push_back(nums[k]);
            }
            else if (nums[k] > candidate_j.back()) {
                int last_i = candidate_i.back();
                while (!candidate_j.empty() && nums[k] > candidate_j.back()) {
                    candidate_i.pop_back();
                    candidate_j.pop_back();
                }
                candidate_i.push_back(last_i);
                candidate_j.push_back(nums[k]);
            }
        }

        return false;
    }
};
```

```Java [sol3-Java]
class Solution {
    public boolean find132pattern(int[] nums) {
        int n = nums.length;
        List<Integer> candidateI = new ArrayList<Integer>();
        candidateI.add(nums[0]);
        List<Integer> candidateJ = new ArrayList<Integer>();
        candidateJ.add(nums[0]);

        for (int k = 1; k < n; ++k) {
            int idxI = binarySearchFirst(candidateI, nums[k]);
            int idxJ = binarySearchLast(candidateJ, nums[k]);
            if (idxI >= 0 && idxJ >= 0) {
                if (idxI <= idxJ) {
                    return true;
                }
            }
            
            if (nums[k] < candidateI.get(candidateI.size() - 1)) {
                candidateI.add(nums[k]);
                candidateJ.add(nums[k]);
            } else if (nums[k] > candidateJ.get(candidateJ.size() - 1)) {
                int lastI = candidateI.get(candidateI.size() - 1);
                while (!candidateJ.isEmpty() && nums[k] > candidateJ.get(candidateJ.size() - 1)) {
                    candidateI.remove(candidateI.size() - 1);
                    candidateJ.remove(candidateJ.size() - 1);
                }
                candidateI.add(lastI);
                candidateJ.add(nums[k]);
            }
        }

        return false;
    }

    public int binarySearchFirst(List<Integer> candidate, int target) {
        int low = 0, high = candidate.size() - 1;
        if (candidate.get(high) >= target) {
            return -1;
        }
        while (low < high) {
            int mid = (high - low) / 2 + low;
            int num = candidate.get(mid);
            if (num >= target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }

    public int binarySearchLast(List<Integer> candidate, int target) {
        int low = 0, high = candidate.size() - 1;
        if (candidate.get(low) <= target) {
            return -1;
        }
        while (low < high) {
            int mid = (high - low + 1) / 2 + low;
            int num = candidate.get(mid);
            if (num <= target) {
                high = mid - 1;
            } else {
                low = mid;
            }
        }
        return low;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def find132pattern(self, nums: List[int]) -> bool:
        candidate_i, candidate_j = [-nums[0]], [-nums[0]]

        for v in nums[1:]:
            idx_i = bisect.bisect_right(candidate_i, -v)
            idx_j = bisect.bisect_left(candidate_j, -v)
            if idx_i < idx_j:
                return True

            if v < -candidate_i[-1]:
                candidate_i.append(-v)
                candidate_j.append(-v)
            elif v > -candidate_j[-1]:
                last_i = -candidate_i[-1]
                while candidate_j and v > -candidate_j[-1]:
                    candidate_i.pop()
                    candidate_j.pop()
                candidate_i.append(-last_i)
                candidate_j.append(-v)

        return False
```

```JavaScript [sol3-JavaScript]
var find132pattern = function(nums) {
    const n = nums.length;
    const candidateI = [nums[0]], candidateJ = [nums[0]];

    for (let k = 1; k < n; ++k) {
        const idxI = binarySearchFirst(candidateI, nums[k]);
        const idxJ = binarySearchLast(candidateJ, nums[k]);
        if (idxI >= 0 && idxJ >= 0) {
            if (idxI <= idxJ) {
                return true;
            }
        }
        
        if (nums[k] < candidateI[candidateI.length - 1]) {
            candidateI.push(nums[k]);
            candidateJ.push(nums[k]);
        } else if (nums[k] > candidateJ[candidateJ.length - 1]) {
            const lastI = candidateI[candidateI.length - 1];
            while (candidateJ.length && nums[k] > candidateJ[candidateJ.length - 1]) {
                candidateI.pop();
                candidateJ.pop();
            }
            candidateI.push(lastI);
            candidateJ.push(nums[k]);
        }
    }

    return false;
};

const binarySearchFirst = (candidate, target) => {
    let low = 0, high = candidate.length - 1;
    if (candidate[high] >= target) {
        return -1;
    }
    while (low < high) {
        const mid = Math.floor((high - low) / 2) + low;
        const num = candidate[mid];
        if (num >= target) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
}

const binarySearchLast = (candidate, target) => {
    let low = 0, high = candidate.length - 1;
    if (candidate[low] <= target) {
        return -1;
    }
    while (low < high) {
        const mid = Math.floor((high - low + 1) / 2) + low;
        const num = candidate[mid];
        if (num <= target) {
            high = mid - 1;
        } else {
            low = mid;
        }
    }
    return low;
}
```

```go [sol3-Golang]
func find132pattern(nums []int) bool {
    candidateI, candidateJ := []int{-nums[0]}, []int{-nums[0]}

    for _, v := range nums[1:] {
        idxI := sort.SearchInts(candidateI, 1-v)
        idxJ := sort.SearchInts(candidateJ, -v)
        if idxI < idxJ {
            return true
        }

        if v < -candidateI[len(candidateI)-1] {
            candidateI = append(candidateI, -v)
            candidateJ = append(candidateJ, -v)
        } else if v > -candidateJ[len(candidateJ)-1] {
            lastI := -candidateI[len(candidateI)-1]
            for len(candidateJ) > 0 && v > -candidateJ[len(candidateJ)-1] {
                candidateI = candidateI[:len(candidateI)-1]
                candidateJ = candidateJ[:len(candidateJ)-1]
            }
            candidateI = append(candidateI, -lastI)
            candidateJ = append(candidateJ, -v)
        }
    }

    return false
}
```

```C [sol3-C]
int upper_bound(int* vec, int vecSize, int target) {
    int low = 0, high = vecSize - 1;
    if (vec[high] >= target) {
        return -1;
    }
    while (low < high) {
        int mid = (high - low) / 2 + low;
        int num = vec[mid];
        if (num >= target) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
}

int lower_bound(int* vec, int vecSize, int target) {
    int low = 0, high = vecSize - 1;
    if (vec[low] <= target) {
        return -1;
    }
    while (low < high) {
        int mid = (high - low + 1) / 2 + low;
        int num = vec[mid];
        if (num <= target) {
            high = mid - 1;
        } else {
            low = mid;
        }
    }
    return low;
}

bool find132pattern(int* nums, int numsSize) {
    int n = numsSize;
    int candidate_i[n], top_i = 0;
    int candidate_j[n], top_j = 0;
    candidate_i[top_i++] = nums[0];
    candidate_j[top_j++] = nums[0];

    for (int k = 1; k < n; ++k) {
        int it_i = upper_bound(candidate_i, top_i, nums[k]);
        int it_j = lower_bound(candidate_j, top_j, nums[k]);
        if (it_i != -1 && it_j != -1) {
            if (it_i <= it_j) {
                return true;
            }
        }

        if (nums[k] < candidate_i[top_i - 1]) {
            candidate_i[top_i++] = nums[k];
            candidate_j[top_j++] = nums[k];
        } else if (nums[k] > candidate_j[top_j - 1]) {
            int last_i = candidate_i[top_i - 1];
            while (top_j && nums[k] > candidate_j[top_j - 1]) {
                top_j--, top_i--;
            }
            candidate_i[top_i++] = last_i;
            candidate_j[top_j++] = nums[k];
        }
    }

    return false;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$。枚举 $i$ 的次数为 $O(n)$，由于每一个元素最多被加入和弹出单调栈各一次，因此操作单调栈的时间复杂度一共为 $O(n)$。二分查找的单次时间为 $O(\log n)$，一共为 $O(n \log n)$，总时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$，即为单调栈需要使用的空间。


#### 结语

在上面的三种方法中，方法二的时间复杂度为 $O(n)$，最优秀。而剩余的两种时间复杂度为 $O(n \log n)$ 的方法中，方法一相较于方法三，无论从理解还是代码编写层面来说都更容易一些。那么为什么还要介绍方法三呢？这里我们可以发现方法一和方法二的不足：

- 方法一需要提前知道整个数组，否则就无法使用有序集合维护右侧元素了；

- 方法二是从后向前遍历的，本质上也同样需要提前知道整个数组。

而方法三是从前向后遍历的，并且维护的数据结构不依赖于后续未知的元素，因此如果数组是以「数据流」的形式给出的，那么方法三是唯一可以继续使用的方法。