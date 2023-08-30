#### 方法一：数学

首先我们需要了解一个结论：

> 一个数能被 3 整除，当且仅当它的各位数字之和能被 3 整除。例如数 981，它的各位数字之和为 9 + 8 + 1 = 18 能被 3 整除，同时 981 也能被 3 整除。

那么对于给定的数组 `digits`，记数组中所有元素之和为 `S`，那么就有以下的三种情况：

- 若 `S` 是 `3` 的倍数，那么选择数组 `digits` 中的所有元素，它们任意组成的数都能被 `3` 整除，因此我们只需要将其从大到小排序再连接成一个数即可；

- 若 `S` 模 `3` 余 `1`，那么我们需要从数组 `digits` 从删除若干个元素，它们的和模 `3` 也余 `1`。为了使得最后得到的数尽可能大，最优的方法一定是从 `digits` 中删除一个最小的模 `3` 余 `1` 的数（例如 `1`，`4`，`7`）。如果 `digits` 中没有这样的数，我们可以退而求其次，删除两个最小的模 `3` 余 `2` 的数（例如 `2`，`5`，`8`）。会不会也没有这样的数呢？如果 `digits` 中既没有模 `3` 余 `1` 的数，也最多只有一个模 `3` 余 `2` 的数，那么 `digits` 中所有元素之和要么是 `3` 的倍数（此时没有模 `3` 余 `2` 的数），要么模 `3` 余 `2`（此时有一个模 `3` 余 `2` 的数），不可能得到模 `3` 余 `1` 的结果。因此我们一定能通过删除一个模 `3` 余 `1` 的数或者两个模 `3` 余 `2` 的数，使得 `digits` 中所有元素之和变为 `3` 的倍数。在这之后，我们同样从大到小进行排序再连接成一个数；

- 若 `S` 模 `3` 余 `2`，与上面的情况类似，我们从 `digits` 中删除一个最小的模 `3` 余 `2` 的数，如果没有这样的数，就删除两个最小的模 `3` 余 `1` 的数。

算法的框架已经大致清晰了，还剩下一些实现中的小细节：

我们遍历数组 `digits`，记录下每个数字出现的次数 `cnt` 以及它们模 `3` 的结果出现的次数 `modulo`。在遍历的同时，我们求出所有的元素之和 `S`。根据 `S` 模 `3` 的结果以及 `modulo` 中的记录情况，我们可以得到一个二元组 `(remove_mod, rest)`，其中 `remove_mod` 表示要删除的元素模 `3` 余几，`rest` 表示删除数的个数。在这之后，我们从小到大遍历所有的数（已经以频数的形式记录在 `cnt` 中了，省去了排序），并根据二元组 `(remove_mod, rest)` 删除最小的若干个数。最后我们再从大到小遍历所有的数，并把它们连接起来作为最终的结果。需要注意的是，如果剩余的所有数都是 `0`，那么我们只要返回一个 `0` 作为答案即可。

```C++ [sol1-C++]
class Solution {
public:
    string largestMultipleOfThree(vector<int>& digits) {
        vector<int> cnt(10), modulo(3);
        int sum = 0;
        for (int digit: digits) {
            ++cnt[digit];
            ++modulo[digit % 3];
            sum += digit;
        }

        int remove_mod = 0, rest = 0;
        if (sum % 3 == 1) {
            if (modulo[1] >= 1) {
                remove_mod = 1;
                rest = 1;
            }
            else {
                remove_mod = 2;
                rest = 2;
            }
        }
        else if (sum % 3 == 2) {
            if (modulo[2] >= 1) {
                remove_mod = 2;
                rest = 1;
            }
            else {
                remove_mod = 1;
                rest = 2;
            }
        }
        string ans;
        for (int i = 0; i <= 9; ++i) {
            for (int j = 0; j < cnt[i]; ++j) {
                if (rest && remove_mod == i % 3) {
                    --rest;
                }
                else {
                    ans += static_cast<char>(i + 48);
                }
            }
        }
        if (ans.size() && ans.back() == '0') {
            ans = "0";
        }
        reverse(ans.begin(), ans.end());
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def largestMultipleOfThree(self, digits: List[int]) -> str:
        cnt, modulo = [0] * 10, [0] * 3
        s = 0
        for digit in digits:
            cnt[digit] += 1
            modulo[digit % 3] += 1
            s += digit
        
        remove_mod, rest = 0, 0
        if s % 3 == 1:
            remove_mod, rest = (1, 1) if modulo[1] >= 1 else (2, 2)
        elif s % 3 == 2:
            remove_mod, rest = (2, 1) if modulo[2] >= 1 else (1, 2)

        ans = ""
        for i in range(0, 10):
            for j in range(cnt[i]):
                if rest > 0 and remove_mod == i % 3:
                    rest -= 1
                else:
                    ans += str(i)
        if len(ans) > 0 and ans[-1] == "0":
            ans = "0"
        return ans[::-1]
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组 `digits` 的长度。

- 空间复杂度：$O(1)$，这里统计的是除了返回答案之外的额外空间复杂度。我们需要用到的数组 `cnt` 的大小为 `10`，`modulo` 的大小为 `3`，可以看作是常数级别。