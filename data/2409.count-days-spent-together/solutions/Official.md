#### 方法一：分别计算出每个日子是一年中的第几天后求差

**思路**

我们可以设计一个函数 $\textit{calculateDayOfYear}$ 来计算输入中的每个日子在一年中是第几天。计算输入中的每个日子在一年中是第几天时，可以利用前缀和数组来降低每次计算的复杂度。知道每个日子是一年中的第几天后，可以先通过比较算出两人到达日子的最大值，离开日子的最小值，然后利用减法计算重合的日子。

**代码**

```Python [sol1-Python3]
class Solution:
    def countDaysTogether(self, arriveAlice: str, leaveAlice: str, arriveBob: str, leaveBob: str) -> int:
        datesOfMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        prefixSum = [0]
        for date in datesOfMonths:
            prefixSum.append(prefixSum[-1] + date)

        arriveAliceDay = self.calculateDayOfYear(arriveAlice, prefixSum)
        leaveAliceDay = self.calculateDayOfYear(leaveAlice, prefixSum)
        arriveBobDay = self.calculateDayOfYear(arriveBob, prefixSum)
        leaveBobDay = self.calculateDayOfYear(leaveBob, prefixSum)
        return max(0, min(leaveAliceDay, leaveBobDay) - max(arriveAliceDay, arriveBobDay) + 1)

    def calculateDayOfYear(self, day: str, prefixSum: List[int]) -> int:
        month = int(day[:2])
        date = int(day[3:])
        return prefixSum[month - 1] + date
```

```C++ [sol1-C++]
class Solution {
public:
    int countDaysTogether(string arriveAlice, string leaveAlice, string arriveBob, string leaveBob) {
        vector<int> datesOfMonths = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        vector<int> prefixSum(1, 0);
        for (int date : datesOfMonths) {
            prefixSum.emplace_back(prefixSum.back() + date);
        }

        int arriveAliceDay = calculateDayOfYear(arriveAlice, prefixSum);
        int leaveAliceDay = calculateDayOfYear(leaveAlice, prefixSum);
        int arriveBobDay = calculateDayOfYear(arriveBob, prefixSum);
        int leaveBobDay = calculateDayOfYear(leaveBob, prefixSum);
        return max(0, min(leaveAliceDay, leaveBobDay) - max(arriveAliceDay, arriveBobDay) + 1);
    }

    int calculateDayOfYear(string day, const vector<int> &prefixSum) {
        int month = stoi(day.substr(0, 2));
        int date = stoi(day.substr(3));
        return prefixSum[month - 1] + date;
    }
};       
```

```Java [sol1-Java]
class Solution {
    public int countDaysTogether(String arriveAlice, String leaveAlice, String arriveBob, String leaveBob) {
        int[] datesOfMonths = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int[] prefixSum = new int[13];
        for (int i = 0; i < 12; i++) {
            prefixSum[i + 1] = prefixSum[i] + datesOfMonths[i];
        }

        int arriveAliceDay = calculateDayOfYear(arriveAlice, prefixSum);
        int leaveAliceDay = calculateDayOfYear(leaveAlice, prefixSum);
        int arriveBobDay = calculateDayOfYear(arriveBob, prefixSum);
        int leaveBobDay = calculateDayOfYear(leaveBob, prefixSum);
        return Math.max(0, Math.min(leaveAliceDay, leaveBobDay) - Math.max(arriveAliceDay, arriveBobDay) + 1);
    }

    public int calculateDayOfYear(String day, int[] prefixSum) {
        int month = Integer.parseInt(day.substring(0, 2));
        int date = Integer.parseInt(day.substring(3));
        return prefixSum[month - 1] + date;
    }
}
```

