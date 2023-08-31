## [295.数据流的中位数 中文官方题解](https://leetcode.cn/problems/find-median-from-data-stream/solutions/100000/shu-ju-liu-de-zhong-wei-shu-by-leetcode-ktkst)
#### 方法一：优先队列

**思路和算法**

我们用两个优先队列 $\textit{queMax}$ 和 $\textit{queMin}$ 分别记录大于中位数的数和小于等于中位数的数。当累计添加的数的数量为奇数时，$\textit{queMin}$ 中的数的数量比 $\textit{queMax}$ 多一个，此时中位数为 $\textit{queMin}$ 的队头。当累计添加的数的数量为偶数时，两个优先队列中的数的数量相同，此时中位数为它们的队头的平均值。

当我们尝试添加一个数 $\textit{num}$ 到数据结构中，我们需要分情况讨论：

1. $\textit{num} \leq \max \{\textit{queMin}\}$

    此时 $\textit{num}$ 小于等于中位数，我们需要将该数添加到 $\textit{queMin}$ 中。新的中位数将小于等于原来的中位数，因此我们可能需要将 $\textit{queMin}$ 中最大的数移动到 $\textit{queMax}$ 中。

2. $\textit{num} > \max \{\textit{queMin}\}$

    此时 $\textit{num}$ 大于中位数，我们需要将该数添加到 $\textit{queMin}$ 中。新的中位数将大于等于原来的中位数，因此我们可能需要将 $\textit{queMax}$ 中最小的数移动到 $\textit{queMin}$ 中。

特别地，当累计添加的数的数量为 $0$ 时，我们将 $\textit{num}$ 添加到 $\textit{queMin}$ 中。

**代码**

```C++ [sol1-C++]
class MedianFinder {
public:
    priority_queue<int, vector<int>, less<int>> queMin;
    priority_queue<int, vector<int>, greater<int>> queMax;

    MedianFinder() {}

    void addNum(int num) {
        if (queMin.empty() || num <= queMin.top()) {
            queMin.push(num);
            if (queMax.size() + 1 < queMin.size()) {
                queMax.push(queMin.top());
                queMin.pop();
            }
        } else {
            queMax.push(num);
            if (queMax.size() > queMin.size()) {
                queMin.push(queMax.top());
                queMax.pop();
            }
        }
    }

    double findMedian() {
        if (queMin.size() > queMax.size()) {
            return queMin.top();
        }
        return (queMin.top() + queMax.top()) / 2.0;
    }
};
```

```Java [sol1-Java]
class MedianFinder {
    PriorityQueue<Integer> queMin;
    PriorityQueue<Integer> queMax;

    public MedianFinder() {
        queMin = new PriorityQueue<Integer>((a, b) -> (b - a));
        queMax = new PriorityQueue<Integer>((a, b) -> (a - b));
    }
    
    public void addNum(int num) {
        if (queMin.isEmpty() || num <= queMin.peek()) {
            queMin.offer(num);
            if (queMax.size() + 1 < queMin.size()) {
                queMax.offer(queMin.poll());
            }
        } else {
            queMax.offer(num);
            if (queMax.size() > queMin.size()) {
                queMin.offer(queMax.poll());
            }
        }
    }
    
    public double findMedian() {
        if (queMin.size() > queMax.size()) {
            return queMin.peek();
        }
        return (queMin.peek() + queMax.peek()) / 2.0;
    }
}
```

```C# [sol1-C#]
public class MedianFinder {
    PriorityQueue<int, int> queMin;
    PriorityQueue<int, int> queMax;

    public MedianFinder() {
        queMin = new PriorityQueue<int, int>();
        queMax = new PriorityQueue<int, int>();
    }
    
    public void AddNum(int num) {
        if (queMin.Count == 0 || num <= queMin.Peek()) {
            queMin.Enqueue(num, -num);
            if (queMax.Count + 1 < queMin.Count) {
                int tmp = queMin.Dequeue();
                queMax.Enqueue(tmp, tmp);
            }
        } else {
            queMax.Enqueue(num, num);
            if (queMax.Count > queMin.Count) {
                int tmp = queMax.Dequeue();
                queMin.Enqueue(tmp, -tmp);
            }
        }
    }
    
    public double FindMedian() {
        if (queMin.Count > queMax.Count) {
            return queMin.Peek();
        }
        return (queMin.Peek() + queMax.Peek()) / 2.0;
    }
}
```

```Python [sol1-Python3]
class MedianFinder:

    def __init__(self):
        self.queMin = list()
        self.queMax = list()

    def addNum(self, num: int) -> None:
        queMin_ = self.queMin
        queMax_ = self.queMax

        if not queMin_ or num <= -queMin_[0]:
            heapq.heappush(queMin_, -num)
            if len(queMax_) + 1 < len(queMin_):
                heapq.heappush(queMax_, -heapq.heappop(queMin_))
        else:
            heapq.heappush(queMax_, num)
            if len(queMax_) > len(queMin_):
                heapq.heappush(queMin_, -heapq.heappop(queMax_))
        
    def findMedian(self) -> float:
        queMin_ = self.queMin
        queMax_ = self.queMax

        if len(queMin_) > len(queMax_):
            return -queMin_[0]
        return (-queMin_[0] + queMax_[0]) / 2
```

