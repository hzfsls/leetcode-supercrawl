## [488.祖玛游戏 中文官方题解](https://leetcode.cn/problems/zuma-game/solutions/100000/zu-ma-you-xi-by-leetcode-solution-lrp4)
#### 方法一：广度优先搜索

**思路**

根据题目要求，桌面上最多有 $16$ 个球，手中最多有 $5$ 个球；我们可以以任意顺序在 $5$ 个回合中使用手中的球；在每个回合中，我们可以选择将手中的球插入到桌面上任意两球之间或这一排球的任意一端。

因为插入球的颜色和位置的选择是多样的，选择的影响也可能在多次消除操作之后才能体现出来，所以通过贪心方法根据当前情况很难做出全局最优的决策。实际每次插入一个新的小球时，并不保证插入后一定可以消除，因此我们需要搜索和遍历所有可能的插入方法，找到最小的插入次数。比如以下测试用例：
- 桌面上的球为 $\texttt{RRWWRRBBRR}$，手中的球为 $\texttt{WB}$，如果我们按照贪心法每次插入进行消除就会出现无法完全消除。

因此，我们使用广度优先搜索来解决这道题。即对状态空间进行枚举，通过穷尽所有的可能来找到最优解，并使用剪枝的方法来优化搜索过程。

- 为什么使用广度优先搜索？

我们不妨规定，每一种不同的桌面上球的情况和手中球的情况的组合都是一种不同的状态。对于相同的状态，其清空桌面上球所需的回合数总是相同的；而不同的插入球的顺序，也可能得到相同的状态。因此，如果使用深度优先搜索，则需要使用记忆化搜索，以避免重复计算相同的状态。

因为只需要找出需要回合数最少的方案，因此使用广度优先搜索可以得到可以消除桌面上所有球的方案时就直接返回结果，而不需要继续遍历更多需要回合数更多的方案。而广度优先搜索虽然需要在队列中存储较多的状态，但是因为使用深度优先搜索也需要存储这些状态及这些状态对应的结果，因此使用广度优先搜索并不会需要更多的空间。

**算法**

在算法的实现中，我们可以通过以下方法来实现广度优先：

使用队列来维护需要处理的状态队列，使用哈希集合存储已经访问过的状态。每一次取出队列中的队头状态，考虑其中所有可以插入球的方案，如果新方案还没有被访问过，则将新方案添加到队列的队尾。

下面，我们考虑剪枝条件：

- 第 $1$ 个剪枝条件：手中颜色相同的球每次选择时只需要考虑其中一个即可

如果手中有颜色相同的球，那么插入这些球中的哪一个都没有区别。因此，手中颜色相同的球，我们只需要考虑其中一个即可。在具体的实现中，我们可以先将手中的球排序，如果当前遍历的球的颜色和上一个遍历的球的颜色相同，则跳过当前遍历的球。

- 第 $2$ 个剪枝条件：只在连续相同颜色的球的开头位置或者结尾位置插入新的颜色相同的球

如果桌面上有一个红球，那么在其左侧和右侧插入一个新的红球没有区别；同理，如果桌面上有 $2$ 个连续的红球，那么在其左侧、中间和右侧插入一个新的红球没有区别。因此，如果新插入的球和桌面上某组连续颜色相同的球（也可以是 $1$ 个）的颜色相同，我们只需要考虑在其左侧插入新球的情况即可。在具体的实现中，如果新插入的球和插入位置左侧的球的颜色相同，则跳过这个位置。

- 第 $3$ 个剪枝条件：只考虑放置新球后有可能得到更优解的位置

考虑插入新球的颜色与插入位置周围球的颜色的情况，在已经根据第 $2$ 个剪枝条件剪枝后，还可能出现如下三种情况：插入新球与插入位置右侧的球颜色相同；插入新球与插入位置两侧的球颜色均不相同，且插入位置两侧的球的颜色不同；插入新球与插入位置两侧的球颜色均不相同，且插入位置两侧的球的颜色相同。

对于「插入新球与插入位置右侧的球颜色相同」的情况，这种操作可能可以构成连续三个相同颜色的球实现消除，是有可能得到更优解的。读者可以结合以下例子理解。

例如：桌面上的球为 $\texttt{WWRRBBWW}$，手中的球为 $\texttt{WWRB}$，答案为 $2$。

操作方法如下：$\texttt{WWRRBBWW} \rightarrow \texttt{WW(R)RRBBWW} \rightarrow \texttt{WWBBWW} \rightarrow \texttt{WW(B)BBWW} \rightarrow \texttt{WWWW} \rightarrow \texttt{""}$。

