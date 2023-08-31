## [739.每日温度 中文官方题解](https://leetcode.cn/problems/daily-temperatures/solutions/100000/mei-ri-wen-du-by-leetcode-solution)
### 📺 视频题解  
![739. 每日温度.mp4](c5bccc21-dd3e-47c4-94ff-7a66bbfb5564)

### 📖 文字题解
#### 方法一：暴力

对于温度列表中的每个元素 `temperatures[i]`，需要找到最小的下标 `j`，使得 `i < j` 且 `temperatures[i] < temperatures[j]`。

由于温度范围在 `[30, 100]` 之内，因此可以维护一个数组 `next` 记录每个温度第一次出现的下标。数组 `next` 中的元素初始化为无穷大，在遍历温度列表的过程中更新 `next` 的值。

反向遍历温度列表。对于每个元素 `temperatures[i]`，在数组 `next` 中找到从 `temperatures[i] + 1` 到 `100` 中每个温度第一次出现的下标，将其中的最小下标记为 `warmerIndex`，则 `warmerIndex` 为下一次温度比当天高的下标。如果 `warmerIndex` 不为无穷大，则 `warmerIndex - i` 即为下一次温度比当天高的等待天数，最后令 `next[temperatures[i]] = i`。

为什么上述做法可以保证正确呢？因为遍历温度列表的方向是反向，当遍历到元素 `temperatures[i]` 时，只有 `temperatures[i]` 后面的元素被访问过，即对于任意 `t`，当 `next[t]` 不为无穷大时，一定存在 `j` 使得 `temperatures[j] == t` 且 `i < j`。又由于遍历到温度列表中的每个元素时都会更新数组 `next` 中的对应温度的元素值，因此对于任意 `t`，当 `next[t]` 不为无穷大时，令 `j = next[t]`，则 `j` 是满足 `temperatures[j] == t` 且 `i < j` 的最小下标。

```Java [sol1-Java]
class Solution {
    public int[] dailyTemperatures(int[] temperatures) {
        int length = temperatures.length;
        int[] ans = new int[length];
        int[] next = new int[101];
        Arrays.fill(next, Integer.MAX_VALUE);
        for (int i = length - 1; i >= 0; --i) {
            int warmerIndex = Integer.MAX_VALUE;
            for (int t = temperatures[i] + 1; t <= 100; ++t) {
                if (next[t] < warmerIndex) {
                    warmerIndex = next[t];
                }
            }
            if (warmerIndex < Integer.MAX_VALUE) {
                ans[i] = warmerIndex - i;
            }
            next[temperatures[i]] = i;
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def dailyTemperatures(self, temperatures: List[int]) -> List[int]:
        n = len(temperatures)
        ans, nxt, big = [0] * n, dict(), 10**9
        for i in range(n - 1, -1, -1):
            warmer_index = min(nxt.get(t, big) for t in range(temperatures[i] + 1, 102))
            if warmer_index != big:
                ans[i] = warmer_index - i
            nxt[temperatures[i]] = i
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> dailyTemperatures(vector<int>& temperatures) {
        int n = temperatures.size();
        vector<int> ans(n), next(101, INT_MAX);
        for (int i = n - 1; i >= 0; --i) {
            int warmerIndex = INT_MAX;
            for (int t = temperatures[i] + 1; t <= 100; ++t) {
                warmerIndex = min(warmerIndex, next[t]);
            }
            if (warmerIndex != INT_MAX) {
                ans[i] = warmerIndex - i;
            }
            next[temperatures[i]] = i;
        }
        return ans;
    }
};
```

```golang [sol1-Golang]
func dailyTemperatures(temperatures []int) []int {
    length := len(temperatures)
    ans := make([]int, length)
    next := make([]int, 101)
    for i := 0; i < 101; i++ {
        next[i] = math.MaxInt32
    }
    for i := length - 1; i >= 0; i-- {
        warmerIndex := math.MaxInt32
        for t := temperatures[i] + 1; t <= 100; t++ {
            if next[t] < warmerIndex {
                warmerIndex = next[t]
            }
        }
        if warmerIndex < math.MaxInt32 {
            ans[i] = warmerIndex - i
        }
        next[temperatures[i]] = i
    }
    return ans
}
```

**复杂度分析**

* 时间复杂度：$O(nm)$，其中 $n$ 是温度列表的长度，$m$ 是数组 `next` 的长度，在本题中温度不超过 $100$，所以 $m$ 的值为 $100$。反向遍历温度列表一遍，对于温度列表中的每个值，都要遍历数组 `next` 一遍。

* 空间复杂度：$O(m)$，其中 $m$ 是数组 `next` 的长度。除了返回值以外，需要维护长度为 $m$ 的数组 `next` 记录每个温度第一次出现的下标位置。

#### 方法二：单调栈

可以维护一个存储下标的单调栈，从栈底到栈顶的下标对应的温度列表中的温度依次递减。如果一个下标在单调栈里，则表示尚未找到下一次温度更高的下标。

正向遍历温度列表。对于温度列表中的每个元素 `temperatures[i]`，如果栈为空，则直接将 `i` 进栈，如果栈不为空，则比较栈顶元素 `prevIndex` 对应的温度 `temperatures[prevIndex]` 和当前温度 `temperatures[i]`，如果 `temperatures[i] > temperatures[prevIndex]`，则将 `prevIndex` 移除，并将 `prevIndex` 对应的等待天数赋为 `i - prevIndex`，重复上述操作直到栈为空或者栈顶元素对应的温度小于等于当前温度，然后将 `i` 进栈。

