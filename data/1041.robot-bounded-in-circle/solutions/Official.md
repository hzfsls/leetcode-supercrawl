## [1041.困于环中的机器人 中文官方题解](https://leetcode.cn/problems/robot-bounded-in-circle/solutions/100000/kun-yu-huan-zhong-de-ji-qi-ren-by-leetco-kjya)
#### 方法一：模拟

**思路**

当机器人执行完指令 $\textit{instructions}$ 后，它的位置和方向均有可能发生变化。
- 如果它的位置仍位于原点，那么不管它此时方向是什么，机器人都将永远无法离开。
- 如果它的位置不在原点，那么需要考虑此时机器人的方向：

    - 如果机器人仍然朝北，那么机器人可以不会陷入循环。假设执行完一串指令后，机器人的位置是 $(x, y)$ 且不为原点，方向仍然朝北，那么执行完第二串指令后，机器人的位置便成为 $(2\times x, 2\times y)$，会不停地往外部移动，不会陷入循环。
    - 如果机器人朝南，那么执行第二串指令时，机器人的位移会与第一次相反，即第二次的位移是 $(-x, -y)$，并且结束后会回到原来的方向。这样一来，每两串指令之后，机器人都会回到原点，并且方向朝北，机器人会陷入循环。
    - 如果机器人朝东，即右转了 $90\degree$。这样一来，每执行一串指令，机器人都会右转 $90\degree$。那么第一次和第三次指令的方向是相反的，第二次和第四次指令的方向是相反的，位移之和也为 $0$，这样一来，每四次指令之后，机器人都会回到原点，并且方向朝北，机器人会陷入循环。如果机器人朝西，也是一样的结果。

因此，机器人想要摆脱循环，在一串指令之后的状态，必须是不位于原点且方向朝北。

**代码**

```Python [sol1-Python3]
class Solution:
    def isRobotBounded(self, instructions: str) -> bool:
        direc = [[0, 1], [1, 0], [0, -1], [-1, 0]]
        direcIndex = 0
        x, y = 0, 0
        for instruction in instructions:
            if instruction == 'G':
                x += direc[direcIndex][0]
                y += direc[direcIndex][1]
            elif instruction == 'L':
                direcIndex -= 1
                direcIndex %= 4
            else:
                direcIndex += 1
                direcIndex %= 4
        return direcIndex != 0 or (x == 0 and y == 0)
```

```Java [sol1-Java]
class Solution {
    public boolean isRobotBounded(String instructions) {
        int[][] direc = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
        int direcIndex = 0;
        int x = 0, y = 0;
        int n = instructions.length();
        for (int idx = 0; idx < n; idx++) {
            char instruction = instructions.charAt(idx);
            if (instruction == 'G') {
                x += direc[direcIndex][0];
                y += direc[direcIndex][1];
            } else if (instruction == 'L') {
                direcIndex += 3;
                direcIndex %= 4;
            } else {
                direcIndex++;
                direcIndex %= 4;
            }
        }
        return direcIndex != 0 || (x == 0 && y == 0);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool isRobotBounded(string instructions) {
        vector<vector<int>> direc {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
        int direcIndex = 0;
        int x = 0, y = 0;
        for (char instruction : instructions) {
            if (instruction == 'G') {
                x += direc[direcIndex][0];
                y += direc[direcIndex][1];
            } else if (instruction == 'L') {
                direcIndex += 3;
                direcIndex %= 4;
            } else {
                direcIndex++;
                direcIndex %= 4;
            }
        }
        return direcIndex != 0 || (x == 0 && y == 0);
    }
};
```

```Go [sol1-Go]
func isRobotBounded(instructions string) bool {
    direc := [][]int{{0, 1}, {1, 0}, {0, -1}, {-1, 0}}
    direcIndex := 0
    x, y := 0, 0
    n := len(instructions)
    for i := 0; i < n; i++ {
        instruction := instructions[i]
        if instruction == 'G' {
            x += direc[direcIndex][0]
            y += direc[direcIndex][1]
        } else if instruction == 'L' {
            direcIndex += 3
            direcIndex %= 4
        } else {
            direcIndex++
            direcIndex %= 4
        }
    }
    return direcIndex != 0 || (x == 0 && y == 0)
}

```

```JavaScript [sol1-JavaScript]
var isRobotBounded = function(instructions) {
    const direc = [[0, 1], [1, 0], [0, -1], [-1, 0]]
    let direcIndex = 0
    let x = 0, y = 0
    const n = instructions.length
    for (let i = 0; i < n; i++) {
        let instruction = instructions[i]
        if (instruction === 'G') {
            x += direc[direcIndex][0]
            y += direc[direcIndex][1]
        } else if (instruction === 'L') {
            direcIndex += 3
            direcIndex %= 4
        } else {
            direcIndex++
            direcIndex %= 4
        }
    }
    return direcIndex !== 0 || (x === 0 && y === 0)
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsRobotBounded(string instructions) {
        int[][] direc = {new int[]{0, 1}, new int[]{1, 0}, new int[]{0, -1}, new int[]{-1, 0}};
        int direcIndex = 0;
        int x = 0, y = 0;
        int n = instructions.Length;
        for (int idx = 0; idx < n; idx++) {
            char instruction = instructions[idx];
            if (instruction == 'G') {
                x += direc[direcIndex][0];
                y += direc[direcIndex][1];
            } else if (instruction == 'L') {
                direcIndex += 3;
                direcIndex %= 4;
            } else {
                direcIndex++;
                direcIndex %= 4;
            }
        }
        return direcIndex != 0 || (x == 0 && y == 0);
    }
}
```

```C [sol1-C]
bool isRobotBounded(char * instructions) {
    int direc[4][2] = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
    int direcIndex = 0;
    int x = 0, y = 0;
    int n = strlen(instructions);
    for (int i = 0; i < n; i++) {
        char instruction = instructions[i];
        if (instruction == 'G') {
            x += direc[direcIndex][0];
            y += direc[direcIndex][1];
        } else if (instruction == 'L') {
            direcIndex += 3;
            direcIndex %= 4;
        } else {
            direcIndex++;
            direcIndex %= 4;
        }
    }
    return direcIndex != 0 || (x == 0 && y == 0);
}
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{instructions}$ 的长度，需要遍历 $\textit{instructions}$ 一次。

- 空间复杂度：$O(1)$，只用到常数空间。