## [1503.所有蚂蚁掉下来前的最后一刻 中文官方题解](https://leetcode.cn/problems/last-moment-before-all-ants-fall-out-of-a-plank/solutions/100000/suo-you-ma-yi-diao-xia-lai-qian-de-zui-hou-yi-ke-2)

#### 方法一：模拟

这道题最容易让人迷惑的地方在于「当两只向**不同**方向移动的蚂蚁在某个点相遇时，它们会同时改变移动方向并继续移动」。按照常规思路，需要对每只蚂蚁分别计算每个时刻所在的位置，如果考虑到改变移动方向，情况会非常复杂。

注意到题目要求的是最后一只蚂蚁从木板上掉下来的时刻，所以并不需要区分每只蚂蚁。注意到题目中的信息，由于改变移动方向不花费额外时间，而且改变移动方向后的移动速度不变，因此，**两只相遇的蚂蚁同时改变移动方向之后的情形等价于两只蚂蚁都不改变移动方向**，继续按照原来的方向和速度移动，这样问题就简化成根据每只蚂蚁的初始位置和移动方向得到最后一只蚂蚁到达木板边界的时刻。

假设一只蚂蚁在位置 $p$。如果这只蚂蚁向左移动，则它到达木板边界需要的时间是 $p$。如果这只蚂蚁向右移动，则它到达木板边界需要的时间是 $n-p$。

遍历数组 $\text{left}$ 和 $\text{right}$，根据每只蚂蚁的初始位置和移动方向得到每只蚂蚁到达木板边界需要的时间，其中的最大值即为最后一只蚂蚁到达木板边界的时刻，也是最后一只蚂蚁从木板上掉下来的时刻。

```Java [sol1-Java]
class Solution {
    public int getLastMoment(int n, int[] left, int[] right) {
        int lastMoment = 0;
        for (int ant : left) {
            lastMoment = Math.max(lastMoment, ant);
        }
        for (int ant : right) {
            lastMoment = Math.max(lastMoment, n - ant);
        }
        return lastMoment;
    }
}
```

```csharp [sol1-C#]
public class Solution 
{
    public int GetLastMoment(int n, int[] left, int[] right) 
    {
        int lastMoment = 0;

        foreach (int ant in left) 
        {
            lastMoment = Math.Max(lastMoment, ant);
        }

        foreach (int ant in right) 
        {
            lastMoment = Math.Max(lastMoment, n - ant);
        }

        return lastMoment;
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    int getLastMoment(int n, vector<int>& left, vector<int>& right) {
        int lastMoment = 0;
        for (int ant : left) {
            lastMoment = max(lastMoment, ant);
        }
        for (int ant : right) {
            lastMoment = max(lastMoment, n - ant);
        }
        return lastMoment;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def getLastMoment(self, n: int, left: List[int], right: List[int]) -> int:
        lastMoment = 0 if not left else max(left)
        if right:
            lastMoment = max(lastMoment, max(n - ant for ant in right))
        return lastMoment
```

**复杂度分析**

- 时间复杂度：$O(n)$。需要遍历 $\text{left}$ 和 $\text{right}$ 两个数组，因此时间复杂度与两个数组的长度之和呈线性关系，又由于两个数组的长度之和最大为 $n+1$，因此时间复杂度是 $O(n)$。

- 空间复杂度：$O(1)$。