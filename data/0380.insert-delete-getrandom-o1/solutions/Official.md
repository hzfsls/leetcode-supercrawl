## [380.O(1) 时间插入、删除和获取随机元素 中文官方题解](https://leetcode.cn/problems/insert-delete-getrandom-o1/solutions/100000/o1-shi-jian-cha-ru-shan-chu-he-huo-qu-su-rlz2)
#### 方法一：变长数组 + 哈希表

这道题要求实现一个类，满足插入、删除和获取随机元素操作的平均时间复杂度为 $O(1)$。

变长数组可以在 $O(1)$ 的时间内完成获取随机元素操作，但是由于无法在 $O(1)$ 的时间内判断元素是否存在，因此不能在 $O(1)$ 的时间内完成插入和删除操作。哈希表可以在 $O(1)$ 的时间内完成插入和删除操作，但是由于无法根据下标定位到特定元素，因此不能在 $O(1)$ 的时间内完成获取随机元素操作。为了满足插入、删除和获取随机元素操作的时间复杂度都是 $O(1)$，需要将变长数组和哈希表结合，变长数组中存储元素，哈希表中存储每个元素在变长数组中的下标。

插入操作时，首先判断 $\textit{val}$ 是否在哈希表中，如果已经存在则返回 $\text{false}$，如果不存在则插入 $\textit{val}$，操作如下：

1. 在变长数组的末尾添加 $\textit{val}$；

2. 在添加 $\textit{val}$ 之前的变长数组长度为 $\textit{val}$ 所在下标 $\textit{index}$，将 $\textit{val}$ 和下标 $\textit{index}$ 存入哈希表；

3. 返回 $\text{true}$。

删除操作时，首先判断 $\textit{val}$ 是否在哈希表中，如果不存在则返回 $\text{false}$，如果存在则删除 $\textit{val}$，操作如下：

1. 从哈希表中获得 $\textit{val}$ 的下标 $\textit{index}$；

2. 将变长数组的最后一个元素 $\textit{last}$ 移动到下标 $\textit{index}$ 处，在哈希表中将 $\textit{last}$ 的下标更新为 $\textit{index}$；

3. 在变长数组中删除最后一个元素，在哈希表中删除 $\textit{val}$；

4. 返回 $\text{true}$。

删除操作的重点在于将变长数组的最后一个元素移动到待删除元素的下标处，然后删除变长数组的最后一个元素。该操作的时间复杂度是 $O(1)$，且可以保证在删除操作之后变长数组中的所有元素的下标都连续，方便插入操作和获取随机元素操作。

获取随机元素操作时，由于变长数组中的所有元素的下标都连续，因此随机选取一个下标，返回变长数组中该下标处的元素。

```Python [sol1-Python3]
class RandomizedSet:
    def __init__(self):
        self.nums = []
        self.indices = {}

    def insert(self, val: int) -> bool:
        if val in self.indices:
            return False
        self.indices[val] = len(self.nums)
        self.nums.append(val)
        return True

    def remove(self, val: int) -> bool:
        if val not in self.indices:
            return False
        id = self.indices[val]
        self.nums[id] = self.nums[-1]
        self.indices[self.nums[id]] = id
        self.nums.pop()
        del self.indices[val]
        return True

    def getRandom(self) -> int:
        return choice(self.nums)
```

```Java [sol1-Java]
class RandomizedSet {
    List<Integer> nums;
    Map<Integer, Integer> indices;
    Random random;

    public RandomizedSet() {
        nums = new ArrayList<Integer>();
        indices = new HashMap<Integer, Integer>();
        random = new Random();
    }

    public boolean insert(int val) {
        if (indices.containsKey(val)) {
            return false;
        }
        int index = nums.size();
        nums.add(val);
        indices.put(val, index);
        return true;
    }

    public boolean remove(int val) {
        if (!indices.containsKey(val)) {
            return false;
        }
        int index = indices.get(val);
        int last = nums.get(nums.size() - 1);
        nums.set(index, last);
        indices.put(last, index);
        nums.remove(nums.size() - 1);
        indices.remove(val);
        return true;
    }

    public int getRandom() {
        int randomIndex = random.nextInt(nums.size());
        return nums.get(randomIndex);
    }
}
```

```C# [sol1-C#]
public class RandomizedSet {
    IList<int> nums;
    Dictionary<int, int> indices;
    Random random;

    public RandomizedSet() {
        nums = new List<int>();
        indices = new Dictionary<int, int>();
        random = new Random();
    }

    public bool Insert(int val) {
        if (indices.ContainsKey(val)) {
            return false;
        }
        int index = nums.Count;
        nums.Add(val);
        indices.Add(val, index);
        return true;
    }

    public bool Remove(int val) {
        if (!indices.ContainsKey(val)) {
            return false;
        }
        int index = indices[val];
        int last = nums[nums.Count - 1];
        nums[index] = last;
        indices[last] = index;
        nums.RemoveAt(nums.Count - 1);
        indices.Remove(val);
        return true;
    }

    public int GetRandom() {
        int randomIndex = random.Next(nums.Count);
        return nums[randomIndex];
    }
}
```

