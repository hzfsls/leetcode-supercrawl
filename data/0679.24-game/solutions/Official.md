## [679.24 点游戏 中文官方题解](https://leetcode.cn/problems/24-game/solutions/100000/24-dian-you-xi-by-leetcode-solution)
#### 方法一：回溯

一共有 $4$ 个数和 $3$ 个运算操作，因此可能性非常有限。一共有多少种可能性呢？

首先从 $4$ 个数字中有序地选出 $2$ 个数字，共有 $4 \times 3=12$ 种选法，并选择加、减、乘、除 $4$ 种运算操作之一，用得到的结果取代选出的 $2$ 个数字，剩下 $3$ 个数字。

然后在剩下的 $3$ 个数字中有序地选出 $2$ 个数字，共有 $3 \times 2=6$ 种选法，并选择 $4$ 种运算操作之一，用得到的结果取代选出的 $2$ 个数字，剩下 $2$ 个数字。

最后剩下 $2$ 个数字，有 $2$ 种不同的顺序，并选择 $4$ 种运算操作之一。

因此，一共有 $12 \times 4 \times 6 \times 4 \times 2 \times 4=9216$ 种不同的可能性。

可以通过回溯的方法遍历所有不同的可能性。具体做法是，使用一个列表存储目前的全部数字，每次从列表中选出 $2$ 个数字，再选择一种运算操作，用计算得到的结果取代选出的 $2$ 个数字，这样列表中的数字就减少了 $1$ 个。重复上述步骤，直到列表中只剩下 $1$ 个数字，这个数字就是一种可能性的结果，如果结果等于 $24$，则说明可以通过运算得到 $24$。如果所有的可能性的结果都不等于 $24$，则说明无法通过运算得到 $24$。

实现时，有一些细节需要注意。

- 除法运算为实数除法，因此结果为浮点数，列表中存储的数字也都是浮点数。在判断结果是否等于 $24$ 时应考虑精度误差，这道题中，误差小于 $10^{-6}$ 可以认为是相等。

- 进行除法运算时，除数不能为 $0$，如果遇到除数为 $0$ 的情况，则这种可能性可以直接排除。由于列表中存储的数字是浮点数，因此判断除数是否为 $0$ 时应考虑精度误差，这道题中，当一个数字的绝对值小于 $10^{-6}$ 时，可以认为该数字等于 $0$。

还有一个可以优化的点。

- 加法和乘法都满足交换律，因此如果选择的运算操作是加法或乘法，则对于选出的 $2$ 个数字不需要考虑不同的顺序，在遇到第二种顺序时可以不进行运算，直接跳过。

```Java [sol1-Java]
class Solution {
    static final int TARGET = 24;
    static final double EPSILON = 1e-6;
    static final int ADD = 0, MULTIPLY = 1, SUBTRACT = 2, DIVIDE = 3;

    public boolean judgePoint24(int[] nums) {
        List<Double> list = new ArrayList<Double>();
        for (int num : nums) {
            list.add((double) num);
        }
        return solve(list);
    }

    public boolean solve(List<Double> list) {
        if (list.size() == 0) {
            return false;
        }
        if (list.size() == 1) {
            return Math.abs(list.get(0) - TARGET) < EPSILON;
        }
        int size = list.size();
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                if (i != j) {
                    List<Double> list2 = new ArrayList<Double>();
                    for (int k = 0; k < size; k++) {
                        if (k != i && k != j) {
                            list2.add(list.get(k));
                        }
                    }
                    for (int k = 0; k < 4; k++) {
                        if (k < 2 && i > j) {
                            continue;
                        }
                        if (k == ADD) {
                            list2.add(list.get(i) + list.get(j));
                        } else if (k == MULTIPLY) {
                            list2.add(list.get(i) * list.get(j));
                        } else if (k == SUBTRACT) {
                            list2.add(list.get(i) - list.get(j));
                        } else if (k == DIVIDE) {
                            if (Math.abs(list.get(j)) < EPSILON) {
                                continue;
                            } else {
                                list2.add(list.get(i) / list.get(j));
                            }
                        }
                        if (solve(list2)) {
                            return true;
                        }
                        list2.remove(list2.size() - 1);
                    }
                }
            }
        }
        return false;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    static constexpr int TARGET = 24;
    static constexpr double EPSILON = 1e-6;
    static constexpr int ADD = 0, MULTIPLY = 1, SUBTRACT = 2, DIVIDE = 3;

    bool judgePoint24(vector<int> &nums) {
        vector<double> l;
        for (const int &num : nums) {
            l.emplace_back(static_cast<double>(num));
        }
        return solve(l);
    }

    bool solve(vector<double> &l) {
        if (l.size() == 0) {
            return false;
        }
        if (l.size() == 1) {
            return fabs(l[0] - TARGET) < EPSILON;
        }
        int size = l.size();
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                if (i != j) {
                    vector<double> list2 = vector<double>();
                    for (int k = 0; k < size; k++) {
                        if (k != i && k != j) {
                            list2.emplace_back(l[k]);
                        }
                    }
                    for (int k = 0; k < 4; k++) {
                        if (k < 2 && i > j) {
                            continue;
                        }
                        if (k == ADD) {
                            list2.emplace_back(l[i] + l[j]);
                        } else if (k == MULTIPLY) {
                            list2.emplace_back(l[i] * l[j]);
                        } else if (k == SUBTRACT) {
                            list2.emplace_back(l[i] - l[j]);
                        } else if (k == DIVIDE) {
                            if (fabs(l[j]) < EPSILON) {
                                continue;
                            }
                            list2.emplace_back(l[i] / l[j]);
                        }
                        if (solve(list2)) {
                            return true;
                        }
                        list2.pop_back();
                    }
                }
            }
        }
        return false;
    }
};
```

