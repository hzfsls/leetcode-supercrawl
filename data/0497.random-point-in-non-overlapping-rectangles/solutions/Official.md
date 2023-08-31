## [497.非重叠矩形中的随机点 中文官方题解](https://leetcode.cn/problems/random-point-in-non-overlapping-rectangles/solutions/100000/fei-zhong-die-ju-xing-zhong-de-sui-ji-di-6s33)
#### 方法一：前缀和 + 二分查找

**思路**

记 $\textit{rects}$ 的长度为 $n$。矩形 $\textit{rects}[i]$ 的左下角点为 $(a_i, b_i)$, 右上角点为 $(x_i, y_i)$，则它覆盖的整数点有 $s_i = (x_i-a_i+1)\times(y_i-b_i+1)$ 个。数组 $\textit{rects}$ 表示的 $n$ 个矩形一共覆盖 $S = \sum\limits_{i=0}^{n-1}s_i$ 个整数点。我们将这些整数点进行编号为 $0$ 至 $S-1$。其中 $\textit{rects}[0]$ 覆盖的点编号为 $0$ 至 $s_0-1$，$\textit{rects}[1]$ 覆盖的整数点为接下去 $s_1$ 个，编号为 $s_0$ 至 $s_0+s_1-1$，依此类推。在同一个矩形中，整数点一共有 $(y_i-b_i+1)$ 行，$(x_i-a_i+1)$ 列。在同一个矩形中的编号，左下角为 $0$，并在同一行中，随着横坐标的增加，编号增加，右下角点 $(x_i, b_i)$ 在这个矩形中的编号为 $(x_i-a_i)$。接着逐行向上进行编号。

编号完成后，可以进行随机取点。在所有编号内等概率随机取整数 $k$，先确定它位于哪个矩形中，然后再确定它在矩形中的位置。确定矩形编号时，可以采用预处理前缀和和二分搜索的方式。前缀和可以记录某个矩形覆盖的整数点的编号范围。因为不同矩形覆盖的整数点编号是单调的，利用二分搜索根据整数点编号快速确定矩形编号。确定矩形编号后，原整数点编号可以转换为矩形内整数点编号，然后定位具体的点的坐标。

**代码**

```Python [sol1-Python3]
class Solution:
    def __init__(self, rects: List[List[int]]):
        self.rects = rects
        self.sum = [0]
        for a, b, x, y in rects:
            self.sum.append(self.sum[-1] + (x - a + 1) * (y - b + 1))

    def pick(self) -> List[int]:
        k = randrange(self.sum[-1])
        rectIndex = bisect_right(self.sum, k) - 1
        a, b, _, y = self.rects[rectIndex]
        da, db = divmod(k - self.sum[rectIndex], y - b + 1)
        return [a + da, b + db]
```

```Java [sol1-Java]
class Solution {
    Random rand;
    List<Integer> arr;
    int[][] rects;

    public Solution(int[][] rects) {
        rand = new Random();
        arr = new ArrayList<Integer>();
        arr.add(0);
        this.rects = rects;
        for (int[] rect : rects) {
            int a = rect[0], b = rect[1], x = rect[2], y = rect[3];
            arr.add(arr.get(arr.size() - 1) + (x - a + 1) * (y - b + 1));
        }
    }

    public int[] pick() {
        int k = rand.nextInt(arr.get(arr.size() - 1));
        int rectIndex = binarySearch(arr, k + 1) - 1;
        k -= arr.get(rectIndex);
        int[] rect = rects[rectIndex];
        int a = rect[0], b = rect[1], y = rect[3];
        int col = y - b + 1;
        int da = k / col;
        int db = k - col * da;
        return new int[]{a + da, b + db};
    }

    private int binarySearch(List<Integer> arr, int target) {
        int low = 0, high = arr.size() - 1;
        while (low <= high) {
            int mid = (high - low) / 2 + low;
            int num = arr.get(mid);
            if (num == target) {
                return mid;
            } else if (num > target) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C# [sol1-C#]
public class Solution {
    Random rand;
    IList<int> arr;
    int[][] rects;

    public Solution(int[][] rects) {
        rand = new Random();
        arr = new List<int>();
        arr.Add(0);
        this.rects = rects;
        foreach (int[] rect in rects) {
            int a = rect[0], b = rect[1], x = rect[2], y = rect[3];
            arr.Add(arr[arr.Count - 1] + (x - a + 1) * (y - b + 1));
        }
    }

    public int[] Pick() {
        int k = rand.Next(arr[arr.Count - 1]);
        int rectIndex = BinarySearch(arr, k + 1) - 1;
        k -= arr[rectIndex];
        int[] rect = rects[rectIndex];
        int a = rect[0], b = rect[1], y = rect[3];
        int col = y - b + 1;
        int da = k / col;
        int db = k - col * da;
        return new int[]{a + da, b + db};
    }

    private int BinarySearch(IList<int> arr, int target) {
        int low = 0, high = arr.Count - 1;
        while (low <= high) {
            int mid = (high - low) / 2 + low;
            int num = arr[mid];
            if (num == target) {
                return mid;
            } else if (num > target) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    Solution(vector<vector<int>>& rects) : rects{rects} {
        this->arr.emplace_back(0);
        for (auto & rect : rects) {
            this->arr.emplace_back(arr.back() + (rect[2] - rect[0] + 1) * (rect[3] - rect[1] + 1));
        }
    }
    
    vector<int> pick() {
        uniform_int_distribution<int> dis(0, arr.back() - 1);
        int k = dis(gen) % arr.back();
        int rectIndex = upper_bound(arr.begin(), arr.end(), k) - arr.begin() - 1;
        k = k - arr[rectIndex];
        int a = rects[rectIndex][0], b = rects[rectIndex][1];
        int y = rects[rectIndex][3];
        int col = y - b + 1;
        int da = k / col;
        int db = k - col * da;
        return {a + da, b + db};
    }    
private:
    vector<int> arr;
    vector<vector<int>>& rects;
    mt19937 gen{random_device{}()};
};
```

