## [1053.交换一次的先前排列 中文官方题解](https://leetcode.cn/problems/previous-permutation-with-one-swap/solutions/100000/jiao-huan-yi-ci-de-xian-qian-pai-lie-by-evkqi)
#### 方法一：贪心

记数组 $\textit{arr}$ 的长度为 $n$，对于 $0 \le i \lt j \lt n$，如果交换 $\textit{arr}[i]$ 和 $\textit{arr}[j]$ 后得到的新数组按字典序排列比原数组小，显然有 $\textit{arr}[i] \gt \textit{arr}[j]$ 成立。因此符合题意要求的交换会使得数组 $\textit{arr}$ 在下标 $i$ 处的元素变小。那么为了得到按字典序排列小于原数组的最大新数组，尽可能地保持前面的元素不变是最优的，即让 $i$ 最大化。

+ 如何最大化 $i$

    我们可以从大到小枚举 $i \in [0, n - 2]$，然后枚举 $j \in [i + 1, n)$，如果存在 $j$ 使 $\textit{arr}[i] \gt \textit{arr}[j]$ 成立，那么说明当前枚举的 $i$ 是最大化的。这里只需要判断 $\textit{arr}[i] \gt \textit{arr}[i + 1]$ 是否成立即可，因为后面的元素是符合非递减的，即 $\textit{arr}[i + 1]$ 是 $\textit{arr}[i]$ 后面的最小元素。

> 当我们枚举 $i$ 时，显然不存在 $k \gt i$，使得 $\textit{arr}[k] \gt \textit{arr}[k + 1]$ 成立，因此 $\textit{arr}[i]$ 后面的元素是符合非递减的。

+ $i$ 最大化后，$j \in [i + 1, n)$ 应该怎么选择

    显然在满足 $\textit{arr}[j] \lt \textit{arr}[i]$ 的条件下，取最大的 $\textit{arr}[j]$ 是最优的。但是题目并没有元素不重复的要求，最大的 $\textit{arr}[j]$ 可能有重复值，那么选择其中下标最小的 $\textit{arr}[j]$ 是最优的。

    由前面推导可知，区间 $[i + 1, n)$ 的元素是非递减的，因此我们从大到小枚举 $j$，直到 $\textit{arr}[j] \lt \textit{arr}[i]$ 且 $\textit{arr}[j] \ne \textit{arr}[j - 1]$ 成立，那么得到的 $j$ 就是符合要求的。交换 $\textit{arr}[i]$ 和 $\textit{arr}[j]$。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> prevPermOpt1(vector<int>& arr) {
        int n = arr.size();
        for (int i = n - 2; i >= 0; i--) {
            if (arr[i] > arr[i + 1]) {
                int j = n - 1;
                while (arr[j] >= arr[i] || arr[j] == arr[j - 1]) {
                    j--;
                }
                swap(arr[i], arr[j]);
                break;
            }
        }
        return arr;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] prevPermOpt1(int[] arr) {
        int n = arr.length;
        for (int i = n - 2; i >= 0; i--) {
            if (arr[i] > arr[i + 1]) {
                int j = n - 1;
                while (arr[j] >= arr[i] || arr[j] == arr[j - 1]) {
                    j--;
                }
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
                break;
            }
        }
        return arr;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def prevPermOpt1(self, arr: List[int]) -> List[int]:
        n = len(arr)
        for i in range(n - 2, -1, -1):
            if arr[i] > arr[i + 1]:
                j = n - 1
                while arr[j] >= arr[i] or arr[j] == arr[j - 1]:
                    j -= 1
                arr[i], arr[j] = arr[j], arr[i]
                break
        return arr
```

```C# [sol1-C#]
public class Solution {
    public int[] PrevPermOpt1(int[] arr) {
        int n = arr.Length;
        for (int i = n - 2; i >= 0; i--) {
            if (arr[i] > arr[i + 1]) {
                int j = n - 1;
                while (arr[j] >= arr[i] || arr[j] == arr[j - 1]) {
                    j--;
                }
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
                break;
            }
        }
        return arr;
    }
}
```

```Golang [sol1-Golang]
func prevPermOpt1(arr []int) []int {
    for i := len(arr) - 2; i >= 0; i-- {
        if arr[i] > arr[i + 1] {
            j := len(arr) - 1
            for arr[j] >= arr[i] || arr[j] == arr[j - 1] {
                j--
            }
            arr[i], arr[j] = arr[j], arr[i]
            break
        }
    }
    return arr
}
```

```C [sol1-C]
int* prevPermOpt1(int* arr, int arrSize, int* returnSize) {
    int n = arrSize;
    for (int i = n - 2; i >= 0; i--) {
        if (arr[i] > arr[i + 1]) {
            int j = n - 1;
            while (arr[j] >= arr[i] || arr[j] == arr[j - 1]) {
                j--;
            }
            int val = arr[i];
            arr[i] = arr[j];
            arr[j] = val;
            break;
        }
    }
    *returnSize = arrSize;
    return arr;
}
```

```JavaScript [sol1-JavaScript]
var prevPermOpt1 = function(arr) {
  const n = arr.length;
  for (let i = n - 2; i >= 0; i--) {
    if (arr[i] > arr[i + 1]) {
      let j = n - 1;
      while (arr[j] >= arr[i] || arr[j] == arr[j - 1]) {
        j--;
      }
      let temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
      break;
    }
  }
  return arr;

};
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。查找 $i$ 需要 $O(n)$ 的时间复杂度，查找 $j$ 需要 $O(n)$ 的时间复杂度。

+ 空间复杂度：$O(1)$。返回值不计入空间复杂度。