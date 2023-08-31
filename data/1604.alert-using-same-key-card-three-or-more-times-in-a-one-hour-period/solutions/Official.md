## [1604.警告一小时内使用相同员工卡大于等于三次的人 中文官方题解](https://leetcode.cn/problems/alert-using-same-key-card-three-or-more-times-in-a-one-hour-period/solutions/100000/jing-gao-yi-xiao-shi-nei-shi-yong-xiang-ioeiw)

#### 方法一：哈希表 + 排序

由于给定的数组是每个员工在**同一天**内使用员工卡的时间，因此同一个员工使用员工卡的时间顺序一定是按照小时数和分钟数递增的。只要获得每个员工的全部使用员工卡的时间，即可判断哪些员工收到系统警告，即哪些员工在一小时内使用员工卡的次数大于等于三次。

遍历数组 $\textit{keyName}$ 和 $\textit{keyTime}$，即可获得每个员工的全部使用员工卡的时间列表。使用哈希表记录每个员工的全部使用员工卡的时间列表。为了方便后序计算，将使用员工卡的时间转成分钟数。

获得每个员工的全部使用员工卡的时间列表之后，再对每个员工分别判断是否收到系统警告。具体做法是，对于每个员工，从哈希表中获得该员工的全部使用员工卡的时间列表，并将列表排序，然后遍历排序后的列表。如果发现列表中存在三个连续元素中的最大元素与最小元素之差不超过 $60$，即意味着这三次使用员工卡是在一小时之内发生的，因此因此该员工会收到系统警告。由于只需要知道每个员工是否收到系统警告，因此一旦可以确认某个员工会收到系统警告，即可停止遍历该员工的剩余的使用员工卡的时间。

使用一个列表存储收到系统警告的员工名字。在得到所有的收到系统警告的员工名字之后，对该列表进行排序，然后返回。

```Python [sol1-Python3]
class Solution:
    def alertNames(self, keyName: List[str], keyTime: List[str]) -> List[str]:
        timeMap = defaultdict(list)
        for name, time in zip(keyName, keyTime):
            hour, minute = int(time[:2]), int(time[3:])
            timeMap[name].append(hour * 60 + minute)

        ans = []
        for name, times in timeMap.items():
            times.sort()
            if any(t2 - t1 <= 60 for t1, t2 in zip(times, times[2:])):
                ans.append(name)
        ans.sort()
        return ans
```

```Java [sol1-Java]
class Solution {
    public List<String> alertNames(String[] keyName, String[] keyTime) {
        Map<String, List<Integer>> timeMap = new HashMap<String, List<Integer>>();
        int n = keyName.length;
        for (int i = 0; i < n; i++) {
            String name = keyName[i];
            String time = keyTime[i];
            timeMap.putIfAbsent(name, new ArrayList<Integer>());
            int hour = (time.charAt(0) - '0') * 10 + (time.charAt(1) - '0');
            int minute = (time.charAt(3) - '0') * 10 + (time.charAt(4) - '0');
            timeMap.get(name).add(hour * 60 + minute);
        }
        List<String> res = new ArrayList<String>();
        Set<String> keySet = timeMap.keySet();
        for (String name : keySet) {
            List<Integer> list = timeMap.get(name);
            Collections.sort(list);
            int size = list.size();
            for (int i = 2; i < size; i++) {
                int time1 = list.get(i - 2), time2 = list.get(i);
                int difference = time2 - time1;
                if (difference <= 60) {
                    res.add(name);
                    break;
                }
            }
        }
        Collections.sort(res);
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> AlertNames(string[] keyName, string[] keyTime) {
        IDictionary<string, IList<int>> timeDictionary = new Dictionary<string, IList<int>>();
        int n = keyName.Length;
        for (int i = 0; i < n; i++) {
            string name = keyName[i];
            string time = keyTime[i];
            timeDictionary.TryAdd(name, new List<int>());
            int hour = (time[0] - '0') * 10 + (time[1] - '0');
            int minute = (time[3] - '0') * 10 + (time[4] - '0');
            timeDictionary[name].Add(hour * 60 + minute);
        }
        IList<string> res = new List<string>();
        foreach (KeyValuePair<string, IList<int>> pair in timeDictionary) {
            string name = pair.Key;
            IList<int> list = pair.Value;
            ((List<int>) list).Sort();
            int size = list.Count;
            for (int i = 2; i < size; i++) {
                int time1 = list[i - 2], time2 = list[i];
                int difference = time2 - time1;
                if (difference <= 60) {
                    res.Add(name);
                    break;
                }
            }
        }
        ((List<string>) res).Sort();
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> alertNames(vector<string>& keyName, vector<string>& keyTime) {
        unordered_map<string, vector<int>> timeMap;
        int n = keyName.size();
        for (int i = 0; i < n; i++) {
            string name = keyName[i];
            string time = keyTime[i];
            int hour = (time[0] - '0') * 10 + (time[1] - '0');
            int minute = (time[3] - '0') * 10 + (time[4] - '0');
            timeMap[name].emplace_back(hour * 60 + minute);
        }
        vector<string> res;
        for (auto &[name, list] : timeMap) {
            sort(list.begin(), list.end());
            int size = list.size();
            for (int i = 2; i < size; i++) {
                int time1 = list[i - 2], time2 = list[i];
                int difference = time2 - time1;
                if (difference <= 60) {
                    res.emplace_back(name);
                    break;
                }
            }
        }
        sort(res.begin(), res.end());
        return res;
    }
};
```

