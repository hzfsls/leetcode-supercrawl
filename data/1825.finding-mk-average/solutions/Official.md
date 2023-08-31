## [1825.求出 MK 平均值 中文官方题解](https://leetcode.cn/problems/finding-mk-average/solutions/100000/qiu-chu-mk-ping-jun-zhi-by-leetcode-solu-sos6)
#### 方法一：三个有序集合

我们使用三个有序集合 $s_1$，$s_2$ 和 $s_3$ 分别保存最小的 $k$ 个元素、中间的 $m-2k$ 个元素和最大的 $k$ 个元素；使用 $\textit{sum}_2$ 保存 $s_2$ 中所有元素之和；使用队列 $q$ 保存最后的 $m$ 个元素。

+ $\text{addElement}$ 函数：

    我们先将新增加的元素 $\textit{num}$ 放入队列 $q$ 中，然后对 $q$ 的元素数目进行判断：

    + $q$ 的元素数目小于等于 $m$：

        将新增加的元素 $\textit{num}$ 插入有序集合 $s_2$ 中，并且更新 $\textit{sum}_2 = \textit{sum}_2 + \textit{num}$。如果 $q$ 的元素数目等于 $m$，那么我们需要分别将 $s_2$ 最小的 $k$ 个元素和最大的 $k$ 个元素移动到 $s_1$ 和 $s_3$ 中，同时相应地更新 $\textit{sum}_2$。

    + $q$ 的元素数目等于 $m + 1$：

        如果 $\textit{num}$ 小于 $s_1$ 的最大元素，那么我们将它插入 $s_1$中，然后将 $s_1$ 的最大元素移动到 $s_2$ 中，同时相应地更新 $\textit{sum}_2$；如果 $\textit{num}$ 大于 $s_3$ 的最小元素，那么我们将它插入 $s_3$中，然后将 $s_3$ 的最小元素移动到 $s_2$ 中，同时相应地更新 $\textit{sum}_2$；否则我们将 $\textit{num}$ 插入 $s_2$ 中，并且更新 $\textit{sum}_2 = \textit{sum}_2 + \textit{num}$。**以上操作之后，$s_2$ 的元素数目额外多出 $1$ 个，因此删除操作发生在 $s_1$ 或 $s_3$ 时，需要从 $s_2$ 移动元素以保持元素数目的平衡。**

        我们从队列 $q$ 的队头取出首元素 $x$。对于待删除的元素 $x$：如果 $x$ 在 $s_2$中，我们将它从 $s_2$ 中删除；如果 $x$ 在 $s_1$中，我们将它从 $s_1$ 中删除，然后将 $s_2$ 中最小的元素移动到 $s_1$ 中；如果 $x$ 在 $s_3$中，我们将它从 $s_3$ 中删除，然后将 $s_2$ 中最大的元素移动到 $s_3$ 中。

+ $\text{calculateMKAverage}$ 函数：

    如果队列 $q$ 的元素数目小于 $m$，直接返回 $-1$；否则返回 $\big \lfloor \dfrac{\textit{sum}_2}{m-2k} \big \rfloor$

```C++ [sol1-C++]
class MKAverage {
private:
    int m, k;
    queue<int> q;
    multiset<int> s1, s2, s3;
    long long sum2;
public:
    MKAverage(int m, int k) : m(m), k(k) {
        sum2 = 0;
    }

    void addElement(int num) {
        q.push(num);
        if (q.size() <= m) {
            s2.insert(num);
            sum2 += num;
            if (q.size() == m) {
                while (s1.size() < k) {
                    s1.insert(*s2.begin());
                    sum2 -= *s2.begin();
                    s2.erase(s2.begin());
                }
                while (s3.size() < k) {
                    s3.insert(*s2.rbegin());
                    sum2 -= *s2.rbegin();
                    s2.erase(prev(s2.end()));
                }
            }
            return;
        }

        if (num < *s1.rbegin()) {
            s1.insert(num);
            s2.insert(*s1.rbegin());
            sum2 += *s1.rbegin();
            s1.erase(prev(s1.end()));
        } else if (num > *s3.begin()) {
            s3.insert(num);
            s2.insert(*s3.begin());
            sum2 += *s3.begin();
            s3.erase(s3.begin());
        } else {
            s2.insert(num);
            sum2 += num;
        }

        int x = q.front();
        q.pop();
        if (s1.count(x) > 0) {
            s1.erase(s1.find(x));
            s1.insert(*s2.begin());
            sum2 -= *s2.begin();
            s2.erase(s2.begin());
        } else if (s3.count(x) > 0) {
            s3.erase(s3.find(x));
            s3.insert(*s2.rbegin());
            sum2 -= *s2.rbegin();
            s2.erase(prev(s2.end()));
        } else {
            s2.erase(s2.find(x));
            sum2 -= x;
        }
    }

    int calculateMKAverage() {
        if (q.size() < m) {
            return -1;
        }
        return sum2 / (m - 2 * k);
    }
};
```