```go [sol1-Golang]
type MedianFinder struct {
    queMin, queMax hp
}

func Constructor() MedianFinder {
    return MedianFinder{}
}

func (mf *MedianFinder) AddNum(num int) {
    minQ, maxQ := &mf.queMin, &mf.queMax
    if minQ.Len() == 0 || num <= -minQ.IntSlice[0] {
        heap.Push(minQ, -num)
        if maxQ.Len()+1 < minQ.Len() {
            heap.Push(maxQ, -heap.Pop(minQ).(int))
        }
    } else {
        heap.Push(maxQ, num)
        if maxQ.Len() > minQ.Len() {
            heap.Push(minQ, -heap.Pop(maxQ).(int))
        }
    }
}

func (mf *MedianFinder) FindMedian() float64 {
    minQ, maxQ := mf.queMin, mf.queMax
    if minQ.Len() > maxQ.Len() {
        return float64(-minQ.IntSlice[0])
    }
    return float64(maxQ.IntSlice[0]-minQ.IntSlice[0]) / 2
}

type hp struct{ sort.IntSlice }
func (h *hp) Push(v interface{}) { h.IntSlice = append(h.IntSlice, v.(int)) }
func (h *hp) Pop() interface{}   { a := h.IntSlice; v := a[len(a)-1]; h.IntSlice = a[:len(a)-1]; return v }
```

**复杂度分析**

- 时间复杂度：
  - $\textit{addNum}$: $O(\log n)$，其中 $n$ 为累计添加的数的数量。
  - $\textit{findMedian}$: $O(1)$。

- 空间复杂度：$O(n)$，主要为优先队列的开销。

#### 方法二：有序集合 + 双指针

**思路和算法**

我们也可以使用有序集合维护这些数。我们把有序集合看作自动排序的数组，使用双指针指向有序集合中的中位数元素即可。当累计添加的数的数量为奇数时，双指针指向同一个元素。当累计添加的数的数量为偶数时，双指针分别指向构成中位数的两个数。

当我们尝试添加一个数 $\textit{num}$ 到数据结构中，我们需要分情况讨论：

1. 初始有序集合为空时，我们直接让左右指针指向 $\textit{num}$ 所在的位置。

2. 有序集合为中元素为奇数时，$\textit{left}$ 和 $\textit{right}$ 同时指向中位数。如果 $\textit{num}$ 大于等于中位数，那么只要让 $\textit{left}$ 左移，否则让 $\textit{right}$ 右移即可。

3. 有序集合为中元素为偶数时，$\textit{left}$ 和 $\textit{right}$ 分别指向构成中位数的两个数。
   - 当 $\textit{num}$ 成为新的唯一的中位数，那么我们让 $\textit{left}$ 右移，$\textit{right}$ 左移，这样它们即可指向 $\textit{num}$ 所在的位置；
   - 当 $\textit{num}$ 大于等于 $\textit{right}$，那么我们让 $\textit{left}$ 右移即可；
   - 当 $\textit{num}$ 小于 $\textit{right}$ 指向的值，那么我们让 $\textit{right}$ 左移，注意到如果 $\textit{num}$ 恰等于 $\textit{left}$ 指向的值，那么 $\textit{num}$ 将被插入到 $\textit{left}$ 右侧，使得 $\textit{left}$ 和 $\textit{right}$ 间距增大，所以我们还需要额外让 $\textit{left}$ 指向移动后的 $\textit{right}$。

**代码**

```C++ [sol2-C++]
class MedianFinder {
    multiset<int> nums;
    multiset<int>::iterator left, right;

public:
    MedianFinder() : left(nums.end()), right(nums.end()) {}

    void addNum(int num) {
        const size_t n = nums.size();

        nums.insert(num);
        if (!n) {
            left = right = nums.begin();
        } else if (n & 1) {
            if (num < *left) {
                left--;
            } else {
                right++;
            }
        } else {
            if (num > *left && num < *right) {
                left++;
                right--;
            } else if (num >= *right) {
                left++;
            } else {
                right--;
                left = right;
            }
        }
    }

    double findMedian() {
        return (*left + *right) / 2.0;
    }
};
```

