#### 方法一：排序

**思路与算法**

如果 $\textit{num} = 0$，那么答案就是 $0$。

如果 $\textit{num}$ 是负数，那么最小化就是将它的相反数最大化，也就是将 $\textit{num}$ 的数字部分按照降序排序，再组合成一个新的数即可。

如果 $\textit{num}$ 是正数，那么同样地，将 $\textit{num}$ 的数字部分按照升序排序，再组合成一个新的数即可。需要注意的是，再升序排序后，首位可能为 $0$，而题目规定重排数字不能有前导 $0$，因此我们需要找到一个除了 $0$ 以外的最小数字，将其和 $0$ 进行交换。由于 $\textit{num}$ 本身不为 $0$，因此这样的数字是一定能找到的。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long smallestNumber(long long num) {
        if (num == 0) {
            return 0;
        }
        
        bool negative = (num < 0);
        num = abs(num);
        vector<int> digits;

        long long dummy = num;
        while (dummy) {
            digits.push_back(dummy % 10);
            dummy /= 10;
        }
        sort(digits.begin(), digits.end());
        if (negative) {
            reverse(digits.begin(), digits.end());
        }
        else {
            if (digits[0] == 0) {
                for (int i = 1;; ++i) {
                    if (digits[i] != 0) {
                        swap(digits[0], digits[i]);
                        break;
                    }
                }
            }
        }

        long long ans = 0;
        for (int digit: digits) {
            ans = ans * 10 + digit;
        }
        return negative ? -ans : ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def smallestNumber(self, num: int) -> int:
        if num == 0:
            return 0
        
        negative = (num) < 0
        num = abs(num)
        digits = sorted(int(digit) for digit in str(num))
        
        if negative:
            digits = digits[::-1]
        else:
            if digits[0] == 0:
                i = 1
                while digits[i] == 0:
                    i += 1
                digits[0], digits[i] = digits[i], digits[0]

        ans = int("".join(str(digit) for digit in digits))
        return -ans if negative else ans
```

**复杂度分析**

- 时间复杂度：$O(\log \textit{num} \log\log \textit{num})$，即为排序需要的时间。$\textit{num}$ 包含的数字个数为 $O(\log \textit{num})$。

- 空间复杂度：$O(\log \textit{num})$，即为存储 $\textit{num}$ 包含的数字需要使用的空间。