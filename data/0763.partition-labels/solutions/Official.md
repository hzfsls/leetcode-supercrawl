## [763.划分字母区间 中文官方题解](https://leetcode.cn/problems/partition-labels/solutions/100000/hua-fen-zi-mu-qu-jian-by-leetcode-solution)
#### 方法一：贪心

由于同一个字母只能出现在同一个片段，显然同一个字母的第一次出现的下标位置和最后一次出现的下标位置必须出现在同一个片段。因此需要遍历字符串，得到每个字母最后一次出现的下标位置。

在得到每个字母最后一次出现的下标位置之后，可以使用贪心的方法将字符串划分为尽可能多的片段，具体做法如下。

- 从左到右遍历字符串，遍历的同时维护当前片段的开始下标 $\textit{start}$ 和结束下标 $\textit{end}$，初始时 $\textit{start}=\textit{end}=0$。

- 对于每个访问到的字母 $c$，得到当前字母的最后一次出现的下标位置 $\textit{end}_c$，则当前片段的结束下标一定不会小于 $\textit{end}_c$，因此令 $\textit{end}=\max(\textit{end},\textit{end}_c)$。

- 当访问到下标 $\textit{end}$ 时，当前片段访问结束，当前片段的下标范围是 $[\textit{start},\textit{end}]$，长度为 $\textit{end}-\textit{start}+1$，将当前片段的长度添加到返回值，然后令 $\textit{start}=\textit{end}+1$，继续寻找下一个片段。

- 重复上述过程，直到遍历完字符串。

上述做法使用贪心的思想寻找每个片段可能的最小结束下标，因此可以保证每个片段的长度一定是符合要求的最短长度，如果取更短的片段，则一定会出现同一个字母出现在多个片段中的情况。由于每次取的片段都是符合要求的最短的片段，因此得到的片段数也是最多的。

由于每个片段访问结束的标志是访问到下标 $\textit{end}$，因此对于每个片段，可以保证当前片段中的每个字母都一定在当前片段中，不可能出现在其他片段，可以保证同一个字母只会出现在同一个片段。

```Java [sol1-Java]
class Solution {
    public List<Integer> partitionLabels(String s) {
        int[] last = new int[26];
        int length = s.length();
        for (int i = 0; i < length; i++) {
            last[s.charAt(i) - 'a'] = i;
        }
        List<Integer> partition = new ArrayList<Integer>();
        int start = 0, end = 0;
        for (int i = 0; i < length; i++) {
            end = Math.max(end, last[s.charAt(i) - 'a']);
            if (i == end) {
                partition.add(end - start + 1);
                start = end + 1;
            }
        }
        return partition;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> partitionLabels(string s) {
        int last[26];
        int length = s.size();
        for (int i = 0; i < length; i++) {
            last[s[i] - 'a'] = i;
        }
        vector<int> partition;
        int start = 0, end = 0;
        for (int i = 0; i < length; i++) {
            end = max(end, last[s[i] - 'a']);
            if (i == end) {
                partition.push_back(end - start + 1);
                start = end + 1;
            }
        }
        return partition;
    }
};
```

```JavaScript [sol1-JavaScript]
var partitionLabels = function(s) {
    const last = new Array(26);
    const length = s.length;
    const codePointA = 'a'.codePointAt(0);
    for (let i = 0; i < length; i++) {
        last[s.codePointAt(i) - codePointA] = i;
    }
    const partition = [];
    let start = 0, end = 0;
    for (let i = 0; i < length; i++) {
        end = Math.max(end, last[s.codePointAt(i) - codePointA]);
        if (i == end) {
            partition.push(end - start + 1);
            start = end + 1;
        }
    }
    return partition;
};
```

```Python [sol1-Python3]
class Solution:
    def partitionLabels(self, s: str) -> List[int]:
        last = [0] * 26
        for i, ch in enumerate(s):
            last[ord(ch) - ord("a")] = i
        
        partition = list()
        start = end = 0
        for i, ch in enumerate(s):
            end = max(end, last[ord(ch) - ord("a")])
            if i == end:
                partition.append(end - start + 1)
                start = end + 1
        
        return partition
```

```Golang [sol1-Golang]
func partitionLabels(s string) (partition []int) {
    lastPos := [26]int{}
    for i, c := range s {
        lastPos[c-'a'] = i
    }
    start, end := 0, 0
    for i, c := range s {
        if lastPos[c-'a'] > end {
            end = lastPos[c-'a']
        }
        if i == end {
            partition = append(partition, end-start+1)
            start = end + 1
        }
    }
    return
}
```

```C [sol1-C]
int* partitionLabels(char* s, int* returnSize) {
    int last[26];
    int length = strlen(s);
    for (int i = 0; i < length; i++) {
        last[s[i] - 'a'] = i;
    }
    int* partition = malloc(sizeof(int) * length);
    int start = 0, end = 0;
    *returnSize = 0;
    for (int i = 0; i < length; i++) {
        end = fmax(end, last[s[i] - 'a']);
        if (i == end) {
            partition[(*returnSize)++] = end - start + 1;
            start = end + 1;
        }
    }
    return partition;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。需要遍历字符串两次，第一次遍历时记录每个字母最后一次出现的下标位置，第二次遍历时进行字符串的划分。

- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 是字符串中的字符集。这道题中，字符串只包含小写字母，因此 $|\Sigma|=26$。