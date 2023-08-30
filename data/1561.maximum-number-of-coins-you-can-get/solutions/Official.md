#### 方法一：贪心

由于一共有 $3n$ 堆硬币，每个人都会取走 $n$ 堆硬币，因此在取走的硬币堆的数量确定的情况下，为了获得最大硬币数目，在每次取走一堆硬币时，应取走数量最多的一堆硬币。

显然，$\text{Alice}$ 一定会取走 $3n$ 堆硬币中数量最多的一堆硬币，在 $\text{Alice}$ 取走数量最多的一堆硬币之后，我们可以取走数量第二多的一堆硬币。当 $n=1$ 时，一共有 $3$ 堆硬币，每个人都只能取走 $1$ 堆硬币，因此我们可以获得的最大硬币数目即为数量第二多的一堆硬币的数目。

当 $n \ge 2$ 时，如何获得最大硬币数目？和 $n = 1$ 的情况相似，第一轮时，$\text{Alice}$ 取走数量最多的，我们取走数量第二多的，但不同的是我们不让 $\text{Bob}$ 取走数量第三多的，我们让 $\text{Bob}$ 取走数量最少的。第二轮时，应该让 $\text{Alice}$ 取走数量第三多的一堆硬币，我们就取走数量第四多的一堆硬币，以此类推。试想如果我们在第一轮让 $\text{Bob}$ 拿走了第三多的，按照这个策略我们只能在第二轮拿到数量第五多的，以此类推，这个策略不如前面的策略好。

基于上述分析，可以看到，每一轮中，$\text{Alice}$ 取数量最多的一堆硬币，我们取数量第二多的一堆硬币，可以让我们获得最大硬币数目。由于每一轮中要选出 $3$ 堆硬币，其中的最后一堆由 $\text{Bob}$ 取走，为了不让 $\text{Bob}$ 影响我们获得的最大硬币数目，只要让 $\text{Bob}$ 每次取的硬币是所有堆中数量最少的即可。

为了方便地知道每一堆硬币的数量之间的关系，首先对数组进行排序。排序后的数组的前 $n$ 个元素是最小的元素，留给 $\text{Bob}$，其余的元素则分别属于我们和 $\text{Alice}$。

每一轮，我们选出 $3$ 堆硬币，包括数量最多的 $2$ 堆硬币和数量最少的 $1$ 堆硬币，我们总能获得这 $3$ 堆硬币中的数量第二多的硬币。

计算可以获得的最大硬币数目时，按照从大到小的顺序遍历数组中的元素，每次遍历 $2$ 个元素，其中较小的元素即为这一轮取走的硬币数量。

```Java [sol1-Java]
class Solution {
    public int maxCoins(int[] piles) {
        Arrays.sort(piles);
        int length = piles.length;
        int rounds = length / 3;
        int coins = 0;
        int index = length - 2;
        for (int i = 0; i < rounds; i++) {
            coins += piles[index];
            index -= 2;
        }
        return coins;
    }
}
```
```cpp [sol1-C++]
class Solution {
public:
    int maxCoins(vector<int>& piles) {
        sort(piles.begin(), piles.end());
        int length = piles.size();
        int rounds = length / 3;
        int coins = 0;
        int index = length - 2;
        for (int i = 0; i < rounds; i++) {
            coins += piles[index];
            index -= 2;
        }
        return coins;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxCoins(self, piles: List[int]) -> int:
        n = len(piles)
        piles.sort()
        return sum(piles[n // 3 :: 2])
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组的长度除以 $3$（即数组的长度是 $3n$）。排序的时间复杂度是 $O(3n \log 3n)=O(3n (\log 3 + \log n))=O(n \log n)$，遍历数组计算最大硬币数目的时间复杂度是 $O(n)$，因此总时间复杂度是 $O(n \log n)$。

- 空间复杂度：$O(\log n)$。C++ 的 `sort` 整合了快排、堆排和插入排序三种方法，这里递归使用栈空间的大小可以认为是 $O(\log n)$。