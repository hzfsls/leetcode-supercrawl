## [215.数组中的第K个最大元素 中文官方题解](https://leetcode.cn/problems/kth-largest-element-in-an-array/solutions/100000/shu-zu-zhong-de-di-kge-zui-da-yuan-su-by-leetcode-)

### 📺 视频题解  
![215. 数组中的第K个最大元素.mp4](9c5f6d66-f7ed-4d98-a8f4-5629eb8ed376)

### 📖 文字题解

#### 前言

+ 约定：假设这里数组的长度为 $n$。

+ 题目分析：本题希望我们返回数组排序之后的倒数第 $k$ 个位置。

#### 方法一：基于快速排序的选择方法

**思路和算法**

我们可以用快速排序来解决这个问题，先对原数组排序，再返回倒数第 $k$ 个位置，这样平均时间复杂度是 $O(n \log n)$，但其实我们可以做的更快。

首先我们来回顾一下快速排序，这是一个典型的分治算法。我们对数组 $a[l \cdots r]$ 做快速排序的过程是（参考《算法导论》）：

+ **分解：** 将数组 $a[l \cdots r]$ 「划分」成两个子数组 $a[l \cdots q - 1]$、$a[q + 1 \cdots r]$，使得 $a[l \cdots q - 1]$ 中的每个元素小于等于 $a[q]$，且 $a[q]$ 小于等于 $a[q + 1 \cdots r]$ 中的每个元素。其中，计算下标 $q$ 也是「划分」过程的一部分。
+ **解决：** 通过递归调用快速排序，对子数组 $a[l \cdots q - 1]$ 和 $a[q + 1 \cdots r]$ 进行排序。
+ **合并：** 因为子数组都是原址排序的，所以不需要进行合并操作，$a[l \cdots r]$ 已经有序。
+ 上文中提到的 **「划分」** 过程是：从子数组 $a[l \cdots r]$ 中选择任意一个元素 $x$ 作为主元，**调整子数组的元素使得左边的元素都小于等于它，右边的元素都大于等于它，** $x$ 的最终位置就是 $q$。

由此可以发现每次经过「划分」操作后，我们一定可以确定一个元素的最终位置，即 $x$ 的最终位置为 $q$，并且保证 $a[l \cdots q - 1]$ 中的每个元素小于等于 $a[q]$，且 $a[q]$ 小于等于 $a[q + 1 \cdots r]$ 中的每个元素。**所以只要某次划分的 $q$ 为倒数第 $k$ 个下标的时候，我们就已经找到了答案。** 我们只关心这一点，至于 $a[l \cdots q - 1]$ 和 $a[q+1 \cdots r]$ 是否是有序的，我们不关心。

因此我们可以改进快速排序算法来解决这个问题：在分解的过程当中，我们会对子数组进行划分，如果划分得到的 $q$ 正好就是我们需要的下标，就直接返回 $a[q]$；否则，如果 $q$ 比目标下标小，就递归右子区间，否则递归左子区间。这样就可以把原来递归两个区间变成只递归一个区间，提高了时间效率。这就是「快速选择」算法。

我们知道快速排序的性能和「划分」出的子数组的长度密切相关。直观地理解如果每次规模为 $n$ 的问题我们都划分成 $1$ 和 $n - 1$，每次递归的时候又向 $n - 1$ 的集合中递归，这种情况是最坏的，时间代价是 $O(n ^ 2)$。我们可以引入随机化来加速这个过程，它的时间代价的期望是 $O(n)$，证明过程可以参考「《算法导论》9.2：期望为线性的选择算法」。需要注意的是，这个时间复杂度只有在 **随机数据** 下才成立，而对于精心构造的数据则可能表现不佳。因此我们这里并没有真正地使用随机数，而是使用双指针的方法，这种方法能够较好地应对各种数据。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    int quickselect(vector<int> &nums, int l, int r, int k) {
        if (l == r)
            return nums[k];
        int partition = nums[l], i = l - 1, j = r + 1;
        while (i < j) {
            do i++; while (nums[i] < partition);
            do j--; while (nums[j] > partition);
            if (i < j)
                swap(nums[i], nums[j]);
        }
        if (k <= j)return quickselect(nums, l, j, k);
        else return quickselect(nums, j + 1, r, k);
    }

    int findKthLargest(vector<int> &nums, int k) {
        int n = nums.size();
        return quickselect(nums, 0, n - 1, n - k);
    }
};
```

```Java [sol1-Java]
class Solution {
    int quickselect(int[] nums, int l, int r, int k) {
        if (l == r) return nums[k];
        int x = nums[l], i = l - 1, j = r + 1;
        while (i < j) {
            do i++; while (nums[i] < x);
            do j--; while (nums[j] > x);
            if (i < j){
                int tmp = nums[i];
                nums[i] = nums[j];
                nums[j] = tmp;
            }
        }
        if (k <= j) return quickselect(nums, l, j, k);
        else return quickselect(nums, j + 1, r, k);
    }
    public int findKthLargest(int[] _nums, int k) {
        int n = _nums.length;
        return quickselect(_nums, 0, n - 1, n - k);
    }
}
```

```C [sol1-C]
int quickselect(int *nums, int l, int r, int k) {
    if (l == r)
        return nums[k];
    int partition = nums[l], i = l - 1, j = r + 1;
    while (i < j) {
        do i++; while (nums[i] < partition);
        do j--; while (nums[j] > partition);
        if (i < j) {
            int tmp = nums[i];
            nums[i] = nums[j];
            nums[j] = tmp;
        }
    }
    if (k <= j)return quickselect(nums, l, j, k);
    else return quickselect(nums, j + 1, r, k);
}

