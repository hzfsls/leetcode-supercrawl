## [406.根据身高重建队列 中文官方题解](https://leetcode.cn/problems/queue-reconstruction-by-height/solutions/100000/gen-ju-shen-gao-zhong-jian-dui-lie-by-leetcode-sol)

#### 方法一：从低到高考虑

**思路与算法**

当每个人的身高都不相同时，如果我们将他们按照身高从小到大进行排序，那么就可以很方便地还原出原始的队列了。

为了叙述方便，我们设人数为 $n$，在进行排序后，它们的身高依次为 $h_0, h_1, \cdots, h_{n-1}$，且排在第 $i$ 个人前面身高**大于** $h_i$ 的人数为 $k_i$。如果我们按照排完序后的顺序，依次将每个人放入队列中，那么当我们放入第 $i$ 个人时：

- 第 $0, \cdots, i-1$ 个人已经在队列中被安排了位置，并且他们无论站在哪里，对第 $i$ 个人都没有任何影响，因为他们都比第 $i$ 个人矮；

- 而第 $i+1, \cdots, n-1$ 个人还没有被放入队列中，但他们只要站在第 $i$ 个人的前面，就会对第 $i$ 个人产生影响，因为他们都比第 $i$ 个人高。

如果我们在初始时建立一个包含 $n$ 个位置的空队列，而我们每次将一个人放入队列中时，会将一个「空」位置变成「满」位置，那么当我们放入第 $i$ 个人时，我们需要给他安排一个「空」位置，并且这个「空」位置前面恰好还有 $k_i$ 个「空」位置，用来安排给后面身高更高的人。也就是说，**第 $i$ 个人的位置，就是队列中从左往右数第 $k_i+1$ 个「空」位置**。

那么如果有身高相同的人，上述 $k_i$ 定义中的**大于**就与题目描述中要求的**大于等于**不等价了，此时应该怎么修改上面的方法呢？我们可以这样想，如果第 $i$ 个人和第 $j$ 个人的身高相同，即 $h_i = h_j$，那么我们可以把在队列中处于较后位置的那个人的身高减小一点点。换句话说，对于某一个身高值 $h$，我们将队列中第一个身高为 $h$ 的人保持不变，第二个身高为 $h$ 的人的身高减少 $\delta$，第三个身高为 $h$ 的人的身高减少 $2\delta$，以此类推，其中 $\delta$ 是一个很小的常数，它使得任何身高为 $h$ 的人不会与其它（身高不为 $h$ 的）人造成影响。

如何找到第一个、第二个、第三个身高为 $h$ 的人呢？我们可以借助 $k$ 值，可以发现：当 $h_i=h_j$ 时，如果 $k_i > k_j$，那么说明 $i$ 一定相对于 $j$ 在队列中处于较后的位置（因为在第 $j$ 个人之前比他高的所有人，一定都比第 $i$ 个人要高），按照修改之后的结果，$h_i$ 略小于 $h_j$，第 $i$ 个人在排序后应该先于第 $j$ 个人被放入队列。因此，我们不必真的去对身高进行修改，而只需要按照 $h_i$ 为第一关键字升序，$k_i$ 为第二关键字降序进行排序即可。此时，具有相同身高的人会按照它们在队列中的位置逆序进行排列，也就间接实现了上面将身高减少 $\delta$ 这一操作的效果。

