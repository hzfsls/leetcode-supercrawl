#### 方法一：离线算法

**提示 $1$**

如果我们可以将给定的房间和询问重新排序，那么是否可以使得问题更加容易解决？

**提示 $2$**

我们可以将房间以及询问都看成一个「事件」，如果我们将这些「事件」按照大小（房间的 $\textit{size}$ 或者询问的 $\textit{minSize}$）进行降序排序，那么：

- 如果我们遇到一个表示房间的「事件」，那么可以将该房间的 $\textit{roomId}$ 加入某一「数据结构」中；
- 如果我们遇到一个表示询问的「事件」，那么需要在「数据结构」中寻找与 $\textit{preferred}$ 最接近的 $\textit{roomId}$。

**提示 $3$**

你能想出一种合适的「数据结构」吗？

**思路与算法**

我们使用「有序集合」作为提示中的「数据结构」。

根据提示 $2$，我们将每一个房间以及询问对应一个「事件」，放入数组中进行降序排序。随后我们遍历这些「事件」：

- 如果我们遇到一个表示房间的「事件」，那么将该该房间的 $\textit{roomId}$ 加入「有序集合」中；
- 如果我们遇到一个表示询问的「事件」，那么答案即为「有序集合」中与询问的 $\textit{preferred}$ 最接近的那个 $\textit{roomId}$。在大部分语言的「有序集合」的 API 中，提供了例如「在有序集合中查找最小的大于等于 $x$ 的元素」或者「在有序集合中查找最小的严格大于 $x$ 的元素」，我们可以利用这些 API 找出「有序集合」中与 $\textit{preferred}$ 最接近的两个元素，其中一个小于 $\textit{preferred}$，另一个大于等于 $\textit{preferred}$。通过比较这两个元素，我们即可得到该询问对应的答案。

**细节**

如果不同类型的「事件」的位置相同，那么我们应当按照先处理表示房间的「事件」，再处理表示询问的「事件」，这是因为房间的 $\textit{size}$ 只要大于等于询问的 $\textit{minSize}$ 就是满足要求的。

**代码**

```C++ [sol1-C++]
struct Event {
    // 事件的类型，0 表示房间，1 表示询问
    int type;
    // 房间的 size 或者询问的 minSize
    int size;
    // 房间的 roomId 或者询问的 preferred
    int id;
    // 房间在数组 room 中的原始编号或者询问在数组 queries 中的原始编号
    int origin;
    
    Event(int _type, int _size, int _id, int _origin): type(_type), size(_size), id(_id), origin(_origin) {}
    
    // 自定义比较函数，按照事件的 size 降序排序
    // 如果 size 相同，优先考虑房间
    bool operator< (const Event& that) const {
        return size > that.size || (size == that.size && type < that.type);
    }
};

class Solution {
public:
    vector<int> closestRoom(vector<vector<int>>& rooms, vector<vector<int>>& queries) {
        int m = rooms.size();
        int n = queries.size();
        
        vector<Event> events;
        for (int i = 0; i < m; ++i) {
            // 房间事件
            events.emplace_back(0, rooms[i][1], rooms[i][0], i);
        }
        for (int i = 0; i < n; ++i) {
            // 询问事件
            events.emplace_back(1, queries[i][1], queries[i][0], i);
        }

        sort(events.begin(), events.end());
        
        vector<int> ans(n, -1);
        // 存储房间 roomId 的有序集合
        set<int> valid;
        for (const auto& event: events) {
            if (event.type == 0) {
                // 房间事件，将 roomId 加入有序集合
                valid.insert(event.id);
            }
            else {
                // 询问事件
                int dist = INT_MAX;
                // 查找最小的大于等于 preferred 的元素
                auto it = valid.lower_bound(event.id);
                if (it != valid.end() && *it - event.id < dist) {
                    dist = *it - event.id;
                    ans[event.origin] = *it;
                }
                if (it != valid.begin()) {
                    // 查找最大的严格小于 preferred 的元素
                    it = prev(it);
                    if (event.id - *it <= dist) {
                        dist = event.id - *it;
                        ans[event.origin] = *it;
                    }
                }
            }
        }
        
        return ans;
    }
};
```

```Python [sol1-Python3]
class Event:
    """
    op: 事件的类型，0 表示房间，1 表示询问
    size: 房间的 size 或者询问的 minSize
    idx: 房间的 roomId 或者询问的 preferred
    origin: 房间在数组 room 中的原始编号或者询问在数组 queries 中的原始编号
    """
    def __init__(self, op: int, size: int, idx: int, origin: int):
        self.op = op
        self.size = size
        self.idx = idx
        self.origin = origin

    """
    自定义比较函数，按照事件的 size 降序排序
    如果 size 相同，优先考虑房间
    """
    def __lt__(self, other: "Event") -> bool:
        return self.size > other.size or (self.size == other.size and self.op < other.op)

class Solution:
    def closestRoom(self, rooms: List[List[int]], queries: List[List[int]]) -> List[int]:
        n = len(queries)

        events = list()
        for i, (roomId, size) in enumerate(rooms):
            # 房间事件
            events.append(Event(0, size, roomId, i))

        for i, (minSize, preferred) in enumerate(queries):
            # 询问事件
            events.append(Event(1, preferred, minSize, i))

        events.sort()

        ans = [-1] * n
        # 存储房间 roomId 的有序集合
        # 需要导入 sortedcontainers 库
        valid = sortedcontainers.SortedList()
        for event in events:
            if event.op == 0:
                # 房间事件，将 roomId 加入有序集合
                valid.add(event.idx)
            else:
                # 询问事件
                dist = float("inf")
                # 查找最小的大于等于 preferred 的元素
                x = valid.bisect_left(event.idx)
                if x != len(valid) and valid[x] - event.idx < dist:
                    dist = valid[x] - event.idx
                    ans[event.origin] = valid[x]
                if x != 0:
                    # 查找最大的严格小于 preferred 的元素
                    x -= 1
                    if event.idx - valid[x] <= dist:
                        dist = event.idx - valid[x]
                        ans[event.origin] = valid[x]
            
        return ans
```

**复杂度分析**

- 时间复杂度：$O((n+q) \log (n+q))$，其中 $n$ 是数组 $\textit{rooms}$ 的长度，$q$ 是数组 $\textit{queries}$ 的长度。「事件」的数量为 $n+q = O(n+q)$，因此需要 $O((n+q) \log (n+q))$ 的时间进行排序。在这之后，我们需要 $O(n+q)$ 的时间对事件进行遍历，而对有序集合进行操作的单次时间复杂度为 $O(\log n)$，总时间复杂度为 $O((n+q) \log n)$，在渐进意义下小于前者，可以忽略。

- 空间复杂度：$O(n+q)$。我们需要 $O(n+q)$ 的空间存储「事件」，以及 $O(n)$ 的空间分配给有序集合，因此总空间复杂度为 $O(n+q)$。