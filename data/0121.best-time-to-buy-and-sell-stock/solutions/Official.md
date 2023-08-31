## [121.买卖股票的最佳时机 中文官方题解](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock/solutions/100000/121-mai-mai-gu-piao-de-zui-jia-shi-ji-by-leetcode-)
### 📺 视频题解
![LeetCode 121买卖股票的最佳时机.mp4](8191f465-1b9c-46d9-9be6-23e68f604b59)

### 📖 文字题解
#### 解决方案

我们需要找出给定数组中两个数字之间的最大差值（即，最大利润）。此外，第二个数字（卖出价格）必须大于第一个数字（买入价格）。

形式上，对于每组 $i$ 和 $j$（其中 $j > i$）我们需要找出 $\max(prices[j] - prices[i])$。

#### 方法一：暴力法

```Java []
public class Solution {
    public int maxProfit(int[] prices) {
        int maxprofit = 0;
        for (int i = 0; i < prices.length - 1; i++) {
            for (int j = i + 1; j < prices.length; j++) {
                int profit = prices[j] - prices[i];
                if (profit > maxprofit) {
                    maxprofit = profit;
                }
            }
        }
        return maxprofit;
    }
}
```
```python []
# 此方法会超时
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        ans = 0
        for i in range(len(prices)):
            for j in range(i + 1, len(prices)):
                ans = max(ans, prices[j] - prices[i])
        return ans
```
```C++ []
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int n = (int)prices.size(), ans = 0;
        for (int i = 0; i < n; ++i){
            for (int j = i + 1; j < n; ++j) {
                ans = max(ans, prices[j] - prices[i]);
            }
        }
        return ans;
    }
};
```


**复杂度分析**

* 时间复杂度：$O(n^2)$。循环运行 $\dfrac{n (n-1)}{2}$ 次。
* 空间复杂度：$O(1)$。只使用了常数个变量。




#### 方法二：一次遍历

**算法**

假设给定的数组为：`[7, 1, 5, 3, 6, 4]`

如果我们在图表上绘制给定数组中的数字，我们将会得到：

![Profit Graph](https://pic.leetcode-cn.com/cc4ef55d97cfef6f9215285c7573027c4b265c31101dd54e8555a7021c95c927-file_1555699418271){:width="400px"}
{:align="center"}

我们来假设自己来购买股票。随着时间的推移，每天我们都可以选择出售股票与否。那么，假设在第 `i` 天，如果我们要在今天卖股票，那么我们能赚多少钱呢？

显然，如果我们真的在买卖股票，我们肯定会想：如果我是在历史最低点买的股票就好了！太好了，在题目中，我们只要用一个变量记录一个历史最低价格 `minprice`，我们就可以假设自己的股票是在那天买的。那么我们在第 `i` 天卖出股票能得到的利润就是 `prices[i] - minprice`。

因此，我们只需要遍历价格数组一遍，记录历史最低点，然后在每一天考虑这么一个问题：如果我是在历史最低点买进的，那么我今天卖出能赚多少钱？当考虑完所有天数之时，我们就得到了最好的答案。

```Java []
public class Solution {
    public int maxProfit(int prices[]) {
        int minprice = Integer.MAX_VALUE;
        int maxprofit = 0;
        for (int i = 0; i < prices.length; i++) {
            if (prices[i] < minprice) {
                minprice = prices[i];
            } else if (prices[i] - minprice > maxprofit) {
                maxprofit = prices[i] - minprice;
            }
        }
        return maxprofit;
    }
}
```
```python []
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        inf = int(1e9)
        minprice = inf
        maxprofit = 0
        for price in prices:
            maxprofit = max(price - minprice, maxprofit)
            minprice = min(price, minprice)
        return maxprofit
```
```C++ []
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int inf = 1e9;
        int minprice = inf, maxprofit = 0;
        for (int price: prices) {
            maxprofit = max(maxprofit, price - minprice);
            minprice = min(price, minprice);
        }
        return maxprofit;
    }
};
```


**复杂度分析**

* 时间复杂度：$O(n)$，只需要遍历一次。
* 空间复杂度：$O(1)$，只使用了常数个变量。