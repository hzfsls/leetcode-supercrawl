[TOC] 

 ## 解决方案

---

 #### 方法 1：线性搜索 

 **概述** 

 我们可以通过从开始到结束线性扫描数组来寻找缺失的数字。由于我们被告知无法移除第一个和最后一个数字，我们可以使用这两个数字来求得每对连续元素之间需要的差值。 

 $\text{difference} = \dfrac{\text{last value} - \text{first value}}{\text{number of values}}$ 
 一旦我们得到了差值，我们就可以知道每个索引的值应该是什么。使用上面计算的`difference`，并定义`initial`是索引 0 的值，我们有以下等式： 
 $\text{index 0} = \text{initial} \\  \text{index 1} = \text{initial} + \text{difference} \\  \text{index 2} = \text{initial} + 2 \cdot \text{difference} \\  \text{index 3} = \text{initial} + 3 \cdot \text{difference} \\  \dots \\  \text{index n} = \text{initial} + \text{n} \cdot \text{difference}$ 

 让我们用这个方法来找出等差数列中第一个缺失的值。 

 **算法步骤** 

 1. 使用第一个元素和最后一个元素获取 `difference` 的值，`difference = last_value - first_value / number_of_values`。
 2. 以第一个元素为预期值 `expected = first_element` 开始。
 3. 从第一个值运行到最后一个值，检查当前值是否等于 `expected`。如果不是，那么在下一次迭代中将 `difference` 增加到 `expected`。
 4. 返回数组中与该值不匹配的第一个 `expected` 值。 

 ```C++ [slu1]
 class Solution {
public:
    int missingNumber(vector<int> &arr) {
        int n = arr.size();

        // 1. 获取差值 `difference`.
        int difference = (arr.back() - arr.front()) / n;

        // 2. 预期元素等于起始元素。
        int expected = arr.front();

        for (int &val : arr) {
            // 返回与val不匹配的期望值。
            if (val != expected) return expected;

            // 下一个元素将是预期元素+`difference`。
            expected += difference;
        }
        return expected;
    }
};
 ```

 ```Java [slu1]
 class Solution {
    public int missingNumber(int[] arr) {
        int n = arr.length;

        // 获取差值 `difference`.
        int difference = (arr[arr.length - 1] - arr[0]) / n;

        // 预期元素等于起始元素。
        int expected = arr[0];

        for (int val : arr) {
            // 返回与val不匹配的期望值。
            if (val != expected) return expected;

            // 下一个元素将是预期元素+`difference`。
            expected += difference;
        }
        return expected;
    }
}
 ```

 **复杂度分析** 

 * 时间复杂度： $O(n)$。其中 $n$ 是数组 `arr` 的长度，因为在最坏的情况下，我们迭代整个数组。 
 * 空间复杂度： $O(1)$。算法执行需要恒定的空间。 

---

 #### 方法 2：二分查找 

 **概述** 
 在之前的方法中我们看到，我们可以得到任何索引处的所需值。让我们试着使用这个属性来二分查找缺失的值。 
 我们知道在给定的数列中只缺失一个数字。在任何索引 `i`，我们可以通过将 `difference` 乘以 `i` 加到列表中的第一个值，然后将其与索引 `i` 处的值进行比较，来判断索引 `i` 处的值是否位于正确的位置。如果它们匹配，就意味着缺失的值在 `i` 的右边，否则就在 `i` 的左边或者就在 `i`。 
 我们可以利用这个事实使用二分查找找到第一个正确的数字的索引，因为如果 `i` 是第一个正确数字的索引，那么所有索引跟在 `i` 之后的都会在错误的位置（它们应该在更远的位置，因为缺少一个数），而所有在索引 `i` 之前的数字都会在正确的位置。这个特性是二分查找可能的。 

 **算法步骤** 

 1. 使用第一个元素和最后一个元素获取 `difference` 的值，`difference = last_value - first_value / number_of_values`。 
 2. 在左索引 `lo = 0` 和右索引 `hi = arr.size() - 1` 开始。
 3. 选择一个中间点索引 `mid = (lo + hi) / 2`。
 4. 如果 `arr[mid] == first_element + mid * difference`。那么在 `mid` 右边进行二分查找，否则在 `mid` 左边（包括 `mid` 本身）进行二分查找。 
 5. 当只剩下一个索引时结束，因为这将是第一个值错误的索引。
 6. 返回这个索引应该有的值，这将是 `first_element + difference * index`。

 ```C++ [slu2]
 class Solution {
public:
    int missingNumber(vector<int> &arr) {
        int n = arr.size();

        // 获取差值 `difference`.
        int difference = (arr.back() - arr.front()) / n;
        int lo = 0;
        int hi = n - 1;

        // 二分查找模版。
        while (lo < hi) {
            int mid = (lo + hi) / 2;

            // 所有数字中没有遗漏的数字，所以在右边搜索。
            if (arr[mid] == arr.front() + mid * difference) {
                lo = mid + 1;
            }

            // ‘mid`前缺少一个数字，包括 `mid` 本身。
            else {
                hi = mid;
            }
        }

        // 索引 `lo` 将是第一个数字错误的位置。
        // 返回应该位于此索引处的值。
        return arr.front() + difference * lo;
    }
};
 ```

 ```Java [slu2]
 class Solution {
    public int missingNumber(int arr[]) {
        int n = arr.length;

        // 1. 获取差值 `difference`.
        int difference = (arr[n - 1] - arr[0]) / n;
        int lo = 0;
        int hi = n - 1;

        // 二分查找模版。
        while (lo < hi) {
            int mid = (lo + hi) / 2;

            // 所有数字中没有遗漏的数字，所以在右边搜索。
            if (arr[mid] == arr[0] + mid * difference) {
                lo = mid + 1;
            }

            // ‘mid`前缺少一个数字，包括 `mid` 本身。
            else {
                hi = mid;
            }
        }

        // 索引 `lo` 将是第一个数字错误的位置。
        // 返回应该位于此索引处的值。
        return arr[0] + difference * lo;
    }
}
 ```

 **复杂度分析** 

 * 时间复杂度： $O(\log n)$。其中 $n$ 是数组 `arr` 的长度，因为我们在每次迭代时都会将搜索空间减半。 
 * 空间复杂度： $O(1)$。算法执行需要恒定的空间。