## [1151.最少交换次数来组合所有的 1 中文官方题解](https://leetcode.cn/problems/minimum-swaps-to-group-all-1s-together/solutions/100000/zui-shao-jiao-huan-ci-shu-lai-zu-he-suo-you-de-1-b)

[TOC] 

 ## 解决方案

---

 #### 概述 

 假设输入数组 `data` 中有 `ones` 个 1，我们需要找到一个长度为 `ones` 的子数组，或窗口，并通过交换 0 将所有 1 放到其中。因此，在所有长度为 `ones` 的窗口中，为找到所需的最少交换次数，我们需要找到窗口中最多的 1 数量以实现通过最少的交换次数达到目标。 

 ![image.png](https://pic.leetcode.cn/1691987236-HVRpnk-image.png){:width=400}

 *图1.查找长度为 `ones` 的子数组并将0与1交换* 


---

 #### 方法 1：滑动窗口与双指针 

 **算法** 

 我们将使用两个指针 `left` 和 `right` 来维护一个长度为 `ones` 的滑动窗口，并在通过输入数组 `data` 检查每个窗口时，我们将计算其中 1 的数量作为 `cnt_one`，并将最大的一个存储为 `max_one`。 

 当窗口通过 `data` 滑动时，我们想保持其长度为 `ones`。同时，我们也想更新窗口中 1 的数量，通过添加新的边界 `data[right]` 并减去左边界 `data[left]`。 

 <![image.png](https://pic.leetcode.cn/1691992100-wZYoqn-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691992110-IzLVSL-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691992114-KIyMYA-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691992117-wpCbhW-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691992120-TWoVNx-image.png){:width=400}>

 ```Java [slu1]
 class Solution {
    public int minSwaps(int[] data) {
        int ones = Arrays.stream(data).sum();
        int cnt_one = 0, max_one = 0;
        int left = 0, right = 0;

        while (right < data.length) {
            // 通过添加新元素更新 1 的数量
            cnt_one += data[right++];
            // 将窗口的长度保持为 ones
            if (right - left > ones) {
                // 通过移除最老的元素来更新 1 的数量
                cnt_one -= data[left++];
            }
            // 记录窗口中 1 的数量的最大值
            max_one = Math.max(max_one, cnt_one);
        }
        return ones - max_one;
    }
}
 ```

 ```Python3 [slu1]
 class Solution:
    def minSwaps(self, data: List[int]) -> int:
        ones = sum(data)
        cnt_one = max_one = 0
        left = right = 0
        while right < len(data):
            # 通过添加新元素更新 1 的数量
            cnt_one += data[right]
            right += 1
            # 将窗口的长度保持为 ones
            if right - left > ones:
                # 通过移除最老的元素来更新 1 的数量
                cnt_one -= data[left]
                left += 1
            # 记录窗口中 1 的数量的最大值
            max_one = max(max_one, cnt_one)
        return ones - max_one
 ```

 **复杂度分析** 

 * 时间复杂度: $\mathcal{O}(n)$，其中 $n$ 是数组的长度。 
 * 空间复杂度: $\mathcal{O}(1)$。

---

 #### 方法 2：使用双端队列的滑动窗口 

 **算法** 

 实现滑动窗口算法的另一种方式是使用双端队列（Deque）。关键思想是通过在其右端添加新元素并从其左端弹出旧元素来维护大小为 `ones` 的双端队列 `deque`。 
 更具体地说，在初始化 `deque` 后，我们会开始在其大小达到 `ones` 之前将元素附加到其右边。当 `deque` 中有 `ones` 个元素时，我们会继续在其右侧添加新元素，我们还会从其中删除最左边的元素，以使其大小始终为 `ones`。在这个过程中，我们可以进行计算这个双端队列中 1 的数量，这与方法 1 类似。 

 ```Java [slu2]
 class Solution {
    public int minSwaps(int[] data) {
        int ones = Arrays.stream(data).sum();
        int cnt_one = 0, max_one = 0;
        // 保持双端队列的长度等于 ones
        Deque<Integer> deque = new ArrayDeque<>();

        for (int i = 0; i < data.length; i++) {

            // 我们总是将新元素添加到双端队列中
            deque.addLast(data[i]);
            cnt_one += data[i];

            // 当双端队列中有超过 1 个元素，
            // 删除最左边的
            if (deque.size() > ones) {
                cnt_one -= deque.removeFirst();;
            }
            max_one = Math.max(max_one, cnt_one);
        }
        return ones - max_one;

    }
}
 ```

 ```Python3 [slu2]
 class Solution {
    public int minSwaps(int[] data) {
        int ones = Arrays.stream(data).sum();
        int cnt_one = 0, max_one = 0;
        // maintain a deque with the size = ones
        Deque<Integer> deque = new ArrayDeque<>();

        for (int i = 0; i < data.length; i++) {

            // 我们总是将新元素添加到双端队列中
            deque.addLast(data[i]);
            cnt_one += data[i];

            // 当双端队列中有超过 1 个元素，
            // 删除最左边的
            if (deque.size() > ones) {
                cnt_one -= deque.removeFirst();;
            }
            max_one = Math.max(max_one, cnt_one);
        }
        return ones - max_one;

    }
}
 ```

 **复杂度分析** 

 * 时间复杂度: $\mathcal{O}(n)$，其中 $n$ 是数组的长度。 请注意，将元素添加到 `deque` 的右端和从其左端弹出元素的时间复杂度都是 $\mathcal{O}(1)$。
 * 空间复杂度: $\mathcal{O}(n)$，当 $n$ 是数组长度时。因为我们需要一个大小为 `ones` 的 `deque`。

---