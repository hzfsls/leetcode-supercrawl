#### 方法一：排序 + 二分查找

**思路与算法**

我们首先将包裹按照尺寸从小到大进行排序。

随后我们枚举每一个供应商。对于第 $i$ 个供应商提供的箱子，我们同样将这些箱子按照尺寸从小到大排序。

对于每一个包裹，如果它的尺寸为 $x$，那么我们选择的尺寸为 $y$ 的箱子，需要满足 $y \geq x$。由于我们的目标是使得**总浪费空间最小**，因此每一个箱子浪费的空间都要尽可能小，即我们选择的 $y$ 是满足 $y \geq x$ 中最小的那个。

这样一来，我们就可以使用「逆向思维」来解决问题了。与其遍历每一个「包裹」选择「箱子」，我们不如遍历每一个「箱子」并匹配「包裹」。我们可以设计出如下的算法：

- 我们依次遍历每一个箱子；

- 如果当前遍历到的箱子的尺寸为 $y$，那么剩余所有的尺寸满足 $x \leq y$ 的包裹，放入当前的箱子都是最优的。我们计算出这些包裹浪费的空间并进行累加，随后将这些包裹全部移除；

- 当我们遍历完所有的箱子之后，就得到了总浪费空间，并且它是在我们选择第 $i$ 个供应商的前提下**最小**的总浪费空间。

因为我们已经将包裹和箱子按照尺寸排好序了，所以上面的算法可以通过双指针来实现：即一个指针指向当前遍历到的箱子，一个指针指向尺寸最小的那个未被移除的包裹。然而这样做的时间复杂度为 $O(nm + l)$，其中 $n$，$m$，$l$ 分别是包裹的数量，供应商的数量以及所有供应商提供的箱子的数量之和，会超出时间限制，因此我们需要对上面的算法进行优化。

**优化**

优化的方向较为直观：既然我们枚举的是供应商，以及每一个供应商提供的所有箱子，那么时间复杂度中的 $m$ 和 $l$ 是不可避免的，我们可以尝试优化掉包含 $n$ 的项。

可以发现，包含 $n$ 的项在上面的算法中对应的步骤是「枚举所有尺寸满足 $x \leq y$ 的包裹」。由于包裹已经有序，我们可以将这一步枚举改为二分查找，即：

- 假设当前遍历到的箱子的尺寸为 $y$，并且剩余的尺寸最小的包裹对应的下标为 $\textit{pt}$；

- 我们使用二分查找，找出「最大的尺寸满足 $x \leq y$ 的包裹」，设其对应的下标为 $\textit{pt}'$，那么下标在 $[\textit{pt}, \textit{pt}']$ 范围内的所有包裹，放入尺寸为 $y$ 的箱子都是最优的。这些包裹对应的浪费空间之和为：

$$
\sum_{j=\textit{pt}}^{\textit{pt}'} (y - \textit{packages}[j])
$$

即为：

$$
(\textit{pt}' - \textit{pt} + 1) y - \sum_{j=\textit{pt}}^{\textit{pt}'} \textit{packages}[j]
$$

如果我们预处理出了包裹尺寸的前缀和，那么上式就可以在 $O(1)$ 的时间内计算出。这样一来，我们一共需要进行 $O(l)$ 次二分查找，每次二分查找的时间复杂度为 $O(\log n)$，总时间复杂度为 $O(l \log n)$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    using LL = long long;

    static constexpr int MOD = 1000000007;

public:
    int minWastedSpace(vector<int>& packages, vector<vector<int>>& boxes) {
        int n = packages.size();
        sort(packages.begin(), packages.end());

        // 计算数组 packages 的前缀和
        vector<LL> pre(n + 1);
        for (int i = 1; i <= n; ++i) {
            pre[i] = pre[i - 1] + packages[i - 1];
        }

        // 辅助函数，通过前缀和数组，得到数组 packages[left..right] 的和
        auto get = [&](int left, int right) {
            return pre[right + 1] - pre[left];
        };

        LL ans = LLONG_MAX;
        for (auto& box: boxes) {
            sort(box.begin(), box.end());
            // 小优化，如果最大包裹的尺寸大于最大箱子的尺寸，那么一定不满足，直接跳过
            if (packages.back() > box.back()) {
                continue;
            }

            // 初始化指针 pt，它指向还未被放入箱子的第一个包裹
            auto pt = packages.begin();
            // 总浪费空间
            LL total = 0;

            for (int y: box) {
                // 小优化，如果当前箱子 y 的尺寸小于 pt 指向的包裹，那么无需进行二分查找
                if (y < *pt) {
                    continue;
                }
                
                // pt'
                auto pt_next = prev(upper_bound(pt, packages.end(), y));
                
                total += (LL)(pt_next - pt + 1) * y - get(pt - packages.begin(), pt_next - packages.begin());
                pt = next(pt_next);
                // 小优化，如果所有包裹都已经被放入箱子，可以提前退出
                if (pt == packages.end()) {
                    break;
                }
            }
            ans = min(ans, total);
        }

        return (ans == LLONG_MAX ? -1 : ans % MOD);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minWastedSpace(self, packages: List[int], boxes: List[List[int]]) -> int:
        MOD = 10**9 + 7
        
        packages.sort()
        # 计算数组 packages 的前缀和
        pre = list(accumulate(packages, initial=0))

        # 辅助函数，通过前缀和数组，得到数组 packages[left..right] 的和
        get = lambda left, right: pre[right + 1] - pre[left]
        
        ans = float("inf")
        for box in boxes:
            box.sort()
            # 小优化，如果最大包裹的尺寸大于最大箱子的尺寸，那么一定不满足，直接跳过
            if packages[-1] > box[-1]:
                continue

            # 初始化指针 pt，它指向还未被放入箱子的第一个包裹
            pt = 0
            # 总浪费空间
            total = 0

            for y in box:
                # 小优化，如果当前箱子 y 的尺寸小于 pt 指向的包裹，那么无需进行二分查找
                if y < packages[pt]:
                    continue
                
                # pt'
                pt_next = bisect_right(packages, y, pt) - 1
                
                total += (pt_next - pt + 1) * y - get(pt, pt_next)
                pt = pt_next + 1
                # 小优化，如果所有包裹都已经被放入箱子，可以提前退出
                if pt == len(packages):
                    break
            
            ans = min(ans, total)

        return -1 if ans == float("inf") else ans % MOD
```

**复杂度分析**

- 时间复杂度：$O(n \log n + l \log l + l \log n)$，其中 $n$ 和 $l$ 分别是包裹的数量，以及所有供应商提供的箱子的数量之和。由于供应商的数量 $m$ 是一定小于等于 $l$ 的，因此时间复杂度中没有出现 $m$ 也是很正常的。

    - 对数组 $\textit{packages}$ 排序的时间复杂度为 $O(n \log n)$；

    - 计算前缀和的时间复杂度为 $O(n)$，在渐进意义下可以忽略；

    - 对数组 $\textit{boxes}$ 中的每一个数组排序的总时间复杂度为 $O(l \log l)$；

    - 一共需要进行 $O(l)$ 次二分查找，每次的时间复杂度为 $O(\log n)$，总时间复杂度为 $O(l \log n)$。

- 空间复杂度：$O(n + \log l)$。我们需要 $O(n)$ 的空间存储前缀和，$O(\log n)$ 和 $O(\log l)$ 的空间作为排序使用的栈空间，其中 $O(\log n)$ 项在渐近意义下可以忽略。