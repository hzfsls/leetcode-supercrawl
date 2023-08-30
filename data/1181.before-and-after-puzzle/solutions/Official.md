#### 方法一：哈希表、排序

**思路**

本题更偏向于工程问题，对算法的要求不高。题目要求前后拼接两个短语，且**第一个短语的最后一个单词 和 第二个短语的第一个单词 必须相同**。那么我们只需要找到每个短语的第一个单词和最后一个单词，然后和其他短语逐一比较。因为需要保证最后返回的列表的单词没有重复，先使用哈希表记录所有拼接后的短语，最后放到列表中进行排序即可。

**算法**

1. 遍历字符串数组 `phrases`，根据空格切割字符串，将字符串的第一个单词和最后一个单词存到新的数组中，新的数组 `sp` 需要保持和 `phrases` 同样的顺序。
2. 二重遍历新数组 `sp`，如果 `sp[i][0] == sp[j][1]` 说明下标为 `i` 和 `j` 的两个短语满足要求，将他们拼接放到哈希表中。
3. 将哈希表中的短语存到新的字符串数组中，排序字符串数组输出结果。

**代码**

```golang [ ]
func beforeAndAfterPuzzles(phrases []string) []string {
    n := len(phrases)
    sp := [][]string{}
    for i := 0; i < n; i++ {
        s := strings.Split(phrases[i], " ")
        sp = append(sp, []string{s[0], s[len(s)-1]})
    }
    m := map[string]bool{}
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
           if i == j {
               continue
           }
           if sp[i][0] == sp[j][1] {
               m[phrases[j] + phrases[i][len(sp[i][0]):]] = true
           }
        }
    }
    ret := make([]string, 0)
    for k := range m {
        ret = append(ret, k)
    }
    sort.Strings(ret)
    return ret
}
```

**复杂度分析**

- 时间复杂度：$O(N^2K(\log N+\log K))$，其中 $N$ 为字符串数组 `phrases` 的长度， $K$ 为字符串短语的平均长度。二重遍历字符串数组的时间复杂度为 $O(N^2K)$。哈希表的长度最大为 $N(N-1)$，拼接后的字符串最长为 $2K - C$，$C$ 为字符串首尾相同的单词长度。字符串数组排序的时间复杂度为 $O(N(N-1)(2K-C)(\log N(N-1) + \log(2K-C))) = O(N^2 K (\log N + \log K))$。

- 空间复杂度：$O(N^2K)$，其中 $N$ 为字符串数组 `phrases` 的大小，$K$ 为字符串短语的平均长度。哈希表最大为 $N(N-1)$，每一项所占空间为 $O(K)$，二维数组 `sp` 最大为字符串数组 `phrases` 的大小。