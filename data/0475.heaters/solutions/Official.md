## [475.供暖器 中文官方题解](https://leetcode.cn/problems/heaters/solutions/100000/gong-nuan-qi-by-leetcode-solution-rwui)

#### 方法一：排序 + 二分查找

**思路和算法**

为了使供暖器可以覆盖所有房屋且供暖器的加热半径最小，对于每个房屋，应该选择离该房屋最近的供暖器覆盖该房屋，最近的供暖器和房屋的距离即为该房屋需要的供暖器的最小加热半径。所有房屋需要的供暖器的最小加热半径中的最大值即为可以覆盖所有房屋的最小加热半径。

为了得到距离每个房屋最近的供暖器，可以将供暖器数组 $\textit{heaters}$ 排序，然后通过二分查找得到距离最近的供暖器。

具体而言，对于每个房屋 $\textit{house}$，需要在有序数组 $\textit{heaters}$ 中找到最大的下标 $i$，使得 $\textit{heaters}[i] \le \textit{house}$，特别地，当 $\textit{heaters}[0] > \textit{house}$ 时，$i = -1$。在得到下标 $i$ 之后，令 $j = i + 1$，则 $j$ 是满足 $\textit{heaters}[j] > \textit{house}$ 的最小下标。特别地，当 $\textit{heaters}[n - 1] \le \textit{house}$ 时，$j = n$，其中 $n$ 是数组 $\textit{heaters}$ 的长度。

得到下标 $i$ 和 $j$ 之后，离房屋 $\textit{house}$ 最近的供暖器为 $\textit{heaters}[i]$ 或 $\textit{heaters}[j]$，分别计算这两个供暖器和房屋 $\textit{house}$ 的距离，其中的最小值即为该房屋需要的供暖器的最小加热半径。对于 $i = -1$ 或 $j = n$ 的下标越界情况，只要将对应的距离设为 $+\infty$ 即可。

**代码**

```Java [sol1-Java]
class Solution {
    public int findRadius(int[] houses, int[] heaters) {
        int ans = 0;
        Arrays.sort(heaters);
        for (int house : houses) {
            int i = binarySearch(heaters, house);
            int j = i + 1;
            int leftDistance = i < 0 ? Integer.MAX_VALUE : house - heaters[i];
            int rightDistance = j >= heaters.length ? Integer.MAX_VALUE : heaters[j] - house;
            int curDistance = Math.min(leftDistance, rightDistance);
            ans = Math.max(ans, curDistance);
        }
        return ans;
    }

    public int binarySearch(int[] nums, int target) {
        int left = 0, right = nums.length - 1;
        if (nums[left] > target) {
            return -1;
        }
        while (left < right) {
            int mid = (right - left + 1) / 2 + left;
            if (nums[mid] > target) {
                right = mid - 1;
            } else {
                left = mid;
            }
        }
        return left;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindRadius(int[] houses, int[] heaters) {
        int ans = 0;
        Array.Sort(heaters);
        foreach (int house in houses) {
            int i = BinarySearch(heaters, house);
            int j = i + 1;
            int leftDistance = i < 0 ? int.MaxValue : house - heaters[i];
            int rightDistance = j >= heaters.Length ? int.MaxValue : heaters[j] - house;
            int curDistance = Math.Min(leftDistance, rightDistance);
            ans = Math.Max(ans, curDistance);
        }
        return ans;
    }

    public int BinarySearch(int[] nums, int target) {
        int left = 0, right = nums.Length - 1;
        if (nums[left] > target) {
            return -1;
        }
        while (left < right) {
            int mid = (right - left + 1) / 2 + left;
            if (nums[mid] > target) {
                right = mid - 1;
            } else {
                left = mid;
            }
        }
        return left;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int findRadius(vector<int> &houses, vector<int> &heaters) {
        int ans = 0;
        sort(heaters.begin(), heaters.end());
        for (int house: houses) {
            int j = upper_bound(heaters.begin(), heaters.end(), house) - heaters.begin();
            int i = j - 1;
            int rightDistance = j >= heaters.size() ? INT_MAX : heaters[j] - house;
            int leftDistance = i < 0 ? INT_MAX : house - heaters[i];
            int curDistance = min(leftDistance, rightDistance);
            ans = max(ans, curDistance);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def findRadius(self, houses: List[int], heaters: List[int]) -> int:
        ans = 0
        heaters.sort()
        for house in houses:
            j = bisect_right(heaters, house)
            i = j - 1
            rightDistance = heaters[j] - house if j < len(heaters) else float('inf')
            leftDistance = house - heaters[i] if i >= 0 else float('inf')
            curDistance = min(leftDistance, rightDistance)
            ans = max(ans, curDistance)
        return ans
```

