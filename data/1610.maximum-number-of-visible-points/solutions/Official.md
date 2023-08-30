#### 方法一：二分查找

**思路**

题目本身为几何问题，需要求出在视角范围内 $[d - \textit{angle} / 2, d + \textit{angle} / 2]$ 内最多的点的覆盖数。在本题中视角可转换为相对于 $\textit{location}$ 的「[极角](https://baike.baidu.com/item/%E6%9E%81%E8%A7%92/12726003?fr=aladdin)」。首先将所有点 $p$ 的坐标转化为相对于 $\textit{location}$ 的极角，设点 $p$ 相对于 $\textit{location}$ 的极角为 $d_{p}$，找到坐标的极角处于区间 $[d_{p},d_{p} + \textit{angle}]$ 的最大数量即可。

- 极角转换时，已知两点的坐标可以通过反三角函数来进行转换，一般可以通过反余弦 $\texttt{acos}$，反正弦 $\texttt{asin}$，反正切 $\texttt{atan}$ 等函数来确定，但以上函数的返回值范围最多只能覆盖 $\pi$，可以利用函数 $\texttt{atan2}$，不同的语言实现可以参考不同语言的标准库函数。以 $\texttt{C++}$ 为例，「[$\texttt{atan2}$](https://zh.cppreference.com/w/cpp/numeric/math/atan2)」的返回值范围为 $[-\pi,\pi]$，它的覆盖范围为 $2\pi$。

- 我们将所有坐标的相对于 $\textit{location}$ 极角全部求出，并按照极角的大小进行排序，我们遍历每个坐标 $p_i = (x_i,y_i)$，我们设 $p_i$ 的相对于 $\textit{location}$ 的极角为 $d_{p_i}$，此时需要求出所有满足坐标的极角大小处在 $[d_{p_i},d_{p_i} + \textit{angle}]$ 范围内的最大数目，可以利用二分查找快速的统计出处在 $[d_{p_i},d_{p_i} + \textit{angle}]$ 的元素数目。特别注意的是，由于存在 $d_{p_i} + \textit{angle} > 180\degree$ 的情况，可以在原数组中将每个元素 $d_{p_i} + 360\degree$ 添加到原数组的后面，这样即可防止反转的问题。

- 在求极角时，对于坐标刚好处于 $\textit{location}$ 的元素需要单独进行统计，因为当 $\texttt{atan2}$ 的两个参数都为 $0$ 时，$\texttt{atan2}$ 的返回值可能是未定义的，因此我们要尽量避免这种情况发生，所以需要将位于 $\textit{location}$ 的坐标进行单独统计。

**代码**

```Java [sol1-Java]
class Solution {
    public int visiblePoints(List<List<Integer>> points, int angle, List<Integer> location) {
        int sameCnt = 0;
        List<Double> polarDegrees = new ArrayList<>();
        int locationX = location.get(0);
        int locationY = location.get(1);
        for (int i = 0; i < points.size(); ++i) {
            int x = points.get(i).get(0);
            int y = points.get(i).get(1);
            if (x == locationX && y == locationY) {
                sameCnt++;
                continue;
            }
            Double degree = Math.atan2(y - locationY, x - locationX);
            polarDegrees.add(degree);
        }
        Collections.sort(polarDegrees);

        int m = polarDegrees.size();
        for (int i = 0; i < m; ++i) {
            polarDegrees.add(polarDegrees.get(i) + 2 * Math.PI);
        }

        int maxCnt = 0;
        Double toDegree = angle * Math.PI / 180;
        for (int i = 0; i < m; ++i) {
            int iteration = binarySearch(polarDegrees, polarDegrees.get(i) + toDegree, false);
            maxCnt = Math.max(maxCnt, iteration - i);
        }
        return maxCnt + sameCnt;
    }

    public int binarySearch(List<Double> nums, Double target, boolean lower) {
        int left = 0, right = nums.size() - 1;
        int ans = nums.size();
        while (left <= right) {
            int mid = (left + right) / 2;
            if (nums.get(mid) > target || (lower && nums.get(mid) >= target)) {
                right = mid - 1;
                ans = mid;
            } else {
                left = mid + 1;
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int visiblePoints(vector<vector<int>>& points, int angle, vector<int>& location) {
        int sameCnt = 0;
        vector<double> polarDegrees;
        for (auto & point : points) {
            if (point[0] == location[0] && point[1] == location[1]) {
                sameCnt++;
                continue;
            }
            double degree = atan2(point[1] - location[1], point[0] - location[0]);
            polarDegrees.emplace_back(degree);
        }
        sort(polarDegrees.begin(), polarDegrees.end());

        int m = polarDegrees.size();
        for (int i = 0; i < m; ++i) {
            polarDegrees.emplace_back(polarDegrees[i] + 2 * M_PI);
        }

        int maxCnt = 0; 
        double degree = angle * M_PI / 180;
        for (int i = 0; i < m; ++i) {
            auto it = upper_bound(polarDegrees.begin() + i, polarDegrees.end(), polarDegrees[i] + degree);
            int curr = it - polarDegrees.begin() - i;
            maxCnt = max(maxCnt, curr);
        }
        return maxCnt + sameCnt;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int VisiblePoints(IList<IList<int>> points, int angle, IList<int> location) {
        int sameCnt = 0;
        List<double> polarDegrees = new List<double>();
        int locationX = location[0];
        int locationY = location[1];
        for (int i = 0; i < points.Count; ++i) {
            int x = points[i][0];
            int y = points[i][1];
            if (x == locationX && y == locationY) {
                sameCnt++;
                continue;
            }
            double degree = Math.Atan2(y - locationY, x - locationX);
            polarDegrees.Add(degree);
        }
        polarDegrees.Sort();

        int m = polarDegrees.Count;
        for (int i = 0; i < m; ++i) {
            polarDegrees.Add(polarDegrees[i] + 2 * Math.PI);
        }

        int maxCnt = 0;
        double toDegree = angle * Math.PI / 180.0;
        for (int i = 0; i < m; ++i) {
            int iteration = BinarySearch(polarDegrees, polarDegrees[i] + toDegree, false);
            maxCnt = Math.Max(maxCnt, iteration - i);
        }
        return maxCnt + sameCnt;
    }

    public int BinarySearch(List<double> nums, double target, bool lower) {
        int left = 0, right = nums.Count - 1;
        int ans = nums.Count;
        while (left <= right) {
            int mid = (left + right) / 2;
            if (nums[mid] > target || (lower && nums[mid] >= target)) {
                right = mid - 1;
                ans = mid;
            } else {
                left = mid + 1;
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
#define PI 3.1415926
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int cmp(const void* a, const void* b) {
    double* pa = (double*)a;
    double* pb = (double*)b;
    return *pa > *pb ? 1 : -1;
}

int binarySearch(double* nums, int numsSize, double target, bool lower) {
    int left = 0, right = numsSize - 1;
    int ans = 0;
    while (left <= right) {
        int mid = (left + right) / 2;
        if (nums[mid] > target || (lower && nums[mid] >= target)) {
            right = mid - 1;
            ans = mid;
        } else {
            left = mid + 1;
        }
    }
    return ans;
}

int visiblePoints(int** points, int pointsSize, int* pointsColSize, int angle, int* location, int locationSize){
    int sameCnt = 0;
    int polarSize = 0;
    double* polarDegrees = (double*)malloc(sizeof(double) * pointsSize * 2);
    for (int i = 0; i < pointsSize; ++i) {
        if (points[i][0] == location[0] && points[i][1] == location[1]) {
            sameCnt++;
            continue;
        }
        double degree = atan2(points[i][1] - location[1], points[i][0] - location[0]);
        polarDegrees[polarSize] = degree;
        polarSize++;
    }
    qsort(polarDegrees, polarSize, sizeof(double), cmp);

    int m = polarSize;
    for (int i = 0; i < m; ++i) {
        polarDegrees[polarSize] = polarDegrees[i] + 2 * PI;
        polarSize++;
    }

    int maxCnt = 0; 
    double degree = angle * PI / 180.0;
    for (int i = 0; i < m; ++i) {
        int iteration = binarySearch(polarDegrees, polarSize, polarDegrees[i] + degree, false);
        maxCnt = MAX(maxCnt, iteration - i);
    }
    return maxCnt + sameCnt;
}
```

```JavaScript [sol1-JavaScript]
var visiblePoints = function(points, angle, location) {
    let sameCnt = 0;
    const polarDegrees = [];
    let locationX = location[0];
    let locationY = location[1];
    for (let i = 0; i < points.length; ++i) {
        const x = points[i][0];
        const y = points[i][1];
        if (x === locationX && y === locationY) {
            sameCnt++;
            continue;
        }
        const degree = Math.atan2(y - locationY, x - locationX);
        polarDegrees.push(degree);
    }
    polarDegrees.sort((a, b) => a - b);

    const m = polarDegrees.length;
    for (let i = 0; i < m; ++i) {
        polarDegrees.push(polarDegrees[i] + Math.PI * 2);
    }

    let maxCnt = 0;
    const toDegree = angle * Math.PI / 180; 
    for (let i = 0; i < m; ++i) {
        const iteration = binarySearch(polarDegrees, polarDegrees[i] + toDegree, false);
        maxCnt = Math.max(maxCnt, iteration - i);
    }
    return maxCnt + sameCnt;
};

const binarySearch = (nums, target, lower) => {
    let left = 0, right = nums.length - 1;
    let ans = nums.length;
    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        if (nums[mid] > target || (lower && nums[mid] >= target)) {
            right = mid - 1;
            ans = mid;
        } else {
            left = mid + 1;
        }
    }
    return ans;
}
```

```go [sol1-Golang]
func visiblePoints(points [][]int, angle int, location []int) int {
    sameCnt := 0
    polarDegrees := []float64{}
    for _, p := range points {
        if p[0] == location[0] && p[1] == location[1] {
            sameCnt++
        } else {
            polarDegrees = append(polarDegrees, math.Atan2(float64(p[1]-location[1]), float64(p[0]-location[0])))
        }
    }
    sort.Float64s(polarDegrees)

    n := len(polarDegrees)
    for _, deg := range polarDegrees {
        polarDegrees = append(polarDegrees, deg+2*math.Pi)
    }

    maxCnt := 0
    degree := float64(angle) * math.Pi / 180
    for i, deg := range polarDegrees[:n] {
        j := sort.Search(n*2, func(j int) bool { return polarDegrees[j] > deg+degree })
        if j-i > maxCnt {
            maxCnt = j - i
        }
    }
    return sameCnt + maxCnt
}
```

```Python [sol1-Python3]
class Solution:
    def visiblePoints(self, points: List[List[int]], angle: int, location: List[int]) -> int:
        sameCnt = 0
        polarDegrees = []
        for p in points:
            if p == location:
                sameCnt += 1
            else:
                polarDegrees.append(atan2(p[1] - location[1], p[0] - location[0]))
        polarDegrees.sort()

        n = len(polarDegrees)
        polarDegrees += [deg + 2 * pi for deg in polarDegrees]

        degree = angle * pi / 180
        maxCnt = max((bisect_right(polarDegrees, polarDegrees[i] + degree) - i for i in range(n)), default=0)
        return maxCnt + sameCnt
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为坐标的个数，由于需要对所有的极角进行排序，再对每一个坐标的区间进行二分查找，因此总的时间复杂度应该为 $O(n \log n + 2n \log (2n)) = O(n \log n)$。

- 空间复杂度：$O(n)$，其中$n$ 为坐标的个数，我们总共最多需要两倍坐标个数的空间来存储坐标的极角。

#### 方法二：滑动窗口

**思路**

整体解题思路跟方法一类似，在进行区间查找时，可以利用滑动窗口对每个坐标的极角区间 $[d_{p_i},d_{p_i} + \textit{angle}]$ 查找的时间复杂度由 $O(2n \log 2n)$ 优化为 $O(2n + 2n)$。

**代码**

```Java [sol2-Java]
class Solution {
    public int visiblePoints(List<List<Integer>> points, int angle, List<Integer> location) {
        int sameCnt = 0;
        List<Double> polarDegrees = new ArrayList<>();
        int locationX = location.get(0);
        int locationY = location.get(1);
        for (int i = 0; i < points.size(); ++i) {
            int x = points.get(i).get(0);
            int y = points.get(i).get(1);
            if (x == locationX && y == locationY) {
                sameCnt++;
                continue;
            }
            Double degree = Math.atan2(y - locationY, x - locationX);
            polarDegrees.add(degree);
        }
        Collections.sort(polarDegrees);

        int m = polarDegrees.size();
        for (int i = 0; i < m; ++i) {
            polarDegrees.add(polarDegrees.get(i) + 2 * Math.PI);
        }

        int maxCnt = 0;
        int right = 0;
        double toDegree = angle * Math.PI / 180; 
        for (int i = 0; i < m; ++i) {
            Double curr = polarDegrees.get(i) + toDegree;
            while (right < polarDegrees.size() && polarDegrees.get(right) <= curr) {
                right++;
            }
            maxCnt = Math.max(maxCnt, right - i);
        }
        return maxCnt + sameCnt;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int visiblePoints(vector<vector<int>>& points, int angle, vector<int>& location) {
        int sameCnt = 0;
        vector<double> polarDegrees;
        for (auto & point : points) {
            if (point[0] == location[0] && point[1] == location[1]) {
                sameCnt++;
                continue;
            }
            double degree = atan2(point[1] - location[1], point[0] - location[0]);
            polarDegrees.emplace_back(degree);
        }
        sort(polarDegrees.begin(), polarDegrees.end());

        int m = polarDegrees.size();
        for (int i = 0; i < m; ++i) {
            polarDegrees.emplace_back(polarDegrees[i] + 2 * M_PI);
        }

        int maxCnt = 0;
        int right = 0;
        double degree = angle * M_PI / 180;
        for (int i = 0; i < m; ++i) {
            while (right < polarDegrees.size() && polarDegrees[right] <= polarDegrees[i] + degree) {
                right++;
            }
            maxCnt = max(maxCnt, right - i);
        }
        return maxCnt + sameCnt;
    }
};
```

```C# [sol2-C#]
public class Solution {
    public int VisiblePoints(IList<IList<int>> points, int angle, IList<int> location) {
        int sameCnt = 0;
        List<double> polarDegrees = new List<double>();
        int locationX = location[0];
        int locationY = location[1];
        for (int i = 0; i < points.Count; ++i) {
            int x = points[i][0];
            int y = points[i][1];
            if (x == locationX && y == locationY) {
                sameCnt++;
                continue;
            }
            double degree = Math.Atan2(y - locationY, x - locationX);
            polarDegrees.Add(degree);
        }
        polarDegrees.Sort();
 
        int m = polarDegrees.Count;
        for (int i = 0; i < m; ++i) {
            polarDegrees.Add(polarDegrees[i] + 2 * Math.PI);
        }

        int maxCnt = 0;
        int right = 0;
        double toDegree = angle * Math.PI / 180;
        for (int i = 0; i < m; ++i) {
            double curr = polarDegrees[i] + toDegree;
            while (right < polarDegrees.Count && polarDegrees[right] <= curr) {
                right++;
            }
            maxCnt = Math.Max(maxCnt, right - i);
        }
        return maxCnt + sameCnt;
    }
}
```

```C [sol2-C]
#define PI 3.1415926
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int cmp(const void* a, const void* b) {
    double* pa = (double*)a;
    double* pb = (double*)b;
    return *pa > *pb ? 1 : -1;
}

int visiblePoints(int** points, int pointsSize, int* pointsColSize, int angle, int* location, int locationSize){
    int sameCnt = 0;
    int polarSize = 0;
    double* polarDegrees = (double*)malloc(sizeof(double) * pointsSize * 2);
    for (int i = 0; i < pointsSize; ++i) {
        if (points[i][0] == location[0] && points[i][1] == location[1]) {
            sameCnt++;
            continue;
        }
        double degree = atan2(points[i][1] - location[1], points[i][0] - location[0]);
        polarDegrees[polarSize] = degree;
        polarSize++;
    }
    qsort(polarDegrees, polarSize, sizeof(double), cmp);

    int m = polarSize;
    for (int i = 0; i < m; ++i) {
        polarDegrees[polarSize] = polarDegrees[i] + 2 * PI;
        polarSize++;
    }

    int maxCnt = 0; 
    int right = 0;
    double toDegree = angle * PI / 180;
    for (int i = 0; i < m; ++i) {
        while (right < polarSize && polarDegrees[right] <= polarDegrees[i] + toDegree) {
            right++;
        }
        maxCnt = MAX(maxCnt, right - i);
    }
    return maxCnt + sameCnt;
}
```

```JavaScript [sol2-JavaScript]
var visiblePoints = function(points, angle, location) {
    let sameCnt = 0;
    const polarDegrees = [];
    let locationX = location[0];
    let locationY = location[1];
    for (let i = 0; i < points.length; ++i) {
        const x = points[i][0];
        const y = points[i][1];
        if (x === locationX && y === locationY) {
            sameCnt++;
            continue;
        }
        const degree = Math.atan2(y - locationY, x - locationX);
        polarDegrees.push(degree);
    }
    polarDegrees.sort((a, b) => a - b);

    const m = polarDegrees.length;
    for (let i = 0; i < m; ++i) {
        polarDegrees.push(polarDegrees[i] + 2 * Math.PI);
    }

    let maxCnt = 0;
    let right = 0;
    const toDegree = angle * Math.PI / 180;
    for (let i = 0; i < m; ++i) {
        const curr = polarDegrees[i] + toDegree;
        while (right < polarDegrees.length && polarDegrees[right] <= curr) {
            right++;
        }
        maxCnt = Math.max(maxCnt, right - i);
    }
    return maxCnt + sameCnt;
};
```

```go [sol2-Golang]
func visiblePoints(points [][]int, angle int, location []int) int {
    sameCnt := 0
    polarDegrees := []float64{}
    for _, p := range points {
        if p[0] == location[0] && p[1] == location[1] {
            sameCnt++
        } else {
            polarDegrees = append(polarDegrees, math.Atan2(float64(p[1]-location[1]), float64(p[0]-location[0])))
        }
    }
    sort.Float64s(polarDegrees)

    n := len(polarDegrees)
    for _, deg := range polarDegrees {
        polarDegrees = append(polarDegrees, deg+2*math.Pi)
    }

    maxCnt := 0
    right := 0
    degree := float64(angle) * math.Pi / 180
    for i, deg := range polarDegrees[:n] {
        for right < n*2 && polarDegrees[right] <= deg+degree {
            right++
        }
        if right-i > maxCnt {
            maxCnt = right - i
        }
    }
    return sameCnt + maxCnt
}
```

```Python [sol2-Python3]
class Solution:
    def visiblePoints(self, points: List[List[int]], angle: int, location: List[int]) -> int:
        sameCnt = 0
        polarDegrees = []
        for p in points:
            if p == location:
                sameCnt += 1
            else:
                polarDegrees.append(atan2(p[1] - location[1], p[0] - location[0]))
        polarDegrees.sort()

        n = len(polarDegrees)
        polarDegrees += [deg + 2 * pi for deg in polarDegrees]

        maxCnt = 0
        right = 0
        degree = angle * pi / 180
        for i in range(n):
            while right < n * 2 and polarDegrees[right] <= polarDegrees[i] + degree:
                right += 1
            maxCnt = max(maxCnt, right - i)
        return sameCnt + maxCnt
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为坐标的个数，由于需要对所有的极角进行排序，利用移动指针区间查找的时间复杂度为 $O(2n + 2n)$，因此总的时间复杂度应该为 $O(n \log n + 2n + 2n) = O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为坐标的个数，我们总共最多需要两倍坐标个数的空间来存储坐标的极角。