## [1521.找到最接近目标值的函数值 中文官方题解](https://leetcode.cn/problems/find-a-value-of-a-mysterious-function-closest-to-target/solutions/100000/zhao-dao-zui-jie-jin-mu-biao-zhi-de-han-shu-zhi-by)

**思路**

我们定义「[按位与运算](https://baike.baidu.com/item/%E6%8C%89%E4%BD%8D%E4%B8%8E)」为题目描述中的 $\&$ 运算，「按位与之和」为若干个数依次进行 $\&$ 运算得到的值。由于：

- 按位与运算满足交换律，即 $a~\&~b$ 等于 $b~\&~a$；

- 按位与运算满足结合律，即 $a~\&~b~\&~c$ 等于 $a~\&~(b~\&~c)$。

所以给定的若干个数按照任意顺序进行按位与运算，得到的值都是相同的，即「按位与之和」的定义无歧义。

题目中的函数 $\textit{func}(\textit{arr}, l, r)$ 实际上求的就是 $\textit{arr}[l]$ 到 $\textit{arr}[r]$ 的按位与之和，即：

$$
\textit{arr}[l]~\&~\textit{arr}[l+1]~\&~ \cdots ~\&~\textit{arr}[r-1]~\&~\textit{arr}[r]
$$

如果我们直接暴力地枚举 $l$ 和 $r$，求出 $\textit{func}(\textit{arr}, l, r)$ 的值并更新答案，那么时间复杂度至少是 $O(n^2)$ 的（其中 $n$ 是数组 $\textit{arr}$ 的长度）。要想通过本题，我们需要挖掘按位与之和的一些有趣的性质。

如果我们固定右端点 $r$，那么左端点 $l$ 可以选择 $[0, r]$ 这个区间内的任意整数。如果我们从大到小枚举 $l$，那么：

- 按位与之和是随着 $l$ 的减小而单调递减的。

    > 由于按位与运算满足结合律，所以 $\textit{func}(\textit{arr}, l, r) = \textit{arr}[l]~\&~\textit{func}(\textit{arr}, l+1, r)$。并且由于按位与运算本身的性质，$a~\&~b$ 的值不会大于 $a$，也不会大于 $b$。因此 $\textit{func}(\textit{arr}, l, r) \leq \textit{func}(\textit{arr}, l+1, r)$，即按位与之和是随着 $l$ 的减小而单调递减的。

- 按位与之和最多只有 $20$ 种不同的值。

    > 当 $l=r$ 时，按位与之和就是 $\textit{arr}[r]$。随着 $l$ 的减小，按位与之和变成 $\textit{arr}[r-1]~\&~\textit{arr}[r]$，$\textit{arr}[r-2]~\&~\textit{arr}[r-1]~\&~arr[r]$ 等等。由于 $\textit{arr}[r] \leq 10^6 < 2^{20}$，那么 $\textit{arr}[r]$ 的**二进制表示**中最多有 $20$ 个 $1$。而每进行一次按位与运算，如果按位与之和发生了变化，那么值中有若干个 $1$ 变成了 $0$。由于在按位与运算中，$0$ 不能变回 $1$。因此值的变化的次数不会超过 $\textit{arr}[r]$ 二进制表示中 $1$ 的个数，即 $\textit{func}(\textit{arr}, l, r)$ 的值最多只有 $20$ 种。

**算法**

根据上面的分析，我们知道对于固定的右端点 $r$，按位与之和最多只有 $20$ 种不同的值，因此我们可以使用一个集合维护所有的值。

我们从小到大遍历 $r$，并用一个集合实时地维护 $\textit{func}(\textit{arr}, l, r)$ 的所有不同的值，集合的大小不过超过 $20$。当我们从 $r$ 遍历到 $r+1$ 时，以 $r+1$ 为右端点的值，就是集合中的每个值和 $\textit{arr}[r+1]$ 进行按位与运算得到的值，再加上 $\textit{arr}[r+1]$ 本身。我们对这些新的值进行去重，就可以得到 $\textit{func}(\textit{arr}, l, r+1)$ 对应的值的集合。

在遍历的过程中，当我们每次得到新的集合，就对集合中的每个值更新一次答案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int closestToTarget(vector<int>& arr, int target) {
        int ans = abs(arr[0] - target);
        vector<int> valid = {arr[0]};
        for (int num: arr) {
            vector<int> validNew = {num};
            ans = min(ans, abs(num - target));
            for (int prev: valid) {
                validNew.push_back(prev & num);
                ans = min(ans, abs((prev & num) - target));
            }
            validNew.erase(unique(validNew.begin(), validNew.end()), validNew.end());
            valid = validNew;
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int closestToTarget(int[] arr, int target) {
        int ans = Math.abs(arr[0] - target);
        List<Integer> valid = new ArrayList<Integer>();
        valid.add(arr[0]);
        for (int num : arr) {
            List<Integer> validNew = new ArrayList<Integer>();
            validNew.add(num);
            int last = num;
            ans = Math.min(ans, Math.abs(num - target));
            for (int prev : valid) {
                int curr = prev & num;
                if (curr != last) {
                    validNew.add(curr);
                    ans = Math.min(ans, Math.abs(curr - target));
                    last = curr;
                }
            }
            valid = validNew;
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def closestToTarget(self, arr: List[int], target: int) -> int:
        ans = abs(arr[0] - target)
        valid = {arr[0]}
        for num in arr:
            valid = {x & num for x in valid} | {num}
            ans = min(ans, min(abs(x - target) for x in valid))
        return ans
```

```C [sol1-C]
int closestToTarget(int* arr, int arrSize, int target) {
    int ans = abs(arr[0] - target);
    int* valid = (int*)malloc(sizeof(int) * 20);
    int num = 1;
    valid[0] = arr[0];
    for (int i = 0; i < arrSize; i++) {
        int* validNew = (int*)malloc(sizeof(int) * 20);
        int numNew = 1;
        validNew[0] = arr[i];
        ans = fmin(ans, fabs(arr[i] - target));
        for (int j = 0; j < num; j++) {
            validNew[numNew++] = valid[j] & arr[i];
            ans = fmin(ans, fabs((valid[j] & arr[i]) - target));
        }
        int add = 0;
        for (int j = 1; j < numNew; j++) {
            if (validNew[add] != validNew[j]) validNew[++add] = validNew[j];
        }
        num = add + 1;
        free(valid);
        valid = validNew;
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log C)$，这里的 $C$ 是数组元素的最大范围，本题中 $\log C = \log_2 10^6 \approx 20$。

- 空间复杂度：$O(\log C)$，记为集合中的值的最多数量。

**思考**

在上面的 `C++` 代码中，我们使用了 `unique() + erase()` 进行去重操作。然而 `unique()` 函数必须在数组有序时才能使用。我们没有对数组进行过排序，但为什么它是正确的呢？

答案：可以使用数学归纳法。

- 当 $r=0$ 时，集合中只有一个值，显然是有序的；

- 假设当 $r=r_0$ 时有序，那么当 $r=r_0+1$ 时，将一个有序的集合对同一个数 $\textit{arr}[r_0+1]$ 进行按位与运算，得到的集合仍然保持有序。并且我们是在一开始就将 $\textit{arr}[r_0+1]$ 加入了集合，它显然不小于集合中的所有数。因此最终的集合是有序的，进行去重操作后也仍然保持有序。