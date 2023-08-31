## [862.和至少为 K 的最短子数组 中文官方题解](https://leetcode.cn/problems/shortest-subarray-with-sum-at-least-k/solutions/100000/he-zhi-shao-wei-k-de-zui-duan-zi-shu-zu-57ffq)

#### 方法一：前缀和 + 单调双端队列

**思路**

记数组 $\textit{nums}$ 的前缀和数组为 $\textit{preSumArr}$，可以根据 $\textit{preSumArr}[i]$ = $\sum_{j=0}^{i-1}{nums}[j]$ 计算得到。对于边界情况，$\textit{preSumArr}[0] = 0$。而从数组 $\textit{nums}$ 下标 $i$ 开始长为 $m$ 的子数组的和就可以根据 $\textit{preSumArr}[i+m] - \textit{preSumArr}[i]$ 快速计算得到。

题目要求计算 $\textit{nums}$ 中，和大于等于 $k$ 的最短子数组的长度。可以以 $\textit{nums}$ 的每一个下标作为候选子数组的起点下标，都计算满足条件的最短子数组的长度，然后再从这些长度中找出最小值即可。

遍历 $\textit{preSumArr}$ 数组，访问过的前缀和先暂存在某种集合 $q$ 中。根据前缀和数组的性质，后访问到的某个前缀和 $\textit{preSumArr}[j]$ 减去之前访问到的某个前缀和 $\textit{preSumArr}[i]$（$j \gt i$）即为 $\textit{nums}$ 中某段子数组的和。因此，每次访问到某个前缀和 $\textit{preSumArr}[j]$ 时，可以用它尝试减去集合 $q$ 中所有已经访问过的前缀和。当某个 $q$ 中的前缀和 $\textit{preSumArr}[i]$，第一次出现 $\textit{preSumArr}[j] - \textit{preSumArr}[i] \geq k$ 时，这个下标 $i$ 就找到了以它为起点的最短子数组的长度 $j-i$。此时，可以将它从 $q$ 中移除，后续即使还有以它为起点的满足条件的子数组，长度也会大于当前的长度。当一个前缀和 $\textit{preSumArr}[j]$ 试减完 $q$ 中的元素时，需要将它也放入 $q$ 中。将它放入 $q$ 前， $q$ 中可能存在比 $\textit{preSumArr}[j]$ 大的元素，而这些元素和 $\textit{preSumArr}[j]$ 一样，只能作为再后续访问到的某个前缀和 $\textit{preSumArr}[h]$ 的减数。而作为减数时，更大的值只会让不等式 $\textit{preSumArr}[h] - \textit{preSumArr}[i] \geq k$ 更难满足。即使都满足，后访问到的值也可以带来更短的长度。 因此，在把 $\textit{preSumArr}[j]$ 放入 $q$ 时，需要将 $q$ 中大于等于 $\textit{preSumArr}[j]$ 的值也都移除。

接下来考虑 $q$ 的性质。我们会往 $q$ 中增加和删除元素。每次增加一个元素 $\textit{curSum}$ 前，先根据不等式删除一部分元素（也可能不删），然后再删除 $q$ 中所有大于等于 $\textit{curSum}$ 的元素，这样每次加进去的元素都会是 $q$ 中的唯一最大值，使得 $q$ 中的元素是按照添加顺序严格单调递增的，我们知道单调队列是满足这样的性质的。而这一性质，也可以帮助找到 $q$ 中所有满足不等式的值。按照添加的顺序从早到晚，即元素的值从小到大来比较是否满足不等式即可。按照这个顺序，一旦有一个元素不满足，$q$ 中后续的元素也不会满足不等式，即可停止比较。基于此，我们需要一个集合，可以在两端删除元素，在一端添加元素，因此使用双端队列。

在完成代码时，$q$ 中暂存的元素是 $\textit{preSumArr}$ 的下标，对应下标的前缀和严格单调递增。

**代码**

```Python [sol1-Python3]
class Solution:
    def shortestSubarray(self, nums: List[int], k: int) -> int:
        preSumArr = [0]
        res = len(nums) + 1
        for num in nums:
            preSumArr.append(preSumArr[-1] + num)
        q = deque()
        for i, curSum in enumerate(preSumArr):
            while q and curSum - preSumArr[q[0]] >= k:
                res = min(res, i - q.popleft())
            while q and preSumArr[q[-1]] >= curSum:
                q.pop()
            q.append(i)
        return res if res < len(nums) + 1 else -1
```

```Java [sol1-Java]
class Solution {
    public int shortestSubarray(int[] nums, int k) {
        int n = nums.length;
        long[] preSumArr = new long[n + 1];
        for (int i = 0; i < n; i++) {
            preSumArr[i + 1] = preSumArr[i] + nums[i];
        }
        int res = n + 1;
        Deque<Integer> queue = new ArrayDeque<Integer>();
        for (int i = 0; i <= n; i++) {
            long curSum = preSumArr[i];
            while (!queue.isEmpty() && curSum - preSumArr[queue.peekFirst()] >= k) {
                res = Math.min(res, i - queue.pollFirst());
            }
            while (!queue.isEmpty() && preSumArr[queue.peekLast()] >= curSum) {
                queue.pollLast();
            }
            queue.offerLast(i);
        }
        return res < n + 1 ? res : -1;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int shortestSubarray(vector<int>& nums, int k) {
        int n = nums.size();
        vector<long> preSumArr(n + 1);
        for (int i = 0; i < n; i++) {
            preSumArr[i + 1] = preSumArr[i] + nums[i];
        }
        int res = n + 1;
        deque<int> qu;
        for (int i = 0; i <= n; i++) {
            long curSum = preSumArr[i];
            while (!qu.empty() && curSum - preSumArr[qu.front()] >= k) {
                res = min(res, i - qu.front());
                qu.pop_front();
            }
            while (!qu.empty() && preSumArr[qu.back()] >= curSum) {
                qu.pop_back();
            }
            qu.push_back(i);
        }
        return res < n + 1 ? res : -1;
    }
};
```

