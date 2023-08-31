## [253.会议室 II 中文官方题解](https://leetcode.cn/problems/meeting-rooms-ii/solutions/100000/hui-yi-shi-ii-by-leetcode-solution-fzxq)

[TOC]


 ## 解决方案

---

 **概述**
 这个问题公司员工可能是每天都会遇到的一个问题。
 假设你在一家公司工作，你属于 IT 部门，你的工作职责之一就是确保会议室得到保障。
 你们办公室有许多会议室，你想要正确地使用它们。你不想让人们等待，想要让一个员工团队在正好的时间里进行会议。
 与此同时，你并不想使用太多的房间，除非绝对有必要。只有在会议时间冲突的情况下，才会在不同的房间进行会议，否则你想使用尽可能少的房间来举行所有的会议。你会怎么做呢？
 刚才描述了一个在办公室常见的场景，给出了整天需要举行的会议的开始和结束时间，你作为一个 IT 高手，需要为不同的团队设置和分配房间号。
 让我们从一群想要召开会议但还没有被分配房间的人的角度来看待这个问题。他们会怎么做呢？
 >这个团队会从一个房间走到另一个房间，看看有没有会议室是空闲的。如果他们发现一个房间确实是空闲的，他们就会在那个房间开始他们的会议。否则，他们会等待一个房间空闲出来。一旦房间空闲出来，他们就会占用它。

 这就是我们在这个问题上要遵循的基本方法。因此，它可以被看作是一种模拟，但又不完全是。在最坏的情况下，我们可以为所有的会议分配一个新的房间，但这并不真正合理，对吧？除非他们都和其他会议时间冲突。
 >我们需要能够有效地找出一个房间是可用的还是不可用的，只有在没有被分配的房间当前是空闲的情况下才分配一个新的房间。

 让我们看看第一种基于我们刚才讨论的解决方法。 

---

 #### 方法 1：优先队列

 我们不能在任意顺序处理给定的会议。处理会议的最基本方法是以其“开始时间”的增加顺序处理，这是我们将遵循的顺序。毕竟，安排一个在早上 9 点举行的会议在下午 5 点的会议之前是有道理的，对吗？
 让我们以样本会议时间来做一个例题的演练，看看我们的算法应该能够有效地做什么。
 我们将考虑以下会议时间作为我们的例子 `(1, 10), (2, 7), (3, 19), (8, 12), (10, 20), (11, 30)`。元组的第一部分是会议的开始时间，第二个值表示结束时间。我们按照开始时间的排序顺序来考虑会议。第一个图显示了前三个会议，它们需要单独的房间来进行，因为它们的时间会相互冲突。

