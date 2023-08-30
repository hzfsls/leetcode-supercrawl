#### 方法一：模拟路径
首先要知道，从地图上的任意一点到另外一点，最短距离为 x 轴的距离加上 y 轴的距离。

![fig1](https://assets.leetcode-cn.com/solution-static/573_fig1.jpg)


观察题目要求可知，除了松鼠第一次拿的坚果，所有的坚果都需要从树的位置出发，拿到坚果后再回到树的位置。也就是说，如果确定了松鼠第一次拿哪个坚果，那么答案就已经确定了。因此我们可以采用暴力的方法，即遍历所有的坚果，把它们分别假设为松鼠第一次拿的坚果，求解对应的总路程。

![fig2](https://assets.leetcode-cn.com/solution-static/573_fig2.gif)

以上方法遍历每一个第一次拿取的坚果之后，需要再遍历所有的坚果求解总路程。时间复杂度为 $O(n^2)$ 造成超时。但实际上，路程的求解过程是可以优化的。

假设松鼠一开始在树的位置，那么显然最优的总路程（记为 `sum_dis`）是树到每个坚果的距离相加乘以 2，因为松鼠拿每个坚果的时候都是从树的位置出发，再回到树的位置。

而现在考虑松鼠换到另一个位置，可以发现此时的最短路程与 `sum_dis`相比，差别也只有松鼠到第一颗坚果的路程。所以我们假设一颗坚果为第一颗坚果时，可以直接计算此时的解与 `sum_dis` 的差别。那么记第一颗坚果为 `first_nut`，由于取第一颗坚果时不再从树的位置出发，所以要减去树到第一颗坚果的距离 `distance(tree, first_nut)`，同时也要加上松鼠到第一颗坚果的距离。松鼠的总路程为 `sum_dis - distance(tree, first_nut) + distance(squirrel, first_nut)`。

![fig3](https://assets.leetcode-cn.com/solution-static/573_fig3.gif)


因此，我们可以先计算 `sum_dis`，然后遍历松鼠拿取的第一颗坚果，遍历过程中用 `sum_dis - distance(tree, first_nut) + distance(squirrel, first_nut)` 计算总路程，取其中的最小值即可。

```Python []
class Solution:
    def getDistance(self, a, b):
        return abs(a[0] - b[0]) + abs(a[1] - b[1])

    def minDistance(self, height: int, width: int, tree: List[int], squirrel: List[int], nuts: List[List[int]]) -> int:
        ans = int(1e9)
        sum_dis = sum(self.getDistance(nut, tree) for nut in nuts) * 2
        for first_nut in nuts:
            cur = sum_dis - self.getDistance(first_nut, tree) + self.getDistance(first_nut, squirrel)
            ans = min(cur, ans)
        return ans
```
```C++ []
class Solution {
    int getDistance(vector<int>& a, vector<int>& b) {
        return abs(a[0] - b[0]) + abs(a[1] - b[1]);
    }
public:
    int minDistance(int height, int width, vector<int>& tree, vector<int>& squirrel, vector<vector<int>>& nuts) {
        int ans = 1e9;
        int sum_dis = 0;
        for (auto nut = nuts.begin(); nut != nuts.end(); ++nut)
            sum_dis += getDistance(*nut, tree) * 2;
        for (auto first_nut = nuts.begin(); first_nut != nuts.end(); ++first_nut) {
            int cur = sum_dis - getDistance(*first_nut, tree) + getDistance(*first_nut, squirrel);
            ans = min(cur, ans);
        }
        return ans;
    }
};
```

```javascript []
/**
 * @param {number} height
 * @param {number} width
 * @param {number[]} tree
 * @param {number[]} squirrel
 * @param {number[][]} nuts
 * @return {number}
 */
var getDistance = (a, b) => (Math.abs(a[0]-b[0])+Math.abs(a[1]-b[1]));
var minDistance = function(height, width, tree, squirrel, nuts) {
    var ans = 1000000000, sum_dis = 0;
    nuts.forEach((nut)=>{
        sum_dis += getDistance(nut, tree) * 2;
    })
    nuts.forEach((first_nut) => {
        var cur = sum_dis - getDistance(first_nut, tree) + getDistance(first_nut, squirrel);
        ans = Math.min(ans,cur);
    });
    return ans;
};
```

```Java []
class Solution {
    public int getDistance(int[] a, int[] b) {
        return Math.abs(a[0] - b[0]) + Math.abs(a[1] - b[1]);
    }

    public int minDistance(int height, int width, int[] tree, int[] squirrel, int[][] nuts) {
        int ans = (int) 1e9;
        int sum_dis = 0;
        for (int[] nut : nuts)
            sum_dis += getDistance(nut, tree) * 2;
        for (int[] first_nut : nuts) {
            int cur = sum_dis - getDistance(first_nut, tree) + getDistance(first_nut, squirrel);
            ans = Math.min(cur, ans);
        }
        return ans;
    }
}
```
**复杂度分析**

  * 时间复杂度：$O(n)$
    我们需要遍历所有的 $n$ 个坚果作为第一个拿取的坚果，对于每个坚果，我们只需要用 $O(1)$ 的时间计算总路程，相乘得时间复杂度为 $O(n)$。
  * 空间复杂度：$O(1)$
    计算过程中只需要常数个临时变量，空间复杂度为 $O(1)$。