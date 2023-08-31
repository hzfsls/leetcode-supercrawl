## [65.有效数字 中文官方题解](https://leetcode.cn/problems/valid-number/solutions/100000/you-xiao-shu-zi-by-leetcode-solution-298l)

#### 方法一：确定有限状态自动机

**预备知识**

确定有限状态自动机（以下简称「自动机」）是一类计算模型。它包含一系列状态，这些状态中：

- 有一个特殊的状态，被称作「初始状态」。
- 还有一系列状态被称为「接受状态」，它们组成了一个特殊的集合。其中，一个状态可能既是「初始状态」，也是「接受状态」。

起初，这个自动机处于「初始状态」。随后，它顺序地读取字符串中的每一个字符，并根据当前状态和读入的字符，按照某个事先约定好的「转移规则」，从当前状态转移到下一个状态；当状态转移完成后，它就读取下一个字符。当字符串全部读取完毕后，如果自动机处于某个「接受状态」，则判定该字符串「被接受」；否则，判定该字符串「被拒绝」。

**注意**：如果输入的过程中某一步转移失败了，即不存在对应的「转移规则」，此时计算将提前中止。在这种情况下我们也判定该字符串「被拒绝」。

一个自动机，总能够回答某种形式的「对于给定的输入字符串 S，判断其是否满足条件 P」的问题。在本题中，条件 P 即为「构成合法的表示数值的字符串」。

自动机驱动的编程，可以被看做一种暴力枚举方法的延伸：它穷尽了在任何一种情况下，对应任何的输入，需要做的事情。

自动机在计算机科学领域有着广泛的应用。在算法领域，它与大名鼎鼎的字符串查找算法「KMP 算法」有着密切的关联；在工程领域，它是实现「正则表达式」的基础。

**问题描述**

