## [1496.判断路径是否相交 中文官方题解](https://leetcode.cn/problems/path-crossing/solutions/100000/pan-duan-lu-jing-shi-fou-xiang-jiao-by-leetcode-so)
#### 方法一：哈希表

**思路**

我们可以模拟机器人行走的过程，机器人行走的本质是它的坐标发生了变化，要解决这个问题，就要保存机器人走过的所有坐标——所以这道题的关键在于如何判断「走到之前已经走过的位置」。

由于数组 $\it path$ 的长度最大是 $10^4$，我们并不能开一个二维数组来表示这个坐标平面：在极端情况下，机器人每次都沿着同一个方向前进，开二维数组需要 $(10^4)^2$ 个布尔类型变量的空间，它非常大。实际上，这 $(10^4)^2$ 个位置并不是都能用到，大多数位置是没有访问到的，用这样的方法打访问标记会造成很大的空间浪费。

因此我们可以用哈希表来解决这个问题，即我们可以给「已经走过」的位置打上访问标记，把坐标 $(x, y)$ 存入哈希表，每次模拟坐标的变化得到新的坐标，在哈希表中查询这个坐标对应的哈希值有没有出现过，这样既不用花费很大的空间，又能快速查询到一个坐标是否访问过。

在 `C++` 语言中，如果使用 `pair<int, int>` 存储坐标，那么我们需要自己实现哈希映射函数。我们可以令哈希函数 $f(x, y) = x \times 20001 + y$，这是因为 $y$ 的取值范围在 $[-10^4, 10^4]$ 内，共有 $20001$ 种可能性，上述的哈希函数就不会造成冲突。在 `Python` 语言中，我们使用元组 `tuple` 存储坐标，可以直接放入哈希表 `set` 中。

代码如下。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    int getHash(int x, int y) {
        return x * 20001 + y;
    }

    bool isPathCrossing(string path) {
        unordered_set<int> vis;

        int x = 0, y = 0;
        vis.insert(getHash(x, y));

        for (char dir: path) {
            switch (dir) {
                case 'N': --x; break;
                case 'S': ++x; break;
                case 'W': --y; break;
                case 'E': ++y; break;
            }
            int hashValue = getHash(x, y);
            if (vis.find(hashValue) != vis.end()) {
                return true;
            } else {
                vis.insert(hashValue);
            }
        }

        return false;
    }
};
```

```C++ [sol1-C++11]
class Solution {
public:
    bool isPathCrossing(string path) {
        auto pairHash = [](const pair<int, int>& o) {
            return o.first * 20001 + o.second;
        };
        unordered_set<pair<int, int>, decltype(pairHash)> vis(0, pairHash);

        int x = 0, y = 0;
        vis.emplace(x, y);

        for (char dir: path) {
            switch (dir) {
                case 'N': --x; break;
                case 'S': ++x; break;
                case 'W': --y; break;
                case 'E': ++y; break;
            }
            if (vis.find({x, y}) != vis.end()) {
                return true;
            } else {
                vis.emplace(x, y);
            }
        }

        return false;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isPathCrossing(String path) {
        Set<Integer> vis = new HashSet<Integer>();

        int x = 0, y = 0;
        vis.add(getHash(x, y));

        int length = path.length();
        for (int i = 0; i < length; i++) {
            char dir = path.charAt(i);
            switch (dir) {
                case 'N': --x; break;
                case 'S': ++x; break;
                case 'W': --y; break;
                case 'E': ++y; break;
            }
            int hashValue = getHash(x, y);
            if (!vis.add(hashValue)) {
                return true;
            }
        }

        return false;
    }

    public int getHash(int x, int y) {
        return x * 20001 + y;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isPathCrossing(self, path: str) -> bool:
        dirs = {
            "N": (-1, 0),
            "S": (1, 0),
            "W": (0, -1),
            "E": (0, 1),
        }
        
        x, y = 0, 0
        vis = set([(x, y)])
        for ch in path:
            dx, dy = dirs[ch]
            x, y = x + dx, y + dy
            if (x, y) in vis:
                return True
            vis.add((x, y))

        return False
```

**复杂度**

假设 `path` 的长度为 $n$。

+ 时间复杂度：$O(n)$。最坏情况下，对于 $n$ 个元素，每个元素做一次 $O(1)$ 的哈希表查询和一次 $O(1)$ 的哈希表插入。

+ 空间复杂度：$O(n)$。这里使用了哈希表作为辅助空间，故空间代价是 $O(n)$。