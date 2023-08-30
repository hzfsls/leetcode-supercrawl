#### 解题思路：

注意到这个操作是可逆的，即数组中最大的数肯定是最后一次被替换后的数，也即上一轮的数组和，我们记这个最大的数为 $s$ ，这一轮的数组和为 $sum$ ，则我们可以知道被替换的数就是
$$
s-(sum-s)
$$
这样就可以还原到上一轮，即操作可逆。

再观察到一个性质：**如果最大的数被替换掉以后还是最大的数，那么每次减去的差值，即 (sum-s) 是恒定不变的**，因为这个差值就是除这个最大的数以外的所有的数之和，每次逆操作不会影响到这些数，也就不会影响到这些数之和，我们可以根据此对我们原来的操作加速。

我们设当前轮最大的数是 $x$ ，第二大的数是 $y$ ，这一轮数组和为 $sum$ ，分两种情况，如果$y$ 为 $1$ ，则我们需要把 $x$ 减到 $1$ ，否则需要将 $x$ 减到小于 $y$ ，已知差值为 $sum-x$ ，设减了 $k$ 次以后 $x$ 小于 $y$ ，针对情况 $2$ 我们可以列出不等式：
$$
x-k*(sum-x)<y
$$
解得
$$
k>\frac{x-y}{sum-x}
$$
即 $k=\frac{x-y}{sum-x}+1$。

情况 $1$ 同理可以列出一个不等式：
$$
x-k*(sum-x)<=y
$$
解得

$$k>=\frac{x-y}{sum-x}$$

由于后者除出来的结果可能是小数，所以解出来的 $k$ 分两种情况，一种 $x-y$ 整除 $sum-x$ 的时候 $k=\frac{x-y}{sum-x}$ ，不整除的时候 $k=\frac{x-y}{sum-x}+1$ ，也可以直接整合成一个式子，即：
$$
k=\frac{x-y+sum-x-1}{sum-x}
$$
简单解释就是当 $x-y$ 整除 $sum-x$ 的时候 $\frac{sum-x-1}{sum-x}$ 为 $0$ ，不整除的时候说明 $x-y$ 模 $sum-x$ 大于等于1，那么再加上 $sum-x-1$ 就大于等于 $sum-x$ ，产生了 $1$ 的贡献，符合上面分类讨论的结果。

然后我们就可以根据两种情况更新 $x$，同时拿一个优先队列维护数组最大值， $O(1)$ 取出最大值，$O(logn)$ 插入了，实现快速更新。


```C++ []
class Solution {
public:
    long long tot=0;
    priority_queue<int>Q;
    bool isPossible(vector<int>& target) {
        if ((int)target.size()==1) return target[0]==1;
        while (!Q.empty()) Q.pop();
        for(auto x:target) Q.push(x),tot+=x;
        while (!Q.empty()){
            int x=Q.top();Q.pop();
            if (x==1) break;
            if (x*2-tot<1) return false;
            long long left=tot-x;
            long long y=Q.top();
            long long k;
            if (y==1) k=(x-y+left-1)/left;
            else k=(x-y)/left+1;
            x-=k*left;
            if (x<=0) return false;
            tot-=k*left;
            Q.push(x);
        }
        return true;
    }
};
```

**复杂度分析**

- **时间复杂度：**$O(nlogS)$，$S=max_{i=0}^{N-1}target_i$，我们假设长度为 $n$ 的数组最大值为 $target_1$ ，次大值为 $target_2$ ，将要被替换的数是 $C$ ，则我们可以知道
  $$
  target_1=k*(sum-target_1)+C(C< target_2)
  $$
  而 $target_2<sum-target_1$ ，所以我们可以得到
  $$
  C<sum-target_1
  $$
  等价于
  $$
  target_1=k*(sum-target_1)+C>k*C+C>(k+1)*C
  $$
  而 $k\geq 1$ ，因为至少进行一次操作，所以我们可以知道
  $$
  target_1>2*C
  $$
  所以我们可以知道被替换的数 $C$ 起码是 $target_1$ 的 $\frac{1}{2}$ 倍，也即每次$target_1$ 至少减半，从这里我们也可以看出这其实等价于一个取模的操作，所以需要每个数只需要 $log$ 次操作就能变成 $1$ ，一共有 $n$ 个数，所以得出了上述的时间复杂度。
  
- **空间复杂度：**$O(n)$ 。