#### 方法一：排序

设元素数目为 $n$，我们先对整数数组 $\textit{arr}$ 从小到大进行排序，然后对区间 $\big [ \dfrac{n}{20}, \dfrac{19n}{20} \big )$ 内的元素进行求和，得到未删除元素的求和结果 $\textit{partialSum}$，返回均值 $\dfrac{\textit{partialSum}}{0.9n}$ 。

```Python [sol1-Python3]
class Solution:
    def trimMean(self, arr: List[int]) -> float:
        arr.sort()
        n = len(arr)
        return sum(arr[n // 20: -n // 20]) / (n * 0.9)
```

```C++ [sol1-C++]
class Solution {
public:
    double trimMean(vector<int>& arr) {
        int n = arr.size();
        sort(arr.begin(), arr.end());
        int partialSum = accumulate(arr.begin() + n / 20, arr.begin() + (19 * n / 20), 0);
        return partialSum / (n * 0.9);
    }
};
```

```Java [sol1-Java]
class Solution {
    public double trimMean(int[] arr) {
        int n = arr.length;
        Arrays.sort(arr);
        int partialSum = 0;
        for (int i = n / 20; i < 19 * n / 20; i++) {
            partialSum += arr[i];
        }
        return partialSum / (n * 0.9);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public double TrimMean(int[] arr) {
        int n = arr.Length;
        Array.Sort(arr);
        int partialSum = 0;
        for (int i = n / 20; i < 19 * n / 20; i++) {
            partialSum += arr[i];
        }
        return partialSum / (n * 0.9);
    }
}
```

```C [sol1-C]
static inline int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

double trimMean(int* arr, int arrSize){
    qsort(arr, arrSize, sizeof(int), cmp);
    int partialSum = 0;
    for (int i = arrSize / 20; i < (19 * arrSize / 20); i++) {
        partialSum += arr[i];
    }
    return partialSum / (arrSize * 0.9);
}
```

```JavaScript [sol1-JavaScript]
var trimMean = function(arr) {
    const n = arr.length;
    arr.sort((a, b) => a - b);
    let partialSum = 0;
    for (let i = n / 20; i < 19 * n / 20; i++) {
        partialSum += arr[i];
    }
    return partialSum / (n * 0.9);
};
```

```go [sol1-Golang]
func trimMean(arr []int) float64 {
    sort.Ints(arr)
    n := len(arr)
    sum := 0
    for _, x := range arr[n/20 : 19*n/20] {
        sum += x
    }
    return float64(sum*10) / float64(n*9)
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。

+ 空间复杂度：$O(\log n)$。排序需要 $O(\log n)$ 的栈空间。