为什么可以在弹栈的时候更新 `ans[prevIndex]` 呢？因为在这种情况下，即将进栈的 `i` 对应的 `temperatures[i]` 一定是 `temperatures[prevIndex]` 右边第一个比它大的元素，试想如果 `prevIndex` 和 `i` 有比它大的元素，假设下标为 `j`，那么 `prevIndex` 一定会在下标 `j` 的那一轮被弹掉。

由于单调栈满足从栈底到栈顶元素对应的温度递减，因此每次有元素进栈时，会将温度更低的元素全部移除，并更新出栈元素对应的等待天数，这样可以确保等待天数一定是最小的。

以下用一个具体的例子帮助读者理解单调栈。对于温度列表 $[73,74,75,71,69,72,76,73]$，单调栈 $\textit{stack}$ 的初始状态为空，答案 $\textit{ans}$ 的初始状态是 $[0,0,0,0,0,0,0,0]$，按照以下步骤更新单调栈和答案，其中单调栈内的元素都是下标，括号内的数字表示下标在温度列表中对应的温度。

* 当 $i=0$ 时，单调栈为空，因此将 $0$ 进栈。

   * $\textit{stack}=[0(73)]$

   * $\textit{ans}=[0,0,0,0,0,0,0,0]$

* 当 $i=1$ 时，由于 $74$ 大于 $73$，因此移除栈顶元素 $0$，赋值 $ans[0]:=1-0$，将 $1$ 进栈。

   * $\textit{stack}=[1(74)]$

   * $\textit{ans}=[1,0,0,0,0,0,0,0]$

* 当 $i=2$ 时，由于 $75$ 大于 $74$，因此移除栈顶元素 $1$，赋值 $ans[1]:=2-1$，将 $2$ 进栈。

   * $\textit{stack}=[2(75)]$

   * $\textit{ans}=[1,1,0,0,0,0,0,0]$

* 当 $i=3$ 时，由于 $71$ 小于 $75$，因此将 $3$ 进栈。

   * $\textit{stack}=[2(75),3(71)]$

   * $\textit{ans}=[1,1,0,0,0,0,0,0]$

* 当 $i=4$ 时，由于 $69$ 小于 $71$，因此将 $4$ 进栈。

   * $\textit{stack}=[2(75),3(71),4(69)]$

   * $\textit{ans}=[1,1,0,0,0,0,0,0]$

* 当 $i=5$ 时，由于 $72$ 大于 $69$ 和 $71$，因此依次移除栈顶元素 $4$ 和 $3$，赋值 $ans[4]:=5-4$ 和 $ans[3]:=5-3$，将 $5$ 进栈。

   * $\textit{stack}=[2(75),5(72)]$

   * $\textit{ans}=[1,1,0,2,1,0,0,0]$

* 当 $i=6$ 时，由于 $76$ 大于 $72$ 和 $75$，因此依次移除栈顶元素 $5$ 和 $2$，赋值 $ans[5]:=6-5$ 和 $ans[2]:=6-2$，将 $6$ 进栈。

   * $\textit{stack}=[6(76)]$

   * $\textit{ans}=[1,1,4,2,1,1,0,0]$

* 当 $i=7$ 时，由于 $73$ 小于 $76$，因此将 $7$ 进栈。

   * $\textit{stack}=[6(76),7(73)]$

   * $\textit{ans}=[1,1,4,2,1,1,0,0]$

```Java [sol2-Java]
class Solution {
    public int[] dailyTemperatures(int[] temperatures) {
        int length = temperatures.length;
        int[] ans = new int[length];
        Deque<Integer> stack = new LinkedList<Integer>();
        for (int i = 0; i < length; i++) {
            int temperature = temperatures[i];
            while (!stack.isEmpty() && temperature > temperatures[stack.peek()]) {
                int prevIndex = stack.pop();
                ans[prevIndex] = i - prevIndex;
            }
            stack.push(i);
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def dailyTemperatures(self, temperatures: List[int]) -> List[int]:
        length = len(temperatures)
        ans = [0] * length
        stack = []
        for i in range(length):
            temperature = temperatures[i]
            while stack and temperature > temperatures[stack[-1]]:
                prev_index = stack.pop()
                ans[prev_index] = i - prev_index
            stack.append(i)
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> dailyTemperatures(vector<int>& temperatures) {
        int n = temperatures.size();
        vector<int> ans(n);
        stack<int> s;
        for (int i = 0; i < n; ++i) {
            while (!s.empty() && temperatures[i] > temperatures[s.top()]) {
                int previousIndex = s.top();
                ans[previousIndex] = i - previousIndex;
                s.pop();
            }
            s.push(i);
        }
        return ans;
    }
};
```

```golang [sol2-Golang]
func dailyTemperatures(temperatures []int) []int {
    length := len(temperatures)
    ans := make([]int, length)
    stack := []int{}
    for i := 0; i < length; i++ {
        temperature := temperatures[i]
        for len(stack) > 0 && temperature > temperatures[stack[len(stack)-1]] {
            prevIndex := stack[len(stack)-1]
            stack = stack[:len(stack)-1]
            ans[prevIndex] = i - prevIndex
        }
        stack = append(stack, i)
    }
    return ans
}
```

**复杂度分析**

* 时间复杂度：$O(n)$，其中 $n$ 是温度列表的长度。正向遍历温度列表一遍，对于温度列表中的每个下标，最多有一次进栈和出栈的操作。

* 空间复杂度：$O(n)$，其中 $n$ 是温度列表的长度。需要维护一个单调栈存储温度列表中的下标。