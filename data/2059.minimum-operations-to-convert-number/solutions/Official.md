#### 方法一：广度优先搜索

**思路与算法**

我们可以使用广度优先搜索寻找将初始值转化为目标值的最小次数。

在广度优先搜索的过程中，我们在队列中保存 $(x, \textit{step})$ 二元组，其中 $x$ 为当前整数的值，$\textit{step}$ 为当前值对应的转化次数。注意到如果 $x$ 不在可以操作的范围（本题为 $[0, 1000]$ 闭区间内的整数）内，除非 $x = \textit{goal}$ 恰好成立，否则由于我们无法进行任何操作，该数一定无法转化为目标值。故我们**无需将可操作范围以外的数值加入队列**。且由于初始值一定在可操作范围内，因此我们可以保证队列中的值一定在可操作范围内。

除此以外，为了避免重复遍历，我们需要用数组 $\textit{vis}$ 来维护**可操作范围内整数**是否已被加入过队列。

当我们遍历到 $x$ 时，我们枚举数组中的元素和加、减与按位异或三种操作，计算生成的值 $\textit{nx}$，此时有以下几种情况：

- $\textit{nx}$ 恰好等于目标值 $\textit{goal}$，此时我们应当返回 $\textit{step}) + 1$，即初始值转化为目标值的最小次数作为答案；

- $\textit{nx}$ 不在可操作范围，此时我们无需做任何操作；

- $\textit{nx}$ 在可操作范围，且 $\textit{nx}$ 已被加入过队列，此时我们无需做任何操作；

- $\textit{nx}$ 在可操作范围，且 $\textit{nx}$ 未被加入过队列，此时我们需要更新 $\textit{nx}$ 的访问情况，并将 $(\textit{nx}, \textit{step} + 1)$ 二元组加入队列。其中 $\textit{step} + 1$ 为新生成的值对应的转化次数。

最终，如果不存在转化为目标值的方案，我们返回 $-1$ 作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumOperations(vector<int>& nums, int start, int goal) {
        int n = nums.size();
        auto op1 = [](int x, int y) -> int { return x + y; };
        auto op2 = [](int x, int y) -> int { return x - y; };
        auto op3 = [](int x, int y) -> int { return x ^ y; };
        vector<function<int(int, int)>> ops = {op1, op2, op3};   // 运算符列表
        vector<int> vis(1001, 0);   // 可操作范围内整数的访问情况
        queue<pair<int, int>> q;
        q.emplace(start, 0);
        vis[start] = 1;
        while (!q.empty()){
            auto [x, step] = q.front();
            q.pop();
            // 枚举数组中的元素和操作符并计算新生成的数值
            for (int i = 0; i < n; ++i){
                for (auto& op: ops){
                    int nx = op(x, nums[i]);
                    // 如果新生成的数值等于目标值，则返回对应操作数
                    if (nx == goal){
                        return step + 1;
                    }
                    // 如果新生成的数值位于可操作范围内且未被加入队列，则更改访问情况并加入队列
                    if (nx >= 0 && nx <= 1000 && !vis[nx]){
                        vis[nx] = 1;
                        q.emplace(nx, step + 1);
                    }
                }
            }
        }
        // 不存在从初始值到目标值的转化方案
        return -1;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def minimumOperations(self, nums: List[int], start: int, goal: int) -> int:
        n = len(nums)
        op1 = lambda x, y: x + y
        op2 = lambda x, y: x - y
        op3 = lambda x, y: x ^ y
        ops = [op1, op2, op3]   # 运算符列表
        vis = [False] * 1001   # 可操作范围内整数的访问情况
        q = deque([(start, 0)])
        vis[start] = True
        while q:
            x, step = q.popleft()
            # 枚举数组中的元素和操作符并计算新生成的数值
            for i in range(n):
                for op in ops:
                    nx = op(x, nums[i])
                    # 如果新生成的数值等于目标值，则返回对应操作数
                    if nx == goal:
                        return step + 1
                    # 如果新生成的数值位于可操作范围内且未被加入队列，则更改访问情况并加入队列
                    if 0 <= nx <= 1000 and vis[nx] is False:
                        vis[nx] = True
                        q.append((nx, step + 1))
        # 不存在从初始值到目标值的转化方案
        return -1
```


**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $n$ 为 $\textit{nums}$ 的长度，$m$ 为可对 $x$ 进行操作的取值范围大小。广度优先搜索至多需要将 $O(m)$ 个数值加入队列，对于每个加入队列的数值可能的操作种数为 $O(n)$ 个。

- 空间复杂度：$O(m)$。即为广度优先搜索队列的空间开销。