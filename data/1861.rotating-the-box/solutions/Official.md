#### 方法一：用队列维护空位

**提示 $1$**

当我们将盒子顺时针旋转之后，原先的「每一行」就变成了「每一列」。

由于石头受到重力只会竖直向下掉落，因此「每一列」之间都互不影响，我们可以依次计算「每一列」的结果，即原先的「每一行」的结果。

**思路与算法**

由于重力向下，那么我们应当从右向左遍历原先的「每一行」。

我们使用一个队列来存放一行中的空位：

- 当我们遍历到一块石头时，就从队首取出一个空位来放置这块石头。如果队列为空，那么说明右侧没有空位，这块石头不会下落；

- 当我们遍历到一个空位时，我们将其加入队列；

- 当我们遍历到一个障碍物时，需要将队列清空，障碍物右侧的空位都是不可用的。

在遍历完所有的行后，我们将矩阵顺时针旋转 $90$ 度，放入答案数组中即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<char>> rotateTheBox(vector<vector<char>>& box) {
        int m = box.size();
        int n = box[0].size();

        for (int i = 0; i < m; ++i) {
            deque<int> q;
            for (int j = n - 1; j >= 0; --j) {
                if (box[i][j] == '*') {
                    // 遇到障碍物，清空队列
                    q.clear();
                }
                else if (box[i][j] == '#') {
                    if (!q.empty()) {
                        // 如果队列不为空，石头就会下落
                        int pos = q.front();
                        q.pop_front();
                        box[i][pos] = '#';
                        box[i][j] = '.';
                        // 由于下落，石头变为空位，也需要加入队列
                        q.push_back(j);
                    }
                }
                else {
                    // 将空位加入队列
                    q.push_back(j);
                }
            }
        }

        // 将矩阵顺时针旋转 90 度放入答案
        vector<vector<char>> ans(n, vector<char>(m));
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                ans[j][m - i - 1] = box[i][j];
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def rotateTheBox(self, box: List[List[str]]) -> List[List[str]]:
        m, n = len(box), len(box[0])

        for i in range(m):
            q = deque()
            for j in range(n - 1, -1, -1):
                if box[i][j] == "*":
                    # 遇到障碍物，清空队列
                    q.clear()
                elif box[i][j] == "#":
                    if q:
                        # 如果队列不为空，石头就会下落
                        pos = q.popleft()
                        box[i][pos] = "#"
                        box[i][j] = "."
                        # 由于下落，石头变为空位，也需要加入队列
                        q.append(j)
                else:
                    # 将空位加入队列
                    q.append(j)

        # 将矩阵顺时针旋转 90 度放入答案
        ans = [[""] * m for _ in range(n)]
        for i in range(m):
            for j in range(n):
                ans[j][m - i - 1] = box[i][j]
        return ans
```

**复杂度分析**

- 时间复杂度：$O(mn)$。

- 空间复杂度：$O(n)$，即为队列需要使用的空间。这里我们不计算返回的答案使用的空间。

#### 方法二：用指针维护空位

**提示 $1$**

在遍历完某一个位置之后，如果队列不为空，那么：

- 队尾一定是该位置；
- 队列中的位置一定是连续的。

**提示 $1$ 解释**

如果队列不为空，那么该位置一定是空位（要么原本就是空位，要么原本有一块石头下落，该位置变成了空位），因此该位置会被加入队列成为队尾。

如果队列中的位置不连续，假设队列中没有位置 $x$，但有小于 $x$ 和大于 $x$ 的位置，当我们在此之前遍历到位置 $x$ 时，$x$ 没有被放入队列，说明 $x$ 不是空位，并且那时的队列为空，这样队列中就不可能有大于 $x$ 的位置了，这就产生了矛盾。

**思路与算法**

根据提示 $1$，我们就无需显式地维护这个队列了。

如果队列不为空，那么队尾一定为当前位置，且队列中的位置连续。因此我们只需要维护队首对应的位置即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<vector<char>> rotateTheBox(vector<vector<char>>& box) {
        int m = box.size();
        int n = box[0].size();

        for (int i = 0; i < m; ++i) {
            // 队首对应的位置
            int front_pos = n - 1;
            for (int j = n - 1; j >= 0; --j) {
                if (box[i][j] == '*') {
                    // 遇到障碍物，清空队列
                    front_pos = j - 1;
                }
                else if (box[i][j] == '#') {
                    if (front_pos > j) {
                        // 如果队列不为空，石头就会下落
                        box[i][front_pos] = '#';
                        box[i][j] = '.';
                        --front_pos;
                    }
                    else {
                        front_pos = j - 1;
                    }
                }
            }
        }

        // 将矩阵顺时针旋转 90 度放入答案
        vector<vector<char>> ans(n, vector<char>(m));
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                ans[j][m - i - 1] = box[i][j];
            }
        }
        return ans;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def rotateTheBox(self, box: List[List[str]]) -> List[List[str]]:
        m, n = len(box), len(box[0])

        for i in range(m):
            # 队首对应的位置
            front_pos = n - 1
            for j in range(n - 1, -1, -1):
                if box[i][j] == "*":
                    # 遇到障碍物，清空队列
                    front_pos = j - 1
                elif box[i][j] == "#":
                    if front_pos > j:
                        # 如果队列不为空，石头就会下落
                        box[i][front_pos] = "#"
                        box[i][j] = "."
                        front_pos -= 1
                    else:
                        front_pos = j - 1

        # 将矩阵顺时针旋转 90 度放入答案
        ans = [[""] * m for _ in range(n)]
        for i in range(m):
            for j in range(n):
                ans[j][m - i - 1] = box[i][j]
        return ans
```

**复杂度分析**

- 时间复杂度：$O(mn)$。

- 空间复杂度：$O(1)$。这里我们不计算返回的答案使用的空间。