#### 方法一：模拟

**思路与算法**

根据题目描述，我们可以发现：机器人总是会在网格的「最外圈」进行循环移动。

![fig1](https://assets.leetcode-cn.com/solution-static/5911/5911.png){:width="40%"}

因此，我们可以将机器人移动的循环节（位置以及移动方向）预处理出来，存储在数组中，并用一个指针 $\textit{idx}$ 指向数组中的某个位置，表示当前机器人的位置以及移动方向。

预处理可以分为四个步骤完成。如上图所示，不同颜色的网格表示机器人在对应网格上的不同方向，因此我们可以使用四个循环分别枚举每一种颜色对应的网格的位置，把它们加入预处理的数组即可。

对于题目要求实现的三个接口，我们可以依次实现：

- $\texttt{void move(int num)}$：我们可以将 $\textit{idx}$ 的值增加 $\textit{num}$。由于机器人的移动路径是循环的，我们需要将增加后的值对循环的长度取模。

- $\texttt{int[] getPos()}$：我们根据 $\textit{idx}$ 返回预处理数组中的位置即可。

- $\texttt{String getDir()}$：我们根据 $\textit{idx}$ 返回预处理数组中的朝向即可。

**细节**

需要注意的是。当机器人回到原点时，它的朝向为「南」，但机器人初始在原点时的朝向为「东」。因此我们可以将预处理数组中原点的朝向改为「南」，并使用一个布尔变量记录机器人是否移动过：

- 如果机器人未移动过，我们总是返回「东」朝向；

- 如果机器人移动过，我们根据 $\textit{idx}$ 返回预处理数组中的朝向。

**代码**

```C++ [sol1-C++]
class Robot {
private:
    bool moved = false;
    int idx = 0;
    vector<pair<int, int>> pos;
    vector<int> dir;
    unordered_map<int, string> to_dir = {
        {0, "East"},
        {1, "North"},
        {2, "West"},
        {3, "South"}
    };
    
public:
    Robot(int width, int height) {
        for (int i = 0; i < width; ++i) {
            pos.emplace_back(i, 0);
            dir.emplace_back(0);
        }
        for (int i = 1; i < height; ++i) {
            pos.emplace_back(width - 1, i);
            dir.emplace_back(1);
        }
        for (int i = width - 2; i >= 0; --i) {
            pos.emplace_back(i, height - 1);
            dir.emplace_back(2);
        }
        for (int i = height - 2; i > 0; --i) {
            pos.emplace_back(0, i);
            dir.emplace_back(3);
        }
        dir[0] = 3;
    }
    
    void move(int num) {
        moved = true;
        idx = (idx + num) % pos.size();
    }
    
    vector<int> getPos() {
        return {pos[idx].first, pos[idx].second};
    }
    
    string getDir() {
        if (!moved) {
            return "East";
        }
        return to_dir[dir[idx]];
    }
};
```

```Python [sol1-Python3]
class Robot:

    TO_DIR = {
        0: "East",
        1: "North",
        2: "West",
        3: "South",
    }

    def __init__(self, width: int, height: int):
        self.moved = False
        self.idx = 0
        self.pos = list()
        self.dirs = list()

        pos_, dirs_ = self.pos, self.dirs

        for i in range(width):
            pos_.append((i, 0))
            dirs_.append(0)
        for i in range(1, height):
            pos_.append((width - 1, i))
            dirs_.append(1)
        for i in range(width - 2, -1, -1):
            pos_.append((i, height - 1))
            dirs_.append(2)
        for i in range(height - 2, 0, -1):
            pos_.append((0, i))
            dirs_.append(3)

        dirs_[0] = 3

    def move(self, num: int) -> None:
        self.moved = True
        self.idx = (self.idx + num) % len(self.pos)

    def getPos(self) -> List[int]:
        return list(self.pos[self.idx])

    def getDir(self) -> str:
        if not self.moved:
            return "East"
        return Robot.TO_DIR[self.dirs[self.idx]]
```

**复杂度分析**

- 时间复杂度：预处理的时间复杂度为 $O(\textit{width} + \textit{height})$，所有查询接口的时间复杂度均为 $O(1)$。

- 空间复杂度：$O(\textit{width} + \textit{height})$，即为存储预处理数组需要的空间。