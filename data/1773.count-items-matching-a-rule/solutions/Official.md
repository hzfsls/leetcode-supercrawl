#### 方法一：模拟

**思路**

可以利用哈希表把输入 $\textit{ruleKey}$ 转换为 $\textit{items}[i]$ 的下标，然后再遍历一遍 $\textit{items}$，找出符合条件的物品数量。

**代码**

```Python [sol1-Python3]
class Solution:
    def countMatches(self, items: List[List[str]], ruleKey: str, ruleValue: str) -> int:
        index = {"type": 0, "color": 1, "name": 2}[ruleKey]
        return sum(item[index] == ruleValue for item in items)
```

```Java [sol1-Java]
class Solution {
    public int countMatches(List<List<String>> items, String ruleKey, String ruleValue) {
        int index = new HashMap<String, Integer>() {{
            put("type", 0);
            put("color", 1);
            put("name", 2);
        }}.get(ruleKey);
        int res = 0;
        for (List<String> item : items) {
            if (item.get(index).equals(ruleValue)) {
                res++;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountMatches(IList<IList<string>> items, string ruleKey, string ruleValue) {
        int index = new Dictionary<string, int>() {
            {"type", 0}, {"color", 1}, {"name", 2}
        }[ruleKey];
        int res = 0;
        foreach (IList<string> item in items) {
            if (item[index].Equals(ruleValue)) {
                res++;
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int countMatches(vector<vector<string>>& items, string ruleKey, string ruleValue) {
        unordered_map<string, int> dictionary = {{"type", 0}, {"color", 1}, {"name", 2}};
        int res = 0, index = dictionary[ruleKey];
        for (auto &&item : items) {
            if (item[index] == ruleValue) {
                res++;
            }
        }
        return res;
    }
};
```

```C [sol1-C]
int countMatches(char *** items, int itemsSize, int* itemsColSize, char * ruleKey, char * ruleValue) {   
    int res = 0, index = 0;
    if (strcmp(ruleKey, "type") == 0) {
        index = 0;
    } else if (strcmp(ruleKey, "color") == 0) {
        index = 1;
    } else if (strcmp(ruleKey, "name") == 0) {
        index = 2;
    }
    for (int i = 0; i < itemsSize; i++) {
        if (strcmp(items[i][index], ruleValue) == 0) {
            res++;
        }
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var countMatches = function(items, ruleKey, ruleValue) {
    const index = {"type":0, "color":1, "name":2}[ruleKey];
    let res = 0;
    for (const item of items) {
        if (item[index] === ruleValue) {
            res++;
        }
    }
    return res;
};
```

```go [sol1-Golang]
var d = map[string]int{"type": 0, "color": 1, "name": 2}

func countMatches(items [][]string, ruleKey, ruleValue string) (ans int) {
    index := d[ruleKey]
    for _, item := range items {
        if item[index] == ruleValue {
            ans++
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是输入 $\textit{items}$ 的长度。需要遍历一遍 $\textit{items}$。

- 空间复杂度：$O(1)$，仅消耗常数空间。