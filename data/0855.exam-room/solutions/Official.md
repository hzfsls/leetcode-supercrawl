## [855.考场就座 中文官方题解](https://leetcode.cn/problems/exam-room/solutions/100000/kao-chang-jiu-zuo-by-leetcode-solution-074y)
#### 方法一：延迟删除 + 有序集合 + 优先队列

假设有两个学生，他们的位置分别为 $s_1$ 和 $s_2$，我们用区间 $[s_1, s_2]$ 表示他们之间的空闲座位区间。如果固定某一个区间，那么座位选择该区间的中点 $s=s_1 + \lfloor \frac{s_2-s_1}{2} \rfloor$ 能够使新进入的学生与离他最近的人之间的距离达到最大化。

由题意可知，我们需要实时地维护这些区间的顺序关系，并且能实时地获取这些区间中最优区间（最优区间：能够使新进入的学生与离他最近的人之间的距离达到最大化），同时还要求实时地删除某个学生占用的座位以及修改对应的区间关系。现成的数据结构并不能很好地满足这些需求，我们尝试将删除区间这一操作延迟到获取最优区间时执行。

使用有序集合 $\textit{seats}$ 保存已经有学生的座位编号，优先队列 $\textit{pq}$ 保存座位区间（假设优先队列中的两个区间分别为 $[s_1, s_2]$ 和 $[s_3, s_4]$，那么如果 $\lfloor \frac{s_2 - s_1}{2} \rfloor \gt \lfloor \frac{s_4 - s_3}{2} \rfloor$ 或者 $\lfloor \frac{s_2 - s_1}{2} \rfloor = \lfloor \frac{s_4 - s_3}{2} \rfloor \space and \space s_1 \lt s_3$，那么区间 $[s_1, s_2]$ 比区间 $[s_3, s_4]$ 更优）。

+ 对于 $\text{seat}$ 函数：

    学生进入考场时，有三种情况：

    1. 考场没有一个学生，那么学生只能坐在座位 $0$；

        将座位 $0$ 插入有序集合 $\textit{seats}$，并且返回座位 $0$。

    2. 考场有超过两位学生，并且选择这些学生所在的座位组成的区间比直接坐在考场的最左或者最右的座位更优；

        首先判断优先队列中最优的区间是否有效（有效指当前区间的左右两个端点的座位有学生，中间的所有座位都没有学生），如果无效，删除该区间。设当前有效区间为 $[s_1, s_2]$，最左的座位跟最左的有学生的座位的距离为 $\textit{left}$，最右的座位跟最右的有学生的座位的距离为 $\textit{right}$，如果 $\lfloor \frac{s2 - s1}{2} \rfloor \gt \textit{left}$ 且 $\lfloor \frac{s2 - s1}{2} \rfloor \ge \textit{right}$，那么选择当前最优区间比直接坐在考场的最左或者最右的座位更优，学生坐下的座位为 $s=s_1 + \lfloor \frac{s_2-s_1}{2} \rfloor$，将当前区间从优先队列 $\textit{pq}$ 中移除，然后分别将新增加的两个区间 $[s_1, s]$ 和 $[s, s_2]$ 插入优先队列 $\textit{pq}$，将 $s$ 插入有序集合 $\textit{seats}$，返回座位 $s$。

    3. 考场少于两位学生，或者直接坐在考场的最左或者最右的座位比选择这些学生组成的区间更优。

        如果是最左的座位更优，那么将新增加的区间插入优先队列 $\textit{pq}$，最左的座位插入有序集合 $\textit{seats}$，并且返回最左的座位；最右的座位的做法类似。

+ 对于 $\text{leave}$ 函数：

    如果要删除的座位 $p$ 上的学生不是所有学生的最左或者最右的学生，那么删除该学生会产生新的区间，我们将该区间放入优先队列 $\textit{pq}$ 中，然后在有序集合 $\textit{seats}$ 中删除该学生；否则只需要在有序集合 $\textit{seats}$ 中删除该学生。对于删除座位后已经无效的区间，我们只需要在 $\text{seat}$ 函数中判断区间是否有效即可。

