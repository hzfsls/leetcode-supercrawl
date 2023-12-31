## [487.最大连续1的个数 II 中文官方题解](https://leetcode.cn/problems/max-consecutive-ones-ii/solutions/100000/zui-da-lian-xu-1de-ge-shu-ii-by-leetcode-solution)

#### 方法一：预处理 + 枚举

直观的想法就是枚举每个 $0$ 的位置，把这个位置变成 $1$ ，统计它能把前后连成的最多的 $1$ 的个数。考虑位置 $i(0<i<n-1)$ ，从这个位置切开可以将整个数组（数组下标 $[0,n-1]$）分成三个部分：

1. $[0,i-1]$
2. $[i,i]$
3. $[i+1,n-1]$

则区间包含 $i$ 的最大连续 $1$ 的个数就是由第一部分的数组末尾往前延伸最大的连续 $1$ 的个数加上第三部分的数组开头往后延伸最大的连续 $1$ 的个数再加上把第 $i$ 个位置变成 $1$ 的总和。第一部分和第二部分我们都可以通过预处理数组来实现 $O(1)$ 查询。

预处理 $pre[i]$ 数组表示以 $i$ 结尾往前延伸最大连续 $1$ 的个数，则可以列出递推式：
$$\left\{\begin{matrix}pre[i-1]+1,nums[i]=1\\ 0,nums[i]=0\end{matrix}\right.$$

预处理 $suff[i]$ 数组表示以 $i$ 开头往后延伸最大连续 $1$ 的个数，则可以列出递推式：
$$\left\{\begin{matrix}suff[i+1]+1,nums[i]=1\\ 0,nums[i]=0\end{matrix}\right.$$

则位置 $i$ 的答案就是$pre[i-1]+1+suff[i+1]$

对于这一类最多改变一个位置的题都可以这么考虑，当然我们肯定还要统计原数组的最大连续 $1$ 的个数，这个直接在我们预处理两个数组的时候就可以统计出来了，即 $max_{i=0}^npre[i]$ 。

```C++ []
class Solution {
public:
    int findMaxConsecutiveOnes(vector<int>& nums) {
        int n=(int)nums.size(),ans=0;
        vector<int>pre(n,0),suff(n,0);
        for (int i=0;i<n;++i){
            if (i) pre[i]=pre[i-1];
            if (nums[i]) pre[i]++;
            else pre[i]=0;
            ans=max(ans,pre[i]);
        }
        for (int i=n-1;i>=0;--i){
            if (i<n-1) suff[i]=suff[i+1];
            if (nums[i]) suff[i]++;
            else suff[i]=0;
        }
        for (int i=0;i<n;++i)if(!nums[i]){
            int res=0;
            if (i>0) res+=pre[i-1];
            if (i<n-1) res+=suff[i+1];
            ans=max(ans,res+1);
        }
        return ans;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(n)$ ，预处理两个数组 $O(n)$， 最后统计答案也是 $O(n)$ 。
- 空间复杂度：$O(n)$， 需要额外两个辅助数组。

#### 方法二：动态规划

方法一其实没有办法解决进阶问题：**如果输入的数字是作为无限流逐个输入如何处理？换句话说，内存不能存储下所有从流中输入的数字。您可以有效地解决吗？** 因为它需要预先知道所有的数，而我们如果用动态规划则可以有效解决进阶问题。

定义 $dp[i][0]$ 为考虑到以 $i$ 为结尾未使用操作将 $[0,i]$ 某个 $0$ 变成 $1$ 的最大的连续 $1$ 的个数，$dp[i][1]$ 为考虑到以 $i$ 为结尾使用操作将 $[0,i]$ 某个 $0$ 变成 $1$ 的最大的连续 $1$ 的个数。则我们可以列出转移式：
$$dp[i][0]=\left\{\begin{matrix}
dp[i-1][0]+1,nums[i]=1\\ 
0,nums[i]=0
\end{matrix}\right.$$

和
$$dp[i][1]=\left\{\begin{matrix}
dp[i-1][1]+1,nums[i]=1\\ 
dp[i-1][0]+1,nums[i]=0
\end{matrix}\right.$$

解释一下，针对 $dp[i][0]$ ，如果当前位置是 $0$ ，由于未使用操作，所以肯定是 $0$，如果是 $1$，则从前一个位置未使用操作的状态转移过来即可。针对 $dp[i][1]$ ，如果当前位置是 $0$ ，则我们操作肯定是要用在这个位置，把它变成 $1$，所以只能从前一个未使用过操作的状态转移过来，如果是 $1$ ，则从前一个已经使用过操作的状态转移过来。

最后答案就是 $max_{i=0}^{n-1}max(dp[i][0],dp[i][1])$ 。

到这里其实还并不能解决进阶问题，因为开 $dp$ 数组仍然需要提前知道数组的大小，但是我们注意到每次转移只与前一个位置有关，所以我们并不需要开数组，只需要额外两个变量记录一下前一个位置的两个状态即可，这样我们就可以有效解决进阶的问题。

```C++ []
class Solution {
public:
    int findMaxConsecutiveOnes(vector<int>& nums) {
        int n=(int)nums.size(),ans=0,dp0=0,dp1=0;
        for (int i=0;i<n;++i){
            if (nums[i]){
                dp1++;
                dp0++;
            }
            else{
                dp1=dp0+1;
                dp0=0;
            }
            ans=max(ans,max(dp0,dp1));
        }
        return ans;
    }
};
```

**复杂度分析**

- 时间复杂度：由上面的转移式我们知道转移是$O(1)$ 的，一共有 $2n$ 个状态，所以时间复杂度为 $O(n)$。 
- 空间复杂度：$O(1)$ 。