在 [C++ 文档](https://en.cppreference.com/w/cpp/language/floating_literal) 中，描述了一个合法的数值字符串应当具有的格式。具体而言，它包含以下部分：
- 符号位，即 $+$、$-$ 两种符号
- 整数部分，即由若干字符 $0-9$ 组成的字符串
- 小数点
- 小数部分，其构成与整数部分相同
- 指数部分，其中包含开头的字符 $\text{e}$（大写小写均可）、可选的符号位，和整数部分

在上面描述的五个部分中，每个部分都不是必需的，但也受一些额外规则的制约，如：
- 如果符号位存在，其后面必须跟着数字或小数点。
- 小数点的前后两侧，至少有一侧是数字。

**思路与算法**

根据上面的描述，现在可以定义自动机的「状态集合」了。那么怎么挖掘出所有可能的状态呢？一个常用的技巧是，用「当前处理到字符串的哪个部分」当作状态的表述。根据这一技巧，不难挖掘出所有状态：

0. 初始状态
1. 符号位
2. 整数部分
3. 左侧有整数的小数点
4. 左侧无整数的小数点（根据前面的第二条额外规则，需要对左侧有无整数的两种小数点做区分）
5. 小数部分
6. 字符 $\text{e}$
7. 指数部分的符号位
8. 指数部分的整数部分

下一步是找出「初始状态」和「接受状态」的集合。根据题意，「初始状态」应当为状态 0，而「接受状态」的集合则为状态 2、状态 3、状态 5 以及状态 8。换言之，字符串的末尾要么是空格，要么是数字，要么是小数点，但前提是小数点的前面有数字。

最后，需要定义「转移规则」。结合数值字符串应当具备的格式，将自动机转移的过程以图解的方式表示出来：

![fig1](https://assets.leetcode-cn.com/solution-static/65/1.png)

比较上图与「预备知识」一节中对自动机的描述，可以看出有一点不同：
- 我们没有单独地考虑每种字符，而是划分为若干类。由于全部 $10$ 个数字字符彼此之间都等价，因此只需定义一种统一的「数字」类型即可。对于正负号也是同理。

在实际代码中，我们需要处理转移失败的情况。为了处理这种情况，我们可以创建一个特殊的拒绝状态。如果当前状态下没有对应读入字符的「转移规则」，我们就转移到这个特殊的拒绝状态。一旦自动机转移到这个特殊状态，我们就可以立即判定该字符串不「被接受」。

**代码**

可以很简单地将上面的状态转移图翻译成代码：

```C++ [sol1-C++]
class Solution {
public:
    enum State {
        STATE_INITIAL,
        STATE_INT_SIGN,
        STATE_INTEGER,
        STATE_POINT,
        STATE_POINT_WITHOUT_INT,
        STATE_FRACTION,
        STATE_EXP,
        STATE_EXP_SIGN,
        STATE_EXP_NUMBER,
        STATE_END
    };

    enum CharType {
        CHAR_NUMBER,
        CHAR_EXP,
        CHAR_POINT,
        CHAR_SIGN,
        CHAR_ILLEGAL
    };

    CharType toCharType(char ch) {
        if (ch >= '0' && ch <= '9') {
            return CHAR_NUMBER;
        } else if (ch == 'e' || ch == 'E') {
            return CHAR_EXP;
        } else if (ch == '.') {
            return CHAR_POINT;
        } else if (ch == '+' || ch == '-') {
            return CHAR_SIGN;
        } else {
            return CHAR_ILLEGAL;
        }
    }

    bool isNumber(string s) {
        unordered_map<State, unordered_map<CharType, State>> transfer{
            {
                STATE_INITIAL, {
                    {CHAR_NUMBER, STATE_INTEGER},
                    {CHAR_POINT, STATE_POINT_WITHOUT_INT},
                    {CHAR_SIGN, STATE_INT_SIGN}
                }
            }, {
                STATE_INT_SIGN, {
                    {CHAR_NUMBER, STATE_INTEGER},
                    {CHAR_POINT, STATE_POINT_WITHOUT_INT}
                }
            }, {
                STATE_INTEGER, {
                    {CHAR_NUMBER, STATE_INTEGER},
                    {CHAR_EXP, STATE_EXP},
                    {CHAR_POINT, STATE_POINT}
                }
            }, {
                STATE_POINT, {
                    {CHAR_NUMBER, STATE_FRACTION},
                    {CHAR_EXP, STATE_EXP}
                }
            }, {
                STATE_POINT_WITHOUT_INT, {
                    {CHAR_NUMBER, STATE_FRACTION}
                }
            }, {
                STATE_FRACTION,
                {
                    {CHAR_NUMBER, STATE_FRACTION},
                    {CHAR_EXP, STATE_EXP}
                }
            }, {
                STATE_EXP,
                {
                    {CHAR_NUMBER, STATE_EXP_NUMBER},
                    {CHAR_SIGN, STATE_EXP_SIGN}
                }
            }, {
                STATE_EXP_SIGN, {
                    {CHAR_NUMBER, STATE_EXP_NUMBER}
                }
            }, {
                STATE_EXP_NUMBER, {
                    {CHAR_NUMBER, STATE_EXP_NUMBER}
                }
            }
        };

        int len = s.length();
        State st = STATE_INITIAL;

        for (int i = 0; i < len; i++) {
            CharType typ = toCharType(s[i]);
            if (transfer[st].find(typ) == transfer[st].end()) {
                return false;
            } else {
                st = transfer[st][typ];
            }
        }
        return st == STATE_INTEGER || st == STATE_POINT || st == STATE_FRACTION || st == STATE_EXP_NUMBER || st == STATE_END;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isNumber(String s) {
        Map<State, Map<CharType, State>> transfer = new HashMap<State, Map<CharType, State>>();
        Map<CharType, State> initialMap = new HashMap<CharType, State>() {{
            put(CharType.CHAR_NUMBER, State.STATE_INTEGER);
            put(CharType.CHAR_POINT, State.STATE_POINT_WITHOUT_INT);
            put(CharType.CHAR_SIGN, State.STATE_INT_SIGN);
        }};
        transfer.put(State.STATE_INITIAL, initialMap);
        Map<CharType, State> intSignMap = new HashMap<CharType, State>() {{
            put(CharType.CHAR_NUMBER, State.STATE_INTEGER);
            put(CharType.CHAR_POINT, State.STATE_POINT_WITHOUT_INT);
        }};
        transfer.put(State.STATE_INT_SIGN, intSignMap);
        Map<CharType, State> integerMap = new HashMap<CharType, State>() {{
            put(CharType.CHAR_NUMBER, State.STATE_INTEGER);
            put(CharType.CHAR_EXP, State.STATE_EXP);
            put(CharType.CHAR_POINT, State.STATE_POINT);
        }};
        transfer.put(State.STATE_INTEGER, integerMap);
        Map<CharType, State> pointMap = new HashMap<CharType, State>() {{
            put(CharType.CHAR_NUMBER, State.STATE_FRACTION);
            put(CharType.CHAR_EXP, State.STATE_EXP);
        }};
        transfer.put(State.STATE_POINT, pointMap);
        Map<CharType, State> pointWithoutIntMap = new HashMap<CharType, State>() {{
            put(CharType.CHAR_NUMBER, State.STATE_FRACTION);
        }};
        transfer.put(State.STATE_POINT_WITHOUT_INT, pointWithoutIntMap);
        Map<CharType, State> fractionMap = new HashMap<CharType, State>() {{
            put(CharType.CHAR_NUMBER, State.STATE_FRACTION);
            put(CharType.CHAR_EXP, State.STATE_EXP);
        }};
        transfer.put(State.STATE_FRACTION, fractionMap);
        Map<CharType, State> expMap = new HashMap<CharType, State>() {{
            put(CharType.CHAR_NUMBER, State.STATE_EXP_NUMBER);
            put(CharType.CHAR_SIGN, State.STATE_EXP_SIGN);
        }};
        transfer.put(State.STATE_EXP, expMap);
        Map<CharType, State> expSignMap = new HashMap<CharType, State>() {{
            put(CharType.CHAR_NUMBER, State.STATE_EXP_NUMBER);
        }};
        transfer.put(State.STATE_EXP_SIGN, expSignMap);
        Map<CharType, State> expNumberMap = new HashMap<CharType, State>() {{
            put(CharType.CHAR_NUMBER, State.STATE_EXP_NUMBER);
        }};
        transfer.put(State.STATE_EXP_NUMBER, expNumberMap);

        int length = s.length();
        State state = State.STATE_INITIAL;

        for (int i = 0; i < length; i++) {
            CharType type = toCharType(s.charAt(i));
            if (!transfer.get(state).containsKey(type)) {
                return false;
            } else {
                state = transfer.get(state).get(type);
            }
        }
        return state == State.STATE_INTEGER || state == State.STATE_POINT || state == State.STATE_FRACTION || state == State.STATE_EXP_NUMBER || state == State.STATE_END;
    }

    public CharType toCharType(char ch) {
        if (ch >= '0' && ch <= '9') {
            return CharType.CHAR_NUMBER;
        } else if (ch == 'e' || ch == 'E') {
            return CharType.CHAR_EXP;
        } else if (ch == '.') {
            return CharType.CHAR_POINT;
        } else if (ch == '+' || ch == '-') {
            return CharType.CHAR_SIGN;
        } else {
            return CharType.CHAR_ILLEGAL;
        }
    }

    enum State {
        STATE_INITIAL,
        STATE_INT_SIGN,
        STATE_INTEGER,
        STATE_POINT,
        STATE_POINT_WITHOUT_INT,
        STATE_FRACTION,
        STATE_EXP,
        STATE_EXP_SIGN,
        STATE_EXP_NUMBER,
        STATE_END
    }

    enum CharType {
        CHAR_NUMBER,
        CHAR_EXP,
        CHAR_POINT,
        CHAR_SIGN,
        CHAR_ILLEGAL
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsNumber(string s) {
        Dictionary<State, Dictionary<CharType, State>> transfer = new Dictionary<State, Dictionary<CharType, State>>();
        Dictionary<CharType, State> initialDictionary = new Dictionary<CharType, State> {
            {CharType.CHAR_NUMBER, State.STATE_INTEGER},
            {CharType.CHAR_POINT, State.STATE_POINT_WITHOUT_INT},
            {CharType.CHAR_SIGN, State.STATE_INT_SIGN}
        };
        transfer.Add(State.STATE_INITIAL, initialDictionary);
        Dictionary<CharType, State> intSignDictionary = new Dictionary<CharType, State> {
            {CharType.CHAR_NUMBER, State.STATE_INTEGER},
            {CharType.CHAR_POINT, State.STATE_POINT_WITHOUT_INT}
        };
        transfer.Add(State.STATE_INT_SIGN, intSignDictionary);
        Dictionary<CharType, State> integerDictionary = new Dictionary<CharType, State> {
            {CharType.CHAR_NUMBER, State.STATE_INTEGER},
            {CharType.CHAR_EXP, State.STATE_EXP},
            {CharType.CHAR_POINT, State.STATE_POINT}
        };
        transfer.Add(State.STATE_INTEGER, integerDictionary);
        Dictionary<CharType, State> pointDictionary = new Dictionary<CharType, State> {
            {CharType.CHAR_NUMBER, State.STATE_FRACTION},
            {CharType.CHAR_EXP, State.STATE_EXP}
        };
        transfer.Add(State.STATE_POINT, pointDictionary);
        Dictionary<CharType, State> pointWithoutIntDictionary = new Dictionary<CharType, State> {
            {CharType.CHAR_NUMBER, State.STATE_FRACTION}
        };
        transfer.Add(State.STATE_POINT_WITHOUT_INT, pointWithoutIntDictionary);
        Dictionary<CharType, State> fractionDictionary = new Dictionary<CharType, State> {
            {CharType.CHAR_NUMBER, State.STATE_FRACTION},
            {CharType.CHAR_EXP, State.STATE_EXP}
        };
        transfer.Add(State.STATE_FRACTION, fractionDictionary);
        Dictionary<CharType, State> expDictionary = new Dictionary<CharType, State> {
            {CharType.CHAR_NUMBER, State.STATE_EXP_NUMBER},
            {CharType.CHAR_SIGN, State.STATE_EXP_SIGN}
        };
        transfer.Add(State.STATE_EXP, expDictionary);
        Dictionary<CharType, State> expSignDictionary = new Dictionary<CharType, State> {
            {CharType.CHAR_NUMBER, State.STATE_EXP_NUMBER}
        };
        transfer.Add(State.STATE_EXP_SIGN, expSignDictionary);
        Dictionary<CharType, State> expNumberDictionary = new Dictionary<CharType, State> {
            {CharType.CHAR_NUMBER, State.STATE_EXP_NUMBER}
        };
        transfer.Add(State.STATE_EXP_NUMBER, expNumberDictionary);

        int length = s.Length;
        State state = State.STATE_INITIAL;

        for (int i = 0; i < length; i++) {
            CharType type = ToCharType(s[i]);
            if (!transfer[state].ContainsKey(type)) {
                return false;
            } else {
                state = transfer[state][type];
            }
        }
        return state == State.STATE_INTEGER || state == State.STATE_POINT || state == State.STATE_FRACTION || state == State.STATE_EXP_NUMBER || state == State.STATE_END;
    }

    CharType ToCharType(char ch) {
        if (ch >= '0' && ch <= '9') {
            return CharType.CHAR_NUMBER;
        } else if (ch == 'e' || ch == 'E') {
            return CharType.CHAR_EXP;
        } else if (ch == '.') {
            return CharType.CHAR_POINT;
        } else if (ch == '+' || ch == '-') {
            return CharType.CHAR_SIGN;
        } else {
            return CharType.CHAR_ILLEGAL;
        }
    }

    enum State {
        STATE_INITIAL,
        STATE_INT_SIGN,
        STATE_INTEGER,
        STATE_POINT,
        STATE_POINT_WITHOUT_INT,
        STATE_FRACTION,
        STATE_EXP,
        STATE_EXP_SIGN,
        STATE_EXP_NUMBER,
        STATE_END
    }

    enum CharType {
        CHAR_NUMBER,
        CHAR_EXP,
        CHAR_POINT,
        CHAR_SIGN,
        CHAR_ILLEGAL
    }
}
```

```golang [sol1-Golang]
type State int
type CharType int

const (
    STATE_INITIAL State = iota
    STATE_INT_SIGN
    STATE_INTEGER
    STATE_POINT
    STATE_POINT_WITHOUT_INT
    STATE_FRACTION
    STATE_EXP
    STATE_EXP_SIGN
    STATE_EXP_NUMBER
    STATE_END
)

const (
    CHAR_NUMBER CharType = iota
    CHAR_EXP
    CHAR_POINT
    CHAR_SIGN
    CHAR_ILLEGAL
)

func toCharType(ch byte) CharType {
    switch ch {
    case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
        return CHAR_NUMBER
    case 'e', 'E':
        return CHAR_EXP
    case '.':
        return CHAR_POINT
    case '+', '-':
        return CHAR_SIGN
    default:
        return CHAR_ILLEGAL
    }
}

func isNumber(s string) bool {
    transfer := map[State]map[CharType]State{
        STATE_INITIAL: map[CharType]State{
            CHAR_NUMBER: STATE_INTEGER,
            CHAR_POINT:  STATE_POINT_WITHOUT_INT,
            CHAR_SIGN:   STATE_INT_SIGN,
        },
        STATE_INT_SIGN: map[CharType]State{
            CHAR_NUMBER: STATE_INTEGER,
            CHAR_POINT:  STATE_POINT_WITHOUT_INT,
        },
        STATE_INTEGER: map[CharType]State{
            CHAR_NUMBER: STATE_INTEGER,
            CHAR_EXP:    STATE_EXP,
            CHAR_POINT:  STATE_POINT,
        },
        STATE_POINT: map[CharType]State{
            CHAR_NUMBER: STATE_FRACTION,
            CHAR_EXP:    STATE_EXP,
        },
        STATE_POINT_WITHOUT_INT: map[CharType]State{
            CHAR_NUMBER: STATE_FRACTION,
        },
        STATE_FRACTION: map[CharType]State{
            CHAR_NUMBER: STATE_FRACTION,
            CHAR_EXP:    STATE_EXP,
        },
        STATE_EXP: map[CharType]State{
            CHAR_NUMBER: STATE_EXP_NUMBER,
            CHAR_SIGN:   STATE_EXP_SIGN,
        },
        STATE_EXP_SIGN: map[CharType]State{
            CHAR_NUMBER: STATE_EXP_NUMBER,
        },
        STATE_EXP_NUMBER: map[CharType]State{
            CHAR_NUMBER: STATE_EXP_NUMBER,
        },
    }
    state := STATE_INITIAL
    for i := 0; i < len(s); i++ {
        typ := toCharType(s[i])
        if _, ok := transfer[state][typ]; !ok {
            return false
        } else {
            state = transfer[state][typ]
        }
    }
    return state == STATE_INTEGER || state == STATE_POINT || state == STATE_FRACTION || state == STATE_EXP_NUMBER || state == STATE_END
}
```

```C [sol1-C]
enum State {
    STATE_INITIAL,
    STATE_INT_SIGN,
    STATE_INTEGER,
    STATE_POINT,
    STATE_POINT_WITHOUT_INT,
    STATE_FRACTION,
    STATE_EXP,
    STATE_EXP_SIGN,
    STATE_EXP_NUMBER,
    STATE_END,
    STATE_ILLEGAL
};

enum CharType {
    CHAR_NUMBER,
    CHAR_EXP,
    CHAR_POINT,
    CHAR_SIGN,
    CHAR_ILLEGAL
};

enum CharType toCharType(char ch) {
    if (ch >= '0' && ch <= '9') {
        return CHAR_NUMBER;
    } else if (ch == 'e' || ch == 'E') {
        return CHAR_EXP;
    } else if (ch == '.') {
        return CHAR_POINT;
    } else if (ch == '+' || ch == '-') {
        return CHAR_SIGN;
    } else {
        return CHAR_ILLEGAL;
    }
}

enum State transfer(enum State st, enum CharType typ) {
    switch (st) {
        case STATE_INITIAL: {
            switch (typ) {
                case CHAR_NUMBER:
                    return STATE_INTEGER;
                case CHAR_POINT:
                    return STATE_POINT_WITHOUT_INT;
                case CHAR_SIGN:
                    return STATE_INT_SIGN;
                default:
                    return STATE_ILLEGAL;
            }
        }
        case STATE_INT_SIGN: {
            switch (typ) {
                case CHAR_NUMBER:
                    return STATE_INTEGER;
                case CHAR_POINT:
                    return STATE_POINT_WITHOUT_INT;
                default:
                    return STATE_ILLEGAL;
            }
        }
        case STATE_INTEGER: {
            switch (typ) {
                case CHAR_NUMBER:
                    return STATE_INTEGER;
                case CHAR_EXP:
                    return STATE_EXP;
                case CHAR_POINT:
                    return STATE_POINT;
                default:
                    return STATE_ILLEGAL;
            }
        }
        case STATE_POINT: {
            switch (typ) {
                case CHAR_NUMBER:
                    return STATE_FRACTION;
                case CHAR_EXP:
                    return STATE_EXP;
                default:
                    return STATE_ILLEGAL;
            }
        }
        case STATE_POINT_WITHOUT_INT: {
            switch (typ) {
                case CHAR_NUMBER:
                    return STATE_FRACTION;
                default:
                    return STATE_ILLEGAL;
            }
        }
        case STATE_FRACTION: {
            switch (typ) {
                case CHAR_NUMBER:
                    return STATE_FRACTION;
                case CHAR_EXP:
                    return STATE_EXP;
                default:
                    return STATE_ILLEGAL;
            }
        }
        case STATE_EXP: {
            switch (typ) {
                case CHAR_NUMBER:
                    return STATE_EXP_NUMBER;
                case CHAR_SIGN:
                    return STATE_EXP_SIGN;
                default:
                    return STATE_ILLEGAL;
            }
        }
        case STATE_EXP_SIGN: {
            switch (typ) {
                case CHAR_NUMBER:
                    return STATE_EXP_NUMBER;
                default:
                    return STATE_ILLEGAL;
            }
        }
        case STATE_EXP_NUMBER: {
            switch (typ) {
                case CHAR_NUMBER:
                    return STATE_EXP_NUMBER;
                default:
                    return STATE_ILLEGAL;
            }
        }
        default:
            return STATE_ILLEGAL;
    }
}

bool isNumber(char* s) {
    int len = strlen(s);
    enum State st = STATE_INITIAL;

    for (int i = 0; i < len; i++) {
        enum CharType typ = toCharType(s[i]);
        enum State nextState = transfer(st, typ);
        if (nextState == STATE_ILLEGAL) return false;
        st = nextState;
    }
    return st == STATE_INTEGER || st == STATE_POINT || st == STATE_FRACTION || st == STATE_EXP_NUMBER || st == STATE_END;
}
```

```Python [sol1-Python3]
from enum import Enum

class Solution:
    def isNumber(self, s: str) -> bool:
        State = Enum("State", [
            "STATE_INITIAL",
            "STATE_INT_SIGN",
            "STATE_INTEGER",
            "STATE_POINT",
            "STATE_POINT_WITHOUT_INT",
            "STATE_FRACTION",
            "STATE_EXP",
            "STATE_EXP_SIGN",
            "STATE_EXP_NUMBER",
            "STATE_END"
        ])
        Chartype = Enum("Chartype", [
            "CHAR_NUMBER",
            "CHAR_EXP",
            "CHAR_POINT",
            "CHAR_SIGN",
            "CHAR_ILLEGAL"
        ])

        def toChartype(ch: str) -> Chartype:
            if ch.isdigit():
                return Chartype.CHAR_NUMBER
            elif ch.lower() == "e":
                return Chartype.CHAR_EXP
            elif ch == ".":
                return Chartype.CHAR_POINT
            elif ch == "+" or ch == "-":
                return Chartype.CHAR_SIGN
            else:
                return Chartype.CHAR_ILLEGAL
        
        transfer = {
            State.STATE_INITIAL: {
                Chartype.CHAR_NUMBER: State.STATE_INTEGER,
                Chartype.CHAR_POINT: State.STATE_POINT_WITHOUT_INT,
                Chartype.CHAR_SIGN: State.STATE_INT_SIGN
            },
            State.STATE_INT_SIGN: {
                Chartype.CHAR_NUMBER: State.STATE_INTEGER,
                Chartype.CHAR_POINT: State.STATE_POINT_WITHOUT_INT
            },
            State.STATE_INTEGER: {
                Chartype.CHAR_NUMBER: State.STATE_INTEGER,
                Chartype.CHAR_EXP: State.STATE_EXP,
                Chartype.CHAR_POINT: State.STATE_POINT
            },
            State.STATE_POINT: {
                Chartype.CHAR_NUMBER: State.STATE_FRACTION,
                Chartype.CHAR_EXP: State.STATE_EXP
            },
            State.STATE_POINT_WITHOUT_INT: {
                Chartype.CHAR_NUMBER: State.STATE_FRACTION
            },
            State.STATE_FRACTION: {
                Chartype.CHAR_NUMBER: State.STATE_FRACTION,
                Chartype.CHAR_EXP: State.STATE_EXP
            },
            State.STATE_EXP: {
                Chartype.CHAR_NUMBER: State.STATE_EXP_NUMBER,
                Chartype.CHAR_SIGN: State.STATE_EXP_SIGN
            },
            State.STATE_EXP_SIGN: {
                Chartype.CHAR_NUMBER: State.STATE_EXP_NUMBER
            },
            State.STATE_EXP_NUMBER: {
                Chartype.CHAR_NUMBER: State.STATE_EXP_NUMBER
            },
        }

        st = State.STATE_INITIAL
        for ch in s:
            typ = toChartype(ch)
            if typ not in transfer[st]:
                return False
            st = transfer[st][typ]
        
        return st in [State.STATE_INTEGER, State.STATE_POINT, State.STATE_FRACTION, State.STATE_EXP_NUMBER, State.STATE_END]
```

```JavaScript [sol1-JavaScript]
var isNumber = function(s) {
    const State = {
        STATE_INITIAL : "STATE_INITIAL",
        STATE_INT_SIGN : "STATE_INT_SIGN",
        STATE_INTEGER : "STATE_INTEGER",
        STATE_POINT : "STATE_POINT",
        STATE_POINT_WITHOUT_INT : "STATE_POINT_WITHOUT_INT",
        STATE_FRACTION : "STATE_FRACTION",
        STATE_EXP : "STATE_EXP",
        STATE_EXP_SIGN : "STATE_EXP_SIGN",
        STATE_EXP_NUMBER : "STATE_EXP_NUMBER",
        STATE_END : "STATE_END"
    }

    const CharType = {
        CHAR_NUMBER : "CHAR_NUMBER",
        CHAR_EXP : "CHAR_EXP",
        CHAR_POINT : "CHAR_POINT",
        CHAR_SIGN : "CHAR_SIGN",
        CHAR_ILLEGAL : "CHAR_ILLEGAL"
    }

    const toCharType = (ch) => {
        if (!isNaN(ch)) {
            return CharType.CHAR_NUMBER;
        } else if (ch.toLowerCase() === 'e') {
            return CharType.CHAR_EXP;
        } else if (ch === '.') {
            return CharType.CHAR_POINT;
        } else if (ch === '+' || ch === '-') {
            return CharType.CHAR_SIGN;
        } else {
            return CharType.CHAR_ILLEGAL;
        }
    }   

    const transfer = new Map();
    const initialMap = new Map();
    initialMap.set(CharType.CHAR_NUMBER, State.STATE_INTEGER);
    initialMap.set(CharType.CHAR_POINT, State.STATE_POINT_WITHOUT_INT);
    initialMap.set(CharType.CHAR_SIGN, State.STATE_INT_SIGN);
    transfer.set(State.STATE_INITIAL, initialMap);
    const intSignMap = new Map();
    intSignMap.set(CharType.CHAR_NUMBER, State.STATE_INTEGER);
    intSignMap.set(CharType.CHAR_POINT, State.STATE_POINT_WITHOUT_INT);
    transfer.set(State.STATE_INT_SIGN, intSignMap);
    const integerMap = new Map();
    integerMap.set(CharType.CHAR_NUMBER, State.STATE_INTEGER);
    integerMap.set(CharType.CHAR_EXP, State.STATE_EXP);
    integerMap.set(CharType.CHAR_POINT, State.STATE_POINT);
    transfer.set(State.STATE_INTEGER, integerMap);
    const pointMap = new Map() 
    pointMap.set(CharType.CHAR_NUMBER, State.STATE_FRACTION);
    pointMap.set(CharType.CHAR_EXP, State.STATE_EXP);
    transfer.set(State.STATE_POINT, pointMap);
    const pointWithoutIntMap = new Map();
    pointWithoutIntMap.set(CharType.CHAR_NUMBER, State.STATE_FRACTION);
    transfer.set(State.STATE_POINT_WITHOUT_INT, pointWithoutIntMap);
    const fractionMap = new Map();
    fractionMap.set(CharType.CHAR_NUMBER, State.STATE_FRACTION);
    fractionMap.set(CharType.CHAR_EXP, State.STATE_EXP);
    transfer.set(State.STATE_FRACTION, fractionMap);
    const expMap = new Map(); 
    expMap.set(CharType.CHAR_NUMBER, State.STATE_EXP_NUMBER);
    expMap.set(CharType.CHAR_SIGN, State.STATE_EXP_SIGN);
    transfer.set(State.STATE_EXP, expMap);
    const expSignMap = new Map();
    expSignMap.set(CharType.CHAR_NUMBER, State.STATE_EXP_NUMBER);
    transfer.set(State.STATE_EXP_SIGN, expSignMap);
    const expNumberMap = new Map();
    expNumberMap.set(CharType.CHAR_NUMBER, State.STATE_EXP_NUMBER);
    transfer.set(State.STATE_EXP_NUMBER, expNumberMap);

    const length = s.length;
    let state = State.STATE_INITIAL;

    for (let i = 0; i < length; i++) {
        const type = toCharType(s[i]);
        if (!transfer.get(state).has(type)) {
            return false;
        } else {
            state = transfer.get(state).get(type);
        }
    }
    return state === State.STATE_INTEGER || state === State.STATE_POINT || state === State.STATE_FRACTION || state === State.STATE_EXP_NUMBER || state === State.STATE_END;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串的长度。我们需要遍历字符串的每个字符，其中状态转移所需的时间复杂度为 $O(1)$。

- 空间复杂度：$O(1)$。只需要创建固定大小的状态转移表。