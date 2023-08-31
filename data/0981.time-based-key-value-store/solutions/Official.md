## [981.基于时间的键值存储 中文官方题解](https://leetcode.cn/problems/time-based-key-value-store/solutions/100000/ji-yu-shi-jian-de-jian-zhi-cun-chu-by-le-t98o)

#### 方法一：哈希表 + 二分查找

为实现 $\texttt{get}$ 操作，我们需要用一个哈希表存储 $\texttt{set}$ 操作传入的数据。具体地，哈希表的键为字符串 $\textit{key}$，值为一个二元组列表，二元组中存储的是时间戳 $\textit{timestamp}$ 和值 $\textit{value}$。

由于 $\texttt{set}$ 操作中的时间戳都是严格递增的，因此二元组列表中保存的时间戳也是严格递增的，这样我们可以根据 $\texttt{get}$ 操作中的 $\textit{key}$ 在哈希表中找到对应的二元组列表 $\textit{pairs}$，然后根据 $\textit{timestamp}$ 在 $\textit{pairs}$ 中二分查找。我们需要找到最大的不超过 $\textit{timestamp}$ 的时间戳，对此，我们可以二分找到第一个超过 $\textit{timestamp}$ 的二元组下标 $i$，若 $i>0$ 则说明目标二元组存在，即 $\textit{pairs}[i-1]$，否则二元组不存在，返回空字符串。

```C++ [sol1-C++]
class TimeMap {
    unordered_map<string, vector<pair<int, string>>> m;

public:
    TimeMap() {}

    void set(string key, string value, int timestamp) {
        m[key].emplace_back(timestamp, value);
    }

    string get(string key, int timestamp) {
        auto &pairs = m[key];
        // 使用一个大于所有 value 的字符串，以确保在 pairs 中含有 timestamp 的情况下也返回大于 timestamp 的位置
        pair<int, string> p = {timestamp, string({127})};
        auto i = upper_bound(pairs.begin(), pairs.end(), p);
        if (i != pairs.begin()) {
            return (i - 1)->second;
        }
        return "";
    }
};
```

```Java [sol1-Java]
class TimeMap {
    class Pair implements Comparable<Pair> {
        int timestamp;
        String value;

        public Pair(int timestamp, String value) {
            this.timestamp = timestamp;
            this.value = value;
        }

        public int hashCode() {
            return timestamp + value.hashCode();
        }

        public boolean equals(Object obj) {
            if (obj instanceof Pair) {
                Pair pair2 = (Pair) obj;
                return this.timestamp == pair2.timestamp && this.value.equals(pair2.value);
            }
            return false;
        }

        public int compareTo(Pair pair2) {
            if (this.timestamp != pair2.timestamp) {
                return this.timestamp - pair2.timestamp;
            } else {
                return this.value.compareTo(pair2.value);
            }
        }
    }

    Map<String, List<Pair>> map;

    public TimeMap() {
        map = new HashMap<String, List<Pair>>();
    }
    
    public void set(String key, String value, int timestamp) {
        List<Pair> pairs = map.getOrDefault(key, new ArrayList<Pair>());
        pairs.add(new Pair(timestamp, value));
        map.put(key, pairs);
    }
    
    public String get(String key, int timestamp) {
        List<Pair> pairs = map.getOrDefault(key, new ArrayList<Pair>());
        // 使用一个大于所有 value 的字符串，以确保在 pairs 中含有 timestamp 的情况下也返回大于 timestamp 的位置
        Pair pair = new Pair(timestamp, String.valueOf((char) 127));
        int i = binarySearch(pairs, pair);
        if (i > 0) {
            return pairs.get(i - 1).value;
        }
        return "";
    }

    private int binarySearch(List<Pair> pairs, Pair target) {
        int low = 0, high = pairs.size() - 1;
        if (high < 0 || pairs.get(high).compareTo(target) <= 0) {
            return high + 1;
        }
        while (low < high) {
            int mid = (high - low) / 2 + low;
            Pair pair = pairs.get(mid);
            if (pair.compareTo(target) <= 0) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```C# [sol1-C#]
