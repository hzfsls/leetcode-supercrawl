## [88.合并两个有序数组 中文官方题解](https://leetcode.cn/problems/merge-sorted-array/solutions/100000/he-bing-liang-ge-you-xu-shu-zu-by-leetco-rrb0)


### 📺 视频题解  
![88. 合并两个有序数组.mp4](c4e23dee-0349-4f11-83d0-d476c2567f90)

### 📖 文字题解
#### 方法一：直接合并后排序

**算法**

最直观的方法是先将数组 $\textit{nums}_2$ 放进数组 $\textit{nums}_1$ 的尾部，然后直接对整个数组进行排序。

```C++ [sol1-C++]
class Solution {
public:
    void merge(vector<int>& nums1, int m, vector<int>& nums2, int n) {
        for (int i = 0; i != n; ++i) {
            nums1[m + i] = nums2[i];
        }
        sort(nums1.begin(), nums1.end());
    }
};
```

```Java [sol1-Java]
class Solution {
    public void merge(int[] nums1, int m, int[] nums2, int n) {
        for (int i = 0; i != n; ++i) {
            nums1[m + i] = nums2[i];
        }
        Arrays.sort(nums1);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def merge(self, nums1: List[int], m: int, nums2: List[int], n: int) -> None:
        """
        Do not return anything, modify nums1 in-place instead.
        """
        nums1[m:] = nums2
        nums1.sort()
```

```go [sol1-Golang]
func merge(nums1 []int, m int, nums2 []int, _ int) {
    copy(nums1[m:], nums2)
    sort.Ints(nums1)
}
```

```JavaScript [sol1-JavaScript]
var merge = function(nums1, m, nums2, n) {
    nums1.splice(m, nums1.length - m, ...nums2);
    nums1.sort((a, b) => a - b);
};
```

```C [sol1-C]
int cmp(int* a, int* b) {
    return *a - *b;
}

void merge(int* nums1, int nums1Size, int m, int* nums2, int nums2Size, int n) {
    for (int i = 0; i != n; ++i) {
        nums1[m + i] = nums2[i];
    }
    qsort(nums1, nums1Size, sizeof(int), cmp);
}
```

**复杂度分析**

  * 时间复杂度：$O((m+n)\log(m+n))$。
    排序序列长度为 $m+n$，套用快速排序的时间复杂度即可，平均情况为 $O((m+n)\log(m+n))$。

  * 空间复杂度：$O(\log(m+n))$。
    排序序列长度为 $m+n$，套用快速排序的空间复杂度即可，平均情况为 $O(\log(m+n))$。

#### 方法二：双指针

**算法**

方法一没有利用数组 $\textit{nums}_1$ 与 $\textit{nums}_2$ 已经被排序的性质。为了利用这一性质，我们可以使用双指针方法。这一方法将两个数组看作队列，每次从两个数组头部取出比较小的数字放到结果中。如下面的动画所示：

