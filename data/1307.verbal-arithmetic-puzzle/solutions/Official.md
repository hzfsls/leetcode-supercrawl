#### 说明

本题在时间复杂度的数量级上并没有很大的优化空间，不存在多项式时间复杂度的算法。我们必须枚举所有字母与数字的映射情况，并判断它们是否满足要求。因此，我们需要做的是尽量对这个搜索过程进行优化，舍弃不必要的搜索，减小搜索空间，也就是所谓的「搜索剪枝」。

我们会给出两种不同的「搜索剪枝」方法，在衡量时间复杂度时，我们以代码在力扣平台上的运行时间作为「搜索剪枝」的有效程度，即运行时间越少，搜索空间就越小，「搜索剪枝」的有效程度就越高。

我们会用题目中的第一个样例

```
  SEND
+ MORE
-------
 MONEY
```

作为例子，详细地阐述这两种「搜索剪枝」的方法。

#### 方法一：低位优先

从直觉上来看，我们首先能想到的搜索方法是优先搜索等式的低位，这是因为在计算加法时，我们也是从低位向高位进行运算。在例子中，我们的搜索顺序为：`DEYNREEONSMOM`。

那么我们如何具体地从低位向高位进行搜索呢？我们可以使用哈希映射（HashMap）来存储字母和数字之间的映射关系：当我们搜索到一个没有出现在哈希映射中的字母时，我们遍历当前所有有效的数字，枚举该字母的映射，并继续搜索；当我们搜索到一个出现在哈希映射中的字母时，我们可以跳过该字母，并继续搜索。当搜索完所有的字母后，我们检查等式是否成立。

这是一种没有使用任何剪枝的搜索方法，它需要枚举所有可能的字母与数字映射的情况。那么我们如何进行剪枝呢？可以发现，当我们从低位向高位搜索完前两个字母 `DE` 之后，下一个字母 `M` 实际上并不需要进行搜索了，我们可以直接通过 `D + E` 对 `10` 取模的值得到 `M`。同理，当我们继续搜索完后续的字母 `NR` 后，可以直接通过 `N + R + carry(D + E)` 对 `10` 取模的值得到 `E`，其中 `carry(D + E)` 表示 `D + E` 对 `10` 整除的值，即低位向高位的进位。到这一步时，我们发现 `E` 在之前已经被搜索过，那么如果 `N + R + carry(D + E)` 对 `10` 取模的值与之前将 `E` 映射的值不相等，我们就得出了矛盾，也就不用继续搜索了，而是需要回溯到之前的状态，重新枚举字母的映射。

根据这个剪枝方法，我们可以将搜索过程归纳为如下的步骤：

- 我们从低位向高位进行搜索；

- 如果我们当前搜索字母的位置在等式的左侧（即例子中的 `SEND` 和 `MORE`），那么：

  - 如果当前字母在之前已经被搜索过，我们就可以跳过该字母；

  - 如果当前字母在之前未被搜索过，我们枚举所有有效的数字（「有效的数字」为之前没有被映射到，且不会有前导零出现的数字），作为该字母的映射，并搜索下一个字母；

- 如果我们当前搜索字母的位置在等式的右侧（即例子中的 `MONEY`），那么：

  - 我们首先需要计算出等式左侧对应数位的数字之和，并加上低位的进位值，记为 `x`；

  - 如果当前字母在之前已经被搜索过，我们需要判断 `x % 10` 与该字母的映射值是否相等。若相等，我们就可以跳过该字母；若不相等，我们得出了矛盾，跳出当前的搜索并进行回溯；

  - 如果当前字母在之前未被搜索过，我们可以确定该字母必须被映射到 `x % 10`。如果 `x % 10` 是有效的数字，我们就将其作为该字母的映射，并搜索下一个字母；如果不是，我们得出了矛盾，跳出当前的搜索并进行回溯。

此外，我们还可以额外添加一个判断无解的剪枝，即等式左侧的某个字符串的长度大于等式右侧的字符串时，等式是无解的。例如 `A + BCD = EF`，它不可能存在满足要求的解。