```C [sol1-C]
const int TARGET = 24;
const double EPSILON = 1e-6;
const int ADD = 0, MULTIPLY = 1, SUBTRACT = 2, DIVIDE = 3;

bool solve(double *l, int l_len) {
    if (l_len == 0) {
        return false;
    }
    if (l_len == 1) {
        return fabs(l[0] - TARGET) < EPSILON;
    }
    int size = l_len;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            if (i != j) {
                double list2[20];
                int l2_len = 0;
                for (int k = 0; k < size; k++) {
                    if (k != i && k != j) {
                        list2[l2_len++] = l[k];
                    }
                }
                for (int k = 0; k < 4; k++) {
                    if (k < 2 && i > j) {
                        continue;
                    }
                    if (k == ADD) {
                        list2[l2_len++] = l[i] + l[j];
                    } else if (k == MULTIPLY) {
                        list2[l2_len++] = l[i] * l[j];
                    } else if (k == SUBTRACT) {
                        list2[l2_len++] = l[i] - l[j];
                    } else if (k == DIVIDE) {
                        if (fabs(l[j]) < EPSILON) {
                            continue;
                        }
                        list2[l2_len++] = l[i] / l[j];
                    }
                    if (solve(list2, l2_len)) {
                        return true;
                    }
                    l2_len--;
                }
            }
        }
    }
    return false;
}

bool judgePoint24(int *nums, int numsSize) {
    double l[20];
    int l_len = 0;
    for (int i = 0; i < numsSize; i++) {
        l[l_len++] = nums[i];
    }
    return solve(l, l_len);
}
```

```Python [sol1-Python3]
class Solution:
    def judgePoint24(self, nums: List[int]) -> bool:
        TARGET = 24
        EPSILON = 1e-6
        ADD, MULTIPLY, SUBTRACT, DIVIDE = 0, 1, 2, 3

        def solve(nums: List[float]) -> bool:
            if not nums:
                return False
            if len(nums) == 1:
                return abs(nums[0] - TARGET) < EPSILON
            for i, x in enumerate(nums):
                for j, y in enumerate(nums):
                    if i != j:
                        newNums = list()
                        for k, z in enumerate(nums):
                            if k != i and k != j:
                                newNums.append(z)
                        for k in range(4):
                            if k < 2 and i > j:
                                continue
                            if k == ADD:
                                newNums.append(x + y)
                            elif k == MULTIPLY:
                                newNums.append(x * y)
                            elif k == SUBTRACT:
                                newNums.append(x - y)
                            elif k == DIVIDE:
                                if abs(y) < EPSILON:
                                    continue
                                newNums.append(x / y)
                            if solve(newNums):
                                return True
                            newNums.pop()
            return False

        return solve(nums)
```

```golang [sol1-Golang]
const (
    TARGET = 24
    EPSILON = 1e-6
    ADD, MULTIPLY, SUBTRACT, DIVIDE = 0, 1, 2, 3
)

func judgePoint24(nums []int) bool {
    list := []float64{}
    for _, num := range nums {
        list = append(list, float64(num))
    }
    return solve(list)
}

func solve(list []float64) bool {
    if len(list) == 0 {
        return false
    }
    if len(list) == 1 {
        return abs(list[0] - TARGET) < EPSILON
    }
    size := len(list)
    for i := 0; i < size; i++ {
        for j := 0; j < size; j++ {
            if i != j {
                list2 := []float64{}
                for k := 0; k < size; k++ {
                    if k != i && k != j {
                        list2 = append(list2, list[k])
                    }
                }
                for k := 0; k < 4; k++ {
                    if k < 2 && i < j {
                        continue
                    }
                    switch k {
                    case ADD:
                        list2 = append(list2, list[i] + list[j])
                    case MULTIPLY:
                        list2 = append(list2, list[i] * list[j])
                    case SUBTRACT:
                        list2 = append(list2, list[i] - list[j])
                    case DIVIDE:
                        if abs(list[j]) < EPSILON {
                            continue
                        } else {
                            list2 = append(list2, list[i] / list[j])
                        }
                    }
                    if solve(list2) {
                        return true
                    }
                    list2 = list2[:len(list2) - 1]
                }
            }
        }
    }
    return false
}

func abs(x float64) float64 {
    if x < 0 {
        return -x
    }
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。一共有 $9216$ 种可能性，对于每种可能性，各项操作的时间复杂度都是 $O(1)$，因此总时间复杂度是 $O(1)$。

- 空间复杂度：$O(1)$。空间复杂度取决于递归调用层数与存储中间状态的列表，因为一共有 $4$ 个数，所以递归调用的层数最多为 $4$，存储中间状态的列表最多包含 $4$ 个元素，因此空间复杂度为常数。