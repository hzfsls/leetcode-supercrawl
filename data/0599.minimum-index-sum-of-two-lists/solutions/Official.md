#### 方法一：哈希表

**思路与算法**

使用一个哈希表记录 $\textit{list}_1$ 中每个餐厅对应的索引下标，然后遍历 $\textit{list}_2$，如果 $\textit{list}_2$ 中的餐厅存在于哈希表中，那么说明该餐厅是两人共同喜爱的，计算它的索引和。如果该索引和比最小索引和小，则清空结果，将该餐厅加入结果中，该索引和作为最小索引和；如果该索引和等于最小索引和，则直接将该餐厅加入结果中。

**代码**

```Python [sol1-Python3]
class Solution:
    def findRestaurant(self, list1: List[str], list2: List[str]) -> List[str]:
        index = {s: i for i, s in enumerate(list1)}
        ans = []
        indexSum = inf
        for i, s in enumerate(list2):
            if s in index:
                j = index[s]
                if i + j < indexSum:
                    indexSum = i + j
                    ans = [s]
                elif i + j == indexSum:
                    ans.append(s)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> findRestaurant(vector<string>& list1, vector<string>& list2) {
        unordered_map<string, int> index;
        for (int i = 0; i < list1.size(); i++) {
            index[list1[i]] = i;
        }

        vector<string> ret;
        int indexSum = INT_MAX;
        for (int i = 0; i < list2.size(); i++) {
            if (index.count(list2[i]) > 0) {
                int j = index[list2[i]];
                if (i + j < indexSum) {
                    ret.clear();
                    ret.push_back(list2[i]);
                    indexSum = i + j;
                } else if (i + j == indexSum) {
                    ret.push_back(list2[i]);
                }
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String[] findRestaurant(String[] list1, String[] list2) {
        Map<String, Integer> index = new HashMap<String, Integer>();
        for (int i = 0; i < list1.length; i++) {
            index.put(list1[i], i);
        }

        List<String> ret = new ArrayList<String>();
        int indexSum = Integer.MAX_VALUE;
        for (int i = 0; i < list2.length; i++) {
            if (index.containsKey(list2[i])) {
                int j = index.get(list2[i]);
                if (i + j < indexSum) {
                    ret.clear();
                    ret.add(list2[i]);
                    indexSum = i + j;
                } else if (i + j == indexSum) {
                    ret.add(list2[i]);
                }
            }
        }
        return ret.toArray(new String[ret.size()]);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string[] FindRestaurant(string[] list1, string[] list2) {
        Dictionary<string, int> index = new Dictionary<string, int>();
        for (int i = 0; i < list1.Length; i++) {
            index.Add(list1[i], i);
        }

        IList<string> ret = new List<string>();
        int indexSum = int.MaxValue;
        for (int i = 0; i < list2.Length; i++) {
            if (index.ContainsKey(list2[i])) {
                int j = index[list2[i]];
                if (i + j < indexSum) {
                    ret.Clear();
                    ret.Add(list2[i]);
                    indexSum = i + j;
                } else if (i + j == indexSum) {
                    ret.Add(list2[i]);
                }
            }
        }
        return ret.ToArray();
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

typedef struct {
  char *key;
  int val;
  UT_hash_handle hh;
} HashItem;

void freeHash(HashItem ** obj) {
    HashItem * curr = NULL, * next = NULL;
    HASH_ITER(hh, *obj, curr, next) {
      HASH_DEL(*obj, curr);
      free(curr);
    } 
}

char ** findRestaurant(char ** list1, int list1Size, char ** list2, int list2Size, int* returnSize){
    HashItem * index = NULL;
    HashItem * pEntry = NULL;
    for (int i = 0; i < list1Size; i++) {
        HASH_FIND_STR(index, list1[i], pEntry);
        if (NULL == pEntry) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = list1[i];
            pEntry->val = i;
            HASH_ADD_STR(index, key, pEntry);
        }
    }

    char ** ret = (char **)malloc(sizeof(char *) * MIN(list1Size, list2Size));
    int pos = 0;
    int indexSum = INT_MAX;
    for (int i = 0; i < list2Size; i++) {
        HASH_FIND_STR(index, list2[i], pEntry);
        if (NULL != pEntry) {
            int j = pEntry->val;
            if (i + j < indexSum) {
                pos = 0;
                ret[pos++] = list2[i];
                indexSum = i + j;
            } else if (i + j == indexSum) {
                ret[pos++] = list2[i];
            }
        }
    }
    freeHash(&index);
    *returnSize = pos;
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var findRestaurant = function(list1, list2) {
    const index = new Map();
    for (let i = 0; i < list1.length; i++) {
        index.set(list1[i], i);
    }

    const ret = [];
    let indexSum = Number.MAX_VALUE;
    for (let i = 0; i < list2.length; i++) {
        if (index.has(list2[i])) {
            const j = index.get(list2[i]);
            if (i + j < indexSum) {
                ret.length = 0;
                ret.push(list2[i]);
                indexSum = i + j;
            } else if (i + j == indexSum) {
                ret.push(list2[i]);
            }
        }
    }
    return ret;
};
```

```go [sol1-Golang]
func findRestaurant(list1, list2 []string) (ans []string) {
    index := make(map[string]int, len(list1))
    for i, s := range list1 {
        index[s] = i
    }

    indexSum := math.MaxInt32
    for i, s := range list2 {
        if j, ok := index[s]; ok {
            if i+j < indexSum {
                indexSum = i + j
                ans = []string{s}
            } else if i+j == indexSum {
                ans = append(ans, s)
            }
        }
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(\sum_1 + \sum_2)$，其中 $\sum_1$ 和 $\sum_2$ 分别表示 $\textit{list}_1$ 和 $\textit{list}_2$ 中的字符串长度之和。建立哈希表需要 $O(\sum_1)$，遍历 $\textit{list}_2$ 需要 $O(\sum_2)$。

+ 空间复杂度：$O(\sum_1)$。保存哈希表需要 $O(\sum_1)$ 的空间，返回结果不计算空间复杂度。