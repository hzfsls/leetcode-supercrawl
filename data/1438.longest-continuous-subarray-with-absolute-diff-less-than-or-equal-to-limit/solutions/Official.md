## [1438.绝对差不超过限制的最长连续子数组 中文官方题解](https://leetcode.cn/problems/longest-continuous-subarray-with-absolute-diff-less-than-or-equal-to-limit/solutions/100000/jue-dui-chai-bu-chao-guo-xian-zhi-de-zui-5bki)

#### 方法一：滑动窗口 + 有序集合

**思路和解法**

我们可以枚举每一个位置作为右端点，找到其对应的最靠左的左端点，满足区间中最大值与最小值的差不超过 $\textit{limit}$。

注意到随着右端点向右移动，左端点也将向右移动，于是我们可以使用滑动窗口解决本题。

为了方便统计当前窗口内的最大值与最小值，我们可以使用平衡树：

- 语言自带的红黑树，例如 $\texttt{C++}$ 中的 $\texttt{std::multiset}$，$\texttt{Java}$ 中的 $\texttt{TreeMap}$；

- 第三方的平衡树库，例如 $\texttt{Python}$ 中的 $\texttt{sortedcontainers}$（事实上，这个库的底层实现并不是平衡树，但各种操作的时间复杂度仍然很优秀）；

- 手写 $\texttt{Treap}$ 一类的平衡树，例如下面的 $\texttt{Golang}$ 代码。

来维护窗口内元素构成的有序集合。

**代码**

