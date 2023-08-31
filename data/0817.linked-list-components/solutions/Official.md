## [817.链表组件 中文官方题解](https://leetcode.cn/problems/linked-list-components/solutions/100000/lian-biao-zu-jian-by-leetcode-solution-5f91)
#### 方法一：计算组件的起始位置

**思路**

此题需要计算组件的个数，只需在链表中计算有多少组件的起始位置即可。当一个节点满足以下条件之一时，它是组件的起始位置：

- 节点的值在数组 $\textit{nums}$ 中且节点位于链表起始位置；
- 节点的值在数组 $\textit{nums}$ 中且节点的前一个点不在数组 $\textit{nums}$ 中。

遍历链表，计算出满足条件的点的个数即可。因为需要多次判断值是否位于数组 $\textit{nums}$ 中，用一个哈希集合保存数组 $\textit{nums}$ 中的点可以降低时间复杂度。

**代码**

```Python [sol1-Python3]
class Solution:
    def numComponents(self, head: Optional[ListNode], nums: List[int]) -> int:
        numsSet = set(nums)
        inSet = False
        res = 0
        while head:
            if head.val not in numsSet:
                inSet = False
            elif not inSet:
                inSet = True
                res += 1
            head = head.next
        return res
```

```Java [sol1-Java]
class Solution {
    public int numComponents(ListNode head, int[] nums) {
        Set<Integer> numsSet = new HashSet<Integer>();
        for (int num : nums) {
            numsSet.add(num);
        }
        boolean inSet = false;
        int res = 0;
        while (head != null) {
            if (numsSet.contains(head.val)) {
                if (!inSet) {
                    inSet = true;
                    res++;
                }
            } else {
                inSet = false;
            }
            head = head.next;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumComponents(ListNode head, int[] nums) {
        ISet<int> numsSet = new HashSet<int>();
        foreach (int num in nums) {
            numsSet.Add(num);
        }
        bool inSet = false;
        int res = 0;
        while (head != null) {
            if (numsSet.Contains(head.val)) {
                if (!inSet) {
                    inSet = true;
                    res++;
                }
            } else {
                inSet = false;
            }
            head = head.next;
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int numComponents(ListNode* head, vector<int>& nums) {
        unordered_set<int> numsSet;
        for (int num : nums) {
            numsSet.emplace(num);
        }
        bool inSet = false;
        int res = 0;
        while (head != nullptr) {
            if (numsSet.count(head->val)) {
                if (!inSet) {
                    inSet = true;
                    res++;
                }
            } else {
                inSet = false;
            }
            head = head->next;
        }
        return res;
    }
};
```

```C [sol1-C]
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

int numComponents(struct ListNode* head, int* nums, int numsSize) {
    HashItem *numsSet = NULL;
    for (int i = 0; i < numsSize; i++) {
        hashAddItem(&numsSet, nums[i]);
    }
    bool inSet = false;
    int res = 0;
    while (head != NULL) {
        if (hashFindItem(&numsSet, head->val) != NULL) {
            if (!inSet) {
                inSet = true;
                res++;
            }
        } else {
            inSet = false;
        }
        head = head->next;
    }
    hashFree(&numsSet);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var numComponents = function(head, nums) {
    const numsSet = new Set();
    for (const num of nums) {
        numsSet.add(num);
    }
    let inSet = false;
    let res = 0;
    while (head) {
        if (numsSet.has(head.val)) {
            if (!inSet) {
                inSet = true;
                res++;
            }
        } else {
            inSet = false;
        }
        head = head.next;
    }
    return res;
};
```

```go [sol1-Golang]
func numComponents(head *ListNode, nums []int) (ans int) {
    set := make(map[int]struct{}, len(nums))
    for _, v := range nums {
        set[v] = struct{}{}
    }
    for inSet := false; head != nil; head = head.Next {
        if _, ok := set[head.Val]; !ok {
            inSet = false
        } else if !inSet {
            inSet = true
            ans++
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，需要遍历一遍链表。

- 空间复杂度：$O(m)$，其中 $m$ 是数组 $\textit{nums}$ 的长度，需要一个哈希集合来存储 $\textit{nums}$ 的元素。