```C++ [sol1-C++]
class RandomizedSet {
public:
    RandomizedSet() {
        srand((unsigned)time(NULL));
    }
    
    bool insert(int val) {
        if (indices.count(val)) {
            return false;
        }
        int index = nums.size();
        nums.emplace_back(val);
        indices[val] = index;
        return true;
    }
    
    bool remove(int val) {
        if (!indices.count(val)) {
            return false;
        }
        int index = indices[val];
        int last = nums.back();
        nums[index] = last;
        indices[last] = index;
        nums.pop_back();
        indices.erase(val);
        return true;
    }
    
    int getRandom() {
        int randomIndex = rand()%nums.size();
        return nums[randomIndex];
    }
private:
    vector<int> nums;
    unordered_map<int, int> indices;
};
```

```C [sol1-C]
#define MAX_NUM_SIZE 10001

typedef struct {
    int key;
    int val;
    UT_hash_handle hh; 
} HashItem;

bool findHash(const HashItem ** obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    if (NULL != pEntry) {
        return true;
    }
    return false;
}

int getHash(const HashItem ** obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    if (NULL == pEntry) {
        return -1;
    }
    return pEntry->val;
}

void insertHash(HashItem ** obj, int key, int val) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    if (NULL != pEntry) {
        pEntry->val = val;
    } else {
        pEntry = (HashItem *)malloc(sizeof(HashItem));
        pEntry->key = key;
        pEntry->val = val;
        HASH_ADD_INT(*obj, key, pEntry);
    }
}

bool removeHash(HashItem ** obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    if (NULL != pEntry) {
        HASH_DEL(*obj, pEntry);  
        free(pEntry); 
    }
    return true;
}

void freeHash(HashItem ** obj) {
    HashItem *curr, *tmp;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);
    }
}

typedef struct {
    int * nums;
    int numsSize;
    HashItem * indices;
} RandomizedSet;

RandomizedSet* randomizedSetCreate() {
    srand((unsigned)time(NULL));
    RandomizedSet * obj = (RandomizedSet *)malloc(sizeof(RandomizedSet));
    obj->nums = (int *)malloc(sizeof(int) * MAX_NUM_SIZE);
    obj->numsSize = 0;
    obj->indices = NULL;
    return obj;
}

bool randomizedSetInsert(RandomizedSet* obj, int val) {
    HashItem *pEntry = NULL;
    if (findHash(&obj->indices, val)) {
        return false;
    }
    int index = obj->numsSize;
    obj->nums[obj->numsSize++] = val;
    insertHash(&obj->indices, val, obj->numsSize - 1);
    return true;
}

bool randomizedSetRemove(RandomizedSet* obj, int val) {
    if (!findHash(&obj->indices, val)) {
        return false;
    }
    int index = getHash(&obj->indices, val);
    int last = obj->nums[obj->numsSize - 1];
    obj->nums[index] = last;
    insertHash(&obj->indices, last, index);
    obj->numsSize--;
    removeHash(&obj->indices, val);
    return true;
}

int randomizedSetGetRandom(RandomizedSet* obj) {
    int randomIndex = rand() % obj->numsSize;
    return obj->nums[randomIndex];
}

void randomizedSetFree(RandomizedSet* obj) {
    freeHash(&obj->indices);
    free(obj->nums);
    free(obj);
}
```

```go [sol1-Golang]
type RandomizedSet struct {
    nums    []int
    indices map[int]int
}

func Constructor() RandomizedSet {
    return RandomizedSet{[]int{}, map[int]int{}}
}

func (rs *RandomizedSet) Insert(val int) bool {
    if _, ok := rs.indices[val]; ok {
        return false
    }
    rs.indices[val] = len(rs.nums)
    rs.nums = append(rs.nums, val)
    return true
}

func (rs *RandomizedSet) Remove(val int) bool {
    id, ok := rs.indices[val]
    if !ok {
        return false
    }
    last := len(rs.nums) - 1
    rs.nums[id] = rs.nums[last]
    rs.indices[rs.nums[id]] = id
    rs.nums = rs.nums[:last]
    delete(rs.indices, val)
    return true
}

func (rs *RandomizedSet) GetRandom() int {
    return rs.nums[rand.Intn(len(rs.nums))]
}
```

```JavaScript [sol1-JavaScript]
var RandomizedSet = function() {
    this.nums = [];
    this.indices = new Map();
};

RandomizedSet.prototype.insert = function(val) {
    if (this.indices.has(val)) {
        return false;
    }
    let index = this.nums.length;
    this.nums.push(val);
    this.indices.set(val, index);
    return true;
};

RandomizedSet.prototype.remove = function(val) {
    if (!this.indices.has(val)) {
        return false;
    }
    let id = this.indices.get(val);
    this.nums[id] = this.nums[this.nums.length - 1];
    this.indices.set(this.nums[id], id);
    this.nums.pop();
    this.indices.delete(val);
    return true;
};

RandomizedSet.prototype.getRandom = function() {
    const randomIndex = Math.floor(Math.random() * this.nums.length);
    return this.nums[randomIndex];
};
```

**复杂度分析**

- 时间复杂度：初始化和各项操作的时间复杂度都是 $O(1)$。

- 空间复杂度：$O(n)$，其中 $n$ 是集合中的元素个数。存储元素的数组和哈希表需要 $O(n)$ 的空间。