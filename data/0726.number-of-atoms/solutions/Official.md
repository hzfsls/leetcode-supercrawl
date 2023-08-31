## [726.原子的数量 中文官方题解](https://leetcode.cn/problems/number-of-atoms/solutions/100000/yuan-zi-de-shu-liang-by-leetcode-solutio-54lv)

#### 方法一：栈 + 哈希表

对于括号序列相关的题目，通用的解法是使用递归或栈。本题中我们将使用栈解决。

从左到右遍历该化学式，并使用哈希表记录当前层遍历到的原子及其数量，因此初始时需将一个空的哈希表压入栈中。对于当前遍历的字符：

- 如果是左括号，将一个空的哈希表压入栈中，进入下一层。

- 如果不是括号，则读取一个原子名称，若后面还有数字，则读取一个数字，否则将该原子后面的数字视作 $1$。然后将原子及数字加入栈顶的哈希表中。

- 如果是右括号，则说明遍历完了当前层，若括号右侧还有数字，则读取该数字 $\textit{num}$，否则将该数字视作 $1$。然后将栈顶的哈希表弹出，将弹出的哈希表中的原子数量与 $\textit{num}$ 相乘，加到上一层的原子数量中。

遍历结束后，栈顶的哈希表即为化学式中的原子及其个数。遍历哈希表，取出所有「原子-个数」对加入数组中，对数组按照原子字典序排序，然后遍历数组，按题目要求拼接成答案。

```C++ [sol1-C++]
class Solution {
public:
    string countOfAtoms(string formula) {
        int i = 0, n = formula.length();

        auto parseAtom = [&]() -> string {
            string atom;
            atom += formula[i++]; // 扫描首字母
            while (i < n && islower(formula[i])) {
                atom += formula[i++]; // 扫描首字母后的小写字母
            }
            return atom;
        };

        auto parseNum = [&]() -> int {
            if (i == n || !isdigit(formula[i])) {
                return 1; // 不是数字，视作 1
            }
            int num = 0;
            while (i < n && isdigit(formula[i])) {
                num = num * 10 + int(formula[i++] - '0'); // 扫描数字
            }
            return num;
        };

        stack<unordered_map<string, int>> stk;
        stk.push({});
        while (i < n) {
            char ch = formula[i];
            if (ch == '(') {
                i++;
                stk.push({}); // 将一个空的哈希表压入栈中，准备统计括号内的原子数量
            } else if (ch == ')') {
                i++;
                int num = parseNum(); // 括号右侧数字
                auto atomNum = stk.top();
                stk.pop(); // 弹出括号内的原子数量
                for (auto &[atom, v] : atomNum) {
                    stk.top()[atom] += v * num; // 将括号内的原子数量乘上 num，加到上一层的原子数量中
                }
            } else {
                string atom = parseAtom();
                int num = parseNum();
                stk.top()[atom] += num; // 统计原子数量
            }
        }

        auto &atomNum = stk.top();
        vector<pair<string, int>> pairs;
        for (auto &[atom, v] : atomNum) {
            pairs.emplace_back(atom, v);
        }
        sort(pairs.begin(), pairs.end());

        string ans;
        for (auto &p : pairs) {
            ans += p.first;
            if (p.second > 1) {
                ans += to_string(p.second);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    int i, n;
    String formula;

    public String countOfAtoms(String formula) {
        this.i = 0;
        this.n = formula.length();
        this.formula = formula;

        Deque<Map<String, Integer>> stack = new LinkedList<Map<String, Integer>>();
        stack.push(new HashMap<String, Integer>());
        while (i < n) {
            char ch = formula.charAt(i);
            if (ch == '(') {
                i++;
                stack.push(new HashMap<String, Integer>()); // 将一个空的哈希表压入栈中，准备统计括号内的原子数量
            } else if (ch == ')') {
                i++;
                int num = parseNum(); // 括号右侧数字
                Map<String, Integer> popMap = stack.pop(); // 弹出括号内的原子数量
                Map<String, Integer> topMap = stack.peek();
                for (Map.Entry<String, Integer> entry : popMap.entrySet()) {
                    String atom = entry.getKey();
                    int v = entry.getValue();
                    topMap.put(atom, topMap.getOrDefault(atom, 0) + v * num); // 将括号内的原子数量乘上 num，加到上一层的原子数量中
                }
            } else {
                String atom = parseAtom();
                int num = parseNum();
                Map<String, Integer> topMap = stack.peek();
                topMap.put(atom, topMap.getOrDefault(atom, 0) + num); // 统计原子数量
            }
        }

        Map<String, Integer> map = stack.pop();
        TreeMap<String, Integer> treeMap = new TreeMap<String, Integer>(map);

        StringBuffer sb = new StringBuffer();
        for (Map.Entry<String, Integer> entry : treeMap.entrySet()) {
            String atom = entry.getKey();
            int count = entry.getValue();
            sb.append(atom);
            if (count > 1) {
                sb.append(count);
            }
        }
        return sb.toString();
    }

    public String parseAtom() {
        StringBuffer sb = new StringBuffer();
        sb.append(formula.charAt(i++)); // 扫描首字母
        while (i < n && Character.isLowerCase(formula.charAt(i))) {
            sb.append(formula.charAt(i++)); // 扫描首字母后的小写字母
        }
        return sb.toString();
    }

    public int parseNum() {
        if (i == n || !Character.isDigit(formula.charAt(i))) {
            return 1; // 不是数字，视作 1
        }
        int num = 0;
        while (i < n && Character.isDigit(formula.charAt(i))) {
            num = num * 10 + formula.charAt(i++) - '0'; // 扫描数字
        }
        return num;
    }
}
```

