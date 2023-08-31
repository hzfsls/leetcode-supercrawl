## [1515.服务中心的最佳位置 中文官方题解](https://leetcode.cn/problems/best-position-for-a-service-centre/solutions/100000/fu-wu-zhong-xin-de-zui-jia-wei-zhi-by-leetcode-sol)

#### 前言

比起普通的算法题，本题更像是机器学习岗位面试中的一道数学题。题目中给定的函数是一个凸函数（convex function），因此这是一个凸优化问题，「局部最小值」就等于「全局最小值」。

需要注意的是，最终的结果 $(x_c, y_c)$ 是给定的 $\{x_i\}$ 和 $\{y_i\}$ 的「几何中位数」。几何中位数并没有解析解，我们无法直接求出「全局最小值」。但我们可以使用求解「局部最小值」的方法，得到的结果就等于「全局最小值」。

> 为了叙述方便，本题解用 $(x_c, y_c)$ 表示题目描述中的 $(x_{center}, y_{center})$。

本题解会简单科普一些常用的求解「局部最小值」的算法。由于大部分算法为迭代法，因此不给出复杂度分析。凸函数的证明过程可参考文末的「凸函数证明」部分。

#### 方法一：梯度下降法

「梯度下降法」是机器学习中常用的一种求解局部最小值的算法。对于给定的点 $(x, y)$，它的梯度方向是函数值上升最快的方向，因此梯度反向就是函数值下降最快的方向。本题中需要优化的函数为：

$$
f(x_c, y_c) = \sum_{i=0}^{n-1} \sqrt{(x_c-x_i)^2 + (y_c-y_i)^2}
$$

它的导数为：

