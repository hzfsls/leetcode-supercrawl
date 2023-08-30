### 📺 视频题解

![1095. 山脉数组中查找目标值.mp4](d7e78ecf-4b0a-458e-a6d6-cb95008ab63e)

### 📖 文字题解
#### 方法一：二分查找

**思路**

显然，如果山脉数组是一个单调递增或者单调递减的序列，那么我们可以通过二分法迅速找到目标值。

而现在题目中有一个单调递增序列（峰值左边）和一个单调递减序列（峰值右边），我们只是不知道两个序列的分割点，即峰值在哪里。所以我们第一步应该首先找到峰值。

而峰值也可以使用二分法寻找：

对于一个范围 `[i, j]`，我们可以先找到范围 `[i, j]` 中间连续的两个点 `mid` 与 `mid + 1`。如果 `mountainArr.get(mid + 1) > mountainArr.get(mid)`，那么可以知道峰值在范围 `[mid + 1, j]` 内；如果 `mountainArr.get(mid + 1) < mountainArr.get(mid)`，那么可以知道峰值在范围 `[i, mid]` 内。通过这样的方法，我们可以在 $O(\log n)$ 的时间内找到峰值所处的下标。

![fig1](https://assets.leetcode-cn.com/solution-static/1095/1095_fig1.png)

这个方法的正确性在于我们二分的目标是相邻位置数的差值，我们每次判断的是 `mountainArr.get(mid + 1) - mountainArr.get(mid)` 与 `0` 的大小关系。这个差值组成的数组保证了单调递增的部分差值均为正数，单调递减的部分差值均为负数，整个数组呈现 `[正数，正数，正数，...，负数，负数]` 这样前半部分均为正数，后半部分均为负数的性质，满足单调性，因此我们可以使用二分查找。

以示例 1 为例，我们对整个数组进行差分，即除了第一个数每个数都减去前一个数得到新的数组，最终我们得到 `[1, 1, 1, 1, -2, -2]`，整个差分数组满足单调性，可以应用二分法。

接下来我们只需要使用二分法在单调序列中找到目标值即可，注意二分法要使用两次，为了编码简洁可以将二分法封装成函数。

**算法**

- 先使用二分法找到数组的峰值。

- 在峰值左边使用二分法寻找目标值。

- 如果峰值左边没有目标值，那么使用二分法在峰值右边寻找目标值。

```C++ [sol1-C++]
class Solution {
    int binary_search(MountainArray &mountain, int target, int l, int r, int key(int)) {
        target = key(target);
        while (l <= r) {
            int mid = (l + r) / 2;
            int cur = key(mountain.get(mid));
            if (cur == target) {
                return mid;
            } else if (cur < target) {
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
        return -1;
    }
public:
    int findInMountainArray(int target, MountainArray &mountainArr) {
        int l = 0, r = mountainArr.length() - 1;
        while (l < r) {
            int mid = (l + r) / 2;
            if (mountainArr.get(mid) < mountainArr.get(mid + 1)) {
                l = mid + 1;
            } else {
                r = mid;
            }
        }
        
        int peak = l;
        int index = binary_search(mountainArr, target, 0, peak, [](int x) -> int{return x;});
        if (index != -1) {
            return index;
        }
        return binary_search(mountainArr, target, peak + 1, mountainArr.length() - 1, [](int x) -> int{return -x;});
    }
};
```
```Java [sol1-Java]
class Solution {
    public int findInMountainArray(int target, MountainArray mountainArr) {
        int l = 0, r = mountainArr.length() - 1;
        while (l < r) {
            int mid = (l + r) / 2;
            if (mountainArr.get(mid) < mountainArr.get(mid + 1)) {
                l = mid + 1;
            } else {
                r = mid;
            }
        }
        int peak = l;
        int index = binarySearch(mountainArr, target, 0, peak, true);
        if (index != -1) {
            return index;
        }
        return binarySearch(mountainArr, target, peak + 1, mountainArr.length() - 1, false);
    }

    public int binarySearch(MountainArray mountainArr, int target, int l, int r, boolean flag) {
        if (!flag) {
            target *= -1;
        }
        while (l <= r) {
            int mid = (l + r) / 2;
            int cur = mountainArr.get(mid) * (flag ? 1 : -1);
            if (cur == target) {
                return mid;
            } else if (cur < target) {
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
        return -1;
    }
}
```
```Python [sol1-Python3]
def binary_search(mountain, target, l, r, key=lambda x: x):
    target = key(target)
    while l <= r:
        mid = (l + r) // 2
        cur = key(mountain.get(mid))
        if cur == target:
            return mid
        elif cur < target:
            l = mid + 1
        else:
            r = mid - 1
    return -1

class Solution:
    def findInMountainArray(self, target: int, mountain_arr: 'MountainArray') -> int:
        l, r = 0, mountain_arr.length() - 1
        while l < r:
            mid = (l + r) // 2
            if mountain_arr.get(mid) < mountain_arr.get(mid + 1):
                l = mid + 1
            else:
                r = mid
        peak = l
        index = binary_search(mountain_arr, target, 0, peak)
        if index != -1:
            return index
        index = binary_search(mountain_arr, target, peak + 1, mountain_arr.length() - 1, lambda x: -x)
        return index
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，我们进行了三次二分搜索，每次的时间复杂度都为 $O(\log n)$。

- 空间复杂度：$O(1)$，只需要常数的空间存放若干变量。