```C++ [sol1-C++]
class Solution {
private:
    unordered_map<char, int> rep;
    unordered_map<char, int> lead_zero;
    bool used[10];
    int carry[10];
    
public:
    bool dfs(const vector<string>& words, const string& result, int pos, int id, int len) {
        if (pos == len) {
            return carry[pos] == 0;
        }
        else if (id < words.size()) {
            int sz = words[id].size();
            if (sz < pos || rep[words[id][sz - pos - 1]] != -1) {
                return dfs(words, result, pos, id + 1, len);
            }
            else {
                char ch = words[id][sz - pos - 1];
                for (int i = lead_zero[ch]; i < 10; ++i) {
                    if (!used[i]) {
                        used[i] = true;
                        rep[ch] = i;
                        bool check = dfs(words, result, pos, id + 1, len);
                        used[i] = false;
                        rep[ch] = -1;
                        if (check) {
                            return true;
                        }
                    }
                }
            }
            return false;
        }
        else {
            int left = carry[pos];
            for (const string& word: words) {
                if (word.size() > pos) {
                    left += rep[word[word.size() - pos - 1]];
                }
            }
            
            carry[pos + 1] = left / 10;
            left %= 10;
            char ch = result[result.size() - pos - 1];
            if (rep[ch] == left) {
                return dfs(words, result, pos + 1, 0, len);
            }
            else if (rep[ch] == -1 && !used[left] && !(lead_zero[ch] == 1 && left == 0)) {
                used[left] = true;
                rep[ch] = left;
                bool check = dfs(words, result, pos + 1, 0, len);
                used[left] = false;
                rep[ch] = -1;
                return check;
            }
            else {
                return false;
            }
        }
    }
    
    bool isSolvable(vector<string>& words, string result) {
        memset(used, false, sizeof(used));
        memset(carry, 0, sizeof(carry));
        for (string& word: words) {
            if (word.size() > result.size()) {
                return false;
            }
            for (char& ch: word) {
                rep[ch] = -1;
                lead_zero[ch] = max(lead_zero[ch], 0);
            }
            if (word.size() > 1) {
                lead_zero[word[0]] = 1;
            }
        }
        for (char& ch: result) {
            rep[ch] = -1;
            lead_zero[ch] = max(lead_zero[ch], 0);
        }
        if (result.size() > 1) {
            lead_zero[result[0]] = 1;
        }
        return dfs(words, result, 0, 0, result.size());
    }
};
```

```Python [sol1-Python3]
class Solution:
    def isSolvable(self, words: List[str], result: str) -> bool:
        used, carry = [False] * 10, [0] * 10
        lead_zero, rep = dict(), dict()

        for word in words:
            if len(word) > len(result):
                return False
            for ch in word:
                rep[ch] = -1
                lead_zero[ch] = max(lead_zero.get(ch, 0), 0)
            if len(word) > 1:
                lead_zero[word[0]] = 1
        for ch in result:
            rep[ch] = -1
            lead_zero[ch] = max(lead_zero.get(ch, 0), 0)
        if len(result) > 1:
            lead_zero[result[0]] = 1
        
        def dfs(pos, iden, length):
            if pos == length:
                return carry[pos] == 0
            elif iden < len(words):
                sz = len(words[iden])
                if sz < pos or rep[words[iden][sz - pos - 1]] != -1:
                    return dfs(pos, iden + 1, length)
                else:
                    ch = words[iden][sz - pos - 1]
                    for i in range(lead_zero[ch], 10):
                        if not used[i]:
                            used[i], rep[ch] = True, i
                            check = dfs(pos, iden + 1, length)
                            used[i], rep[ch] = False, -1
                            if check:
                                return True
                    return False
            else:
                left = carry[pos] + sum(rep[word[len(word) - pos - 1]] for word in words if len(word) > pos)
                carry[pos + 1], left = left // 10, left % 10
                ch = result[len(result) - pos - 1]
                if rep[ch] == left:
                    return dfs(pos + 1, 0, length)
                elif rep[ch] == -1 and not used[left] and not (lead_zero[ch] == 1 and left == 0):
                    used[left], rep[ch] = True, left
                    check = dfs(pos + 1, 0, length)
                    used[left], rep[ch] = False, -1
                    return check
                else:
                    return False

        return dfs(0, 0, len(result))
```

**运行时间**

- 运行时间：上述 `C++` 代码的运行时间约为 100ms，`Python` 代码的运行时间约为 600ms。

#### 方法二：权值合并

方法一是我们从直觉出发，进行一系列剪枝之后得到的方法，但这种方法的运行时间仍然不够优秀。我们从低位向高位进行搜索，但在搜索低位时，我们并没有使用到高位的信息，这就导致了许多无效的搜索。

我们仍然考虑例子 `SEND + MORE = MONEY`，其包含了 `3` 次字母 `E`，分别出现在个位、十位以及百位。如果我们可以将这些 `E` 合并起来，只进行一次搜索，那么它就包含了三个数位的信息。

那么具体应该怎么做呢？我们可以将每一个字符串拆分成十进制表示的形式，例如：