$$
\left\{
\begin{aligned}
\frac{\partial f}{\partial x} = \sum_{i=0}^{n-1} \frac{x_c-x_i}{\sqrt{(x_c-x_i)^2 + (y_c-y_i)^2}} \\
\frac{\partial f}{\partial y} = \sum_{i=0}^{n-1} \frac{y_c-y_i}{\sqrt{(x_c-x_i)^2 + (y_c-y_i)^2}}
\end{aligned}
\right.
$$

那么梯度反向 $-\nabla f = (-\dfrac{\partial f}{\partial x}, -\dfrac{\partial f}{\partial y})$。我们从一个初始点 $(x_{start}, y_{start})$ 开始进行迭代，每次令

$$
\left\{
\begin{aligned}
x'_{start} = x_{start} - \alpha \cdot \frac{\partial f}{\partial x} \\
y'_{start} = y_{start} - \alpha \cdot \frac{\partial f}{\partial y}
\end{aligned}
\right.
$$

得到一个新的点 $(x'_{start}, y'_{start})$，其中 $\alpha$ 为学习率（learning rate）。当迭代了一定次数之后，当前的点会非常接近真正的最小值点，如果我们的学习速率保持不变，迭代的结果将会在最小值点的周围来回「震荡」，无法继续接近最小值点。因此，我们需要设置学习率衰减（learning rate decay），在迭代的过程中逐步减小学习率，向最小值点逼近。

我们也可以使用机器学习中的一些技巧，例如「小批量梯度下降法」等，每次只对一批 $(x_i, y_i)$ 进行求导并更新答案。在下面的代码中，我们令：

- 初始点 $(x_{start}, y_{start}) = \left(\dfrac{\sum_{i=0}^{n-1} x_i}{n}, \dfrac{\sum_{i=0}^{n-1} y_i}{n} \right)$，即算术平均值；

- 学习率 $\alpha = 1$；

- 学习率衰减 $\eta = 10^{-3}$；

- 当 $(x_{start}, y_{start})$ 与 $(x'_{start}, y'_{start})$ 的距离小于 $10^{-7}$ 时结束迭代。

对于下面的代码，当批大小 $\text{batchSize} = n$，为「批量梯度下降法」，可以通过本题；当 $n=8/16$ 等常用值时，为「小批量梯度下降法」，由于具有随机性，可能得到的解并不精确，但有较高概率可以通过本题。

```C++ [sol1-C++]
class Solution {
public:
    double getMinDistSum(vector<vector<int>>& positions) {
        double eps = 1e-7;
        double alpha = 1;
        double decay = 1e-3;
        
        int n = positions.size();
        // 调整批大小
        int batchSize = n;
        
        double x = 0.0, y = 0.0;
        for (const auto& pos: positions) {
            x += pos[0];
            y += pos[1];
        }
        x /= n;
        y /= n;
        
        // 计算服务中心 (xc, yc) 到客户的欧几里得距离之和
        auto getDist = [&](double xc, double yc) {
            double ans = 0;
            for (const auto& pos: positions) {
                ans += sqrt((pos[0] - xc) * (pos[0] - xc) + (pos[1] - yc) * (pos[1] - yc));
            }
            return ans;
        };
        
        mt19937 gen{random_device{}()};

        while (true) {
            // 将数据随机打乱
            shuffle(positions.begin(), positions.end(), gen);
            double xPrev = x;
            double yPrev = y;

            for (int i = 0; i < n; i += batchSize) {
                int j = min(i + batchSize, n);
                double dx = 0.0, dy = 0.0;
                // 计算导数，注意处理分母为零的情况
                for (int k = i; k < j; ++k) {
                    const auto& pos = positions[k];
                    dx += (x - pos[0]) / (sqrt((x - pos[0]) * (x - pos[0]) + (y - pos[1]) * (y - pos[1])) + eps);
                    dy += (y - pos[1]) / (sqrt((x - pos[0]) * (x - pos[0]) + (y - pos[1]) * (y - pos[1])) + eps);
                }
                x -= alpha * dx;
                y -= alpha * dy;

                // 每一轮迭代后，将学习率进行衰减
                alpha *= (1.0 - decay);
            }
            
            // 判断是否结束迭代
            if (sqrt((x - xPrev) * (x - xPrev) + (y - yPrev) * (y - yPrev)) < eps) {
                break;
            }
        }
        
        return getDist(x, y);
    }
};
```

```Java [sol1-Java]
class Solution {
    public double getMinDistSum(int[][] positions) {
        double eps = 1e-7;
        double alpha = 1;
        double decay = 1e-3;
        
        int n = positions.length;
        // 调整批大小
        int batchSize = n;
        
        double x = 0.0, y = 0.0;
        for (int[] pos : positions) {
            x += pos[0];
            y += pos[1];
        }
        x /= n;
        y /= n;
        
        while (true) {
            // 将数据随机打乱
            shuffle(positions);
            double xPrev = x;
            double yPrev = y;

            for (int i = 0; i < n; i += batchSize) {
                int j = Math.min(i + batchSize, n);
                double dx = 0.0, dy = 0.0;
                // 计算导数，注意处理分母为零的情况
                for (int k = i; k < j; ++k) {
                    int[] pos = positions[k];
                    dx += (x - pos[0]) / (Math.sqrt((x - pos[0]) * (x - pos[0]) + (y - pos[1]) * (y - pos[1])) + eps);
                    dy += (y - pos[1]) / (Math.sqrt((x - pos[0]) * (x - pos[0]) + (y - pos[1]) * (y - pos[1])) + eps);
                }
                x -= alpha * dx;
                y -= alpha * dy;

                // 每一轮迭代后，将学习率进行衰减
                alpha *= (1.0 - decay);
            }
            
            // 判断是否结束迭代
            if (Math.sqrt((x - xPrev) * (x - xPrev) + (y - yPrev) * (y - yPrev)) < eps) {
                break;
            }
        }
        
        return getDist(x, y, positions);
    }

    public void shuffle(int[][] positions) {
        Random rand = new Random();
        int n = positions.length;
        for (int i = 0; i < n; i++) {
            int x = positions[i][0], y = positions[i][1];
            int randIndex = rand.nextInt(n);
            positions[i][0] = positions[randIndex][0];
            positions[i][1] = positions[randIndex][1];
            positions[randIndex][0] = x;
            positions[randIndex][1] = y;
        }
    }

    // 计算服务中心 (xc, yc) 到客户的欧几里得距离之和
    public double getDist(double xc, double yc, int[][] positions) {
        double ans = 0;
        for (int[] pos : positions) {
            ans += Math.sqrt((pos[0] - xc) * (pos[0] - xc) + (pos[1] - yc) * (pos[1] - yc));
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def getMinDistSum(self, positions: List[List[int]]) -> float:
        eps = 1e-7
        alpha = 1.0
        decay = 1e-3

        n = len(positions)
        # 调整批大小
        batchSize = n

        x = sum(pos[0] for pos in positions) / n
        y = sum(pos[1] for pos in positions) / n
        
        # 计算服务中心 (xc, yc) 到客户的欧几里得距离之和
        getDist = lambda xc, yc: sum(((x - xc) ** 2 + (y - yc) ** 2) ** 0.5 for x, y in positions)
        
        while True:
            # 将数据随机打乱
            random.shuffle(positions)
            xPrev, yPrev = x, y

            for i in range(0, n, batchSize):
                j = min(i + batchSize, n)
                dx, dy = 0.0, 0.0

                # 计算导数，注意处理分母为零的情况
                for k in range(i, j):
                    pos = positions[k]
                    dx += (x - pos[0]) / (sqrt((x - pos[0]) * (x - pos[0]) + (y - pos[1]) * (y - pos[1])) + eps)
                    dy += (y - pos[1]) / (sqrt((x - pos[0]) * (x - pos[0]) + (y - pos[1]) * (y - pos[1])) + eps)
                
                x -= alpha * dx
                y -= alpha * dy

                # 每一轮迭代后，将学习率进行衰减
                alpha *= (1.0 - decay)
            
            # 判断是否结束迭代
            if ((x - xPrev) ** 2 + (y - yPrev) ** 2) ** 0.5 < eps:
                break

        return getDist(x, y)
```

```C [sol1-C]
double getDist(int** positions, int positionsSize, double xc, double yc) {
    double ans = 0;
    for (int i = 0; i < positionsSize; i++) {
        int* pos = positions[i];
        ans += sqrt((pos[0] - xc) * (pos[0] - xc) + (pos[1] - yc) * (pos[1] - yc));
    }
    return ans;
};

void shuffle(int** positions, int positionsSize) {
    for (int i = positionsSize - 1; i >= 0; i--) {
        int add = rand() % (i + 1);
        int tmp[2] = {positions[add][0], positions[add][1]};
        positions[add][0] = positions[i][0];
        positions[add][1] = positions[i][1];
        positions[i][0] = tmp[0];
        positions[i][1] = tmp[1];
    }
}

double getMinDistSum(int** positions, int positionsSize, int* positionsColSize) {
    double eps = 1e-7;
    double alpha = 1;
    double decay = 1e-3;

    int batchSize = positionsSize;

    double x = 0.0, y = 0.0;
    for (int i = 0; i < positionsSize; i++) {
        int* pos = positions[i];
        x += pos[0];
        y += pos[1];
    }
    x /= positionsSize;
    y /= positionsSize;

    srand(time(0));

    while (true) {
        // 将数据随机打乱
        shuffle(positions, positionsSize);
        double xPrev = x;
        double yPrev = y;

        for (int i = 0; i < positionsSize; i += batchSize) {
            int j = fmin(i + batchSize, positionsSize);
            double dx = 0.0, dy = 0.0;
            // 计算导数，注意处理分母为零的情况
            for (int k = i; k < j; ++k) {
                int* pos = positions[k];
                dx += (x - pos[0]) / (sqrt((x - pos[0]) * (x - pos[0]) + (y - pos[1]) * (y - pos[1])) + eps);
                dy += (y - pos[1]) / (sqrt((x - pos[0]) * (x - pos[0]) + (y - pos[1]) * (y - pos[1])) + eps);
            }
            x -= alpha * dx;
            y -= alpha * dy;

            // 每一轮迭代后，将学习率进行衰减
            alpha *= (1.0 - decay);
        }

        // 判断是否结束迭代
        if (sqrt((x - xPrev) * (x - xPrev) + (y - yPrev) * (y - yPrev)) < eps) {
            break;
        }
    }

    return getDist(positions, positionsSize, x, y);
}
```

#### 方法二：爬山法

如果给定的凸函数很难进行求导（或者读者懒得求导）怎么办？注意到梯度反向 $-\nabla f = (-\dfrac{\partial f}{\partial x}, -\dfrac{\partial f}{\partial y})$ 实际上可以拆分成：

$$
\begin{aligned}
(-\dfrac{\partial f}{\partial x}, -\dfrac{\partial f}{\partial y}) &= (-\dfrac{\partial f}{\partial x}, 0) + (0, -\dfrac{\partial f}{\partial y}) \\
&= -\dfrac{\partial f}{\partial x} \cdot (1, 0)  -\dfrac{\partial f}{\partial y} \cdot (0, 1)
\end{aligned}
$$

即我们「横向」移动若干个单位长度，「纵向」移动若干个单位长度，也可以得到和梯度下降一样的结果。因此我们只需要考虑四个方向，即单位向量 $(1, 0)$，$(-1, 0)$，$(0, 1)$ 和 $(0, -1)$。

初始时，我们选择一个「步长」$\text{step}$，表示每次移动的距离。如果我们当前在位置 $(x, y)$，我们就依次枚举四个方向 $(d_x, d_y)$，并判断 $(x + \text{step} \cdot d_x, y + \text{step} \cdot d_y)$ 对应的函数值是否更小。如果找到一个满足要求的方向，我们就进行移动；否则说明我们当前的「步长」较大，直接越过了最值点，因此调整步长为原来的一半，直到步长小于给定的阈值 $\epsilon$。

在下面的代码中，我们令：

- 初始点 $(x_{start}, y_{start}) = \left(\dfrac{\sum_{i=0}^{n-1} x_i}{n}, \dfrac{\sum_{i=0}^{n-1} y_i}{n} \right)$，即算术平均值；

- 步长 $\text{step} = 1$；

- 步长阈值 $\epsilon = 10^{-7}$；

就可以通过本题。

这种方法叫做「爬山法」：如果我们将一个凸函数倒过来看，它会形成一个类似「山峰」的形状。在我们攀登顶峰（找到最大值点）的过程中，我们可能并不知道顶峰在哪里。但如果我们每一步都环顾四周，走向更高的地方（检查四个方向的函数值是否更大），那么我们最终总能到达山峰。

```C++ [sol2-C++]
class Solution {
private:
    static constexpr int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

public:
    double getMinDistSum(vector<vector<int>>& positions) {
        double eps = 1e-7;
        double step = 1;
        double decay = 0.5;
        
        int n = positions.size();
        
        double x = 0.0, y = 0.0;
        for (const auto& pos: positions) {
            x += pos[0];
            y += pos[1];
        }
        x /= n;
        y /= n;
        
        // 计算服务中心 (xc, yc) 到客户的欧几里得距离之和
        auto getDist = [&](double xc, double yc) {
            double ans = 0;
            for (const auto& pos: positions) {
                ans += sqrt((pos[0] - xc) * (pos[0] - xc) + (pos[1] - yc) * (pos[1] - yc));
            }
            return ans;
        };
        
        while (step > eps) {
            bool modified = false;
            for (int i = 0; i < 4; ++i) {
                double xNext = x + step * dirs[i][0];
                double yNext = y + step * dirs[i][1];
                if (getDist(xNext, yNext) < getDist(x, y)) {
                    x = xNext;
                    y = yNext;
                    modified = true;
                    break;
                }
            }
            if (!modified) {
                step *= (1.0 - decay);
            }
        }
        
        return getDist(x, y);
    }
};
```

```Java [sol2-Java]
class Solution {
    private static int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    public double getMinDistSum(int[][] positions) {
        double eps = 1e-7;
        double step = 1;
        double decay = 0.5;
        
        int n = positions.length;
        
        double x = 0.0, y = 0.0;
        for (int[] pos : positions) {
            x += pos[0];
            y += pos[1];
        }
        x /= n;
        y /= n;
        
        while (step > eps) {
            boolean modified = false;
            for (int i = 0; i < 4; ++i) {
                double xNext = x + step * dirs[i][0];
                double yNext = y + step * dirs[i][1];
                if (getDist(xNext, yNext, positions) < getDist(x, y, positions)) {
                    x = xNext;
                    y = yNext;
                    modified = true;
                    break;
                }
            }
            if (!modified) {
                step *= (1.0 - decay);
            }
        }
        
        return getDist(x, y, positions);
    }

    // 计算服务中心 (xc, yc) 到客户的欧几里得距离之和
    public double getDist(double xc, double yc, int[][] positions) {
        double ans = 0;
        for (int[] pos : positions) {
            ans += Math.sqrt((pos[0] - xc) * (pos[0] - xc) + (pos[1] - yc) * (pos[1] - yc));
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def getMinDistSum(self, positions: List[List[int]]) -> float:
        dirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]

        eps = 1e-7
        step = 1.0
        decay = 0.5

        n = len(positions)

        x = sum(pos[0] for pos in positions) / n
        y = sum(pos[1] for pos in positions) / n
        
        # 计算服务中心 (xc, yc) 到客户的欧几里得距离之和
        getDist = lambda xc, yc: sum(((x - xc) ** 2 + (y - yc) ** 2) ** 0.5 for x, y in positions)
        
        while step > eps:
            modified = False
            for dx, dy in dirs:
                xNext = x + step * dx
                yNext = y + step * dy
                if getDist(xNext, yNext) < getDist(x, y):
                    x, y = xNext, yNext
                    modified = True
                    break
            if not modified:
                step *= (1.0 - decay)

        return getDist(x, y)
```

```C [sol2-C]
#include <math.h>
#include <stdbool.h>
#include <string.h>

double getDist(int** positions, int positionsSize, double xc, double yc) {
    double ans = 0;
    for (int i = 0; i < positionsSize; i++) {
        int* pos = positions[i];
        ans += sqrt((pos[0] - xc) * (pos[0] - xc) + (pos[1] - yc) * (pos[1] - yc));
    }
    return ans;
};

const int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

double getMinDistSum(int** positions, int positionsSize, int* positionsColSize) {
    double eps = 1e-7;
    double step = 1;
    double decay = 0.5;

    int batchSize = positionsSize;

    double x = 0.0, y = 0.0;
    for (int i = 0; i < positionsSize; i++) {
        int* pos = positions[i];
        x += pos[0];
        y += pos[1];
    }
    x /= positionsSize;
    y /= positionsSize;

    while (step > eps) {
        bool modified = false;
        for (int i = 0; i < 4; ++i) {
            double xNext = x + step * dirs[i][0];
            double yNext = y + step * dirs[i][1];
            if (getDist(positions, positionsSize, xNext, yNext) < getDist(positions, positionsSize, x, y)) {
                x = xNext;
                y = yNext;
                modified = true;
                break;
            }
        }
        if (!modified) {
            step *= (1.0 - decay);
        }
    }

    return getDist(positions, positionsSize, x, y);
}
```

#### 方法三：三分查找

除了寻找下降的方向之外，我们也可以使用「三分查找」，逐步缩小范围，找到最小值点。

考虑一个 $\mathbb{R}$ 上的凸函数 $y = f(x)$，它的定义域为 $[L, R]$，我们可以用三分查找的方式将不可能包含最小值点的范围排除：

- 我们取两个点 $x_1, x_2$，满足 $L < x_1 < x_2 < R$，记 $y_1 = f(x_1)$，$y_2 = f(x_2)$；

- 如果 $y_1 > y_2$，那么最小值点一定不在 $[L, x_1]$ 内；如果 $y_1 < y_2$，那么最小值点一定不在 $[x_2, R]$ 内。

证明也很容易，只需要用到凸函数的定义。假设最小值点在 $[L, x_1]$ 内，记为 $x_m$。由于 $y_1 > y_2$，那么最小值点显然不为 $x_1$，即 $x_1 \neq x_m$。因此有 $x_m < x_1 < x_2$ 且 $f(x_m) < f(x_1)$，$f(x_2) < f(x_1)$。由于 $f$ 是凸函数，使用定比分点可以得到：

$$
\frac{x_2-x_1}{x_2-x_m} f(x_m) + \frac{x_1-x_m}{x_2-x_m} f(x_2) \geq f\left( \frac{x_2-x_1}{x_2-x_m} \cdot x_m + \frac{x_1-x_m}{x_2-x_m} \cdot x_2 \right)= f(x_1)
$$

然而：

$$
\frac{x_2-x_1}{x_2-x_m} f(x_m) + \frac{x_1-x_m}{x_2-x_m} f(x_2) < \frac{x_2-x_1}{x_2-x_m} f(x_1) + \frac{x_1-x_m}{x_2-x_m} f(x_1) = f(x_1)
$$

产生了矛盾！因此最小值点一定不在 $[L, x_1]$ 内。对于 $y_1 < y_2$ 的情况同理。

我们可以取 $x_1, x_2$ 为 $[L, R]$ 的三等分点，即：

$$
\left\{
\begin{aligned}
& x_1 = \frac{2L + R}{3} \\
& x_2 = \frac{L + 2R}{3}
\end{aligned}
\right.
$$

这样我们每次就可以排除三分之一的定义域。当定义域的宽度 $R-L$ 收敛至给定的阈值 $\epsilon$ 时，就可以结束三分查找。此时 $L$ 和 $R$ 足够接近，可以将 $[L, R]$ 内的所有值都视作极值点。

题目中的函数 $f(x_c, y_c)$ 是二元函数，我们可以使用「三分查找」套「三分查找」的方法。外层的三分查找用来确定 $x_c$ 的范围，每次三分查找时，取定义域 $[x_L, x_R]$ 中的两个三等分点 $x_1, x_2$，并分别固定 $x_c$ 的值为 $x_1$ 和 $x_2$，对 $y_c$ 进行三分查找。将得到的最优解进行比较，以此选择忽略 $[x_L, x_1]$ 或 $[x_2, x_R]$。

每一层的三分查找都会在定义域的宽度小于给定的阈值 $\epsilon$ 时结束。在下面的代码中，我们令：

- 区间宽度阈值 $\epsilon = 10^{-7}$；

就可以通过本题。

```C++ [sol3-C++]
class Solution {
public:
    double getMinDistSum(vector<vector<int>>& positions) {
        double eps = 1e-7;

        // 计算服务中心 (xc, yc) 到客户的欧几里得距离之和
        auto getDist = [&](double xc, double yc) {
            double ans = 0;
            for (const auto& pos: positions) {
                ans += sqrt((pos[0] - xc) * (pos[0] - xc) + (pos[1] - yc) * (pos[1] - yc));
            }
            return ans;
        };

        // 固定 xc，使用三分法找出最优的 yc
        auto checkOptimal = [&](double xc) {
            double yLeft = 0.0, yRight = 100.0;
            while (yRight - yLeft > eps) {
                double yFirst = (yLeft + yLeft + yRight) / 3;
                double ySecond = (yLeft + yRight + yRight) / 3;
                if (getDist(xc, yFirst) < getDist(xc, ySecond)) {
                    yRight = ySecond;
                }
                else {
                    yLeft = yFirst;
                }
            }
            return getDist(xc, yLeft);
        };
        
        double xLeft = 0.0, xRight = 100.0;
        while (xRight - xLeft > eps) {
            // 左 1/3 点
            double xFirst = (xLeft + xLeft + xRight) / 3;
            // 右 1/3 点
            double xSecond = (xLeft + xRight + xRight) / 3;
            if (checkOptimal(xFirst) < checkOptimal(xSecond)) {
                xRight = xSecond;
            }
            else {
                xLeft = xFirst;
            }
        }

        return checkOptimal(xLeft);
    }
};
```

```Java [sol3-Java]
class Solution {
    public double getMinDistSum(int[][] positions) {
        double eps = 1e-7;

        double xLeft = 0.0, xRight = 100.0;
        while (xRight - xLeft > eps) {
            // 左 1/3 点
            double xFirst = (xLeft + xLeft + xRight) / 3;
            // 右 1/3 点
            double xSecond = (xLeft + xRight + xRight) / 3;
            if (checkOptimal(xFirst, positions, eps) < checkOptimal(xSecond, positions, eps)) {
                xRight = xSecond;
            } else {
                xLeft = xFirst;
            }
        }

        return checkOptimal(xLeft, positions, eps);
    }

    // 计算服务中心 (xc, yc) 到客户的欧几里得距离之和
    public double getDist(double xc, double yc, int[][] positions) {
        double ans = 0;
        for (int[] pos : positions) {
            ans += Math.sqrt((pos[0] - xc) * (pos[0] - xc) + (pos[1] - yc) * (pos[1] - yc));
        }
        return ans;
    }

    // 固定 xc，使用三分法找出最优的 yc
    public double checkOptimal(double xc, int[][] positions, double eps) {
        double yLeft = 0.0, yRight = 100.0;
        while (yRight - yLeft > eps) {
            double yFirst = (yLeft + yLeft + yRight) / 3;
            double ySecond = (yLeft + yRight + yRight) / 3;
            if (getDist(xc, yFirst, positions) < getDist(xc, ySecond, positions)) {
                yRight = ySecond;
            } else {
                yLeft = yFirst;
            }
        }
        return getDist(xc, yLeft, positions);
    }    
}
```

```Python [sol3-Python3]
class Solution:
    def getMinDistSum(self, positions: List[List[int]]) -> float:
        eps = 1e-7

        # 计算服务中心 (xc, yc) 到客户的欧几里得距离之和
        getDist = lambda xc, yc: sum(((x - xc) ** 2 + (y - yc) ** 2) ** 0.5 for x, y in positions)

        # 固定 xc，使用三分法找出最优的 yc
        def checkOptimal(xc: float) -> float:
            yLeft, yRight = 0.0, 100.0
            while yRight - yLeft > eps:
                yFirst = (yLeft + yLeft + yRight) / 3
                ySecond = (yLeft + yRight + yRight) / 3
                if getDist(xc, yFirst) < getDist(xc, ySecond):
                    yRight = ySecond
                else:
                    yLeft = yFirst
            return getDist(xc, yLeft)
        
        xLeft, xRight = 0.0, 100.0
        while xRight - xLeft > eps:
            # 左 1/3 点
            xFirst = (xLeft + xLeft + xRight) / 3
            # 右 1/3 点
            xSecond = (xLeft + xRight + xRight) / 3
            if checkOptimal(xFirst) < checkOptimal(xSecond):
                xRight = xSecond
            else:
                xLeft = xFirst

        return checkOptimal(xLeft)
```

```C [sol3-C]
double eps = 1e-7;

double getDist(int** positions, int positionsSize, double xc, double yc) {
    double ans = 0;
    for (int i = 0; i < positionsSize; i++) {
        int* pos = positions[i];
        ans += sqrt((pos[0] - xc) * (pos[0] - xc) + (pos[1] - yc) * (pos[1] - yc));
    }
    return ans;
};

double checkOptimal(int** positions, int positionsSize, double xc) {
    double yLeft = 0.0, yRight = 100.0;
    while (yRight - yLeft > eps) {
        double yFirst = (yLeft + yLeft + yRight) / 3;
        double ySecond = (yLeft + yRight + yRight) / 3;
        if (getDist(positions, positionsSize, xc, yFirst) < getDist(positions, positionsSize, xc, ySecond)) {
            yRight = ySecond;
        } else {
            yLeft = yFirst;
        }
    }
    return getDist(positions, positionsSize, xc, yLeft);
};

double getMinDistSum(int** positions, int positionsSize, int* positionsColSize) {
    int batchSize = positionsSize;

    double x = 0.0, y = 0.0;
    for (int i = 0; i < positionsSize; i++) {
        int* pos = positions[i];
        x += pos[0];
        y += pos[1];
    }
    x /= positionsSize;
    y /= positionsSize;

    double xLeft = 0.0, xRight = 100.0;
    while (xRight - xLeft > eps) {
        // 左 1/3 点
        double xFirst = (xLeft + xLeft + xRight) / 3;
        // 右 1/3 点
        double xSecond = (xLeft + xRight + xRight) / 3;
        if (checkOptimal(positions, positionsSize, xFirst) < checkOptimal(positions, positionsSize, xSecond)) {
            xRight = xSecond;
        } else {
            xLeft = xFirst;
        }
    }

    return checkOptimal(positions, positionsSize, xLeft);
}
```

#### 凸函数证明

给定 $x_0, \cdots, x_{n-1} \in \mathbb{R}$ 以及 $y_0, \cdots, y_{n-1} \in \mathbb{R}$，证明

$$
f(x, y) = \sum_{i=0}^{n-1} \sqrt{(x-x_i)^2 + (y-y_i)^2}
$$

是 $\mathbb{R}^2$ 上的凸函数（convex function）。

**证明**

记 $f_i(x, y) = \sqrt{(x-x_i)^2 + (y-y_i)^2}$，显然 $f_i(x, y)$ 连续可导。一阶导数为：
$$
\left\{
\begin{aligned}
\frac{\partial f_i}{\partial x} = \frac{x-x_i}{\sqrt{(x-x_i)^2 + (y-y_i)^2}} \\
\frac{\partial f_i}{\partial y} = \frac{y-y_i}{\sqrt{(x-x_i)^2 + (y-y_i)^2}}
\end{aligned}
\right.
$$

二阶导数为：

$$
\left\{
\begin{aligned}
& \frac{\partial^2 f_i}{\partial x^2} = \frac{(y-y_i)^2}{\big((x-x_i)^2 + (y-y_i)^2\big)^{\frac{3}{2}}} \\
& \frac{\partial^2 f_i}{\partial y^2} = \frac{(x-x_i)^2}{\big((x-x_i)^2 + (y-y_i)^2\big)^{\frac{3}{2}}} \\
& \frac{\partial^2 f_i}{\partial x \partial y} = \frac{\partial^2 f_i}{\partial y \partial x} = -\frac{(x-x_i)(y-y_i)}{\big((x-x_i)^2 + (y-y_i)^2\big)^{\frac{3}{2}}}
\end{aligned}
\right.
$$

对应的 Hessian 矩阵

$$
H(f_i) = \left[
\begin{array}{cc}
\dfrac{\partial^2 f_i}{\partial x^2} & \dfrac{\partial^2 f_i}{\partial x \partial y} \\ \\
\dfrac{\partial^2 f_i}{\partial y \partial x} & \dfrac{\partial^2 f_i}{\partial y^2}
\end{array}
\right]
$$

的主子式

$$
\left\{
\begin{aligned}
& \frac{\partial^2 f_i}{\partial x^2} \geq 0 \\ \\
& \frac{\partial^2 f_i}{\partial y^2} \geq 0 \\ \\
& \frac{\partial^2 f_i}{\partial x^2} \frac{\partial^2 f_i}{\partial y^2} - \frac{\partial^2 f_i}{\partial x \partial y} \frac{\partial^2 f_i}{\partial y \partial x} = 0
\end{aligned}
\right.
$$

均大于等于零。因此 Hessian 矩阵为半正定矩阵，即 $f_i(x, y)$ 是凸函数。

因此 $f = \sum\limits_{i=0}^{n-1} f_i$ 也是凸函数。