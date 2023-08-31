## [1356.根据数字二进制下 1 的数目排序 中文官方题解](https://leetcode.cn/problems/sort-integers-by-the-number-of-1-bits/solutions/100000/gen-ju-shu-zi-er-jin-zhi-xia-1-de-shu-mu-pai-xu-by)

#### 前言

题目本身很简单，只要调用系统自带的排序函数，然后自己改写排序规则即可，所以这里主要讲解如何计算数字二进制下 $1$ 的个数。

#### 方法一：暴力

对每个十进制的数转二进制的时候统计二进制表示中的 $1$ 的个数即可。

```C++ [sol1-C++]
class Solution {
public:
    int get(int x){
        int res = 0;
        while (x) {
            res += (x % 2);
            x /= 2;
        }
        return res;
    }
    vector<int> sortByBits(vector<int>& arr) {
        vector<int> bit(10001, 0);
        for (auto x: arr) {
            bit[x] = get(x);
        }
        sort(arr.begin(), arr.end(), [&](int x, int y){
            if (bit[x] < bit[y]) {
                return true;
            }
            if (bit[x] > bit[y]) {
                return false;
            }
            return x < y;
        });
        return arr;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] sortByBits(int[] arr) {
        int[] bit = new int[10001];
        List<Integer> list = new ArrayList<Integer>();
        for (int x : arr) {
            list.add(x);
            bit[x] = get(x);
        }
        Collections.sort(list, new Comparator<Integer>() {
            public int compare(Integer x, Integer y) {
                if (bit[x] != bit[y]) {
                    return bit[x] - bit[y];
                } else {
                    return x - y;
                }
            }
        });
        for (int i = 0; i < arr.length; ++i) {
            arr[i] = list.get(i);
        }
        return arr;
    }

    public int get(int x) {
        int res = 0;
        while (x != 0) {
            res += x % 2;
            x /= 2;
        }
        return res;
    }
}
```

```Golang [sol1-Golang]
func onesCount(x int) (c int) {
    for ; x > 0; x /= 2 {
        c += x % 2
    }
    return
}

func sortByBits(a []int) []int {
    sort.Slice(a, func(i, j int) bool {
        x, y := a[i], a[j]
        cx, cy := onesCount(x), onesCount(y)
        return cx < cy || cx == cy && x < y
    })
    return a
}
```

```C [sol1-C]
int* bit;

int get(int x) {
    int res = 0;
    while (x) {
        res += (x % 2);
        x /= 2;
    }
    return res;
}

int cmp(void* _x, void* _y) {
    int x = *(int*)_x, y = *(int*)_y;
    return bit[x] == bit[y] ? x - y : bit[x] - bit[y];
}

int* sortByBits(int* arr, int arrSize, int* returnSize) {
    bit = malloc(sizeof(int) * 10001);
    memset(bit, 0, sizeof(int) * 10001);
    for (int i = 0; i < arrSize; ++i) {
        bit[arr[i]] = get(arr[i]);
    }
    qsort(arr, arrSize, sizeof(int), cmp);
    free(bit);
    *returnSize = arrSize;
    return arr;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为整数数组 $\textit{arr}$ 的长度。

- 空间复杂度：$O(n)$，其中 $n$ 为整数数组 $\textit{arr}$ 的长度。


#### 方法二：递推预处理

我们定义 $bit[i]$ 为数字 $i$ 二进制表示下数字 $1$ 的个数，则可以列出递推式：

$$ bit[i] = bit[i>>1] + (i \& 1)$$

所以我们线性预处理 $bit$ 数组然后去排序即可。

```C++ [sol2-C++]
class Solution {
public:
    vector<int> sortByBits(vector<int>& arr) {
        vector<int> bit(10001, 0);
        for (int i = 1; i <= 10000; ++i) {
            bit[i] = bit[i >> 1] + (i & 1);
        }
        sort(arr.begin(), arr.end(), [&](int x, int y){
            if (bit[x] < bit[y]) {
                return true;
            }
            if (bit[x] > bit[y]) {
                return false;
            }
            return x < y;
        });
        return arr;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] sortByBits(int[] arr) {
        List<Integer> list = new ArrayList<Integer>();
        for (int x : arr) {
            list.add(x);
        }
        int[] bit = new int[10001];
        for (int i = 1; i <= 10000; ++i) {
            bit[i] = bit[i >> 1] + (i & 1);
        }
        Collections.sort(list, new Comparator<Integer>() {
            public int compare(Integer x, Integer y) {
                if (bit[x] != bit[y]) {
                    return bit[x] - bit[y];
                } else {
                    return x - y;
                }
            }
        });
        for (int i = 0; i < arr.length; ++i) {
            arr[i] = list.get(i);
        }
        return arr;
    }
}
```

```Golang [sol2-Golang]
var bit = [1e4 + 1]int{}

func init() {
    for i := 1; i <= 1e4; i++ {
        bit[i] = bit[i>>1] + i&1
    }
}

func sortByBits(a []int) []int {
    sort.Slice(a, func(i, j int) bool {
        x, y := a[i], a[j]
        cx, cy := bit[x], bit[y]
        return cx < cy || cx == cy && x < y
    })
    return a
}
```

```C [sol2-C]
int* bit;

int cmp(void* _x, void* _y) {
    int x = *(int*)_x, y = *(int*)_y;
    return bit[x] == bit[y] ? x - y : bit[x] - bit[y];
}

int* sortByBits(int* arr, int arrSize, int* returnSize) {
    bit = malloc(sizeof(int) * 10001);
    memset(bit, 0, sizeof(int) * 10001);
    for (int i = 1; i <= 10000; ++i) {
        bit[i] = bit[i >> 1] + (i & 1);
    }
    qsort(arr, arrSize, sizeof(int), cmp);
    free(bit);
    *returnSize = arrSize;
    return arr;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为整数数组 $\textit{arr}$ 的长度。

- 空间复杂度：$O(n)$，其中 $n$ 为整数数组 $\textit{arr}$ 的长度。