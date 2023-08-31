## [682.棒球比赛 中文官方题解](https://leetcode.cn/problems/baseball-game/solutions/100000/bang-qiu-bi-sai-by-leetcode-solution-gxab)
#### 方法一：模拟

**思路与算法**

使用变长数组对栈进行模拟。

+ 如果操作是 $+$，那么访问数组的后两个得分，将两个得分之和加到总得分，并且将两个得分之和入栈。

+ 如果操作是 $\text{D}$，那么访问数组的最后一个得分，将得分乘以 $2$ 加到总得分，并且将得分乘以 $2$ 入栈。

+ 如果操作是 $\text{C}$，那么访问数组的最后一个得分，将总得分减去该得分，并且将该得分出栈。

+ 如果操作是整数，那么将该整数加到总得分，并且将该整数入栈。

**代码**

```Python [sol1-Python3]
class Solution:
    def calPoints(self, ops: List[str]) -> int:
        ans = 0
        points = []
        for op in ops:
            if op == '+':
                pt = points[-1] + points[-2]
            elif op == 'D':
                pt = points[-1] * 2
            elif op == 'C':
                ans -= points.pop()
                continue
            else:
                pt = int(op)
            ans += pt
            points.append(pt)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int calPoints(vector<string>& ops) {
        int ret = 0;
        vector<int> points;
        for (auto &op : ops) {
            int n = points.size();
            switch (op[0]) {
                case '+':
                    ret += points[n - 1] + points[n - 2];
                    points.push_back(points[n - 1] + points[n - 2]);
                    break;
                case 'D':
                    ret += 2 * points[n - 1];
                    points.push_back(2 * points[n - 1]);
                    break;
                case 'C':
                    ret -= points[n - 1];
                    points.pop_back();
                    break;
                default:
                    ret += stoi(op);
                    points.push_back(stoi(op));
                    break;
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int calPoints(String[] ops) {
        int ret = 0;
        List<Integer> points = new ArrayList<Integer>();
        for (String op : ops) {
            int n = points.size();
            switch (op.charAt(0)) {
                case '+':
                    ret += points.get(n - 1) + points.get(n - 2);
                    points.add(points.get(n - 1) + points.get(n - 2));
                    break;
                case 'D':
                    ret += 2 * points.get(n - 1);
                    points.add(2 * points.get(n - 1));
                    break;
                case 'C':
                    ret -= points.get(n - 1);
                    points.remove(n - 1);
                    break;
                default:
                    ret += Integer.parseInt(op);
                    points.add(Integer.parseInt(op));
                    break;
            }
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CalPoints(string[] ops) {
        int ret = 0;
        IList<int> points = new List<int>();
        foreach (string op in ops) {
            int n = points.Count;
            switch (op[0]) {
                case '+':
                    ret += points[n - 1] + points[n - 2];
                    points.Add(points[n - 1] + points[n - 2]);
                    break;
                case 'D':
                    ret += 2 * points[n - 1];
                    points.Add(2 * points[n - 1]);
                    break;
                case 'C':
                    ret -= points[n - 1];
                    points.RemoveAt(n - 1);
                    break;
                default:
                    ret += int.Parse(op);
                    points.Add(int.Parse(op));
                    break;
            }
        }
        return ret;
    }
}
```

```C [sol1-C]
int calPoints(char ** ops, int opsSize){
    int ret = 0;
    int * points = (int *)malloc(sizeof(int) * opsSize);
    int pos = 0;
    for (int i = 0; i < opsSize; i++) {
        switch (ops[i][0]) {
            case '+':
                ret += points[pos - 1] + points[pos - 2];
                points[pos++] = points[pos - 1] + points[pos - 2];
                break;
            case 'D':
                ret += 2 * points[pos - 1];
                points[pos++] = 2 * points[pos - 1];
                break;
            case 'C':
                ret -= points[pos - 1];
                pos--;
                break;
            default:
                ret += atoi(ops[i]);
                points[pos++] = atoi(ops[i]);
                break;
        }
    }
    free(points);
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var calPoints = function(ops) {
    let ret = 0;
    const points = [];
    for (const op of ops) {
        const n = points.length;
        switch (op[0]) {
            case '+':
                ret += points[n - 1] + points[n - 2];
                points.push(points[n - 1] + points[n - 2]);
                break;
            case 'D':
                ret += 2 * points[n - 1];
                points.push(2 * points[n - 1]);
                break;
            case 'C':
                ret -= points[n - 1];
                points.pop();
                break;
            default:
                ret += parseInt(op);
                points.push(parseInt(op));
                break;
        }
    }
    return ret;
};
```

```go [sol1-Golang]
func calPoints(ops []string) (ans int) {
    points := []int{}
    for _, op := range ops {
        n := len(points)
        switch op[0] {
        case '+':
            ans += points[n-1] + points[n-2]
            points = append(points, points[n-1]+points[n-2])
        case 'D':
            ans += points[n-1] * 2
            points = append(points, 2*points[n-1])
        case 'C':
            ans -= points[n-1]
            points = points[:len(points)-1]
        default:
            pt, _ := strconv.Atoi(op)
            ans += pt
            points = append(points, pt)
        }
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{ops}$ 的大小。遍历整个 $\textit{ops}$ 需要 $O(n)$。

+ 空间复杂度：$O(n)$。变长数组最多保存 $O(n)$ 个元素。