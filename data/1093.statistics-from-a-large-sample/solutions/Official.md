## [1093.大样本统计 中文官方题解](https://leetcode.cn/problems/statistics-from-a-large-sample/solutions/100000/da-yang-ben-tong-ji-by-leetcode-solution-xx14)

#### 方法一：直接模拟

**思路与算法**

根据题意可知，需要计算样本数组的以下值：
+ $\textit{minimum}$：样本中的最小元素。
+ $\textit{maximum}$：样品中的最大元素。
+ $\textit{mean}$：样本的平均值，计算为所有元素的总和除以元素总数。
+ $\textit{median}$：样本的中位数。
  + 如果样本的元素个数是奇数，那么一旦样本排序后，中位数 $\textit{median}$ 就是中间的元素。
  + 如果样本中有偶数个元素，那么中位数 $\textit{median}$ 就是样本排序后中间两个元素的平均值。
+ $\textit{mode}$：样本中出现次数最多的数字。保众数是「唯一」的。

根据以上定义我们分别进行模拟计算即可，对 $0$ 到 $255$ 之间的整数进行采样，并将结果存储在数组 $\textit{count}$ 中：$\textit{count}[k]$ 就是整数 $k$ 在样本中出现的次数。
+ $\textit{minimum}$：定义为样本中的最小元素，由于从 $0$ 到 $255$ 采样，而题目中给定的每个整数出现的次数，我们从 $0$ 开始遍历找到第一个 $\textit{count}[i] > 0$ 的整数 $i$ 即为样本最小元素。
+ $\textit{maximum}$：定义为样本中的最大元素，我们从 $255$ 开始倒序遍历找到第一个 $\textit{count}[i] > 0$ 的整数 $i$ 即为样本最大元素。。
+ $\textit{mean}$：样本的平均值，我们计算样本数据的和，并除以样本的采样次数即可，其中样本数据的和为 $\sum_{i=0}^{255}\textit{count}[i] \times i$，采样次数为 $\sum_{i=0}^{255}\textit{count}[i]$，样本的平均值 $\textit{mean} = \dfrac{\sum_{i=0}^{255}\textit{count}[i] \times i}{\sum_{i=0}^{255}\textit{count}[i]}$。
+ $\textit{median}$：找到样本的中位数，样本的中位数稍微麻烦一些，已经知道采样总的次数为 $\textit{total} = \sum_{i=0}^{255}\textit{count}[i]$，此时:
  + 如果 $\textit{total}$ 为偶数：我们从小到大找到排序为 $\dfrac{\textit{total}}{2}$ 与 $\dfrac{\textit{total}}{2} + 1$ 的元素，此时中位数即为二者和的平均值；
  + 如果 $\textit{total}$ 为奇数：我们从小到大找到排序为 $\dfrac{\textit{total} + 1}{2}$ 的元素，此时中位数即为该元素。
  + 每次查找时统计当前已经遍历过的样本数目，$\textit{cnt}$ 表示从当前从元素 $0$ 开始到 $i$ 的样本总数，定义中位数的两个元素排序取值范围为 $[\textit{left}, \textit{right}]$，如果当前元素刚好处于中位数的取值范围则将其加入计算即可。

+ $\textit{mode}$：样本中出现次数最多的数字，找到 $\textit{count}[i]$ 的最大值，此时 $i$ 即为样本出现次数最多的数字。

**代码**

```C++ [sol1-C++]
class Solution {
public:    
    vector<double> sampleStats(vector<int>& count) {
        int n = count.size();
        int total = accumulate(count.begin(), count.end(), 0);
        double mean = 0.0;
        double median = 0.0;
        int minnum = 256;
        int maxnum = 0;
        int mode = 0;

        int left = (total + 1) / 2;
        int right = (total + 2) / 2;
        int cnt = 0;
        int maxfreq = 0;
        long long sum = 0;
        for (int i = 0; i < n; i++) {
            sum += (long long)count[i] * i;
            if (count[i] > maxfreq) {
                maxfreq = count[i];
                mode = i;
            }
            if (count[i] > 0) {
                if (minnum == 256) {
                    minnum = i;
                }
                maxnum = i;
            }
            if (cnt < right && cnt + count[i] >= right) {
                median += i;
            }
            if (cnt < left && cnt + count[i] >= left) {
                median += i;
            }
            cnt += count[i];
        }
        mean = (double) sum / total;
        median = median / 2.0;
        return {(double)minnum, (double)maxnum, mean, median, (double)mode};
    }
};
```

```Java [sol1-Java]
class Solution {
    public double[] sampleStats(int[] count) {
        int n = count.length;
        int total = Arrays.stream(count).sum();
        double mean = 0.0;
        double median = 0.0;
        int minnum = 256;
        int maxnum = 0;
        int mode = 0;

        int left = (total + 1) / 2;
        int right = (total + 2) / 2;
        int cnt = 0;
        int maxfreq = 0;
        long sum = 0;
        for (int i = 0; i < n; i++) {
            sum += (long) count[i] * i;
            if (count[i] > maxfreq) {
                maxfreq = count[i];
                mode = i;
            }
            if (count[i] > 0) {
                if (minnum == 256) {
                    minnum = i;
                }
                maxnum = i;
            }
            if (cnt < right && cnt + count[i] >= right) {
                median += i;
            }
            if (cnt < left && cnt + count[i] >= left) {
                median += i;
            }
            cnt += count[i];
        }
        mean = (double) sum / total;
        median = median / 2.0;
        return new double[]{minnum, maxnum, mean, median, mode};
    }
}
```

