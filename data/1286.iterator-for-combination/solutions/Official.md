### 方法一：生成法

我们可以用经典的生成法依次求出这些组合。以字符串 `"abcde"` 为例，我们需要求出其长度为 `3` 的所有组合。

首先，第一个组合即为 `"abcde"` 的前三个字母：

```
a b c
```

那么我们如何求出下一个组合呢？可以发现，`"abc"` 的最后一个字母 `"c"` 还可以增大为 `"d"`，因此我们将其变为 `"d"` 即可得到第二个组合。同理，将 `"d"` 变为 `"e"` 即可得到第三个组合。

```
a b c     =>     a b d     =>     a b e
    ^                ^
    d                e
```

此时，最后一个字母 `"e"` 已经无法再增大了，我们需要向前寻找可以增大的字母。可以发现，`"abe"` 中的第二个字母 `"b"` 可以增大为 `"c"`，因此我们将其变为 `"c"` 得到 `"ace"`。然而这并不是第四个组合，因为还需要将最后一个字母 `"e"` 减少为满足要求的最小值。因此我们将其变为 `"d"` 得到 `"acd"`，即为第四个组合。

```
a b e     =>     a c d
  ^ ^
  c d
```

同理，我们可以继续得到接下来的第五和第六个组合：

```
a c d     =>     a c e     =>     a d e
    ^              ^ ^
    e              d e
```

此时，最后一个字母 `"e"` 已经无法再增大了，同时第二个字母 `"d"` 也无法再增大了（虽然有比它大的字母 `"e"`，但是如果第二个字母增大为 `"e"`，那么最后一个字母就无法选择任何值了），我们需要再向前寻找到第一个字母，将其变为 `"b"` 得到 `"bde"`。同样地，我们需要将后面的两个字母减少为满足要求的最小值，变为 `"bcd"`，即为第七个组合。

```
a d e     =>     b c d
^ ^ ^
b c d
```

同理，我们可以继续得到接下来的第八，第九和第十个组合：

```
b c d     =>     b c e     =>     b d e     =>     c d e
    ^              ^ ^            ^ ^ ^
    e              d e            c d e
```

此时，这三个字母都已经无法再增大，因此我们就可以知道这是最后一个组合了。

通过上面这个例子，我们可以得到一般性的组合生成方法：

- 假设字符串的长度为 `l`，组合的长度为 `k`，第一个组合即为字符串中的前 `k` 个字母；

- 在调用函数 `next()` 时，我们将当前的组合作为答案返回，并开始寻找下一个组合：

  - 我们从组合中的第 `k` 个位置开始看起，如果当前位置的字母可以增大，则将其增大一次；如果当前位置的字母已经到达最大值，则向前寻找，直到找到可以增大的位置，将其增大一次。如果没有找到，则说明当前已经是最大的组合，我们添加一个标记。对于组合中的第 `i` 个位置，它的最大值是字符串中的第 `l - k + i` 个字母；

  - 记找到可以增大的字母位置为 `i`。我们将组合中的第 `i + 1` 到第 `k` 个位置的字母减少为满足要求的最小值。具体地，第 `i + 1` 个位置的字母为第 `i` 个位置的字母在字符串中的下一个字母，第 `i + 2` 个位置的字母为第 `i + 1` 个位置的字母在字符串中的下一个字母，以此类推。

- 在调用函数 `hasNext()` 时，如果在调用函数 `next()` 时被添加过标记，那么说明当前已经是最大的组合，返回 `true`，否则返回 `false`。

这种生成方法的优势在于，我们仅根据当前的组合就可以快速地得到下一个组合，而不需要提前将所有的组合存储在数据结构中。

```C++ [sol1-C++]
class CombinationIterator {
private:
    vector<int> pos;
    string s;
    bool finished;

public:
    CombinationIterator(string characters, int combinationLength) {
        s = characters;
        pos.resize(combinationLength);
        iota(pos.begin(), pos.end(), 0);
        finished = false;
    }
    
    string next() {
        string ans;
        for (int p: pos) {
            ans += s[p];
        }
        int i = -1;
        for (int k = pos.size() - 1; k >= 0; --k) {
            if (pos[k] != s.size() - pos.size() + k) {
                i = k;
                break;
            }
        }
        if (i == -1) {
            finished = true;
        }
        else {
            ++pos[i];
            for (int j = i + 1; j < pos.size(); ++j) {
                pos[j] = pos[j - 1] + 1;
            }
        }
        return ans;
    }
    
    bool hasNext() {
        return !finished;
    }
};
```

```Python [sol1-Python3]
class CombinationIterator:

    def __init__(self, characters: str, combinationLength: int):
        self.s = characters
        self.pos = [x for x in range(combinationLength)]
        self.finished = False

    def next(self) -> str:
        ans = "".join([self.s[p] for p in self.pos])
        i = -1
        for k in range(len(self.pos) - 1, -1, -1):
            if self.pos[k] != len(self.s) - len(self.pos) + k:
                i = k
                break
        if i == -1:
            self.finished = True
        else:
            self.pos[i] += 1
            for j in range(i + 1, len(self.pos)):
                self.pos[j] = self.pos[j - 1] + 1
        return ans

    def hasNext(self) -> bool:
        return not self.finished
```

**复杂度分析**

- 时间复杂度：`next()` 函数的时间复杂度为 $O(K)$，其中 $K$ 是组合的长度。`hasNext()` 函数的时间复杂度为 $O(1)$。

- 空间复杂度：除了存储字符串和组合使用的空间之外，`next` 函数和 `hasNext()` 函数的空间复杂度均为 $O(1)$。