int findKthLargest(int *nums, int numsSize, int k) {
    return quickselect(nums, 0, numsSize - 1, numsSize - k);
}
```

```golang [sol1-Golang]
func findKthLargest(nums []int, k int) int {
    n := len(nums)
    return quickselect(nums, 0, n - 1, n - k)
}

func quickselect(nums []int, l, r, k int) int{
    if (l == r){
        return nums[k]
    }
    partition := nums[l]
    i := l - 1
    j := r + 1
    for (i < j) {
        for i++;nums[i]<partition;i++{}
        for j--;nums[j]>partition;j--{}
        if (i < j) {
            nums[i],nums[j]=nums[j],nums[i]
        }
    }
    if (k <= j){
        return quickselect(nums, l, j, k)
    }else{
        return quickselect(nums, j + 1, r, k)
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，如上文所述，证明过程可以参考「《算法导论》9.2：期望为线性的选择算法」。
- 空间复杂度：$O(\log n)$，递归使用栈空间的空间代价的期望为 $O(\log n)$。

#### 方法二：基于堆排序的选择方法

**思路和算法**

我们也可以使用堆排序来解决这个问题——建立一个大根堆，做 $k - 1$ 次删除操作后堆顶元素就是我们要找的答案。在很多语言中，都有优先队列或者堆的的容器可以直接使用，但是在面试中，面试官更倾向于让更面试者自己实现一个堆。所以建议读者掌握这里大根堆的实现方法，在这道题中尤其要搞懂「建堆」、「调整」和「删除」的过程。

**友情提醒：「堆排」在很多大公司的面试中都很常见，不了解的同学建议参考《算法导论》或者大家的数据结构教材，一定要学会这个知识点哦！^_^**

<![fig1](https://assets.leetcode-cn.com/solution-static/215/1.png),![fig2](https://assets.leetcode-cn.com/solution-static/215/2.png),![fig3](https://assets.leetcode-cn.com/solution-static/215/3.png),![fig4](https://assets.leetcode-cn.com/solution-static/215/4.png),![fig5](https://assets.leetcode-cn.com/solution-static/215/5.png),![fig6](https://assets.leetcode-cn.com/solution-static/215/6.png),![fig7](https://assets.leetcode-cn.com/solution-static/215/7.png),![fig8](https://assets.leetcode-cn.com/solution-static/215/8.png),![fig9](https://assets.leetcode-cn.com/solution-static/215/9.png),![fig10](https://assets.leetcode-cn.com/solution-static/215/10.png),![fig11](https://assets.leetcode-cn.com/solution-static/215/11.png),![fig12](https://assets.leetcode-cn.com/solution-static/215/12.png),![fig13](https://assets.leetcode-cn.com/solution-static/215/13.png),![fig14](https://assets.leetcode-cn.com/solution-static/215/14.png),![fig15](https://assets.leetcode-cn.com/solution-static/215/15.png),![fig16](https://assets.leetcode-cn.com/solution-static/215/16.png),![fig17](https://assets.leetcode-cn.com/solution-static/215/17.png),![fig18](https://assets.leetcode-cn.com/solution-static/215/18.png),![fig19](https://assets.leetcode-cn.com/solution-static/215/19.png),![fig20](https://assets.leetcode-cn.com/solution-static/215/20.png)>

**代码**

```cpp [sol2-C++]
class Solution {
public:
    void maxHeapify(vector<int>& a, int i, int heapSize) {
        int l = i * 2 + 1, r = i * 2 + 2, largest = i;
        if (l < heapSize && a[l] > a[largest]) {
            largest = l;
        } 
        if (r < heapSize && a[r] > a[largest]) {
            largest = r;
        }
        if (largest != i) {
            swap(a[i], a[largest]);
            maxHeapify(a, largest, heapSize);
        }
    }

    void buildMaxHeap(vector<int>& a, int heapSize) {
        for (int i = heapSize / 2; i >= 0; --i) {
            maxHeapify(a, i, heapSize);
        } 
    }

    int findKthLargest(vector<int>& nums, int k) {
        int heapSize = nums.size();
        buildMaxHeap(nums, heapSize);
        for (int i = nums.size() - 1; i >= nums.size() - k + 1; --i) {
            swap(nums[0], nums[i]);
            --heapSize;
            maxHeapify(nums, 0, heapSize);
        }
        return nums[0];
    }
};
```
```Java [sol2-Java]
class Solution {
    public int findKthLargest(int[] nums, int k) {
        int heapSize = nums.length;
        buildMaxHeap(nums, heapSize);
        for (int i = nums.length - 1; i >= nums.length - k + 1; --i) {
            swap(nums, 0, i);
            --heapSize;
            maxHeapify(nums, 0, heapSize);
        }
        return nums[0];
    }

    public void buildMaxHeap(int[] a, int heapSize) {
        for (int i = heapSize / 2; i >= 0; --i) {
            maxHeapify(a, i, heapSize);
        } 
    }

    public void maxHeapify(int[] a, int i, int heapSize) {
        int l = i * 2 + 1, r = i * 2 + 2, largest = i;
        if (l < heapSize && a[l] > a[largest]) {
            largest = l;
        } 
        if (r < heapSize && a[r] > a[largest]) {
            largest = r;
        }
        if (largest != i) {
            swap(a, i, largest);
            maxHeapify(a, largest, heapSize);
        }
    }

    public void swap(int[] a, int i, int j) {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
}
```

```C [sol2-C]
void maxHeapify(int* a, int i, int heapSize) {
    int l = i * 2 + 1, r = i * 2 + 2, largest = i;
    if (l < heapSize && a[l] > a[largest]) {
        largest = l;
    }
    if (r < heapSize && a[r] > a[largest]) {
        largest = r;
    }
    if (largest != i) {
        int t = a[i];
        a[i] = a[largest], a[largest] = t;
        maxHeapify(a, largest, heapSize);
    }
}

void buildMaxHeap(int* a, int heapSize) {
    for (int i = heapSize / 2; i >= 0; --i) {
        maxHeapify(a, i, heapSize);
    }
}

int findKthLargest(int* nums, int numsSize, int k) {
    int heapSize = numsSize;
    buildMaxHeap(nums, heapSize);
    for (int i = numsSize - 1; i >= numsSize - k + 1; --i) {
        int t = nums[0];
        nums[0] = nums[i], nums[i] = t;
        --heapSize;
        maxHeapify(nums, 0, heapSize);
    }
    return nums[0];
}
```

```golang [sol2-Golang]
func findKthLargest(nums []int, k int) int {
    heapSize := len(nums)
    buildMaxHeap(nums, heapSize)
    for i := len(nums) - 1; i >= len(nums) - k + 1; i-- {
        nums[0], nums[i] = nums[i], nums[0]
        heapSize--
        maxHeapify(nums, 0, heapSize)
    }
    return nums[0]
}

func buildMaxHeap(a []int, heapSize int) {
    for i := heapSize/2; i >= 0; i-- {
        maxHeapify(a, i, heapSize)
    }
}

func maxHeapify(a []int, i, heapSize int) {
    l, r, largest := i * 2 + 1, i * 2 + 2, i
    if l < heapSize && a[l] > a[largest] {
        largest = l
    }
    if r < heapSize && a[r] > a[largest] {
        largest = r
    }
    if largest != i {
        a[i], a[largest] = a[largest], a[i]
        maxHeapify(a, largest, heapSize)
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，建堆的时间代价是 $O(n)$，删除的总代价是 $O(k \log n)$，因为 $k < n$，故渐进时间复杂为 $O(n + k \log n) = O(n \log n)$。
- 空间复杂度：$O(\log n)$，即递归使用栈空间的空间代价。