## [457.环形数组是否存在循环 中文官方题解](https://leetcode.cn/problems/circular-array-loop/solutions/100000/huan-xing-shu-zu-shi-fou-cun-zai-xun-hua-0ay2)
#### 方法一：快慢指针

**思路及算法**

我们可以将环形数组理解为图中的 $n$ 个点，$\text{nums}[i]$ 表示 $i$ 号点向 $(i + \text{nums}[i]) \bmod n$ 号点连有一条单向边。

注意到这张图中的每个点有且仅有一条出边，这样我们从某一个点出发，沿着单向边不断移动，最终必然会进入一个环中。而依据题目要求，我们要检查图中是否存在一个所有单向边方向一致的环。我们可以使用在无向图中找环的一个经典算法：快慢指针来解决本题，参考题解「[141. 环形链表](https://leetcode-cn.com/problems/linked-list-cycle/solution/huan-xing-lian-biao-by-leetcode-solution/)」。

具体地，我们检查每一个节点，令快慢指针从当前点出发，快指针每次移动两步，慢指针每次移动一步，期间每移动一次，我们都需要检查当前单向边的方向是否与初始方向是否一致，如果不一致，我们即可停止遍历，因为当前路径必然不满足条件。为了降低时间复杂度，我们可以标记每一个点是否访问过，过程中如果我们的下一个节点为已经访问过的节点，则可以停止遍历。

在实际代码中，我们无需新建一个数组记录每个点的访问情况，而只需要将原数组的对应元素置零即可（题目保证原数组中元素不为零）。遍历过程中，如果快慢指针相遇，或者移动方向改变，那么我们就停止遍历，并将快慢指针经过的点均置零即可。

特别地，当 $\text{nums}[i]$ 为 $n$ 的整倍数时，$i$ 的后继节点即为 $i$ 本身，此时循环长度 $k=1$，不符合题目要求，因此我们需要跳过这种情况。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool circularArrayLoop(vector<int>& nums) {
        int n = nums.size();
        auto next = [&](int cur) {
            return ((cur + nums[cur]) % n + n) % n; // 保证返回值在 [0,n) 中
        };

        for (int i = 0; i < n; i++) {
            if (!nums[i]) {
                continue;
            }
            int slow = i, fast = next(i);
            // 判断非零且方向相同
            while (nums[slow] * nums[fast] > 0 && nums[slow] * nums[next(fast)] > 0) {
                if (slow == fast) {
                    if (slow != next(slow)) {
                        return true;
                    } else {
                        break;
                    }
                }
                slow = next(slow);
                fast = next(next(fast));
            }
            int add = i;
            while (nums[add] * nums[next(add)] > 0) {
                int tmp = add;
                add = next(add);
                nums[tmp] = 0;
            }
        }
        return false;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean circularArrayLoop(int[] nums) {
        int n = nums.length;
        for (int i = 0; i < n; i++) {
            if (nums[i] == 0) {
                continue;
            }
            int slow = i, fast = next(nums, i);
            // 判断非零且方向相同
            while (nums[slow] * nums[fast] > 0 && nums[slow] * nums[next(nums, fast)] > 0) {
                if (slow == fast) {
                    if (slow != next(nums, slow)) {
                        return true;
                    } else {
                        break;
                    }
                }
                slow = next(nums, slow);
                fast = next(nums, next(nums, fast));
            }
            int add = i;
            while (nums[add] * nums[next(nums, add)] > 0) {
                int tmp = add;
                add = next(nums, add);
                nums[tmp] = 0;
            }
        }
        return false;
    }

    public int next(int[] nums, int cur) {
        int n = nums.length;
        return ((cur + nums[cur]) % n + n) % n; // 保证返回值在 [0,n) 中
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CircularArrayLoop(int[] nums) {
        int n = nums.Length;
        for (int i = 0; i < n; i++) {
            if (nums[i] == 0) {
                continue;
            }
            int slow = i, fast = Next(nums, i);
            // 判断非零且方向相同
            while (nums[slow] * nums[fast] > 0 && nums[slow] * nums[Next(nums, fast)] > 0) {
                if (slow == fast) {
                    if (slow != Next(nums, slow)) {
                        return true;
                    } else {
                        break;
                    }
                }
                slow = Next(nums, slow);
                fast = Next(nums, Next(nums, fast));
            }
            int add = i;
            while (nums[add] * nums[Next(nums, add)] > 0) {
                int tmp = add;
                add = Next(nums, add);
                nums[tmp] = 0;
            }
        }
        return false;
    }

    public int Next(int[] nums, int cur) {
        int n = nums.Length;
        return ((cur + nums[cur]) % n + n) % n; // 保证返回值在 [0,n) 中
    }
}
```

```go [sol1-Golang]
func circularArrayLoop(nums []int) bool {
    n := len(nums)
    next := func(cur int) int {
        return ((cur+nums[cur])%n + n) % n // 保证返回值在 [0,n) 中
    }

    for i, num := range nums {
        if num == 0 {
            continue
        }
        slow, fast := i, next(i)
        // 判断非零且方向相同
        for nums[slow]*nums[fast] > 0 && nums[slow]*nums[next(fast)] > 0 {
            if slow == fast {
                if slow == next(slow) {
                    break
                }
                return true
            }
            slow = next(slow)
            fast = next(next(fast))
        }
        add := i
        for nums[add]*nums[next(add)] > 0 {
            tmp := add
            add = next(add)
            nums[tmp] = 0
        }
    }
    return false
}
```

```Python [sol1-Python3]
class Solution:
    def circularArrayLoop(self, nums: List[int]) -> bool:
        n = len(nums)

        def next(cur: int) -> int:
            return (cur + nums[cur]) % n  # 保证返回值在 [0,n) 中

        for i, num in enumerate(nums):
            if num == 0:
                continue
            slow, fast = i, next(i)
            # 判断非零且方向相同
            while nums[slow] * nums[fast] > 0 and nums[slow] * nums[next(fast)] > 0:
                if slow == fast:
                    if slow == next(slow):
                        break
                    return True
                slow = next(slow)
                fast = next(next(fast))
            add = i
            while nums[add] * nums[next(add)] > 0:
                tmp = add
                add = next(add)
                nums[tmp] = 0
        return False
```

```C [sol1-C]
int next(int* nums, int numsSize, int cur) {
    return ((cur + nums[cur]) % numsSize + numsSize) % numsSize;  // 保证返回值在 [0,n) 中
}

bool circularArrayLoop(int* nums, int numsSize) {
    for (int i = 0; i < numsSize; i++) {
        if (!nums[i]) {
            continue;
        }
        int slow = i, fast = next(nums, numsSize, i);
        // 判断非零且方向相同
        while (nums[slow] * nums[fast] > 0 && nums[slow] * nums[next(nums, numsSize, fast)] > 0) {
            if (slow == fast) {
                if (slow != next(nums, numsSize, slow)) {
                    return true;
                } else {
                    break;
                }
            }
            slow = next(nums, numsSize, slow);
            fast = next(nums, numsSize, next(nums, numsSize, fast));
        }
        int add = i;
        while (nums[add] * nums[next(nums, numsSize, add)] > 0) {
            int tmp = add;
            add = next(nums, numsSize, add);
            nums[tmp] = 0;
        }
    }
    return false;
}
```

```JavaScript [sol1-JavaScript]
var circularArrayLoop = function(nums) {
    const n = nums.length;
    for (let i = 0; i < n; i++) {
        if (nums[i] === 0) {
            continue;
        }
        let slow = i, fast = next(nums, i);
        // 判断非零且方向相同
        while (nums[slow] * nums[fast] > 0 && nums[slow] * nums[next(nums, fast)] > 0) {
            if (slow === fast) {
                if (slow !== next(nums, slow)) {
                    return true;
                } else {
                    break;
                }
            }
            slow = next(nums, slow);
            fast = next(nums, next(nums, fast));
        }
        let add = i;
        while (nums[add] * nums[next(nums, add)] > 0) {
            const tmp = add;
            add = next(nums, add);
            nums[tmp] = 0;
        }
    }
    return false;
}

const next = (nums, cur) => {
    const n = nums.length;
    return ((cur + nums[cur]) % n + n) % n; // 保证返回值在 [0,n) 中
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是环形数组的长度。我们至多遍历每个点四次，其中快指针两次，慢指针一次，置零标记一次。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量。