```Java [sol1-Java]
class MKAverage {
    private int m, k;
    private Queue<Integer> q;
    private TreeMap<Integer, Integer> s1;
    private TreeMap<Integer, Integer> s2;
    private TreeMap<Integer, Integer> s3;
    private int size1, size2, size3;
    private long sum2;

    public MKAverage(int m, int k) {
        this.m = m;
        this.k = k;
        this.q = new ArrayDeque<Integer>();
        this.s1 = new TreeMap<Integer, Integer>();
        this.s2 = new TreeMap<Integer, Integer>();
        this.s3 = new TreeMap<Integer, Integer>();
        this.size1 = 0;
        this.size2 = 0;
        this.size3 = 0;
        this.sum2 = 0;
    }

    public void addElement(int num) {
        q.offer(num);
        if (q.size() <= m) {
            s2.put(num, s2.getOrDefault(num, 0) + 1);
            size2++;
            sum2 += num;
            if (q.size() == m) {
                while (size1 < k) {
                    int firstNum = s2.firstKey();
                    s1.put(firstNum, s1.getOrDefault(firstNum, 0) + 1);
                    size1++;
                    sum2 -= firstNum;
                    s2.put(firstNum, s2.get(firstNum) - 1);
                    if (s2.get(firstNum) == 0) {
                        s2.remove(firstNum);
                    }
                    size2--;
                }
                while (size3 < k) {
                    int lastNum = s2.lastKey();
                    s3.put(lastNum, s3.getOrDefault(lastNum, 0) + 1);
                    size3++;
                    sum2 -= lastNum;
                    s2.put(lastNum, s2.get(lastNum) - 1);
                    if (s2.get(lastNum) == 0) {
                        s2.remove(lastNum);
                    }
                    size2--;
                }
            }
            return;
        }

        if (num < s1.lastKey()) {
            s1.put(num, s1.getOrDefault(num, 0) + 1);
            int lastNum = s1.lastKey();
            s2.put(lastNum, s2.getOrDefault(lastNum, 0) + 1);
            size2++;
            sum2 += lastNum;
            s1.put(lastNum, s1.get(lastNum) - 1);
            if (s1.get(lastNum) == 0) {
                s1.remove(lastNum);
            }
        } else if (num > s3.firstKey()) {
            s3.put(num, s3.getOrDefault(num, 0) + 1);
            int firstNum = s3.firstKey();
            s2.put(firstNum, s2.getOrDefault(firstNum, 0) + 1);
            size2++;
            sum2 += firstNum;
            s3.put(firstNum, s3.get(firstNum) - 1);
            if (s3.get(firstNum) == 0) {
                s3.remove(firstNum);
            }
        } else {
            s2.put(num, s2.getOrDefault(num, 0) + 1);
            size2++;
            sum2 += num;
        }

        int x = q.poll();
        if (s1.containsKey(x)) {
            s1.put(x, s1.get(x) - 1);
            if (s1.get(x) == 0) {
                s1.remove(x);
            }
            int firstNum = s2.firstKey();
            s1.put(firstNum, s1.getOrDefault(firstNum, 0) + 1);
            sum2 -= firstNum;
            s2.put(firstNum, s2.get(firstNum) - 1);
            if (s2.get(firstNum) == 0) {
                s2.remove(firstNum);
            }
            size2--;
        } else if (s3.containsKey(x)) {
            s3.put(x, s3.get(x) - 1);
            if (s3.get(x) == 0) {
                s3.remove(x);
            }
            int lastNum = s2.lastKey();
            s3.put(lastNum, s3.getOrDefault(lastNum, 0) + 1);
            sum2 -= lastNum;
            s2.put(lastNum, s2.get(lastNum) - 1);
            if (s2.get(lastNum) == 0) {
                s2.remove(lastNum);
            }
            size2--;
        } else {
            s2.put(x, s2.get(x) - 1);
            if (s2.get(x) == 0) {
                s2.remove(x);
            }
            size2--;
            sum2 -= x;
        }
    }

    public int calculateMKAverage() {
        if (q.size() < m) {
            return -1;
        }
        return (int) (sum2 / (m - 2 * k));
    }
}
```

**复杂度分析**

+ 时间复杂度：

    + $\text{addElement}$ 函数：$O(\log m)$，其中 $m$ 是计算需要的元素数目。调用一次 $\text{addElement}$ 函数平均只需要有限次有序集合的查找、插入和删除操作。

    + $\text{calculateMKAverage}$ 函数：$O(1)$。

+ 空间复杂度：$O(m)$。