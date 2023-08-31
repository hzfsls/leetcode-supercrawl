## [1431.拥有最多糖果的孩子 中文官方题解](https://leetcode.cn/problems/kids-with-the-greatest-number-of-candies/solutions/100000/yong-you-zui-duo-tang-guo-de-hai-zi-by-leetcode-so)
### 📺 视频题解  
![1431. 拥有最多糖果的孩子.mp4](23e02b0e-6a64-4153-acf7-1001b619c58e)

### 📖 文字题解
#### 方法一：遍历

**思路**

如果我们希望某个小朋友拥有的糖果最多，那么最优的方案当然是把额外的所有糖果都分给这个小朋友。因此，我们可以枚举每一个小朋友，并将额外的所有糖果都分给这个小朋友，然后再用 $O(n)$ 的时间遍历其余的小朋友，就可以判断这个小朋友是否拥有最多的糖果。

上述方法的时间复杂度为 $O(n^2)$，然而我们可以将其优化为 $O(n)$。事实上，对于每一个小朋友，只要这个小朋友「拥有的糖果数目」加上「额外的糖果数目」大于等于所有小朋友拥有的糖果数目最大值，那么这个小朋友就可以拥有最多的糖果。

**证明**

设某个小朋友的糖果数为 $x$，其余小朋友拥有的糖果数目最大值为 $y$，额外的糖果数为 $e$。这个小朋友可以拥有最多的糖果，当且仅当

$$
x+e \geq y
$$

由于 $x+e \geq x$ 显然成立，那么我们有

$$
x+e \geq \max(x, y)
$$

而 $\max(x, y)$ 就是所有小朋友拥有的糖果数目最大值。因此我们可以预处理出这个值，随后遍历每一个小朋友，只要这个小朋友「拥有的糖果数目」加上「额外的糖果数目」大于等于这个值，就可以满足要求。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    vector<bool> kidsWithCandies(vector<int>& candies, int extraCandies) {
        int n = candies.size();
        int maxCandies = *max_element(candies.begin(), candies.end());
        vector<bool> ret;
        for (int i = 0; i < n; ++i) {
            ret.push_back(candies[i] + extraCandies >= maxCandies);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Boolean> kidsWithCandies(int[] candies, int extraCandies) {
        int n = candies.length;
        int maxCandies = 0;
        for (int i = 0; i < n; ++i) {
            maxCandies = Math.max(maxCandies, candies[i]);
        }
        List<Boolean> ret = new ArrayList<Boolean>();
        for (int i = 0; i < n; ++i) {
            ret.add(candies[i] + extraCandies >= maxCandies);
        }
        return ret;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def kidsWithCandies(self, candies: List[int], extraCandies: int) -> List[bool]:
        maxCandies = max(candies)
        ret = [candy + extraCandies >= maxCandies for candy in candies]
        return ret
```

```golang [sol1-Golang]
func kidsWithCandies(candies []int, extraCandies int) []bool {
    n := len(candies)
    maxCandies := 0
    for i := 0; i < n; i++ {
        maxCandies = max(maxCandies, candies[i])
    }
    ret := make([]bool, n)
    for i := 0; i < n; i++ {
        ret[i] = candies[i] + extraCandies >= maxCandies
    }
    return ret
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

**复杂度分析**

假设小朋友的总数为 $n$。

+ 时间复杂度：我们首先使用 $O(n)$ 的时间预处理出所有小朋友拥有的糖果数目最大值。对于每一个小朋友，我们需要 $O(1)$ 的时间判断这个小朋友是否可以拥有最多的糖果，故渐进时间复杂度为 $O(n)$。

+ 空间复杂度：这里只用了常数个变量作为辅助空间，与 $n$ 的规模无关，故渐进空间复杂度为 $O(1)$。