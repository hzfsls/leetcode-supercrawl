#### 方法一：堆

**思路**

题目要求我们最优化「速度和」和「效率最小值」的乘积。变化的量有两个，一个是「速度」，一个是「效率」，这看起来有些棘手。我们不妨采用「动一个，定一个」的策略——即我们可以枚举效率的最小值 $e_{\min}$，在所有效率大于 $e_{\min}$ 的工程师中选取不超过 $k - 1$ 个，让他们的速度和最大。

**思考：为什么是 $k - 1$ 个而不是 $k$ 个？** 因为最小值 $e_{\min}$ 代表的工程师是必选，加起来一共 $k$ 个，所以剩下只要选 $k - 1$ 个。 

**思考：如何满足速度和最大？** 因为 `speed[i] > 0`，所以只需要选效率大于 $e_{\min}$ 中速度最大的 $k - 1$ 个，如果效率大于 $e_{\min}$ 的元素小于 $k - 1$，就全取。

具体地，我们可以对工程师先按照「效率」从高到低的规则排序，然后从前往后枚举这个序列中的元素作为 $e_{\min}$，这样可以保证前面的元素的效率都比当前这个工程师高，然后维护一个以「速度」为关键字的小根堆，存放前面已经枚举过的元素中速度前 $k - 1$ 大的，动态维护这个堆的速度和，一轮枚举后，我们可以得到乘积最大值。

**思考：为什么是小根堆？** 因为我们要动态维护前 $k - 1$ 大的元素，当堆内的元素超过 $k - 1$ 的时候，我们可以从堆顶 `pop` 掉比较小的元素，保证最大的 $k - 1$ 个元素还在堆中。

代码实现如下。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    using LL = long long;

    struct Staff {
        int s, e;
        bool operator < (const Staff& rhs) const {
            return s > rhs.s;
        }
    };

    int maxPerformance(int n, vector<int>& speed, vector<int>& efficiency, int k) {
        vector<Staff> v;
        priority_queue<Staff> q;
        for (int i = 0; i < n; ++i) {
            v.push_back({speed[i], efficiency[i]});
        }
        sort(v.begin(), v.end(), [] (const Staff& u, const Staff& v) { return u.e > v.e; });
        LL ans = 0, sum = 0;
        for (int i = 0; i < n; ++i) {
            LL minE = v[i].e;
            LL sumS = sum + v[i].s;
            ans = max(ans, sumS * minE);
            q.push(v[i]); 
            sum += v[i].s;
            if (q.size() == k) {
                sum -= q.top().s;
                q.pop();
            }
        }
        return ans % (int(1E9) + 7);
    }
};
```

```Java [sol1-Java]
class Solution {
    class Staff {
        int s, e;

        public Staff(int s, int e) {
            this.s = s;
            this.e = e;
        }
    }

    public int maxPerformance(int n, int[] speed, int[] efficiency, int k) {
        final int MODULO = 1000000007;
        List<Staff> list = new ArrayList<Staff>();
        PriorityQueue<Staff> queue = new PriorityQueue<Staff>(new Comparator<Staff>() {
            public int compare(Staff staff1, Staff staff2) {
                return staff1.s - staff2.s;
            }
        });
        for (int i = 0; i < n; ++i) {
            list.add(new Staff(speed[i], efficiency[i]));
        }
        Collections.sort(list, new Comparator<Staff>() {
            public int compare(Staff staff1, Staff staff2) {
                return staff2.e - staff1.e;
            }
        });
        long ans = 0, sum = 0;
        for (int i = 0; i < n; ++i) {
            Staff staff = list.get(i);
            long minE = staff.e;
            long sumS = sum + staff.s;
            ans = Math.max(ans, sumS * minE);
            queue.offer(staff); 
            sum += staff.s;
            if (queue.size() == k) {
                sum -= queue.poll().s;
            }
        }
        return (int) (ans % MODULO);
    }
}
```

```Python [sol1-Python3]
class Solution:
    class Staff:
        def __init__(self, s, e):
            self.s = s
            self.e = e
        
        def __lt__(self, that):
            return self.s < that.s
        
    def maxPerformance(self, n: int, speed: List[int], efficiency: List[int], k: int) -> int:
        v = list()
        for i in range(n):
            v.append(Solution.Staff(speed[i], efficiency[i]))
        v.sort(key=lambda x: -x.e)

        q = list()
        ans, total = 0, 0
        for i in range(n):
            minE, totalS = v[i].e, total + v[i].s
            ans = max(ans, minE * totalS)
            heapq.heappush(q, v[i])
            total += v[i].s
            if len(q) == k:
                item = heapq.heappop(q)
                total -= item.s
        return ans % (10**9 + 7)
```

**复杂度分析**

- 时间复杂度：排序的时间代价为 $O(n \log n)$，后面的操作中每个元素进出堆的次数最多一次，所以总的时间代价是 $O(n \log n)$。故渐进时间复杂度为 $O(n \log n)$。

- 空间复杂度：这里用了堆和一个辅助数组存放工程师信息，故渐进空间复杂度为 $O(n)$。