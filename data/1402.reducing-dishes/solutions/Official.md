## [1402.做菜顺序 中文官方题解](https://leetcode.cn/problems/reducing-dishes/solutions/100000/zuo-cai-shun-xu-by-leetcode-solution)

#### 方法一：贪心算法

**分析**

我们从最简单的情况开始思考起。

假设我们只能选一道菜，那么我们应该如何选择呢？显然，选择满意程度最大的那一道菜 $s_0$ 是最优的，并且我们需要验证是否有 $s_0 > 0$，因为如果 $s_0 \leq 0$，我们选择这道菜不会有任何受益。

现在我们可以再多选一道菜，也就是两道菜，那么我们应该如何选择呢？假设我们选择了 $s_1$ 这道菜，那么满意程度的总和为

$$
s_1 + 2s_0
$$

由于 $s_0$ 是满意程度最大的那道菜，我们要最大化上述表达式的值，就应该找到尽可能大的 $s_1$。因此在最优的情况下，我们选择满意程度次大的那一道菜作为 $s_1$，并且需要保证选择之后的收益多于选择之前的收益，即

$$
s_1 + 2s_0 > s_0
$$

也就是只要满足

$$
s_1 + s_0 > 0
$$

我们就可以选择 $s_1$。

对于第三道菜也是如此，我们如果要选择 $s_2$，就应该选择满意程度第三大的那一道菜作为 $s_2$，同时要保证收益的增加，即

$$
s_2 + 2s_1 + 3s_0 > s1 + 2s_0
$$

也就是当

$$
s_2 + s_1 + s_0 > 0
$$

时，我们就可以选择 $s_2$。

因此我们就有了一个贪心的大致思路：

- 我们将所有菜的满意程度从大到小排序；

- 我们按照排好序的顺序依次遍历这些菜，对于当前遍历到的菜 $s_i$，如果它与之前选择的所有菜的满意程度之和大于 $0$，我们就选择这道菜，否则可以直接退出遍历的循环。这是因为如果 $s_i$ 与之前选择的所有菜的满意程度之和已经小于等于 $0$ 了，那么后面的菜比 $s_i$ 的满意程度还要小，就更不可能得到一个大于 $0$ 的和了。

**正确性证明**

在上面的分析中，我们只给出了一个贪心算法的思路，而并没有对其正确性进行证明。如果对证明感兴趣的读者可以阅读本节，如果不感兴趣，可以直接跳到后面的代码部分。

我们需要证明：在最优的选取方法中，如果我们选择了 $k$ 道菜，那么一定是满意程度最大的 $k$ 道菜，并且满意程度越大的菜，做菜顺序越靠后。

具体地，我们可以使用反证法。假设我们选择了 $a_1, a_2, \cdots, a_k$ 这 $k$ 道菜，它们并不是满意程度最大的 $k$ 道菜，因此我们可以进行如下两个步骤：

- 首先我们不改变选择的这些菜，而只改变它们的做菜顺序。根据 [排序不等式](https://baike.baidu.com/item/%E6%8E%92%E5%BA%8F%E4%B8%8D%E7%AD%89%E5%BC%8F)，当将这些菜按照满意程度升序排序后，这样的做菜顺序可以得到最大的总喜爱时间。也就是说，我们写出总喜爱时间的表达式：

    $$
    a_1 + 2a_2 + 3a_3 + \cdots + ka_k
    $$

    当 $a_1, a_2, \cdots, a_k$ 单调递增时，这个表达式的值可以取到最大值；

- 随后我们将 $a_1, a_2, \cdots, a_k$ 替换成满意程度最大的 $k$ 道菜，设为 $b_1, b_2, \cdots, b_k$，它们也是按照升序排序的。由于 $a_1, a_2, \cdots, a_k$ 已经按照升序排序，那么 $b_i \geq a_i$ 恒成立，因此我们将原本的 $k$ 道菜替换成满意程度最大的 $k$ 道菜，总喜爱时间不会减少。

这样以来，我们将原先的 $a_1, a_2, \cdots, a_k$ 替换成了 $b_1, b_2, \cdots, b_k$，并且总喜爱时间不会减少，因此我们就证明了上述的结论，即：如果我们知道需要选择 $k$ 道菜，那么选择满意程度最大的 $k$ 道菜，并且按照它们的满意程度升序排序，以此顺序进行制作，可以得到最大的总喜爱时间。也就是说，如果我们将所有的菜按照满意程度降序排序，在最优的情况下，我们选择的菜是从满意度最高的菜开始的连续若干道菜。

因此，我们可以将所有的菜按照满意程度从大到小排序，随后依次遍历每一道菜。如果加入这道菜导致总喜爱时间增加，我们就可以选取这道菜，否则我们直接退出循环。因为我们需要连续地选取若干道菜，而当前这道菜会产生副收益，因此后面的菜都不需要考虑了。这与我们提出的贪心算法也是一致的。

```C++ [sol1-C++]
class Solution {
public:
    int maxSatisfaction(vector<int>& satisfaction) {
        sort(satisfaction.begin(), satisfaction.end(), greater<int>());
        int presum = 0, ans = 0;
        for (int si: satisfaction) {
            if (presum + si > 0) {
                presum += si;
                ans += presum;
            }
            else {
                break;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxSatisfaction(int[] satisfaction) {
        Arrays.sort(satisfaction);
        int presum = 0, ans = 0;
        for (int i = satisfaction.length - 1; i >= 0; --i) {
            int si = satisfaction[i];
            if (presum + si > 0) {
                presum += si;
                ans += presum;
            } else {
                break;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxSatisfaction(self, satisfaction: List[int]) -> int:
        satisfaction.sort(reverse=True)
        presum, ans = 0, 0
        for si in satisfaction:
            if presum + si > 0:
                presum += si
                ans += presum
            else:
                break
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N \log N)$，我们需要对满意程度进行排序。

- 空间复杂度：$O(\log N)$，使用语言自带的排序，空间复杂度为 $O(\log N)$。如果使用堆排序，空间复杂度可以降低至 $O(1)$。