```Python [sol1-Python3]
class Solution:
    def sampleStats(self, count: List[int]) -> List[float]:
        n = len(count)
        total = sum(count)
        mean = 0.0
        median = 0.0
        min_num = 256
        max_num = 0
        mode = 0

        left = (total + 1) // 2
        right = (total + 2) // 2
        cnt = 0
        max_freq = 0
        sum_ = 0
        for i in range(n):
            sum_ += count[i] * i
            if count[i] > max_freq:
                max_freq = count[i]
                mode = i
            if count[i] > 0:
                if min_num == 256:
                    min_num = i
                max_num = i
            if cnt < right and cnt + count[i] >= right:
                median += i
            if cnt < left and cnt + count[i] >= left:
                median += i
            cnt += count[i]
        mean = sum_ / total
        median = median / 2.0
        return [min_num, max_num, mean, median, mode]
```

```Go [sol1-Go]
func sampleStats(count []int) []float64 {
    n := len(count)
    total := 0
    for i := 0; i < n; i++ {
        total += count[i]
    }
    mean := 0.0
    median := 0.0
    minimum := 256
    maxnum := 0
    mode := 0

    left := (total + 1) / 2
    right := (total + 2) / 2
    cnt := 0
    maxfreq := 0
    sum := 0
    for i := 0; i < n; i++ {
        sum += int(count[i]) * int(i)
        if count[i] > maxfreq {
            maxfreq = count[i]
            mode = i
        }
        if count[i] > 0 {
            if minimum == 256 {
                minimum = i
            }
            maxnum = i
        }
        if cnt < right && cnt+count[i] >= right {
            median += float64(i)
        }
        if cnt < left && cnt+count[i] >= left {
            median += float64(i)
        }
        cnt += count[i]
    }
    mean = float64(sum) / float64(total)
    median = median / 2.0
    return []float64{float64(minimum), float64(maxnum), mean, median, float64(mode)}
}
```

```JavaScript [sol1-JavaScript]
var sampleStats = function(count) {
    let n = count.length;
    let total = count.reduce((acc, cur) => acc + cur, 0);
    let mean = 0.0;
    let median = 0.0;
    let min_num = 256;
    let max_num = 0;
    let mode = 0;

    let left = parseInt((total + 1) / 2);
    let right = parseInt((total + 2) / 2);
    let cnt = 0;
    let maxfreq = 0;
    let sum = 0;
    for (let i = 0; i < n; i++) {
        sum += count[i] * i;
        if (count[i] > maxfreq) {
            maxfreq = count[i];
            mode = i;
        }
        if (count[i] > 0) {
            if (min_num == 256) {
                min_num = i;
            }
            max_num = i;
        }
        if (cnt < right && cnt + count[i] >= right) {
            median += i;
        }
        if (cnt < left && cnt + count[i] >= left) {
            median += i;
        }
        cnt += count[i];
    }
    mean = sum / total;
    median = median / 2.0;
    return [min_num, max_num, mean, median, mode];
}
```

```C# [sol1-C#]
public class Solution {
    public double[] SampleStats(int[] count) {
        int n = count.Length;
        int total = count.Sum();
        double mean = 0.0;
        double median = 0.0;
        int minnum = 256;
        int maxnum = 0;
        int mode = 0;

        int left = (total + 1) / 2;
        int right = (total + 2) / 2;
        int cnt = 0;
        int maxfreq = 0;
        long sum = 0;
        for (int i = 0; i < n; i++) {
            sum += (long) count[i] * i;
            if (count[i] > maxfreq) {
                maxfreq = count[i];
                mode = i;
            }
            if (count[i] > 0) {
                if (minnum == 256) {
                    minnum = i;
                }
                maxnum = i;
            }
            if (cnt < right && cnt + count[i] >= right) {
                median += i;
            }
            if (cnt < left && cnt + count[i] >= left) {
                median += i;
            }
            cnt += count[i];
        }
        mean = (double) sum / total;
        median = median / 2.0;
        return new double[]{minnum, maxnum, mean, median, mode};
    }
}
```

```C [sol1-C]
double* sampleStats(int* count, int countSize, int* returnSize) {
    int n = countSize;
    int total = 0;
    for (int i = 0; i < n; i++) {
        total += count[i];
    }
    double mean = 0.0;
    double median = 0.0;
    int minnum = 256;
    int maxnum = 0;
    int mode = 0;

    int left = (total + 1) / 2;
    int right = (total + 1) / 2 + ((total + 1) & 1);
    int cnt = 0;
    int maxfreq = 0;
    long long sum = 0;
    for (int i = 0; i < n; i++) {
        sum += (long long)count[i] * i;
        if (count[i] > maxfreq) {
            maxfreq = count[i];
            mode = i;
        }
        if (count[i] > 0) {
            if (minnum == 256) {
                minnum = i;
            }
            maxnum = i;
        }
        if (cnt < right && cnt + count[i] >= right) {
            median += i;
        }
        if (cnt < left && cnt + count[i] >= left) {
            median += i;
        }
        cnt += count[i];
    }
    mean = (double) sum / total;
    median = median / 2.0;
    double *ret = (double *)calloc(5, sizeof(double));
    ret[0] = (double)minnum;
    ret[1] = (double)maxnum;
    ret[2] = mean;
    ret[3] = median;
    ret[4] = (double)mode;
    *returnSize = 5;
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示给定的数组的长度。根据题意可知道只需遍历数组两次，总体时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。除返回值以外，不需要额外的空间。