```Java [sol2-Java]
class MedianFinder {
    TreeMap<Integer, Integer> nums;
    int n;
    int[] left;
    int[] right;

    public MedianFinder() {
        nums = new TreeMap<Integer, Integer>();
        n = 0;
        left = new int[2];
        right = new int[2];
    }
    
    public void addNum(int num) {
        nums.put(num, nums.getOrDefault(num, 0) + 1);
        if (n == 0) {
            left[0] = right[0] = num;
            left[1] = right[1] = 1;
        } else if ((n & 1) != 0) {
            if (num < left[0]) {
                decrease(left);
            } else {
                increase(right);
            }
        } else {
            if (num > left[0] && num < right[0]) {
                increase(left);
                decrease(right);
            } else if (num >= right[0]) {
                increase(left);
            } else {
                decrease(right);
                System.arraycopy(right, 0, left, 0, 2);
            }
        }
        n++;
    }

    public double findMedian() {
        return (left[0] + right[0]) / 2.0;
    }

    private void increase(int[] iterator) {
        iterator[1]++;
        if (iterator[1] > nums.get(iterator[0])) {
            iterator[0] = nums.ceilingKey(iterator[0] + 1);
            iterator[1] = 1;
        }
    }

    private void decrease(int[] iterator) {
        iterator[1]--;
        if (iterator[1] == 0) {
            iterator[0] = nums.floorKey(iterator[0] - 1);
            iterator[1] = nums.get(iterator[0]);
        }
    }
}
```

```Python [sol2-Python3]
from sortedcontainers import SortedList

class MedianFinder:

    def __init__(self):
        self.nums = SortedList()
        self.left = self.right = None
        self.left_value = self.right_value = None

    def addNum(self, num: int) -> None:
        nums_ = self.nums

        n = len(nums_)
        nums_.add(num)

        if n == 0:
            self.left = self.right = 0
        else:
            # 模拟双指针，当 num 小于 self.left 或 self.right 指向的元素时，num 的加入会导致对应指针向右移动一个位置
            if num < self.left_value:
                self.left += 1
            if num < self.right_value:
                self.right += 1

            if n & 1:
                if num < self.left_value:
                    self.left -= 1
                else:
                    self.right += 1
            else:
                if self.left_value < num < self.right_value:
                    self.left += 1
                    self.right -= 1
                elif num >= self.right_value:
                    self.left += 1
                else:
                    self.right -= 1
                    self.left = self.right
        
        self.left_value = nums_[self.left]
        self.right_value = nums_[self.right]

    def findMedian(self) -> float:
        return (self.left_value + self.right_value) / 2
```

```go [sol2-Golang]
type MedianFinder struct {
    nums        *redblacktree.Tree
    total       int
    left, right iterator
}

func Constructor() MedianFinder {
    return MedianFinder{nums: redblacktree.NewWithIntComparator()}
}

func (mf *MedianFinder) AddNum(num int) {
    if count, has := mf.nums.Get(num); has {
        mf.nums.Put(num, count.(int)+1)
    } else {
        mf.nums.Put(num, 1)
    }
    if mf.total == 0 {
        it := mf.nums.Iterator()
        it.Next()
        mf.left = iterator{it, 1}
        mf.right = mf.left
    } else if mf.total%2 == 1 {
        if num < mf.left.Key().(int) {
            mf.left.prev()
        } else {
            mf.right.next()
        }
    } else {
        if mf.left.Key().(int) < num && num < mf.right.Key().(int) {
            mf.left.next()
            mf.right.prev()
        } else if num >= mf.right.Key().(int) {
            mf.left.next()
        } else {
            mf.right.prev()
            mf.left = mf.right
        }
    }
    mf.total++
}

func (mf *MedianFinder) FindMedian() float64 {
    return float64(mf.left.Key().(int)+mf.right.Key().(int)) / 2
}

type iterator struct {
    redblacktree.Iterator
    count int
}

func (it *iterator) prev() {
    if it.count > 1 {
        it.count--
    } else {
        it.Prev()
        it.count = it.Value().(int)
    }
}

func (it *iterator) next() {
    if it.count < it.Value().(int) {
        it.count++
    } else {
        it.Next()
        it.count = 1
    }
}
```

**复杂度分析**

- 时间复杂度：
  - $\textit{addNum}$: $O(\log n)$，其中 $n$ 为累计添加的数的数量。
  - $\textit{findMedian}$: $O(1)$。

- 空间复杂度：$O(n)$，主要为有序集合的开销。

#### 进阶 $1$

如果数据流中所有整数都在 $0$ 到 $100$ 范围内，那么我们可以利用计数排序统计每一类数的数量，并使用双指针维护中位数。

#### 进阶 $2$

如果数据流中 $99\%$ 的整数都在 $0$ 到 $100$ 范围内，那么我们依然利用计数排序统计每一类数的数量，并使用双指针维护中位数。对于超出范围的数，我们可以单独进行处理，建立两个数组，分别记录小于 $0$ 的部分的数的数量和大于 $100$ 的部分的数的数量即可。当小部分时间，中位数不落在区间 $[0,100]$ 中时，我们在对应的数组中暴力检查即可。