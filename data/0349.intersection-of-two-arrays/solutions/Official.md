## [349.两个数组的交集 中文官方题解](https://leetcode.cn/problems/intersection-of-two-arrays/solutions/100000/liang-ge-shu-zu-de-jiao-ji-by-leetcode-solution)
#### 方法一：两个集合

计算两个数组的交集，直观的方法是遍历数组 `nums1`，对于其中的每个元素，遍历数组 `nums2` 判断该元素是否在数组 `nums2` 中，如果存在，则将该元素添加到返回值。假设数组 `nums1` 和 `nums2` 的长度分别是 $m$ 和 $n$，则遍历数组 `nums1` 需要 $O(m)$ 的时间，判断 `nums1` 中的每个元素是否在数组 `nums2` 中需要 $O(n)$ 的时间，因此总时间复杂度是 $O(mn)$。

如果使用哈希集合存储元素，则可以在 $O(1)$ 的时间内判断一个元素是否在集合中，从而降低时间复杂度。

首先使用两个集合分别存储两个数组中的元素，然后遍历较小的集合，判断其中的每个元素是否在另一个集合中，如果元素也在另一个集合中，则将该元素添加到返回值。该方法的时间复杂度可以降低到 $O(m+n)$。

```Java [sol1-Java]
class Solution {
    public int[] intersection(int[] nums1, int[] nums2) {
        Set<Integer> set1 = new HashSet<Integer>();
        Set<Integer> set2 = new HashSet<Integer>();
        for (int num : nums1) {
            set1.add(num);
        }
        for (int num : nums2) {
            set2.add(num);
        }
        return getIntersection(set1, set2);
    }

    public int[] getIntersection(Set<Integer> set1, Set<Integer> set2) {
        if (set1.size() > set2.size()) {
            return getIntersection(set2, set1);
        }
        Set<Integer> intersectionSet = new HashSet<Integer>();
        for (int num : set1) {
            if (set2.contains(num)) {
                intersectionSet.add(num);
            }
        }
        int[] intersection = new int[intersectionSet.size()];
        int index = 0;
        for (int num : intersectionSet) {
            intersection[index++] = num;
        }
        return intersection;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def intersection(self, nums1: List[int], nums2: List[int]) -> List[int]:
        set1 = set(nums1)
        set2 = set(nums2)
        return self.set_intersection(set1, set2)

    def set_intersection(self, set1, set2):
        if len(set1) > len(set2):
            return self.set_intersection(set2, set1)
        return [x for x in set1 if x in set2]
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> intersection(vector<int>& nums1, vector<int>& nums2) {
        unordered_set<int> set1, set2;
        for (auto& num : nums1) {
            set1.insert(num);
        }
        for (auto& num : nums2) {
            set2.insert(num);
        }
        return getIntersection(set1, set2);
    }

    vector<int> getIntersection(unordered_set<int>& set1, unordered_set<int>& set2) {
        if (set1.size() > set2.size()) {
            return getIntersection(set2, set1);
        }
        vector<int> intersection;
        for (auto& num : set1) {
            if (set2.count(num)) {
                intersection.push_back(num);
            }
        }
        return intersection;
    }
};
```

```JavaScript [sol1-JavaScript]
const set_intersection = (set1, set2) => {
    if (set1.size > set2.size) {
        return set_intersection(set2, set1);
    }
    const intersection = new Set();
    for (const num of set1) {
        if (set2.has(num)) {
            intersection.add(num);
        }
    }
    return [...intersection];
}

var intersection = function(nums1, nums2) {
    const set1 = new Set(nums1);
    const set2 = new Set(nums2);
    return set_intersection(set1, set2);
};
```

```Golang [sol1-Golang]
func intersection(nums1 []int, nums2 []int) (intersection []int) {
    set1 := map[int]struct{}{}
    for _, v := range nums1 {
        set1[v] = struct{}{}
    }
    set2 := map[int]struct{}{}
    for _, v := range nums2 {
        set2[v] = struct{}{}
    }
    if len(set1) > len(set2) {
        set1, set2 = set2, set1
    }
    for v := range set1 {
        if _, has := set2[v]; has {
            intersection = append(intersection, v)
        }
    }
    return
}
```

