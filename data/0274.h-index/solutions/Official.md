## [274.H 指数 中文官方题解](https://leetcode.cn/problems/h-index/solutions/100000/h-zhi-shu-by-leetcode-solution-fnhl)
#### 方法一：排序

首先我们可以将初始的 $\text{H}$ 指数 $h$ 设为 $0$，然后将引用次数排序，并且对排序后的数组从大到小遍历。

根据 $\text{H}$ 指数的定义，如果当前 $\text{H}$ 指数为 $h$ **并且**在遍历过程中找到当前值 $\textit{citations}[i] > h$，则说明**我们找到了一篇被引用了至少 $h+1$ 次的论文**，所以**将现有的 $h$ 值加 $1$**。继续遍历直到 $h$ 无法继续增大。最后返回 $h$ 作为最终答案。

```Java [sol1-Java]
class Solution {
    public int hIndex(int[] citations) {
        Arrays.sort(citations);
        int h = 0, i = citations.length - 1; 
        while (i >= 0 && citations[i] > h) {
            h++; 
            i--;
        }
        return h;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int HIndex(int[] citations) {
        Array.Sort(citations);
        int h = 0, i = citations.Length - 1; 
        while (i >= 0 && citations[i] > h) {
            h++; 
            i--;
        }
        return h;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def hIndex(self, citations: List[int]) -> int:
        sorted_citation = sorted(citations, reverse = True)
        h = 0; i = 0; n = len(citations)
        while i < n and sorted_citation[i] > h:
            h += 1
            i += 1
        return h
```

```JavaScript [sol1-JavaScript]
var hIndex = function(citations) {
    citations.sort((a, b) => a - b);
    let h = 0, i = citations.length - 1; 
    while (i >= 0 && citations[i] > h) {
        h++; 
        i--;
    }
    return h;
};
```

```go [sol1-Golang]
func hIndex(citations []int) (h int) {
    sort.Ints(citations)
    for i := len(citations) - 1; i >= 0 && citations[i] > h; i-- {
        h++
    }
    return
}
```

```C++ [sol1-C++]
class Solution {
public:
    int hIndex(vector<int>& citations) {
        sort(citations.begin(), citations.end());
        int h = 0, i = citations.size() - 1;
        while (i >= 0 && citations[i] > h) {
            h++;
            i--;
        }
        return h;
    }
};
```

