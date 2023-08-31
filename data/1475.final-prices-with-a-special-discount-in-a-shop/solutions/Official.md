## [1475.商品折扣后的最终价格 中文官方题解](https://leetcode.cn/problems/final-prices-with-a-special-discount-in-a-shop/solutions/100000/shang-pin-zhe-kou-hou-de-zui-zhong-jie-g-ind3)

#### 方法一：直接遍历

对于第 $i$ 件商品的价格为 $\textit{prices}[i]$，我们需要查找到相应可能的折扣。按照题目要求，我们从第 $i + 1$ 件商品开始依次向后遍历，直到找到第一个满足 $\textit{prices}[j] \le \textit{prices}[i]$ 的下标 $j$ 即可求出该物品的最终折扣价格。我们按照题目要求依次遍历即可。

```Python [sol1-Python3]
class Solution:
    def finalPrices(self, prices: List[int]) -> List[int]:
        n = len(prices)
        ans = [0] * n
        for i, p in enumerate(prices):
            discount = 0
            for j in range(i + 1, n):
                if prices[j] <= p:
                    discount = prices[j]
                    break
            ans[i] = p - discount
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> finalPrices(vector<int>& prices) {
        int n = prices.size();
        vector<int> ans;
        for (int i = 0; i < n; ++i) {
            int discount = 0;
            for (int j = i + 1; j < n; ++j) {
                if(prices[j] <= prices[i]){
                    discount = prices[j];
                    break;
                }
            }
            ans.emplace_back(prices[i] - discount);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] finalPrices(int[] prices) {
        int n = prices.length;
        int[] ans = new int[n];
        for (int i = 0; i < n; ++i) {
            int discount = 0;
            for (int j = i + 1; j < n; ++j) {
                if(prices[j] <= prices[i]){
                    discount = prices[j];
                    break;
                }
            }
            ans[i] = prices[i] - discount;
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] FinalPrices(int[] prices) {
        int n = prices.Length;
        int[] ans = new int[n];
        for (int i = 0; i < n; ++i) {
            int discount = 0;
            for (int j = i + 1; j < n; ++j) {
                if(prices[j] <= prices[i]){
                    discount = prices[j];
                    break;
                }
            }
            ans[i] = prices[i] - discount;
        }
        return ans;
    }
}
```

```C [sol1-C]
int* finalPrices(int* prices, int pricesSize, int* returnSize) {
    int *ans = (int *)malloc(sizeof(int) * pricesSize);
    for (int i = 0; i < pricesSize; ++i) {
        int discount = 0;
        for (int j = i + 1; j < pricesSize; ++j) {
            if(prices[j] <= prices[i]){
                discount = prices[j];
                break;
            }
        }
        ans[i] = prices[i] - discount;
    }
    *returnSize = pricesSize;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var finalPrices = function(prices) {
    const n = prices.length;
    const ans = new Array(n).fill(0);
    for (let i = 0; i < n; ++i) {
        let discount = 0;
        for (let j = i + 1; j < n; ++j) {
            if(prices[j] <= prices[i]){
                discount = prices[j];
                break;
            }
        }
        ans[i] = prices[i] - discount;
    }
    return ans;
};  
```