```Go [sol1-Go]
func countDaysTogether(arriveAlice string, leaveAlice string, arriveBob string, leaveBob string) int {
    datesOfMonths := []int{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    prefixSum := make([]int, 1)
    for _, date := range datesOfMonths {
        prefixSum = append(prefixSum, prefixSum[len(prefixSum) - 1] + date)
    }

    arriveAliceDay := calculateDayOfYear(arriveAlice, prefixSum)
    leaveAliceDay := calculateDayOfYear(leaveAlice, prefixSum)
    arriveBobDay := calculateDayOfYear(arriveBob, prefixSum)
    leaveBobDay := calculateDayOfYear(leaveBob, prefixSum)

    return max(0, min(leaveAliceDay, leaveBobDay) - max(arriveAliceDay, arriveBobDay) + 1)
}

func calculateDayOfYear(day string, prefixSum []int) int {
    month, _ := strconv.Atoi(day[:2])
    date, _ := strconv.Atoi(day[3:])
    return prefixSum[month - 1] + date
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var countDaysTogether = function(arriveAlice, leaveAlice, arriveBob, leaveBob) {
    let datesOfMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    let prefixSum = [0];
    for (let i = 0; i < datesOfMonths.length; i++) {
        prefixSum.push(prefixSum[i] + datesOfMonths[i]);
    }

    let arriveAliceDay = calculateDayOfYear(arriveAlice, prefixSum);
    let leaveAliceDay = calculateDayOfYear(leaveAlice, prefixSum);
    let arriveBobDay = calculateDayOfYear(arriveBob, prefixSum);
    let leaveBobDay = calculateDayOfYear(leaveBob, prefixSum);

    return Math.max(0, Math.min(leaveAliceDay, leaveBobDay) - Math.max(arriveAliceDay, arriveBobDay) + 1);
};

function calculateDayOfYear(day, prefixSum) {
    let month = parseInt(day.substring(0, 2));
    let date = parseInt(day.substring(3));
    return prefixSum[month - 1] + date;
}
```

```C# [sol1-C#]
public class Solution {
    public int CountDaysTogether(string arriveAlice, string leaveAlice, string arriveBob, string leaveBob) {
        int[] datesOfMonths = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int[] prefixSum = new int[13];
        for (int i = 0; i < 12; i++) {
            prefixSum[i + 1] = prefixSum[i] + datesOfMonths[i];
        }

        int arriveAliceDay = CalculateDayOfYear(arriveAlice, prefixSum);
        int leaveAliceDay = CalculateDayOfYear(leaveAlice, prefixSum);
        int arriveBobDay = CalculateDayOfYear(arriveBob, prefixSum);
        int leaveBobDay = CalculateDayOfYear(leaveBob, prefixSum);
        return Math.Max(0, Math.Min(leaveAliceDay, leaveBobDay) - Math.Max(arriveAliceDay, arriveBobDay) + 1);
    }

    public int CalculateDayOfYear(string day, int[] prefixSum) {
        int month = int.Parse(day.Substring(0, 2));
        int date = int.Parse(day.Substring(3));
        return prefixSum[month - 1] + date;
    }
}
```

```C [sol1-C]
static int min(int a, int b) {
    return a < b ? a : b;
}

static int max(int a, int b) {
    return a > b ? a : b;
}

static int calculateDayOfYear(const char *day, const int *prefixSum) {
    int month = (day[0] - '0') * 10 + day[1] - '0';
    int date = (day[3] - '0') * 10 + day[4] - '0';
    return prefixSum[month - 1] + date;
}

int countDaysTogether(char * arriveAlice, char * leaveAlice, char * arriveBob, char * leaveBob){
    int datesOfMonths[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int prefixSum[13];
    prefixSum[0] = 0;
    for (int i = 0; i < 12; i++) {
        prefixSum[i + 1] = prefixSum[i] + datesOfMonths[i];
    }
    int arriveAliceDay = calculateDayOfYear(arriveAlice, prefixSum);
    int leaveAliceDay = calculateDayOfYear(leaveAlice, prefixSum);
    int arriveBobDay = calculateDayOfYear(arriveBob, prefixSum);
    int leaveBobDay = calculateDayOfYear(leaveBob, prefixSum);
    return max(0, min(leaveAliceDay, leaveBobDay) - max(arriveAliceDay, arriveBobDay) + 1);
}
```

**复杂度分析**

- 时间复杂度：$O(1)$，最耗时的操作是计算前缀和，因为一年中只有 $12$ 个月，因此时间复杂度是常数。

- 空间复杂度：$O(1)$，最消耗空间的是存储每个月日子的数组和它的前缀和数组，因为一年中只有 $12$ 个月，因此空间复杂度是常数。