```C++ [sol1-C++]
struct Comp {
    bool operator()(const pair<int, int> &p1, const pair<int, int> &p2) {
        int d1 = p1.second - p1.first, d2 = p2.second - p2.first;
        return d1 / 2 < d2 / 2 || (d1 / 2 == d2 / 2 && p1.first > p2.first);
    }
};

class ExamRoom {
private:
    int n;
    set<int> seats;
    priority_queue<pair<int, int>, vector<pair<int, int>>, Comp> pq;

public:
    ExamRoom(int n) : n(n) {
        
    }

    int seat() {
        if (seats.empty()) {
            seats.insert(0);
            return 0;
        }
        int left = *seats.begin(), right = n - 1 - *seats.rbegin();
        while (seats.size() >= 2) {
            auto p = pq.top();
            if (seats.count(p.first) > 0 && seats.count(p.second) > 0 && 
                *next(seats.find(p.first)) == p.second) { // 不属于延迟删除的区间
                int d = p.second - p.first;
                if (d / 2 < right || d / 2 <= left) { // 最左或最右的座位更优
                    break;
                }
                pq.pop();
                pq.push({p.first, p.first + d / 2});
                pq.push({p.first + d / 2, p.second});
                seats.insert(p.first + d / 2);
                return p.first + d / 2;
            }
            pq.pop(); // leave 函数中延迟删除的区间在此时删除
        }
        if (right > left) { // 最右的位置更优
            pq.push({*seats.rbegin(), n - 1});
            seats.insert(n - 1);
            return n - 1;
        } else {
            pq.push({0, *seats.begin()});
            seats.insert(0);
            return 0;
        }
    }

    void leave(int p) {
        if (p != *seats.begin() && p != *seats.rbegin()) {
            auto it = seats.find(p);
            pq.push({*prev(it), *next(it)});
        }
        seats.erase(p);
    }
};
```

```Java [sol1-Java]
class ExamRoom {
    int n;
    TreeSet<Integer> seats;
    PriorityQueue<int[]> pq;

    public ExamRoom(int n) {
        this.n = n;
        this.seats = new TreeSet<Integer>();
        this.pq = new PriorityQueue<int[]>((a, b) -> {
            int d1 = a[1] - a[0], d2 = b[1] - b[0];
            return d1 / 2 < d2 / 2 || (d1 / 2 == d2 / 2 && a[0] > b[0]) ? 1 : -1;
        });
    }

    public int seat() {
        if (seats.isEmpty()) {
            seats.add(0);
            return 0;
        }
        int left = seats.first(), right = n - 1 - seats.last();
        while (seats.size() >= 2) {
            int[] p = pq.peek();
            if (seats.contains(p[0]) && seats.contains(p[1]) && seats.higher(p[0]) == p[1]) { // 不属于延迟删除的区间
                int d = p[1] - p[0];
                if (d / 2 < right || d / 2 <= left) { // 最左或最右的座位更优
                    break;
                }
                pq.poll();
                pq.offer(new int[]{p[0], p[0] + d / 2});
                pq.offer(new int[]{p[0] + d / 2, p[1]});
                seats.add(p[0] + d / 2);
                return p[0] + d / 2;
            }
            pq.poll(); // leave 函数中延迟删除的区间在此时删除
        }
        if (right > left) { // 最右的位置更优
            pq.offer(new int[]{seats.last(), n - 1});
            seats.add(n - 1);
            return n - 1;
        } else {
            pq.offer(new int[]{0, seats.first()});
            seats.add(0);
            return 0;
        }
    }

    public void leave(int p) {
        if (p != seats.first() && p != seats.last()) {
            int prev = seats.lower(p), next = seats.higher(p);
            pq.offer(new int[]{prev, next});
        }
        seats.remove(p);
    }
}
```

**复杂度分析**

+ 时间复杂度：

    + $\text{seat}$ 函数：均摊时间复杂度 $O(\log m)$，其中 $m$ 是调用 $\text{seat}$ 函数的次数。因为优先队列最多保存不超过 $2 \times m$ 个元素，所以一次 $\textit{seat}$ 函数平均只有不超过 $2$ 次的优先队列延迟删除操作，对优先队列和有序集合操作的时间复杂度都是 $O(\log m)$。

    + $\text{leave}$ 函数：$O(\log m)$。删除有序集合 $\textit{seats}$ 的一个元素和优先队列插入一个元素的时间复杂度都是 $O(\log m)$。

+ 空间复杂度：$O(m)$。有序集合 $\textit{seats}$ 和优先队列 $\textit{pq}$ 中最多保存不超过 $2 \times m$ 个元素。