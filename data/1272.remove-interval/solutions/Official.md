## [1272.删除区间 中文官方题解](https://leetcode.cn/problems/remove-interval/solutions/100000/shan-chu-qu-jian-by-leetcode-solution)
[TOC]


 ## 解决方案

---

 #### 方法 1：扫描线算法

 **最好的可能时间复杂度**

 > 这里最好的可能时间复杂度是什么？

 输入已经排序，这通常意味着至少是线性时间复杂度。$\mathcal{O}(\log N)$ 是可能的吗？不，因为将输入元素复制到输出中仍需要 $\mathcal{O}(N)$ 的时间。

**扫描线算法**
**扫描线算法** 是一种几何可视化的类型。让我们想象一根在平面上扫过的垂直线，在某些点停下。这可能会创造出各种情况，并且决定取决于停止点。

 ![image.png](https://pic.leetcode.cn/1691998080-yKxTgb-image.png){:width=600}

 **思路**
 通过遍历输入区间来扫描线，看看它可能带给我们什么。

 - 当前区间与toBeRemoved的一个没有重叠。 这意味着没有什么需要注意的， 只需更新输出就可以。

 ![image.png](https://pic.leetcode.cn/1691998201-vFOJuR-image.png){:width=600}
 - 第二种情况是toBeRemoved区间在当前区间内部。 然后，一个必须在输出中添加两个非重叠的部分 当前区间。

![image.png](https://pic.leetcode.cn/1691998305-njMSsG-image.png){:width=600}
 - "左"重叠。

![image.png](https://pic.leetcode.cn/1691998421-ieMyvk-image.png){:width=600}
 - "右"重叠。

![image.png](https://pic.leetcode.cn/1691998478-qKhXfj-image.png){:width=600}

 现在我们全部覆盖了所有情况，算法完成。

 **实现**

 将上述转换为代码的一种方法是检查上述描述的每一种情况。然而，更好的方法是认识到 *如果有任何重叠*，那么重叠的区间将被分解成*最多两个新的区间*;一个左区间和一个右区间。因此，我们可以把情况 2 视为既是情况 3 又是情况 4。

 ```Java [slu1]
class Solution {
    public List<List<Integer>> removeInterval(int[][] intervals, int[] toBeRemoved) {
        List<List<Integer>> result = new ArrayList<>();
        for (int[] interval : intervals) {
            // 如果没有重叠，则按原样将间隔添加到列表中。
            if (interval[0] > toBeRemoved[1] || interval[1] < toBeRemoved[0]) {
                result.add(Arrays.asList(interval[0], interval[1]));
            } else {
                // 需要保留左区间吗？
                if (interval[0] < toBeRemoved[0]) {
                    result.add(Arrays.asList(interval[0], toBeRemoved[0]));
                }
                // 需要保留右区间吗？
                if (interval[1] > toBeRemoved[1]) {
                    result.add(Arrays.asList(toBeRemoved[1], interval[1]));
                }
            }
        }
        return result;
    }
}
 ```

```Python3 [slu1]
class Solution:
    def removeInterval(self, intervals: List[List[int]], toBeRemoved: List[int]) -> List[List[int]]:

        remove_start, remove_end = toBeRemoved
        output = []

        for start, end in intervals:
            # 如果没有重叠，则按原样将间隔添加到列表中。
            if start > remove_end or end < remove_start:
                output.append([start, end])
            else:
                # 需要保留左区间吗？
                if start < remove_start:
                    output.append([start, remove_start])
                # 需要保留右区间吗？
                if end > remove_end:
                    output.append([remove_end, end])

        return output
```


 **复杂度分析**

 * 时间复杂度：$\mathcal{O}(N)$，因为它是一次通过输入数组。 
 * 空间复杂度：$\mathcal{O}(1)$，不考虑输出列表的$\mathcal{O}(N)$空间。