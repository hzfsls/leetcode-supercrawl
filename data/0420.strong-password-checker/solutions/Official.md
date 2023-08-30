#### 方法一：分类讨论

**思路与算法**

根据题目中的要求，我们可以将给定的字符串按照长度分成三类，进行分类讨论，即：

- 长度严格小于 $6$；
- 长度在 $[6, 20]$ 范围内；
- 长度严格大于 $20$。

题目中给定的操作有三种，即：（1）添加一个字符；（2）替换一个字符；（3）删除一个字符。

下面我们进行分类讨论，为了方便叙述，记给定字符串的长度为 $n$。

- 当给定的字符串长度严格小于 $6$ 时，我们可以发现「删除一个字符」的操作是没有意义的，因为为了使得长度满足要求，我们需要至少添加 $6-n$ 个字符，而每使用「删除一个字符」的操作，我们就需要一次额外的「添加一个字符」的操作来保证长度。由于我们「删除一个字符」的目的只可能是因为该字符连续出现了三次或以上，因此我们不妨在原本被删除的字符的两侧均「添加一个字符」，使用相同次数的操作达到同样（或者更好）的结果。

    这样一来，如果字符串中出现不超过 $4$ 个连续相同的字符，「替换一个字符」的操作也是没有意义的，因为「替换一个字符」的目的只可能是将连续相同的字符中间的某个字符替换成不同的字符，而这个数量不超过 $4$ 时，我们在中间的位置添加一个不同的字符，也可以达到同样（或者更好）的结果。

    如果字符串中出现了 $5$ 个连续相同的字符，那么「替换一个字符」的操作同样也是没有意义的。因为此时字符的种类只有一种，至少需要两次操作才能达到字符种类的要求。而我们在中间字符的两侧分别添加一个不同种类的字符，即可满足要求，并且操作次数最少。

    因此，我们证明出了在这种情况下，只有「添加一个字符」的操作是有意义的。因此，该操作的次数为 $6 - n$ 与 $3 - ($字符种类$)$ 中的较大值，即需要保证字符串长度和字符种类均满足要求。

- 当给定的字符串长度在 $[6, 20]$ 范围内，我们可以发现「添加一个字符」和「删除一个字符」的操作是没有意义的，这是因为在长度已经满足要求的前提下，我们只需要再满足：（1）包含全部的 $3$ 类字符；（2）同一字符不连续出现 $3$ 次。对于（1）而言，「删除一个字符」与该要求相反，而如果我们选择「添加一个字符」以增加字符的种类数，我们也可以「替换一个字符」，将当前数量较多的那一种字符替换成一种新的字符。对于（2）而言，如果「删除一个字符」，我们也可以将待删除的那个字符替换成与周围字符均不相同的字符；如果「添加一个字符」，我们也可以将添加位置两侧字符中的其中一个替换成待添加的字符，这样的结果均是一致的。

    因此，我们只需要考虑「替换一个字符」这一种操作就行了。对于连续的 $k$ 个相同的字符，我们可以替换其中 $\Big\lfloor \dfrac{k}{3} \Big\rfloor$ 个，使得不存在 $3$ 个连续相同的字符（即每数 $3$ 个字符就替换一次）。同时，我们还需要保证最终字符串包含全部的 $3$ 类字符，因此替换操作的次数为 $($所有的 $\Big\lfloor \dfrac{k}{3} \Big\rfloor$ 之和$)$ 与 $3 - ($字符种类$)$ 中的较大值。

