## [929.独特的电子邮件地址 中文官方题解](https://leetcode.cn/problems/unique-email-addresses/solutions/100000/du-te-de-dian-zi-you-jian-di-zhi-by-leet-f178)
#### 方法一：哈希表

根据题意，我们需要将每个邮件地址的本地名按照规则转换，具体来说：

- 去掉本地名中第一个加号之后的部分（包括加号）；
- 去掉本地名中所有的句点。

转换后得到了实际的邮件地址。

为了计算不同地址的数目，我们可以用一个哈希表记录所有的邮件地址，答案为哈希表的长度。

```Python [sol1-Python3]
class Solution:
    def numUniqueEmails(self, emails: List[str]) -> int:
        emailSet = set()
        for email in emails:
            i = email.index('@')
            local = email[:i].split('+', 1)[0]  # 去掉本地名第一个加号之后的部分
            local = local.replace('.', '')  # 去掉本地名中所有的句点
            emailSet.add(local + email[i:])
        return len(emailSet)
```

```C++ [sol1-C++]
class Solution {
public:
    int numUniqueEmails(vector<string> &emails) {
        unordered_set<string> emailSet;
        for (auto &email: emails) {
            string local;
            for (char c: email) {
                if (c == '+' || c == '@') {
                    break;
                }
                if (c != '.') {
                    local += c;
                }
            }
            emailSet.emplace(local + email.substr(email.find('@')));
        }
        return emailSet.size();
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numUniqueEmails(String[] emails) {
        Set<String> emailSet = new HashSet<String>();
        for (String email : emails) {
            int i = email.indexOf('@');
            String local = email.substring(0, i).split("\\+")[0]; // 去掉本地名第一个加号之后的部分
            local = local.replace(".", ""); // 去掉本地名中所有的句点
            emailSet.add(local + email.substring(i));
        }
        return emailSet.size();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumUniqueEmails(string[] emails) {
        ISet<string> emailSet = new HashSet<string>();
        foreach (string email in emails) {
            int i = email.IndexOf('@');
            string local = email.Substring(0, i).Split("+")[0]; // 去掉本地名第一个加号之后的部分
            local = local.Replace(".", ""); // 去掉本地名中所有的句点
            emailSet.Add(local + email.Substring(i));
        }
        return emailSet.Count;
    }
}
```

```go [sol1-Golang]
func numUniqueEmails(emails []string) int {
    emailSet := map[string]struct{}{}
    for _, email := range emails {
        i := strings.IndexByte(email, '@')
        local := strings.SplitN(email[:i], "+", 2)[0] // 去掉本地名第一个加号之后的部分
        local = strings.ReplaceAll(local, ".", "")    // 去掉本地名中所有的句点
        emailSet[local+email[i:]] = struct{}{}
    }
    return len(emailSet)
}
```

```C [sol1-C]
typedef struct {
    char *key;
    UT_hash_handle hh;
} HashItem;

int numUniqueEmails(char ** emails, int emailsSize) {
    HashItem *emailSet = NULL;
    for (int i = 0; i < emailsSize; i++) {
        char local[101];
        int pos = 0;
        for (int j = 0; emails[i][j] != 0; j++) {
            if (emails[i][j] == '+' || emails[i][j] == '@') {
                break;
            }
            if (emails[i][j] != '.') {
                local[pos++] = emails[i][j];
            }
        }
        sprintf(local + pos, "%s", strchr(emails[i], '@'));
        HashItem *pEntry = NULL;
        HASH_FIND_STR(emailSet, local, pEntry);
        if (NULL == pEntry) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = (char *)malloc(sizeof(char) * (strlen(local) + 1));
            strcpy(pEntry->key, local);
            HASH_ADD_STR(emailSet, key, pEntry);
        }
    }
    return HASH_COUNT(emailSet);
}
```

```JavaScript [sol1-JavaScript]
var numUniqueEmails = function(emails) {
    const emailSet = new Set();
    for (const email of emails) {
        const i = email.indexOf('@');
        let local = email.slice(0, i).split("+")[0]; // 去掉本地名第一个加号之后的部分
        local = local.replaceAll(".", ""); // 去掉本地名中所有的句点
        emailSet.add(local + email.slice(i));
    }
    return emailSet.size;
};
```

**复杂度分析**

- 时间复杂度：$O(L)$，其中 $L$ 是 $\textit{emails}$ 中字符串的长度之和。

- 空间复杂度：$O(L)$。哈希表需要 $O(L)$ 的空间。