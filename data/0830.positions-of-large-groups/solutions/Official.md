#### 方法一：一次遍历

**思路及解法**

我们可以遍历该序列，并记录当前分组的长度。如果下一个字符与当前字符不同，或者已经枚举到字符串尾部，就说明当前字符为当前分组的尾部。每次找到当前分组的尾部时，如果该分组长度达到 $3$，我们就将其加入答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> largeGroupPositions(string s) {
        vector<vector<int>> ret;
        int n = s.size();
        int num = 1;
        for (int i = 0; i < n; i++) {
            if (i == n - 1 || s[i] != s[i + 1]) {
                if (num >= 3) {
                    ret.push_back({i - num + 1, i});
                }
                num = 1;
            } else {
                num++;
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<List<Integer>> largeGroupPositions(String s) {
        List<List<Integer>> ret = new ArrayList<List<Integer>>();
        int n = s.length();
        int num = 1;
        for (int i = 0; i < n; i++) {
            if (i == n - 1 || s.charAt(i) != s.charAt(i + 1)) {
                if (num >= 3) {
                    ret.add(Arrays.asList(i - num + 1, i));
                }
                num = 1;
            } else {
                num++;
            }
        }
        return ret;
    }
}
```

```go [sol1-Golang]
func largeGroupPositions(s string) (ans [][]int) {
    cnt := 1
    for i := range s {
        if i == len(s)-1 || s[i] != s[i+1] {
            if cnt >= 3 {
                ans = append(ans, []int{i - cnt + 1, i})
            }
            cnt = 1
        } else {
            cnt++
        }
    }
    return
}
```

```C [sol1-C]
int** largeGroupPositions(char* s, int* returnSize, int** returnColumnSizes) {
    *returnSize = 0;
    int n = strlen(s);
    int** ret = malloc(sizeof(int*) * (n / 3));
    *returnColumnSizes = malloc(sizeof(int) * (n / 3));
    int num = 1;
    for (int i = 0; i < n; i++) {
        if (i == n - 1 || s[i] != s[i + 1]) {
            if (num >= 3) {
                int* tmp = malloc(sizeof(int) * 2);
                tmp[0] = i - num + 1, tmp[1] = i;
                (*returnColumnSizes)[*returnSize] = 2;
                ret[(*returnSize)++] = tmp;
            }
            num = 1;
        } else {
            num++;
        }
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var largeGroupPositions = function(s) {
    const ret = [];
    const n = s.length;
    let num = 1;
    for (let i = 0; i < n; i++) {
        if (i === n - 1 || s[i] !== s[i + 1]) {
            if (num >= 3) {
                ret.push([i - num + 1, i]);
            }
            num = 1;
        } else {
            num++;
        }
    }
    return ret;
};
```

```Python [sol1-Python3]
class Solution:
    def largeGroupPositions(self, s: str) -> List[List[int]]:
        ret = list()
        n, num = len(s), 1

        for i in range(n):
            if i == n - 1 or s[i] != s[i + 1]:
                if num >= 3:
                    ret.append([i - num + 1, i])
                num = 1
            else:
                num += 1
        
        return ret
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。我们只需要遍历一次该数组。

- 空间复杂度：$O(1)$。我们只需要常数的空间来保存若干变量，注意返回值不计入空间复杂度。