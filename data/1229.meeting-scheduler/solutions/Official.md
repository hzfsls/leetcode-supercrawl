## [1229.安排会议日程 中文官方题解](https://leetcode.cn/problems/meeting-scheduler/solutions/100000/an-pai-hui-yi-ri-cheng-by-leetcode-solut-j8cf)
[TOC]

 ## 解决方案

---

 #### 概述

 为了找到适合两个人的最早的时间段，最直接的方法是查看他们所有可能的时间段。我们可以排序两个输入数组并使用两个指针，或者我们可以使用一个堆来排序时间段并找到最早的重叠时间段。我们将在本文中介绍这两种方法。

---

 #### 方法 1：双指针

 **思路**

 ![image.png](https://pic.leetcode.cn/1691737073-PeCvBs-image.png){:width=600}
 *图1.两个时间段之间的公共时间段。*

 我们想要按开始时间对 `slots1` 和 `slots2` 进行排序，然后初始化两个指针，每个指针指向两个数组的开始。从那里，我们将比较两个时间段，并且如果公共时间段小于 `duration`，我们将一次移动一个指针。

 >注意，按开始时间和结束时间排序是一样的，这是因为，如果一个时间段开始得早，那么它结束得也会早。记住，对于两个人，他们没有重叠的时间段。

 问题来了：我们如何决定应该增加哪个指针？
 答案是：我们总是移动那个结束时间较早的。假设我们正在比较 `slots1[i]` 和 `slots2[j]` 并且 `slots1[i][1] > slots2[j][1]`，我们总是选择移动 `j` 指针。原因是，因为两个时间段都是排序的，如果 `slots1[i][1] > slots2[j][1]`，我们知道 `slots1[i+1][0] > slots2[j][1]` ，所以 `slots1[i+1]` 和 `slots2[j]` 之间不会有交集。

 ![image.png](https://pic.leetcode.cn/1691737176-XjiqOi-image.png){:width=600}
 *图2.总是移动那个结束时间早的。*

 **算法**

 - 按开始时间对 `slots1` 和 `slots2` 进行排序。 
 - 初始化两个指针 `pointer1` 和 `pointer2`，分别指向 `slots1` 和 `slots2` 的开始。 
 - 迭代，直到 `pointer1` 到达 `slots1` 的结束或 `pointer2` 到达 `slots2` 的结束：  
 - 找到 `slots1[pointer1]` 和 `slots2[pointer2]` 的公共时间段。  
 - 如果公共时间段大于或等于 `duration`，返回结果。  
 - 否则，找到结束时间较早的时间段并移动指针。 
 - 如果没有找到公共时间段，返回一个空数组。

 **代码实现**

 ```Java [slu1]
class Solution {
    public List<Integer> minAvailableDuration(int[][] slots1, int[][] slots2, int duration) {
        Arrays.sort(slots1, (a, b) -> a[0] - b[0]);
        Arrays.sort(slots2, (a, b) -> a[0] - b[0]);

        int pointer1 = 0, pointer2 = 0;

        while (pointer1 < slots1.length $$ pointer2 < slots2.length) {
            // 找出交集的边界，或者通用的时间段。
            int intersectLeft = Math.max(slots1[pointer1][0], slots2[pointer2][0]);
            int intersectRight = Math.min(slots1[pointer1][1], slots2[pointer2][1]);
            if (intersectRight - intersectLeft >= duration) {
                return new ArrayList<Integer>(Arrays.asList(intersectLeft, intersectLeft + duration));
            }
            // 始终移动那个结束时间较早的时间段
            if (slots1[pointer1][1] < slots2[pointer2][1]) {
                pointer1++;
            } else {
                pointer2++;
            }
        }
        return new ArrayList<Integer>();
    }
}
 ```

```Python3 [slu1]
class Solution:
    def minAvailableDuration(self, slots1: List[List[int]], slots2: List[List[int]], duration: int) -> List[int]:

        slots1.sort()
        slots2.sort()
        pointer1 = pointer2 = 0

        while pointer1 < len(slots1) and pointer2 < len(slots2):
            # 找出交集的边界，或者通用的时间段
            intersect_right = min(slots1[pointer1][1], slots2[pointer2][1])
            intersect_left = max(slots1[pointer1][0],slots2[pointer2][0])
            if intersect_right - intersect_left >= duration:
                return [intersect_left, intersect_left + duration]
            # 始终移动那个结束时间较早的时间段
            if slots1[pointer1][1]< slots2[pointer2][1]:
                pointer1 += 1
            else:
                pointer2 += 1
        return []
```


 **复杂度分析**

 * 时间复杂度： $O(M \log M + N \log N)$，当$M$是 `slots1` 的长度，$N$是 `slots2` 的长度。
   排序两个数组会花费 $O(M \log M + N \log N)$.两个指针花费 $O(M + N)$，因为在每次迭代中，我们会访问一个新的元素，总共有 $M+N$ 个元素。综合这些，总时间复杂度是 $O(M \log M + N \log N)$。
 * 空间复杂度: $O(1)$. 这是因为我们没有使用任何额外的数据结构；我们只使用了一些固定大小的整数变量。

---

 #### 方法 2：堆

 **思路**
 系统选择和比较时间段的另一种方法是使用堆。我们将初始化一个堆 `timeslots` 并将所有的时间段推入其中。
 这里的关键思想是 **我们只需要一个堆**。也就是说，我们可以将两个人的时间段放入同一个堆中，然后如果我们找到一个公共的时间段，我们就知道这两个时间段不可能是同一个人的。在阅读这个论述之前，自己想一想为什么我们可以得出这样一个大胆的结论。
 问题描述中提到，一个人的时间段不会重叠。这意味着如果，比如，我们有时间段 `[10, 15]` 和 `[14, 20]`，那么我们*知道*这些时间段*不能是同一个人的*。否则，我们就会有一个矛盾。所以，给定一个公共的时间段必须重叠，则两个时间段必须来自不同的人。
 堆总是先返回最小的项目。因此，我们从堆中移除的时间段是按开始时间排序的。利用这个特性，我们可以按时间的顺序比较时间段。

 ![image.png](https://pic.leetcode.cn/1691738490-nkFiQA-image.png){:width=600}
 *图3.比较弹出的时间段和堆顶的元素。*

 **算法**

 - 初始化一个堆 `timeslots` 并把持续时间比 `duration` 长的时间段推进去。 
 - 迭代，直到 `timeslots` 中只剩一个时间段：  
 - 从 `timeslots` 中弹出第一个时间段 `[start1, end1]` 。  
 - 取得下一个时间段 `[start2, end2]`这是 `timeslots` 中当前的顶元素。  
 - 如果我们发现 `end1 >= start2 + duration` ，因为 `start1 <= start2` ，公共的时间段比 `duration` 长，我们就可以返回它。 - 如果我们找不到比 `duration` 长的公共时间段，返回一个空数组。

**实现**

 ```Java [slu2]
class Solution {
    public List<Integer> minAvailableDuration(int[][] slots1, int[][] slots2, int duration) {
        PriorityQueue<int[]> timeslots = new PriorityQueue<>((slot1, slot2) -> slot1[0] - slot2[0]);

        for (int[] slot: slots1) {
            if (slot[1] - slot[0] >= duration) timeslots.offer(slot);
        }
        for (int[] slot: slots2) {
            if (slot[1] - slot[0] >= duration) timeslots.offer(slot);
        }

        while (timeslots.size() > 1) {
            int[] slot1 = timeslots.poll();
            int[] slot2 = timeslots.peek();
            if (slot1[1] >= slot2[0] + duration) {
                return new ArrayList<Integer>(Arrays.asList(slot2[0], slot2[0] + duration));
            }
        }
        return new ArrayList<Integer>();
    }
}
 ```

```Python3 [slu2]
class Solution:
    def minAvailableDuration(self, slots1: List[List[int]], slots2: List[List[int]], duration: int) -> List[int]:
        # 构建一个包含持续时间长于持续时间的时隙的堆
        timeslots = list(filter(lambda x: x[1] - x[0] >= duration, slots1 + slots2))
        heapq.heapify(timeslots)

        while len(timeslots) > 1:
            start1, end1 = heapq.heappop(timeslots)
            start2, end2 = timeslots[0]
            if end1 >= start2 + duration:
                return [start2, start2 + duration]
        return []
```

 **复杂度分析**

 * 时间复杂度：$O((M+N) \log (M+N))$，当 $M$ 是 `slots1` 的长度，$N$ 是 `slots2` 的长度。
   有两部分需要分析：
   1. 建堆；
   2. 我们在堆中不断弹出元素的迭代。对于第二部分，弹出一个元素需要 $O(\log(M + N))$ ，因此，在最坏的情况下，弹出 $M + N$ 个元素需要 $O((M+N) \log (M+N))$。
       关于第一部分，对于 Java 和 Python 实现，我们有不同的答案。对于 Python，`heapq.heapify` 可以将列表在原地，以线性时间，转化为一个堆；然而，在 Java 中，我们选择将每个元素推入堆中，这导致了时间复杂度为 $O((M+N) \log (M+N))$。需要注意的是，使用 `PriorityQueue` 的构造函数，我们可以将数组在线性时间内转化为堆；然而，这不会影响总的时间复杂度，也会让它变得不易读。
       当我们将这两部分放在一起时，总时间复杂度为 $O((M+N) \log (M+N))$，主要由第一部分决定。
 * 空间复杂度：$O(M+N)$。这是因为我们在堆中存储了所有的 $M+N$ 个时间段。
   <br/>

---