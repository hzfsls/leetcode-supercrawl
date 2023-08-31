## [1535.找出数组游戏的赢家 中文官方题解](https://leetcode.cn/problems/find-the-winner-of-an-array-game/solutions/100000/zhao-chu-shu-zu-you-xi-de-ying-jia-by-leetcode-sol)
#### 方法一：模拟

由于数组 $\textit{arr}$ 中的整数各不相同，因此数组中的任意两个整数之间的游戏一定能分出胜负。

首先考虑 $k=1$ 的情况，当 $k=1$ 时，只有 $\textit{arr}[0]$ 和 $\textit{arr}[1]$ 之间有一回合游戏，由于一定能分出胜负，因此直接返回 $\textit{arr}[0]$ 和 $\textit{arr}[1]$ 中的最大值即可。

然后考虑 $k>1$ 的情况。根据题目描述，每回合游戏之后，较小的整数移至数组的末尾。其实，并不需要对数组进行更新。在第一回合游戏之后，无论 $\textit{arr}[0]$ 和 $\textit{arr}[1]$ 当中谁取得胜利，第二回合游戏的另一个整数一定是 $\textit{arr}$ 中的下一个整数。推广到一般的情况，当 $2 \le i < \textit{arr}.\text{length}$ 时，第 $i$ 回合游戏一定在第 $i-1$ 回合游戏中取得胜利的整数和 $\textit{arr}[i]$ 之间进行。

因此，需要记录上一回合游戏中取得胜利的整数和该整数取得连续胜利的回合数。使用 $\textit{prev}$ 表示上一回合游戏中取得胜利的整数，使用 $\textit{consecutive}$ 表示该整数取得连续胜利的回合数。

第一回合游戏在 $\textit{arr}[0]$ 和 $\textit{arr}[1]$ 之间进行，第一回合游戏之后，$\textit{prev}$ 为 $\textit{arr}[0]$ 和 $\textit{arr}[1]$ 中的较大值，$\textit{consecutive}$ 的值为 $1$。

当 $2 \le i < \textit{arr}.\text{length}$ 时，令 $\textit{curr}=\textit{arr}[i]$，第 $i$ 回合游戏在 $\textit{prev}$ 和 $\textit{curr}$ 之间进行，可能有以下两种情况：

- 如果 $\textit{prev}>\textit{curr}$，则 $\textit{prev}$ 不变，将 $\textit{consecutive}$ 的值加 $1$，如果 $\textit{consecutive}$ 的值更新之后等于 $k$，则 $\textit{prev}$ 赢得 $k$ 个连续回合，成为游戏的赢家，将 $\textit{prev}$ 返回即可；

- 如果 $\textit{prev}<\textit{curr}$，则 $\textit{curr}$ 取得胜利，令 $\textit{prev}=\textit{curr}$，并将 $\textit{consecutive}$ 的值更新为 $1$。

在上述过程中，同时维护数组 $\textit{arr}$ 中的最大值 $\textit{maxNum}$。

如果遍历 $\textit{arr}$ 之后仍未发现有整数赢得 $k$ 个连续回合，则不需要继续模拟，数组 $\textit{arr}$ 中的最大值 $\textit{maxNum}$ 即为游戏的赢家。

为什么不需要继续模拟就能知道 $\textit{maxNum}$ 为游戏的赢家？因为 $\textit{maxNum}$ 是数组 $\textit{arr}$ 中的最大值，无论和哪个整数进行游戏，$\textit{maxNum}$ 都能取得胜利，因此在遍历 $\textit{arr}$ 之后，$\textit{maxNum}$ 一定位于 $\textit{arr}[0]$，且将一直位于 $\textit{arr}[0]$，在其余的游戏中，$\textit{maxNum}$ 将永远取得胜利，自然也会赢得 $k$ 个连续回合。

```Java [sol1-Java]
class Solution {
    public int getWinner(int[] arr, int k) {
        int prev = Math.max(arr[0], arr[1]);
        if (k == 1) {
            return prev;
        }
        int consecutive = 1;
        int maxNum = prev;
        int length = arr.length;
        for (int i = 2; i < length; i++) {
            int curr = arr[i];
            if (prev > curr) {
                consecutive++;
                if (consecutive == k) {
                    return prev;
                }
            } else {
                prev = curr;
                consecutive = 1;
            }
            maxNum = Math.max(maxNum, curr);
        }
        return maxNum;
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    int getWinner(vector<int>& arr, int k) {
        int prev = max(arr[0], arr[1]);
        if (k == 1) {
            return prev;
        }
        int consecutive = 1;
        int maxNum = prev;
        int length = arr.size();
        for (int i = 2; i < length; i++) {
            int curr = arr[i];
            if (prev > curr) {
                consecutive++;
                if (consecutive == k) {
                    return prev;
                }
            } else {
                prev = curr;
                consecutive = 1;
            }
            maxNum = max(maxNum, curr);
        }
        return maxNum;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def getWinner(self, arr: List[int], k: int) -> int:
        prev = max(arr[0], arr[1])
        if k == 1:
            return prev

        consecutive = 1
        maxNum = prev
        length = len(arr)

        for i in range(2, length):
            curr = arr[i]
            if prev > curr:
                consecutive += 1
                if consecutive == k:
                    return prev
            else:
                prev = curr
                consecutive = 1
            maxNum = max(maxNum, curr)
        
        return maxNum
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{arr}$ 的长度。遍历数组一次。

- 空间复杂度：$O(1)$。只需要维护常量的额外空间。