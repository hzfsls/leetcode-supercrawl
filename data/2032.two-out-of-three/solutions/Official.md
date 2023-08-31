## [2032.至少在两个数组中出现的值 中文官方题解](https://leetcode.cn/problems/two-out-of-three/solutions/100000/zhi-shao-zai-liang-ge-shu-zu-zhong-chu-x-5131)
#### 方法一：哈希表

**思路与算法**

题目给出三个整数数组 $\textit{nums}_1$、$\textit{nums}_2$ 和 $\textit{nums}_3$。现在我们需要求一个**元素各不相同**的数组，其中的元素为至少在数组 $\textit{nums}_1$、$\textit{nums}_2$ 和 $\textit{nums}_3$ 中两个数组出现的全部元素。

我们可以用「哈希表」来实现——由于只有三个数组，所以我们一个整数的最低三个二进制位来标记某一个数在哪几个数组中，$1$ 表示该数在对应的数组中的，反之 $0$ 表示不在。最后我们只需要判断每一个数对应的标记数字中二进制位个数是否大于 $1$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def twoOutOfThree(self, nums1: List[int], nums2: List[int], nums3: List[int]) -> List[int]:
        mask = defaultdict(int)
        for i, nums in enumerate((nums1, nums2, nums3)):
            for x in nums:
                mask[x] |= 1 << i
        return [x for x, m in mask.items() if m & (m - 1)]
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> twoOutOfThree(vector<int>& nums1, vector<int>& nums2, vector<int>& nums3) {
        unordered_map<int, int> mp;
        for (auto& i : nums1) {
            mp[i] = 1;
        }
        for (auto& i : nums2) {
            mp[i] |= 2;
        }
        for (auto& i : nums3) {
            mp[i] |= 4;
        }
        vector<int> res;
        for (auto& [k, v] : mp) {
            if (v & (v - 1)) {
                res.push_back(k);
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> twoOutOfThree(int[] nums1, int[] nums2, int[] nums3) {
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        for (int i : nums1) {
            map.put(i, 1);
        }
        for (int i : nums2) {
            map.put(i, map.getOrDefault(i, 0) | 2);
        }
        for (int i : nums3) {
            map.put(i, map.getOrDefault(i, 0) | 4);
        }
        List<Integer> res = new ArrayList<Integer>();
        for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
            int k = entry.getKey(), v = entry.getValue();
            if ((v & (v - 1)) != 0) {
                res.add(k);
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> TwoOutOfThree(int[] nums1, int[] nums2, int[] nums3) {
        IDictionary<int, int> dictionary = new Dictionary<int, int>();
        foreach (int i in nums1) {
            dictionary.TryAdd(i, 1);
        }
        foreach (int i in nums2) {
            dictionary.TryAdd(i, 0);
            dictionary[i] |= 2;
        }
        foreach (int i in nums3) {
            dictionary.TryAdd(i, 0);
            dictionary[i] |= 4;
        }
        IList<int> res = new List<int>();
        foreach (KeyValuePair<int, int> pair in dictionary) {
            int k = pair.Key, v = pair.Value;
            if ((v & (v - 1)) != 0) {
                res.Add(k);
            }
        }
        return res;
    }
}
```

```C [sol1-C]
#define MAX_NUM 100

int* twoOutOfThree(int* nums1, int nums1Size, int* nums2, int nums2Size, int* nums3, int nums3Size, int* returnSize) {
    int mp[MAX_NUM + 1];
    memset(mp, 0, sizeof(mp));
    for (int i = 0; i < nums1Size; i++) {
        mp[nums1[i]] = 1;
    }
    for (int i = 0; i < nums2Size; i++) {
        mp[nums2[i]] |= 2;
    }
    for (int i = 0; i < nums3Size; i++) {
        mp[nums3[i]] |= 4;
    }
    int *res = (int *)malloc(sizeof(int) * MAX_NUM);
    int pos = 0;
    for (int i = 1; i <= MAX_NUM; i++) {
        if (mp[i] & (mp[i] - 1)) {
            res[pos++] = i;
        }
    }
    *returnSize = pos;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var twoOutOfThree = function(nums1, nums2, nums3) {
    const map = new Map();
    for (const i of nums1) {
        map.set(i, 1);
    }
    for (const i of nums2) {
        map.set(i, (map.get(i) || 0) | 2);
    }
    for (const i of nums3) {
        map.set(i, (map.get(i) || 0) | 4);
    }
    const res = [];
    for (const [k, v] of map.entries()) {
        if ((v & (v - 1)) !== 0) {
            res.push(k);
        }
    }
    return res;
};
```

```go [sol1-Golang]
func twoOutOfThree(nums1, nums2, nums3 []int) (ans []int) {
	mask := map[int]int{}
	for i, nums := range [][]int{nums1, nums2, nums3} {
		for _, x := range nums {
			mask[x] |= 1 << i
		}
	}
	for x, m := range mask {
		if m&(m-1) > 0 {
			ans = append(ans, x)
		}
	}
	return
}
```

**复杂度分析**

- 时间复杂度：$O(n_1 + n_2 + n_3)$，其中 $n_1$，$n_2$，$n_3$ 分别为数组 $\textit{nums}_1$，$\textit{nums}_2$，$\textit{nums}_3$ 的长度。
- 空间复杂度：$O(n_1 + n_2 + n_3)$，其中 $n_1$，$n_2$，$n_3$ 分别为数组 $\textit{nums}_1$，$\textit{nums}_2$，$\textit{nums}_3$ 的长度，主要为哈希表的空间开销。