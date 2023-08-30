#### 方法一：暴力

观察数据范围注意到矩阵大小不会超过 $100*100=10^4$，所以我们可以遍历矩阵所有数，统计负数的个数。


```C++ []
class Solution {
public:
    int countNegatives(vector<vector<int>>& grid) {
        int num=0;
        for (auto x:grid){
            for (auto y:x){
                if (y<0) num++;
            }
        }
        return num;
    }
};
```
**复杂度分析**

- 时间复杂度：$O(nm)$，即矩阵元素的总个数。
- 空间复杂度：$O(1)$。

#### 方法二：二分查找

注意到题目中给了一个性质，即**矩阵中的元素无论是按行还是按列，都以非递增顺序排列**，可以考虑把这个性质利用起来优化暴力。已知这个性质告诉了我们每一行的数都是有序的，所以我们通过二分查找可以找到每一行中从前往后的第一个负数，那么这个位置之后到这一行的末尾里所有的数必然是负数了，可以直接统计。


1. 遍历矩阵的每一行。

2. 二分查找到该行从前往后的第一个负数，考虑第 $i$ 行，我们记这个位置为 $pos_i$，那么第 $i$ 行 $[pos_i,m-1]$ 中的所有数都是负数，所以这一行对答案的贡献就是 $m-1-pos_i+1=m-pos_i$。

3. 最后的答案就是 $\sum_{i=0}^{n-1}(m-pos_i)$。


```C++ []
class Solution {
public:
    int countNegatives(vector<vector<int>>& grid) {
        int num=0;
        for (auto x:grid){
            int l=0,r=(int)x.size()-1,pos=-1;
            while (l<=r){
                int mid=l+((r-l)>>1);
                if (x[mid]<0){
                    pos=mid;
                    r=mid-1;
                }
                else l=mid+1;
            }
            if (~pos) num+=(int)x.size()-pos;// pos=-1表示这一行全是>=0的数，不能统计
        }
        return num;
    }
};
```

**复杂度分析**

- 时间复杂度：二分查找一行的时间复杂度为$logm$，需要遍历$n$行，所以总时间复杂度是$O(nlogm)$。
- 空间复杂度：$O(1)$。

#### 方法三：分治

方法二其实只利用了一部分的性质，即每一行是非递增的，但其实整个矩阵是**每行每列均非递增**，这说明了一个更重要的性质：**每一行从前往后第一个负数的位置是不断递减的**，即我们设第 $i$ 行的第一个负数的位置为 $pos_i$，不失一般性，我们把一行全是正数的 $pos$ 设为 $m$，则
$$
pos_0>=pos_1>=pos_2>=...>=pos_{n-1}
$$
所以我们可以依此设计一个分治算法。



我们设计一个函数 $solve(l,r,L,R)$ 表示我们在统计 $[l,r]$ 行的答案，第 $[l,r]$ 行 $pos$ 的位置在 $[L,R]$ 列中，计算 $[l,r]$ 的中间行第 $mid$ 行的的 $pos_{mid}$，算完以后根据之前的方法计算这一行对答案的贡献。然后根据我们之前发现的性质，可以知道 $[l,mid-1]$ 中所有行的 $pos$ 是大于等于 $pos_{mid}$，$[mid+1,r]$ 中所有行的 $pos$ 值是小于等于 $pos_{mid}$ 的，所以可以分成两部分递归下去，即：
$$
solve(l,mid-1,pos_{mid},R)
$$
和
$$
solve(mid+1,r,L,pos_{mid})
$$
所以答案就是 $m-pos_{mid}+solve(l,mid-1,pos_{mid},R)+solve(mid+1,r,L,pos_{mid})$。

递归函数入口为 $solve(0,n-1,0,m-1)$。

```C++ []
class Solution {
public:
    int solve(int l,int r,int L,int R,vector<vector<int> > grid){
        if (l>r) return 0;
        int mid=l+((r-l)>>1),pos=-1;
        for (int i=L;i<=R;++i){
            if (grid[mid][i]<0){
                pos=i;
                break;
            }
        }
        int ans=0;
        if (~pos){
            ans+=(int)grid[0].size()-pos;
            ans+=solve(l,mid-1,pos,R,grid);
            ans+=solve(mid+1,r,L,pos,grid);
        }
        else{// 说明[l..o-1]不会有负数，不用再去递归
            ans+=solve(mid+1,r,L,R,grid);
        }
        return ans;
    }
    int countNegatives(vector<vector<int>>& grid) {
        return solve(0,(int)grid.size()-1,0,(int)grid[0].size()-1,grid);
    }
};
```

**复杂度分析**

- 时间复杂度：代码中找第一个负数的位置是直接遍历 $[L,R]$ 找的，再考虑到 $n$ 和 $m$ 同阶，所以每个 $solve$ 函数里需要消耗 $O(n)$ 的时间，由主定理可得时间复杂度为：
  $$
  T(n)=2T(n/2)+O(n)=O(nlogn)
  $$

- 空间复杂度：$O(1)$。

#### 方法四：倒序遍历


考虑方法三发现的性质，我们可以设计一个更简单的方法。考虑我们已经算出第 $i$ 行的从前往后第一个负数的位置 $pos_i$，那么第 $i+1$ 行的时候，$pos_{i+1}$ 的位置肯定是位于 $[0,pos_i]$ 中，所以对于第 $i+1$ 行我们倒着从 $pos_i$ 循环找 $pos_{i+1}$ 即可，这个循环起始变量是一直在递减的。

```C++ []
class Solution {
public:
    int countNegatives(vector<vector<int>>& grid) {
        int num=0,m=(int)grid[0].size(),pos=(int)grid[0].size()-1;
        for (auto x:grid){
            int i;
            for (i=pos;i>=0;--i){
                if (x[i]>=0){
                    if (i+1<m){
                        pos=i+1;
                        num+=m-pos;
                    }
                    break;
                }
            }
            if (i==-1){
                num+=m;
                pos=-1;
            }
        }
        return num;
    }
};
```

**复杂度分析**

- 时间复杂度：考虑每次循环变量的起始位置是单调不降的，所以起始位置最多移动 $m$ 次，时间复杂度 $O(n+m)$。
- 空间复杂度：$O(1)$。