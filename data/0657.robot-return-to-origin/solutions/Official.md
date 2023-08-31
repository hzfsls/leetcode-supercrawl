## [657.机器人能否返回原点 中文官方题解](https://leetcode.cn/problems/robot-return-to-origin/solutions/100000/ji-qi-ren-neng-fou-fan-hui-yuan-dian-by-leetcode-s)
#### 方法一： 模拟

**思路与算法**

我们只需按指令模拟机器人移动的坐标即可。起始时机器人的坐标为 $(0,0)$，在遍历完所有指令并对机器人进行移动之后，判断机器人的坐标是否为 $(0,0)$ 即可。

具体来说，我们用两个变量 $x$ 和 $y$ 来表示机器人当前所在的坐标为 $(x,y)$，起始时 $x=0$，$y=0$。接下来我们遍历指令并更新机器人的坐标：

- 如果指令是 $U$，则令 $y=y-1$
- 如果指令是 $D$，则令 $y=y+1$
- 如果指令是 $L$，则令 $x=x-1$
- 如果指令是 $R$，则令 $x=x+1$

最后判断 $(x,y)$ 是否为 $(0,0)$ 即可。

```Java [sol1-Java]
class Solution {
    public boolean judgeCircle(String moves) {
        int x = 0, y = 0;
        int length = moves.length();
        for (int i = 0; i < length; i++) {
            char move = moves.charAt(i);
            if (move == 'U') {
                y--;
            } else if (move == 'D') {
                y++;
            } else if (move == 'L') {
                x--;
            } else if (move == 'R') {
                x++;
            }
        }
        return x == 0 && y == 0;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool judgeCircle(string moves) {
        int x = 0, y = 0;
        for (const auto& move: moves) {
            if (move == 'U') {
                y--;
            }
            else if (move == 'D') {
                y++;
            }
            else if (move == 'L') {
                x--;
            }
            else if (move == 'R') {
                x++;
            }
        }
        return x == 0 && y == 0;
    }
};
```

```Python [sol1-Python]
class Solution(object):
    def judgeCircle(self, moves):
        x = y = 0
        for move in moves:
            if move == 'U': y -= 1
            elif move == 'D': y += 1
            elif move == 'L': x -= 1
            elif move == 'R': x += 1

        return x == y == 0
```

```C [sol1-C]
bool judgeCircle(char* moves) {
    int n = strlen(moves), x = 0, y = 0;
    for (int i = 0; i < n; i++) {
        if (moves[i] == 'U') {
            y--;
        } else if (moves[i] == 'D') {
            y++;
        } else if (moves[i] == 'L') {
            x--;
        } else if (moves[i] == 'R') {
            x++;
        }
    }
    return x == 0 && y == 0;
}
```

```golang [sol1-Golang]
func judgeCircle(moves string) bool {
    x, y := 0, 0
    length := len(moves)
    for i := 0; i < length; i++ {
        switch moves[i] {
        case 'U':
            y--
        case 'D':
            y++
        case 'L':
            x--
        case 'R':
            x++
        }
    }
    return x == 0 && y == 0
}
```

**复杂度分析**

* 时间复杂度： $O(N)$，其中 $N$ 表示 $\textit{moves}$ 指令串的长度。我们只需要遍历一遍字符串即可。

* 空间复杂度： $O(1)$。我们只需要常数的空间来存放若干变量。