## [874.模拟行走机器人 中文官方题解](https://leetcode.cn/problems/walking-robot-simulation/solutions/100000/mo-ni-xing-zou-ji-qi-ren-by-leetcode-sol-41b8)
#### 方法一：哈希表

**思路与算法**

题目给出一个在点 $(0, 0)$ ，并面向北方的机器人。现在有一个大小为 $n$ 的命令数组 $\textit{commands}$ 来操作机器人的移动，和一个大小为 $m$ 的障碍物数组 $\textit{obstacles}$。现在我们通过 $\textit{commands}$ 来模拟机器人的移动，并用一个哈希表来存储每一个障碍物放置点。当机器人的指令为向前移动时，我们尝试往前移动对应的次数——若往前一个单位不为障碍物放置点（即不在哈希表中），则机器人向前移动一个单位，否则机器人保持原位不变。

在机器人移动的过程中记录从原点到机器人所有经过的整数路径点的最大欧式距离的平方即为最后的答案。

在代码实现的过程中，对于机器人转向和向前移动的操作，我们可以用一个方向数组 $\textit{dirs} = \{[-1, 0], [0, 1], [1, 0], [0, -1]\}$ 来现实。若当前机器人的坐标为 $(x, y)$，当前方向的标号为 $d$，则往前移动一单位的操作为 $x = x + \textit{dirs}[d][0]$，$y = y + \textit{dirs}[i][1]$。向左转的操作为 $d = (d + 3) \mod 4$，向右转的操作为 $d = (d + 1) \mod 4$。

**代码**

```Python [sol1-Python3]
class Solution:
    def robotSim(self, commands: List[int], obstacles: List[List[int]]) -> int:
        dirs = [[-1, 0], [0, 1], [1, 0], [0, -1]]
        px, py, d = 0, 0, 1
        mp = set([tuple(i) for i in obstacles])
        res = 0
        for c in commands:
            if c < 0:
                d += 1 if c == -1 else -1
                d %= 4
            else:
                for i in range(c):
                    if tuple([px + dirs[d][0], py + dirs[d][1]]) in mp:
                        break
                    px, py = px + dirs[d][0], py + dirs[d][1]
                    res = max(res, px * px + py * py)
        return res
```

```Java [sol1-Java]
class Solution {
    public int robotSim(int[] commands, int[][] obstacles) {
        int[][] dirs = {{-1, 0}, {0, 1}, {1, 0}, {0, -1}};
        int px = 0, py = 0, d = 1;
        Set<Integer> set = new HashSet<Integer>();
        for (int[] obstacle : obstacles) {
            set.add(obstacle[0] * 60001 + obstacle[1]);
        }
        int res = 0;
        for (int c : commands) {
            if (c < 0) {
                d += c == -1 ? 1 : -1;
                d %= 4;
                if (d < 0) {
                    d += 4;
                }
            } else {
                for (int i = 0; i < c; i++) {
                    if (set.contains((px + dirs[d][0]) * 60001 + py + dirs[d][1])) {
                        break;
                    }
                    px += dirs[d][0];
                    py += dirs[d][1];
                    res = Math.max(res, px * px + py * py);
                }
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int RobotSim(int[] commands, int[][] obstacles) {
        int[][] dirs = {new int[]{-1, 0}, new int[]{0, 1}, new int[]{1, 0}, new int[]{0, -1}};
        int px = 0, py = 0, d = 1;
        ISet<int> set = new HashSet<int>();
        foreach (int[] obstacle in obstacles) {
            set.Add(obstacle[0] * 60001 + obstacle[1]);
        }
        int res = 0;
        foreach (int c in commands) {
            if (c < 0) {
                d += c == -1 ? 1 : -1;
                d %= 4;
                if (d < 0) {
                    d += 4;
                }
            } else {
                for (int i = 0; i < c; i++) {
                    if (set.Contains((px + dirs[d][0]) * 60001 + py + dirs[d][1])) {
                        break;
                    }
                    px += dirs[d][0];
                    py += dirs[d][1];
                    res = Math.Max(res, px * px + py * py);
                }
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int robotSim(vector<int>& commands, vector<vector<int>>& obstacles) {
        int dirs[4][2] = {{-1, 0}, {0, 1}, {1, 0}, {0, -1}};
        int px = 0, py = 0, d = 1;
        unordered_set<int> mp;
        for (auto &obstacle : obstacles) {
            mp.emplace(obstacle[0] * 60001 + obstacle[1]);
        }
        int res = 0;
        for (int c : commands) {
            if (c < 0) {
                d += c == -1 ? 1 : -1;
                d %= 4;
                if (d < 0) {
                    d += 4;
                }
            } else {
                for (int i = 0; i < c; i++) {
                    if (mp.count((px + dirs[d][0]) * 60001 + py + dirs[d][1])) {
                        break;
                    }
                    px += dirs[d][0];
                    py += dirs[d][1];
                    res = max(res, px * px + py * py);
                }
            }
        }
        return res;
    }
};
```

