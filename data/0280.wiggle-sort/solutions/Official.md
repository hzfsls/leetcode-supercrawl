## [280.摆动排序 中文官方题解](https://leetcode.cn/problems/wiggle-sort/solutions/100000/bai-dong-pai-xu-by-leetcode-solution-gv1e)
[TOC]

 ## 解决方案

---

 ### 前言

 我们得到一个整数数组 `nums`。 我们的任务是重新排序，使得 `nums[0] <= nums[1] >= nums[2] <= nums[3]...`。

---

 ### 方法 1：排序

 #### 思路

 我们的任务是以这样一种方式重新排序给定的数组，使得每个在奇数索引处的元素大于或等于其在偶数索引处的两个相邻元素。

 一种直观的方法是对 `nums` 数组进行排序，然后对每个在奇数索引处的元素，例如 `i`，我们与其在索引 `i + 1` 的相邻元素进行交换。

 让我们通过一个例子来更好地理解。 假设我们有一个排序后的数组，其中有以下五个元素：`[a, b, c, d, e]`。 由于数组是排序的，我们有 `a <= b <= c <= d <= e`。 我们将在奇数索引处的第一个元素（基于0的索引），即在索引1处的 `b`，与其相邻的元素 `c` 进行互换。 由于 `a <= b` 并且 `b <= c`，我们得到 `a <= c`。 此外，`b <= c` 并且 `c <= d`，所以 `b <= d`。 交换 `b` 和 `c` 后，数组的顺序为 `a <= c >= b <= d <= e`。 `a, b, c` 是交替排序的。 我们移到下一个在奇数索引处的元素，也就是索引3处的 `d`，并将其与 `e` 交换。 由于 `b <= d` 并且 `d <= e`，我们有 `b <= e`。 数组的顺序现在变为 `a <= c >= b <= e >= d`，这是一个波动排序的数组。 请注意，互换 `d` 和 `e` 保留了对 `a, b, c` 的交替排序。

 #### 算法

 1. 对 `nums` 数组进行排序。 
 2. 从索引 `i = 1` 开始遍历 `nums` 的每一个奇数索引，直到 `nums.length - 2`。我们实际上是只迭代到倒数第二个元素，因为最后一个元素没有下一个元素可以用来交换。我们以2为单位增加索引，以便只在奇数索引上移动。  
    - 将奇数索引 `i` 处的元素与索引 `i + 1` 处的相邻元素进行交换。


 #### 实现

 ```C++ [slu1]
class Solution {
public:
    void swap(int& a, int& b) {
        int temp = a;
        a = b;
        b = temp;
    }

    void wiggleSort(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        for (int i = 1; i < nums.size() - 1; i += 2) {
            swap(nums[i], nums[i + 1]);
        }
    }
};
 ```

```Java [slu1]
class Solution {
    public void swap(int[] nums, int i, int j) {
        int temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }

    public void wiggleSort(int[] nums) {
        Arrays.sort(nums);
        for (int i = 1; i < nums.length - 1; i += 2) {
            swap(nums, i, i + 1);
        }
    }
}
```


 #### 复杂度分析

 设 `nums` 的大小为 $n$。

 * 时间复杂度：$O(n \cdot \log(n))$
    - 对 `nums` 进行排序所需的时间是 $O(n \cdot \log(n))$。  
    - 我们以 $O(n)$ 时间遍历所有奇数索引，然后用 `swap` 方法以 $O(1)$ 时间/最大操作交换每个奇数索引元素与其下一个相邻元素。
 * 空间复杂度：$O(1)$
    - 对于排序，我们使用的算法决定了空间。然而，像堆排序这样的排序算法需要 $O(1)$ 空间。  
    - 除了几个整数 `i`，`j` 和 `temp`，我们不需要任何空间。