```C [sol1-C]
int cmp(int *a, int *b) {
    return *a - *b;
}

int hIndex(int *citations, int citationsSize) {
    qsort(citations, citationsSize, sizeof(int), cmp);
    int h = 0, i = citationsSize - 1;
    while (i >= 0 && citations[i] > h) {
        h++;
        i--;
    }
    return h;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为数组 $\textit{citations}$ 的长度。即为排序的时间复杂度。

- 空间复杂度：$O(\log n)$，其中 $n$ 为数组 $\textit{citations}$ 的长度。即为排序的空间复杂度。

#### 方法二：计数排序

根据上述解法我们发现，最终的时间复杂度与排序算法的时间复杂度有关，所以我们可以使用计数排序算法，新建并维护一个数组 $\textit{counter}$ 用来记录当前引用次数的论文有几篇。

根据定义，我们可以发现 $\text{H}$ 指数不可能大于总的论文发表数，所以对于引用次数超过论文发表数的情况，我们可以将其按照总的论文发表数来计算即可。这样我们可以限制参与排序的数的大小为 $[0,n]$（其中 $n$ 为总的论文发表数），使得计数排序的时间复杂度降低到 $O(n)$。

最后我们可以从后向前遍历数组 $\textit{counter}$，对于每个 $0 \le i \le n$，在数组 $\textit{counter}$ 中得到大于或等于当前引用次数 $i$ 的总论文数。当我们找到一个 $\text{H}$ 指数时跳出循环，并返回结果。

```Java [sol2-Java]
public class Solution {
    public int hIndex(int[] citations) {
        int n = citations.length, tot = 0;
        int[] counter = new int[n + 1];
        for (int i = 0; i < n; i++) {
            if (citations[i] >= n) {
                counter[n]++;
            } else {
                counter[citations[i]]++;
            }
        }
        for (int i = n; i >= 0; i--) {
            tot += counter[i];
            if (tot >= i) {
                return i;
            }
        }
        return 0;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int HIndex(int[] citations) {
        int n = citations.Length, tot = 0;
        int[] counter = new int[n + 1];
        for (int i = 0; i < n; i++) {
            if (citations[i] >= n) {
                counter[n]++;
            } else {
                counter[citations[i]]++;
            }
        }
        for (int i = n; i >= 0; i--) {
            tot += counter[i];
            if (tot >= i) {
                return i;
            }
        }
        return 0;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def hIndex(self, citations: List[int]) -> int:
        n = len(citations); tot = 0
        counter = [0] * (n+1)
        for c in citations:
            if c >= n:
                counter[n] += 1
            else:
                counter[c] += 1
        for i in range(n, -1, -1):
            tot += counter[i]
            if tot >= i:
                return i
        return 0
```

```JavaScript [sol2-JavaScript]
var hIndex = function(citations) {
    let n = citations.length, tot = 0;
    const counter = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) {
        if (citations[i] >= n) {
            counter[n]++;
        } else {
            counter[citations[i]]++;
        }
    }
    for (let i = n; i >= 0; i--) {
        tot += counter[i];
        if (tot >= i) {
            return i;
        }
    }
    return 0;
};
```

```go [sol2-Golang]
func hIndex(citations []int) (h int) {
    n := len(citations)
    counter := make([]int, n+1)
    for _, citation := range citations {
        if citation >= n {
            counter[n]++
        } else {
            counter[citation]++
        }
    }
    for i, tot := n, 0; i >= 0; i-- {
        tot += counter[i]
        if tot >= i {
            return i
        }
    }
    return 0
}
```

```C++ [sol2-C++]
class Solution {
public:
    int hIndex(vector<int>& citations) {
        int n = citations.size(), tot = 0;
        vector<int> counter(n + 1);
        for (int i = 0; i < n; i++) {
            if (citations[i] >= n) {
                counter[n]++;
            } else {
                counter[citations[i]]++;
            }
        }
        for (int i = n; i >= 0; i--) {
            tot += counter[i];
            if (tot >= i) {
                return i;
            }
        }
        return 0;
    }
};
```

```C [sol2-C]
int hIndex(int *citations, int citationsSize) {
    int n = citationsSize, tot = 0;
    int counter[n + 1];
    memset(counter, 0, sizeof(counter));
    for (int i = 0; i < n; i++) {
        if (citations[i] >= n) {
            counter[n]++;
        } else {
            counter[citations[i]]++;
        }
    }
    for (int i = n; i >= 0; i--) {
        tot += counter[i];
        if (tot >= i) {
            return i;
        }
    }
    return 0;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{citations}$ 的长度。需要遍历数组 $\textit{citations}$ 一次，以及遍历长度为 $n+1$ 的数组 $\textit{counter}$ 一次。

- 空间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{citations}$ 的长度。需要创建长度为 $n+1$ 的数组 $\textit{counter}$。

#### 方法三：二分搜索

我们需要找到一个值 `h`，它是满足「有 `h` 篇论文的引用次数至少为 `h`」的最大值。小于等于 `h` 的所有值 `x` 都满足这个性质，而大于 `h` 的值都不满足这个性质。同时因为我们可以用较短时间（扫描一遍数组的时间复杂度为 $O(n)$，其中 $n$ 为数组 $\textit{citations}$ 的长度）来判断 `x` 是否满足这个性质，所以这个问题可以用二分搜索来解决。

设查找范围的初始左边界 $left$ 为 $0$，初始右边界 $right$ 为 $n$。每次在查找范围内取中点 $mid$，同时扫描整个数组，判断是否至少有 `mid` 个数大于 `mid`。如果有，说明要寻找的 `h` 在搜索区间的右边，反之则在左边。

```Java [sol3-Java]
class Solution {
    public int hIndex(int[] citations) {
        int left=0,right=citations.length;
        int mid=0,cnt=0;
        while(left<right){
            // +1 防止死循环
            mid=(left+right+1)>>1;
            cnt=0;
            for(int i=0;i<citations.length;i++){
                if(citations[i]>=mid){
                    cnt++;
                }
            }
            if(cnt>=mid){
                // 要找的答案在 [mid,right] 区间内
                left=mid;
            }else{
                // 要找的答案在 [0,mid) 区间内
                right=mid-1;
            }
        }
        return left;
    }
}
```

```C [sol3-C]
int hIndex(int* citations, int citationsSize){
    int left=0,right=citationsSize;
    int mid=0,cnt=0;
    while(left<right){
        // +1 防止死循环
        mid=(left+right+1)>>1;
        cnt=0;
        for(int i=0;i<citationsSize;i++){
            if(citations[i]>=mid){
                cnt++;
            }
        }
        if(cnt>=mid){
            // 要找的答案在 [mid,right] 区间内
            left=mid;
        }else{
            // 要找的答案在 [0,mid) 区间内
            right=mid-1;
        }
    }
    return left;
}
```

```C++ [sol3-C++]
class Solution {
public:
    int hIndex(vector<int>& citations) {
        int left=0,right=citations.size();
        int mid=0,cnt=0;
        while(left<right){
            // +1 防止死循环
            mid=(left+right+1)>>1;
            cnt=0;
            for(int i=0;i<citations.size();i++){
                if(citations[i]>=mid){
                    cnt++;
                }
            }
            if(cnt>=mid){
                // 要找的答案在 [mid,right] 区间内
                left=mid;
            }else{
                // 要找的答案在 [0,mid) 区间内
                right=mid-1;
            }
        }
        return left;
    }
};
```

```go [sol3-Golang]
func hIndex(citations []int) int {
    // 答案最多只能到数组长度
    left,right:=0,len(citations)
    var mid int
    for left<right{
        // +1 防止死循环
        mid=(left+right+1)>>1
        cnt:=0
        for _,v:=range citations{
            if v>=mid{
                cnt++
            }
        }
        if cnt>=mid{
            // 要找的答案在 [mid,right] 区间内
            left=mid
        }else{
            // 要找的答案在 [0,mid) 区间内
            right=mid-1
        }
    }
    return left
}
```

```C# [sol3-C#]
public class Solution {
    public int HIndex(int[] citations) {
        int left=0,right=citations.Length;
        int mid=0,cnt=0;
        while(left<right){
            // +1 防止死循环
            mid=(left+right+1)>>1;
            cnt=0;
            for(int i=0;i<citations.Length;i++){
                if(citations[i]>=mid){
                    cnt++;
                }
            }
            if(cnt>=mid){
                // 要找的答案在 [mid,right] 区间内
                left=mid;
            }else{
                // 要找的答案在 [0,mid) 区间内
                right=mid-1;
            }
        }
        return left;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def hIndex(self, citations: List[int]) -> int:
        left,right = 0,len(citations)
        while left<right:
            # +1 防止死循环
            mid = left+right
            cnt = 0
            for v in citations:
                if v>=mid:
                    cnt+=1
            if cnt>=mid:
                # 要找的答案在 [mid,right] 区间内
                left=mid
            else:
                # 要找的答案在 [0,mid) 区间内
                right=mid-1
        return left
```

```JavaScript [sol3-JavaScript]
/**
 * @param {number[]} citations
 * @return {number}
 */
var hIndex = function(citations) {
    let left = 0, right = citations.length
    while (left<right){
        // +1 防止死循环
        let mid = left + right
        let cnt = 0
        for (let v of citations){
            if (v >= mid){
                cnt+=1
            }
        }
        if(cnt>=mid){
            // 要找的答案在 [mid,right] 区间内
            left=mid
        }else{
            // 要找的答案在 [0,mid) 区间内
            right=mid-1
        }
    }
    return left
};
```

**复杂度分析**

- 时间复杂度：$O(n log n)$，其中 $n$ 为数组 $\textit{citations}$ 的长度。需要进行 $log n$ 次二分搜索，每次二分搜索需要遍历数组 $\textit{citations}$ 一次。
- 空间复杂度：$O(1)$，只需要常数个变量来进行二分搜索。