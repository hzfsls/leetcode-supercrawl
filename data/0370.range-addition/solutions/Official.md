#### 方法一：差分数组

如果我们知道每一个元素比前一个元素大多少，以及第一元素的值，我们就可以 $O(n)$ 遍历数组求出所有数的值。举个例子，我们已知 $a_1=3$ ，$a_2$ 比 $a_1$ 大 5，则我们可以知道 $a_2=a_1+5=8$ 。

回到题目本身，每个操作其实代表了这样两个事情：

- $a_{startIndex}$ 比前一个元素多了 $inc$ 。
- $a_{endIndex + 1}$ 比前一个元素少了 $inc$ 。

则我们可以建立一个差分数组 $b$ 表示元素间的差值，即 $b_i=a_i-a_{i-1}$ ，则刚刚的操作就等价于：
- $b_{startIndex} += inc$ 。
- $b_{endIndex+1} -= inc$ 。

最后我们用 $b$ 数组求出 $a$ 数组，即为我们要的答案。

```C++ []
class Solution {
public:
    vector<int> getModifiedArray(int length, vector<vector<int>>& updates) {
        vector<int> vec(length,0);
        for (auto x:updates){
            vec[x[0]]+=x[2];
            if (x[1]+1<length) vec[x[1]+1]-=x[2]; 
        }
        for (int i=1;i<length;++i) vec[i]+=vec[i-1];
        return vec;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(k+n)$ ，每个操作值修改两个元素，即修改操作是 $O(1)$ 的，最后遍历差分数组是 $O(n)$ 的。
- 空间复杂度：$O(n)$ 。