对于「插入新球与插入位置两侧的球颜色均不相同，且插入位置两侧的球的颜色不同」的情况，这种操作可以将连续相同颜色的球拆分到不同的组合中消除，也是有可能得到更优解的。读者可以结合以下例子理解。

例如：桌面上的球为 $\texttt{RRWWRRBBRR}$，手中的球为 $\texttt{WB}$，答案为 $2$。

操作方法如下：$\texttt{RRWWRRBBRR} \rightarrow \texttt{RRWWRRBBR(W)R} \rightarrow \texttt{RRWWRR(B)BBRWR} \rightarrow \texttt{RRWWRRRWR} \rightarrow \texttt{RRWWWR} \rightarrow \texttt{RRR} \rightarrow \texttt{""}$。

对于「插入新球与插入位置两侧的球颜色均不相同，且插入位置两侧的球的颜色相同」的情况，这种操作并不能对消除顺序产生任何影响。如插入位置旁边的球可以消除的话，那么这种插入方法与直接将新球插入到与之颜色相同的球的旁边没有区别。因此，这种操作不能得到比「插入新球与插入位置右侧的球颜色相同」更好的情况，得到更优解。读者可以结合以下例子理解。

例如：桌面上的球为 $\texttt{WWRRBBWW}$，手中的球为 $\texttt{WWRB}$，答案为 $2$。

操作方法如下：$\texttt{WWRRBBWW} \rightarrow \texttt{WWRRBB(R)WW} \rightarrow \texttt{WWRRB(B)BRWW} \rightarrow \texttt{WWRRRWW} \rightarrow \texttt{WWWW} \rightarrow \texttt{""}$。

**细节**

题目规定了如果在消除操作后，如果导致出现了新的连续三个或者三个以上颜色相同的球，则继续消除这些球，直到不再满足消除条件，实际消除时我们可以利用栈的特性，每次遇到连续可以消除的球时，我们就将其从栈中弹出。在实现中，我们可以在遍历桌面上的球时，使用列表维护遍历过的每种球的颜色和连续数量，从而通过一次遍历消除连续三个或者三个以上颜色相同的球。具体地：

* 使用 $\textit{visited\_ball}$ 维护遍历过的每种球的颜色和连续数量，设其中最后一个颜色 $\textit{last\_color}$，其连续数量为 $\textit{last\_num}$；遍历桌面上的球，设当前遍历到的球为 $\textit{cur\_ball}$，其颜色为 $\textit{cur\_color}$。
* 首先，判断：
  * 如果 $\textit{visited\_ball}$ 不为空，且 $\textit{cur\_color}$ 与 $\textit{last\_color}$ 不同，则判断：如果 $\textit{last\_num}$ 大于等于 $3$，则从 $\textit{visited\_ball}$ 中移除 $\textit{last\_color}$ 和 $\textit{last\_num}$。
* 接着，判断：
  * 如果 $\textit{visited\_ball}$ 为空，或 $\textit{cur\_color}$ 与 $\textit{last\_color}$ 不同，则向 $\textit{visited\_ball}$ 添加 $\textit{cur\_color}$ 及连续数量 $1$；
  * 否则，累加 $\textit{last\_num}$。

最后，根据列表中维护的每种球的颜色和连续数量，重新构造桌面上的球的组合即可。

在 $\texttt{Python}$ 中，因为对正则表达式的优化较好，也可以循环地使用正则表达式来消除连续三个或者三个以上颜色相同的球。

**代码**

```Python [sol1-Python3]
class Solution:
    def findMinStep(self, board: str, hand: str) -> int:
        def clean(s):
            # 消除桌面上需要消除的球
            n = 1
            while n:
                s, n = re.subn(r"(.)\1{2,}", "", s)
            return s

        hand = "".join(sorted(hand))

        # 初始化用队列维护的状态队列：其中的三个元素分别为桌面球状态、手中球状态和回合数
        queue = deque([(board, hand, 0)])

        # 初始化用哈希集合维护的已访问过的状态
        visited = {(board, hand)}

        while queue:
            cur_board, cur_hand, step = queue.popleft()
            for i, j in product(range(len(cur_board) + 1), range(len(cur_hand))):
                # 第 1 个剪枝条件: 当前球的颜色和上一个球的颜色相同
                if j > 0 and cur_hand[j] == cur_hand[j - 1]:
                    continue

                # 第 2 个剪枝条件: 只在连续相同颜色的球的开头位置插入新球
                if i > 0 and cur_board[i - 1] == cur_hand[j]:
                    continue
                
                # 第 3 个剪枝条件: 只在以下两种情况放置新球
                choose = False
                #  - 第 1 种情况 : 当前球颜色与后面的球的颜色相同
                if i < len(cur_board) and cur_board[i] == cur_hand[j]:
                    choose = True
                #  - 第 2 种情况 : 当前后颜色相同且与当前颜色不同时候放置球
                if 0 < i < len(cur_board) and cur_board[i - 1] == cur_board[i] and cur_board[i - 1] != cur_hand[j]:
                    choose = True

                if choose:
                    new_board = clean(cur_board[:i] + cur_hand[j] + cur_board[i:])
                    new_hand = cur_hand[:j] + cur_hand[j + 1:]
                    if not new_board:
                        return step + 1
                    if (new_board, new_hand) not in visited:
                        queue.append((new_board, new_hand, step + 1))
                        visited.add((new_board, new_hand))

        return -1
```

