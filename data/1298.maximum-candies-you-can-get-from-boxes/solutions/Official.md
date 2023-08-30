#### 方法一：广度优先搜索

我们可以使用广度优先搜索 + 队列的方法解决这个问题。

对于第 `i` 个盒子，我们只有拥有这个盒子（在初始时就拥有或从某个盒子中开出）并且能打开它（在初始时就是打开的状态或得到它的钥匙），才能获得其中的糖果。我们用数组 `has_box` 表示每个盒子是否被拥有，数组 `can_open` 表示每个盒子是否能被打开。在搜索前，我们只拥有数组 `initialBoxes` 中的那些盒子，并且能打开数组 `status` 值为 `0` 对应的那些盒子。如果一个盒子在搜索前满足这两条要求，就将其放入队列中。

在进行广度优先搜索时，每一轮我们取出队首的盒子 `k` 将其打开，得到其中的糖果、盒子 `containedBoxes[k]` 以及钥匙 `keys[k]`。我们将糖果加入答案，并依次枚举每个盒子以及每把钥匙。在枚举盒子时，如果该盒子可以被打开，就将其加入队尾；同理，在枚举钥匙时，如果其对应的盒子已经被拥有，就将该盒子加入队尾。当队列为空时，搜索结束，我们就得到了得到糖果的最大数目。

```C++ [sol1-C++]
class Solution {
public:
    int maxCandies(vector<int>& status, vector<int>& candies, vector<vector<int>>& keys, vector<vector<int>>& containedBoxes, vector<int>& initialBoxes) {
        int n = status.size();
        vector<bool> can_open(n), has_box(n), used(n);
        for (int i = 0; i < n; ++i) {
            can_open[i] = (status[i] == 1);
        }

        queue<int> q;
        int ans = 0;
        for (int box: initialBoxes) {
            has_box[box] = true;
            if (can_open[box]) {
                q.push(box);
                used[box] = true;
                ans += candies[box];
            }
        }
        
        while (!q.empty()) {
            int big_box = q.front();
            q.pop();
            for (int key: keys[big_box]) {
                can_open[key] = true;
                if (!used[key] && has_box[key]) {
                    q.push(key);
                    used[key] = true;
                    ans += candies[key];
                }
            }
            for (int box: containedBoxes[big_box]) {
                has_box[box] = true;
                if (!used[box] && can_open[box]) {
                    q.push(box);
                    used[box] = true;
                    ans += candies[box];
                }
            }
        }
        
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxCandies(self, status: List[int], candies: List[int], keys: List[List[int]], containedBoxes: List[List[int]], initialBoxes: List[int]) -> int:
        n = len(status)
        can_open = [status[i] == 1 for i in range(n)]
        has_box, used = [False] * n, [False] * n
        
        q = collections.deque()
        ans = 0
        for box in initialBoxes:
            has_box[box] = True
            if can_open[box]:
                q.append(box)
                used[box] = True
                ans += candies[box]
        
        while len(q) > 0:
            big_box = q.popleft()
            for key in keys[big_box]:
                can_open[key] = True
                if not used[key] and has_box[key]:
                    q.append(key)
                    used[key] = True
                    ans += candies[key]
            for box in containedBoxes[big_box]:
                has_box[box] = True
                if not used[box] and can_open[box]:
                    q.append(box)
                    used[box] = True
                    ans += candies[box]
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N)$。题目保证了每一把钥匙在 `keys` 中不会出现超过一次，并且每一个盒子在 `containedBoxes` 中也不会出现超过一次，因此在广度优先搜索中最多会得到 $N$ 把钥匙和 $N$ 个盒子，总时间复杂度为 $O(N)$。

- 空间复杂度：$O(N)$。