对于 $\texttt{Python}$ 语言，力扣平台支持 $\texttt{sortedcontainers}$，但其没有默认被导入（import）。读者可以参考 [Python Sorted Containers](http://www.grantjenks.com/docs/sortedcontainers/index.html) 了解该第三方库的使用方法。

```C++ [sol1-C++]
class Solution {
public:
    int longestSubarray(vector<int>& nums, int limit) {
        multiset<int> s;
        int n = nums.size();
        int left = 0, right = 0;
        int ret = 0;
        while (right < n) {
            s.insert(nums[right]);
            while (*s.rbegin() - *s.begin() > limit) {
                s.erase(s.find(nums[left++]));
            }
            ret = max(ret, right - left + 1);
            right++;
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int longestSubarray(int[] nums, int limit) {
        TreeMap<Integer, Integer> map = new TreeMap<Integer, Integer>();
        int n = nums.length;
        int left = 0, right = 0;
        int ret = 0;
        while (right < n) {
            map.put(nums[right], map.getOrDefault(nums[right], 0) + 1);
            while (map.lastKey() - map.firstKey() > limit) {
                map.put(nums[left], map.get(nums[left]) - 1);
                if (map.get(nums[left]) == 0) {
                    map.remove(nums[left]);
                }
                left++;
            }
            ret = Math.max(ret, right - left + 1);
            right++;
        }
        return ret;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def longestSubarray(self, nums: List[int], limit: int) -> int:
        s = SortedList()
        n = len(nums)
        left = right = ret = 0

        while right < n:
            s.add(nums[right])
            while s[-1] - s[0] > limit:
                s.remove(nums[left])
                left += 1
            ret = max(ret, right - left + 1)
            right += 1
        
        return ret
```

```go [sol1-Golang]
import "math/rand"

type node struct {
    ch       [2]*node
    priority int
    key      int
    cnt      int
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

func (o *node) rotate(d int) *node {
    x := o.ch[d^1]
    o.ch[d^1] = x.ch[d]
    x.ch[d] = o
    return x
}

type treap struct {
    root *node
}

func (t *treap) ins(o *node, key int) *node {
    if o == nil {
        return &node{priority: rand.Int(), key: key, cnt: 1}
    }
    if d := o.cmp(key); d >= 0 {
        o.ch[d] = t.ins(o.ch[d], key)
        if o.ch[d].priority > o.priority {
            o = o.rotate(d ^ 1)
        }
    } else {
        o.cnt++
    }
    return o
}

func (t *treap) del(o *node, key int) *node {
    if o == nil {
        return nil
    }
    if d := o.cmp(key); d >= 0 {
        o.ch[d] = t.del(o.ch[d], key)
    } else {
        if o.cnt > 1 {
            o.cnt--
        } else {
            if o.ch[1] == nil {
                return o.ch[0]
            }
            if o.ch[0] == nil {
                return o.ch[1]
            }
            d = 0
            if o.ch[0].priority > o.ch[1].priority {
                d = 1
            }
            o = o.rotate(d)
            o.ch[d] = t.del(o.ch[d], key)
        }
    }
    return o
}

func (t *treap) insert(key int) {
    t.root = t.ins(t.root, key)
}

func (t *treap) delete(key int) {
    t.root = t.del(t.root, key)
}

func (t *treap) min() (min *node) {
    for o := t.root; o != nil; o = o.ch[0] {
        min = o
    }
    return
}

func (t *treap) max() (max *node) {
    for o := t.root; o != nil; o = o.ch[1] {
        max = o
    }
    return
}

func longestSubarray(nums []int, limit int) (ans int) {
    t := &treap{}
    left := 0
    for right, v := range nums {
        t.insert(v)
        for t.max().key-t.min().key > limit {
            t.delete(nums[left])
            left++
        }
        ans = max(ans, right-left+1)
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组长度。向有序集合中添加或删除元素都是 $O(\log n)$ 的时间复杂度。每个元素最多被添加与删除一次。

- 空间复杂度：$O(n)$，其中 $n$ 是数组长度。最坏情况下有序集合将和原数组等大。

#### 方法二：滑动窗口 + 单调队列

**思路和解法**

在方法一中，我们仅需要统计当前窗口内的最大值与最小值，因此我们也可以分别使用两个单调队列解决本题。

在实际代码中，我们使用一个单调递增的队列 $\textit{queMin}$ 维护最小值，一个单调递减的队列 $\textit{queMax}$ 维护最大值。这样我们只需要计算两个队列的队首的差值，即可知道当前窗口是否满足条件。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int longestSubarray(vector<int>& nums, int limit) {
        deque<int> queMax, queMin;
        int n = nums.size();
        int left = 0, right = 0;
        int ret = 0;
        while (right < n) {
            while (!queMax.empty() && queMax.back() < nums[right]) {
                queMax.pop_back();
            }
            while (!queMin.empty() && queMin.back() > nums[right]) {
                queMin.pop_back();
            }
            queMax.push_back(nums[right]);
            queMin.push_back(nums[right]);
            while (!queMax.empty() && !queMin.empty() && queMax.front() - queMin.front() > limit) {
                if (nums[left] == queMin.front()) {
                    queMin.pop_front();
                }
                if (nums[left] == queMax.front()) {
                    queMax.pop_front();
                }
                left++;
            }
            ret = max(ret, right - left + 1);
            right++;
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int longestSubarray(int[] nums, int limit) {
        Deque<Integer> queMax = new LinkedList<Integer>();
        Deque<Integer> queMin = new LinkedList<Integer>();
        int n = nums.length;
        int left = 0, right = 0;
        int ret = 0;
        while (right < n) {
            while (!queMax.isEmpty() && queMax.peekLast() < nums[right]) {
                queMax.pollLast();
            }
            while (!queMin.isEmpty() && queMin.peekLast() > nums[right]) {
                queMin.pollLast();
            }
            queMax.offerLast(nums[right]);
            queMin.offerLast(nums[right]);
            while (!queMax.isEmpty() && !queMin.isEmpty() && queMax.peekFirst() - queMin.peekFirst() > limit) {
                if (nums[left] == queMin.peekFirst()) {
                    queMin.pollFirst();
                }
                if (nums[left] == queMax.peekFirst()) {
                    queMax.pollFirst();
                }
                left++;
            }
            ret = Math.max(ret, right - left + 1);
            right++;
        }
        return ret;
    }
}
```

```JavaScript [sol2-JavaScript]
var longestSubarray = function(nums, limit) {
    const queMax = [];
    const queMin = [];
    const n = nums.length;
    let left = 0, right = 0;
    let ret = 0;
    while (right < n) {
        while (queMax.length && queMax[queMax.length - 1] < nums[right]) {
            queMax.pop();
        }
        while (queMin.length && queMin[queMin.length - 1] > nums[right]) {
            queMin.pop();
        }
        queMax.push(nums[right]);
        queMin.push(nums[right]);
        while (queMax.length && queMin.length && queMax[0] - queMin[0] > limit) {
            if (nums[left] === queMin[0]) {
                queMin.shift();
            }
            if (nums[left] === queMax[0]) {
                queMax.shift();
            }
            left++;
        }
        ret = Math.max(ret, right - left + 1);
        right++;
    }
    return ret;
};
```

```Python [sol2-Python3]
class Solution:
    def longestSubarray(self, nums: List[int], limit: int) -> int:
        n = len(nums)
        queMax, queMin = deque(), deque()
        left = right = ret = 0

        while right < n:
            while queMax and queMax[-1] < nums[right]:
                queMax.pop()
            while queMin and queMin[-1] > nums[right]:
                queMin.pop()
            
            queMax.append(nums[right])
            queMin.append(nums[right])

            while queMax and queMin and queMax[0] - queMin[0] > limit:
                if nums[left] == queMin[0]:
                    queMin.popleft()
                if nums[left] == queMax[0]:
                    queMax.popleft()
                left += 1
            
            ret = max(ret, right - left + 1)
            right += 1
        
        return ret
```

```go [sol2-Golang]
func longestSubarray(nums []int, limit int) (ans int) {
    var minQ, maxQ []int
    left := 0
    for right, v := range nums {
        for len(minQ) > 0 && minQ[len(minQ)-1] > v {
            minQ = minQ[:len(minQ)-1]
        }
        minQ = append(minQ, v)
        for len(maxQ) > 0 && maxQ[len(maxQ)-1] < v {
            maxQ = maxQ[:len(maxQ)-1]
        }
        maxQ = append(maxQ, v)
        for len(minQ) > 0 && len(maxQ) > 0 && maxQ[0]-minQ[0] > limit {
            if nums[left] == minQ[0] {
                minQ = minQ[1:]
            }
            if nums[left] == maxQ[0] {
                maxQ = maxQ[1:]
            }
            left++
        }
        ans = max(ans, right-left+1)
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol2-C]
int longestSubarray(int* nums, int numsSize, int limit) {
    int queMax[numsSize], queMin[numsSize];
    int leftMax = 0, rightMax = 0;
    int leftMin = 0, rightMin = 0;
    int left = 0, right = 0;
    int ret = 0;
    while (right < numsSize) {
        while (leftMax < rightMax && queMax[rightMax - 1] < nums[right]) {
            rightMax--;
        }
        while (leftMin < rightMin && queMin[rightMin - 1] > nums[right]) {
            rightMin--;
        }
        queMax[rightMax++] = nums[right];
        queMin[rightMin++] = nums[right];
        while (leftMax < rightMax && leftMin < rightMin && queMax[leftMax] - queMin[leftMin] > limit) {
            if (nums[left] == queMin[leftMin]) {
                leftMin++;
            }
            if (nums[left] == queMax[leftMax]) {
                leftMax++;
            }
            left++;
        }
        ret = fmax(ret, right - left + 1);
        right++;
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组长度。我们最多遍历该数组两次，两个单调队列入队出队次数也均为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组长度。最坏情况下单调队列将和原数组等大。