```Java [sol1-Java]
class Solution {
    public int findMinStep(String board, String hand) {
        char[] arr = hand.toCharArray();
        Arrays.sort(arr);
        hand = new String(arr);

        // 初始化用队列维护的状态队列：其中的三个元素分别为桌面球状态、手中球状态和回合数
        Queue<State> queue = new ArrayDeque<State>();
        queue.offer(new State(board, hand, 0));

        // 初始化用哈希集合维护的已访问过的状态
        Set<String> visited = new HashSet<String>();
        visited.add(board + " " + hand);

        while (!queue.isEmpty()) {
            State state = queue.poll();
            String curBoard = state.board;
            String curHand = state.hand;
            int step = state.step;
            for (int i = 0; i <= curBoard.length(); ++i) {
                for (int j = 0; j < curHand.length(); ++j) {
                    // 第 1 个剪枝条件: 当前球的颜色和上一个球的颜色相同
                    if (j > 0 && curHand.charAt(j) == curHand.charAt(j - 1)) {
                        continue;
                    }

                    // 第 2 个剪枝条件: 只在连续相同颜色的球的开头位置插入新球
                    if (i > 0 && curBoard.charAt(i - 1) == curHand.charAt(j)) {
                        continue;
                    }

                    // 第 3 个剪枝条件: 只在以下两种情况放置新球
                    boolean choose = false;
                    //  - 第 1 种情况 : 当前球颜色与后面的球的颜色相同
                    if (i < curBoard.length() && curBoard.charAt(i) == curHand.charAt(j)) {
                        choose = true;
                    }
                    //  - 第 2 种情况 : 当前后颜色相同且与当前颜色不同时候放置球
                    if (i > 0 && i < curBoard.length() && curBoard.charAt(i - 1) == curBoard.charAt(i) && curBoard.charAt(i - 1) != curHand.charAt(j)) {
                        choose = true;
                    }

                    if (choose) {
                        String newBoard = clean(curBoard.substring(0, i) + curHand.charAt(j) + curBoard.substring(i));
                        String newHand = curHand.substring(0, j) + curHand.substring(j + 1);
                        if (newBoard.length() == 0) {
                            return step + 1;
                        }
                        String str = newBoard + " " + newHand;
                        if (visited.add(str)) {
                            queue.offer(new State(newBoard, newHand, step + 1));
                        }
                    }
                }
            }
        }
        return -1;
    }

    public String clean(String s) {
        StringBuffer sb = new StringBuffer();
        Deque<Character> letterStack = new ArrayDeque<Character>();
        Deque<Integer> countStack = new ArrayDeque<Integer>();
        
        for (int i = 0; i < s.length(); ++i) {
            char c = s.charAt(i);
            while (!letterStack.isEmpty() && c != letterStack.peek() && countStack.peek() >= 3) {
                letterStack.pop();
                countStack.pop();
            }
            if (letterStack.isEmpty() || c != letterStack.peek()) {
                letterStack.push(c);
                countStack.push(1);
            } else {
                countStack.push(countStack.pop() + 1);
            }
        }
        if (!countStack.isEmpty() && countStack.peek() >= 3) {
            letterStack.pop();
            countStack.pop();
        }
        while (!letterStack.isEmpty()) {
            char letter = letterStack.pop();
            int count = countStack.pop();
            for (int i = 0; i < count; ++i) {
                sb.append(letter);
            }
        }
        sb.reverse();
        return sb.toString();
    }
}

class State {
    String board;
    String hand;
    int step;

    public State(String board, String hand, int step) {
        this.board = board;
        this.hand = hand;
        this.step = step;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindMinStep(string board, string hand) {
        char[] arr = hand.ToCharArray();
        Array.Sort(arr);
        hand = new string(arr);

        // 初始化用队列维护的状态队列：其中的三个元素分别为桌面球状态、手中球状态和回合数
        Queue<State> queue = new Queue<State>();
        queue.Enqueue(new State(board, hand, 0));

        // 初始化用哈希集合维护的已访问过的状态
        ISet<string> visited = new HashSet<string>();
        visited.Add(board + "#" + hand);

        while (queue.Count > 0) {
            State state = queue.Dequeue();
            string curBoard = state.board;
            string curHand = state.hand;
            int step = state.step;
            for (int i = 0; i <= curBoard.Length; ++i) {
                for (int j = 0; j < curHand.Length; ++j) {
                    // 第 1 个剪枝条件: 当前球的颜色和上一个球的颜色相同
                    if (j > 0 && curHand[j] == curHand[j - 1]) {
                        continue;
                    }

                    // 第 2 个剪枝条件: 只在连续相同颜色的球的开头位置插入新球
                    if (i > 0 && curBoard[i - 1] == curHand[j]) {
                        continue;
                    }

                    // 第 3 个剪枝条件: 只在以下两种情况放置新球
                    //  - 第 1 种情况 : 当前球颜色与后面的球的颜色相同
                    //  - 第 2 种情况 : 当前后颜色相同且与当前颜色不同时候放置球
                    bool choose = false;
                    if (i > 0 && i < curBoard.Length && curBoard[i - 1] == curBoard[i] && curBoard[i - 1] != curHand[j]) {
                        choose = true;
                    }
                    if (i < curBoard.Length && curBoard[i] == curHand[j]) {
                        choose = true;
                    }

                    if (choose) {
                        string newBoard = Clean(curBoard.Substring(0, i) + curHand[j] + curBoard.Substring(i));
                        string newHand = curHand.Substring(0, j) + curHand.Substring(j + 1);
                        if (newBoard.Length == 0) {
                            return step + 1;
                        }
                        string str = newBoard + "#" + newHand;
                        if (visited.Add(str)) {
                            queue.Enqueue(new State(newBoard, newHand, step + 1));
                        }
                    }
                }
            }
        }
        return -1;
    }

    public string Clean(string s) {
        StringBuilder sb = new StringBuilder();
        Stack<char> letterStack = new Stack<char>();
        Stack<int> countStack = new Stack<int>();
        
        foreach (char c in s) {
            while (letterStack.Count > 0 && c != letterStack.Peek() && countStack.Peek() >= 3) {
                letterStack.Pop();
                countStack.Pop();
            }
            if (letterStack.Count == 0 || c != letterStack.Peek()) {
                letterStack.Push(c);
                countStack.Push(1);
            } else {
                countStack.Push(countStack.Pop() + 1);
            }
        }
        if (countStack.Count > 0 && countStack.Peek() >= 3) {
            letterStack.Pop();
            countStack.Pop();
        }
        while (letterStack.Count > 0) {
            char letter = letterStack.Pop();
            int count = countStack.Pop();
            for (int i = 0; i < count; ++i) {
                sb.Append(letter);
            }
        }
        StringBuilder res = new StringBuilder();
        for (int i = sb.Length - 1; i >= 0; --i) {
            res.Append(sb[i]);
        }
        return res.ToString();
    }
}

class State {
    public string board;
    public string hand;
    public int step;

    public State(string board, string hand, int step) {
        this.board = board;
        this.hand = hand;
        this.step = step;
    }
}
```

