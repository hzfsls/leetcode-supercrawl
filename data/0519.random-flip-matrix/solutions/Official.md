## [519.随机翻转矩阵 中文官方题解](https://leetcode.cn/problems/random-flip-matrix/solutions/100000/sui-ji-fan-zhuan-ju-zhen-by-leetcode-sol-pfmr)
#### 题目分析

由于题目中给出的 $m$ 和 $n$ 最大能达到 $10000$，因此我们在维护这个矩阵时，要注意以下两点：
- 我们不能使用 $O(m \times n)$ 的空间复杂度来维护这个矩阵，这样会超出空间限制。我们应当找到空间复杂度较低的数据结构来表示这个矩阵；
- 我们需要尽量少的调用语言内置的 $\texttt{random}()$ 函数来产生随机数，保证每次 $\texttt{flip}()$ 操作的时间复杂度尽可能低。

#### 方法一：数组映射

**解题思路**

我们可以考虑将矩阵转换为一个长度为 $m \times n$ 的一维数组 $\textit{map}$，对于矩阵中的位置 $(i, j)$，它对应了 $\textit{map}$ 中的元素 $\textit{map}[i \times n + j]$，这样就保证了矩阵和 $map$ 的元素映射。在经过 $m \times n-k$ 次翻转 $\texttt{flip}$ 后，我们会修改 $\textit{map}$ 与矩阵的映射，使得当前矩阵中有 $m \times n-k$ 个 $1$ 和 $k$ 个 $0$。
此时我们可以利用数组中元素的交换，使得 $\textit{map}[0 \cdots k - 1]$ 映射到矩阵中的 $0$，而 $\textit{map}[k \cdots m \times n - 1]$ 映射到矩阵中的 $1$。这样的好处是，当我们进行下一次翻转操作时，我们只需要在 $[0, k-1)$ 这个区间生成随机数 $x$，并将 $\textit{map}[x]$ 映射到的矩阵的位置进行翻转即可。

在将 $\textit{map}[x]$ 进行翻转后，此时矩阵中有 $k - 1$ 个 $0$，所以我们需要保证 $\textit{map}[0 .. k - 2]$ 都映射到矩阵中的 $0$。由于此时 $\textit{map}[x]$ 映射到了矩阵中的 $1$，因此我们可以将 $\textit{map}[x]$ 与 $\textit{map}[k - 1]$ 的值进行交换，即将这个新翻转的 $1$ 作为 $\textit{map}[k - 1]$ 的映射，而把原本 $\textit{map}[k - 1]$ 映射到的 $0$ 交给 $x$。这样我们就保证了在每一次翻转操作后，$\textit{map}$ 中的前 $k$ 个元素恰好映射到矩阵中的所有 $k$ 个 $0$。

那么我们如何维护这个一维数组 $\textit{map}$ 呢？我们可以发现，$\textit{map}$ 中的大部分映射关系是不会改变的，即矩阵中的 $(i, j)$ 映射到 $A[i \times n + j]$，因此我们可以使用一个 $\texttt{HashMap}$ 存储那些 $\textit{map}$ 中那些被修改了的映射。对于一个数 $x$，如果 $x$ 不是 $\texttt{HashMap}$ 中的一个键，那么它直接映射到最开始的 $(x/n, x \%n)$；如果 $x$ 是 $\texttt{HashMap}$ 中的一个键，那么它映射到其在 $\texttt{HashMap}$ 中对应的值。实际运行中 $\texttt{HashMap}$ 的大小仅和翻转次数成正比，因为每一次翻转操作我们会交换 $\textit{map}$ 中两个元素的映射，即最多有两个元素的映射关系被修改。

**代码**

```Java [sol1-Java]
class Solution {
    Map<Integer, Integer> map = new HashMap<>();
    int m, n, total;
    Random rand = new Random();

    public Solution(int m, int n) {
        this.m = m;
        this.n = n;
        this.total = m * n;
    }
    
    public int[] flip() {
        int x = rand.nextInt(total);
        total--;
        // 查找位置 x 对应的映射
        int idx = map.getOrDefault(x, x);
        // 将位置 x 对应的映射设置为位置 total 对应的映射
        map.put(x, map.getOrDefault(total, total));
        return new int[]{idx / n, idx % n};
    }
    
    public void reset() {
        total = m * n;
        map.clear();
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    Solution(int m, int n) {
        this->m = m;
        this->n = n;
        this->total = m * n;
        srand(time(nullptr));
    }
    
    vector<int> flip() {
        int x = rand() % total;
        vector<int> ans;
        total--;   
        // 查找位置 x 对应的映射
        if (map.count(x)) {
            ans = {map[x] / n, map[x] % n};
        } else {
            ans = {x / n, x % n};
        }
        // 将位置 x 对应的映射设置为位置 total 对应的映射
        if (map.count(total)) {
            map[x] = map[total];
        } else {
            map[x] = total;
        }
        return ans;
    }
    
    void reset() {
        total = m * n;
        map.clear();
    }
private:
    int m;
    int n;
    int total;
    unordered_map<int, int> map;
};
```