```C [sol1-C]
typedef struct {
    int *elements;
    int rear, front;
    int capacity;
} MyCircularDeque;

MyCircularDeque* myCircularDequeCreate(int k) {
    MyCircularDeque *obj = (MyCircularDeque *)malloc(sizeof(MyCircularDeque));
    obj->capacity = k + 1;
    obj->rear = obj->front = 0;
    obj->elements = (int *)malloc(sizeof(int) * obj->capacity);
    return obj;
}

bool myCircularDequeInsertFront(MyCircularDeque* obj, int value) {
    if ((obj->rear + 1) % obj->capacity == obj->front) {
        return false;
    }
    obj->front = (obj->front - 1 + obj->capacity) % obj->capacity;
    obj->elements[obj->front] = value;
    return true;
}

bool myCircularDequeInsertLast(MyCircularDeque* obj, int value) {
    if ((obj->rear + 1) % obj->capacity == obj->front) {
        return false;
    }
    obj->elements[obj->rear] = value;
    obj->rear = (obj->rear + 1) % obj->capacity;
    return true;
}

bool myCircularDequeDeleteFront(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return false;
    }
    obj->front = (obj->front + 1) % obj->capacity;
    return true;
}

bool myCircularDequeDeleteLast(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return false;
    }
    obj->rear = (obj->rear - 1 + obj->capacity) % obj->capacity;
    return true;
}

int myCircularDequeGetFront(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return -1;
    }
    return obj->elements[obj->front];
}

int myCircularDequeGetRear(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return -1;
    }
    return obj->elements[(obj->rear - 1 + obj->capacity) % obj->capacity];
}

bool myCircularDequeIsEmpty(MyCircularDeque* obj) {
    return obj->rear == obj->front;
}

bool myCircularDequeIsFull(MyCircularDeque* obj) {
    return (obj->rear + 1) % obj->capacity == obj->front;
}

void myCircularDequeFree(MyCircularDeque* obj) {
    free(obj->elements);
    free(obj);
}

#define MIN(a, b) ((a) < (b) ? (a) : (b))

int shortestSubarray(int* nums, int numsSize, int k) {
    long preSumArr[numsSize + 1];
    preSumArr[0] = 0;
    for (int i = 0; i < numsSize; i++) {
        preSumArr[i + 1] = preSumArr[i] + nums[i];
    }
    int res = numsSize + 1;
    MyCircularDeque *queue = myCircularDequeCreate(numsSize + 1);
    for (int i = 0; i <= numsSize; i++) {
        long curSum = preSumArr[i];
        while (!myCircularDequeIsEmpty(queue) && curSum - preSumArr[myCircularDequeGetFront(queue)] >= k) {
            res = MIN(res, i - myCircularDequeGetFront(queue));
            myCircularDequeDeleteFront(queue);
        }
        while (!myCircularDequeIsEmpty(queue) && preSumArr[myCircularDequeGetRear(queue)] >= curSum) {
            myCircularDequeDeleteLast(queue);
        }
        myCircularDequeInsertLast(queue, i);
    }
    myCircularDequeFree(queue);
    return res < numsSize + 1 ? res : -1;
}
```

```JavaScript [sol1-JavaScript]
var shortestSubarray = function(nums, k) {
    const n = nums.length;
    const preSumArr = new Array(n + 1).fill(0);
        for (let i = 0; i < n; i++) {
        preSumArr[i + 1] = preSumArr[i] + nums[i];
    }
    let res = n + 1;
    const queue = [];
    for (let i = 0; i <= n; i++) {
        const curSum = preSumArr[i];
        while (queue.length != 0 && curSum - preSumArr[queue[0]] >= k) {
            res = Math.min(res, i - queue.shift());
        }
        while (queue.length != 0 && preSumArr[queue[queue.length - 1]] >= curSum) {
            queue.pop();
        }
        queue.push(i);
    }
    return res < n + 1 ? res : -1;
};
```

```go [sol1-Golang]
func shortestSubarray(nums []int, k int) int {
    n := len(nums)
    preSumArr := make([]int, n+1)
    for i, num := range nums {
        preSumArr[i+1] = preSumArr[i] + num
    }
    ans := n + 1
    q := []int{}
    for i, curSum := range preSumArr {
        for len(q) > 0 && curSum-preSumArr[q[0]] >= k {
            ans = min(ans, i-q[0])
            q = q[1:]
        }
        for len(q) > 0 && preSumArr[q[len(q)-1]] >= curSum {
            q = q[:len(q)-1]
        }
        q = append(q, i)
    }
    if ans < n+1 {
        return ans
    }
    return -1
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。求 $\textit{preSumArr}$ 消耗 $O(n)$。$\textit{preSumArr}$ 每个下标会入 $q$ 一次，最多出 $q$ 一次。

- 空间复杂度：$O(n)$。$\textit{preSumArr}$ 和 $q$ 长度均为 $O(n)$。