```
SEND  =             S * 1000 + E * 100 + N * 10 + D
MORE  =             M * 1000 + O * 100 + R * 10 + E
MONEY = M * 10000 + O * 1000 + N * 100 + E * 10 + Y
```

将其进行整理，可以得到：

```
S * 1000 + E * 91 - N * 90 + D - M * 9000 - O * 900 + R * 10 - Y = 0
```

我们将所有字母移到等式的左侧，这样只需要依次对每个字母进行搜索。在搜索结束后，如果等式左侧的值为 `0`，那么我们就找到了一组答案。但这种方法的运行时间会非常长，因为我们没有使用任何的搜索剪枝，在等式无解时，它需要枚举所有可能的字母与数字映射的情况。那么有哪些可以剪枝的方法呢？

观察上面等式中 `-M * 9000` 这一项，我们可以断定 `M` 的值不能非常大。这是因为当 `M` 的值很大（例如 `M = 9`）时，剩下的那些字母因为权值都较小，所以无论怎么取值，等式的左侧都会是一个负数，无法得到 `0`。也就是说，我们应当优先搜索 `M` 的值，并且在指定了 `M` 对应的数字映射之后，需要估计出剩余的项可以凑出的最大值 `max` 和最小值 `min` 分别是多少，如果 `-M * 9000` 不在 `[-max, -min]` 的范围内，那么剩余的项就无法和 `-M * 9000` 累计得到 `0`，也就说明当前搜索的 `M` 值是无解的。

有了这样一个模糊的剪枝概念之后，我们开始考虑如何设计算法。我们先将等式左侧所有的项按照系数的绝对值大小进行降序排序，系数的绝对值越大，搜索的优先级越高，即：

```
M * (-9000) + S * 1000 + O * (-900) + E * 91 + N * (-90) + R * 10 + D + Y * (-1) = 0 
```

随后我们开始进行搜索。首先搜索的是 `M`，我们需要估计剩余项

```
S * 1000 + O * (-900) + E * 91 + N * (-90) + R * 10 + D + Y * (-1)
```

的最大值 `max` 和最小值 `min`。做这个估计的目的是进行搜索剪枝，减少搜索空间，而不是精确地计算出答案。因此我们只需要进行一个粗略的估计即可，即估计出 `max'` 和 `min'`，其中 `max'` 大于等于真正的最大值 `max`，`min'` 小于等于真正的最小值 `min`，这样就不会把正确答案剪枝掉。在大部分情况下，粗略的估计就已经足够了。

那么如何进行一个粗略的估计呢？我们将剩余的项根据系数的正负分为两类，且每一类中按照系数的绝对值大小进行降序排序：

```
系数为正：S * 1000 + E * 91 + R * 10 + D
系数为负：-(O * 900 + N * 90 + Y)
```

我们可以依次考虑这两类，从而估计出最大值和最小值：

- 最大值：对于系数为正的项，我们将 `S` 映射为 `9`，`E` 映射为 `8`，以此类推；对于系数为负的项，我们将 `O` 映射为 `0`，`N` 映射为 `1`，以此类推。这样我们可以估计出最大值 `max' = 9712`；

- 最小值：对于系数为正的项，我们将 `S` 映射为 `0`，`E` 映射为 `1`，以此类推；对于系数为负的项，我们将 `O` 映射为 `9`，`N` 映射为 `8`，以此类推。这样我们可以估计出最小值 `min' = -8713`。

得到 `M * (-9000)` 的取值范围为 `[-max', -min'] = [-9712, 8713]`，而 `M` 又是 `MORE` 和 `MONEY` 的最高位，因此 `M` 只有唯一可能的取值 `1`。这样一个粗略的估计，就帮助我们唯一确定了 `M` 的值。

随后，我们可以开始搜索 `S` 的值，使用同样的方法估计出剩余项可以凑出的最大值和最小值（注意，这里还需要加上第一项 `M * (-9000)` 的值，这个值已经确定，所以就不需要对 `M` 进行新的映射了），确定 `S` 的范围，并进行后续的搜索。

