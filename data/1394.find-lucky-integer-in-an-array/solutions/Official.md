#### 方法一：哈希映射

**思路**

我们可以使用哈希映射来解决这个问题，把数值作为键，把数值出现的次数作为值。具体地，我们先遍历原数组建立哈希表，然后遍历哈希表找到最大的键和值相等的元素作为答案，如果找不到就返回 -1。

![fig1](https://assets.leetcode-cn.com/solution-static/1394_fig1.gif)

**代码**

```C++ [sol1-C++]
class Solution {
public:
    unordered_map <int, int> m;
    int findLucky(vector<int>& arr) {
        for (auto x: arr) ++m[x];
        int ans = -1;
        for (auto [key, value]: m) {
            if (key == value) {
                ans = max(ans, key);
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def findLucky(self, arr: List[int]) -> int:
        m = dict()
        for x in arr:
            m[x] = m.get(x, 0) + 1
        ans = -1
        for (key, value) in m.items():
            if key == value:
                ans = max(ans, key)
        return ans
```

```Java [sol1-Java]
class Solution {
    public int findLucky(int[] arr) {
        Map<Integer, Integer> m = new HashMap<Integer, Integer>();
        for (int x : arr) {
            m.put(x, m.getOrDefault(x, 0) + 1);
        }
        int ans = -1;
        for (Map.Entry<Integer, Integer> entry : m.entrySet()) {
            int key = entry.getKey(), value = entry.getValue();
            if (key == value) {
                ans = Math.max(ans, key);
            }
        }
        return ans;
    }
}
```

```JavaScript [sol1-JavaScript]
var findLucky = function(arr) {
    let m = {}
    arr.forEach((x) => {
        m[x] = (x in m ? m[x] + 1 : 1)
    })
    let ans = -1
    Object.keys(m).forEach((key) => {
        ans = (key == m[key] ? Math.max(key, ans) : ans)
    })
    return ans
};
```

**复杂度分析**

记数组中的的元素个数为 $n$，则哈希表中最多有 $n$ 个键值对。

- 时间复杂度：遍历数组的时间代价是 $O(n)$，遍历哈希表的时间代价也是 $O(n)$，故渐进时间复杂度 $O(n)$。

- 空间复杂度：哈希表中最多有 $n$ 个键值对，故渐进空间复杂度 $O(n)$。