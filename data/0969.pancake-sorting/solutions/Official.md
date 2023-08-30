#### 前言

煎饼排序的相关背景内容可以参考百度百科「[煎饼排序](https://baike.baidu.com/item/%E7%85%8E%E9%A5%BC%E6%8E%92%E5%BA%8F)」。2011年，劳伦特·比尔托（Laurent Bulteau）、纪尧姆·佛丁（Guillaume Fertin）和伊雷娜·鲁苏（Irena Rusu）证明了给定一叠煎饼的长度分布，找到最短解法是 NP 困难的，参考论文「[Bulteau, Laurent; Fertin, Guillaume; Rusu, Irena. Pancake Flipping Is Hard. Journal of Computer and System Sciences: 1556–1574.](https://arxiv.org/abs/1111.0434v1)」。

#### 方法一：类选择排序

**思路与算法**

设一个元素的下标是 $\textit{index}$，我们可以通过两次煎饼排序将它放到尾部：

+ 第一步选择 $k = \textit{index} + 1$，然后反转子数组 $\textit{arr}[0 ... k - 1]$，此时该元素已经被放到首部。

+ 第二步选择 $k = \textit{n}$，其中 $\textit{n}$ 是数组 $\textit{arr}$ 的长度，然后反转整个数组，此时该元素已经被放到尾部。

通过以上两步操作，我们可以将当前数组的最大值放到尾部，然后将去掉尾部元素的数组作为新的处理对象，重复以上操作，直到处理对象的长度等于一，此时原数组已经完成排序，且需要的总操作数是 $2 \times (n - 1)$，符合题目要求。如果最大值已经在尾部，我们可以省略对应的操作。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> pancakeSort(vector<int>& arr) {
        vector<int> ret;
        for (int n = arr.size(); n > 1; n--) {
            int index = max_element(arr.begin(), arr.begin() + n) - arr.begin();
            if (index == n - 1) {
                continue;
            }
            reverse(arr.begin(), arr.begin() + index + 1);
            reverse(arr.begin(), arr.begin() + n);
            ret.push_back(index + 1);
            ret.push_back(n);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> pancakeSort(int[] arr) {
        List<Integer> ret = new ArrayList<Integer>();
        for (int n = arr.length; n > 1; n--) {
            int index = 0;
            for (int i = 1; i < n; i++) {
                if (arr[i] >= arr[index]) {
                    index = i;
                }
            }
            if (index == n - 1) {
                continue;
            }
            reverse(arr, index);
            reverse(arr, n - 1);
            ret.add(index + 1);
            ret.add(n);
        }
        return ret;
    }

    public void reverse(int[] arr, int end) {
        for (int i = 0, j = end; i < j; i++, j--) {
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> PancakeSort(int[] arr) {
        IList<int> ret = new List<int>();
        for (int n = arr.Length; n > 1; n--) {
            int index = 0;
            for (int i = 1; i < n; i++) {
                if (arr[i] >= arr[index]) {
                    index = i;
                }
            }
            if (index == n - 1) {
                continue;
            }
            Reverse(arr, index);
            Reverse(arr, n - 1);
            ret.Add(index + 1);
            ret.Add(n);
        }
        return ret;
    }

    public void Reverse(int[] arr, int end) {
        for (int i = 0, j = end; i < j; i++, j--) {
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }
}
```

```C [sol1-C]
void reverse(int *arr, int arrSize) {
    for (int left = 0, right = arrSize - 1; left < right; left++, right--) {
        int tmp = arr[left];
        arr[left] = arr[right];
        arr[right] = tmp;
    }
}

int *pancakeSort(int *arr, int arrSize, int *returnSize){
    int *ret = (int *)malloc(sizeof(int) * (arrSize - 1) * 2);
    int retSize = 0;
    for (int n = arrSize; n > 1; n--) {
        int index = 0;
        for (int i = 1; i < n; i++) {
            if (arr[i] >= arr[index]) {
                index = i;
            }
        }
        if (index == n - 1) {
            continue;
        }
        reverse(arr, index + 1);
        reverse(arr, n);
        ret[retSize++] = index + 1;
        ret[retSize++] = n;
    }
    *returnSize = retSize;
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var pancakeSort = function(arr) {
    const ret = [];
    for (let n = arr.length; n > 1; n--) {
        let index = 0;
        for (let i = 1; i < n; i++) {
            if (arr[i] >= arr[index]) {
                index = i;
            }
        }
        if (index === n - 1) {
            continue;
        }
        reverse(arr, index);
        reverse(arr, n - 1);
        ret.push(index + 1);
        ret.push(n);
    }
    return ret;
}

const reverse = (arr, end) => {
    for (let i = 0, j = end; i < j; i++, j--) {
        let temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def pancakeSort(self, arr: List[int]) -> List[int]:
        ans = []
        for n in range(len(arr), 1, -1):
            index = 0
            for i in range(n):
                if arr[i] > arr[index]:
                    index = i
            if index == n - 1:
                continue
            m = index
            for i in range((m + 1) // 2):
                arr[i], arr[m - i] = arr[m - i], arr[i]  # 原地反转
            for i in range(n // 2):
                arr[i], arr[n - 1 - i] = arr[n - 1 - i], arr[i]  # 原地反转
            ans.append(index + 1)
            ans.append(n)
        return ans
```

```go [sol1-Golang]
func pancakeSort(arr []int) (ans []int) {
    for n := len(arr); n > 1; n-- {
        index := 0
        for i, v := range arr[:n] {
            if v > arr[index] {
                index = i
            }
        }
        if index == n-1 {
            continue
        }
        for i, m := 0, index; i < (m+1)/2; i++ {
            arr[i], arr[m-i] = arr[m-i], arr[i]
        }
        for i := 0; i < n/2; i++ {
            arr[i], arr[n-1-i] = arr[n-1-i], arr[i]
        }
        ans = append(ans, index+1, n)
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{arr}$ 的大小。总共执行至多 $n - 1$ 次查找最大值，至多 $2 \times (n - 1)$ 次反转数组，而查找最大值的时间复杂度是 $O(n)$，反转数组的时间复杂度是 $O(n)$，因此总时间复杂度是 $O(n^2)$。

+ 空间复杂度：$O(1)$。返回值不计入空间复杂度。