```JavaScript [sol1-JavaScript]
var findMinStep = function(board, hand) {
    hand = Array.from(hand).sort().join('');

    // 初始化用队列维护的状态队列：其中的三个元素分别为桌面球状态、手中球状态和回合数
    const queue = [];
    queue.push([board, hand, 0]);

    // 初始化用哈希集合维护的已访问过的状态
    const visited = new Set();
    visited.add(board + "#" + hand);

    while (queue.length) {
        const [curBoard, curHand, step]= queue.shift();
        for (let i = 0; i <= curBoard.length; ++i) {
            for (let j = 0; j < curHand.length; ++j) {
                // 第 1 个剪枝条件: 当前球的颜色和上一个球的颜色相同
                if (j > 0 && curHand[j] === curHand[j - 1]) {
                    continue;
                }

                // 第 2 个剪枝条件: 只在连续相同颜色的球的开头位置插入新球
                if (i > 0 && curBoard[i - 1] === curHand[j]) {
                    continue;
                }

                // 第 3 个剪枝条件: 只在以下两种情况放置新球
                let choose = false;
                //  - 第 1 种情况 : 当前球颜色与后面的球的颜色相同
                if (i < curBoard.length && curBoard[i] === curHand[j]) {
                    choose = true;
                }
                //  - 第 2 种情况 : 当前后颜色相同且与当前颜色不同时候放置球
                if (i > 0 && i < curBoard.length && curBoard[i - 1] === curBoard[i] && curBoard[i - 1] !== curHand[j]) {
                    choose = true;
                }
                

                if (choose) {
                    const newBoard = clean(curBoard.substring(0, i) + curHand[j] + curBoard.substring(i));
                    const newHand = curHand.substring(0, j) + curHand.substring(j + 1);
                    if (newBoard.length === 0) {
                        return step + 1;
                    }
                    const str = newBoard + "#" + newHand;
                    if (visited.add(str)) {
                        queue.push([newBoard, newHand, step + 1]);
                    }
                }
            }
        }
    }
    return -1;
};

const clean = (s) => {
    let prev = "";
    while (s !== prev) {
        let sb = [];
        let consecutive = 1;
        for (let i = 0; i < s.length; ++i) {
            const c = s[i];
            if (i > 0) {
                if (c === s[i - 1]) {
                    ++consecutive;
                } else {
                    if (consecutive >= 3) {
                        sb = sb.slice(0, sb.length - consecutive);
                    }
                    consecutive = 1;
                }
            }
            sb.push(c);
        }
        if (consecutive >= 3) {
            sb = sb.slice(0, sb.length - consecutive);
        }
        prev = s;
        s = sb.join('');
    }
    return s;
}
```