```go [sol1-Golang]
func finalPrices(prices []int) []int {
    ans := make([]int, len(prices))
    for i, p := range prices {
        discount := 0
        for _, q := range prices[i+1:] {
            if q <= p {
                discount = q
                break
            }
        }
        ans[i] = p - discount
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n ^ 2)$，其中 $n$ 为数组的长度。对于每个商品，我们需要遍历一遍数组查找符合题目要求的折扣。

- 空间复杂度：$O(1)$。返回值不计入空间复杂度。

#### 方法二：单调栈

本题可以采用「[单调栈](https://oi-wiki.org/ds/monotonous-stack/)」的解法，可以参考「[496. 下一个更大元素 I 的官方题解](https://leetcode.cn/problems/next-greater-element-i/solution/xia-yi-ge-geng-da-yuan-su-i-by-leetcode-bfcoj/)」。使用单调栈先预处理 $\textit{prices}$，使得查询 $\textit{prices}$ 中每个元素对应位置的右边的第一个更小的元素值时不需要再遍历 $\textit{prices}$。解法的重点在于考虑如何更高效地计算 $\textit{prices}$ 中每个元素右边第一个更小的值。倒序遍历 $\textit{prices}$，并用单调栈中维护当前位置右边的更小的元素列表，从栈底到栈顶的元素是单调递增的。具体每次我们移动到数组中一个新的位置 $i$，就将单调栈中所有大于 $\textit{prices}[i]$ 的元素弹出单调栈，当前位置右边的第一个小于等于 $\textit{prices}[i]$ 的元素即为栈顶元素，如果栈为空则说明当前位置右边没有更大的元素，随后我们将位置 $i$ 的元素入栈。

当遍历第 $i$ 个元素 $\textit{prices}[i]$ 时：

+ 如果当前栈顶的元素大于 $\textit{prices}[i]$，则将栈顶元素出栈，直到栈顶的元素小于等于 $\textit{prices}[i]$，栈顶的元素即为右边第一个小于 $\textit{prices}[i]$ 的元素；

+ 如果当前栈顶的元素小于等于 $\textit{prices}[i]$，此时可以知道当前栈顶元素即为 $i$ 的右边第一个小于等于 $\textit{prices}[i]$ 的元素，此时第 $i$ 个物品折后的价格为 $\textit{prices}[i]$  与栈顶的元素的差。

+ 如果当前栈中的元素为空，则此时折扣为 $0$，商品的价格为原价 $\textit{prices}[i]$；

+ 将 $\textit{prices}[i]$ 压入栈中，保证 $\textit{prices}[i]$ 为当前栈中的最大值；

```Python [sol2-Python3]
class Solution:
    def finalPrices(self, prices: List[int]) -> List[int]:
        n = len(prices)
        ans = [0] * n
        st = [0]
        for i in range(n - 1, -1, -1):
            p = prices[i]
            while len(st) > 1 and st[-1] > p:
                st.pop()
            ans[i] = p - st[-1]
            st.append(p)
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> finalPrices(vector<int>& prices) {
        int n = prices.size();
        vector<int> ans(n);
        stack<int> st;
        for (int i = n - 1; i >= 0; i--) {
            while (!st.empty() && st.top() > prices[i]) {
                st.pop();
            }
            ans[i] = st.empty() ? prices[i] : prices[i] - st.top();
            st.emplace(prices[i]);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] finalPrices(int[] prices) {
        int n = prices.length;
        int[] ans = new int[n];
        Deque<Integer> stack = new ArrayDeque<Integer>();
        for (int i = n - 1; i >= 0; i--) {
            while (!stack.isEmpty() && stack.peek() > prices[i]) {
                stack.pop();
            }
            ans[i] = stack.isEmpty() ? prices[i] : prices[i] - stack.peek();
            stack.push(prices[i]);
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int[] FinalPrices(int[] prices) {
        int n = prices.Length;
        int[] ans = new int[n];
        Stack<int> stack = new Stack<int>();
        for (int i = n - 1; i >= 0; i--) {
            while (stack.Count > 0 && stack.Peek() > prices[i]) {
                stack.Pop();
            }
            ans[i] = stack.Count == 0 ? prices[i] : prices[i] - stack.Peek();
            stack.Push(prices[i]);
        }
        return ans;
    }
}
```

```C [sol2-C]
int* finalPrices(int* prices, int pricesSize, int* returnSize) {
    int *ans = (int *)malloc(sizeof(int) * pricesSize);
    int *stack = (int *)malloc(sizeof(int) * pricesSize);
    int top = 0;
    for (int i = pricesSize - 1; i >= 0; i--) {
        while (top > 0 && stack[top - 1] > prices[i]) {
            top--;
        }
        ans[i] = top == 0 ? prices[i] : prices[i] - stack[top - 1];
        stack[top++] = prices[i];
    }
    *returnSize = pricesSize;
    free(stack);
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var finalPrices = function(prices) {
    const n = prices.length;
    const ans = new Array(n).fill(0);
    const stack = [];
    for (let i = n - 1; i >= 0; i--) {
        while (stack.length && stack[stack.length - 1] > prices[i]) {
            stack.pop();
        }
        ans[i] = stack.length === 0 ? prices[i] : prices[i] - stack[stack.length - 1];
        stack.push(prices[i]);
    }
    return ans;
};  
```

```go [sol2-Golang]
func finalPrices(prices []int) []int {
    n := len(prices)
    ans := make([]int, n)
    st := []int{0}
    for i := n - 1; i >= 0; i-- {
        p := prices[i]
        for len(st) > 1 && st[len(st)-1] > p {
            st = st[:len(st)-1]
        }
        ans[i] = p - st[len(st)-1]
        st = append(st, p)
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。只需遍历一遍数组即可。

- 空间复杂度：$O(n)$。需要栈空间存储中间变量，需要的空间为 $O(n)$。