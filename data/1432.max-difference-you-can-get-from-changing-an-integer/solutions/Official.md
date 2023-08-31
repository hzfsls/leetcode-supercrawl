## [1432.改变一个整数能得到的最大差值 中文官方题解](https://leetcode.cn/problems/max-difference-you-can-get-from-changing-an-integer/solutions/100000/gai-bian-yi-ge-zheng-shu-neng-de-dao-de-0byhw)
#### 分析

要想使得 $a$ 和 $b$ 的差值尽可能大，我们应该找到从 $\textit{num}$ 可以得到的最大以及最小的整数分别作为 $a$ 和 $b$。

#### 方法一：枚举

根据题目的描述，我们可以任意选择两个数字 $x$ 和 $y$，并将 $\textit{num}$ 中的所有 $x$ 替换成 $y$。由于 $x$ 和 $y$ 的取值范围均为 $[0, 9]$，那么我们最多只有 $10 \times 10 = 100$ 种不同的替换方法。

因此我们可以使用两重循环枚举所有的替换方法。在得到的所有新整数中，找出最大以及最小的赋予 $a$ 和 $b$。

```C++ [sol1-C++]
class Solution {
public:
    int maxDiff(int num) {
        auto change = [&](int x, int y) {
            string num_s = to_string(num);
            for (char& digit: num_s) {
                if (digit - '0' == x) {
                    digit = '0' + y;
                }
            }
            return num_s;
        };

        int min_num = num;
        int max_num = num;
        for (int x = 0; x < 10; ++x) {
            for (int y = 0; y < 10; ++y) {
                string res = change(x, y);
                // 判断是否有前导零
                if (res[0] != '0') {
                    int res_i = stoi(res);
                    min_num = min(min_num, res_i);
                    max_num = max(max_num, res_i);
                }
            }
        }

        return max_num - min_num;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxDiff(self, num: int) -> int:
        def change(x, y):
            return str(num).replace(str(x), str(y))
        
        min_num = max_num = num
        for x in range(10):
            for y in range(10):
                res = change(x, y)
                # 判断是否有前导零
                if res[0] != "0":
                    res_i = int(res)
                    min_num = min(min_num, res_i)
                    max_num = max(max_num, res_i)
        
        return max_num - min_num
```

```Java [sol1-Java]
class Solution {
    public int maxDiff(int num) {
        int min_num = num;
        int max_num = num;
        for (int x = 0; x < 10; ++x) {
            for (int y = 0; y < 10; ++y) {
                String res = change(num, x, y);
                // 判断是否有前导零
                if (res.charAt(0) != '0') {
                    int res_i = Integer.parseInt(res);
                    min_num = Math.min(min_num, res_i);
                    max_num = Math.max(max_num, res_i);
                }
            }
        }

        return max_num - min_num;
    }

    public String change(int num, int x, int y) {
        StringBuffer num_s = new StringBuffer(String.valueOf(num));
        int length = num_s.length();
        for (int i = 0; i < length; i++) {
            char digit = num_s.charAt(i);
            if (digit - '0' == x) {
                num_s.setCharAt(i, (char) ('0' + y));
            }
        }
        return num_s.toString();
    }
}
```

**复杂度分析**

- 时间复杂度：$O(d^2 \log (\textit{num}))$，其中 $d = 10$，表示 $\textit{num}$ 是一个「十」进制数。我们使用两重循环枚举所有的替换方法，时间复杂度为 $O(d^2)$。对于每一种替换方法，我们将 $\textit{num}$ 转换成字符串后并进行替换操作，需要的时间与 $\textit{num}$ 的长度成正比，记为 $O(\log (\textit{num}))$。

- 空间复杂度：$O(1)$。

#### 方法二：贪心算法

**思路**

如果我们想要得到最大的整数，最好的办法应该是找到一个高位将它修改为 $9$。同理，如果我们想要得到最小的整数，最好的办法应该是找到一个高位将它修改为 $0$。

**找到最大的数**

要想得到最大的整数，我们从高到低依次枚举 $\textit{num}$ 中的每一个位置。如果当前枚举到的位置的数字不为 $9$，那么我们该数字全部替换成 $9$，即可得到最大的整数。

**找到最小的数**