public class TimeMap {
    Dictionary<string, IList<Tuple<int, string>>> dictionary;

    public TimeMap() {
        dictionary = new Dictionary<string, IList<Tuple<int, string>>>();
    }
    
    public void Set(string key, string value, int timestamp) {
        if (dictionary.ContainsKey(key)) {
            dictionary[key].Add(new Tuple<int, string>(timestamp, value));
        } else {
            IList<Tuple<int, string>> tuples = new List<Tuple<int, string>>();
            tuples.Add(new Tuple<int, string>(timestamp, value));
            dictionary.Add(key, tuples);
        }
    }
    
    public string Get(string key, int timestamp) {
        IList<Tuple<int, string>> tuples = dictionary.ContainsKey(key) ? dictionary[key] : new List<Tuple<int, string>>();
        // 使用一个大于所有 value 的字符串，以确保在 pairs 中含有 timestamp 的情况下也返回大于 timestamp 的位置
        Tuple<int, string> tuple = new Tuple<int, string>(timestamp, ((char) 127).ToString());
        int i = BinarySearch(tuples, tuple);
        if (i > 0) {
            return tuples[i - 1].Item2;
        }
        return "";
    }

    private int BinarySearch(IList<Tuple<int, string>> tuples, Tuple<int, string> target) {
        int low = 0, high = tuples.Count - 1;
        if (high < 0 || Compare(tuples[high], target) <= 0) {
            return high + 1;
        }
        while (low < high) {
            int mid = (high - low) / 2 + low;
            Tuple<int, string> tuple = tuples[mid];
            if (Compare(tuple, target) <= 0) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }

    private int Compare(Tuple<int, string> tuple1, Tuple<int, string> tuple2) {
        if (tuple1.Item1 != tuple2.Item1) {
            return tuple1.Item1 - tuple2.Item1;
        } else {
            return string.CompareOrdinal(tuple1.Item2, tuple2.Item2);
        }
    }
}
```

```go [sol1-Golang]
type pair struct {
    timestamp int
    value     string
}

type TimeMap struct {
    m map[string][]pair
}

func Constructor() TimeMap {
    return TimeMap{map[string][]pair{}}
}

func (m *TimeMap) Set(key string, value string, timestamp int) {
    m.m[key] = append(m.m[key], pair{timestamp, value})
}

func (m *TimeMap) Get(key string, timestamp int) string {
    pairs := m.m[key]
    i := sort.Search(len(pairs), func(i int) bool { return pairs[i].timestamp > timestamp })
    if i > 0 {
        return pairs[i-1].value
    }
    return ""
}
```

```JavaScript [sol1-JavaScript]
var TimeMap = function() {
    this.map = new Map();
};

TimeMap.prototype.set = function(key, value, timestamp) {
    if (this.map.has(key)) {
        this.map.get(key).push([value, timestamp]);
    } else {
        this.map.set(key, [[value, timestamp]]);
    }
};

TimeMap.prototype.get = function(key, timestamp) {
    let pairs = this.map.get(key)
    if (pairs) {
        let low = 0, high = pairs.length - 1;
        while (low <= high) {
            let mid = Math.floor((high - low) / 2) + low;
            if (pairs[mid][1] > timestamp) {
                high = mid - 1;
            } else if (pairs[mid][1] < timestamp) {
                low = mid + 1;
            } else {
                return pairs[mid][0];
            }
        }
        if (high >= 0) {
            return pairs[high][0];
        }
        return "";
    }
    return "";
};
```

**复杂度分析**

- 时间复杂度：
  - 初始化 $\texttt{TimeMap}$ 和 $\texttt{set}$ 操作均为 $O(1)$；
  - $\texttt{get}$ 操作为 $O(\log n)$，其中 $n$ 是 $\texttt{set}$ 操作的次数。最坏情况下 $\texttt{set}$ 操作插入的 $\textit{key}$ 均相同，这种情况下 $\texttt{get}$ 中二分查找的次数为 $O(\log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是 $\texttt{set}$ 操作的次数。我们需要使用哈希表保存每一次$\texttt{set}$ 操作的信息。