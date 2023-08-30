#### 说明

本题将几个面试中常考的知识点（广度优先搜索、Set/Map 的应用、排序）进行了结合。题目本身的难度不大，但需要仔细考虑清楚每一个模块之间的关系，并且能尽量做到一次性通过，否则调试起来会较为复杂。

#### 方法一：广度优先搜索

##### 步骤一：找出所有 Level k 的好友

我们可以使用广度优先搜索的方法，从编号为 `id` 的节点开始搜索，得到从 `id` 到其余所有节点的最短路径，则所有到 `id` 的最短路径为 `k` 的节点都是 Level k 的好友。

具体地，我们使用一个队列帮助我们进行搜索。队列中初始只有编号为 `id` 的节点。我们进行 `k` 轮搜索，在第 `i` 轮搜索开始前，队列中的节点是所有 Level i-1 的好友，而我们希望从这些节点得到所有 Level i 的好友。我们依次取出这些 Level i-1 的节点，设当前取出的节点为 `x`，我们遍历 `x` 的所有好友 `friends[x]`，如果某个好友未被访问过，那么我们就能知道其为 Level i 的好友，可以将其加入队列。在 `k` 轮搜索结束之后，队列中就包含了所有 Level k 的好友。

##### 步骤二：统计好友观看过的视频

我们使用一个哈希映射（HashMap）来统计 Level k 的好友观看过的视频。对于哈希映射中的每个键值对，键表示视频的名称，值表示视频被好友观看过的次数。对于队列中的每个节点 `x`，我们将 `watchedVideos[x]` 中的所有视频依次加入哈希映射，就可以完成这一步骤。

##### 步骤三：将视频按照要求排序

在统计完成之后，我们将哈希映射中的所有键值对存储进数组中，并将它们按照观看次数为第一关键字、视频名称为第二关键字生序排序，即可得到最终的结果。


```C++ [sol1-C++]
using PSI = pair<string, int>;

class Solution {
public:
    vector<string> watchedVideosByFriends(vector<vector<string>>& watchedVideos, vector<vector<int>>& friends, int id, int level) {
        int n = friends.size();
        vector<bool> used(n);
        queue<int> q;
        q.push(id);
        used[id] = true;
        for (int _ = 1; _ <= level; ++_) {
            int span = q.size();
            for (int i = 0; i < span; ++i) {
                int u = q.front();
                q.pop();
                for (int v: friends[u]) {
                    if (!used[v]) {
                        q.push(v);
                        used[v] = true;
                    }
                }
            }
        }
        
        unordered_map<string, int> freq;
        while (!q.empty()) {
            int u = q.front();
            q.pop();
            for (const string& watched: watchedVideos[u]) {
                ++freq[watched];
            }
        }
        
        vector<PSI> videos(freq.begin(), freq.end());
        sort(videos.begin(), videos.end(), [](const PSI& p, const PSI& q) {
            return p.second < q.second || (p.second == q.second && p.first < q.first);
        });
        
        vector<string> ans;
        for (const PSI& video: videos) {
            ans.push_back(video.first);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def watchedVideosByFriends(self, watchedVideos: List[List[str]], friends: List[List[int]], id: int, level: int) -> List[str]:
        n = len(friends)
        used = [False] * n
        q = collections.deque([id])
        used[id] = True
        for _ in range(level):
            span = len(q)
            for i in range(span):
                u = q.popleft()
                for v in friends[u]:
                    if not used[v]:
                        q.append(v)
                        used[v] = True
        
        freq = collections.Counter()
        for _ in range(len(q)):
            u = q.pop()
            for watched in watchedVideos[u]:
                freq[watched] += 1

        videos = list(freq.items())
        videos.sort(key=lambda x: (x[1], x[0]))

        ans = [video[0] for video in videos]
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N + M + V\log V)$，其中 $N$ 是人数，$M$ 是好友关系的总数，$V$ 是电影的总数。

- 空间复杂度：$O(N + V)$。