![gif1](https://assets.leetcode-cn.com/solution-static/88/1.gif){:width=540}

我们为两个数组分别设置一个指针 $p_1$ 与 $p_2$ 来作为队列的头部指针。代码实现如下：

```C++ [sol2-C++]
class Solution {
public:
    void merge(vector<int>& nums1, int m, vector<int>& nums2, int n) {
        int p1 = 0, p2 = 0;
        int sorted[m + n];
        int cur;
        while (p1 < m || p2 < n) {
            if (p1 == m) {
                cur = nums2[p2++];
            } else if (p2 == n) {
                cur = nums1[p1++];
            } else if (nums1[p1] < nums2[p2]) {
                cur = nums1[p1++];
            } else {
                cur = nums2[p2++];
            }
            sorted[p1 + p2 - 1] = cur;
        }
        for (int i = 0; i != m + n; ++i) {
            nums1[i] = sorted[i];
        }
    }
};
```

```Java [sol2-Java]
class Solution {
    public void merge(int[] nums1, int m, int[] nums2, int n) {
        int p1 = 0, p2 = 0;
        int[] sorted = new int[m + n];
        int cur;
        while (p1 < m || p2 < n) {
            if (p1 == m) {
                cur = nums2[p2++];
            } else if (p2 == n) {
                cur = nums1[p1++];
            } else if (nums1[p1] < nums2[p2]) {
                cur = nums1[p1++];
            } else {
                cur = nums2[p2++];
            }
            sorted[p1 + p2 - 1] = cur;
        }
        for (int i = 0; i != m + n; ++i) {
            nums1[i] = sorted[i];
        }
    }
}
```

```Python [sol2-Python3]
class Solution:
    def merge(self, nums1: List[int], m: int, nums2: List[int], n: int) -> None:
        """
        Do not return anything, modify nums1 in-place instead.
        """
        sorted = []
        p1, p2 = 0, 0
        while p1 < m or p2 < n:
            if p1 == m:
                sorted.append(nums2[p2])
                p2 += 1
            elif p2 == n:
                sorted.append(nums1[p1])
                p1 += 1
            elif nums1[p1] < nums2[p2]:
                sorted.append(nums1[p1])
                p1 += 1
            else:
                sorted.append(nums2[p2])
                p2 += 1
        nums1[:] = sorted
```

```go [sol2-Golang]
func merge(nums1 []int, m int, nums2 []int, n int) {
    sorted := make([]int, 0, m+n)
    p1, p2 := 0, 0
    for {
        if p1 == m {
            sorted = append(sorted, nums2[p2:]...)
            break
        }
        if p2 == n {
            sorted = append(sorted, nums1[p1:]...)
            break
        }
        if nums1[p1] < nums2[p2] {
            sorted = append(sorted, nums1[p1])
            p1++
        } else {
            sorted = append(sorted, nums2[p2])
            p2++
        }
    }
    copy(nums1, sorted)
}
```

```JavaScript [sol2-JavaScript]
var merge = function(nums1, m, nums2, n) {
    let p1 = 0, p2 = 0;
    const sorted = new Array(m + n).fill(0);
    var cur;
    while (p1 < m || p2 < n) {
        if (p1 === m) {
            cur = nums2[p2++];
        } else if (p2 === n) {
            cur = nums1[p1++];
        } else if (nums1[p1] < nums2[p2]) {
            cur = nums1[p1++];
        } else {
            cur = nums2[p2++];
        }
        sorted[p1 + p2 - 1] = cur;
    }
    for (let i = 0; i != m + n; ++i) {
        nums1[i] = sorted[i];
    }
};
```

```C [sol2-C]
void merge(int* nums1, int nums1Size, int m, int* nums2, int nums2Size, int n) {
    int p1 = 0, p2 = 0;
    int sorted[m + n];
    int cur;
    while (p1 < m || p2 < n) {
        if (p1 == m) {
            cur = nums2[p2++];
        } else if (p2 == n) {
            cur = nums1[p1++];
        } else if (nums1[p1] < nums2[p2]) {
            cur = nums1[p1++];
        } else {
            cur = nums2[p2++];
        }
        sorted[p1 + p2 - 1] = cur;
    }
    for (int i = 0; i != m + n; ++i) {
        nums1[i] = sorted[i];
    }
}
```

**复杂度分析**

  * 时间复杂度：$O(m+n)$。
    指针移动单调递增，最多移动 $m+n$ 次，因此时间复杂度为 $O(m+n)$。

  * 空间复杂度：$O(m+n)$。
    需要建立长度为 $m+n$ 的中间数组 $\textit{sorted}$。

#### 方法三：逆向双指针

**算法**

方法二中，之所以要使用临时变量，是因为如果直接合并到数组 $\textit{nums}_1$ 中，$\textit{nums}_1$ 中的元素可能会在取出之前被覆盖。那么如何直接避免覆盖 $\textit{nums}_1$ 中的元素呢？观察可知，$\textit{nums}_1$ 的后半部分是空的，可以直接覆盖而不会影响结果。因此可以指针设置为从后向前遍历，每次取两者之中的较大者放进 $\textit{nums}_1$ 的最后面。

严格来说，在此遍历过程中的任意一个时刻，$\textit{nums}_1$ 数组中有 $m-p_1-1$ 个元素被放入 $\textit{nums}_1$ 的后半部，$\textit{nums}_2$ 数组中有 $n-p_2-1$ 个元素被放入 $\textit{nums}_1$ 的后半部，而在指针 $p_1$ 的后面，$\textit{nums}_1$ 数组有 $m+n-p_1-1$ 个位置。由于

$$m+n-p_1-1\geq m-p_1-1+n-p_2-1$$

等价于

$$p_2\geq -1$$

永远成立，因此 $p_1$ 后面的位置永远足够容纳被插入的元素，不会产生 $p_1$ 的元素被覆盖的情况。

实现代码如下：

```C++ [sol3-C++]
class Solution {
public:
    void merge(vector<int>& nums1, int m, vector<int>& nums2, int n) {
        int p1 = m - 1, p2 = n - 1;
        int tail = m + n - 1;
        int cur;
        while (p1 >= 0 || p2 >= 0) {
            if (p1 == -1) {
                cur = nums2[p2--];
            } else if (p2 == -1) {
                cur = nums1[p1--];
            } else if (nums1[p1] > nums2[p2]) {
                cur = nums1[p1--];
            } else {
                cur = nums2[p2--];
            }
            nums1[tail--] = cur;
        }
    }
};
```

```Java [sol3-Java]
class Solution {
    public void merge(int[] nums1, int m, int[] nums2, int n) {
        int p1 = m - 1, p2 = n - 1;
        int tail = m + n - 1;
        int cur;
        while (p1 >= 0 || p2 >= 0) {
            if (p1 == -1) {
                cur = nums2[p2--];
            } else if (p2 == -1) {
                cur = nums1[p1--];
            } else if (nums1[p1] > nums2[p2]) {
                cur = nums1[p1--];
            } else {
                cur = nums2[p2--];
            }
            nums1[tail--] = cur;
        }
    }
}
```

```Python [sol3-Python3]
class Solution:
    def merge(self, nums1: List[int], m: int, nums2: List[int], n: int) -> None:
        """
        Do not return anything, modify nums1 in-place instead.
        """
        p1, p2 = m - 1, n - 1
        tail = m + n - 1
        while p1 >= 0 or p2 >= 0:
            if p1 == -1:
                nums1[tail] = nums2[p2]
                p2 -= 1
            elif p2 == -1:
                nums1[tail] = nums1[p1]
                p1 -= 1
            elif nums1[p1] > nums2[p2]:
                nums1[tail] = nums1[p1]
                p1 -= 1
            else:
                nums1[tail] = nums2[p2]
                p2 -= 1
            tail -= 1
```

```go [sol3-Golang]
func merge(nums1 []int, m int, nums2 []int, n int) {
    for p1, p2, tail := m-1, n-1, m+n-1; p1 >= 0 || p2 >= 0; tail-- {
        var cur int
        if p1 == -1 {
            cur = nums2[p2]
            p2--
        } else if p2 == -1 {
            cur = nums1[p1]
            p1--
        } else if nums1[p1] > nums2[p2] {
            cur = nums1[p1]
            p1--
        } else {
            cur = nums2[p2]
            p2--
        }
        nums1[tail] = cur
    }
}
```

```JavaScript [sol3-JavaScript]
var merge = function(nums1, m, nums2, n) {
    let p1 = m - 1, p2 = n - 1;
    let tail = m + n - 1;
    var cur;
    while (p1 >= 0 || p2 >= 0) {
        if (p1 === -1) {
            cur = nums2[p2--];
        } else if (p2 === -1) {
            cur = nums1[p1--];
        } else if (nums1[p1] > nums2[p2]) {
            cur = nums1[p1--];
        } else {
            cur = nums2[p2--];
        }
        nums1[tail--] = cur;
    }
};
```

```C [sol3-C]
void merge(int* nums1, int nums1Size, int m, int* nums2, int nums2Size, int n) {
    int p1 = m - 1, p2 = n - 1;
    int tail = m + n - 1;
    int cur;
    while (p1 >= 0 || p2 >= 0) {
        if (p1 == -1) {
            cur = nums2[p2--];
        } else if (p2 == -1) {
            cur = nums1[p1--];
        } else if (nums1[p1] > nums2[p2]) {
            cur = nums1[p1--];
        } else {
            cur = nums2[p2--];
        }
        nums1[tail--] = cur;
    }
}
```

**复杂度分析**

  * 时间复杂度：$O(m+n)$。
    指针移动单调递减，最多移动 $m+n$ 次，因此时间复杂度为 $O(m+n)$。
  
  * 空间复杂度：$O(1)$。
    直接对数组 $\textit{nums}_1$ 原地修改，不需要额外空间。