## [1418.点菜展示表 中文官方题解](https://leetcode.cn/problems/display-table-of-food-orders-in-a-restaurant/solutions/100000/dian-cai-zhan-shi-biao-by-leetcode-solution)
#### 方法一：哈希表

我们首先分析题目需要我们做些什么：

- 我们需要将订单信息进行汇总，存放在一张数据表中作为答案返回；
- 数据表的第一行包含了所有的餐品名称，并且需要按照餐品名称的字典序排序，因此我们需要遍历订单信息，获取所有的餐品名称并对它们进行排序；
- 数据表的第一列包含了所有的餐桌桌号，并且需要按照桌号排序，因此我们需要遍历订单信息，获取所有的桌号并对它们进行排序；
- 数据表中间包含的信息为「某一桌下单的某一道菜的数量」。

我们可以使用两个哈希表来保存订单中的数据：

- 哈希表 $\textit{nameSet}$ 保存所有的餐品名称；
- 哈希表 $\textit{foodsCnt}$ 保存桌号及该桌点餐数量，点餐数量也用一个哈希表保存。

遍历订单并保存信息后，从 $\textit{nameSet}$ 中提取餐品名称，并按字母顺序排列；从 $\textit{foodsCnt}$ 中提取桌号，并按桌号升序排列。然后将餐品名称和桌号分别填入点菜展示表的第一行和第一列。对于表中的餐品数量，我们逐行填入，对于每一行，我们遍历餐品名称，在 $\textit{foodsCnt}$ 中查找对应的点餐数量，然后填入表格中对应位置。

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<string>> displayTable(vector<vector<string>> &orders) {
        // 从订单中获取餐品名称和桌号，统计每桌点餐数量
        unordered_set<string> nameSet;
        unordered_map<int, unordered_map<string, int>> foodsCnt;
        for (auto &order : orders) {
            nameSet.insert(order[2]);
            int id = stoi(order[1]);
            ++foodsCnt[id][order[2]];
        }

        // 提取餐品名称，并按字母顺序排列
        int n = nameSet.size();
        vector<string> names;
        for (auto &name : nameSet) {
            names.push_back(name);
        }
        sort(names.begin(), names.end());

        // 提取桌号，并按餐桌桌号升序排列
        int m = foodsCnt.size();
        vector<int> ids;
        for (auto &[id, _] : foodsCnt) {
            ids.push_back(id);
        }
        sort(ids.begin(), ids.end());

        // 填写点菜展示表
        vector<vector<string>> table(m + 1, vector<string>(n + 1));
        table[0][0] = "Table";
        copy(names.begin(), names.end(), table[0].begin() + 1);
        for (int i = 0; i < m; ++i) {
            int id = ids[i];
            auto &cnt = foodsCnt[id];
            table[i + 1][0] = to_string(id);
            for (int j = 0; j < n; ++j) {
                table[i + 1][j + 1] = to_string(cnt[names[j]]);
            }
        }
        return table;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<List<String>> displayTable(List<List<String>> orders) {
        // 从订单中获取餐品名称和桌号，统计每桌点餐数量
        Set<String> nameSet = new HashSet<String>();
        Map<Integer, Map<String, Integer>> foodsCnt = new HashMap<Integer, Map<String, Integer>>();
        for (List<String> order : orders) {
            nameSet.add(order.get(2));
            int id = Integer.parseInt(order.get(1));
            Map<String, Integer> map = foodsCnt.getOrDefault(id, new HashMap<String, Integer>());
            map.put(order.get(2), map.getOrDefault(order.get(2), 0) + 1);
            foodsCnt.put(id, map);
        }

        // 提取餐品名称，并按字母顺序排列
        int n = nameSet.size();
        List<String> names = new ArrayList<String>();
        for (String name : nameSet) {
            names.add(name);
        }
        Collections.sort(names);

        // 提取桌号，并按餐桌桌号升序排列
        int m = foodsCnt.size();
        List<Integer> ids = new ArrayList<Integer>();
        for (int id : foodsCnt.keySet()) {
            ids.add(id);
        }
        Collections.sort(ids);

        // 填写点菜展示表
        List<List<String>> table = new ArrayList<List<String>>();
        List<String> header = new ArrayList<String>();
        header.add("Table");
        for (String name : names) {
            header.add(name);
        }
        table.add(header);
        for (int i = 0; i < m; ++i) {
            int id = ids.get(i);
            Map<String, Integer> cnt = foodsCnt.get(id);
            List<String> row = new ArrayList<String>();
            row.add(Integer.toString(id));
            for (int j = 0; j < n; ++j) {
                row.add(Integer.toString(cnt.getOrDefault(names.get(j), 0)));
            }
            table.add(row);
        }
        return table;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<IList<string>> DisplayTable(IList<IList<string>> orders) {
        // 从订单中获取餐品名称和桌号，统计每桌点餐数量
        ISet<string> nameSet = new HashSet<string>();
        Dictionary<int, Dictionary<string, int>> foodsCnt = new Dictionary<int, Dictionary<string, int>>();
        foreach (IList<string> order in orders) {
            nameSet.Add(order[2]);
            int id = int.Parse(order[1]);
            Dictionary<string, int> dictionary = foodsCnt.ContainsKey(id) ? foodsCnt[id] : new Dictionary<string, int>();
            if (dictionary.ContainsKey(order[2])) {
                ++dictionary[order[2]];
            } else {
                dictionary.Add(order[2], 1);
            }
            if (!foodsCnt.ContainsKey(id)) {
                foodsCnt.Add(id, dictionary);
            }
        }

        // 提取餐品名称，并按字母顺序排列
        int n = nameSet.Count;
        List<string> names = new List<string>();
        foreach (string name in nameSet) {
            names.Add(name);
        }
        names.Sort((a, b) => string.CompareOrdinal(a, b));

        // 提取桌号，并按餐桌桌号升序排列
        int m = foodsCnt.Count;
        List<int> ids = new List<int>();
        foreach (int id in foodsCnt.Keys) {
            ids.Add(id);
        }
        ids.Sort();

        // 填写点菜展示表
        IList<IList<string>> table = new List<IList<string>>();
        IList<string> header = new List<string>();
        header.Add("Table");
        foreach (string name in names) {
            header.Add(name);
        }
        table.Add(header);
        for (int i = 0; i < m; ++i) {
            int id = ids[i];
            Dictionary<string, int> cnt = foodsCnt[id];
            IList<string> row = new List<string>();
            row.Add(id.ToString());
            for (int j = 0; j < n; ++j) {
                int val = cnt.ContainsKey(names[j]) ? cnt[names[j]] : 0;
                row.Add(val.ToString());
            }
            table.Add(row);
        }
        return table;
    }
}
```

```go [sol1-Golang]
func displayTable(orders [][]string) [][]string {
    // 从订单中获取餐品名称和桌号，统计每桌点餐数量
    nameSet := map[string]struct{}{}
    foodsCnt := map[int]map[string]int{}
    for _, order := range orders {
        id, _ := strconv.Atoi(order[1])
        food := order[2]
        nameSet[food] = struct{}{}
        if foodsCnt[id] == nil {
            foodsCnt[id] = map[string]int{}
        }
        foodsCnt[id][food]++
    }

    // 提取餐品名称，并按字母顺序排列
    n := len(nameSet)
    names := make([]string, 0, n)
    for name := range nameSet {
        names = append(names, name)
    }
    sort.Strings(names)

    // 提取桌号，并按餐桌桌号升序排列
    m := len(foodsCnt)
    ids := make([]int, 0, m)
    for id := range foodsCnt {
        ids = append(ids, id)
    }
    sort.Ints(ids)

    // 填写点菜展示表
    table := make([][]string, m+1)
    table[0] = make([]string, 1, n+1)
    table[0][0] = "Table"
    table[0] = append(table[0], names...)
    for i, id := range ids {
        cnt := foodsCnt[id]
        table[i+1] = make([]string, n+1)
        table[i+1][0] = strconv.Itoa(id)
        for j, name := range names {
            table[i+1][j+1] = strconv.Itoa(cnt[name])
        }
    }
    return table
}
```

```JavaScript [sol1-JavaScript]
var displayTable = function(orders) {
    // 从订单中获取餐品名称和桌号，统计每桌点餐数量
    const nameSet = new Set();
    const foodsCnt = new Map();
    for (const order of orders) {
        nameSet.add(order[2]);
        const id = parseInt(order[1]);
        const map = foodsCnt.get(id) || new Map();
        map.set(order[2], (map.get(order[2]) || 0) + 1);
        foodsCnt.set(id, map);
    }

    // 提取餐品名称，并按字母顺序排列
    const n = nameSet.size;
    const names = [];
    for (const name of nameSet) {
        names.push(name);
    }
    names.sort();

    // 提取桌号，并按餐桌桌号升序排列
    const m = foodsCnt.size;
    const ids = [];
    for (const id of foodsCnt.keys()) {
        ids.push(id);
    }
    ids.sort((a, b) => a - b);

    // 填写点菜展示表
    const table = [];
    const header = [];
    header.push("Table");
    for (const name of names) {
        header.push(name);
    }
    table.push(header);
    for (let i = 0; i < m; ++i) {
        const id = ids[i];
        const cnt = foodsCnt.get(id);
        const row = [];
        row.push(id.toString());
        for (let j = 0; j < n; ++j) {
            row.push((cnt.get(names[j]) || 0).toString());
        }
        table.push(row);
    }
    return table;
};
```

**复杂度分析**

为了便于进行复杂度分析，我们将所有字符串长度均视作常数。

- 时间复杂度：$O(T + N\log N + M\log M + MN)$。其中 $T$ 是数组 $\textit{orders}$ 的长度，$N$ 是数据表的列数（即餐品的数量），$M$ 是数据表的行数（即餐桌的数量）。时间复杂度由以下几个部分组成：
    - 遍历订单并保存信息的时间复杂度为 $O(T)$；
    - 对餐品名称和餐桌编号分别进行排序，时间复杂度分别为 $O(N \log N)$ 和 $O(M \log M)$；
    - 将数据逐行填入表格，时间复杂度为 $O(MN)$。
- 空间复杂度：$O(T + N + M)$。注意这里只计算额外的空间复杂度，不计入存放最终数据表（即答案）需要的空间。