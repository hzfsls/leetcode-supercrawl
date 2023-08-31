## [1524.和为奇数的子数组数目 中文官方题解](https://leetcode.cn/problems/number-of-sub-arrays-with-odd-sum/solutions/100000/he-wei-qi-shu-de-zi-shu-zu-shu-mu-by-leetcode-solu)

#### 方法一：前缀和 + 数学

这道题要求返回和为奇数的子数组数目。为了快速计算任意子数组的和，可以通过维护前缀和的方式。这道题只需要知道每个子数组的和的奇偶性，不需要知道子数组的和的具体值，因此不需要维护每一个前缀和，只需要维护奇数前缀和的数量与偶数前缀和的数量。

分别使用 $\textit{odd}$ 和 $\textit{even}$ 表示奇数前缀和的数量与偶数前缀和的数量。初始时，$\textit{odd}=0$，$\textit{even}=1$，因为空的前缀的和是 $0$，也是偶数前缀和。

遍历数组 $\textit{arr}$ 并计算前缀和。对于下标 $i$ 的位置的前缀和（即 $\textit{arr}[0]+\textit{arr}[1]+\ldots+\textit{arr}[i]$），根据奇偶性进行如下操作：

- 当下标 $i$ 的位置的前缀和是偶数时，如果下标 $j$ 满足 $j < i$ 且下标 $j$ 的位置的前缀和是奇数，则从下标 $j+1$ 到下标 $i$ 的子数组的和是奇数，因此，以下标 $i$ 结尾的子数组中，和为奇数的子数组的数量即为奇数前缀和的数量 $\textit{odd}$；

- 当下标 $i$ 的位置的前缀和是奇数时，如果下标 $j$ 满足 $j < i$ 且下标 $j$ 的位置的前缀和是偶数，则从下标 $j+1$ 到下标 $i$ 的子数组的和是奇数，因此，以下标 $i$ 结尾的子数组中，和为奇数的子数组的数量即为偶数前缀和的数量 $\textit{even}$。

上述下标 $j$ 的最小可能取值为 $-1$，当 $j=-1$ 时表示下标 $j$ 的位置的前缀为空。

在更新和为奇数的子数组数量之后，需要根据下标 $i$ 的位置的前缀和的奇偶性更新 $\textit{odd}$ 或 $\textit{even}$ 的值。如果前缀和是奇数，则 $\textit{odd}$ 的值加 $1$；如果前缀和是偶数，则 $\textit{even}$ 的值加 $1$。

```Java [sol1-Java]
class Solution {
    public int numOfSubarrays(int[] arr) {
        final int MODULO = 1000000007;
        int odd = 0, even = 1;
        int subarrays = 0;
        int sum = 0;
        int length = arr.length;
        for (int i = 0; i < length; i++) {
            sum += arr[i];
            subarrays = (subarrays + (sum % 2 == 0 ? odd : even)) % MODULO;
            if (sum % 2 == 0) {
                even++;
            } else {
                odd++;
            }
        }
        return subarrays;
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    int numOfSubarrays(vector<int>& arr) {
        const int MODULO = 1000000007;
        int odd = 0, even = 1;
        int subarrays = 0;
        int sum = 0;
        int length = arr.size();
        for (int i = 0; i < length; i++) {
            sum += arr[i];
            subarrays = (subarrays + (sum % 2 == 0 ? odd : even)) % MODULO;
            if (sum % 2 == 0) {
                even++;
            } else {
                odd++;
            }
        }
        return subarrays;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numOfSubarrays(self, arr: List[int]) -> int:
        MODULO = 10**9 + 7
        odd, even = 0, 1
        subarrays = 0
        total = 0
        
        for x in arr:
            total += x
            subarrays += (odd if total % 2 == 0 else even)
            if total % 2 == 0:
                even += 1
            else:
                odd += 1
        
        return subarrays % MODULO
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。遍历数组一次，对于数组中的每个元素，更新前缀和、和为奇数的子数组数目以及 $\textit{odd}$ 和 $\textit{even}$ 的值的时间复杂度都是 $O(1)$，因此总时间复杂度是 $O(n)$。

- 空间复杂度：$O(1)$。只需要维护常量的额外空间。