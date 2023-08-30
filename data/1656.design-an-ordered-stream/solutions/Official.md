#### 方法一：使用数组存储 + 遍历

**思路与算法**

对于 $\text{OrderedStream(int n)}$，我们在初始化时开辟一个长度为 $n+1$ 的数组 $\textit{stream}$，用来存储后续的字符串。注意到题目中指针 $\textit{ptr}$ 的初始值为 $1$，而多数语言数组的下标是从 $0$ 开始的，因此使用长度为 $n+1$ 的数组可以使得编码更加容易。

对于 $\text{String[] insert(int id, String value)}$，我们直接根据题目描述中的要求进行遍历即可。我们首先将 $\textit{stream}[\textit{id}]$ 置为 $\textit{value}$。随后，如果 $\textit{stream}[\textit{id}]$ 不为空，我们就将其加入答案，并将 $\textit{ptr}$ 增加 $1$，直到指针超出边界或 $\textit{stream}[\textit{id}]$ 为空时结束并返回答案。

**代码**

```C++ [sol1-C++]
class OrderedStream {
public:
    OrderedStream(int n) {
        stream.resize(n + 1);
        ptr = 1;
    }
    
    vector<string> insert(int idKey, string value) {
        stream[idKey] = value;
        vector<string> res;
        while (ptr < stream.size() && !stream[ptr].empty()) {
            res.push_back(stream[ptr]);
            ++ptr;
        }
        return res;
    }

private:
    vector<string> stream;
    int ptr;
};
```

```Java [sol1-Java]
class OrderedStream {
    private String[] stream;
    private int ptr;

    public OrderedStream(int n) {
        stream = new String[n + 1];
        ptr = 1;
    }

    public List<String> insert(int idKey, String value) {
        stream[idKey] = value;
        List<String> res = new ArrayList<String>();
        while (ptr < stream.length && stream[ptr] != null) {
            res.add(stream[ptr]);
            ++ptr;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class OrderedStream {
    private string[] stream;
    private int ptr;

    public OrderedStream(int n) {
        stream = new string[n + 1];
        ptr = 1;
    }

    public IList<string> Insert(int idKey, string value) {
        stream[idKey] = value;
        IList<string> res = new List<string>();
        while (ptr < stream.Length && stream[ptr] != null) {
            res.Add(stream[ptr]);
            ++ptr;
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class OrderedStream:

    def __init__(self, n: int):
        self.stream = [""] * (n + 1)
        self.ptr = 1

    def insert(self, idKey: int, value: str) -> List[str]:
        stream_ = self.stream

        stream_[idKey] = value
        res = list()
        while self.ptr < len(stream_) and stream_[self.ptr]:
            res.append(stream_[self.ptr])
            self.ptr += 1
        
        return res
```

```C [sol1-C]
typedef struct {
    char **stream;
    int streamSize;
    int ptr;
} OrderedStream;

OrderedStream* orderedStreamCreate(int n) {
    OrderedStream *obj = (OrderedStream *)malloc(sizeof(OrderedStream));
    obj->stream = (char **)malloc(sizeof(char *) * (n + 1));
    for (int i = 0; i <= n; i++) {
        obj->stream[i] = NULL;
    }
    obj->streamSize = n + 1;
    obj->ptr = 1;
    return obj;
}

char ** orderedStreamInsert(OrderedStream* obj, int idKey, char * value, int* retSize) {
    obj->stream[idKey] = value;
    char **res = (char **)malloc(sizeof(char *) * obj->streamSize);
    int pos = 0;
    while (obj->ptr < obj->streamSize && obj->stream[obj->ptr]) {
        res[pos++] = obj->stream[obj->ptr];
        obj->ptr++;
    }
    *retSize = pos;
    return res;
}

void orderedStreamFree(OrderedStream* obj) {
    free(obj->stream);
    free(obj);
}
```

```go [sol1-Golang]
type OrderedStream struct {
    stream []string
    ptr    int
}

func Constructor(n int) OrderedStream {
    return OrderedStream{make([]string, n+1), 1}
}

func (s *OrderedStream) Insert(idKey int, value string) []string {
    s.stream[idKey] = value
    start := s.ptr
    for s.ptr < len(s.stream) && s.stream[s.ptr] != "" {
        s.ptr++
    }
    return s.stream[start:s.ptr]
}
```

**复杂度分析**

注意这里我们将字符串的固定常数 $5$ 看成常数。

- 时间复杂度：

    - $\text{OrderedStream(int n)}$ 的时间复杂度为 $O(n)$；
    
    - $\text{String[] insert(int id, String value)}$ 的时间复杂度为均摊 $O(1)$，这是因为我们会恰好调用该函数 $n$ 次，那么每一个字符串最多会被包含在返回数组中一次；    

- 空间复杂度：$O(n)$，即为存储 $n$ 个字符串需要的空间。