```C [sol1-C]
typedef struct {
    char *key;
    struct ListNode *val;
    UT_hash_handle hh;
} HashItem; 

struct ListNode *creatListNode(int val) {
    struct ListNode *obj = (struct ListNode *)malloc(sizeof(struct ListNode));
    obj->val = val;
    obj->next = NULL;
    return obj;
}

HashItem *hashFindItem(HashItem **obj, const char * key) {
    HashItem *pEntry = NULL;
    HASH_FIND_STR(*obj, key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, const char *key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        pEntry = (HashItem *)malloc(sizeof(HashItem));
        pEntry->key = key;
        pEntry->val = NULL;
        HASH_ADD_STR(*obj, key, pEntry);
    } 
    struct ListNode *node = creatListNode(val);
    node->next = pEntry->val;
    pEntry->val = node;
    return true;
}

void freeList(struct ListNode *list) {
    while (list) {
        struct ListNode *curr = list;
        list = list->next;
        free(curr);
    }
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);
        freeList(curr->val);
        free(curr);             
    }
}

static int cmp1(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

static int cmp2(const void *pa, const void *pb) {
    return strcmp(*(char **)pa, *(char **)pb);
}

char ** alertNames(char ** keyName, int keyNameSize, char ** keyTime, int keyTimeSize, int* returnSize) {
    HashItem *timeMap = NULL;
    for (int i = 0; i < keyNameSize; i++) {
        char *name = keyName[i];
        char *time = keyTime[i];
        int hour = (time[0] - '0') * 10 + (time[1] - '0');
        int minute = (time[3] - '0') * 10 + (time[4] - '0');
        hashAddItem(&timeMap, name, hour * 60 + minute);
    }

    char **res = (char **)malloc(sizeof(char *) * keyNameSize);
    int pos = 0;
    HashItem *curr = NULL, *temp = NULL;
    int arr[keyNameSize];
    HASH_ITER(hh, timeMap, curr, temp) {
        int size = 0;
        for (struct ListNode *node = curr->val; node; node = node->next) {
            arr[size++] = node->val;
        }
        qsort(arr, size, sizeof(int), cmp1); 
        for (int i = 2; i < size; i++) {
            int time1 = arr[i - 2], time2 = arr[i];
            int difference = time2 - time1;
            if (difference <= 60) {
                res[pos] = (char *)malloc(sizeof(char) * (strlen(curr->key) + 1));
                strcpy(res[pos], curr->key);
                pos++;
                break;
            }
        }
    }
    qsort(res, pos, sizeof(char *), cmp2);
    *returnSize = pos;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var alertNames = function(keyName, keyTime) {
    const timeMap = new Map();
    const n = keyName.length;
    for (let i = 0; i < n; i++) {
        const name = keyName[i];
        const time = keyTime[i];
        if (!timeMap.has(name)) {
            timeMap.set(name, []);
        }
        const hour = (time[0].charCodeAt() - '0'.charCodeAt()) * 10 + (time[1].charCodeAt() - '0'.charCodeAt());
        const minute = (time[3].charCodeAt() - '0'.charCodeAt()) * 10 + (time[4].charCodeAt() - '0'.charCodeAt());
        timeMap.get(name).push(hour * 60 + minute);
    }
    let res = [];
    const keySet = timeMap.keys();
    for (const name of keySet) {
        const list = timeMap.get(name);
        list.sort((a, b) => a - b);
        const size = list.length;
        for (let i = 2; i < size; i++) {
            const time1 = list[i - 2], time2 = list[i];
            const difference = time2 - time1;
            if (difference <= 60) {
                res.push(name);
                break;
            }
        }
    }
    res.sort();
    return res;
};
```

```go [sol1-Golang]
func alertNames(keyName, keyTime []string) (ans []string) {
    timeMap := map[string][]int{}
    for i, name := range keyName {
        t := keyTime[i]
        hour := int(t[0]-'0')*10 + int(t[1]-'0')
        minute := int(t[3]-'0')*10 + int(t[4]-'0')
        timeMap[name] = append(timeMap[name], hour*60+minute)
    }
    for name, times := range timeMap {
        sort.Ints(times)
        for i, t := range times[2:] {
            if t-times[i] <= 60 {
                ans = append(ans, name)
                break
            }
        }
    }
    sort.Strings(ans)
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{keyName}$ 和 $\textit{keyTime}$ 的长度。
  需要遍历数组 $\textit{keyName}$ 和 $\textit{keyTime}$，得到每个员工的全部使用员工卡的时间，遍历的时间复杂度是 $O(n)$，存入哈希表的时间复杂度是 $O(1)$，因此时间复杂度是 $O(n)$。
  然后判断每个员工是否收到系统警告，需要进行排序和遍历的操作，最坏情况下，排序的时间复杂度是 $O(n \log n)$，遍历的时间复杂度是 $O(n)$，因此时间复杂度是 $O(n \log n)$。
  因此总时间复杂度是 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{keyName}$ 和 $\textit{keyTime}$ 的长度。空间复杂度主要取决于哈希表，需要存储所有员工的全部打卡时间。