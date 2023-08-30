#### 方法一：线性表暴力

使用字典保存用户，按照用户名使用线性表存储其相应的所有推文，查询时遍历该用户的所有推文判断是否在要求的时间区间内。

```python []
class TweetCounts:

    def __init__(self):
        self.user = collections.defaultdict(list)

    def recordTweet(self, tweetName: str, time: int) -> None:
        self.user[tweetName].append(time)

    def getTweetCountsPerFrequency(self, freq: str, tweetName: str, startTime: int, endTime: int) -> List[int]:
        endTime += 1
        if freq == 'minute':
            length = 60
        elif freq == 'hour':
            length = 60 * 60
        else:
            length = 60 * 60 * 24
        ans = [0] * ((endTime - startTime - 1) // length + 1)
        for t in self.user[tweetName]:
            if endTime > t >= startTime:
                ans[(t - startTime) // length] += 1
        return ans
```

```C++ []
class TweetCounts {
    map<string, vector<int>> user;
public:
    TweetCounts() {
    }
    
    void recordTweet(string tweetName, int time) {
        user[tweetName].push_back(time);
    }
    
    vector<int> getTweetCountsPerFrequency(string freq, string tweetName, int startTime, int endTime) {
        endTime += 1;
        int length = 0;
        if (freq == "minute")
            length = 60;
        else if (freq == "hour")
            length = 60 * 60;
        else
            length = 60 * 60 * 24;
        vector<int> ans((endTime - startTime - 1) / length + 1);
        for (int time : user[tweetName])
            if (time >= startTime && time < endTime)
                ++ans[(time - startTime) / length];
        return ans;
    }
};
```

##### 复杂度分析：

  记插入操作的次数为 $n$，查询操作的次数为 $q$，查询的时间范围为 $t$。

  * 时间复杂度：$O(q(t+n))$ （python），或者 $O(q(t+n)+nlogn)$ （C++）
    * 共有 $n$ 次插入。每次插入需要查询一次用户 ID，python 中的 dict 使用哈希表实现，插入的时间复杂度为 $O(1)$，C++ 中的 map 使用红黑树实现，插入的时间复杂度为 $O(logn)$。
    * 共有 $q$ 次查询。每次查询需要进行一次 $O(n)$ 的遍历，时间复杂度为 $O(nq)$。每次查询还需要建立大小为 $O(t)$ 的数组，时间复杂度为 $O(tq)$。
    * 综合起来，python 的时间复杂度为 $O(q(t+n))$，C++ 的时间复杂度为 $O(q(t+n)+nlogn)$。
  * 空间复杂度：$O(n+t)$
    * 最多需要存储 $n$ 个用户以及 $n$ 条推文时间，空间复杂度为 $O(n)$。
    * 查询时需要开辟 $O(t)$ 的数组，空间复杂度为 $O(t)$。
    * 综合起来，空间复杂度为 $O(n+t)$。

#### 方法二：平衡二叉树

可以将每个用户的推文时间存储方式换成更有效的平衡二叉树。与暴力法所使用的线性表相比，平衡二叉树保证其中的元素使用二叉树有序排列，其时间复杂度与线性表的区别为：

  * 对于插入操作，线性表的时间复杂度为 $O(1)$，平衡二叉树的时间复杂度为 $O(logn)$。
  * 对于查询操作，线性表的时间复杂度为 $O(n)$，平衡二叉树的时间复杂度为 $O(logn)$。
    使用平衡二叉树，在查询时只要先在对应用户的所有推文中查询时间范围的上下界，然后在上下界范围内遍历推文发布时间即可。

```C++ []
class TweetCounts {
    map<string, set<int>> user;
public:
    TweetCounts() {
    }
    
    void recordTweet(string tweetName, int time) {
        user[tweetName].insert(time);
    }
    
    vector<int> getTweetCountsPerFrequency(string freq, string tweetName, int startTime, int endTime) {
        int length = 0;
        if (freq == "minute")
            length = 60;
        else if (freq == "hour")
            length = 60 * 60;
        else
            length = 60 * 60 * 24;
        vector<int> ans((endTime - startTime) / length + 1);
        auto begin = user[tweetName].lower_bound(startTime);
        auto end = user[tweetName].upper_bound(endTime);
        for (; begin != end; ++begin) {
            ++ans[(*begin - startTime) / length];
        }
        return ans;
    }
};
```

##### 复杂度分析：

  记插入操作的次数为 $n$，查询操作的次数为 $q$，查询的时间范围为 $t$。

  * 时间复杂度：$O(q(t+logn)+nlogn)$
    * 共有 $n$ 次插入。每次插入的时间复杂度为 $O(logn)$。总的插入时间复杂度为 $O(nlogn)$。
    * 共有 $q$ 次查询。每次查询需要对上下界进行一次 $O(logn)$ 的查询，时间复杂度为 $O(qlogn)$。每次查询还需要建立大小为 $O(t)$ 的数组，时间复杂度为 $O(tq)$。
    * 综合起来，时间复杂度为 $O(q(t+logn)+nlogn)$
  * 空间复杂度：$O(n+t)$
    * 最多需要存储 $n$ 个用户以及 $n$ 条推文时间，空间复杂度为 $O(n)$。
    * 查询时需要开辟 $O(t)$ 的数组，空间复杂度为 $O(t)$。综合起来，空间复杂度为 $O(n+t)$。