要想得到最小的整数，我们从高到低依次枚举 $\textit{num}$ 中的每一个位置。如果当前枚举到的位置的数字不为 $0$，那么我们将该数字全部替换成 $0$，即可得到最小的整数。

等等，如果我们将数字替换成 $0$，是不是可能会出现「前导零」？举个例子，如果 $\textit{num} = 123$，我们会将最高位的 $1$ 替换成 $0$，得到 $023$，这样就出现了前导零。因此我们必须要考虑前导零的问题：

- 如果我们枚举的是最高位，那么我们只能将其替换成 $1$，否则就会有前导零了；

- 如果我们枚举的是其它的数位：

    - 如果当前的数字与最高位的数字不相等，那么我们就可以将其替换成 $0$；

    - 如果当前的数字与最高位的数字相等，那么我们直接跳过这个数位，这是因为当我们在枚举最高位时，我们已经处理过这个**数字**了。既然在枚举最高位遇到相同的数字时没有选择替换，那么说明这个数字一定就是 $1$，由于前导零的限制我们也不能将其替换成 $0$，因此就可以直接跳过了。

至此，我们通过贪心找高位的方法得到了最大以及最小的数，这样也就得到了最终的答案。

```C++ [sol2-C++]
class Solution {
public:
    int maxDiff(int num) {
        auto replace = [](string& s, char x, char y) {
            for (char& digit: s) {
                if (digit == x) {
                    digit = y;
                }
            }
        };

        string min_num = to_string(num);
        string max_num = to_string(num);

        // 找到一个高位替换成 9
        for (char digit: max_num) {
            if (digit != '9') {
                replace(max_num, digit, '9');
                break;
            }
        }

        // 将最高位替换成 1
        // 或者找到一个与最高位不相等的高位替换成 0
        for (int i = 0; i < min_num.size(); ++i) {
            char digit = min_num[i];
            if (i == 0) {
                if (digit != '1') {
                    replace(min_num, digit, '1');
                    break;
                }
            }
            else {
                if (digit != '0' && digit != min_num[0]) {
                    replace(min_num, digit, '0');
                    break;
                }
            }
        }

        return stoi(max_num) - stoi(min_num);
    }
};
```

```Python [sol2-Python3]
class Solution:
    def maxDiff(self, num: int) -> int:
        min_num, max_num = str(num), str(num)

        # 找到一个高位替换成 9
        for digit in max_num:
            if digit != "9":
                max_num = max_num.replace(digit, "9")
                break

        # 将最高位替换成 1
        # 或者找到一个与最高位不相等的高位替换成 0
        for i, digit in enumerate(min_num):
            if i == 0:
                if digit != "1":
                    min_num = min_num.replace(digit, "1")
                    break
            else:
                if digit != "0" and digit != min_num[0]:
                    min_num = min_num.replace(digit, "0")
                    break

        return int(max_num) - int(min_num)
```

```Java [sol2-Java]
class Solution {
    public int maxDiff(int num) {
        StringBuffer min_num = new StringBuffer(String.valueOf(num));
        StringBuffer max_num = new StringBuffer(String.valueOf(num));

        // 找到一个高位替换成 9
        int max_length = max_num.length();
        for (int i = 0; i < max_length; ++i) {
            char digit = max_num.charAt(i);
            if (digit != '9') {
                replace(max_num, digit, '9');
                break;
            }
        }

        // 将最高位替换成 1
        // 或者找到一个与最高位不相等的高位替换成 0
        int min_length = min_num.length();
        for (int i = 0; i < min_length; ++i) {
            char digit = min_num.charAt(i);
            if (i == 0) {
                if (digit != '1') {
                    replace(min_num, digit, '1');
                    break;
                }
            }
            else {
                if (digit != '0' && digit != min_num.charAt(0)) {
                    replace(min_num, digit, '0');
                    break;
                }
            }
        }

        return Integer.parseInt(max_num.toString()) - Integer.parseInt(min_num.toString());
    }

    public void replace(StringBuffer s, char x, char y) {
        int length = s.length();
        for (int i = 0; i < length; ++i) {
            if (s.charAt(i) == x) {
                s.setCharAt(i, y);
            }
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(\log (\textit{num}))$，我们最多只需要枚举 $\textit{num}$ 的每个数位一次。

- 空间复杂度：$O(1)$。