```C [sol1-C]
struct unordered_set {
    int key;
    UT_hash_handle hh;
};

struct unordered_set* find(struct unordered_set** hashtable, int ikey) {
    struct unordered_set* tmp;
    HASH_FIND_INT(*hashtable, &ikey, tmp);
    return tmp;
}

void insert(struct unordered_set** hashtable, int ikey) {
    struct unordered_set* tmp = find(hashtable, ikey);
    if (tmp != NULL) return;
    tmp = malloc(sizeof(struct unordered_set));
    tmp->key = ikey;
    HASH_ADD_INT(*hashtable, key, tmp);
}

int* getIntersection(struct unordered_set** set1, struct unordered_set** set2, int* returnSize) {
    if (HASH_COUNT(*set1) > HASH_COUNT(*set2)) {
        return getIntersection(set2, set1, returnSize);
    }
    int* intersection = malloc(sizeof(int) * (HASH_COUNT(*set1) + HASH_COUNT(*set2)));
    struct unordered_set *s, *tmp;
    HASH_ITER(hh, *set1, s, tmp) {
        if (find(set2, s->key)) {
            intersection[(*returnSize)++] = s->key;
        }
    }
    return intersection;
}

int* intersection(int* nums1, int nums1Size, int* nums2, int nums2Size, int* returnSize) {
    *returnSize = 0;
    struct unordered_set *set1 = NULL, *set2 = NULL;
    for (int i = 0; i < nums1Size; i++) {
        insert(&set1, nums1[i]);
    }
    for (int i = 0; i < nums2Size; i++) {
        insert(&set2, nums2[i]);
    }

    return getIntersection(&set1, &set2, returnSize);
}
```

**复杂度分析**

- 时间复杂度：$O(m+n)$，其中 $m$ 和 $n$ 分别是两个数组的长度。使用两个集合分别存储两个数组中的元素需要 $O(m+n)$ 的时间，遍历较小的集合并判断元素是否在另一个集合中需要 $O(\min(m,n))$ 的时间，因此总时间复杂度是 $O(m+n)$。

- 空间复杂度：$O(m+n)$，其中 $m$ 和 $n$ 分别是两个数组的长度。空间复杂度主要取决于两个集合。

#### 方法二：排序 + 双指针

如果两个数组是有序的，则可以使用双指针的方法得到两个数组的交集。

首先对两个数组进行排序，然后使用两个指针遍历两个数组。可以预见的是加入答案的数组的元素一定是递增的，为了保证加入元素的唯一性，我们需要额外记录变量 $\textit{pre}$ 表示上一次加入答案数组的元素。

初始时，两个指针分别指向两个数组的头部。每次比较两个指针指向的两个数组中的数字，如果两个数字不相等，则将指向较小数字的指针右移一位，如果两个数字相等，且该数字不等于 $\textit{pre}$ ，将该数字添加到答案并更新 $\textit{pre}$ 变量，同时将两个指针都右移一位。当至少有一个指针超出数组范围时，遍历结束。

```Java [sol2-Java]
class Solution {
    public int[] intersection(int[] nums1, int[] nums2) {
        Arrays.sort(nums1);
        Arrays.sort(nums2);
        int length1 = nums1.length, length2 = nums2.length;
        int[] intersection = new int[length1 + length2];
        int index = 0, index1 = 0, index2 = 0;
        while (index1 < length1 && index2 < length2) {
            int num1 = nums1[index1], num2 = nums2[index2];
            if (num1 == num2) {
                // 保证加入元素的唯一性
                if (index == 0 || num1 != intersection[index - 1]) {
                    intersection[index++] = num1;
                }
                index1++;
                index2++;
            } else if (num1 < num2) {
                index1++;
            } else {
                index2++;
            }
        }
        return Arrays.copyOfRange(intersection, 0, index);
    }
}
```

