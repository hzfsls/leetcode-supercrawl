#### 方法一： 暴力法

本题更偏向于工程问题，主要是对数据的处理。

**思路**

题目要求的是**一个长度为 3 的页面路径列表**，最直观的思路就是找到所有长度为 3 的路径，统计每一种路径的访问人数，比较得到答案。

题目中有几个细节需要我们注意：
1. **至少按某种次序访问过一次**，这句话告诉我们需要根据时间排序。
2. **用户可能不是连续访问这三个路径的**。假设一个用户在 `1,2,3,4` 这 4 个时间点访问了 `a,b,c,d` 这 4 个网站，那么 `a,c,d` 也是一个合法的路径。
3. 题目要求的是**最多的用户**访问的路径，所以一个用户访问很多次，也只能算一次。

**算法**

1. 首先我们需要将 `username`、`timestamp` 和 `website` 这 3 个东西绑定起来。最直观的办法就是使用结构体。将 3 个数组使用结构体数组关联起来。
```
struct Node { name, timestap, website }
```
2. 对结构体数组按照 `timestamp` 排序，保证每个用户的访问次序。
3. 使用哈希表存储每一个用户的访问的网站，哈希表的键是用户名 `name`，值是一个字符串数组。数组的值就是对应的 `website`。因为第二步已经排过序了，所以数组是有序的，可以直接使用
4. 三重遍历每个用户的 `website`，获得所有的访问路径。再一次用哈希表存储所有的访问路径，对应的值就是用户的数量。
5. 最后通过遍历哈希表获得最多用户访问且字典序排列最小的那个值。

**代码**

```Golang [ ]
type Node struct {
    name string
    timestamp int
    website string
}

func mostVisitedPattern(username []string, timestamp []int, website []string) []string {
    n := make([]Node, len(username))
    for i := 0; i < len(username); i++ {
        n[i] = Node{username[i], timestamp[i], website[i]}
    }
    sort.Slice(n, func(i, j int) bool {
        return n[i].timestamp < n[j].timestamp // 保证用户的访问记录有序
    })
    m := make(map[string][]Node)
    for i := 0; i < len(n); i++ {
        m[n[i].name] = append(m[n[i].name], n[i]) // 获取每个用户的所有访问记录
    }
    route := make(map[[3]string]int)
    for _, v := range m {
        tmp := make(map[[3]string]int)
        for i := 0; i < len(v); i++ {
            for j := i + 1; j < len(v); j++ {
                for k := j + 1; k < len(v); k++ {
                    tmp[[3]string{v[i].website, v[j].website, v[k].website}] = 1 // 获取每个访问路径
                }
            }
        }
        for k1, v1 := range tmp {
            route[k1] += v1
        }
    }
    max := -1
    ret := [3]string{}
    for k, v := range route {
        if v > max {
            ret = k
            max = v
        } else if v == max {
            if k[0] < ret[0] || (k[0] == ret[0] && k[1] < ret[1] || (k[0] == ret[0] && k[1] == ret[1] && k[2] < ret[2])) {
                ret = k
            }
        }
    }
    return []string{ret[0], ret[1], ret[2]}
}
```

**复杂度分析**

假设本题的排序算法为插入排序。

- 时间复杂度：$O(n^{3})$。$n$ 为数组 `username` 的长度。插入排序的时间复杂度为 $O(n^{2})$，构建结构体数组和获取单个用户的访问记录的复杂度均为 $O(n)$。假设有 $k$ 个不同的人，那么每个人平均访问的网站数为 $n/k$，三重遍历的复杂度为 $O((n/k)^{3})$，加上最外层的人数，整个循环的复杂度为 $O(n^{3}/k^{2})$。 当 $k$ 为 `1` 的时候复杂度最坏为 $O(n^{3})$，最后遍历所有路径列表的最坏复杂度也为 $O(n^{3})$。

- 空间复杂度：$O(n^{3})$。$n$ 为数组 `username` 的长度。插入排序的空间复杂度为 $O(1)$。结构体数组和记录用户网页的哈希表的空间复杂度均为 $O(n)$。根据时间复杂度的分析，所有路径的最大数量为 $n^{3}$，所以记录路径的哈希表的空间复杂度为 $O(n^{3})$。