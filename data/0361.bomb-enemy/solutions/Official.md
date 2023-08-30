#### 方法一：暴力

暴力枚举所有空位，统计答案，统计答案就是按题意朝 4 个方向延伸，直到碰到墙或者边界停止，统计这中间碰到的敌人数即可。

```C++ []
class Solution {
    int dir_x[4]={0,1,0,-1};
    int dir_y[4]={1,0,-1,0};
public:
    int maxKilledEnemies(vector<vector<char>>& grid) {
        if ((int)grid.size()==0) return 0;
        int ans=0,n=(int)grid.size(),m=(int)grid[0].size();
        for (int i=0;i<n;++i){
            for (int j=0;j<m;++j)if(grid[i][j]=='0'){
                int cnt=0;
                for (int k=0;k<4;++k){
                    int tx=i,ty=j;
                    while (tx>=0 && tx<n && ty>=0 && ty<m && grid[tx][ty]!='W'){// 判断是否碰到边界或者墙
                        cnt+=grid[tx][ty]=='E';
                        tx+=dir_x[k];
                        ty+=dir_y[k];
                    }
                }
                ans=max(ans,cnt);
            }
        }
        return ans;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(nm(n+m))$，其中 $n$ 为矩阵的行， $m$ 为矩阵的列。简单分析就是 $nm$ 为遍历矩阵的复杂度，$n+m$ 为统计一个空格答案的复杂度，因为最多延伸 $2(n+m)$次。
- 空间复杂度：$O(1)$。

#### 方法二：递推优化暴力

考虑上面的暴力，我们可以发现其实在统计一个空格的答案的时候我们没有考虑利用已有的信息。考虑第 $x$ 行格子往左延伸答案，我们定义 $ans[i]$ 为这一行第 $i$ 个格子往左延伸能碰到的敌人数，那么很容易的可以从前一个格子的答案递推过来，即：
$$ans[i]=\left\{\begin{matrix}0, grid[x][i]=='W'\\ ans[i-1], grid[x][i]=='0'\\ans[i-1]+1, grid[x][i]=='E'\end{matrix}\right.$$

注意到我们这样只统计了一个方向的答案，但其他三个方向也是一样的道理，统计完四个方向即统计出了这个位置放炸弹能炸到的敌人数，不用再暴力延伸。

针对 $ans[i]$ 我们注意到每次只与前一个位置的答案有关，所以不用再开数组，直接用一个 $pre$ 变量存储 $ans[i-1]$ 的答案即可。

```C++ []
class Solution {
public:
    int maxKilledEnemies(vector<vector<char>>& grid) {
        if ((int)grid.size()==0) return 0;
        int ans=0,pre,n=(int)grid.size(),m=(int)grid[0].size();
        vector<vector<int>> boom(n,vector<int> (m,0));
        for (int i=0;i<n;++i){
            pre=0;
            for (int j=0;j<m;++j){// 从左往右
                if (grid[i][j]=='W') pre=0;
                else if (grid[i][j]=='E') pre+=1;
                boom[i][j]+=pre;
            }

            pre=0;
            for (int j=m-1;j>=0;--j){// 从右往左
                if (grid[i][j]=='W') pre=0;
                else if (grid[i][j]=='E') pre+=1;
                boom[i][j]+=pre;
            }
        }
        for (int j=0;j<m;++j){
            pre=0;
            for (int i=0;i<n;++i){// 从上到下
                if (grid[i][j]=='W') pre=0;
                else if (grid[i][j]=='E') pre+=1;
                boom[i][j]+=pre;
            }

            pre=0;
            for (int i=n-1;i>=0;--i){// 从下到上
                if (grid[i][j]=='W') pre=0;
                else if (grid[i][j]=='E') pre+=1;
                boom[i][j]+=pre;
            }
        }
        for (int i=0;i<n;++i){
            for (int j=0;j<m;++j)if(grid[i][j]=='0'){
                ans=max(ans,boom[i][j]);
            }
        }
        return ans;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(nm)$ ，其中 $n$ 为矩阵的行，$m$ 为矩阵的列。
- 空间复杂度：$O(nm)$ ，需要额外开一个二维数组存储这个位置的答案。