```C# [sol1-C#]
public class Solution {
    int i, n;
    string formula;

    public string CountOfAtoms(string formula) {
        this.i = 0;
        this.n = formula.Length;
        this.formula = formula;
        Stack<Dictionary<string, int>> stack = new Stack<Dictionary<string, int>>();
        stack.Push(new Dictionary<string, int>());
        while (i < n) {
            char ch = formula[i];
            if (ch == '(') {
                i++;
                stack.Push(new Dictionary<string, int>()); // 将一个空的哈希表压入栈中，准备统计括号内的原子数量
            } else if (ch == ')') {
                i++;
                int num = ParseNum(); // 括号右侧数字
                Dictionary<string, int> popDictionary = stack.Pop(); // 弹出括号内的原子数量
                Dictionary<string, int> topDictionary = stack.Peek();
                foreach (KeyValuePair<string, int> pair in popDictionary) {
                    string atom = pair.Key;
                    int v = pair.Value;
                    // 将括号内的原子数量乘上 num，加到上一层的原子数量中
                    if (topDictionary.ContainsKey(atom)) {
                        topDictionary[atom] += v * num;
                    } else {
                        topDictionary.Add(atom, v * num);
                    }
                }
            } else {
                string atom = ParseAtom();
                int num = ParseNum();
                Dictionary<string, int> topDictionary = stack.Peek();
                // 统计原子数量
                if (topDictionary.ContainsKey(atom)) {
                    topDictionary[atom] += num;
                } else {
                    topDictionary.Add(atom, num);
                }
            }
        }

        Dictionary<string, int> dictionary = stack.Pop();
        List<KeyValuePair<string, int>> pairs = new List<KeyValuePair<string, int>>(dictionary);
        pairs.Sort((p1, p2) => p1.Key.CompareTo(p2.Key));

        StringBuilder sb = new StringBuilder();
        foreach (KeyValuePair<string, int> pair in pairs) {
            string atom = pair.Key;
            int count = pair.Value;
            sb.Append(atom);
            if (count > 1) {
                sb.Append(count);
            }
        }
        return sb.ToString();
    }

    public string ParseAtom() {
        StringBuilder sb = new StringBuilder();
        sb.Append(formula[i++]); // 扫描首字母
        while (i < n && char.IsLower(formula[i])) {
            sb.Append(formula[i++]); // 扫描首字母后的小写字母
        }
        return sb.ToString();
    }

    public int ParseNum() {
        if (i == n || !char.IsNumber(formula[i])) {
            return 1; // 不是数字，视作 1
        }
        int num = 0;
        while (i < n && char.IsNumber(formula[i])) {
            num = num * 10 + formula[i++] - '0'; // 扫描数字
        }
        return num;
    }
}
```