```C# [sol1-C#]
public class Solution {
    Dictionary<int, int> dictionary = new Dictionary<int, int>();
    int m, n, total;
    Random rand = new Random();

    public Solution(int m, int n) {
        this.m = m;
        this.n = n;
        this.total = m * n;
    }
    
    public int[] Flip() {
        int x = rand.Next(total);
        total--;
        // 查找位置 x 对应的映射
        int idx = dictionary.ContainsKey(x) ? dictionary[x] : x;
        // 将位置 x 对应的映射设置为位置 total 对应的映射
        int value = dictionary.ContainsKey(total) ? dictionary[total] : total;
        if (dictionary.ContainsKey(x)) {
            dictionary[x] = value;
        } else {
            dictionary.Add(x, value);
        }
        return new int[]{idx / n, idx % n};
    }
    
    public void Reset() {
        total = m * n;
        dictionary.Clear();
    }
}
```

```Python [sol1-Python3]
class Solution:

    def __init__(self, m: int, n: int):
        self.m = m
        self.n = n
        self.total = m * n
        self.map = {}

    def flip(self) -> List[int]:
        x = random.randint(0, self.total - 1)
        self.total -= 1
        # 查找位置 x 对应的映射
        idx = self.map.get(x, x)
        # 将位置 x 对应的映射设置为位置 total 对应的映射
        self.map[x] = self.map.get(self.total, self.total)
        return [idx // self.n, idx % self.n]
        
    def reset(self) -> None:
        self.total = self.m * self.n
        self.map.clear()
```

```JavaScript [sol1-JavaScript]
var Solution = function(m, n) {
    this.m = m;
    this.n = n;
    this.total = m * n;
    this.map = new Map();
};

Solution.prototype.flip = function() {
    const x = Math.floor(Math.random() * this.total);
    this.total--;
    // 查找位置 x 对应的映射
    const idx = this.map.get(x) || x;
    // 将位置 x 对应的映射设置为位置 total 对应的映射
    this.map.set(x, this.map.get(this.total) || this.total);
    return [Math.floor(idx / this.n), idx % this.n];
};

Solution.prototype.reset = function() {
    this.total = this.m * this.n;
    this.map.clear();
};
```

```go [sol1-Golang]
type Solution struct {
    m, n, total int
    mp          map[int]int
}

func Constructor(m, n int) Solution {
    return Solution{m, n, m * n, map[int]int{}}
}

func (s *Solution) Flip() (ans []int) {
    x := rand.Intn(s.total)
    s.total--
    if y, ok := s.mp[x]; ok { // 查找位置 x 对应的映射
        ans = []int{y / s.n, y % s.n}
    } else {
        ans = []int{x / s.n, x % s.n}
    }
    if y, ok := s.mp[s.total]; ok { // 将位置 x 对应的映射设置为位置 total 对应的映射
        s.mp[x] = y
    } else {
        s.mp[x] = s.total
    }
    return
}

func (s *Solution) Reset() {
    s.total = s.m * s.n
    s.mp = map[int]int{}
}
```

**复杂度分析**

- 时间复杂度：$\texttt{flip}()$ 操作的时间复杂度为 $O(1)$，$\texttt{reset}()$ 操作的时间复杂度为 $O(F)$，其中 $F$ 是在上一次 $\texttt{reset}()$ 之后执行 $\texttt{flip}()$ 的次数。

- 空间复杂度：$O(F)$，其中 $F$ 代表执行函数 $\texttt{flip}()$ 的次数。

#### 方法二：分块

**解题思路**

我们可以考虑另一种方法来维护这个一维数组 $\textit{map}$。假设我们把这 $m \times n$  个位置放到 $k$ 个桶中，第一个桶对应 $map[0 \cdots a_{1}]$，第二个桶对应 $\textit{map}[a_{1} + 1 \cdots a_{2}]$，以此类推。我们用 $\textit{cnt}[i]$ 表示第 $i$ 个桶中还剩余的 $0$ 的个数，并给每个桶分配一个集合 $\texttt{HashSet}$ 存放桶中哪些位置对应的是 $1$（即被翻转过的位置）。