```C++ [sol1-C++]
struct State {
    string board;
    string hand;
    int step;
    State(const string & board, const string & hand, int step) {
        this->board = board;
        this->hand = hand;
        this->step = step;
    }
};

class Solution {
public:
    string clean(const string & s) {
        string res;
        vector<pair<char, int>> st;
        
        for (auto c : s) {
            while (!st.empty() && c != st.back().first && st.back().second >= 3) {
                st.pop_back();
            }
            if (st.empty() || c != st.back().first) {
                st.push_back({c,1});
            } else {
                st.back().second++;
            }
        }
        if (!st.empty() && st.back().second >= 3) {
            st.pop_back();
        }
        for (int i = 0; i < st.size(); ++i) {
            for (int j = 0; j < st[i].second; ++j) {
                res.push_back(st[i].first);
            }
        }
        return res;
    }

    int findMinStep(string board, string hand) {
        unordered_set<string> visited;
        sort(hand.begin(), hand.end());

        visited.insert(board + " " + hand);
        queue<State> qu;
        qu.push(State(board, hand, 0));
        while (!qu.empty()) {
            State curr = qu.front();
            qu.pop();

            for (int j = 0; j < curr.hand.size(); ++j) {
                // 第 1 个剪枝条件: 当前选择的球的颜色和前一个球的颜色相同
                if (j > 0 && curr.hand[j] == curr.hand[j - 1]) {
                    continue;
                }
                for (int i = 0; i <= curr.board.size(); ++i) {
                    // 第 2 个剪枝条件: 只在连续相同颜色的球的开头位置插入新球
                    if (i > 0 && curr.board[i - 1] == curr.hand[j]) {
                        continue;
                    }

                    // 第 3 个剪枝条件: 只在以下两种情况放置新球
                    bool choose = false;
                    //   第 1 种情况 : 当前球颜色与后面的球的颜色相同
                    if (i < curr.board.size() && curr.board[i] == curr.hand[j]) {
                        choose = true;
                    }  
                    //   第 2 种情况 : 当前后颜色相同且与当前颜色不同时候放置球
                    if (i > 0 && i < curr.board.size() && curr.board[i - 1] == curr.board[i] && curr.board[i] != curr.hand[j]){
                        choose = true;
                    }
                    if (choose) {
                        string new_board = clean(curr.board.substr(0, i) + curr.hand[j] + curr.board.substr(i));
                        string new_hand = curr.hand.substr(0, j) + curr.hand.substr(j + 1);
                        if (new_board.size() == 0) {
                            return curr.step + 1;
                        }
                        if (!visited.count(new_board + " " + new_hand)) {
                            qu.push(State(new_board, new_hand, curr.step + 1));
                            visited.insert(new_board + " " + new_hand);
                        }
                    }
                }
            }
        }

        return -1;  
    }
};
```
**复杂度分析**

