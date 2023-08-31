## [1754.构造字典序最大的合并字符串 中文官方题解](https://leetcode.cn/problems/largest-merge-of-two-strings/solutions/100000/gou-zao-zi-dian-xu-zui-da-de-he-bing-zi-g6az1)

#### 方法一：贪心算法

**思路与算法**

题目要求合并两个字符串 $\textit{word}_1$ 与 $\textit{word}_2$，且要求合并后的字符串字典序最大。首先需要观察一下合并的选择规律，假设当前需要从 $\textit{word}_1$ 的第 $i$ 个字符和 $\textit{word}_2$ 的第 $j$ 个字符选择一个字符加入到新字符串 $\textit{merge}$ 中，需要进行分类讨论:
+ 如果 $\textit{word}_1[i] > \textit{word}_2[j]$，此时我们的最优选择是移除 $\textit{word}_1[i]$ 加入到 $\textit{merge}$ 中，从而保证 $\textit{merge}$ 的字典序最大；

+ 如果 $\textit{word}_1[i] < \textit{word}_2[j]$，此时我们的最优选择是移除 $\textit{word}_2[j]$ 加入到 $\textit{merge}$，从而保证 $\textit{merge}$ 的字典序最大；

+ 如果 $\textit{word}_1[i] = \textit{word}_2[j]$，此时则需要进一步讨论，结论如下：
    + 如果 $\textit{word}_1$ 从 $i$ 开始的后缀字典序大于 $\textit{word}_2$ 从 $j$ 开始的后缀，则此时优先选择移除 $\textit{word}_1[i]$ 加入到 $\textit{merge}$ 中；
    + 如果 $\textit{word}_1$ 从 $i$ 开始的后缀字典序小于 $\textit{word}_2$ 从 $j$ 开始的后缀，则此时优先选择移除 $\textit{word}_2[j]$ 加入到 $\textit{merge}$ 中；
    + 如果 $\textit{word}_1$ 从 $i$ 开始的后缀字典序等于 $\textit{word}_2$ 从 $j$ 开始的后缀，则此时任选一个均可；

当两个字符相等时，则我们最优选择为后缀较大的字符串，分类讨论如下：
假设 $\textit{word}_1[i] = \textit{word}_2[j]$，此时两个字符串分别从 $i,j$ 开始还有 $l$ 个字符相等，则此时 $\textit{word}_1[i+k] = \textit{word}_2[j+k], k \in [0,l-1]$，第 $l+1$ 个字符时二者不相等，即满足 $\textit{word}_1[i + l] \neq \textit{word}_2[j + l]$，我们可以假设 $\textit{word}_1[i + l] < \textit{word}_2[j + l]$。