---

 ### 方法 2：贪心

 #### 思路

 正如我们所知，每个奇数位置应该大于或等于其两个相邻的偶数位置。对于任何奇数索引 `i`，我们需要确保 `nums[i-1] <= nums[i]` 且 `nums[i+1] <= nums[i]`。

 让我们来看一个例子。假设，我们有一个 `nums` 数组，它有五个元素。如果 `nums[0] <= nums[1]` ，那么前两个元素已经是交替排序的。在这种情况下，我们不需要进行任何操作，直接移动到下一个元素。否则，如果 `nums[0] > nums[1]`，我们会交换 `nums[0]` 和 `nums[1]`。

 现在，我们继续处理下一个元素，`nums[2]`。目前为止，我们有 `nums[0] <= nums[1]`。如果 `nums[1] >= nums[2]`，那么 `nums` 的前三个元素已经按照交替排序的方式排列。否则，如果 `nums[1] < nums[2]`，那就意味着 `nums[0] < nums[2]`（因为 `nums[0] <= nums[1]`）。我们交换 `nums[1]` 和 `nums[2]`，这样 `nums` 的顺序就按照 `nums[0] <= nums[1] >= nums[2]` 进行排序，也就是交替排序的顺序。注意，第二次交换对 `nums[0]` 没有影响。

 现在，我们得到了以下结果：`nums[0] <= nums[1] >= nums[2]`，在所有必要的交换后，`nums[3]` 是我们的下一个元素。如果 `nums[2] <= nums[3]`，元素已经是交替排序的。否则，如果 `nums[2] > nums[3]`，那就意味着 `nums[1] > nums[3]`（因为 `nums[1] >= nums[2]`）。我们交换 `nums[2]` 和 `nums[3]`，以使数组按 `nums[0] <= nums[1] >= nums[2] <= nums[3]` 的顺序排列，这是一个交替排序的数组。同样，注意在这第三次交换中，直到第二个元素，`nums[1]` 的数组没有受到影响。它保留了直到 `nums[1]` 的交替排序属性。

 类似地，我们可以添加 `nums[4]` 并观察到，直到第三个元素的数组没有受到影响，保留了交替属性。

 我们在上面的例子中观察到的模式是，位于索引0和2的元素（即位于偶数索引的元素）如果大于下一个相邻元素，就会与下一个相邻元素交换。同样，我们在上面的例子中看到，在索引 1 和 3（即位于奇数索引的元素）的元素如果小于下一个相邻元素，就会与下一个相邻元素交换。该例子还显示，对于任何数组，我们总能将其排列成交替排序的顺序。

 这就引出了我们的解决方案。我们贪婪地检查每个索引 `i`。如果 `i` 是偶数，`nums[i]` 应该小于或等于 `nums[i + 1]`。如果它更大，即 `nums[i] > nums[i + 1]`，我们交换 `nums[i]` 和 `nums[i + 1]`。

 同样，如果 `i` 是奇数，`nums[i]` 应该大于或等于 `nums[i + 1]`。如果它更小，即 `nums[i] < nums[i + 1]`，我们交换 `nums[i]` 和 `nums[i + 1]`。

 这里有一个例子：

 ![image.png](https://pic.leetcode.cn/1691734943-Yvvyom-image.png){:width=600}

 #### 步骤

 1. 从 0 开始，到 `nums.length - 2`，迭代遍历 `nums` 中的每个元素，因为最后一个元素没有下一个可以交换的元素。 
 2. 检查是否 `i` 是偶数且 `nums[i] > nums[i + 1]`。 如果是，交换 `nums[i]` 和 `nums[i + 1]`。 
 3. 检查是否 `i` 是奇数且 `nums[i] < nums[i + 1]`。 如果是，交换 `nums[i]` 和 `nums[i + 1]`。

 #### 实现

 ```C++ [slu2]
class Solution {
public:
    void swap(vector<int>& nums, int i, int j) {
        int temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }

    void wiggleSort(vector<int>& nums) {
        for (int i = 0; i < nums.size() - 1; i++) {
            if (((i % 2 == 0) && nums[i] > nums[i + 1]) ||
                ((i % 2 == 1) && nums[i] < nums[i + 1])) {
                swap(nums, i, i + 1);
            }
        }
    }
};
 ```

```Java [slu2]
class Solution {
    public void swap(int[] nums, int i, int j) {
        int temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }

    public void wiggleSort(int[] nums) {
        for (int i = 0; i < nums.length - 1; i++) {
            if (((i % 2 == 0) && nums[i] > nums[i + 1])
                    || ((i % 2 == 1) && nums[i] < nums[i + 1])) {
                swap(nums, i, i + 1);
            }
        }
    }
}
```


 #### 复杂度分析

 设 `nums` 的大小为 $n$。

 * 时间复杂度：$O(n)$
    - 我们以 $O(n)$ 时间遍历每一个 `nums` 元素，并在必要时用 `swap` 方法以 $O(1)$ 时间/次 最大操作交换当前元素与下一个元素。

 * 空间复杂度：$O(1)$
    - 除了几个整数 `i`，`j` 和 `temp`，我们不需要任何其他空间。