```Python [sol2-Python3]
class Solution:
    def intersection(self, nums1: List[int], nums2: List[int]) -> List[int]:
        nums1.sort()
        nums2.sort()
        length1, length2 = len(nums1), len(nums2)
        intersection = list()
        index1 = index2 = 0
        while index1 < length1 and index2 < length2:
            num1 = nums1[index1]
            num2 = nums2[index2]
            if num1 == num2:
                # 保证加入元素的唯一性
                if not intersection or num1 != intersection[-1]:
                    intersection.append(num1)
                index1 += 1
                index2 += 1
            elif num1 < num2:
                index1 += 1
            else:
                index2 += 1
        return intersection
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> intersection(vector<int>& nums1, vector<int>& nums2) {
        sort(nums1.begin(), nums1.end());
        sort(nums2.begin(), nums2.end());
        int length1 = nums1.size(), length2 = nums2.size();
        int index1 = 0, index2 = 0;
        vector<int> intersection;
        while (index1 < length1 && index2 < length2) {
            int num1 = nums1[index1], num2 = nums2[index2];
            if (num1 == num2) {
                // 保证加入元素的唯一性
                if (!intersection.size() || num1 != intersection.back()) {
                    intersection.push_back(num1);
                }
                index1++;
                index2++;
            } else if (num1 < num2) {
                index1++;
            } else {
                index2++;
            }
        }
        return intersection;
    }
};
```

```JavaScript [sol2-JavaScript]
var intersection = function(nums1, nums2) {
    nums1.sort((x, y) => x - y);
    nums2.sort((x, y) => x - y);
    const length1 = nums1.length, length2 = nums2.length;
    let index1 = 0, index2 = 0;
    const intersection = [];
    while (index1 < length1 && index2 < length2) {
        const num1 = nums1[index1], num2 = nums2[index2];
        if (num1 === num2) {
            // 保证加入元素的唯一性
            if (!intersection.length || num1 !== intersection[intersection.length - 1]) {
                intersection.push(num1);
            }
            index1++;
            index2++;
        } else if (num1 < num2) {
            index1++;
        } else {
            index2++;
        }
    }
    return intersection;
};
```

```Golang [sol2-Golang]
func intersection(nums1 []int, nums2 []int) (res []int) {
    sort.Ints(nums1)
    sort.Ints(nums2)
    for i, j := 0, 0; i < len(nums1) && j < len(nums2); {
        x, y := nums1[i], nums2[j]
        if x == y {
            if res == nil || x > res[len(res)-1] {
                res = append(res, x)
            }
            i++
            j++
        } else if x < y {
            i++
        } else {
            j++
        }
    }
    return
}
```

```C [sol2-C]
int cmp(void* a, void* b) {
    return *(int*)a - *(int*)b;
}

int* intersection(int* nums1, int nums1Size, int* nums2, int nums2Size, int* returnSize) {
    qsort(nums1, nums1Size, sizeof(int), cmp);
    qsort(nums2, nums2Size, sizeof(int), cmp);
    *returnSize = 0;
    int index1 = 0, index2 = 0;
    int* intersection = malloc(sizeof(int) * (nums1Size + nums2Size));
    while (index1 < nums1Size && index2 < nums2Size) {
        int num1 = nums1[index1], num2 = nums2[index2];
        if (num1 == num2) {
            // 保证加入元素的唯一性
            if (!(*returnSize) || num1 != intersection[(*returnSize) - 1]) {
                intersection[(*returnSize)++] = num1;
            }
            index1++;
            index2++;
        } else if (num1 < num2) {
            index1++;
        } else {
            index2++;
        }
    }
    return intersection;
}
```

**复杂度分析**

- 时间复杂度：$O(m \log m+n \log n)$，其中 $m$ 和 $n$ 分别是两个数组的长度。对两个数组排序的时间复杂度分别是 $O(m \log m)$ 和 $O(n \log n)$，双指针寻找交集元素的时间复杂度是 $O(m+n)$，因此总时间复杂度是 $O(m \log m+n \log n)$。

- 空间复杂度：$O(\log m+\log n)$，其中 $m$ 和 $n$ 分别是两个数组的长度。空间复杂度主要取决于排序使用的额外空间。