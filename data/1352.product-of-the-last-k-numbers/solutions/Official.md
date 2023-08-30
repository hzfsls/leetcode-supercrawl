#### 方法一：


如果没有 $0$ 的话，直接考虑维护一个前缀积 $pre[i]$ 表示前 $i$ 个数的乘积即可，答案就是 $\frac{pre[n]}{pre[n-k]}$，其中 $n$ 表示当前 $pre$ 数组的长度。那么如何处理 $0$ 呢？可以注意到如果出现 $0$ 的话，那么 $0$ 之前的数对答案都是没有用的了，所以我们可以遇到 $0$ 的时候直接清空 $pre$ 数组，那么询问的时候我们要求的是末尾 $k$ 个数的乘积，如果这时候我们 $pre$ 数组的长度小于 $k$，说明末尾 $k$ 个数里肯定有 $0$，直接输出 $0$ 即可，否则输出 $\frac{pre[n]}{pre[n-k]}$，简言之：
$$
getProduct(k)=\left\{\begin{matrix}
0, n< k\\ 
\frac{pre[n]}{pre[n-k]},n\geq k
\end{matrix}\right.
$$
，其中$n=pre.length()$。

```C++ []
class ProductOfNumbers {
public:
    #define N 40010
    int len,pre[N];
    ProductOfNumbers() {
        pre[0]=1;
        len=0;
    }
    
    void add(int num) {
        if (!num) len=0;
        else{
            pre[++len]=num;
            pre[len]*=pre[len-1];
        }
    }
    
    int getProduct(int k) {
        if (len<k) return 0;
        return pre[len]/pre[len-k];
    }
};

/**
 * Your ProductOfNumbers object will be instantiated and called as such:
 * ProductOfNumbers* obj = new ProductOfNumbers();
 * obj->add(num);
 * int param_2 = obj->getProduct(k);
 */
```



**复杂度分析**

- **时间复杂度：**$add$ 和 $getProduct$ 复杂度均为 $O(1)$。
- **空间复杂度**：$O(n)$，需要额外提供一个辅助数组。

#### 方法二：


注意到题目说了一句话：**题目数据保证：任何时候，任一连续数字序列的乘积都在 32-bit 整数范围内，不会溢出**，这其实告诉了我们如果只乘大于 $1$ 的数话，数字序列长度最多不会超过 $32$，因为大于 $1$ 最小的数 $2$ 的连着 $32$ 个乘起来已经达到题目乘积的上界，所以我们只需要忽略 $0$ 和 $1$，在查询的时候暴力乘复杂度就能得到保证。



开三个数组：

- $vec[i]$：存加入的数字 $vec[i]$
- $cnt[i]$：前 $i$ 数里 $0$ 的个数和，即 $0$ 个数的前缀和
- $pre[i]$：$[0..i-1]$ 最后一个非 $0$ 和非 $1$ 的位置

对于 $add$ 操作：主要是 $cnt$ 和 $pre$ 数组怎么更新，由于 $cnt$ 存的是 $0$ 个数的前缀和，所以可以得到
$$
cnt[n]=cnt[n-1]+(num==0)
$$
对于 $pre$ 数组，由定义也很容易得到转移式：
$$
pre[n]=\left\{\begin{matrix}
pre[n-1], vec[n-1]<=1\\ 
n-1,vec[n-1]>1
\end{matrix}\right.
$$
更新都是 $O(1)$ 的。

对于 $getProduct$ 操作：先通过 $cnt$ 数组差分得到末尾 $k$ 个数里 $0$ 的个数，如果大于 $0$ 直接返回 $0$ 即可，否则就根据 $pre[i]$ 从最后一个位置开始不断往前跳然后计算答案，直到跳过 $k$ 个数结束，根据前面的性质分析我们会知道这个过程最多跳 $32$ 次。



```C++ []
class ProductOfNumbers {
public:
    vector<int>vec,zero,pre;
    int n;
    ProductOfNumbers() {
        vec.clear();
        zero.clear();
        pre.clear();
        n=0;
    }
    
    void add(int num) {
        n++;
        vec.push_back(num);
        pre.push_back(-1);
        if (n>1){
            if (vec[n-2]!=1 && vec[n-2]!=0) pre[n-1]=n-2;
            else pre[n-1]=pre[n-2];
        }
        zero.push_back(num==0?1:0);
        if (n>1) zero[n-1]+=zero[n-2];
    }
    
    int getProduct(int k) {
        int tot=zero[n-1];
        if (n-k>=1) tot-=zero[n-1-k];
        if (tot>0) return 0;
        int ans=1;
        for (int i=n-1;i>=n-k;){
            ans*=vec[i];
            i=pre[i];
        }
        return ans;
    }
};
```



**复杂度分析**

- **时间复杂度：**$add$ 操作复杂度为 $O(1)$ 和 $getProduct$ 操作复杂度最坏情况为 $O(log_2S)$，$S$ 为值域的上界。
- **空间复杂度**：$O(n)$，需要额外提供三个辅助数组。