- 时间复杂度：$O(m \times n \times A_{n+m}^{m})$，其中 $n$ 为桌面上球的数量，$m$ 为手中球的数量。对 $m$ 个球总共有 $m!$ 种选择顺序，插入后桌面上最多有 $m+n$ 个球，根据排列组合原理插入 $m$ 个球的方案数为 $C_{n+m}^{m}$，实际计算过程中最多有 $O(m! \times C_{n+m}^{n}) = A_{n+m}^{m}$ 种状态；每种状态需要 $O(m \times n)$ 来考虑所有插入球的方案，并需要 $O(n)$ 来消除桌面上连续的球。

- 空间复杂度：$O((n+m) \times A_{n+m}^{m})$。我们需要存储 $O(A_{n+m}^{m})$ 种状态；每种状态需要存储 $n$ 个桌面上的球的状态和 $m$ 个手中球的状态。

#### 方法二：记忆化搜索

**思路**

记忆化搜索的核心思想跟方法一类似，核心思想还是搜索所有可能插入方案，找到最少的插入方案。每次尝试选择一个手中的球将其插入到桌面上的任意两球之间，然后对桌面上的球进行检测并对连续相同颜色的球进行消除，然后依次再进行插入和消除，直到桌面上的球全部消除或者手中的球全部插入后桌面上的球也无法消除为止。假设当前桌面上有 $n$ 个球，手中持有 $m$ 个球，则此时一共有 $C_{m+n}^{n} \times m! = A_{n+m}^{m}$ 种插入方法，如果我们直接进行搜索所有的插入方法的话会超时，因此实际进行记忆化搜索时需要进行剪枝，剪枝的策略跟方法一类似，当然实际中有很多可以进行剪枝的技巧。比如以下几个与方法一相同的减枝技巧：
- 第 $1$ 个剪枝条件：手中颜色相同的球只需要考虑其中一个即可。
- 第 $2$ 个剪枝条件：只在连续相同颜色的球的开头位置或者结尾位置插入新的颜色相同的球。
- 第 $3$ 个剪枝条件：只考虑放置新球后有可能得到更优解的位置。
- 第 $4$ 个剪枝条件：对于如果手中的球全部插入也无法满足新的消除，则我们直接进行中止。

**代码**

```Python [sol2-Python3]
import re
from functools import lru_cache
from itertools import product

class Solution:
    def findMinStep(self, board: str, hand: str) -> int:
        ans = self.dfs(board, "".join(sorted(hand)))
        return ans if ans <= 5 else -1

    @lru_cache(None)
    def dfs(self, cur_board: str, cur_hand: str):
        if not cur_board:
            return 0
        
        res = 6
        for i, j in product(range(len(cur_board) + 1), range(len(cur_hand))):
            # 第 1 个剪枝条件: 手中颜色相同的球只需要考虑其中一个即可
            if j > 0 and cur_hand[j] == cur_hand[j - 1]:
                continue

            # 第 2 个剪枝条件: 只在连续相同颜色的球的开头位置插入新球
            if i > 0 and cur_board[i - 1] == cur_hand[j]:
                continue

            # 第 3 个剪枝条件: 只考虑放置新球后有可能得到更优解的位置
            choose = False
            #  - 第 1 种情况 : 当前球颜色与后面的球的颜色相同
            if i < len(cur_board) and cur_board[i] == cur_hand[j]:
                choose = True
            #  - 第 2 种情况 : 当前后颜色相同且与当前颜色不同时候放置球
            if 0 < i < len(cur_board) and cur_board[i - 1] == cur_board[i] and cur_board[i - 1] != cur_hand[j]:
                choose = True
            
            if choose:
                new_board = self.clean(cur_board[:i] + cur_hand[j] + cur_board[i:])
                new_hand = cur_hand[:j] + cur_hand[j + 1:]
                res = min(res, self.dfs(new_board, new_hand) + 1)
        return res

    @staticmethod
    def clean(s):
        n = 1
        while n:
            s, n = re.subn(r'(.)\1{2,}', '', s)
        return s
```