```go [sol1-Golang]
func countOfAtoms(formula string) string {
    i, n := 0, len(formula)

    parseAtom := func() string {
        start := i
        i++ // 扫描，跳过首字母
        for i < n && unicode.IsLower(rune(formula[i])) { 
            i++ // 扫描首字母后的小写字母
        }
        return formula[start:i]
    }

    parseNum := func() (num int) {
        if i == n || !unicode.IsDigit(rune(formula[i])) { 
            return 1 // 不是数字，视作 1
        }
        for ; i < n && unicode.IsDigit(rune(formula[i])); i++ { 
            num = num*10 + int(formula[i]-'0') // 扫描数字
        }
        return
    }

    stk := []map[string]int{{}}
    for i < n {
        if ch := formula[i]; ch == '(' {
            i++
            stk = append(stk, map[string]int{}) // 将一个空的哈希表压入栈中，准备统计括号内的原子数量
        } else if ch == ')' {
            i++
            num := parseNum() // 括号右侧数字
            atomNum := stk[len(stk)-1]
            stk = stk[:len(stk)-1] // 弹出括号内的原子数量
            for atom, v := range atomNum {
                stk[len(stk)-1][atom] += v * num // 将括号内的原子数量乘上 num，加到上一层的原子数量中
            }
        } else {
            atom := parseAtom()
            num := parseNum()
            stk[len(stk)-1][atom] += num // 统计原子数量
        }
    }

    atomNum := stk[0]
    type pair struct {
        atom string
        num  int
    }
    pairs := make([]pair, 0, len(atomNum))
    for k, v := range atomNum {
        pairs = append(pairs, pair{k, v})
    }
    sort.Slice(pairs, func(i, j int) bool { return pairs[i].atom < pairs[j].atom })

    ans := []byte{}
    for _, p := range pairs {
        ans = append(ans, p.atom...)
        if p.num > 1 {
            ans = append(ans, strconv.Itoa(p.num)...)
        }
    }
    return string(ans)
}
```

```JavaScript [sol1-JavaScript]
var countOfAtoms = function(formula) {
    let i = 0;
    const n = formula.length;

    const stack = [new Map()];
    while (i < n) {
        const ch = formula[i];

        const parseAtom = () => {
            const sb = [];
            sb.push(formula[i++]); // 扫描首字母
            while (i < n && formula[i] >= 'a' && formula[i] <= 'z') {
                sb.push(formula[i++]); // 扫描首字母后的小写字母
            }
            return sb.join('');
        }

        const parseNum = () => {
            if (i === n || isNaN(Number(formula[i]))) {
                return 1; // 不是数字，视作 1
            }
            let num = 0;
            while (i < n && !isNaN(Number(formula[i]))) {
                num = num * 10 + formula[i++].charCodeAt() - '0'.charCodeAt(); // 扫描数字
            }
            return num;
        }

        if (ch === '(') {
            i++;
            stack.unshift(new Map()); // 将一个空的哈希表压入栈中，准备统计括号内的原子数量
        } else if (ch === ')') {
            i++;
            const num = parseNum(); // 括号右侧数字
            const popMap = stack.shift(); // 弹出括号内的原子数量
            const topMap = stack[0];
            for (const [atom, v] of popMap.entries()) {
                topMap.set(atom, (topMap.get(atom) || 0) + v * num); // 将括号内的原子数量乘上 num，加到上一层的原子数量中
            }
        } else {
            const atom = parseAtom();
            const num = parseNum();
            const topMap = stack[0];
            topMap.set(atom, (topMap.get(atom) || 0) + num); // 统计原子数量
            
        }
    }

    let map = stack.pop();
    map = Array.from(map);
    map.sort();
    const sb = [];
    for (const [atom, count] of map) {
        sb.push(atom);
        if (count > 1) {
            sb.push(count);
        }
    }
    return sb.join('');
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$。其中 $n$ 是化学式 $\textit{formula}$ 的长度。
  最坏情况下栈有 $O(n)$ 层，每次出栈时需要更新 $O(n)$ 个原子的数量，因此遍历化学式的时间复杂度为 $O(n^2)$。
  遍历结束后排序的时间复杂度为 $O(n\log n)$。
  因此总的时间复杂度为 $O(n^2+n\log n)=O(n^2)$。

- 空间复杂度：$O(n)$。空间复杂度取决于栈中所有哈希表中的元素个数之和，而这不会超过化学式 $\textit{formula}$ 的长度，因此空间复杂度为 $O(n)$。