![image.png](https://pic.leetcode.cn/1692067979-MLKSie-image.png){:width=600}

 接下来的三次会议开始占用一些已有的房间。然而，最后一个需要一个全新的房间，总的来说我们有四个不同的房间可以容纳所有的会议。

![image.png](https://pic.leetcode.cn/1692069713-XRRqvj-image.png){:width=600}

 排序部分很容易，但对于每个会议，我们如何高效地找出一个房间是否可用呢？在任何时间点，我们都可能有多个房间可以占用，我们并不真正关心哪个房间是空闲的，只要我们找到一个就行。

 一个检查房间是否可用的简单方法是遍历所有的房间，看看是否有一个房间是空闲的。
 >然而，我们可以通过优先级队列或最小堆数据结构来做得更好。

 不是手动遍历每个已分配的房间并检查房间是否可用，我们可以将所有的房间放在一个最小堆中，其中最小堆的键是会议的结束时间。
 因此，每次我们想要检查 **任何** 房间是否空闲时，只需要检查最小堆顶部的元素，因为这将是当前占用的所有其他房间中最早空闲的房间。
 如果从最小堆顶部提取的房间不空闲，那么 `没有其他房间是空闲的`。所以我们在这里可以节省时间，只需分配一个新的房间。
 让我们看看算法，然后再看看实现。

 **算法实现**

 1. 按其`开始时间`对给定的会议进行排序。 
 2. 初始化一个新的`min-heap`并将第一个会议的结束时间添加到堆中。我们只需要跟踪结束时间，因为这告诉我们什么时候一个会议室会空闲。
 3. 对于每个会议室，检查堆的最小元素即堆顶的房间是否空闲。  
    1. 如果房间是空闲的，那么我们提取最顶部的元素并加入当前正在处理的会议的结束时间。
    2. 如果不是，那么我们分配一个新的房间并将其添加到堆中。 
 4. 处理完所有的会议后，堆的大小会告诉我们分配了多少个房间。这将是容纳所有会议所需的最小房间数。

 下面让我们看看这个算法的实现。

 ```Java [slu1]
 class Solution {
    public int minMeetingRooms(int[][] intervals) {
        
    // 检查基本情况。如果没有间隔，返回 0
    if (intervals.length == 0) {
      return 0;
    }

    // 最小堆
    PriorityQueue<Integer> allocator =
        new PriorityQueue<Integer>(
            intervals.length,
            new Comparator<Integer>() {
              public int compare(Integer a, Integer b) {
                return a - b;
              }
            });

    // 根据开始时间排序会议
    Arrays.sort(
        intervals,
        new Comparator<int[]>() {
          public int compare(final int[] a, final int[] b) {
            return a[0] - b[0];
          }
        });

    // 添加第一场会议
    allocator.add(intervals[0][1]);

    // 遍历剩余会议
    for (int i = 1; i < intervals.length; i++) {

      // 如果最早应该腾出的房间是空闲的，则将该房间分配给本次会议。
      if (intervals[i][0] >= allocator.peek()) {
        allocator.poll();
      }

      // 如果要分配一个新房间，那么我们也要添加到堆中，
      // 如果分配了一个旧房间，那么我们还必须添加到具有更新的结束时间的堆中。
      allocator.add(intervals[i][1]);
    }

    // 堆的大小告诉我们所有会议所需的最小房间。
    return allocator.size();
  }
}
 ```

 ```Python [slu1]
 class Solution:
    def minMeetingRooms(self, intervals: List[List[int]]) -> int:
        
        # 如果没有要安排的会议，则不需要分配房间。
        if not intervals:
            return 0

        # 堆初始化
        free_rooms = []

        # 按会议开始时间的升序对会议进行排序。
        intervals.sort(key= lambda x: x[0])

        # 添加第一次会议。我们得给第一次会议腾出一间新房间。
        heapq.heappush(free_rooms, intervals[0][1])

        # 对于所有剩余的会议室
        for i in intervals[1:]:

            # 如果最早应该腾出的房间是空闲的，则将该房间分配给本次会议。
            if free_rooms[0] <= i[0]:
                heapq.heappop(free_rooms)

            # 如果要分配一个新房间，那么我们也要添加到堆中，
            # 如果分配了一个旧房间，那么我们还必须添加到具有更新的结束时间的堆中。
            heapq.heappush(free_rooms, i[1])

        # 堆的大小告诉我们所有会议所需的最小房间。
        return len(free_rooms)
 ```

 **复杂性分析**

 * 时间复杂性：$O(N\log N)$。
    - 这里有两个主要部分需要花费时间。一是 `排序` 的部分，考虑到数组包含了 $N$ 个元素，所以时间复杂度为 $O(N\log N)$。
    - 然后我们还有 `min-heap`。在最坏的情况下，所有 $N$ 个会议会相互冲突。无论如何，我们需要在堆中添加 $N$ 个操作。在最坏的情况下，我们还会有 $N$ 个提取最小值的操作。总体来说，复杂性为 $(NlogN)$，因为在堆上进行提取最小值操作需要 $O(\log N)$。

 * 空间复杂性：$O(N)$，因为我们构建了 `min-heap`，并且在最坏的情况下，它可能包含 $N$ 个元素，就像我们在时间复杂性部分描述的那样。因此，空间复杂性为 $O(N)$。 


---

 #### 方法 2：按时间顺序排序

 **概述**

 会议时间给我们定义了一天中活动的时间顺序。我们得到的是每个会议的开始和结束时间，这可以帮助我们定义这个顺序。
 按照会议的开始时间进行排列可以帮助我们了解一天之内的会议的自然顺序。然而，仅仅知道会议开始的时间并不能告诉我们会议的时长。
 我们还需要按结束时间来排序会议，因为会议的结束事件本质上表示肯定有一次相应的开始事件，更重要的是，会议结束表示一个之前被占用的房间现在已经空闲。
 一个会议由它的开始时间和结束时间来定义。然而，对于这个特定的算法，我们需要将开始时间和结束时间 `单独处理`。这可能一开始不太清楚，因为一个会议由它的开始时间和结束时间来定义。如果我们分开处理它们，并对两者进行个别处理，那么会议的身份就会消失。这是没问题的，因为：
 >当我们遇到一个结束事件时，这意味着稍早开始的某个会议现在已经结束了。我们并不真正关心结束的是哪个会议。我们需要的只是 **某个** 会议已经结束，因此一个房间已经变得可用。

 让我们考虑跟上一个方法一样的例子。我们有以下会议需要安排：`(1, 10), (2, 7), (3, 19), (8, 12), (10, 20), (11, 30)`。和之前一样，第一个图显示了前三个会议，它们需要单独的房间来进行，因为它们的时间会相互冲突。
 ![image.png](https://pic.leetcode.cn/1692070437-MYMjFx-image.png){:width=600}
 接下来的两个图显示了剩下的会议的处理过程，我们看到我们现在可以重用一些现有的会议室。最终的结果是一样的，我们需要4个不同的会议室来处理所有的会议。这是我们能做到的最好的结果。
 ![image.png](https://pic.leetcode.cn/1692070584-iZHWAj-image.png){:width=600}
 ![253_Meeting_Rooms_II_Diag_5.png](https://pic.leetcode.cn/1692070614-PYFvjD-253_Meeting_Rooms_II_Diag_5.png){:width=600}

 **算法**

 1. 将开始时间和结束时间分开放在它们各自的数组中。 
 2. 分别对开始时间和结束时间进行排序。注意，这会破坏原来开始时间和结束时间的对应关系。它们将被单独处理。
 3. 我们考虑两个指针：`s_ptr` 和 `e_ptr`，它们分别指向开始指针和结束指针。开始指针简单地遍历所有的会议，结束指针帮助我们跟踪会议是否结束，我们是否可以重用房间。
 4. 当考虑一个被 `s_ptr` 所指向的特定会议时，我们检查这个开始时间是否大于被 `e_ptr` 所指向的会议。如果是这样，那就意味着在 `s_ptr`处需要开始的会议之前，一些会议已经结束了。所以我们可以重复使用其中一个房间。否则，我们必须分配一个新的房间。
 5. 如果一个会议确实结束了，即 `start[s_ptr] >= end[e_ptr]`，那么我们让 `e_ptr` 加1。
 6. 重复这个过程，直到 `s_ptr` 处理了所有的会议。

 让我们现在看一下这个算法的实现。

 ```Java [slu2]
 class Solution {
    public int minMeetingRooms(int[][] intervals) {
        
    // 检查边界条件。如果没有间隔，返回 0
    if (intervals.length == 0) {
      return 0;
    }

    Integer[] start = new Integer[intervals.length];
    Integer[] end = new Integer[intervals.length];

    for (int i = 0; i < intervals.length; i++) {
      start[i] = intervals[i][0];
      end[i] = intervals[i][1];
    }

    // 按照结束时间对间隔排序
    Arrays.sort(
        end,
        new Comparator<Integer>() {
          public int compare(Integer a, Integer b) {
            return a - b;
          }
        });

    // 按照开始时间对间隔排序
    Arrays.sort(
        start,
        new Comparator<Integer>() {
          public int compare(Integer a, Integer b) {
            return a - b;
          }
        });

    // 算法中的两个指针：e_ptr 和 s_ptr。
    int startPointer = 0, endPointer = 0;

    // 变量来跟踪使用的最大房间数。
    int usedRooms = 0;

    // 在间隔上迭代。
    while (startPointer < intervals.length) {

      // 如果有一个会议在 `start_pointer` 开始时已经结束
      if (start[startPointer] >= end[endPointer]) {
        usedRooms -= 1;
        endPointer += 1;
      }

      // 无论房间是否空闲，我们都会这样做。
      // 如果一个房间是空闲的，那么 used_rooms+=1 将不会有任何效果。 used_rooms 
      // 在这种情况下会保持不变。如果没有空闲的房间，则会增加已用房间数。
      usedRooms += 1;
      startPointer += 1;

    }

    return usedRooms;
  }
}
 ```

```Python3 [slu2]
class Solution:
    def minMeetingRooms(self, intervals: List[List[int]]) -> int:
        
        # 如果没有会议，我们不需要任何房间。
        if not intervals:
            return 0

        used_rooms = 0

        # 将开始计时和结束计时分开，并分别对它们进行排序。
        start_timings = sorted([i[0] for i in intervals])
        end_timings = sorted(i[1] for i in intervals)
        L = len(intervals)

        # 算法中的两个指针：e_ptr 和 s_ptr。
        end_pointer = 0
        start_pointer = 0

        # 直到所有会议都处理完毕
        while start_pointer < L:
            # 如果有一个会议在 `start_pointer` 开始时已经结束
            if start_timings[start_pointer] >= end_timings[end_pointer]:
                # 释放一个房间并递增end_pointer。
                used_rooms -= 1
                end_pointer += 1

            # 无论房间是否空闲，我们都会这样做。
            # 如果一个房间是空闲的，那么 used_rooms+=1 将不会有任何效果。 used_rooms 
            # 在这种情况下会保持不变。如果没有空闲的房间，则会增加已用房间数。
            used_rooms += 1    
            start_pointer += 1   

        return used_rooms
```

 **复杂性分析**
 * 时间复杂性：$O(N\log N)$ 因为我们做的只是分别为 `start timings` 和 `end timings` 两个数组进行排序，每个数组都会包含 $N$ 个元素，考虑到有 $N$ 个时间段。
 * 空间复杂性：$O(N)$ 因为我们创建了两个大小为 $N$的独立数组，一个用于记录开始时间，一个用于记录结束时间。