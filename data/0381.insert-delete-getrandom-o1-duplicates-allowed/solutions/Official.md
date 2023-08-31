## [381.O(1) 时间插入、删除和获取随机元素 - 允许重复 中文官方题解](https://leetcode.cn/problems/insert-delete-getrandom-o1-duplicates-allowed/solutions/100000/o1-shi-jian-cha-ru-shan-chu-he-huo-qu-sui-ji-yua-5)
#### 方法一：哈希表

**思路与算法**

为了使得 $O(1)$ 时间内能够随机获取一个元素，我们将每个数值（可以重复）存储在一个列表 $\textit{nums}$ 中。这样，获取随机元素时，只需要随机生成一个列表中的索引，就能够得到一个随机元素。

这样做的问题在于：列表中的随机删除并不是 $O(1)$ 的。然而我们可以发现，列表中元素的顺序是无关紧要的，只要它们正确地存在于列表中即可。因此，在删除元素时，我们可以将被删的元素与列表中最后一个元素交换位置，随后便可以在 $O(1)$ 时间内，从列表中去除该元素。

这需要我们额外维护数值在列表中**每一次**出现的下标集合。对于数值 $\textit{val}$ 而言，记其下标集合为 $S_{idx}$。

在删除时，我们找出 $val$ 出现的其中一个下标 $i$，并将 $\textit{nums}[i]$ 与  $\textit{nums}[\textit{nums}.\textit{length}-1]$ 交换。随后，将 $i$ 从 $S_{val}$ 中去除，并将 $S_{\textit{nums}[\textit{nums}.\textit{length}-1]}$ 中原有的 $\textit{nums}[\textit{nums}.\textit{length}-1]$ 替换成 $i$。由于集合的每个操作都是 $O(1)$ 的，因此总的平均时间复杂度也是 $O(1)$ 的。

**代码**
```C++ [sol1-C++]
class RandomizedCollection {
public:
    unordered_map<int, unordered_set<int>> idx;
    vector<int> nums;

    /** Initialize your data structure here. */
    RandomizedCollection() {

    }
    
    /** Inserts a value to the collection. Returns true if the collection did not already contain the specified element. */
    bool insert(int val) {
        nums.push_back(val);
        idx[val].insert(nums.size() - 1);
        return idx[val].size() == 1;
    }
    
    /** Removes a value from the collection. Returns true if the collection contained the specified element. */
    bool remove(int val) {
        if (idx.find(val) == idx.end()) {
            return false;
        }
        int i = *(idx[val].begin());
        nums[i] = nums.back();
        idx[val].erase(i);
        idx[nums[i]].erase(nums.size() - 1);
        if (i < nums.size() - 1) {
            idx[nums[i]].insert(i);
        }
        if (idx[val].size() == 0) {
            idx.erase(val);
        }
        nums.pop_back();
        return true;
    }
    
    /** Get a random element from the collection. */
    int getRandom() {
        return nums[rand() % nums.size()];
    }
};
```

```Java [sol1-Java]
class RandomizedCollection {
    Map<Integer, Set<Integer>> idx;
    List<Integer> nums;

    /** Initialize your data structure here. */
    public RandomizedCollection() {
        idx = new HashMap<Integer, Set<Integer>>();
        nums = new ArrayList<Integer>();
    }
    
    /** Inserts a value to the collection. Returns true if the collection did not already contain the specified element. */
    public boolean insert(int val) {
        nums.add(val);
        Set<Integer> set = idx.getOrDefault(val, new HashSet<Integer>());
        set.add(nums.size() - 1);
        idx.put(val, set);
        return set.size() == 1;
    }
    
    /** Removes a value from the collection. Returns true if the collection contained the specified element. */
    public boolean remove(int val) {
        if (!idx.containsKey(val)) {
            return false;
        }
        Iterator<Integer> it = idx.get(val).iterator();  
        int i = it.next();
        int lastNum = nums.get(nums.size() - 1);
        nums.set(i, lastNum);
        idx.get(val).remove(i);
        idx.get(lastNum).remove(nums.size() - 1);
        if (i < nums.size() - 1) {
            idx.get(lastNum).add(i);
        }
        if (idx.get(val).size() == 0) {
            idx.remove(val);
        }
        nums.remove(nums.size() - 1);
        return true;
    }
    
    /** Get a random element from the collection. */
    public int getRandom() {
        return nums.get((int) (Math.random() * nums.size()));
    }
}
```

```JavaScript [sol1-JavaScript]
/**
 * Initialize your data structure here.
 */
var RandomizedCollection = function() {
    this.idx = new Map();
    this.nums = [];
};

/**
 * Inserts a value to the collection. Returns true if the collection did not already contain the specified element. 
 * @param {number} val
 * @return {boolean}
 */
RandomizedCollection.prototype.insert = function(val) {
    this.nums.push(val);
    const set = this.idx.has(val) ? this.idx.get(val) : new Set();
    set.add(this.nums.length - 1);
    this.idx.set(val, set);
    return set.size === 1;
};

/**
 * Removes a value from the collection. Returns true if the collection contained the specified element. 
 * @param {number} val
 * @return {boolean}
 */
RandomizedCollection.prototype.remove = function(val) {
    if (!this.idx.has(val)) {
        return false;
    }
    let i = undefined;
    for (const it of this.idx.get(val)) {
        if (!i) {
            i = it;
            break;
        }
    }
    const lastNum = this.nums[this.nums.length - 1];
    this.nums[i] = lastNum;
    this.idx.get(val).delete(i);
    this.idx.get(lastNum).delete(this.nums.length - 1);
    if (i < this.nums.length - 1) {
        this.idx.get(lastNum).add(i);
    }
    if (this.idx.get(val).size === 0) {
        this.idx.delete(val);
    }
    this.nums.pop();
    return true;
};

/**
 * Get a random element from the collection.
 * @return {number}
 */
RandomizedCollection.prototype.getRandom = function() {
    return this.nums[Math.floor(Math.random() * this.nums.length)];
};
```

```Golang [sol1-Golang]
type RandomizedCollection struct {
    idx  map[int]map[int]struct{}
    nums []int
}

/** Initialize your data structure here. */
func Constructor() RandomizedCollection {
    return RandomizedCollection{
        idx: map[int]map[int]struct{}{},
    }
}

/** Inserts a value to the collection. Returns true if the collection did not already contain the specified element. */
func (r *RandomizedCollection) Insert(val int) bool {
    ids, has := r.idx[val]
    if !has {
        ids = map[int]struct{}{}
        r.idx[val] = ids
    }
    ids[len(r.nums)] = struct{}{}
    r.nums = append(r.nums, val)
    return !has
}

/** Removes a value from the collection. Returns true if the collection contained the specified element. */
func (r *RandomizedCollection) Remove(val int) bool {
    ids, has := r.idx[val]
    if !has {
        return false
    }
    var i int
    for id := range ids {
        i = id
        break
    }
    n := len(r.nums)
    r.nums[i] = r.nums[n-1]
    delete(ids, i)
    delete(r.idx[r.nums[i]], n-1)
    if i < n-1 {
        r.idx[r.nums[i]][i] = struct{}{}
    }
    if len(ids) == 0 {
        delete(r.idx, val)
    }
    r.nums = r.nums[:n-1]
    return true
}

/** Get a random element from the collection. */
func (r *RandomizedCollection) GetRandom() int {
    return r.nums[rand.Intn(len(r.nums))]
}
```

**复杂度分析**
- 时间复杂度：$O(1)$。
- 空间复杂度：$O(N)$，其中 $N$ 为集合中的元素数目。