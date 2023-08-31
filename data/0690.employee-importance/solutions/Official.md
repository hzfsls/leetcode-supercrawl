## [690.员工的重要性 中文官方题解](https://leetcode.cn/problems/employee-importance/solutions/100000/yuan-gong-de-zhong-yao-xing-by-leetcode-h6xre)
#### 前言

由于一个员工最多有一个直系领导，可以有零个或若干个直系下属，因此员工之间的领导和下属关系构成树的结构。给定一个员工编号，要求计算这个员工及其所有下属的重要性之和，即为找到以该员工为根节点的子树的结构中，每个员工的重要性之和。

对于树结构的问题，可以使用深度优先搜索或广度优先搜索的方法解决。

#### 方法一：深度优先搜索

深度优先搜索的做法非常直观。根据给定的员工编号找到员工，从该员工开始遍历，对于每个员工，将其重要性加到总和中，然后对该员工的每个直系下属继续遍历，直到所有下属遍历完毕，此时的总和即为给定的员工及其所有下属的重要性之和。

实现方面，由于给定的是员工编号，且每个员工的编号都不相同，因此可以使用哈希表存储每个员工编号和对应的员工，即可通过员工编号得到对应的员工。

```Java [sol1-Java]
class Solution {
    Map<Integer, Employee> map = new HashMap<Integer, Employee>();

    public int getImportance(List<Employee> employees, int id) {
        for (Employee employee : employees) {
            map.put(employee.id, employee);
        }
        return dfs(id);
    }

    public int dfs(int id) {
        Employee employee = map.get(id);
        int total = employee.importance;
        List<Integer> subordinates = employee.subordinates;
        for (int subId : subordinates) {
            total += dfs(subId);
        }
        return total;
    }
}
```

```C# [sol1-C#]
class Solution {
    Dictionary<int, Employee> dictionary = new Dictionary<int, Employee>();

    public int GetImportance(IList<Employee> employees, int id) {
        foreach (Employee employee in employees) {
            dictionary.Add(employee.id, employee);
        }
        return DFS(id);
    }

    public int DFS(int id) {
        Employee employee = dictionary[id];
        int total = employee.importance;
        IList<int> subordinates = employee.subordinates;
        foreach (int subId in subordinates) {
            total += DFS(subId);
        }
        return total;
    }
}
```

```JavaScript [sol1-JavaScript]
var GetImportance = function(employees, id) {
    const map = new Map();
    for (const employee of employees) {
        map.set(employee.id, employee);
    }
    const dfs = (id) => {
        const employee = map.get(id);
        let total = employee.importance;
        const subordinates = employee.subordinates;
        for (const subId of subordinates) {
            total += dfs(subId);
        }
        return total;
        
    }

    return dfs(id);
};
```

```go [sol1-Golang]
func getImportance(employees []*Employee, id int) (total int) {
    mp := map[int]*Employee{}
    for _, employee := range employees {
        mp[employee.Id] = employee
    }

    var dfs func(int)
    dfs = func(id int) {
        employee := mp[id]
        total += employee.Importance
        for _, subId := range employee.Subordinates {
            dfs(subId)
        }
    }
    dfs(id)
    return
}
```