```JavaScript [sol1-JavaScript]
var findRadius = function(houses, heaters) {
    let ans = 0;
    heaters.sort((a, b) => a - b);
    for (const house of houses) {
        const i = binarySearch(heaters, house);
        const j = i + 1;
        const leftDistance = i < 0 ? Number.MAX_VALUE : house - heaters[i];
        const rightDistance = j >= heaters.length ? Number.MAX_VALUE : heaters[j] - house;
        const curDistance = Math.min(leftDistance, rightDistance);
        ans = Math.max(ans, curDistance);
    }
    return ans;
};

const binarySearch = (nums, target) => {
    let left = 0, right = nums.length - 1;
    if (nums[left] > target) {
        return -1;
    }
    while (left < right) {
        const mid = Math.floor((right - left + 1) / 2) + left;
        if (nums[mid] > target) {
            right = mid - 1;
        } else {
            left = mid;
        }
    }
    return left;
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int binarySearch(const int* nums, int numsSize, int target) {
    int left = 0, right = numsSize - 1;
    if (nums[left] > target) {
        return -1;
    }
    while (left < right) {
        int mid = (right - left + 1) / 2 + left;
        if (nums[mid] > target) {
            right = mid - 1;
        } else {
            left = mid;
        }
    }
    return left;
}

int cmp(const void* a, const void* b) {
    int* pa = (int*)a;
    int* pb = (int*)b;
    return *pa - *pb;
}

int findRadius(int* houses, int housesSize, int* heaters, int heatersSize){
    int ans = 0;
    qsort(heaters, heatersSize, sizeof(int), cmp);
    for (int k = 0; k < housesSize; ++k) {
        int i = binarySearch(heaters, heatersSize, houses[k]);
        int j = i + 1;
        int leftDistance = i < 0 ? INT_MAX : houses[k] - heaters[i];
        int rightDistance = j >= heatersSize ? INT_MAX : heaters[j] - houses[k];
        int curDistance = MIN(leftDistance, rightDistance);
        ans = MAX(ans, curDistance);
    }
    return ans;
}
```

