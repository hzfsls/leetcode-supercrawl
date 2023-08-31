## [2103.环和杆 中文官方题解](https://leetcode.cn/problems/rings-and-rods/solutions/100000/huan-he-gan-by-leetcode-solution-88xj)
#### 方法一：维护每根杆的状态

**思路与算法**

我们可以遍历字符串的每个颜色位置对，来模拟套环的过程。

对于每一个环，由于我们只关心它上面有哪些颜色的环，而不在意具体的数量；同时是否有某一种颜色的环的状态相互独立，因此我们可以用一个 $3$ 二进制位的整数来表示每个环的状态。具体地，**从低到高**第一位表示是否有红色的环，第二位表示是否有蓝色的环，第三位表示是否有绿色的环；每一位为 $1$ 则代表当前杆上有对应颜色的环，为 $0$ 则代表没有。当套上某种颜色的环后，无论该二进制位之前取值如何，新的取值一定为 $1$，这等价于对应二进制位**对 $1$ 取或**的操作。

我们可以用一个长度为 $10$ 的状态数组来表示每个环的状态，数组下标即为杆的编号。在模拟开始前，所有环的状态对应的整数均为 $0$。在遍历到每个颜色位置对时，我们首先看第二个字符寻找出对应的下标，同时根据环的颜色对状态值的对应二进制位**对 $1$ 取或**。当遍历完成后，我们遍历状态数组，统计状态值为 $(111)_2 = 7$ （代表对应杆上有三种颜色的环）的个数，并返回该个数作为答案。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countPoints(string rings) {
        int n = rings.size();
        vector<int> status(10);   // 状态数组
        // 遍历颜色位置对维护状态数组
        for (int i = 0; i < n; i += 2) {
            int idx = rings[i+1] - '0';
            if (rings[i] == 'R') {
                status[idx] |= 1;
            }
            else if (rings[i] == 'G') {
                status[idx] |= 2;
            }
            else {
                status[idx] |= 4;
            }
        }
        // 统计集齐三色环的杆的数量
        int res = 0;
        for (int i = 0; i < 10; ++i) {
            if (status[i] == 7) {
                ++res;
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countPoints(self, rings: str) -> int:
        n = len(rings)
        status = [0] * 10   # 状态数组
        # 遍历颜色位置对维护状态数组
        for i in range(0, n, 2):
            idx = int(rings[i+1])
            if rings[i] == 'R':
                status[idx] |= 1
            elif rings[i] == 'G':
                status[idx] |= 2
            else:
                status[idx] |= 4
        # 统计集齐三色环的杆的数量
        res = 0
        for i in range(10):
            if status[i] == 7:
                res += 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(n + k)$，其中 $n$ 为 $\textit{rings}$ 的长度，$k$ 为杆的数量。初始化杆状态数组与统计数量的时间复杂度为 $O(k)$，遍历字符串的时间复杂度为 $O(n)$。

- 空间复杂度：$O(k)$，即为状态数组的空间开销。