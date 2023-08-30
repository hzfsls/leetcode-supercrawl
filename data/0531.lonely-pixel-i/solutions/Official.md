#### 方法一：暴力

根据题意可以知道我们要统计所有满足条件的**黑色像素**，那么我们枚举所有的黑色像素，检查是否满足条件即可。

假设当前枚举到的黑色像素坐标为 $(i,j)$ ，它满足条件当且仅当第 $i$ 行和 第 $j$ 列的黑色像素数量均为 $1$ ，所以我们遍历第 $i$ 行的所有像素，记该行黑色像素数量为 $row$ ，遍历第 $j$ 列的所有像素，记该列黑色像素为 $col$ ，则其满足条件的时候为：

$$row==1\ \&\&\ col==1$$

枚举每个黑色像素按上述方法检查是否满足条件，满足条件就将答案加一，最后输出即可。

```C++ []
class Solution {
public:
    int findLonelyPixel(vector<vector<char>>& picture) {
        int n=(int)picture.size(),m=(int)picture[0].size();
        int ans=0;
        for (int i=0;i<n;++i){
            for (int j=0;j<m;++j)if(picture[i][j]=='B'){
                int col=0,row=0;
                for (int k=0;k<m;++k){
                    row+=picture[i][k]=='B';
                }
                for (int k=0;k<n;++k){
                    col+=picture[k][j]=='B';
                }
                if (row==1 && col==1) ans++;
            }
        }
        return ans;
    }
};
```

**复杂度分析**

- 时间复杂度：枚举二维数组每个像素需要 $O(nm)$ 的时间复杂度，统计 $(i,j)$ 所在的第 $i$ 行和第 $j$ 列的黑色像素的个数需要 $O(n+m)$ 的时间，所以总时间复杂度为 $O(nm(n+m))$ ，其中 $n$ 为二维数组行数， $m$ 为二维数组列数。
- 空间复杂度：$O(1)$ ，不需要额外的空间。

#### 方法二：预处理

对于方法一中检查每个黑色元素是否满足条件我们可以再优化。我们可以发现按上述方法判断，每一行和每一列的黑色像素数量我们都重复统计了，所以我们可以提前预处理出第 $i$ 行的黑色像素数量 $row[i]$ 和第 $j$ 列的黑色像素数量 $col[j]$ ，这样判断一个黑色像素是否满足条件就由原来 $O(n+m)$ 的时间复杂度降为 $O(1)$ ，每次只要看一下 $row[i]$ 和 $col[j]$ 是否都为 1 即可。

预处理 $row[i]$ 和 $col[j]$ 即遍历二维数组，如果 $(i,j)$ 为黑色像素，则 $row[i]++$ ，$col[j]++$ 。

这样虽然预处理需要额外的 $O(nm)$ 的时间复杂度，但总的复杂度相较于方法一已经下降了一个数量级。

![fig1](https://assets.leetcode-cn.com/solution-static/531_fig1.gif)

```c++ []
class Solution {
    int row[505],col[505];
public:
    int findLonelyPixel(vector<vector<char>>& picture) {
        int n=(int)picture.size(),m=(int)picture[0].size();
        for (int i=0;i<n;++i){
            for (int j=0;j<m;++j){
                row[i]+=picture[i][j]=='B';
                col[j]+=picture[i][j]=='B';
            }
        }
        int ans=0;
        for (int i=0;i<n;++i)if(row[i]==1){
            for (int j=0;j<m;++j)if(picture[i][j]=='B'){
                ans+=col[j]==1;
            }
        }
        return ans;
    }
};
```
```golang []
func findLonelyPixel(picture [][]byte) int {
    x, y := map[int]int{}, map[int]int{}
    for i := 0; i < len(picture); i++ {
        for j := 0; j < len(picture[i]); j++ {
            if picture[i][j] == 'B' {
                x[i]++
                y[j]++
            }
        }
    }
    ret := 0
    for i := 0; i < len(picture); i++ {
        for j := 0; j < len(picture[i]); j++ {
            if picture[i][j] == 'B' && x[i] == 1 && y[j] == 1 {
                ret++
            }
        }
    } 
    return ret
}
```


**复杂度分析**

- 时间复杂度：预处理每行和每列黑色像素的时间复杂度为 $O(nm)$ ，枚举二维数组每个像素需要 $O(nm)$ 的时间复杂度，检查是否满足条件需要 $O(1)$ 的时间复杂度，所以第二部分统计答案只需 $O(nm)$ 的时间复杂度，最后总时间复杂度即为 $O(nm)$ ，其中 $n$ 为二维数组行数， $m$ 为二维数组列数。
- 空间复杂度：$O(max(n,m))$ ，需要两个一维数组分别统计每行和每列的黑色像素个数。