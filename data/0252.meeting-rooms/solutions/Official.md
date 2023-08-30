[TOC] 


 ## 解决方案

---

 #### 方法 1：暴力法 

 最直接的解法是在数组中比较每两个会议，看它们是否有冲突（即是否有重叠）。如果其中一个会议开始时，另一个会议仍在进行中，那么两个会议就有重叠。 

 ```C++ [slu1]
 class Solution {
public:
    bool overlap(vector<int>& interval1, vector<int>& interval2) {
        return interval1[0] >= interval2[0] and interval1[0] < interval2[1]
               or interval2[0] >= interval1[0] and interval2[0] < interval1[1];
    }
    
    bool canAttendMeetings(vector<vector<int>>& intervals) {
        for (size_t i = 0; i < intervals.size(); i++) {
            for (size_t j = i + 1; j < intervals.size(); j++) {
                if (overlap(intervals[i], intervals[j])) {
                    return false;
                }
            }
        }
        return true;
    }
};
 ```

 ```Java [slu1]
 class Solution {
    public boolean canAttendMeetings(int[][] intervals) {
        for (int i = 0; i < intervals.length; i++) {
            for (int j = i + 1; j < intervals.length; j++) {
                if (overlap(intervals[i], intervals[j])) {
                    return false;
                }
            }
        }
        return true;
    }

    private boolean overlap(int[] interval1, int[] interval2) {
        return (interval1[0] >= interval2[0] && interval1[0] < interval2[1])
            || (interval2[0] >= interval1[0] && interval2[0] < interval1[1]);
    }
}
 ```

 ```Python3 [slu1]
 class Solution:
    def canAttendMeetings(self, intervals: List[List[int]]) -> bool:
        def overlap(interval1: List[int], interval2: List[int]) -> bool:
            return (interval1[0] >= interval2[0] and interval1[0] < interval2[1]
                or interval2[0] >= interval1[0] and interval2[0] < interval1[1])

        for i in range(len(intervals)):
            for j in range(i + 1, len(intervals)):
                if overlap(intervals[i], intervals[j]):
                    return False
        return True
 ```

 **重叠条件** 

 上面的代码中的重叠条件可以写得更简洁。考虑两个没有重叠的会议。较早的会议在较晚的会议开始前就结束了。因此，两个会议的*最小*结束时间（即较早会议的结束时间）小于或等于两个会议的*最大*开始时间（即较晚会议的开始时间）。 

 ![image.png](https://pic.leetcode.cn/1692082444-bmAoWB-image.png){:width=400}

 *图1.两个没有重叠的时间间隔.* 

 ![image.png](https://pic.leetcode.cn/1692082447-fAsxEp-image.png){:width=400}

 *图2.两个重叠的时间间隔.* 

 因此，这个条件可以重写如下。 

 ```Java
 public static boolean overlap(int[] interval1, int[] interval2) {
    return (Math.min(interval1[1], interval2[1]) >
            Math.max(interval1[0], interval2[0]));
}
 ```

 **复杂度分析** 

 由于我们有两个检查，每个会议都要与其他所有会议进行比较，总的运行时间是 $O(n^2)$. 没有使用额外的空间，所以空间复杂度是 $O(1)$。

---

 #### 方法 2：排序 

 这里的想法是根据开始时间对会议进行排序。然后，逐个查询会议，确保每个会议在下一个会议开始前结束。 

 ```C++ [slu2]
 class Solution {
public:
    bool canAttendMeetings(vector<vector<int>>& intervals) {
        if (intervals.empty()) {
            return true;
        }

        // 注意：C++ 排序函数会自动首先按第一个元素对向量排序，然后按第二个元素排序，依此类推。
        sort(intervals.begin(), intervals.end());
        for (size_t i = 0; i < intervals.size() - 1; i++) {
            if (intervals[i][1] > intervals[i + 1][0]) {
                return false;
            }
        }
        return true;
    }
};
 ```

 ```Java [slu2]
 class Solution {
    public boolean canAttendMeetings(int[][] intervals) {
        Arrays.sort(intervals, (a, b) -> Integer.compare(a[0], b[0]));
        for (int i = 0; i < intervals.length - 1; i++) {
            if (intervals[i][1] > intervals[i + 1][0]) {
                return false;
            }
        }
        return true;
    }
}
 ```

 ```Python3 [slu2]
 class Solution:
    def canAttendMeetings(self, intervals: List[List[int]]) -> bool:
        intervals.sort()
        for i in range(len(intervals) - 1):
            if intervals[i][1] > intervals[i + 1][0]:
                return False
        return True
 ```

 **复杂度分析** 

 * 时间复杂度 : $O(n \log n)$。 时间复杂度主要由排序部分决定。一旦数组被排序，只需要$O(n)$时间就可以遍历数组，确定是否有任何重叠。 
 * 空间复杂度 : $O(1)$。 由于没有分配额外的空间。