```C++ [sol2-C++]
using PCI = pair<char, int>;

class Solution {
private:
    vector<PCI> weight;
    vector<int> suffix_sum_min, suffix_sum_max;
    vector<int> lead_zero;
    bool used[10];

public:
    int pow10(int x) {
        int ret = 1;
        for (int i = 0; i < x; ++i) {
            ret *= 10;
        }
        return ret;
    }

    bool dfs(int pos, int total) {
        if (pos == weight.size()) {
            return total == 0;
        }
        if (!(total + suffix_sum_min[pos] <= 0 && 0 <= total + suffix_sum_max[pos])) {
            return false;
        }
        for (int i = lead_zero[pos]; i < 10; ++i) {
            if (!used[i]) {
                used[i] = true;
                bool check = dfs(pos + 1, total + weight[pos].second * i);
                used[i] = false;
                if (check) {
                    return true;
                }
            }
        }
        return false;
    }

    bool isSolvable(vector<string>& words, string result) {
        unordered_map<char, int> _weight;
        unordered_set<char> _lead_zero;
        for (const string& word: words) {
            for (int i = 0; i < word.size(); ++i) {
                _weight[word[i]] += pow10(word.size() - i - 1);
            }
            if (word.size() > 1) {
                _lead_zero.insert(word[0]);
            }
        }
        for (int i = 0; i < result.size(); ++i) {
            _weight[result[i]] -= pow10(result.size() - i - 1);
        }
        if (result.size() > 1) {
            _lead_zero.insert(result[0]);
        }

        weight = vector<PCI>(_weight.begin(), _weight.end());
        sort(weight.begin(), weight.end(), [](const PCI& u, const PCI& v) {
            return abs(u.second) > abs(v.second);
        });
        int n = weight.size();
        suffix_sum_min.resize(n);
        suffix_sum_max.resize(n);
        for (int i = 0; i < n; ++i) {
            vector<int> suffix_pos, suffix_neg;
            for (int j = i; j < n; ++j) {
                if (weight[j].second > 0) {
                    suffix_pos.push_back(weight[j].second);
                }
                else if (weight[j].second < 0) {
                    suffix_neg.push_back(weight[j].second);
                }
                sort(suffix_pos.begin(), suffix_pos.end());
                sort(suffix_neg.begin(), suffix_neg.end());
            }
            for (int j = 0; j < suffix_pos.size(); ++j) {
                suffix_sum_min[i] += (suffix_pos.size() - 1 - j) * suffix_pos[j];
                suffix_sum_max[i] += (10 - suffix_pos.size() + j) * suffix_pos[j];
            }
            for (int j = 0; j < suffix_neg.size(); ++j) {
                suffix_sum_min[i] += (9 - j) * suffix_neg[j];
                suffix_sum_max[i] += j * suffix_neg[j];
            }
        }

        lead_zero.resize(n);
        for (int i = 0; i < n; ++i) {
            lead_zero[i] = (_lead_zero.count(weight[i].first) ? 1 : 0);
        }
        
        memset(used, false, sizeof(used));
        return dfs(0, 0);
    }
};
```

```Python [sol2-Python3]
class Solution:
    def isSolvable(self, words: List[str], result: str) -> bool:
        _weight = dict()
        _lead_zero = set()
        for word in words:
            for i, ch in enumerate(word[::-1]):
                _weight[ch] = _weight.get(ch, 0) + 10**i
            if len(word) > 1:
                _lead_zero.add(word[0])
        for i, ch in enumerate(result[::-1]):
            _weight[ch] = _weight.get(ch, 0) - 10**i
        if len(result) > 1:
            _lead_zero.add(result[0])
        
        weight = sorted(list(_weight.items()), key=lambda x: -abs(x[1]))
        suffix_sum_min = [0] * len(weight)
        suffix_sum_max = [0] * len(weight)
        for i in range(len(weight)):
            suffix_pos = sorted(x[1] for x in weight[i:] if x[1] > 0)
            suffix_neg = sorted(x[1] for x in weight[i:] if x[1] < 0)
            suffix_sum_min[i] = sum((len(suffix_pos) - 1 - j) * elem for j, elem in enumerate(suffix_pos)) + sum((9 - j) * elem for j, elem in enumerate(suffix_neg))
            suffix_sum_max[i] = sum((10 - len(suffix_pos) + j) * elem for j, elem in enumerate(suffix_pos)) + sum(j * elem for j, elem in enumerate(suffix_neg))
        
        lead_zero = [int(ch in _lead_zero) for (ch, _) in weight]
        used = [0] * 10
        
        def dfs(pos, total):
            if pos == len(weight):
                return total == 0
            if not total + suffix_sum_min[pos] <= 0 <= total + suffix_sum_max[pos]:
                return False
            for i in range(lead_zero[pos], 10):
                if not used[i]:
                    used[i] = True
                    check = dfs(pos + 1, total + weight[pos][1] * i)
                    used[i] = False
                    if check:
                        return True
            return False
        
        return dfs(0, 0)
```

**运行时间**

- 运行时间：上述 `C++` 代码的运行时间约为 4ms，`Python` 代码的运行时间约为 40ms。