```go [sol1-Golang]
func findRadius(houses, heaters []int) (ans int) {
    sort.Ints(heaters)
    for _, house := range houses {
        j := sort.SearchInts(heaters, house+1)
        minDis := math.MaxInt32
        if j < len(heaters) {
            minDis = heaters[j] - house
        }
        i := j - 1
        if i >= 0 && house-heaters[i] < minDis {
            minDis = house - heaters[i]
        }
        if minDis > ans {
            ans = minDis
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O((n + m) \log n)$，其中 $m$ 是数组 $\textit{houses}$ 的长度，$n$ 是数组 $\textit{heaters}$ 的长度。
  对数组 $\textit{heaters}$ 排序需要 $O(n \log n)$ 的时间。
  使用二分查找对每个房屋寻找距离最近的供暖器，每次二分查找需要 $O(\log n)$ 的时间，有 $m$ 个房屋，因此需要 $O(m \log n)$ 的时间。
  总时间复杂度是 $O((n + m) \log n)$。

- 空间复杂度：$O(\log n)$，其中 $n$ 是数组 $\textit{heaters}$ 的长度。空间复杂度主要取决于排序所需要的空间。

#### 方法二：排序 + 双指针

**思路和算法**

也可以使用双指针寻找和每个房屋距离最近的供暖器。首先对房屋数组 $\textit{houses}$ 和供暖器数组 $\textit{heaters}$ 排序，然后同时遍历两个数组。

分别用 $m$ 和 $n$ 表示数组 $\textit{houses}$ 和 $\textit{heaters}$ 的长度。对于每个 $0 \le i < m$，需要找到下标 $j$ 使得 $\Big|\textit{houses}[i] - \textit{heaters}[j]\Big|$ 最小，则 $\textit{heaters}[j]$ 是和 $\textit{houses}[i]$ 距离最近的供暖器。初始时，$i = j = 0$。

从左到右依次遍历数组 $\textit{houses}$，对于每个下标 $i$，需要维护离 $\textit{houses}[i]$ 最近的供暖器的距离，将距离初始化为 $\textit{houses}[i] - \textit{heaters}[j]$。只要 $\textit{heaters}[j]$ 和当前房屋的距离大于等于 $\textit{heaters}[j + 1]$ 和当前房屋的距离，则将 $j$ 加 $1$，直到 $j = n - 1$ 或者 $\textit{heaters}[j]$ 和当前房屋的距离小于 $\textit{heaters}[j + 1]$ 和当前房屋的距离，此时 $\textit{heaters}[j]$ 为离 $\textit{houses}[i]$ 最近的供暖器，$\textit{heaters}[j]$ 和当前房屋的距离即为当前房屋和最近的供暖器的距离。

遍历完所有房屋之后，即可得到可以覆盖所有房屋的最小加热半径。

**证明**

上述做法中，假设在 $\textit{houses}[i]$ 处的 $j$ 初始值是 $j_0$，则可以保证得到的 $\textit{heaters}[j]$ 是在 $j \ge j_0$ 的情况下和 $\textit{houses}[i]$ 距离最近的供暖器。为了确保和 $\textit{houses}[i]$ 距离最近的供暖器是 $\textit{heaters}[j]$，还需要证明对任意 $j' < j_0$ 都有 $\Big|\textit{houses}[i] - \textit{heaters}[j']\Big| \ge \Big|\textit{houses}[i] - \textit{heaters}[j]\Big|$。可以通过数学归纳法证明。

1. 当 $i = 0$ 时，$j_0 = 0$，因此不存在 $j' < j_0$ 使得 $\Big|\textit{houses}[i] - \textit{heaters}[j']\Big| < \Big|\textit{houses}[i] - \textit{heaters}[j]\Big|$。

2. 当 $i > 0$ 时，假设和 $\textit{houses}[i - 1]$ 距离最近的供暖器是 $\textit{heaters}[j_0]$ 且不存在 $j' < j_0$ 使得 $\textit{heaters}[j']$ 和 $\textit{houses}[i - 1]$ 的距离更小，则对于 $\textit{houses}[i]$，$j$ 从 $j_0$ 开始向右遍历。

   - 如果 $\textit{houses}[i] \ge \textit{heaters}[j]$，则 $\Big|\textit{houses}[i] - \textit{heaters}[j]\Big| = \textit{houses}[i] - \textit{heaters}[j]$。由于 $j' < j_0 \le j$，因此 $\textit{heaters}[j'] \le \textit{heaters}[j]$，$\textit{houses}[i] - \textit{heaters}[j'] \ge \textit{houses}[i] - \textit{heaters}[j]$，即 $\textit{heaters}[j']$ 和 $\textit{houses}[i]$ 的距离不可能小于 $\textit{heaters}[j]$ 和 $\textit{houses}[i]$ 的距离。

   ![fig1](https://assets.leetcode-cn.com/solution-static/475/1.png)

   - 如果 $\textit{houses}[i] < \textit{heaters}[j]$，则一定有 $j = j_0$ 或 $\textit{houses}[i] > \textit{heaters}[j_0]$，否则 $\textit{heaters}[j_0]$ 和 $\textit{houses}[i]$ 的距离更近，矛盾。

      - 如果 $j = j_0$，则根据 $\textit{heaters}[j_0]$ 是和 $\textit{houses}[i - 1]$ 距离最近的供暖器可知，对于任意 $j' < j_0$，一定有 $\textit{houses}[i] \ge \textit{houses}[i - 1] > \textit{heaters}[j']$，$\textit{houses}[i - 1] - \textit{heaters}[j'] \ge \textit{heaters}[j_0] - \textit{houses}[i - 1]$，由于 $\textit{houses}[i - 1] \le \textit{houses}[i]$ 因此有 $\textit{houses}[i] - \textit{heaters}[j'] \ge \textit{heaters}[j_0] - \textit{houses}[i]$。

      - 如果 $\textit{houses}[i] > \textit{heaters}[j_0]$，则对于任意 $j' < j_0$，$\textit{heaters}[j']$ 和 $\textit{houses}[i]$ 的距离不可能小于 $\textit{heaters}[j_0]$ 和 $\textit{houses}[i]$ 的距离，因此 $\textit{heaters}[j']$ 和 $\textit{houses}[i]$ 的距离不可能小于 $\textit{heaters}[j]$ 和 $\textit{houses}[i]$ 的距离。

   ![fig2](https://assets.leetcode-cn.com/solution-static/475/2.png)

   因此对于 $\textit{houses}[i]$，不存在 $j' < j_0$ 使得 $\textit{heaters}[j']$ 和 $\textit{houses}[i]$ 的距离更小。

**代码**

```Java [sol2-Java]
class Solution {
    public int findRadius(int[] houses, int[] heaters) {
        Arrays.sort(houses);
        Arrays.sort(heaters);
        int ans = 0;
        for (int i = 0, j = 0; i < houses.length; i++) {
            int curDistance = Math.abs(houses[i] - heaters[j]);
            while (j < heaters.length - 1 && Math.abs(houses[i] - heaters[j]) >= Math.abs(houses[i] - heaters[j + 1])) {
                j++;
                curDistance = Math.min(curDistance, Math.abs(houses[i] - heaters[j]));
            }
            ans = Math.max(ans, curDistance);
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int FindRadius(int[] houses, int[] heaters) {
        Array.Sort(houses);
        Array.Sort(heaters);
        int ans = 0;
        for (int i = 0, j = 0; i < houses.Length; i++) {
            int curDistance = Math.Abs(houses[i] - heaters[j]);
            while (j < heaters.Length - 1 && Math.Abs(houses[i] - heaters[j]) >= Math.Abs(houses[i] - heaters[j + 1])) {
                j++;
                curDistance = Math.Min(curDistance, Math.Abs(houses[i] - heaters[j]));
            }
            ans = Math.Max(ans, curDistance);
        }
        return ans;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int findRadius(vector<int>& houses, vector<int>& heaters) {
        sort(houses.begin(), houses.end());
        sort(heaters.begin(), heaters.end());
        int ans = 0;
        for (int i = 0, j = 0; i < houses.size(); i++) {
            int curDistance = abs(houses[i] - heaters[j]);
            while (j < heaters.size() - 1 && abs(houses[i] - heaters[j]) >= abs(houses[i] - heaters[j + 1])) {
                j++;
                curDistance = min(curDistance, abs(houses[i] - heaters[j]));
            }
            ans = max(ans, curDistance);
        }
        return ans;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def findRadius(self, houses: List[int], heaters: List[int]) -> int:
        ans = 0
        houses.sort()
        heaters.sort()
        j = 0
        for i, house in enumerate(houses):
            curDistance = abs(house - heaters[j])
            while j + 1 < len(heaters) and abs(houses[i] - heaters[j]) >= abs(houses[i] - heaters[j + 1]):
                j += 1
                curDistance = min(curDistance, abs(houses[i] - heaters[j]))
            ans = max(ans, curDistance)
        return ans
```

```JavaScript [sol2-JavaScript]
var findRadius = function(houses, heaters) {
    houses.sort((a, b) => a - b);
    heaters.sort((a, b) => a - b);
    let ans = 0;
    for (let i = 0, j = 0; i < houses.length; i++) {
        let curDistance = Math.abs(houses[i] - heaters[j]);
        while (j < heaters.length - 1 && Math.abs(houses[i] - heaters[j]) >= Math.abs(houses[i] - heaters[j + 1])) {
            j++;
            curDistance = Math.min(curDistance, Math.abs(houses[i] - heaters[j]));
        }
        ans = Math.max(ans, curDistance);
    }
    return ans;
};
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int cmp(const void* a, const void* b) {
    int* pa = (int*)a;
    int* pb = (int*)b;
    return *pa - *pb;
}

int findRadius(int* houses, int housesSize, int* heaters, int heatersSize){
    int ans = 0;
    qsort(heaters, heatersSize, sizeof(int), cmp);
    qsort(houses, housesSize, sizeof(int), cmp);
    for (int i = 0, j = 0; i < housesSize; i++) {
        int curDistance = abs(houses[i] - heaters[j]);
        while (j < heatersSize - 1 && abs(houses[i] - heaters[j]) >= abs(houses[i] - heaters[j + 1])) {
            j++;
            curDistance = MIN(curDistance, abs(houses[i] - heaters[j]));
        }
        ans = MAX(ans, curDistance);
    }
    return ans;    
}
```

```go [sol2-Golang]
func findRadius(houses, heaters []int) (ans int) {
    sort.Ints(houses)
    sort.Ints(heaters)
    j := 0
    for _, house := range houses {
        dis := abs(house - heaters[j])
        for j+1 < len(heaters) && abs(house-heaters[j]) >= abs(house-heaters[j+1]) {
            j++
            if abs(house-heaters[j]) < dis {
                dis = abs(house - heaters[j])
            }
        }
        if dis > ans {
            ans = dis
        }
    }
    return
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(m \log m + n \log n)$，其中 $m$ 是数组 $\textit{houses}$ 的长度，$n$ 是数组 $\textit{heaters}$ 的长度。
  对数组 $\textit{houses}$ 和 $\textit{heaters}$ 排序分别需要 $O(m \log m)$ 和 $O(n \log n)$ 的时间。
  使用双指针遍历两个数组需要 $O(m + n)$ 的时间。
  由于在渐进意义下 $O(m + n)$ 小于 $O(m \log m + n \log n)$，因此总时间复杂度是 $O(m \log m + n \log n)$。

- 空间复杂度：$O(\log m + \log n)$，其中 $m$ 是数组 $\textit{houses}$ 的长度，$n$ 是数组 $\textit{heaters}$ 的长度。空间复杂度主要取决于排序所需要的空间。