假设当前矩阵中还有 $\textit{total}$ 个 $0$，我们从 $[1, \textit{total}]$ 中随机出一个整数 $x$，并遍历所有的桶，根据所有的 $\textit{cnt}[i]$ 可以找出第 $x$ 个 $0$ 属于哪个桶。假设其属于第 $i$ 个桶，那么 $x$ 应该满足 $\textit{sum}[i - 1] < x <= \textit{sum}[i]$，其中 $\textit{sum}[i]$ 表示前 $i$ 个桶的 $\textit{cnt}[i]$ 之和，即前 $i$ 个桶中 $0$ 的个数。随后我们令 $y = x - \textit{sum}[i - 1]$，即我们需要找到第 $i$ 个桶中的第 $y$ 个 $0$。我们可以依次遍历 $[d \times i + 1 \cdots d \times (i+1)]$ 中的数，根据第 $i$ 个桶对应的集合，找出第 $y$ 个 $0$ 的位置。最后我们将这个 $0$ 进行翻转。

由于 $\textit{map}$ 被分成了 $k$ 个桶，因此每个桶的平均长度为 $\lfloor \frac{m \times n}{k} \rfloor$。在上述的方法中，遍历所有的桶的时间复杂度为 $O(k)$，而遍历第 $i$ 个桶的时间复杂度为 $O(\frac{m \times n}{k})$，因此总时间复杂度为 $O(k +  \frac{m \times n}{k})$。根据均值不等式，可以得知在 $k = \sqrt{m \times n}$，总的时间复杂度最小。
​
**代码**

```Java [sol2-Java]
class Solution {
    int m, n;
    int total, bucketSize;
    List<Set<Integer>> buckets = new ArrayList<>();
    Random rand = new Random();

    public Solution(int m, int n) {
        this.m = m;
        this.n = n;
        this.total = m * n;
        this.bucketSize = (int) Math.sqrt(total);
        for (int i = 0; i < total; i += bucketSize) {
            buckets.add(new HashSet<Integer>());
        }
    }
    
    public int[] flip() {
        int x = rand.nextInt(total);
        int sumZero = 0;
        int curr = 0;
        total--;

        for (Set<Integer> bucket : buckets) {
            if (sumZero + bucketSize - bucket.size() > x) {
                for (int i = 0; i < bucketSize; ++i) {
                    if (!bucket.contains(curr + i)) {
                        if (sumZero == x) {
                            bucket.add(curr + i);
                            return new int[]{(curr + i) / n, (curr + i) % n};
                        } 
                        sumZero++;
                    }
                }
            }
            curr += bucketSize;
            sumZero += bucketSize - bucket.size();
        }

        return null;
    }
    
    public void reset() {
        total = m * n;
        for (Set<Integer> bucket : buckets) {
            bucket.clear();
        }
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    Solution(int m, int n) {
        this->m = m;
        this->n = n;
        total = m * n;
        bucketSize = sqrt(m * n);
        for (int i = 0; i < total; i += bucketSize) {
            buckets.push_back({});
        }
        srand(time(nullptr));
    }

    vector<int> flip() {
        int x = rand() % total;
        int sumZero = 0;
        int curr = 0;
        total--;

        for (auto & bucket : buckets) {
            if (sumZero + bucketSize - bucket.size() > x) {
                for (int i = 0; i < bucketSize; ++i) {
                    if (!bucket.count(curr + i)) {
                        if (sumZero == x) {
                            bucket.emplace(curr + i);
                            return {(curr + i) / n, (curr + i) % n};
                        } 
                        sumZero++;
                    }
                }
            }
            curr += bucketSize;
            sumZero += bucketSize - bucket.size();
        }
        
        return {};
    }

    void reset() {
        for (auto & bucket : buckets) {
            bucket.clear();
        }
        total = m * n;
    }
private:
    int m;
    int n;
    int bucketSize;
    int total;
    vector<unordered_set<int>> buckets;
};
```

```C# [sol2-C#]
public class Solution {
    int m, n;
    int total, bucketSize;
    IList<ISet<int>> buckets = new List<ISet<int>>();
    Random rand = new Random();

    public Solution(int m, int n) {
        this.m = m;
        this.n = n;
        this.total = m * n;
        this.bucketSize = (int) Math.Sqrt(total);
        for (int i = 0; i < total; i += bucketSize) {
            buckets.Add(new HashSet<int>());
        }
    }
    
    public int[] Flip() {
        int x = rand.Next(total);
        int sumZero = 0;
        int curr = 0;
        total--;

        foreach (ISet<int> bucket in buckets) {
            if (sumZero + bucketSize - bucket.Count > x) {
                for (int i = 0; i < bucketSize; ++i) {
                    if (!bucket.Contains(curr + i)) {
                        if (sumZero == x) {
                            bucket.Add(curr + i);
                            return new int[]{(curr + i) / n, (curr + i) % n};
                        } 
                        sumZero++;
                    }
                }
            }
            curr += bucketSize;
            sumZero += bucketSize - bucket.Count;
        }

        return null;
    }
    
    public void Reset() {
        total = m * n;
        foreach (ISet<int> bucket in buckets) {
            bucket.Clear();
        }
    }
}
```