- 当给定的字符串长度严格大于 $20$ 时，类似地我们可以发现「添加一个字符」的操作是没有意义的，但此时「替换一个字符」和「删除一个字符」这两种操作都是必不可少的。这是因为「删除一个字符」会起到调整（减少）字符串长度的作用，而当字符串长度满足要求，但仍然存在 $3$ 个连续相同字符的时候，「替换一个字符」的操作在上一类讨论中被证明是比「删除一个字符」更优的。

    那么我们首先可以分别求出「替换一个字符」和「删除一个字符」需要的次数。对于「替换一个字符」，与上一类讨论一样，需要的次数为 $($所有的 $\Big\lfloor \dfrac{k}{3} \Big\rfloor$ 之和$)$；而对于「删除一个字符」，需要的次数为 $n-20$。然而在删除字符的过程中，连续相同的字符数量也会变少。根据 $k \bmod 3$ 的值的不同，我们可以得出如下关于 $\Big\lfloor \dfrac{k}{3} \Big\rfloor$ 值的变化的结论：

    - 如果 $k \bmod 3 = 0$，那么删除 $1$ 个字符后，$\Big\lfloor \dfrac{k}{3} \Big\rfloor$ 的值会减少 $1$，随后每删除 $3$ 个字符，$\Big\lfloor \dfrac{k}{3} \Big\rfloor$ 的值会再减少 $1$；

    - 如果 $k \bmod 3 = 1$，那么删除 $2$ 个字符后，$\Big\lfloor \dfrac{k}{3} \Big\rfloor$ 的值会减少 $1$，随后每删除 $3$ 个字符，$\Big\lfloor \dfrac{k}{3} \Big\rfloor$ 的值会再减少 $1$；

    - 如果 $k \bmod 3 = 2$，那么每删除 $3$ 个字符，$\Big\lfloor \dfrac{k}{3} \Big\rfloor$ 的值会减少 $1$。

    因此在删除字符时，我们优先从所有 $k \bmod 3 = 0$ 的连续相同字符组中删除 $1$ 个字符（这样可以使得「替换一个字符」的操作次数同时减少 $1$），其次从所有 $k \bmod 3 = 1$ 的连续相同字符组中删除 $2$ 个字符（这样可以使得「替换一个字符」的操作次数同时减少 $1$），最后每删除 $3$ 个字符，可以使得「替换一个字符」的操作次数减少 $1$。

    最终「删除一个字符」需要的次数为 $n-20$，「替换一个字符」需要的次数为 $($所有的 $\Big\lfloor \dfrac{k}{3} \Big\rfloor$ 之和$)$ ，但可以通过删除字符省去若干次操作，最后得到的真正需要的操作次数还需要与 $3 - ($字符种类$)$ 取较大值。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    int strongPasswordChecker(string password) {
        int n = password.size();
        bool has_lower = false, has_upper = false, has_digit = false;
        for (char ch: password) {
            if (islower(ch)) {
                has_lower = true;
            }
            else if (isupper(ch)) {
                has_upper = true;
            }
            else if (isdigit(ch)) {
                has_digit = true;
            }
        }
        int categories = has_lower + has_upper + has_digit;

        if (n < 6) {
            return max(6 - n, 3 - categories);
        }
        else if (n <= 20) {
            int replace = 0;
            int cnt = 0;
            char cur = '#';

            for (char ch: password) {
                if (ch == cur) {
                    ++cnt;
                }
                else {
                    replace += cnt / 3;
                    cnt = 1;
                    cur = ch;
                }
            }
            replace += cnt / 3;
            return max(replace, 3 - categories);
        }
        else {
            // 替换次数和删除次数
            int replace = 0, remove = n - 20;
            // k mod 3 = 1 的组数，即删除 2 个字符可以减少 1 次替换操作
            int rm2 = 0;
            int cnt = 0;
            char cur = '#';

            for (char ch: password) {
                if (ch == cur) {
                    ++cnt;
                }
                else {
                    if (remove > 0 && cnt >= 3) {
                        if (cnt % 3 == 0) {
                            // 如果是 k % 3 = 0 的组，那么优先删除 1 个字符，减少 1 次替换操作
                            --remove;
                            --replace;
                        }
                        else if (cnt % 3 == 1) {
                            // 如果是 k % 3 = 1 的组，那么存下来备用
                            ++rm2;
                        }
                        // k % 3 = 2 的组无需显式考虑
                    }
                    replace += cnt / 3;
                    cnt = 1;
                    cur = ch;
                }
            }
            if (remove > 0 && cnt >= 3) {
                if (cnt % 3 == 0) {
                    --remove;
                    --replace;
                }
                else if (cnt % 3 == 1) {
                    ++rm2;
                }
            }
            replace += cnt / 3;

            // 使用 k % 3 = 1 的组的数量，由剩余的替换次数、组数和剩余的删除次数共同决定
            int use2 = min({replace, rm2, remove / 2});
            replace -= use2;
            remove -= use2 * 2;
            // 由于每有一次替换次数就一定有 3 个连续相同的字符（k / 3 决定），因此这里可以直接计算出使用 k % 3 = 2 的组的数量
            int use3 = min({replace, remove / 3});
            replace -= use3;
            remove -= use3 * 3;
            return (n - 20) + max(replace, 3 - categories);
        }
    }
};
```

```Java [sol1-Java]
class Solution {
    public int strongPasswordChecker(String password) {
        int n = password.length();
        int hasLower = 0, hasUpper = 0, hasDigit = 0;
        for (int i = 0; i < n; ++i) {
            char ch = password.charAt(i);
            if (Character.isLowerCase(ch)) {
                hasLower = 1;
            } else if (Character.isUpperCase(ch)) {
                hasUpper = 1;
            } else if (Character.isDigit(ch)) {
                hasDigit = 1;
            }
        }
        int categories = hasLower + hasUpper + hasDigit;

        if (n < 6) {
            return Math.max(6 - n, 3 - categories);
        } else if (n <= 20) {
            int replace = 0;
            int cnt = 0;
            char cur = '#';

            for (int i = 0; i < n; ++i) {
                char ch = password.charAt(i);
                if (ch == cur) {
                    ++cnt;
                } else {
                    replace += cnt / 3;
                    cnt = 1;
                    cur = ch;
                }
            }
            replace += cnt / 3;
            return Math.max(replace, 3 - categories);
        } else {
            // 替换次数和删除次数
            int replace = 0, remove = n - 20;
            // k mod 3 = 1 的组数，即删除 2 个字符可以减少 1 次替换操作
            int rm2 = 0;
            int cnt = 0;
            char cur = '#';

            for (int i = 0; i < n; ++i) {
                char ch = password.charAt(i);
                if (ch == cur) {
                    ++cnt;
                } else {
                    if (remove > 0 && cnt >= 3) {
                        if (cnt % 3 == 0) {
                            // 如果是 k % 3 = 0 的组，那么优先删除 1 个字符，减少 1 次替换操作
                            --remove;
                            --replace;
                        } else if (cnt % 3 == 1) {
                            // 如果是 k % 3 = 1 的组，那么存下来备用
                            ++rm2;
                        }
                        // k % 3 = 2 的组无需显式考虑
                    }
                    replace += cnt / 3;
                    cnt = 1;
                    cur = ch;
                }
            }
            if (remove > 0 && cnt >= 3) {
                if (cnt % 3 == 0) {
                    --remove;
                    --replace;
                } else if (cnt % 3 == 1) {
                    ++rm2;
                }
            }
            replace += cnt / 3;

            // 使用 k % 3 = 1 的组的数量，由剩余的替换次数、组数和剩余的删除次数共同决定
            int use2 = Math.min(Math.min(replace, rm2), remove / 2);
            replace -= use2;
            remove -= use2 * 2;
            // 由于每有一次替换次数就一定有 3 个连续相同的字符（k / 3 决定），因此这里可以直接计算出使用 k % 3 = 2 的组的数量
            int use3 = Math.min(replace, remove / 3);
            replace -= use3;
            remove -= use3 * 3;
            return (n - 20) + Math.max(replace, 3 - categories);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int StrongPasswordChecker(string password) {
        int n = password.Length;
        int hasLower = 0, hasUpper = 0, hasDigit = 0;
        foreach (char ch in password) {
            if (char.IsLower(ch)) {
                hasLower = 1;
            } else if (char.IsUpper(ch)) {
                hasUpper = 1;
            } else if (char.IsDigit(ch)) {
                hasDigit = 1;
            }
        }
        int categories = hasLower + hasUpper + hasDigit;

        if (n < 6) {
            return Math.Max(6 - n, 3 - categories);
        } else if (n <= 20) {
            int replace = 0;
            int cnt = 0;
            char cur = '#';

            foreach (char ch in password) {
                if (ch == cur) {
                    ++cnt;
                } else {
                    replace += cnt / 3;
                    cnt = 1;
                    cur = ch;
                }
            }
            replace += cnt / 3;
            return Math.Max(replace, 3 - categories);
        } else {
            // 替换次数和删除次数
            int replace = 0, remove = n - 20;
            // k mod 3 = 1 的组数，即删除 2 个字符可以减少 1 次替换操作
            int rm2 = 0;
            int cnt = 0;
            char cur = '#';

            foreach (char ch in password) {
                if (ch == cur) {
                    ++cnt;
                } else {
                    if (remove > 0 && cnt >= 3) {
                        if (cnt % 3 == 0) {
                            // 如果是 k % 3 = 0 的组，那么优先删除 1 个字符，减少 1 次替换操作
                            --remove;
                            --replace;
                        } else if (cnt % 3 == 1) {
                            // 如果是 k % 3 = 1 的组，那么存下来备用
                            ++rm2;
                        }
                        // k % 3 = 2 的组无需显式考虑
                    }
                    replace += cnt / 3;
                    cnt = 1;
                    cur = ch;
                }
            }
            if (remove > 0 && cnt >= 3) {
                if (cnt % 3 == 0) {
                    --remove;
                    --replace;
                } else if (cnt % 3 == 1) {
                    ++rm2;
                }
            }
            replace += cnt / 3;

            // 使用 k % 3 = 1 的组的数量，由剩余的替换次数、组数和剩余的删除次数共同决定
            int use2 = Math.Min(Math.Min(replace, rm2), remove / 2);
            replace -= use2;
            remove -= use2 * 2;
            // 由于每有一次替换次数就一定有 3 个连续相同的字符（k / 3 决定），因此这里可以直接计算出使用 k % 3 = 2 的组的数量
            int use3 = Math.Min(replace, remove / 3);
            replace -= use3;
            remove -= use3 * 3;
            return (n - 20) + Math.Max(replace, 3 - categories);
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def strongPasswordChecker(self, password: str) -> int:
        n = len(password)
        has_lower = has_upper = has_digit = False
        for ch in password:
            if ch.islower():
                has_lower = True
            elif ch.isupper():
                has_upper = True
            elif ch.isdigit():
                has_digit = True
        
        categories = has_lower + has_upper + has_digit

        if n < 6:
            return max(6 - n, 3 - categories)
        elif n <= 20:
            replace = cnt = 0
            cur = "#"

            for ch in password:
                if ch == cur:
                    cnt += 1
                else:
                    replace += cnt // 3
                    cnt = 1
                    cur = ch
            
            replace += cnt // 3
            return max(replace, 3 - categories)
        else:
            # 替换次数和删除次数
            replace, remove = 0, n - 20
            # k mod 3 = 1 的组数，即删除 2 个字符可以减少 1 次替换操作
            rm2 = cnt = 0
            cur = "#"

            for ch in password:
                if ch == cur:
                    cnt += 1
                else:
                    if remove > 0 and cnt >= 3:
                        if cnt % 3 == 0:
                            # 如果是 k % 3 = 0 的组，那么优先删除 1 个字符，减少 1 次替换操作
                            remove -= 1
                            replace -= 1
                        elif cnt % 3 == 1:
                            # 如果是 k % 3 = 1 的组，那么存下来备用
                            rm2 += 1
                        # k % 3 = 2 的组无需显式考虑
                    replace += cnt // 3
                    cnt = 1
                    cur = ch
            
            if remove > 0 and cnt >= 3:
                if cnt % 3 == 0:
                    remove -= 1
                    replace -= 1
                elif cnt % 3 == 1:
                    rm2 += 1
            
            replace += cnt // 3

            # 使用 k % 3 = 1 的组的数量，由剩余的替换次数、组数和剩余的删除次数共同决定
            use2 = min(replace, rm2, remove // 2)
            replace -= use2
            remove -= use2 * 2
            # 由于每有一次替换次数就一定有 3 个连续相同的字符（k / 3 决定），因此这里可以直接计算出使用 k % 3 = 2 的组的数量
            use3 = min(replace, remove // 3)
            replace -= use3
            remove -= use3 * 3
            return (n - 20) + max(replace, 3 - categories)
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int strongPasswordChecker(char * password) {
    int n = strlen(password);
    bool has_lower = false, has_upper = false, has_digit = false;
    for (int i = 0; i < n; i++) {
        if (islower(password[i])) {
            has_lower = true;
        } else if (isupper(password[i])) {
            has_upper = true;
        } else if (isdigit(password[i])) {
            has_digit = true;
        }
    }
    int categories = has_lower + has_upper + has_digit;

    if (n < 6) {
        return MAX(6 - n, 3 - categories);
    } else if (n <= 20) {
        int replace = 0;
        int cnt = 0;
        char cur = '#';

        for (int i = 0; i < n; i++) {
            if (password[i] == cur) {
                ++cnt;
            } else {
                replace += cnt / 3;
                cnt = 1;
                cur = password[i];
            }
        }
        replace += cnt / 3;
        return MAX(replace, 3 - categories);
    } else {
        // 替换次数和删除次数
        int replace = 0, remove = n - 20;
        // k mod 3 = 1 的组数，即删除 2 个字符可以减少 1 次替换操作
        int rm2 = 0;
        int cnt = 0;
        char cur = '#';

        for (int i = 0; i < n; i++) {
            if (password[i] == cur) {
                ++cnt;
            } else {
                if (remove > 0 && cnt >= 3) {
                    if (cnt % 3 == 0) {
                        // 如果是 k % 3 = 0 的组，那么优先删除 1 个字符，减少 1 次替换操作
                        --remove;
                        --replace;
                    } else if (cnt % 3 == 1) {
                        // 如果是 k % 3 = 1 的组，那么存下来备用
                        ++rm2;
                    }
                    // k % 3 = 2 的组无需显式考虑
                }
                replace += cnt / 3;
                cnt = 1;
                cur = password[i];
            }
        }
        if (remove > 0 && cnt >= 3) {
            if (cnt % 3 == 0) {
                --remove;
                --replace;
            } else if (cnt % 3 == 1) {
                ++rm2;
            }
        }
        replace += cnt / 3;

        // 使用 k % 3 = 1 的组的数量，由剩余的替换次数、组数和剩余的删除次数共同决定
        int use2 = MIN(MIN(replace, rm2), remove / 2);
        replace -= use2;
        remove -= use2 * 2;
        // 由于每有一次替换次数就一定有 3 个连续相同的字符（k / 3 决定），因此这里可以直接计算出使用 k % 3 = 2 的组的数量
        int use3 = MIN(replace, remove / 3);
        replace -= use3;
        remove -= use3 * 3;
        return (n - 20) + MAX(replace, 3 - categories);
    }
}
```

```go [sol1-Golang]
func strongPasswordChecker(password string) int {
    hasLower, hasUpper, hasDigit := 0, 0, 0
    for _, ch := range password {
        if unicode.IsLower(ch) {
            hasLower = 1
        } else if unicode.IsUpper(ch) {
            hasUpper = 1
        } else if unicode.IsDigit(ch) {
            hasDigit = 1
        }
    }
    categories := hasLower + hasUpper + hasDigit

    switch n := len(password); {
    case n < 6:
        return max(6-n, 3-categories)
    case n <= 20:
        replace, cnt, cur := 0, 0, '#'
        for _, ch := range password {
            if ch == cur {
                cnt++
            } else {
                replace += cnt / 3
                cnt = 1
                cur = ch
            }
        }
        replace += cnt / 3
        return max(replace, 3-categories)
    default:
        // 替换次数和删除次数
        replace, remove := 0, n-20
        // k mod 3 = 1 的组数，即删除 2 个字符可以减少 1 次替换操作
        rm2, cnt, cur := 0, 0, '#'
        for _, ch := range password {
            if ch == cur {
                cnt++
                continue
            }
            if remove > 0 && cnt >= 3 {
                if cnt%3 == 0 {
                    // 如果是 k % 3 = 0 的组，那么优先删除 1 个字符，减少 1 次替换操作
                    remove--
                    replace--
                } else if cnt%3 == 1 {
                    // 如果是 k % 3 = 1 的组，那么存下来备用
                    rm2++
                }
                // k % 3 = 2 的组无需显式考虑
            }
            replace += cnt / 3
            cnt = 1
            cur = ch
        }

        if remove > 0 && cnt >= 3 {
            if cnt%3 == 0 {
                remove--
                replace--
            } else if cnt%3 == 1 {
                rm2++
            }
        }

        replace += cnt / 3

        // 使用 k % 3 = 1 的组的数量，由剩余的替换次数、组数和剩余的删除次数共同决定
        use2 := min(min(replace, rm2), remove/2)
        replace -= use2
        remove -= use2 * 2

        // 由于每有一次替换次数就一定有 3 个连续相同的字符（k / 3 决定），因此这里可以直接计算出使用 k % 3 = 2 的组的数量
        use3 := min(replace, remove/3)
        replace -= use3
        remove -= use3 * 3
        return (n - 20) + max(replace, 3-categories)
    }
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var strongPasswordChecker = function(password) {
    const n = password.length;
    let hasLower = 0, hasUpper = 0, hasDigit = 0;
    for (let i = 0; i < n; ++i) {
        const ch = password[i];
        if (isLowerCase(ch)) {
            hasLower = 1;
        } else if (isUpperCase(ch)) {
            hasUpper = 1;
        } else if (isDigit(ch)) {
            hasDigit = 1;
        }
    }
    const categories = hasLower + hasUpper + hasDigit;

    if (n < 6) {
        return Math.max(6 - n, 3 - categories);
    } else if (n <= 20) {
        let replace = 0;
        let cnt = 0;
        let cur = '#';

        for (let i = 0; i < n; ++i) {
            const ch = password[i];
            if (ch === cur) {
                ++cnt;
            } else {
                replace += Math.floor(cnt / 3);
                cnt = 1;
                cur = ch;
            }
        }
        replace += Math.floor(cnt / 3);
        return Math.max(replace, 3 - categories);
    } else {
        // 替换次数和删除次数
        let replace = 0, remove = n - 20;
        // k mod 3 = 1 的组数，即删除 2 个字符可以减少 1 次替换操作
        let rm2 = 0;
        let cnt = 0;
        let cur = '#';

        for (let i = 0; i < n; ++i) {
            const ch = password[i];
            if (ch === cur) {
                ++cnt;
            } else {
                if (remove > 0 && cnt >= 3) {
                    if (cnt % 3 === 0) {
                        // 如果是 k % 3 = 0 的组，那么优先删除 1 个字符，减少 1 次替换操作
                        --remove;
                        --replace;
                    } else if (cnt % 3 === 1) {
                        // 如果是 k % 3 = 1 的组，那么存下来备用
                        ++rm2;
                    }
                    // k % 3 = 2 的组无需显式考虑
                }
                replace += Math.floor(cnt / 3);
                cnt = 1;
                cur = ch;
            }
        }
        if (remove > 0 && cnt >= 3) {
            if (cnt % 3 === 0) {
                --remove;
                --replace;
            } else if (cnt % 3 === 1) {
                ++rm2;
            }
        }
        replace += Math.floor(cnt / 3);

        // 使用 k % 3 = 1 的组的数量，由剩余的替换次数、组数和剩余的删除次数共同决定
        const use2 = Math.min(Math.min(replace, rm2), Math.floor(remove / 2));
        replace -= use2;
        remove -= use2 * 2;
        // 由于每有一次替换次数就一定有 3 个连续相同的字符（k / 3 决定），因此这里可以直接计算出使用 k % 3 = 2 的组的数量
        const use3 = Math.min(replace, Math.floor(remove / 3));
        replace -= use3;
        remove -= use3 * 3;
        return (n - 20) + Math.max(replace, 3 - categories);
    }
};

const isLowerCase = (ch) => {
    return 'a' <= ch && ch <= 'z';
}

const isUpperCase = (ch) => {
    return 'A' <= ch && ch <= 'Z';
}

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{password}$ 的长度。我们只需要对字符串进行常数次遍历。

- 空间复杂度：$O(1)$。