```C [sol1-C]
typedef struct {
    int *arr;
    int **rects;
    int rectsSize;
} Solution;

Solution* solutionCreate(int** rects, int rectsSize, int* rectsColSize) {
    srand(time(NULL));
    Solution *obj = (Solution *)malloc(sizeof(Solution));
    obj->rects = rects;
    obj->rectsSize = rectsSize;
    obj->arr = (int *)malloc(sizeof(int) * (rectsSize + 1));
    memset(obj->arr, 0, sizeof(int) * (rectsSize + 1));
    for (int i = 0; i < rectsSize; i++) {
        obj->arr[i + 1] = obj->arr[i] + (rects[i][2] - rects[i][0] + 1) * \
                                        (rects[i][3] - rects[i][1] + 1);
    }
    return obj;
}

int* solutionPick(Solution* obj, int* retSize) {
    int k = rand() % obj->arr[obj->rectsSize];
    int left = 0, right = obj->rectsSize;
    int rectIndex = 0;
    while (left <= right) {
        int mid = (left + right) >> 1;
        if (obj->arr[mid] > k) {
            rectIndex = mid - 1;
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    k = k - obj->arr[rectIndex];
    int a = obj->rects[rectIndex][0], b = obj->rects[rectIndex][1];
    int y = obj->rects[rectIndex][3];
    int col = y - b + 1;
    int da = k / col;
    int db = k - col * da;
    int *res = (int *)malloc(sizeof(int) * 2);
    res[0] = a + da;
    res[1] = b + db;
    *retSize = 2;
    return res;
}

void solutionFree(Solution* obj) {
    free(obj->arr);
    free(obj);
}
```

```go [sol1-Golang]
type Solution struct {
    rects [][]int
    sum   []int
}

func Constructor(rects [][]int) Solution {
    sum := make([]int, len(rects)+1)
    for i, r := range rects {
        a, b, x, y := r[0], r[1], r[2], r[3]
        sum[i+1] = sum[i] + (x-a+1)*(y-b+1)
    }
    return Solution{rects, sum}
}

func (s *Solution) Pick() []int {
    k := rand.Intn(s.sum[len(s.sum)-1])
    rectIndex := sort.SearchInts(s.sum, k+1) - 1
    r := s.rects[rectIndex]
    a, b, y := r[0], r[1], r[3]
    da := (k - s.sum[rectIndex]) / (y - b + 1)
    db := (k - s.sum[rectIndex]) % (y - b + 1)
    return []int{a + da, b + db}
}
```

```JavaScript [sol1-JavaScript]
var Solution = function(rects) {
    this.arr = [0];
    this.rects = rects;
    for (const rect of rects) {
        const a = rect[0], b = rect[1], x = rect[2], y = rect[3];
        this.arr.push(this.arr[this.arr.length - 1] + (x - a + 1) * (y - b + 1));
    }
};

Solution.prototype.pick = function() {
    let k = Math.floor(Math.random() * this.arr[this.arr.length - 1]);
    const rectIndex = binarySearch(this.arr, k + 1) - 1;
    k -= this.arr[rectIndex];
    const rect = this.rects[rectIndex];
    const a = rect[0], b = rect[1], y = rect[3];
    const col = y - b + 1;
    const da = Math.floor(k / col);
    const db = k - col * da;
    return [a + da, b + db];
};

const binarySearch = (arr, target) => {
    let low = 0, high = arr.length - 1;
    while (low <= high) {
        const mid = Math.floor((high - low) / 2) + low;
        const num = arr[mid];
        if (num === target) {
            return mid;
        } else if (num > target) {
            high = mid - 1;
        } else {
            low = mid + 1;
        }
    }
    return low;
}
```

**复杂度分析**

- 时间复杂度：构造函数复杂度为 $O(n)$，$\textit{pick}$ 函数复杂度为 $O(\log n)$，其中 $n$ 为 $\textit{rects}$ 的长度。构造函数需要构造前缀和数组，$\textit{pick}$ 函数需要在前缀和数组内进行二分。

- 空间复杂度：构造函数复杂度为 $O(n)$，$\textit{pick}$ 函数复杂度为 $O(1)$，其中 $n$ 为 $\textit{rects}$ 的长度。构造函数需要构造前缀和数组，$\textit{pick}$ 函数只需要使用常数空间。