```Python [sol2-Python3]
class Solution:
    def __init__(self, m: int, n: int):
        self.m, self.n = m, n
        self.total = m * n
        self.bucketSize = math.floor(math.sqrt(m * n))
        self.buckets = [set() for _ in range(0, self.total, self.bucketSize)]

    def flip(self) -> List[int]:
        x = random.randint(0, self.total - 1)
        self.total -= 1
        sumZero = 0
        curr = 0

        for i in range(len(self.buckets)):
            if sumZero + self.bucketSize - len(self.buckets[i]) > x:
                for j in range(self.bucketSize):
                    if (curr + j) not in self.buckets[i]:
                        if sumZero == x:
                            self.buckets[i].add(curr + j)
                            return [(curr + j) // self.n, (curr + j) % self.n]
                        sumZero += 1
            curr += self.bucketSize
            sumZero += self.bucketSize - len(self.buckets[i])
        return []
        
    def reset(self) -> None:
        self.total = self.m * self.n
        for i in range(len(self.buckets)):
            self.buckets[i].clear()
```

```JavaScript [sol2-JavaScript]
var Solution = function(m, n) {
    this.m = m;
    this.n = n;
    this.total = m * n;
    this.bucketSize = Math.floor(Math.sqrt(this.total));
    this.buckets = [];
    for (let i = 0; i < this.total; i += this.bucketSize) {
        this.buckets.push(new Set());
    }
};

Solution.prototype.flip = function() {
    const x = Math.floor(Math.random() * this.total);
    let sumZero = 0;
    let curr = 0;
    this.total--;

    for (const bucket of this.buckets) {
        if (sumZero + this.bucketSize - bucket.size > x) {
            for (let i = 0; i < this.bucketSize; ++i) {
                if (!bucket.has(curr + i)) {
                    if (sumZero === x) {
                        bucket.add(curr + i);
                        return [Math.floor((curr + i) / this.n), (curr + i) % this.n];
                    } 
                    sumZero++;
                }
            }
        }
        curr += this.bucketSize;
        sumZero += this.bucketSize - bucket.size;
    }
    return undefined;
};

Solution.prototype.reset = function() {
    this.total = this.m * this.n;
    for (const bucket of this.buckets) {
        bucket.clear();
    }
};
```

```go [sol2-Golang]
type Solution struct {
    m, n, total, bucketSize int
    buckets                 []map[int]bool
}

func Constructor(m, n int) Solution {
    total := m * n
    bucketSize := int(math.Sqrt(float64(total)))
    buckets := make([]map[int]bool, (total+bucketSize-1)/bucketSize)
    for i := range buckets {
        buckets[i] = map[int]bool{}
    }
    return Solution{m, n, total, bucketSize, buckets}
}

func (s *Solution) Flip() []int {
    x := rand.Intn(s.total)
    s.total--
    sumZero, curr := 0, 0
    for _, bucket := range s.buckets {
        if sumZero+s.bucketSize-len(bucket) > x {
            for i := 0; i < s.bucketSize; i++ {
                if !bucket[curr+i] {
                    if sumZero == x {
                        bucket[curr+i] = true
                        return []int{(curr + i) / s.n, (curr + i) % s.n}
                    }
                    sumZero++
                }
            }
        }
        curr += s.bucketSize
        sumZero += s.bucketSize - len(bucket)
    }
    return nil
}

func (s *Solution) Reset() {
    s.total = s.m * s.n
    for i := range s.buckets {
        s.buckets[i] = map[int]bool{}
    }
}
```

**复杂度分析**

- 时间复杂度：$\texttt{flip}()$ 操作的时间复杂度为 $O(\sqrt{m \times n})$，其中 $m$ 和 $n$ 分别为矩阵的行数和列数；$\texttt{reset}()$ 操作的时间复杂度为 $O(F)$，其中 $F$ 是在上一次 $\texttt{reset}()$ 之后执行 $\texttt{flip}()$ 的次数。

- 空间复杂度：$O(\sqrt{m \times n} + F)$，其中 $m$ 和 $n$ 分别为矩阵的行数和列数，$F$ 是执行 $\texttt{flip}()$ 的次数。