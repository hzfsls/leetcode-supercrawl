#### 方法一：模拟

**思路**

可以分开考虑在比赛开始前，需要最少增加的精力和经验数量。

每次遇到一个对手，当前精力值都需要严格大于当前对手，否则需要增加精力值。因此，在击败最后一个对手后，剩余的精力值至少要为 $1$。记所有对手的精力和为 $\textit{sm}$，比赛开始前需要达到的最少精力即为 $\textit{sm} +1$ ，否则需要进行 $\textit{sm} +1 - \textit{initialEnergy}$ 小时的训练。

而对于经验，可以遍历一次 $\textit{initialExperience}$ 数组，如果当前经验值大于当前对手，则击败这个对手不需要进行训练；如果小于等于当前对手，则需要进行额外的训练，数量为差值 $+1$。然后需要当前的经验值。遍历完数组之后可以得到增加经验方面需要进行的额外小时数。

两者之和即为总的额外小时数。

**代码**

```Python [sol1-Python3]
class Solution:
    def minNumberOfHours(self, initialEnergy: int, initialExperience: int, energy: List[int], experience: List[int]) -> int:
        sm = sum(energy)
        trainingHours = 0 if initialEnergy > sm else sm + 1 - initialEnergy
        for e in experience:
            if initialExperience <= e:
                trainingHours += 1 + (e - initialExperience)
                initialExperience = 2 * e + 1
            else:
                initialExperience += e
        return trainingHours
```

```Java [sol1-Java]
class Solution {
    public int minNumberOfHours(int initialEnergy, int initialExperience, int[] energy, int[] experience) {
        int sum = 0;
        for (int e : energy) {
            sum += e;
        }
        int trainingHours = initialEnergy > sum ? 0 : sum + 1 - initialEnergy;
        for (int e : experience) {
            if (initialExperience <= e) {
                trainingHours += 1 + (e - initialExperience);
                initialExperience = 2 * e + 1;
            } else {
                initialExperience += e;
            }
        }
        return trainingHours;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinNumberOfHours(int initialEnergy, int initialExperience, int[] energy, int[] experience) {
        int sum = 0;
        foreach (int e in energy) {
            sum += e;
        }
        int trainingHours = initialEnergy > sum ? 0 : sum + 1 - initialEnergy;
        foreach (int e in experience) {
            if (initialExperience <= e) {
                trainingHours += 1 + (e - initialExperience);
                initialExperience = 2 * e + 1;
            } else {
                initialExperience += e;
            }
        }
        return trainingHours;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minNumberOfHours(int initialEnergy, int initialExperience, vector<int>& energy, vector<int>& experience) {
        int sum = 0;
        for (int e : energy) {
            sum += e;
        }
        int trainingHours = initialEnergy > sum ? 0 : sum + 1 - initialEnergy;
        for (int e : experience) {
            if (initialExperience <= e) {
                trainingHours += 1 + (e - initialExperience);
                initialExperience = 2 * e + 1;
            } else {
                initialExperience += e;
            }
        }
        return trainingHours;
    }
};
```

```C [sol1-C]
int minNumberOfHours(int initialEnergy, int initialExperience, int* energy, int energySize, int* experience, int experienceSize) {
    int sum = 0;
    for (int i = 0; i < energySize; i++) {
        sum += energy[i];
    }
    int trainingHours = initialEnergy > sum ? 0 : sum + 1 - initialEnergy;
    for (int i = 0; i < experienceSize; i++) {
        int e = experience[i];
        if (initialExperience <= e) {
            trainingHours += 1 + (e - initialExperience);
            initialExperience = 2 * e + 1;
        } else {
            initialExperience += e;
        }
    }
    return trainingHours;
}
```

```JavaScript [sol1-JavaScript]
var minNumberOfHours = function(initialEnergy, initialExperience, energy, experience) {
    let sum = 0;
    for (const e of energy) {
        sum += e;
    }
    let trainingHours = initialEnergy > sum ? 0 : sum + 1 - initialEnergy;
    for (const e of experience) {
        if (initialExperience <= e) {
            trainingHours += 1 + (e - initialExperience);
            initialExperience = 2 * e + 1;
        } else {
            initialExperience += e;
        }
    }
    return trainingHours;
};
```

```go [sol1-Golang]
func minNumberOfHours(initialEnergy int, initialExperience int, energy []int, experience []int) int {
    sum := 0
    for _, e := range energy {
        sum += e
    }
    trainingHours := 0
    if initialEnergy <= sum {
        trainingHours = sum + 1 - initialEnergy
    }
    for _, e := range experience {
        if initialExperience <= e {
            trainingHours += 1 + (e - initialExperience)
            initialExperience = 2*e + 1
        } else {
            initialExperience += e
        }
    }
    return trainingHours
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，需要遍历一遍 $\textit{energy}$ 和 $\textit{experience}$ 数组。

- 空间复杂度：$O(1)$，仅使用常数空间。