这样一来，我们只需要使用一开始提到的方法，将第 $i$ 个人放入队列中的第 $k_i+1$ 个空位置，即可得到原始的队列。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> reconstructQueue(vector<vector<int>>& people) {
        sort(people.begin(), people.end(), [](const vector<int>& u, const vector<int>& v) {
            return u[0] < v[0] || (u[0] == v[0] && u[1] > v[1]);
        });
        int n = people.size();
        vector<vector<int>> ans(n);
        for (const vector<int>& person: people) {
            int spaces = person[1] + 1;
            for (int i = 0; i < n; ++i) {
                if (ans[i].empty()) {
                    --spaces;
                    if (!spaces) {
                        ans[i] = person;
                        break;
                    }
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[][] reconstructQueue(int[][] people) {
        Arrays.sort(people, new Comparator<int[]>() {
            public int compare(int[] person1, int[] person2) {
                if (person1[0] != person2[0]) {
                    return person1[0] - person2[0];
                } else {
                    return person2[1] - person1[1];
                }
            }
        });
        int n = people.length;
        int[][] ans = new int[n][];
        for (int[] person : people) {
            int spaces = person[1] + 1;
            for (int i = 0; i < n; ++i) {
                if (ans[i] == null) {
                    --spaces;
                    if (spaces == 0) {
                        ans[i] = person;
                        break;
                    }
                }
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def reconstructQueue(self, people: List[List[int]]) -> List[List[int]]:
        people.sort(key=lambda x: (x[0], -x[1]))
        n = len(people)
        ans = [[] for _ in range(n)]
        for person in people:
            spaces = person[1] + 1
            for i in range(n):
                if not ans[i]:
                    spaces -= 1
                    if spaces == 0:
                        ans[i] = person
                        break
        return ans
```

```Golang [sol1-Golang]
func reconstructQueue(people [][]int) [][]int {
    sort.Slice(people, func(i, j int) bool {
        a, b := people[i], people[j]
        return a[0] < b[0] || a[0] == b[0] && a[1] > b[1]
    })
    ans := make([][]int, len(people))
    for _, person := range people {
        spaces := person[1] + 1
        for i := range ans {
            if ans[i] == nil {
                spaces--
                if spaces == 0 {
                    ans[i] = person
                    break
                }
            }
        }
    }
    return ans
}
```

```C [sol1-C]
int cmp(const void* _a, const void* _b) {
    int *a = *(int**)_a, *b = *(int**)_b;
    return a[0] == b[0] ? b[1] - a[1] : a[0] - b[0];
}

int** reconstructQueue(int** people, int peopleSize, int* peopleColSize, int* returnSize, int** returnColumnSizes) {
    qsort(people, peopleSize, sizeof(int*), cmp);
    int** ans = malloc(sizeof(int*) * peopleSize);
    *returnSize = peopleSize;
    *returnColumnSizes = malloc(sizeof(int) * peopleSize);
    memset(*returnColumnSizes, 0, sizeof(int) * peopleSize);
    for (int i = 0; i < peopleSize; ++i) {
        int spaces = people[i][1] + 1;
        for (int j = 0; j < peopleSize; ++j) {
            if ((*returnColumnSizes)[j] == 0) {
                spaces--;
                if (!spaces) {
                    (*returnColumnSizes)[j] = 2;
                    ans[j] = malloc(sizeof(int) * 2);
                    ans[j][0] = people[i][0], ans[j][1] = people[i][1];
                    break;
                }
            }
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{people}$ 的长度。我们需要 $O(n \log n)$ 的时间进行排序，随后需要 $O(n^2)$ 的时间遍历每一个人并将他们放入队列中。由于前者在渐近意义下小于后者，因此总时间复杂度为 $O(n^2)$。

- 空间复杂度：$O(\log n)$，即为排序需要使用的栈空间。

#### 方法二：从高到低考虑

**思路与算法**

同样地，我们也可以将每个人按照身高从大到小进行排序，处理身高相同的人使用的方法类似，即：按照 $h_i$ 为第一关键字降序，$k_i$ 为第二关键字升序进行排序。如果我们按照排完序后的顺序，依次将每个人放入队列中，那么当我们放入第 $i$ 个人时：

- 第 $0, \cdots, i-1$ 个人已经在队列中被安排了位置，他们只要站在第 $i$ 个人的前面，就会对第 $i$ 个人产生影响，因为他们都比第 $i$ 个人高；

- 而第 $i+1, \cdots, n-1$ 个人还没有被放入队列中，并且他们无论站在哪里，对第 $i$ 个人都没有任何影响，因为他们都比第 $i$ 个人矮。

在这种情况下，我们无从得知应该给后面的人安排多少个「空」位置，因此就不能沿用方法一。但我们可以发现，后面的人既然不会对第 $i$ 个人造成影响，我们可以采用「插空」的方法，依次给每一个人在当前的队列中选择一个插入的位置。也就是说，当我们放入第 $i$ 个人时，只需要将其插入队列中，使得他的前面恰好有 $k_i$ 个人即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<vector<int>> reconstructQueue(vector<vector<int>>& people) {
        sort(people.begin(), people.end(), [](const vector<int>& u, const vector<int>& v) {
            return u[0] > v[0] || (u[0] == v[0] && u[1] < v[1]);
        });
        vector<vector<int>> ans;
        for (const vector<int>& person: people) {
            ans.insert(ans.begin() + person[1], person);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[][] reconstructQueue(int[][] people) {
        Arrays.sort(people, new Comparator<int[]>() {
            public int compare(int[] person1, int[] person2) {
                if (person1[0] != person2[0]) {
                    return person2[0] - person1[0];
                } else {
                    return person1[1] - person2[1];
                }
            }
        });
        List<int[]> ans = new ArrayList<int[]>();
        for (int[] person : people) {
            ans.add(person[1], person);
        }
        return ans.toArray(new int[ans.size()][]);
    }
}
```

```Python [sol2-Python3]
class Solution:
    def reconstructQueue(self, people: List[List[int]]) -> List[List[int]]:
        people.sort(key=lambda x: (-x[0], x[1]))
        n = len(people)
        ans = list()
        for person in people:
            ans[person[1]:person[1]] = [person]
        return ans
```

```Golang [sol2-Golang]
func reconstructQueue(people [][]int) (ans [][]int) {
    sort.Slice(people, func(i, j int) bool {
        a, b := people[i], people[j]
        return a[0] > b[0] || a[0] == b[0] && a[1] < b[1]
    })
    for _, person := range people {
        idx := person[1]
        ans = append(ans[:idx], append([][]int{person}, ans[idx:]...)...)
    }
    return
}
```

```C [sol2-C]
int cmp(const void* _a, const void* _b) {
    int *a = *(int**)_a, *b = *(int**)_b;
    return a[0] == b[0] ? a[1] - b[1] : b[0] - a[0];
}

int** reconstructQueue(int** people, int peopleSize, int* peopleColSize, int* returnSize, int** returnColumnSizes) {
    qsort(people, peopleSize, sizeof(int*), cmp);
    int** ans = malloc(sizeof(int*) * peopleSize);
    *returnSize = 0;
    *returnColumnSizes = malloc(sizeof(int) * peopleSize);
    for (int i = 0; i < peopleSize; i++) {
        (*returnColumnSizes)[i] = 2;
    }
    for (int i = 0; i < peopleSize; ++i) {
        int* person = people[i];
        (*returnSize)++;
        for (int j = (*returnSize) - 1; j > person[1]; j--) {
            ans[j] = ans[j - 1];
        }
        int* tmp = malloc(sizeof(int) * 2);
        tmp[0] = person[0], tmp[1] = person[1];
        ans[person[1]] = tmp;
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{people}$ 的长度。我们需要 $O(n \log n)$ 的时间进行排序，随后需要 $O(n^2)$ 的时间遍历每一个人并将他们放入队列中。由于前者在渐近意义下小于后者，因此总时间复杂度为 $O(n^2)$。

- 空间复杂度：$O(\log n)$。