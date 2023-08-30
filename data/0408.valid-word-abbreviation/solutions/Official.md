#### 方法：模拟

关键是分析清楚判断缩写的条件：

- 可以用不含前导零的数字替换长度等于该数字的字符串，如题中给出 $word$ 就可以直接被替换成 $4$ ，因为 $word$ 字符串长度为 $4$ 。
- 剩余的均为小写字母且小写字母所在的位置要与原单词对应，如题中给的缩写 $3d$ ，缩写中的 $d$ 是代表了原单词中**第 $4$ 个** 位置必须为 $d$ ，第几个位置就是累加算得，$d$ 前面有一个数字 $3$ ，说明前面有一串长度为 $3$ 的字符串被替换了，则到 $d$ 就是第四个位置了，那么如果有一个缩写是 $3d12c$ ，则 $c$ 的位置就是对应原单词中的第 $3+1+12+1=17$ 个位置了。 

所以判断给定缩写是否是给定单词的缩写，首先是要保证缩写还原回去以后的字符串长度等于单词的长度，这个我们通过上面的条件可以遍历 $abbr$ 来还原该缩写代表的字符串的长度，即 $abbr$ 中字母对长度贡献 $1$ ，字母间的数字对长度贡献数字大小的长度，其次要判断小写字母对应在原单词中的位置是否也为这个小写字母。

最后实现就是从前往后遍历 $abbr$ ，同时用 $num$ 记录字母间的数字大小，$abbrLen$ 记录当前字母的对应原串中的位置。

如果是字母则 $abbrLen+=num+1$ ，即之前的数字大小加上该字母贡献的长度 $1$ ，同时对比原单词中的位置 $word[abbrLen-1]$ 是否也为该字母，然后清空 $num$ 。

如果碰到数字则更新 $num$， $num=num*10+abbr[i]-'0'$ ，这其实就是一个十进制数字字符串转十进制数字的过程，从前往后遍历数字字符，不断乘 $10$ 加上当前数字字符即可，最后比较 $abbrLen$ 与单词长度是否相等。

如果以上条件均满足，则说明这个缩写可以是给定单词的缩写。

```c++ []
class Solution {
public:
    bool validWordAbbreviation(string word, string abbr) {
        int len=(int)abbr.length(),wordLen=(int)word.length();
        int abbrLen=0,num=0;
        for (int i=0;i<len;++i){
            if (abbr[i]>='a' && abbr[i]<='z'){
                abbrLen+=num+1;
                num=0;
                if (abbrLen>wordLen || abbr[i]!=word[abbrLen-1]) return false;
            }
            else{
                if (!num && abbr[i]=='0') return false; // 不能出现前导零
                num=num*10+abbr[i]-'0';
            }
        }
        return abbrLen+num==wordLen;
    }
};
```
```javascript []
/**
 * @param {string} word
 * @param {string} abbr
 * @return {boolean}
 */
var validWordAbbreviation = function(word, abbr) {
    var wordLen = word.length;
    var abbrLen = 0, num = 0;
    var flag = 1;
    [...abbr].forEach((value) => {
        if (value >= 'a' && value <= 'z') {
            abbrLen += num + 1;
            num = 0;
            if (abbrLen > wordLen || value != word[abbrLen-1]) {
                flag = 0;
            }
        }
        else {
            if (num == 0 && value == '0') {
                flag = 0;
            }
            num = num * 10 + (value - '0');
        }
    })
    return flag && abbrLen + num == wordLen;
};
```
```golang []
func validWordAbbreviation(word string, abbr string) bool {
    digit := 0
    idx := 0
    for i := 0; i < len(abbr); i++ {
        if abbr[i] == '0' && digit == 0 {
            return false
        }
        if abbr[i] >= '0' && abbr[i] <= '9' {
            digit = digit * 10 + int(abbr[i] - '0')
        } else {
            idx += digit
            digit = 0
            if idx >= len(word) || word[idx] != abbr[i] {
                return false
            }
            idx++
        }
    }
    return len(word) - idx == digit
}
```


**复杂度分析**

- 时间复杂度：只需要遍历一遍 $abbr$ 字符串，所以所需时间复杂度为 $O(n)$ ，$n=abbr.length$。

- 空间复杂度：$O(1)$ ，只需要常数的空间大小。