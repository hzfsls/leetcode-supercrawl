#### 方法 1: 深度优先搜索 [Time Limit Exceed]
考虑最直观的解法：直接生成所有可能的答案并比较。首先我们要得出字符串反转能得到的所有字符串。所有可能的反转情况如下图中的树所示，树中的叶子结点即为我们要得到的所有字符串。
我们定义一个递归函数 `dfs` 来搜索此树的叶子结点。`dfs` 以所有还没有考虑过的字符串的列表 `strs` 为参数。

  * 若 `strs` 不为空，考虑第一个字符串 `strs[0]`，分别选择反转或者不反转，递归求解两个子结点的解。
  * 若 `strs` 为空，说明已经处于叶子结点。此时已经得到一个字符串解。对于这一个字符串，我们需要考虑从它中间的任意一个位置开始循环的情况，只要遍历所有可能的循环开始位置，组成字符串并比较即可。

下面的动画说明了这一方法是怎么工作的：

<![image.png](https://pic.leetcode-cn.com/81ed9fbc7d265190de302ac45ac4867988409a36bce3d83bbb4dbd3b41e63296-image.png),![image.png](https://pic.leetcode-cn.com/eae61bd68ccb8e3bda0d99b4beb2d10e644c8ecd741fde75d65e9217c12792ac-image.png),![image.png](https://pic.leetcode-cn.com/3143d21d8c18c49f027e2b4441e41ea5d13d9a353c1c4fc6212feaeecdd0ddd8-image.png),![image.png](https://pic.leetcode-cn.com/986b11cc3529b03370121d93a047a8a1957d33cf5aa37eb4288a2174a2332559-image.png),![image.png](https://pic.leetcode-cn.com/a465e8b5440b963138b915972db0d789ede38018d3271c176b39573ad4ef2045-image.png),![image.png](https://pic.leetcode-cn.com/66386384eeb7d6abc010aa2f338799e74c26edf683ed61d8734b298c3f698bf1-image.png),![image.png](https://pic.leetcode-cn.com/1ba4ea119cd39dd17afd48c5e1cdbf42733a18e2327a0e0af0bff161f49d8997-image.png),![image.png](https://pic.leetcode-cn.com/0b365f0dc4056e5caff73cb66070d35122047b53d3a605febe54e4500b05e40e-image.png),![image.png](https://pic.leetcode-cn.com/a8ed2307a23ff926aa5481035508235971400dce11e52adb718c21257671c1fb-image.png),![image.png](https://pic.leetcode-cn.com/e7d452b2c1c982286e9089ee1220ea7059127c0c03d79705bf40fa8f1adeade6-image.png),![image.png](https://pic.leetcode-cn.com/76c6642f836a3e865dd7261daa786fff98f5eb94756a1965061e6243e331337e-image.png),![image.png](https://pic.leetcode-cn.com/cdb7b6a2e3b5f088e5f1dac0d916a0fa74df8f2497e0ed51df5213ee0785b2ba-image.png),![image.png](https://pic.leetcode-cn.com/1c2c08c53960be2b3faf38fdb484b91f97b576079aeacdca44ed26954efaeb45-image.png),![image.png](https://pic.leetcode-cn.com/2644caf83025f87e01451ee8bbc34fb49d99b7bb80ec27085e951727fb8891d3-image.png),![image.png](https://pic.leetcode-cn.com/98f2a4331d2a2a4e6bf10ed19dd3206f3d67c0c1622b791ad1c824c7fac358e3-image.png)>

```python []
class Solution:
    def dfs(self, prefix, strs):
        if not strs:
            for i in range(len(prefix)):
                self.ans = max(self.ans, prefix[i:] + prefix[: i])
        else:
            self.dfs(prefix + strs[0], strs[1:])
            self.dfs(prefix + strs[0][::-1], strs[1:])

    def splitLoopedString(self, strs: List[str]) -> str:
        self.ans = ''
        self.dfs('', strs)
        return self.ans
```
```C++ []
class Solution {
    string ans{};
    void dfs(string prefix, vector<string>& strs, int cur_index) {
        if (cur_index == strs.size()) {
            for (auto i = prefix.begin(); i != prefix.end(); ++i) {
                string cur = string{i, prefix.end()} + string{prefix.begin(), i};
                ans = max(ans, cur);
            }
        } else {
            string cur_str = strs[cur_index];
            string next_prefix = prefix + cur_str;
            dfs(next_prefix, strs, cur_index + 1);
            next_prefix = prefix + string{cur_str.rbegin(), cur_str.rend()};
            dfs(next_prefix, strs, cur_index + 1);
        }
    }
public:
    string splitLoopedString(vector<string>& strs) {
        dfs(string{}, strs, 0);
        return ans;
    }
};
```

```Java []
class Solution {
    String ans = "";

    public void dfs(String prefix, String[] strs, int cur_index) {
        if (cur_index == strs.length) {
            for (int i = 0; i != prefix.length(); ++i) {
                String cur = prefix.substring(i) + prefix.substring(0, i);
                if (cur.compareTo(ans) > 0)
                    ans = cur;
            }
        } else {
            String cur_str = strs[cur_index];
            String next_prefix = prefix + cur_str;
            dfs(next_prefix, strs, cur_index + 1);
            next_prefix = prefix + new StringBuffer(cur_str).reverse().toString();
            dfs(next_prefix, strs, cur_index + 1);
        }
    }

    public String splitLoopedString(String[] strs) {
        dfs("", strs, 0);
        return ans;
    }
}
```

##### 复杂度分析
  * 时间复杂度：$O(2^{num}n^2)$，$num$ 为字符串个数，$n$ 为字符串总的字母个数。
    递归树的大小为 $O(2^{num})$。
    并且而对于每个叶子结点，我们需要进行一次 $O(n)$ 的遍历，遍历可能的循环起点。
    对于每个循环起点，我们需要将其对应的循环字符串与当前的最好答案进行一次 $O(n)$ 的比较。
    上述三层复杂度相乘得时间复杂度为 $O(2^{num}n^2)$。
  * 空间复杂度：$O(n*num)$，$n$ 为字符串总的字母个数，递归过程中递归栈的最大深度为 $num+1$。已知第一层存储字符串长度为 $0$，第二层存储字符串长度为 $len(s_1)$ ，第三层存储字符串长度为 $len(s_1)+len(s_2)$ （第二个字符串与第一个字符串拼接），...，第 ${num+1}$ 层存储字符串长度为 $len(s_1)+len(s_2)+\cdots +len(s_{num})=n$ , $len(s_i)$ 表示第 $i$ 个字符串的长度，则将这 $num+1$ 层字符串长度全部加起来即为深度优先搜索搜到叶子节点这过程中需要额外存储的空间了，简单将每一层的长度近似于 $n$ ，再乘以深度，可以知道约为 $O(n* num)$。


#### 方法 2：宽度优先搜索 [Memory Limit Exceeded]

找到所有的字符串也可以用宽度优先搜索的方法。我们用队列 $queue$ 维护当前为止在将下一个字符串或者下一个字符串反转后的字符串添加后的所有字符串。每次我们从头部删除一个字符串，我们在尾部添加 2 个字符串，一个是直接连接下一个字符串，另外一个是将下一个字符串反转后连接。

所有字符串被遍历并添加后，队列中总共会有 $O(2^n)$ 个字符串，对应着所有可能的字符串连接方案。我们对队列中每一个字符串都检查所有可能的切断位置。在这个过程中，我们记录一个字典序最大的字符串。

下面的动画说明了这一方法是怎么工作的：

<![image.png](https://pic.leetcode-cn.com/15f4e8f618dc08b3e1101ba418b4eb77510aae78483fef89e476ebbf1c09a919-image.png),![image.png](https://pic.leetcode-cn.com/cc6537196cd57bb28aad6715228f21d0220aac361ba5cdb48ad0df77d1075235-image.png),![image.png](https://pic.leetcode-cn.com/5c4f32260ab65a0e5d95bb55adaa8c8225d37991a18244026b0e06d45dff4d65-image.png),![image.png](https://pic.leetcode-cn.com/d85505b297617797563a6b705ccdf83a08111302bcdcad1f384ad34e3cc63988-image.png),![image.png](https://pic.leetcode-cn.com/65abaad0d13fb6bbe686a3114158eb6fae4870dc2cf5ed3c6f6ef29be0196219-image.png),![image.png](https://pic.leetcode-cn.com/7e6f1678fdef9da4f127162f76b735a834aafd70838a6f864b0618dff1792c87-image.png),![image.png](https://pic.leetcode-cn.com/4dc7aec358d15ffd8457f18d81772227e58d8dd7f510ea8330daff573e0f8235-image.png),![image.png](https://pic.leetcode-cn.com/0e0486fa2da432d1ec57d71d96841761bd8e86397cf05f5572c8b9c028f23472-image.png),![image.png](https://pic.leetcode-cn.com/6c89cc683baa8d820ddd535befa2a0542024b11447dd8138aea6bd9d274e28d9-image.png),![image.png](https://pic.leetcode-cn.com/91f9b0eb70a247b6e4a91800c07917e46cf582226ccc29ba95dc733fddc85cbe-image.png),![image.png](https://pic.leetcode-cn.com/a8cbcbfe4a12202c10afa8cb6d83f381fe919c0b054121bf8963b3127eb641d7-image.png),![image.png](https://pic.leetcode-cn.com/5cd0ba304ec82edffdc6aba8f70ec4bd840109175e99adebabcd1445ea470394-image.png),![image.png](https://pic.leetcode-cn.com/0039dc0bc3d2baf60b6f55ab2a6b5b7f6ecd65f06bfba7c17823b9a881a0f6a6-image.png),![image.png](https://pic.leetcode-cn.com/274fd0cb4b7b4d16845750db047a7debc6f9ba597f353e044f050b5980b294bb-image.png),![image.png](https://pic.leetcode-cn.com/2c6fed3fd897d06b72192621120cd6c193fa97a3b12cf3410f7801c4723e0a18-image.png)>

```python []
from queue import Queue

class Solution:
    def splitLoopedString(self, strs: List[str]) -> str:
        queue = Queue()
        res = ""
        i, j = 0, 0
        queue.put("")
        while i < len(strs):
            t = queue.get()
            queue.put(t + strs[i])
            queue.put(t + strs[i][::-1])
            j += 1
            if j == 1 << i:
                i += 1
                j = 0
        while not queue.empty():
            t = queue.get()
            for k in range(len(t)):
                t1 = t[k:] + t[: k]
                res = max(res, t1)
        return res
```
```Java []
public class Solution {

    public String splitLoopedString(String[] strs) {
        Queue < String > queue = new LinkedList < > ();
        String res = "";
        int i = 0, j = 0;
        queue.add("");
        while (i < strs.length) {
            String t = queue.remove();
            queue.add(t + strs[i]);
            queue.add(t + new StringBuffer(strs[i]).reverse().toString());
            j++;
            if (j == 1 << i) {
                i++;
                j = 0;
            }
        }
        while (!queue.isEmpty()) {
            String t = queue.remove();
            for (int k = 0; k < t.length(); k++) {
                String t1 = t.substring(k) + t.substring(0, k);
                if (t1.compareTo(res) > 0)
                    res = t1;
            }
        }
        return res;
    }
}
```
```C++ []
class Solution {
public:
    string splitLoopedString(vector<string>& strs) {
        queue<string> q{};
        string res{""};
        q.push("");
        int i = 0, j = 0;
        while (i < strs.size()) {
            string t = q.front();
            q.pop();
            q.push(t + strs[i]);
            q.push(t + string(strs[i].rbegin(), strs[i].rend()));
            ++j;
            if (j == 1 << i) {
                ++i;
                j = 0;
            }
        }
        while (!q.empty()) {
            string t{q.front()};
            q.pop();
            for (int k = 0; k < t.size(); ++k) {
                string t1 = t.substr(k) + t.substr(0, k);
                res = max(res, t1);
            }
        }
        return res;
    }
};
```

##### 复杂度分析
  * 时间复杂度：$O(2^{num}n^2)$，$num$ 为字符串个数，$n$ 为字符串总的字母个数。
    递归树的大小为 $O(2^{num})$。
    并且而对于每个叶子结点，我们需要进行一次 $O(n)$ 的遍历，遍历可能的循环起点。
    对于每个循环起点，我们需要将其对应的循环字符串与当前的最好答案进行一次 $O(n)$ 的比较。
    上述三层复杂度相乘得时间复杂度为 $O(2^{num}n^2)$。
  * 空间复杂度：$O(2^{num}n)$，$n$ 为字符串总的字母个数，遍历过程中队列最大可能达到 $O(2^num)$ 数量级，而队列的每一项是一个长度最大为 $n$ 的字符串，相乘可得空间复杂度为 $O(2^{num}n)$。


#### 方法 3：最优解法 [Accepeted]
观察问题的性质，可以发现，如果一个字符串的内部没有被作为循环的起点，那么可以直接确定它是否需要反转。
这一点很好证明：如果字符串 $s_i'$ 的字典序大于其反转字符串 $s_i$ 的字典序，那么对于任何一个包含 $s'$ 的字典序较大的字符串 $s_1s_2...s_i...s_n$，只要把其中的 $s_i'$ 反转，就可以得到一个字典序更大的字符串 $s_1s_2...s_i'...s_n$。
因此，可以先遍历一遍字符串列表，将每一个字符串 $s_i$ 替换为 $s_i$ 与 $s_i'$ 中的较大者。
对于上面的例子中的字符串列表
```
lc evol cdy
```
其中 `evol` 与 `cdy` 反转过后字典序更大。因此处理过后得到的列表为
```
lc love ydc
```
然后我们再遍历可能的循环起点。当我们遍历的循环起点在某个字符串 $s_i$ 内部时，需要分别尝试 $s_i$ 反转与不反转的情况。而其他所有的字符串 $s_1,s_2,...s_{i-1},s_{i+1},...s_n$ 只需要保持刚才处理得到的字典序最大的状态即可。

```python []
class Solution:
    def splitLoopedString(self, strs: List[str]) -> str:
        strs = [s[::-1] if s[::-1] > s else s for s in strs]
        ans = ''.join(strs)
        for i, s in enumerate(strs):
            other = ''.join(strs[i + 1:]) + ''.join(strs[: i])
            for j, _ in enumerate(s):
                head = s[j:]
                tail = s[: j]
                cur = head + other + tail
                ans = max(ans, cur)
                cur = tail[::-1] + other + head[::-1]
                ans = max(ans, cur)
        return ans
```
```C++ []
class Solution {
public:
    string splitLoopedString(vector<string>& strs) {
        for (auto i = strs.begin(); i != strs.end(); ++i) {
            string rev{i -> rbegin(), i -> rend()};
            if (rev > *i)
                *i = rev;
        }
        string ans{};
        for (auto i = strs.begin(); i != strs.end(); ++i) {
            string other{};
            for (auto j = i + 1; j != strs.end(); ++j)
                other += *j;
            for (auto j = strs.begin(); j != i; ++j)
                other += *j;
            for (auto j = i -> begin(); j != i -> end(); ++j) {
                string cur = string{j, i -> end()} + other + string{i -> begin(), j};
                ans = max(ans, cur);
            }
            for (auto j = i -> rbegin(); j != i -> rend(); ++j) {
                string cur = string{j, i -> rend()} + other + string{i -> rbegin(), j};
                ans = max(ans, cur);
            }
        }
        return ans;
    }
};
```
```Java []
class Solution {
    public String splitLoopedString(String[] strs) {
        for (int i = 0; i != strs.length; ++i) {
            String str = strs[i];
            String rev = new StringBuffer(str).reverse().toString();
            if (rev.compareTo(str) > 0)
                strs[i] = rev;
        }
        String ans = "";
        for (int i = 0; i != strs.length; ++i) {
            String str = strs[i];
            String rev = new StringBuffer(str).reverse().toString();
            String other = "";
            for (int j = i + 1; j != strs.length; ++j)
                other += strs[j];
            for (int j = 0; j != i; ++j)
                other += strs[j];
            for (int j = 0; j != str.length(); ++j) {
                String cur = str.substring(j) + other + str.substring(0, j);
                if (cur.compareTo(ans) > 0)
                    ans = cur;
            }
            for (int j = 0; j != str.length(); ++j) {
                String cur = rev.substring(j) + other + rev.substring(0, j);
                if (cur.compareTo(ans) > 0)
                    ans = cur;
            }
        }
        return ans;
    }
}
```

##### 复杂度分析
  * 时间复杂度：$O(n^2)$，$n$ 为字符串总的字母个数。
    我们需要遍历 $n$ 个循环起点，对于每个循环起点，需要对长度为 $n$ 的字符串进行比较。相乘得时间复杂度为 $O(n^2)$。
  * 空间复杂度：$O(n)$，$n$ 为字符串总的字母个数。
    程序运行过程中需要创建长度等于原字符串的临时变量用于对比。