```C++ [sol1-C++]
class Solution {
public:
    unordered_map<int, Employee *> mp;

    int dfs(int id) {
        Employee *employee = mp[id];
        int total = employee->importance;
        for (int subId : employee->subordinates) {
            total += dfs(subId);
        }
        return total;
    }

    int getImportance(vector<Employee *> employees, int id) {
        for (auto &employee : employees) {
            mp[employee->id] = employee;
        }
        return dfs(id);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def getImportance(self, employees: List['Employee'], idx: int) -> int:
        mp = {employee.id: employee for employee in employees}

        def dfs(idx: int) -> int:
            employee = mp[idx]
            total = employee.importance + sum(dfs(subIdx) for subIdx in employee.subordinates)
            return total
        
        return dfs(idx)
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是员工数量。需要遍历所有员工，在哈希表中存储员工编号和员工的对应关系，深度优先搜索对每个员工遍历一次。

- 空间复杂度：$O(n)$，其中 $n$ 是员工数量。空间复杂度主要取决于哈希表的空间和递归调用栈的空间，哈希表的大小为 $n$，栈的深度不超过 $n$。

#### 方法二：广度优先搜索

也可以使用广度优先搜索的做法。

和深度优先搜索一样，使用哈希表存储每个员工编号和对应的员工，即可通过员工编号得到对应的员工。根据给定的员工编号找到员工，从该员工开始广度优先搜索，对于每个遍历到的员工，将其重要性加到总和中，最终得到的总和即为给定的员工及其所有下属的重要性之和。

```Java [sol2-Java]
class Solution {
    public int getImportance(List<Employee> employees, int id) {
        Map<Integer, Employee> map = new HashMap<Integer, Employee>();
        for (Employee employee : employees) {
            map.put(employee.id, employee);
        }
        int total = 0;
        Queue<Integer> queue = new LinkedList<Integer>();
        queue.offer(id);
        while (!queue.isEmpty()) {
            int curId = queue.poll();
            Employee employee = map.get(curId);
            total += employee.importance;
            List<Integer> subordinates = employee.subordinates;
            for (int subId : subordinates) {
                queue.offer(subId);
            }
        }
        return total;
    }
}
```

```C# [sol2-C#]
class Solution {
    public int GetImportance(IList<Employee> employees, int id) {
        Dictionary<int, Employee> dictionary = new Dictionary<int, Employee>();
        foreach (Employee employee in employees) {
            dictionary.Add(employee.id, employee);
        }
        int total = 0;
        Queue<int> queue = new Queue<int>();
        queue.Enqueue(id);
        while (queue.Count > 0) {
            int curId = queue.Dequeue();
            Employee employee = dictionary[curId];
            total += employee.importance;
            IList<int> subordinates = employee.subordinates;
            foreach (int subId in subordinates) {
                queue.Enqueue(subId);
            }
        }
        return total;
    }
}
```

```JavaScript [sol2-JavaScript]
var GetImportance = function(employees, id) {
    const map = new Map();
    for (const employee of employees) {
        map.set(employee.id, employee);
    }
    let total = 0;
    const queue = [];
    queue.push(id);
    while (queue.length) {
        const curId = queue.shift();
        const employee = map.get(curId);
        total += employee.importance;
        const subordinates = employee.subordinates;
        for (const subId of subordinates) {
            queue.push(subId);
        }
    }
    return total;
};
```

```go [sol2-Golang]
func getImportance(employees []*Employee, id int) (total int) {
    mp := map[int]*Employee{}
    for _, employee := range employees {
        mp[employee.Id] = employee
    }

    queue := []int{id}
    for len(queue) > 0 {
        employee := mp[queue[0]]
        queue = queue[1:]
        total += employee.Importance
        for _, subId := range employee.Subordinates {
            queue = append(queue, subId)
        }
    }
    return
}
```

```C++ [sol2-C++]
class Solution {
public:
    int getImportance(vector<Employee *> employees, int id) {
        unordered_map<int, Employee *> mp;
        for (auto &employee : employees) {
            mp[employee->id] = employee;
        }

        int total = 0;
        queue<int> que;
        que.push(id);
        while (!que.empty()) {
            int curId = que.front();
            que.pop();
            Employee *employee = mp[curId];
            total += employee->importance;
            for (int subId : employee->subordinates) {
                que.push(subId);
            }
        }
        return total;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def getImportance(self, employees: List['Employee'], idx: int) -> int:
        mp = {employee.id: employee for employee in employees}

        total = 0
        que = collections.deque([idx])
        while que:
            curIdx = que.popleft()
            employee = mp[curIdx]
            total += employee.importance
            for subIdx in employee.subordinates:
                que.append(subIdx)
        
        return total
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是员工数量。需要遍历所有员工，在哈希表中存储员工编号和员工的对应关系，广度优先搜索对每个员工遍历一次。

- 空间复杂度：$O(n)$，其中 $n$ 是员工数量。空间复杂度主要取决于哈希表的空间和队列的空间，哈希表的大小为 $n$，队列的大小不超过 $n$。