例如 $\textit{word}_1 = \text{``bcadea"}$ 与 $\textit{word}_2 = \text{``\_bcadf''}$，此时 $i = 0, j = 1, l = 4$。

+ 假设我们每次都选择从当前位置后缀较大的字符串，由于两个字符串分别从 $i,j$ 开始连续 $l$ 个字符相等，此时可以知道 $\textit{word}_2$ 向右移动了 $l$ 个位置到达了 $j + l$，此时 $\textit{word}_1$ 向右移动了 $t$ 个位置到达了 $i + t$，此时一定满足 $t \le l$，$\textit{word}_2$ 优先向右移动到达字符 $\textit{word}_2[j + l]$ 处，此时字典序较大的字符 $\textit{word}_2[j + l]$ 优先进行合并。如果 $\textit{word}_2$ 移动 $k$ 个字符时，$\textit{word}_1$ 最多也移动 $k$ 个字符，由于两个字符串同时移动 $k$ 个位置会遇到相同字符时总是选择字典序较大的后缀，因此 $\textit{word}_2$ 一定先移动 $l$ 个位置，可以参考如下图所示：

<![update1](https://assets.leetcode-cn.com/solution-static/1754/1754_1.png),![update2](https://assets.leetcode-cn.com/solution-static/1754/1754_2.png),![update3](https://assets.leetcode-cn.com/solution-static/1754/1754_3.png),![update4](https://assets.leetcode-cn.com/solution-static/1754/1754_4.png),![update5](https://assets.leetcode-cn.com/solution-static/1754/1754_5.png),![update5](https://assets.leetcode-cn.com/solution-static/1754/1754_6.png),![update5](https://assets.leetcode-cn.com/solution-static/1754/1754_7.png)>

+ 假设我们每次都选择从当前位置后缀较小的字符串，由于两个字符串分别从 $i,j$ 开始连续 $l$ 个字符相等，此时可以知道 $\textit{word}_1$ 向右移动了 $l$ 个位置到达了 $i + l$，此时 $\textit{word}_2$ 向右移动了 $t$ 个位置到达了 $j + t$，此时一定满足 $t \le l$，$\textit{word}_1$ 优先向右移动到达字符 $\textit{word}_1[i + l]$ 处，此时字典序较小的字符 $\textit{word}_1[i + k]$ 优先进行合并。如果 $\textit{word}_1$ 移动 $k$ 个字符时，$\textit{word}_2$ 最多也移动 $k$ 个字符，而每次同时移动 $k$ 个位置遇到相同字符时总是选择字典序较小的后缀，因此 $\textit{word}_1$ 一定先移动 $l$ 个位置，可以参考如下图所示：

<![update1](https://assets.leetcode-cn.com/solution-static/1754/1754_8.png),![update2](https://assets.leetcode-cn.com/solution-static/1754/1754_9.png),![update3](https://assets.leetcode-cn.com/solution-static/1754/1754_10.png),![update4](https://assets.leetcode-cn.com/solution-static/1754/1754_11.png),![update5](https://assets.leetcode-cn.com/solution-static/1754/1754_12.png),![update5](https://assets.leetcode-cn.com/solution-static/1754/1754_13.png),![update5](https://assets.leetcode-cn.com/solution-static/1754/1754_14.png)>

+ 我们观察到不论以何种方式进行合并，两个字符串一共移动了 $l + t$ 个位置，此时字符串 $\textit{merge}$ 也合并了长度为 $l + t$ 的字符串 $s$，不论以何种方式进行合并的字符串 $s$ 总是相同的，而此时下一个字符优先选择字典序较大的字符进行合并这样保证合并后的字典序最大。我们可以观察到上述示例中的 $s = \text{``bcbcad''}$。

其余的特殊情况跟上述思路一样，综上我们可以得到结论每次选择字典序较大的后缀进行移除一定可以保证得到最优的结果，其余的选择方法不一定能够保证得到最优结果。

**代码**

```Python [sol1-Python3]
class Solution:
    def largestMerge(self, word1: str, word2: str) -> str:
        merge = []
        i, j, n, m = 0, 0, len(word1), len(word2)
        while i < n or j < m:
            if i < n and word1[i:] > word2[j:]:
                merge.append(word1[i])
                i += 1
            else:
                merge.append(word2[j])
                j += 1
        return ''.join(merge)
```

```C++ [sol1-C++]
class Solution {
public:
    string largestMerge(string word1, string word2) {
        string merge;
        int i = 0, j = 0;
        while (i < word1.size() || j < word2.size()) {
            if (i < word1.size() && word1.substr(i) > word2.substr(j)) {
                merge.push_back(word1[i++]);
            } else {
                merge.push_back(word2[j++]);
            }
        }
        return merge;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String largestMerge(String word1, String word2) {
        StringBuilder merge = new StringBuilder();
        int i = 0, j = 0;
        while (i < word1.length() || j < word2.length()) {
            if (i < word1.length() && word1.substring(i).compareTo(word2.substring(j)) > 0) {
                merge.append(word1.charAt(i));
                i++;
            } else {
                merge.append(word2.charAt(j));
                j++;
            }
        }
        return merge.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string LargestMerge(string word1, string word2) {
        StringBuilder merge = new StringBuilder();
        int i = 0, j = 0;
        while (i < word1.Length || j < word2.Length) {
            if (i < word1.Length && word1.Substring(i).CompareTo(word2.Substring(j)) > 0) {
                merge.Append(word1[i]);
                i++;
            } else {
                merge.Append(word2[j]);
                j++;
            }
        }
        return merge.ToString();
    }
}
```

```C [sol1-C]
char * largestMerge(char * word1, char * word2) {
    int m = strlen(word1), n = strlen(word2);
    char *merge = (char *)malloc(sizeof(char) * (m + n + 1));
    int i = 0, j = 0, pos = 0;
    while (i < m || j < n) {
        if (i < m && strcmp(word1 + i, word2 + j) > 0) {
            merge[pos] = word1[i];
            pos++, i++;
        } else {
            merge[pos] = word2[j];
            pos++, j++;
        }
    }
    merge[pos] = '\0';
    return merge;
}
```

```JavaScript [sol1-JavaScript]
var largestMerge = function(word1, word2) {
    let merge = '';
    let i = 0, j = 0;
    while (i < word1.length || j < word2.length) {
        if (i < word1.length && word1.slice(i) > word2.slice(j)) {
            merge += word1[i];
            i++;
        } else {
            merge += word2[j];
            j++;
        }
    }
    return merge;
};
```

```go [sol1-Golang]
func largestMerge(word1, word2 string) string {
	merge := []byte{}
	i, j, n, m := 0, 0, len(word1), len(word2)
	for i < n || j < m {
		if i < n && word1[i:] > word2[j:] {
			merge = append(merge, word1[i])
			i += 1
		} else {
			merge = append(merge, word2[j])
			j += 1
		}
	}
	return string(merge)
}
```

**复杂度分析**

- 时间复杂度：$O((m + n) \times \max(m, n))$，其中 $m,n$ 分别表示两个字符串的长度。每次压入字符时需要进行后缀比较，每次两个字符串后缀比较的时间复杂度为 $O(\max(m, n))$，一共最多需要比较 $m + n$ 次，因此总的时间复杂度为 $O((m + n) \times \max(m, n))$。

- 空间复杂度：$O(m + n)$，其中 $m,n$ 分别表示两个字符串的长度。每次比较时都会生成两个字符串的后缀，所需要的空间为 $O(m + n)$。

#### 方法二：后缀数组

**思路与算法**

后缀数组的计算过程较为复杂，后缀数组利用了倍增的思想来比较两个后缀的大小，详细资料可以参考「[后缀数组简介](https://oi-wiki.org/string/sa/)」以及 「[Suffix Array](http://se.moevm.info/lib/exe/fetch.php/courses:algorithms_building_and_analysis:algorithmic_challenges_2_suffix_array.pdf)」，在此不再展开描述，本题中计算后缀数组时用字符 $\text{`*'}$ 标识字符串的结尾。

此种与方法一同样的思路，我们在比较两个字符串 $\textit{word}_1,\textit{word}_2$ 的后缀时，直接利用后缀数组来比较两个后缀的字典序大小。在两个 $\textit{word}_1$ 与 $\textit{word}_2$ 的中间添加一个字符 $\texttt{`@'}$ 来表示 $\textit{word}_1$ 的结尾，$\texttt{`@'}$ 比所有的英文字母都小，且比字符串的末尾 $\texttt{`*'}$ 要大。设字符串 $\textit{word}_1,\textit{word}_2$ 的长度分别为 $m,n$，我们计算出合并后的字符串 $\textit{str}$ 的后缀排名 $\textit{rank}$，则 $\textit{word}_1$ 中的第 $i$ 个后缀对应着 $\textit{str}$ 的第 $i$ 个后缀，$\textit{word}_2$ 中的第 $j$ 个后缀对应着 $\textit{str}$ 的第 $m + 1 + j$ 个后缀。进行合并时我们可以直接比较两个字符串的后缀排序，每次选取后缀较大的进行合并即可。

**代码**

```C++ [sol2-C++]
vector<int> sortCharacters(const string & text) {
    int n = text.size();
    vector<int> count(128), order(n);
    for (auto c : text) {
        count[c]++;
    }    
    for (int i = 1; i < 128; i++) {
        count[i] += count[i - 1];
    }
    for (int i = n - 1; i >= 0; i--) {
        count[text[i]]--;
        order[count[text[i]]] = i;
    }
    return order;
}

vector<int> computeCharClasses(const string & text, vector<int> & order) {
    int n = text.size();
    vector<int> res(n, 0);
    res[order[0]] = 0;
    for (int i = 1; i < n; i++) {
        if (text[order[i]] != text[order[i - 1]]) {
            res[order[i]] = res[order[i - 1]] + 1;
        } else {
            res[order[i]] = res[order[i - 1]];
        }
    }
    return res;
}

vector<int> sortDoubled(const string & text, int len, vector<int> & order, vector<int> & classfiy) {
    int n = text.size();
    vector<int> count(n), newOrder(n);
    for (int i = 0; i < n; i++) {
        count[classfiy[i]]++;
    }
    for (int i = 1; i < n; i++) {
        count[i] += count[i - 1];
    }
    for (int i = n - 1; i >= 0; i--) {
        int start = (order[i] - len + n) % n;
        int cl = classfiy[start];
        count[cl]--;
        newOrder[count[cl]] = start;
    }
    return newOrder;
}

vector<int> updateClasses(vector<int> & newOrder, vector<int> & classfiy, int len) {
    int n = newOrder.size();
    vector<int> newClassfiy(n, 0);
    newClassfiy[newOrder[0]] = 0;
    for (int i = 1; i < n; i++) {
        int curr = newOrder[i];
        int prev = newOrder[i - 1];
        int mid = curr + len;
        int midPrev = (prev + len) % n;
        if (classfiy[curr] != classfiy[prev] || classfiy[mid] != classfiy[midPrev]) {
             newClassfiy[curr] = newClassfiy[prev] + 1;
        } else {
             newClassfiy[curr] = newClassfiy[prev];
        }
    }
    return newClassfiy;
}

vector<int> buildSuffixArray(const string& text) {
    vector<int> order = sortCharacters(text);
    vector<int> classfiy = computeCharClasses(text, order);
    int len = 1;
    int n = text.size();
    for (int i = 1; i < n; i <<= 1) {
        order = sortDoubled(text, i, order, classfiy);
        classfiy = updateClasses(order, classfiy, i);
    }
    return order;
}

class Solution {
public:
    string largestMerge(string word1, string word2) {
        int m = word1.size(), n = word2.size();
        string str = word1 + "@" + word2 + "*";
        vector<int> suffixArray = buildSuffixArray(str); 
        vector<int> rank(m + n + 2);
        for (int i = 0; i < m + n + 2; i++) {
            rank[suffixArray[i]] = i;
        }

        string merge;
        int i = 0, j = 0;
        while (i < m || j < n) {
            if (i < m && rank[i] > rank[m + 1 + j]) {
                merge.push_back(word1[i++]);
            } else {
                merge.push_back(word2[j++]);
            }
        }
        return merge;
    }
};
```

```Java [sol2-Java]
class Solution {
    public String largestMerge(String word1, String word2) {
        int m = word1.length(), n = word2.length();
        String str = word1 + "@" + word2 + "*";
        int[] suffixArray = buildSuffixArray(str); 
        int[] rank = new int[m + n + 2];
        for (int i = 0; i < m + n + 2; i++) {
            rank[suffixArray[i]] = i;
        }

        StringBuilder merge = new StringBuilder();
        int i = 0, j = 0;
        while (i < m || j < n) {
            if (i < m && rank[i] > rank[m + 1 + j]) {
                merge.append(word1.charAt(i));
                i++;
            } else {
                merge.append(word2.charAt(j));
                j++;
            }
        }
        return merge.toString();
    }

    public int[] buildSuffixArray(String text) {
        int[] order = sortCharacters(text);
        int[] classfiy = computeCharClasses(text, order);
        int len = 1;
        int n = text.length();
        for (int i = 1; i < n; i <<= 1) {
            order = sortDoubled(text, i, order, classfiy);
            classfiy = updateClasses(order, classfiy, i);
        }
        return order;
    }

    public int[] sortCharacters(String text) {
        int n = text.length();
        int[] count = new int[128];
        int[] order = new int[n];
        for (int i = 0; i < n; i++) {
            char c = text.charAt(i);
            count[c]++;
        }    
        for (int i = 1; i < 128; i++) {
            count[i] += count[i - 1];
        }
        for (int i = n - 1; i >= 0; i--) {
            count[text.charAt(i)]--;
            order[count[text.charAt(i)]] = i;
        }
        return order;
    }

    public int[] computeCharClasses(String text, int[] order) {
        int n = text.length();
        int[] res = new int[n];
        res[order[0]] = 0;
        for (int i = 1; i < n; i++) {
            if (text.charAt(order[i]) != text.charAt(order[i - 1])) {
                res[order[i]] = res[order[i - 1]] + 1;
            } else {
                res[order[i]] = res[order[i - 1]];
            }
        }
        return res;
    }

    public int[] sortDoubled(String text, int len, int[]  order, int[] classfiy) {
        int n = text.length();
        int[] count = new int[n];
        int[] newOrder = new int[n];
        for (int i = 0; i < n; i++) {
            count[classfiy[i]]++;
        }
        for (int i = 1; i < n; i++) {
            count[i] += count[i - 1];
        }
        for (int i = n - 1; i >= 0; i--) {
            int start = (order[i] - len + n) % n;
            int cl = classfiy[start];
            count[cl]--;
            newOrder[count[cl]] = start;
        }
        return newOrder;
    }

    public int[] updateClasses(int[] newOrder, int[] classfiy, int len) {
        int n = newOrder.length;
        int[] newClassfiy = new int[n];
        newClassfiy[newOrder[0]] = 0;
        for (int i = 1; i < n; i++) {
            int curr = newOrder[i];
            int prev = newOrder[i - 1];
            int mid = curr + len;
            int midPrev = (prev + len) % n;
            if (classfiy[curr] != classfiy[prev] || classfiy[mid] != classfiy[midPrev]) {
                newClassfiy[curr] = newClassfiy[prev] + 1;
            } else {
                newClassfiy[curr] = newClassfiy[prev];
            }
        }
        return newClassfiy;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string LargestMerge(string word1, string word2) {
        int m = word1.Length, n = word2.Length;
        String str = word1 + "@" + word2 + "*";
        int[] suffixArray = BuildSuffixArray(str); 
        int[] rank = new int[m + n + 2];
        for (int idx = 0; idx < m + n + 2; idx++) {
            rank[suffixArray[idx]] = idx;
        }

        StringBuilder merge = new StringBuilder();
        int i = 0, j = 0;
        while (i < m || j < n) {
            if (i < m && rank[i] > rank[m + 1 + j]) {
                merge.Append(word1[i]);
                i++;
            } else {
                merge.Append(word2[j]);
                j++;
            }
        }
        return merge.ToString();
    }

    public int[] BuildSuffixArray(String text) {
        int[] order = CortCharacters(text);
        int[] classfiy = ComputeCharClasses(text, order);
        int len = 1;
        int n = text.Length;
        for (int i = 1; i < n; i <<= 1) {
            order = SortDoubled(text, i, order, classfiy);
            classfiy = UpdateClasses(order, classfiy, i);
        }
        return order;
    }

    public int[] CortCharacters(String text) {
        int n = text.Length;
        int[] count = new int[128];
        int[] order = new int[n];
        for (int i = 0; i < n; i++) {
            char c = text[i];
            count[c]++;
        }    
        for (int i = 1; i < 128; i++) {
            count[i] += count[i - 1];
        }
        for (int i = n - 1; i >= 0; i--) {
            count[text[i]]--;
            order[count[text[i]]] = i;
        }
        return order;
    }

    public int[] ComputeCharClasses(String text, int[] order) {
        int n = text.Length;
        int[] res = new int[n];
        res[order[0]] = 0;
        for (int i = 1; i < n; i++) {
            if (text[order[i]] != text[order[i - 1]]) {
                res[order[i]] = res[order[i - 1]] + 1;
            } else {
                res[order[i]] = res[order[i - 1]];
            }
        }
        return res;
    }

    public int[] SortDoubled(String text, int len, int[]  order, int[] classfiy) {
        int n = text.Length;
        int[] count = new int[n];
        int[] newOrder = new int[n];
        for (int i = 0; i < n; i++) {
            count[classfiy[i]]++;
        }
        for (int i = 1; i < n; i++) {
            count[i] += count[i - 1];
        }
        for (int i = n - 1; i >= 0; i--) {
            int start = (order[i] - len + n) % n;
            int cl = classfiy[start];
            count[cl]--;
            newOrder[count[cl]] = start;
        }
        return newOrder;
    }

    public int[] UpdateClasses(int[] newOrder, int[] classfiy, int len) {
        int n = newOrder.Length;
        int[] newClassfiy = new int[n];
        newClassfiy[newOrder[0]] = 0;
        for (int i = 1; i < n; i++) {
            int curr = newOrder[i];
            int prev = newOrder[i - 1];
            int mid = curr + len;
            int midPrev = (prev + len) % n;
            if (classfiy[curr] != classfiy[prev] || classfiy[mid] != classfiy[midPrev]) {
                newClassfiy[curr] = newClassfiy[prev] + 1;
            } else {
                newClassfiy[curr] = newClassfiy[prev];
            }
        }
        return newClassfiy;
    }
}
```

```C [sol2-C]
void sortCharacters(const char *text, int *order) {
    int n = strlen(text);
    int count[128];
    memset(count, 0, sizeof(count));
    for (int i = 0; text[i] != '\0'; i++) {
        count[text[i]]++;
    }    
    for (int i = 1; i < 128; i++) {
        count[i] += count[i - 1];
    }
    for (int i = n - 1; i >= 0; i--) {
        count[text[i]]--;
        order[count[text[i]]] = i;
    }
}

void computeCharClasses(const char *text, const int* order, int *classfiy) {
    int n = strlen(text);
    classfiy[order[0]] = 0;
    for (int i = 1; i < n; i++) {
        if (text[order[i]] != text[order[i - 1]]) {
            classfiy[order[i]] = classfiy[order[i - 1]] + 1;
        } else {
            classfiy[order[i]] = classfiy[order[i - 1]];
        }
    }
}

void sortDoubled(const char *text, int len, const int *order, const int *classfiy, int *newOrder) {
    int n = strlen(text);
    int count[n];
    memset(count, 0, sizeof(count));
    for (int i = 0; i < n; i++) {
        count[classfiy[i]]++;
    }
    for (int i = 1; i < n; i++) {
        count[i] += count[i - 1];
    }
    for (int i = n - 1; i >= 0; i--) {
        int start = (order[i] - len + n) % n;
        int cl = classfiy[start];
        count[cl]--;
        newOrder[count[cl]] = start;
    }
}

void updateClasses(const int *newOrder, int n, int *classfiy, int len, int *newClassfiy) {
    newClassfiy[newOrder[0]] = 0;
    for (int i = 1; i < n; i++) {
        int curr = newOrder[i];
        int prev = newOrder[i - 1];
        int mid = curr + len;
        int midPrev = (prev + len) % n;
        if (classfiy[curr] != classfiy[prev] || classfiy[mid] != classfiy[midPrev]) {
             newClassfiy[curr] = newClassfiy[prev] + 1;
        } else {
             newClassfiy[curr] = newClassfiy[prev];
        }
    }
}

int  *buildSuffixArray(const char *text) {
    int n = strlen(text);
    int *order = (int *)malloc(sizeof(int) * n); 
    int classfiy[n], newOrder[n], newClassfiy[n];
    sortCharacters(text, order);
    computeCharClasses(text, order, classfiy);    
    for (int i = 1; i < n; i <<= 1) {
        sortDoubled(text, i, order, classfiy, newOrder);
        updateClasses(newOrder, n, classfiy, i, newClassfiy);
        memcpy(order, newOrder, sizeof(int) * n);
        memcpy(classfiy, newClassfiy, sizeof(int) * n);
    }
    return order;
}

char * largestMerge(char * word1, char * word2) {
    int m = strlen(word1), n = strlen(word2);
    char str[m + n + 3];
    sprintf(str, "%s@%s*", word1, word2);
    int *suffixArray = buildSuffixArray(str); 
    int rank[m + n + 2];
    for (int i = 0; i < m + n + 2; i++) {
        rank[suffixArray[i]] = i;
    }
    free(suffixArray);

    char *merge = (char *)malloc(sizeof(char) * (m + n + 1));
    int i = 0, j = 0, pos = 0; 
    while (i < m || j < n) {
        if (i < m && rank[i] > rank[m + 1 + j]) {
            merge[pos] = word1[i];
            pos++, i++;
        } else {
            merge[pos] = word2[j];
            pos++, j++;
        }
    }
    merge[pos] = '\0';
    return merge;
}
```

**复杂度分析**

- 时间复杂度：$O(|\Sigma| + (m + n) \times \log (m + n))$，其中 $m, n$ 表示字符串 $\textit{word}_1$ 与 $\textit{word}_2$ 的长度，$|\Sigma|$ 表示字符集的大小，在此 $|\Sigma|$ 取 $128$。时间复杂度主要取决于后缀数组的计算与字符串的遍历，其中后缀数组的计算需要的时间复杂度为 $O(|\Sigma| + (m + n) \times \log (m + n))$，我们通过后缀数组计算出每个后缀的排序需要的时间复杂度为 $O(m + n)$，遍历两个字符串并通过比较后缀的大小来进行合并需要的时间复杂度为 $O(m + n)$，因此总的时间复杂度为 $O(|\Sigma| + (m + n) \times \log (m + n))$

- 空间复杂度：$O(m + n)$。计算后缀数组时需要存放临时的字符串以及后缀排序，需要的空间均为 $O(m + n)$，因此总的空间复杂度为 $O(m + n)$。