```Go [sol1-Go]
func robotSim(commands []int, obstacles [][]int) int {
    dirs := [][]int{{-1, 0}, {0, 1}, {1, 0}, {0, -1}}
    px, py, d := 0, 0, 1
    set := make(map[int]bool)
    for _, obstacle := range obstacles {
        set[obstacle[0] * 60001 + obstacle[1]] = true
    }
    res := 0
    for _, c := range commands {
        if c < 0 {
            if c == -1 {
                d = (d + 1) % 4
            } else {
                d = (d + 3) % 4
            }
        } else {
            for i := 0; i < c; i++ {
                if set[(px + dirs[d][0]) * 60001 + py + dirs[d][1]] {
                    break
                }
                px += dirs[d][0]
                py += dirs[d][1]
                res = max(res, px * px + py * py)
            }
        }
    }
    return res
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var robotSim = function(commands, obstacles) {
    const dirs = [[-1, 0], [0, 1], [1, 0], [0, -1]];
    let px = 0, py = 0, d = 1;
    let set = new Set();
    for (const obstacle of obstacles) {
        set.add(obstacle[0] * 60001 + obstacle[1]);
    }
    let res = 0;
    for (const c of commands) {
        if (c < 0) {
            d += c == -1 ? 1 : 3;
            d %= 4;
        } else {
            for (let i = 0; i < c; i++) {
                if (set.has((px + dirs[d][0]) * 60001 + py + dirs[d][1])) {
                    break;
                }
                px += dirs[d][0];
                py += dirs[d][1];
                res = Math.max(res, px * px + py * py);
            }
        }
    }
    return res;
}
```

```C [sol1-C]
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);
    }
}

int robotSim(int* commands, int commandsSize, int** obstacles, int obstaclesSize, int* obstaclesColSize) {
    int dirs[4][2] = {{-1, 0}, {0, 1}, {1, 0}, {0, -1}};
    int px = 0, py = 0, d = 1;
    HashItem *mp = NULL;
    for (int i = 0; i < obstaclesSize; i++) {
        hashAddItem(&mp, obstacles[i][0] * 60001 + obstacles[i][1]);
    }
    int res = 0;
    for (int i = 0; i < commandsSize; i++) {
        int c = commands[i];
        if (c < 0) {
            d += c == -1 ? 1 : -1;
            d %= 4;
            if (d < 0) {
                d += 4;
            }
        } else {
            for (int i = 0; i < c; i++) {
                if (hashFindItem(&mp , (px + dirs[d][0]) * 60001 + py + dirs[d][1])) {
                    break;
                }
                px += dirs[d][0];
                py += dirs[d][1];
                res = fmax(res, px * px + py * py);
            }
        }
    }
    hashFree(&mp);
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(C \times n + m)$，其中 $n$ 为数组 $\textit{commands}$ 的大小，$C$ 为每次可以向前的步数最大值，在该题目中 $C = 9$，$m$ 为数组 $\textit{obstacles}$ 的大小。时间开销主要为模拟机器人移动和哈希表存储每一个障碍物的坐标的开销。
- 空间复杂度：$O(m)$，其中 $m$ 为数组 $\textit{obstacles}$ 的大小，主要为哈希表存储 $\textit{obstacles}$ 的空间开销。