## [330.按要求补齐数组 中文官方题解](https://leetcode.cn/problems/patching-array/solutions/100000/an-yao-qiu-bu-qi-shu-zu-by-leetcode-solu-klp1)

#### 方法一：贪心

对于正整数 $x$，如果区间 $[1,x-1]$ 内的所有数字都已经被覆盖，且 $x$ 在数组中，则区间 $[1,2x-1]$ 内的所有数字也都被覆盖。证明如下。

> 对于任意 $1 \le y<x$，$y$ 已经被覆盖，$x$ 在数组中，因此 $y+x$ 也被覆盖，区间 $[x+1,2x-1]$（即区间 $[1,x-1]$ 内的每个数字加上 $x$ 之后得到的区间）内的所有数字也被覆盖，由此可得区间 $[1,2x-1]$ 内的所有数字都被覆盖。

假设数字 $x$ 缺失，则至少需要在数组中补充一个小于或等于 $x$ 的数，才能覆盖到 $x$，否则无法覆盖到 $x$。

如果区间 $[1,x-1]$ 内的所有数字都已经被覆盖，则从贪心的角度考虑，补充 $x$ 之后即可覆盖到 $x$，且满足补充的数字个数最少。在补充 $x$ 之后，区间 $[1,2x-1]$ 内的所有数字都被覆盖，下一个缺失的数字一定不会小于 $2x$。

由此可以提出一个贪心的方案。每次找到未被数组 $\textit{nums}$ 覆盖的最小的整数 $x$，在数组中补充 $x$，然后寻找下一个未被覆盖的最小的整数，重复上述步骤直到区间 $[1,n]$ 中的所有数字都被覆盖。

具体实现方面，任何时候都应满足区间 $[1,x-1]$ 内的所有数字都被覆盖。令 $x$ 的初始值为 $1$，数组下标 $\textit{index}$ 的初始值为 $0$，则初始状态下区间 $[1,x-1]$ 为空区间，满足区间内的所有数字都被覆盖。进行如下操作。

- 如果 $\textit{index}$ 在数组 $\textit{nums}$ 的下标范围内且 $\textit{nums}[\textit{index}] \le x$，则将 $\textit{nums}[\textit{index}]$ 的值加给 $x$，并将 $\textit{index}$ 的值加 $1$。
   - 被覆盖的区间从 $[1,x-1]$ 扩展到 $[1,x+\textit{nums}[\textit{index}]-1]$，对 $x$ 的值更新以后，被覆盖的区间为 $[1,x-1]$。

- 否则，$x$ 没有被覆盖，因此需要在数组中补充 $x$，然后将 $x$ 的值乘以 $2$。
   - 在数组中补充 $x$ 之后，被覆盖的区间从 $[1,x-1]$ 扩展到 $[1,2x-1]$，对 $x$ 的值更新以后，被覆盖的区间为 $[1,x-1]$。

- 重复上述操作，直到 $x$ 的值大于 $n$。

由于任何时候都满足区间 $[1,x-1]$ 内的所有数字都被覆盖，因此上述操作可以保证区间 $[1,n]$ 内的所有数字都被覆盖。

又由于上述操作只在 $x$ 不被覆盖时才在数组中补充 $x$，如果不补充 $x$ 则 $x$ 无法被覆盖，因此可以保证补充的数字个数最少。如果减少补充的数字个数，则无法覆盖区间 $[1,n]$ 内的所有数字。

```Java [sol1-Java]
class Solution {
    public int minPatches(int[] nums, int n) {
        int patches = 0;
        long x = 1;
        int length = nums.length, index = 0;
        while (x <= n) {
            if (index < length && nums[index] <= x) {
                x += nums[index];
                index++;
            } else {
                x *= 2;
                patches++;
            }
        }
        return patches;
    }
}
```

```JavaScript [sol1-JavaScript]
var minPatches = function(nums, n) {
    let patches = 0;
    let x = 1;
    const length = nums.length;
    let index = 0;
    while (x <= n) {
        if (index < length && nums[index] <= x) {
            x += nums[index];
            index++;
        } else {
            x *= 2;
            patches++;
        }
    }
    return patches;
};
```

```C++ [sol1-C++]
class Solution {
public:
    int minPatches(vector<int>& nums, int n) {
        int patches = 0;
        long long x = 1;
        int length = nums.size(), index = 0;
        while (x <= n) {
            if (index < length && nums[index] <= x) {
                x += nums[index];
                index++;
            } else {
                x <<= 1;
                patches++;
            }
        }
        return patches;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minPatches(self, nums: List[int], n: int) -> int:
        patches, x = 0, 1
        length, index = len(nums), 0

        while x <= n:
            if index < length and nums[index] <= x:
                x += nums[index]
                index += 1
            else:
                x <<= 1
                patches += 1
        
        return patches
```

```go [sol1-Golang]
func minPatches(nums []int, n int) (patches int) {
    for i, x := 0, 1; x <= n; {
        if i < len(nums) && nums[i] <= x {
            x += nums[i]
            i++
        } else {
            x *= 2
            patches++
        }
    }
    return
}
```

```C [sol1-C]
int minPatches(int* nums, int numsSize, int n) {
    int patches = 0;
    long long x = 1;
    int index = 0;
    while (x <= n) {
        if (index < numsSize && nums[index] <= x) {
            x += nums[index];
            index++;
        } else {
            x <<= 1;
            patches++;
        }
    }
    return patches;
}
```

**复杂度分析**

- 时间复杂度：$O(m+\log n)$，其中 $m$ 是数组 $\textit{nums}$ 的长度，$n$ 是给定的正整数。需要遍历数组中的 $m$ 个元素，以及更新 $x$ 的值，由于 $x$ 的值上限为 $n$，因此对 $x$ 的值乘以 $2$ 的操作不会超过 $\log n$ 次，故时间复杂度是 $O(m+\log n)$。

- 空间复杂度：$O(1)$。只需要使用有限的额外空间。