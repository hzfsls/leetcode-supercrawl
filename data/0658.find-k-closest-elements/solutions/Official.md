## [658.找到 K 个最接近的元素 中文官方题解](https://leetcode.cn/problems/find-k-closest-elements/solutions/100000/zhao-dao-k-ge-zui-jie-jin-de-yuan-su-by-ekwtd)

#### 方法一：排序

首先将数组 $\textit{arr}$ 按照「更接近」的定义进行排序，如果 $a$ 比 $b$ 更接近 $x$，那么 $a$ 将排在 $b$ 前面。排序完成之后，$k$ 个最接近的元素就是数组 $\textit{arr}$ 的前 $k$ 个元素，将这 $k$ 个元素从小到大进行排序后，直接返回。

```Python [sol1-Python3]
class Solution:
    def findClosestElements(self, arr: List[int], k: int, x: int) -> List[int]:
        arr.sort(key=lambda v: abs(v - x))
        return sorted(arr[:k])
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findClosestElements(vector<int>& arr, int k, int x) {
        sort(arr.begin(), arr.end(), [x](int a, int b) -> bool {
            return abs(a - x) < abs(b - x) || abs(a - x) == abs(b - x) && a < b;
        });
        sort(arr.begin(), arr.begin() + k);
        return vector<int>(arr.begin(), arr.begin() + k);
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> findClosestElements(int[] arr, int k, int x) {
        List<Integer> list = new ArrayList<Integer>();
        for (int num : arr) {
            list.add(num);
        }
        Collections.sort(list, (a, b) -> {
            if (Math.abs(a - x) != Math.abs(b - x)) {
                return Math.abs(a - x) - Math.abs(b - x);
            } else {
                return a - b;
            }
        });
        List<Integer> ans = list.subList(0, k);
        Collections.sort(ans);
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> FindClosestElements(int[] arr, int k, int x) {
        Array.Sort(arr, (a, b) => {
            if (Math.Abs(a - x) != Math.Abs(b - x)) {
                return Math.Abs(a - x) - Math.Abs(b - x);
            } else {
                return a - b;
            }
        });
        int[] closest = arr.Take(k).ToArray();
        Array.Sort(closest);
        IList<int> ans = new List<int>();
        foreach (int num in closest) {
            ans.Add(num);
        }
        return ans;
    }
}
```

```C [sol1-C]
int g_val;

static inline int cmp1(const void *pa, const void *pb) {
    int a = *(int *)pa;
    int b = *(int *)pb;
    if (abs(a - g_val) != abs(b - g_val)) {
        return abs(a - g_val) - abs(b - g_val);
    } else {
        return a - b;
    }
}

static inline int cmp2(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int* findClosestElements(int* arr, int arrSize, int k, int x, int* returnSize) {
    g_val = x;
    qsort(arr, arrSize, sizeof(int), cmp1);
    qsort(arr, k, sizeof(int), cmp2);
    int *res = (int *)malloc(sizeof(int) * k);
    memcpy(res, arr, sizeof(int) * k);
    *returnSize = k;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var findClosestElements = function(arr, k, x) {
    const list = [...arr];
    list.sort((a, b) => {
        if (Math.abs(a - x) !== Math.abs(b - x)) {
            return Math.abs(a - x) - Math.abs(b - x);
        } else {
            return a - b;
        }
    });
    const ans = list.slice(0, k);
    ans.sort((a, b) => a - b);
    return ans;
};
```