```Java [sol2-Java]
class Solution {
    Map<String, Integer> dp = new HashMap<String, Integer>();

    public int findMinStep(String board, String hand) {
        char[] arr = hand.toCharArray();
        Arrays.sort(arr);
        hand = new String(arr);
        int ans = dfs(board, hand);
        return ans <= 5 ? ans : -1;
    }

    public int dfs(String board, String hand) {
        if (board.length() == 0) {
            return 0;
        }
        String key = board + " " + hand;
        if (!dp.containsKey(key)) {
            int res = 6;
            for (int j = 0; j < hand.length(); ++j) {
                // 第 1 个剪枝条件: 当前球的颜色和上一个球的颜色相同
                if (j > 0 && hand.charAt(j) == hand.charAt(j - 1)) {
                    continue;
                }
                for (int i = 0; i <= board.length(); ++i) {
                    // 第 2 个剪枝条件: 只在连续相同颜色的球的开头位置插入新球
                    if (i > 0 && board.charAt(i - 1) == hand.charAt(j)) {
                        continue;
                    }

                    // 第 3 个剪枝条件: 只在以下两种情况放置新球
                    boolean choose = false;
                    //  - 第 1 种情况 : 当前球颜色与后面的球的颜色相同
                    if (i < board.length() && board.charAt(i) == hand.charAt(j)) {
                        choose = true;
                    }
                    //  - 第 2 种情况 : 当前后颜色相同且与当前颜色不同时候放置球
                    if (i > 0 && i < board.length() && board.charAt(i - 1) == board.charAt(i) && board.charAt(i - 1) != hand.charAt(j)) {
                        choose = true;
                    }

                    if (choose) {
                        String newBoard = clean(board.substring(0, i) + hand.charAt(j) + board.substring(i));
                        String newHand = hand.substring(0, j) + hand.substring(j + 1);
                        res = Math.min(res, dfs(newBoard, newHand) + 1);
                    }
                }
            }
            dp.put(key, res);
        }
        return dp.get(key);
    }

    public String clean(String s) {
        StringBuffer sb = new StringBuffer();
        Deque<Character> letterStack = new ArrayDeque<Character>();
        Deque<Integer> countStack = new ArrayDeque<Integer>();
        
        for (int i = 0; i < s.length(); ++i) {
            char c = s.charAt(i);
            while (!letterStack.isEmpty() && c != letterStack.peek() && countStack.peek() >= 3) {
                letterStack.pop();
                countStack.pop();
            }
            if (letterStack.isEmpty() || c != letterStack.peek()) {
                letterStack.push(c);
                countStack.push(1);
            } else {
                countStack.push(countStack.pop() + 1);
            }
        }
        if (!countStack.isEmpty() && countStack.peek() >= 3) {
            letterStack.pop();
            countStack.pop();
        }
        while (!letterStack.isEmpty()) {
            char letter = letterStack.pop();
            int count = countStack.pop();
            for (int i = 0; i < count; ++i) {
                sb.append(letter);
            }
        }
        sb.reverse();
        return sb.toString();
    }
}

class State {
    String board;
    String hand;
    int step;

    public State(String board, String hand, int step) {
        this.board = board;
        this.hand = hand;
        this.step = step;
    }
}
```

```C# [sol2-C#]
public class Solution {
    Dictionary<string, int> dp = new Dictionary<string, int>();

    public int FindMinStep(string board, string hand) {
        char[] arr = hand.ToCharArray();
        Array.Sort(arr);
        hand = new string(arr);
        int ans = DFS(board, hand);
        return ans <= 5 ? ans : -1;
    }

    public int DFS(string board, string hand) {
        if (board.Length == 0) {
            return 0;
        }
        string key = board + " " + hand;
        if (!dp.ContainsKey(key)) {
            int res = 6;
            for (int j = 0; j < hand.Length; ++j) {
                // 第 1 个剪枝条件: 当前球的颜色和上一个球的颜色相同
                if (j > 0 && hand[j] == hand[j - 1]) {
                    continue;
                }
                for (int i = 0; i <= board.Length; ++i) {
                    // 第 2 个剪枝条件: 只在连续相同颜色的球的开头位置插入新球
                    if (i > 0 && board[i - 1] == hand[j]) {
                        continue;
                    }

                    // 第 3 个剪枝条件: 只在以下两种情况放置新球
                    bool choose = false;
                    //  - 第 1 种情况 : 当前球颜色与后面的球的颜色相同
                    if (i < board.Length && board[i] == hand[j]) {
                        choose = true;
                    }
                    //  - 第 2 种情况 : 当前后颜色相同且与当前颜色不同时候放置球
                    if (i > 0 && i < board.Length && board[i - 1] == board[i] && board[i - 1] != hand[j]) {
                        choose = true;
                    }

                    if (choose) {
                        String newBoard = Clean(board.Substring(0, i) + hand[j] + board.Substring(i));
                        String newHand = hand.Substring(0, j) + hand.Substring(j + 1);
                        res = Math.Min(res, DFS(newBoard, newHand) + 1);
                    }
                }
            }
            dp.Add(key, res);
        }
        return dp[key];
    }

    public string Clean(string s) {
        StringBuilder sb = new StringBuilder();
        Stack<char> letterStack = new Stack<char>();
        Stack<int> countStack = new Stack<int>();
        
        foreach (char c in s) {
            while (letterStack.Count > 0 && c != letterStack.Peek() && countStack.Peek() >= 3) {
                letterStack.Pop();
                countStack.Pop();
            }
            if (letterStack.Count == 0 || c != letterStack.Peek()) {
                letterStack.Push(c);
                countStack.Push(1);
            } else {
                countStack.Push(countStack.Pop() + 1);
            }
        }
        if (countStack.Count > 0 && countStack.Peek() >= 3) {
            letterStack.Pop();
            countStack.Pop();
        }
        while (letterStack.Count > 0) {
            char letter = letterStack.Pop();
            int count = countStack.Pop();
            for (int i = 0; i < count; ++i) {
                sb.Append(letter);
            }
        }
        StringBuilder res = new StringBuilder();
        for (int i = sb.Length - 1; i >= 0; --i) {
            res.Append(sb[i]);
        }
        return res.ToString();
    }
}

class State {
    public string board;
    public string hand;
    public int step;

    public State(string board, string hand, int step) {
        this.board = board;
        this.hand = hand;
        this.step = step;
    }
}
```

