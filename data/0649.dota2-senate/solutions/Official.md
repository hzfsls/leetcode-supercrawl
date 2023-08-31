## [649.Dota2 参议院 中文官方题解](https://leetcode.cn/problems/dota2-senate/solutions/100000/dota2-can-yi-yuan-by-leetcode-solution-jb7l)

#### 方法一：贪心 + 「循环」队列

**思路与算法**

我们以天辉方的议员为例。当一名天辉方的议员行使权利时：

- 如果目前所有的议员都为天辉方，那么该议员可以直接宣布天辉方取得胜利；

- 如果目前仍然有夜魇方的议员，那么这名天辉方的议员只能行使「禁止一名参议员的权利」这一项权利。显然，该议员不会令一名同为天辉方的议员丧失权利，所以他一定会挑选一名夜魇方的议员。那么应该挑选哪一名议员呢？容易想到的是，**应该贪心地挑选按照投票顺序的下一名夜魇方的议员**。这也是很容易形象化地证明的：既然只能挑选**一名**夜魇方的议员，那么就应该挑最早可以进行投票的那一名议员；如果挑选了其他较晚投票的议员，那么等到最早可以进行投票的那一名议员行使权利时，一名天辉方议员就会丧失权利，这样就得不偿失了。

由于我们总要挑选投票顺序最早的议员，因此我们可以使用两个队列 $\textit{radiant}$ 和 $\textit{dire}$ 分别**按照投票顺序**存储天辉方和夜魇方每一名议员的投票时间。随后我们就可以开始模拟整个投票的过程：

- 如果此时 $\textit{radiant}$ 或者 $\textit{dire}$ 为空，那么就可以宣布另一方获得胜利；

- 如果均不为空，那么比较这两个队列的首元素，就可以确定当前行使权利的是哪一名议员。如果 $\textit{radiant}$ 的首元素较小，那说明轮到天辉方的议员行使权利，其会挑选 $\textit{dire}$ 的首元素对应的那一名议员。因此，我们会将 $\textit{dire}$ 的首元素永久地弹出，并将 $\textit{radiant}$ 的首元素弹出，增加 $n$ 之后再重新放回队列，这里 $n$ 是给定的字符串 $\textit{senate}$ 的长度，即表示该议员会参与下一轮的投票。

    > 为什么这里是固定地增加 $n$，而不是增加与当前剩余议员数量相关的一个数？读者可以思考一下这里的正确性。

    同理，如果 $\textit{dire}$ 的首元素较小，那么会永久弹出 $\textit{radiant}$ 的首元素，剩余的处理方法也是类似的。

这样一来，我们就模拟了整个投票的过程，也就可以得到最终的答案了。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string predictPartyVictory(string senate) {
        int n = senate.size();
        queue<int> radiant, dire;
        for (int i = 0; i < n; ++i) {
            if (senate[i] == 'R') {
                radiant.push(i);
            }
            else {
                dire.push(i);
            }
        }
        while (!radiant.empty() && !dire.empty()) {
            if (radiant.front() < dire.front()) {
                radiant.push(radiant.front() + n);
            }
            else {
                dire.push(dire.front() + n);
            }
            radiant.pop();
            dire.pop();
        }
        return !radiant.empty() ? "Radiant" : "Dire";
    }
};
```

```Java [sol1-Java]
class Solution {
    public String predictPartyVictory(String senate) {
        int n = senate.length();
        Queue<Integer> radiant = new LinkedList<Integer>();
        Queue<Integer> dire = new LinkedList<Integer>();
        for (int i = 0; i < n; ++i) {
            if (senate.charAt(i) == 'R') {
                radiant.offer(i);
            } else {
                dire.offer(i);
            }
        }
        while (!radiant.isEmpty() && !dire.isEmpty()) {
            int radiantIndex = radiant.poll(), direIndex = dire.poll();
            if (radiantIndex < direIndex) {
                radiant.offer(radiantIndex + n);
            } else {
                dire.offer(direIndex + n);
            }
        }
        return !radiant.isEmpty() ? "Radiant" : "Dire";
    }
}
```

```Python [sol1-Python3]
class Solution:
    def predictPartyVictory(self, senate: str) -> str:
        n = len(senate)
        radiant = collections.deque()
        dire = collections.deque()
        
        for i, ch in enumerate(senate):
            if ch == "R":
                radiant.append(i)
            else:
                dire.append(i)
        
        while radiant and dire:
            if radiant[0] < dire[0]:
                radiant.append(radiant[0] + n)
            else:
                dire.append(dire[0] + n)
            radiant.popleft()
            dire.popleft()
        
        return "Radiant" if radiant else "Dire"
```

```Golang [sol1-Golang]
func predictPartyVictory(senate string) string {
    var radiant, dire []int
    for i, s := range senate {
        if s == 'R' {
            radiant = append(radiant, i)
        } else {
            dire = append(dire, i)
        }
    }
    for len(radiant) > 0 && len(dire) > 0 {
        if radiant[0] < dire[0] {
            radiant = append(radiant, radiant[0]+len(senate))
        } else {
            dire = append(dire, dire[0]+len(senate))
        }
        radiant = radiant[1:]
        dire = dire[1:]
    }
    if len(radiant) > 0 {
        return "Radiant"
    }
    return "Dire"
}
```

```C [sol1-C]
char* predictPartyVictory(char* senate) {
    int n = strlen(senate);
    int radiant[n], dire[n];
    int left_r = 0, right_r = 0;
    int left_d = 0, right_d = 0;
    for (int i = 0; i < n; ++i) {
        if (senate[i] == 'R') {
            radiant[right_r++] = i;
        } else {
            dire[right_d++] = i;
        }
    }
    while (left_r < right_r && left_d < right_d) {
        if (radiant[left_r] < dire[left_d]) {
            radiant[right_r++] = radiant[left_r] + n;
        } else {
            dire[right_d++] = dire[left_d] + n;
        }
        left_r++;
        left_d++;
    }
    int* ret;
    if (left_r < right_r) {
        ret = malloc(sizeof(char) * 8);
        ret = "Radiant";
    } else {
        ret = malloc(sizeof(char) * 5);
        ret = "Dire";
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var predictPartyVictory = function(senate) {
    const n = senate.length;
    const radiant = [], dire = [];

    for (const [i, ch] of Array.from(senate).entries()) {
        if (ch === 'R') {
            radiant.push(i);
        } else {
            dire.push(i);
        }
    }

    while (radiant.length && dire.length) {
            if (radiant[0] < dire[0]) {
                radiant.push(radiant[0] + n);
            } else {
                dire.push(dire[0] + n);
            }
            radiant.shift();
            dire.shift();
        }
    return radiant.length ? "Radiant" : "Dire";
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{senate}$ 的长度。在模拟整个投票过程的每一步，我们进行的操作的时间复杂度均为 $O(1)$，并且会弹出一名天辉方或夜魇方的议员。由于议员的数量为 $n$，因此模拟的步数不会超过 $n$，时间复杂度即为 $O(n)$。

- 空间复杂度：$O(n)$，即为两个队列需要使用的空间。