```go [sol1-Golang]
func findClosestElements(arr []int, k, x int) []int {
    // 稳定排序，在绝对值相同的情况下，保证更小的数排在前面
    sort.SliceStable(arr, func(i, j int) bool { return abs(arr[i]-x) < abs(arr[j]-x) })
    arr = arr[:k]
    sort.Ints(arr)
    return arr
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。排序需要 $O(n \log n)$。

+ 空间复杂度：$O(\log n)$。返回值不计算时间复杂度。排序需要 $O(\log n)$ 的栈空间。

#### 方法二：二分查找 + 双指针

假设数组长度为 $n$，注意到数组 $\textit{arr}$ 已经按照升序排序，我们可以将数组 $\textit{arr}$ 分成两部分，前一部分所有元素 $[0, \textit{left}]$ 都小于 $x$，后一部分所有元素 $[\textit{right}, n - 1]$ 都大于等于 $x$，$\textit{left}$ 与 $\textit{right}$ 都可以通过二分查找获得。

$\textit{left}$ 和 $\textit{right}$ 指向的元素都是各自部分最接近 $x$ 的元素，因此我们可以通过比较 $\textit{left}$ 和 $\textit{right}$ 指向的元素获取整体最接近 $x$ 的元素。如果 $x - \textit{arr}[\textit{left}] \le \textit{arr}[\textit{right}] - x$，那么将 $\textit{left}$ 减一，否则将 $\textit{right}$ 加一。相应地，如果 $\textit{left}$ 或 $\textit{right}$ 已经越界，那么不考虑对应部分的元素。

最后，区间 $[\textit{left} + 1, \textit{right} - 1]$ 的元素就是我们所要获得的结果，返回答案既可。 

```Python [sol2-Python3]
class Solution:
    def findClosestElements(self, arr: List[int], k: int, x: int) -> List[int]:
        right = bisect_left(arr, x)
        left = right - 1
        for _ in range(k):
            if left < 0:
                right += 1
            elif right >= len(arr) or x - arr[left] <= arr[right] - x:
                left -= 1
            else:
                right += 1
        return arr[left + 1: right]
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> findClosestElements(vector<int>& arr, int k, int x) {
        int right = lower_bound(arr.begin(), arr.end(), x) - arr.begin();
        int left = right - 1;
        while (k--) {
            if (left < 0) {
                right++;
            } else if (right >= arr.size()) {
                left--;
            } else if (x - arr[left] <= arr[right] - x) {
                left--;
            } else {
                right++;
            }
        }
        return vector<int>(arr.begin() + left + 1, arr.begin() + right);
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> findClosestElements(int[] arr, int k, int x) {
        int right = binarySearch(arr, x);
        int left = right - 1;
        while (k-- > 0) {
            if (left < 0) {
                right++;
            } else if (right >= arr.length) {
                left--;
            } else if (x - arr[left] <= arr[right] - x) {
                left--;
            } else {
                right++;
            }
        }
        List<Integer> ans = new ArrayList<Integer>();
        for (int i = left + 1; i < right; i++) {
            ans.add(arr[i]);
        }
        return ans;
    }

    public int binarySearch(int[] arr, int x) {
        int low = 0, high = arr.length - 1;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (arr[mid] >= x) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<int> FindClosestElements(int[] arr, int k, int x) {
        int right = BinarySearch(arr, x);
        int left = right - 1;
        while (k-- > 0) {
            if (left < 0) {
                right++;
            } else if (right >= arr.Length) {
                left--;
            } else if (x - arr[left] <= arr[right] - x) {
                left--;
            } else {
                right++;
            }
        }
        IList<int> ans = new List<int>();
        for (int i = left + 1; i < right; i++) {
            ans.Add(arr[i]);
        }
        return ans;
    }

    public int BinarySearch(int[] arr, int x) {
        int low = 0, high = arr.Length - 1;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (arr[mid] >= x) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C [sol2-C]
int binarySearch(const int* arr, int arrSize, int x) {
    int low = 0, high = arrSize - 1;
    while (low < high) {
        int mid = low + (high - low) / 2;
        if (arr[mid] >= x) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
}

int* findClosestElements(int* arr, int arrSize, int k, int x, int* returnSize) {
    int right = binarySearch(arr, arrSize, x);
    int left = right - 1;
    while (k--) {
        if (left < 0) {
            right++;
        } else if (right >= arrSize) {
            left--;
        } else if (x - arr[left] <= arr[right] - x) {
            left--;
        } else {
            right++;
        }
    }
    int *res = (int *)malloc(sizeof(int) * (right - left - 1));
    memcpy(res, arr + left + 1, sizeof(int) * (right - left - 1));
    *returnSize = right - left - 1;
    return res;
}
```

```JavaScript [sol2-JavaScript]
var findClosestElements = function(arr, k, x) {
    let right = binarySearch(arr, x);
    let left = right - 1;
    while (k-- > 0) {
        if (left < 0) {
            right++;
        } else if (right >= arr.length) {
            left--;
        } else if (x - arr[left] <= arr[right] - x) {
            left--;
        } else {
            right++;
        }
    }
    const ans = [];
    for (let i = left + 1; i < right; i++) {
        ans.push(arr[i]);
    }
    return ans;
}

const binarySearch = (arr, x) => {
    let low = 0, high = arr.length - 1;
    while (low < high) {
        const mid = low + Math.floor((high - low) / 2);
        if (arr[mid] >= x) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
}
```

```go [sol2-Golang]
func findClosestElements(arr []int, k, x int) []int {
    right := sort.SearchInts(arr, x)
    left := right - 1
    for ; k > 0; k-- {
        if left < 0 {
            right++
        } else if right >= len(arr) || x-arr[left] <= arr[right]-x {
            left--
        } else {
            right++
        }
    }
    return arr[left+1 : right]
}
```

**复杂度分析**

+ 时间复杂度：$O(\log n + k)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。二分查找需要 $O(\log n)$，双指针查找需要 $O(k)$。

+ 空间复杂度：$O(1)$。返回值不计入空间复杂度。