```C++ [sol2-C++]
struct State {
    string board;
    string hand;
    int step;
    State(const string & board, const string & hand, int step) {
        this->board = board;
        this->hand = hand;
        this->step = step;
    }
};

class Solution {
public:
    unordered_map<string, int> dp;
    string clean(const string & s) {
        string res;
        vector<pair<char, int>> st;
        
        for (auto c : s) {
            while (!st.empty() && c != st.back().first && st.back().second >= 3) {
                st.pop_back();
            }
            if (st.empty() || c != st.back().first) {
                st.push_back({c,1});
            } else {
                st.back().second++;
            }
        }
        if (!st.empty() && st.back().second >= 3) {
            st.pop_back();
        }
        for (int i = 0; i < st.size(); ++i) {
            for (int j = 0; j < st[i].second; ++j) {
                res.push_back(st[i].first);
            }
        }
        return res;
    }

    int dfs(const string & board, const string & hand) {
        if (board.size() == 0) {
            return 0;
        }
        if (dp.count(board + " " + hand)) {
            return dp[board + " " + hand];
        }

        int res = 6;
        for (int j = 0; j < hand.size(); ++j) {
            // 第 1 个剪枝条件: 当前选择的球的颜色和前一个球的颜色相同
            if (j > 0 && hand[j] == hand[j - 1]) {
                continue;
            }
            for (int i = 0; i <= board.size(); ++i) {
                // 第 2 个剪枝条件: 只在连续相同颜色的球的开头位置插入新球
                if (i > 0 && board[i - 1] == hand[j]) {
                    continue;
                }
                bool choose = false;
                // 第 3 个剪枝条件: 只在以下两种情况放置新球
                //   第 1 种情况 : 当前球颜色与后面的球的颜色相同
                if (i < board.size() && board[i] == hand[j]) {
                    choose = true;
                }  
                //   第 2 种情况 : 当前后颜色相同且与当前颜色不同时候放置球
                if (i > 0 && i < board.size() && board[i - 1] == board[i] && board[i] != hand[j]){
                    choose = true;
                }
                if (choose) {
                    string new_board = clean(board.substr(0, i) + hand[j] + board.substr(i));
                    string new_hand = hand.substr(0, j) + hand.substr(j + 1);
                    res = min(res, dfs(new_board, new_hand) + 1);
                }
            }
        }
        dp[board + " " + hand] = res;
        return res;
    }

    int findMinStep(string board, string hand) {
        sort(hand.begin(), hand.end());
        int ans = dfs(board, hand);
        return ans <= 5 ? ans : -1;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(m \times n \times A_{n+m}^{m})$，其中 $n$ 为桌面上球的数量，$m$ 为手中球的数量。我们需要考虑实际计算过程中最多有 $O(A_{n+m}^{m})$ 种状态；每种状态需要 $O(m \times n)$ 来考虑所有插入球的方案，并需要 $O(n)$ 来消除桌面上连续的球。

- 空间复杂度：$O((n+m) \times A_{n+m}^{m})$，其中 $n$ 为桌面上球的数量，$m$ 为手中球的数量。我们需要存储 $O(A_{n+m}^{m})$ 种状态；每种状态需要存储 $n$ 个桌面上的球的状态和 $m$ 个手中球的状态，此外还需要考虑到递归需要耗费栈的空间，我们可以知道递归深度为 $m$，因此总的空间复杂度为 $O(m + (n+m) \times A_{n+m}^{m}) = O((n+m) \times A_{n+m}^{m})$。