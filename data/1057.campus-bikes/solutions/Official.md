## 解决方案

___

#### 概述

我们有 $n$ 个工人和 $m$ 辆自行车。我们需要为每个工人分配一辆自行车，因为 $m\geq n$ 总是可以做到的。我们被指示按以下参数的升序进行上述赋值：

1.  曼哈顿距离
2.  工人下标
3.  自行车下标

首先，我们将检查每个工人和每辆自行车之间的曼哈顿距离，并对曼哈顿距离较小的 `(worker, bike)` 对进行优先排序。如果多个对的距离相同，我们将继续检查工人下标，并优先选择工人指数较小的对。如果工人下标也相同，我们会优先考虑自行车指数较低的配对。两个 `(worker, bike)` 不可能具有全部三个属性，因此这三个属性足以确保唯一的解决方案。因此，问题归根结底是按照上面解释的顺序对 `(worker, bike)` 进行排序，同时跟踪分配给哪些工人和自行车。

___

#### 方法 1: 排序

**概述**

如前所述，我们希望按升序组织 `(worker, bike)` 对，按其曼哈顿距离、工人下标和自行车下标的优先顺序排列。因此，我们将生成所有可能的 `(worker, bike)` 对，并根据前面列出的优先级对它们进行排序。然后，如果工人和自行车都可用，我们将迭代这些对，将自行车分配给工人，并将它们都标记为不可用。我们将重复这一过程，直到所有工人都分配了一辆自行车。

**算法**

1.  生成所有(工人、自行车)对，并为每对找到曼哈顿距离。将这三个属性存储在元组中为 `{distance, worker index, bike index}`。在 Java 中，我们使用定义的类型 `WorkerBikePair` 来存储这三个属性。
    
2.  将生成的所有三元组存储在 `allTriplets` 中，即元组列表(如果是 Java，则存储为 `WorkerBikePair`)。
    
3.  按距离、工人下标和自行车下标的升序对列表 `allTriplets` 进行排序。在 C++  Python 中我们可以存储为元组 `distance, worker index, bike index`。而在 Java 中，我们将显式定义自定义比较器 `WorkerBikePairCotator` 来进行相应的排序。
    
4.  迭代列表 `allTriplets`, 并且对于每一个三元组:
    
    -   如果工作者没有分配自行车(`workerStatus[workerIndex]` 为 `-1`)，且自行车仍可用(`bikeStatus[bike]` 为 `false`)。然后将自行车分配给工人，并将它们都标记为不可用。增加变量 `pairCount` 中的配对数量。
    -   如果所有的工作者都分配了一辆自行车(`pairCount` 等于工作者的数量)，我们就可以停止迭代这些自行车对了。
5.  返回 `workerStatus`.
    

**实现**

```C++ [slu1]
class Solution {
public:
    // 返回曼哈顿距离的函数
    int findDistance(vector<int>& worker, vector<int>& bike) {
        return abs(worker[0] - bike[0]) + abs(worker[1] - bike[1]);
    }
    
    vector<int> assignBikes(vector<vector<int>>& workers, vector<vector<int>>& bikes) {
        // 存储所有可能的三元组的 WorkerBikeTuples 的列表
        vector<tuple<int, int, int>> allTriplets;
        
        // 生成所有可能的对
        for (int worker = 0; worker < workers.size(); worker++) {
            for (int bike = 0; bike < bikes.size(); bike++) {
                int distance = findDistance(workers[worker], bikes[bike]);        
                allTriplets.push_back({distance, worker, bike});
            }
        }
        
        // 对所有三元组排序。默认每次排序优先级
        // 先按元组的第一个元素，接着是第二个，最后是第三个。
        sort(allTriplets.begin(), allTriplets.end());  
        
        // 将所有值初始化为 False，以表示没有取走自行车
        vector<int> bikeStatus(bikes.size(), false);
        // 将所有索引初始化为 -1，表示没有工人拥有自行车
        vector<int> workerStatus(workers.size(), -1);
        // 记录已经产生了多少工人、自行车对
        int pairCount = 0;
        
        for (auto[dist, worker, bike] : allTriplets) { 
            // 如果工人和自行车都是空闲的，就把它们分配给对方
            if (workerStatus[worker] == -1 && !bikeStatus[bike]) {
                bikeStatus[bike] = true;
                workerStatus[worker] = bike;
                pairCount++;
                
                // 如果所有的工人都分配了自行车，我们就可以停下来
                if (pairCount == workers.size()) {
                    return workerStatus;
                }
            }
        }
        
        return workerStatus;
    }
};
```

```Java [slu1]
class Solution {
     // 存储(worker, bike, distance)的类
    class WorkerBikePair {
        int workerIndex;
        int bikeIndex;
        int distance;   
        
        // 初始化成员变量的构造函数
        WorkerBikePair(int workerIndex, int bikeIndex, int distance) {
            this.workerIndex = workerIndex;
            this.bikeIndex = bikeIndex;
            this.distance = distance;
        }
    }
    
    // 自定义排序器
    Comparator<WorkerBikePair> WorkerBikePairComparator
        = new Comparator<WorkerBikePair>() {
        @Override
        public int compare(WorkerBikePair a, WorkerBikePair b) {
            if (a.distance != b.distance) {
                // 优先选择距离较短的那个
                return a.distance - b.distance;
            } else if (a.workerIndex != b.workerIndex) {
                // 优先根据工人下标
                return a.workerIndex - b.workerIndex;
            } else {
                // 优先根据自行车下标
                return a.bikeIndex - b.bikeIndex;
            }
        }
    };
    
    // 返回曼哈顿距离的函数
    int findDistance(int[] worker, int[] bike) {
        return Math.abs(worker[0] - bike[0]) + Math.abs(worker[1] - bike[1]);
    }
    
    public int[] assignBikes(int[][] workers, int[][] bikes) {
        // 存储所有可能的配对的 WorkerBikePair 列表
        List<WorkerBikePair> allTriplets = new ArrayList<>();
        
        // 生成所有可能的对
        for (int worker = 0; worker < workers.length; worker++) {
            for (int bike = 0; bike < bikes.length; bike++) {
                int distance = findDistance(workers[worker], bikes[bike]);        
                WorkerBikePair workerBikePair 
                    = new WorkerBikePair(worker, bike, distance);
                allTriplets.add(workerBikePair);
            }
        }
        
        // 根据自定义比较器 'WorkerBikePairCompator' 对三元组进行排序
        Collections.sort(allTriplets, WorkerBikePairComparator);  
        
        // 将所有值初始化为 False，以表示没有取走自行车
        boolean bikeStatus[] = new boolean[bikes.length];
        // 将所有索引初始化为 -1，以标记所有工人都可用
        int workerStatus[] = new int[workers.length];
        Arrays.fill(workerStatus, -1);
        // 记录已经产生了多少工人、自行车对
        int pairCount = 0;
        
        for (WorkerBikePair triplet : allTriplets) {
            int worker = triplet.workerIndex;
            int bike = triplet.bikeIndex;
            
            // 如果工人和自行车都是空闲的，就把它们分配给对方
            if (workerStatus[worker] == -1 && !bikeStatus[bike]) {
                bikeStatus[bike] = true;
                workerStatus[worker] = bike;
                pairCount++;
                
                // 如果所有的工人都分配了自行车，我们就可以停下来
                if (pairCount == workers.length) {
                    return workerStatus;
                }
            }
        }
        
        return workerStatus;
    }
}
```

```Python3 [slu1]
class Solution:
    def assignBikes(self, workers: List[List[int]], bikes: List[List[int]]) -> List[int]:
        
        def find_distance(worker_loc, bike_loc):
            return abs(worker_loc[0] - bike_loc[0]) + abs(worker_loc[1] - bike_loc[1])
        
        # 计算每个工人和自行车之间的距离。
        all_triplets = []
        for worker, worker_loc in enumerate(workers):
            for bike, bike_loc in enumerate(bikes):
                distance = find_distance(worker_loc, bike_loc)
                all_triplets.append((distance, worker, bike))
        
        # 对所有三元组排序。默认每次排序优先级
        # 先按元组的第一个元素，接着是第二个，最后是第三个。
        all_triplets.sort()
        
        # 将所有值初始化为 False，以表示没有取走自行车
        bike_status = [False] * len(bikes)
        # 将所有值初始化为 -1，以表示没有工人拥有自行车
        worker_status = [-1] * len(workers)
        # 记录已经产生了多少工人、自行车对
        pair_count = 0
        
        for distance, worker, bike in all_triplets:
            # 如果工人和自行车都是空闲的，就把它们分配给对方
            # 并标记自行车已被取走
            if worker_status[worker] == -1 and not bike_status[bike]:
                bike_status[bike] = True
                worker_status[worker] = bike
                pair_count += 1
                
                # 如果所有的工人都分配了自行车，我们就可以停下来
                if pair_count == len(workers):
                    return worker_status
        
        return worker_status
```

**复杂度分析**

在这里，$N$ 是工人数量，$M$ 是自行车数量。

-   时间复杂度：$O(NM \log (NM))$
    
    总共将有 $NM$ 个 `(worker, bike)` 对。对 $NM$ 元素列表进行排序将花费 $O(NM \log(NM))$ 时间。在最坏的情况下，我们必须遍历所有的自行车对，为每个工人分配一辆自行车。因此，迭代遍历这些对需要 $O(NM)$ 时间。由于排序的时间复杂度占主导地位，因此时间复杂度为$O(NM\log(NM))$。
    
-   空间复杂度：$O(NM)$
    
    `WorkerBikePair` 或元组有三个变量，因此占用 $O(1)$ 空间。存储 $NM$ 个`WorkerBikePairs` 或 `allTriplets` 中的元组将花费 $O(NM)$ 空间。为了跟踪自行车的可用性，`bikeStatus` 占用 $O(M)$ 空间。将工人下标对应的自行车索引存储在 `workerStatus` 中需要 $O(N)$ 空间。
    
    排序算法的空间复杂度取决于每种编程语言的实现。例如，在 Java 中，用于原语的Arrays.Sort() 被实现为快速排序算法的变体，其空间复杂度为 $O(\log NM)。在 C++ 中，stl 提供的 sort() 函数是快速排序、堆排序和插入排序的混合体，最坏情况下的空间复杂度为 $O(\log NM)$。在 Python 中，sort() 函数使用 TimSort，其最坏情况的空间复杂度为 $O(NM)$。因此，使用内置的 sort() 函数可能会增加 $O(NM)$ 的空间复杂度。
    
    所需的总空间为 $(NM+N+M+NM)$，因此，复杂度等于 $O(NM)$。

___

#### 方法 2: 桶排序

**概述**

正如问题描述中所述，最多可以有 `1000` 名工人和最多 `1000` 辆自行车，这意味着我们可能会有 $10^6$ 对 `(worker, bike)`。如果我们仔细观察问题约束，自行车和工人的坐标都在 `[0,1000)` 范围内。因此，一个工人和一辆自行车之间可能的最大曼哈顿距离是 `1998`。当其中一个自行车/工作者处于 `(0，0)`，而另一个实体工作者/自行车处于 `(999,999)` 时，该最大值是可能的。

如前所述，我们希望 `(worker, bike)` 对按其距离的升序排列，而距离可以在 `[0,1998]` 的范围内。记住，当我们的输入分布在一个已知的 **短** 范围内时，我们可以使用桶排序。在桶排序中，我们将元素分配到一个桶数组中，然后分别对每个桶进行排序。因此，我们可以按距离对配对进行分组，然后分别对每组进行排序，而不是对大量配对进行排序。因此，以升序迭代桶，并且对于每个桶，迭代排序的内容将等价于迭代所有对的排序列表。

除了实现桶排序之外，此方法与前面的方法相同。我们仍将对所有对进行排序，但这一次我们将首先按它们的距离对它们进行分组，然后分别对每组进行排序。然后，为了按升序排列对，我们只需按升序迭代可能的距离。

**注**：我们的目标是先按距离排序，然后是工人下标，然后是自行车下标。通过按距离对对进行分组，我们可以按距离的升序遍历对组。在存储桶排序中，我们的下一步通常是对每个存储桶进行排序，以确保 `{worker index, bike index}` 对在每个存储桶中按升序排列。然而，在创建这些对时，我们以升序迭代工人下标，然后以升序迭代自行车下标。因此，可以保证每个桶中的配对已经处于升序！因此，不需要对每个桶进行分类。

**算法**

1.  生成所有 `(worker, bike)` 对，并找到每一对的曼哈顿距离 `distance`。将此对添加到索引 `distance` 对应的 `disToPairs` 列表中。
2.  在生成的所有对中，将最小距离存储在变量 `minDis` 中。
3.  将 `currDis` 初始化为 `minDis`。在为所有工人分配自行车之前，请执行以下操作：
    -   迭代距离为 `currDis` 的对
    -   如果工人和自行车都可用，则将自行车分配给 `workerStatus` 列表中的工人，并在 `bikeStatus` 中标记为不可用。递增 `pairCount` 的值，它是已经制造的工人-自行车对的值。
    -   遍历完当前距离的所有对后，递增 `currDis` 的值。
4.  返回 `workerStatus`。

**实现**

```C++ [slu2]
class Solution {
public:
    // 返回曼哈顿距离的函数
    int findDistance(vector<int>& worker, vector<int>& bike) {
        return abs(worker[0] - bike[0]) + abs(worker[1] - bike[1]);
    }
    
    vector<int> assignBikes(vector<vector<int>>& workers, vector<vector<int>>& bikes) {
        int minDis = INT_MAX;
        // 存储对应距离的 (worker, bike) 对列表
        vector<pair<int, int>> disToPairs[1999];
        
        // 添加与其距离列表对应的(worker, bike)对
        for (int worker = 0; worker < workers.size(); worker++) {
            for (int bike = 0; bike < bikes.size(); bike++) {
                int distance = findDistance(workers[worker], bikes[bike]);
                disToPairs[distance].push_back({worker, bike});
                minDis = min(minDis, distance);
            }
        }
        
        int currDis = minDis;
        // 将所有值初始化为 false，以表示没有取走自行车
        vector<int> bikeStatus(bikes.size(), false);
        // 将所有索引初始化为 -1，表示没有工人拥有自行车
        vector<int> workerStatus(workers.size(), -1);
        // 维护产生了多少工人-自行车对
        int pairCount = 0;
        
        // 直到给所有工人分配一辆自行车
        while (pairCount != workers.size()) {
            for (auto[worker, bike] : disToPairs[currDis]) {
                if (workerStatus[worker] == -1 && !bikeStatus[bike]) {
                    // 如果工人和自行车都是空闲的，就把它们分配给对方
                    bikeStatus[bike] = true;
                    workerStatus[worker] = bike;
                    pairCount++;
                }
            }
            currDis++;
        }
        
        return workerStatus;
    }
};
```

```Java [slu2]
class Solution {
    // 返回曼哈顿距离的函数
    int findDistance(int[] worker, int[] bike) {
        return Math.abs(worker[0] - bike[0]) + Math.abs(worker[1] - bike[1]);
    }

    public int[] assignBikes(int[][] workers, int[][] bikes) {
        int minDis = Integer.MAX_VALUE;
        // 存储与其距离对应的 (worker, bike) 对列表
        Map<Integer, List<Pair<Integer, Integer>>> disToPairs = new HashMap();
        
        // 添加与其距离列表对应的 (worker, bike) 对
        for (int worker = 0; worker < workers.length; worker++) {
            for (int bike = 0; bike < bikes.length; bike++) {
                int distance = findDistance(workers[worker], bikes[bike]);
                
                disToPairs.putIfAbsent(distance, new ArrayList<>());
                
                disToPairs.get(distance).add(new Pair(worker, bike));
                minDis = Math.min(minDis, distance);
            }
        }
        
        int currDis = minDis;
        // 将所有值初始化为 false，以表示没有取走自行车
        boolean bikeStatus[] = new boolean[bikes.length];

        int workerStatus[] = new int[workers.length];
        // 将所有索引初始化为 -1，以标记所有可用工人
        Arrays.fill(workerStatus, -1);
        // 记录已经产生了多少工人-自行车对
        int pairCount = 0;
        
        // 直到给所有工人分配一辆自行车
        while (pairCount != workers.length) {
             if (!disToPairs.containsKey(currDis)) {
                 currDis++;
                 continue;
             }
            
            for (Pair<Integer, Integer> pair : disToPairs.get(currDis)) {
                int worker = pair.getKey();
                int bike = pair.getValue();

                if (workerStatus[worker] == -1 && !bikeStatus[bike]) {
                    // 如果工人和自行车都是空闲的，就把它们分配给对方
                    bikeStatus[bike] = true;
                    workerStatus[worker] = bike;
                    pairCount++;
                }
            }
            currDis++;
        }
        
        return workerStatus;
    }
}
```

```Python3 [slu2]
class Solution:
    def assignBikes(self, workers: List[List[int]], bikes: List[List[int]]) -> List[int]:
        
        def find_distance(worker_loc, bike_loc):
            return abs(worker_loc[0] - bike_loc[0]) + abs(worker_loc[1] - bike_loc[1])
        
        min_dist = float('inf')
        dist_to_pairs = collections.defaultdict(list)
        
        for worker, worker_loc in enumerate(workers):
            for bike, bike_loc in enumerate(bikes):
                distance = find_distance(worker_loc, bike_loc)
                dist_to_pairs[distance].append((worker, bike))
                min_dist = min(min_dist, distance)
                
        curr_dist = min_dist
        # 将所有值初始化为 false，以表示没有取走自行车
        bike_status = [False] * len(bikes)
        # 将所有值初始化为 -1，以表示没有工人拥有自行车
        worker_status = [-1] * len(workers)
        # 记录已经产生了多少工人自行车对
        pair_count = 0
        
        # 直到所有的工人都分配了自行车
        while pair_count < len(workers):
            for worker, bike in dist_to_pairs[curr_dist]:
                if worker_status[worker] == -1 and not bike_status[bike]:
                    # 如果工人和自行车都是空闲的，就把它们分配给对方
                    bike_status[bike] = True
                    worker_status[worker] = bike
                    pair_count += 1
            curr_dist += 1
        
        return worker_status
```

**复杂度分析**

这里，$N$ 是工人的数量，$M$ 是自行车的数量，$K$ 是工人/自行车对的最大可能曼哈顿距离。在这个问题中，$K$ 等于 $1998$。

-   时间复杂度：$O(NM + K)$
    
    生成所有 `(worker,bike)` 对需要 $O(NM)$ 时间。我们根据它们的距离迭代在 while 循环中生成的对。因此，至多，我们将迭代所有 $NM$ 对。但是，由于可能存在一些不存在对的 `currDis` 值，因此这些操作也必须被计算在内。`currDis` 的总可能值为 $K$。因此，时间复杂度等于 $O(NM+K)$
    
-   空间复杂度：$O(NM + K)$
    
    我们将所有与其距离对应的对存储在 `disToPairs` 中，这需要 $O(NM)$ 空间。为了跟踪自行车的可用性，`bikeStatus` 占用 $O(M)$ 空间。将每个工人被分配的自行车的索引存储在 `workerStatus` 中需要 $O(N)$ 空间。另外，请注意，在 `C++` 实现中，我们定义了一个大小为 $K$ 的数组。因此，即使存在比 $K$ 对更少的对，也将花费 $O(K)$ 空间。

___

#### 方法 3: 优先队列

**概述**

如前所述，我们需要按升序排列 `(worker, bike)` 对。一种方法是将所有 $n \cdot m$ 个 `workerBikePair ({worker index, bike index, distance})` 放在一个小顶堆中，然后我们可以继续从堆中弹出以获取最短的曼哈顿距离对。这里的缺点是我们要从 $n \cdot m$ 个对中选择第一对。但是，我们可以丢弃某些对，而无需将它们插入到优先队列中。想一想第一个收到自行车的工人。我们不需要为这个工人推所有对应于所有自行车的对。相反，我们可以只放置与最近的自行车对应的一对自行车，因为其他对不能是具有最小曼哈顿距离的对。

在这种方法中，我们将为每个工作者找到最近的自行车，并将其对应的 `workerBikePair`(对于 C++，则为元组)放入优先队列中。因此，在任何给定时间，我们在优先队列中将最多有 $n$ 个元素，而不是 $n \cdot m$。这样，我们可以省略不是最短曼哈顿距离的潜在候选者的 `(worker, bike)` 对。

现在，在这些 $n$ 个元素(每个工人一个元素)中，具有最短曼哈顿距离的元素将位于顶部。因此，我们将弹出它，如果该元素中的自行车没有被取走，我们将把自行车分配给工人。如果我们弹出的自行车对中的自行车已经分配给不同的工人，我们将丢弃这对自行车，并将新的自行车对(即距离该工人最近的自行车)推入优先队列。这样，优先队列将始终具有每个剩余工作进程的最小距离对。我们将继续从优先队列中弹出，直到所有工人都被分配了一辆自行车。

基本上，我们根据曼哈顿距离为每位员工制作了一份自行车的分类清单。因此，我们已经为每 $n$ 个工人排序了大小为 $m$ 的列表。我们需要从这些 $n$ 个排序列表中的每一个精确地合并一个元素。因此，我们将把 $n$ 个列表中每一个的第一个元素插入到优先队列中，并弹出最小元素。如果弹出的自行车对中的自行车可用，则我们将其分配给该对中的工人。否则，我们将在排序列表中为弹出的对中的工人插入下一对。这非常类似于我们在合并两个排序列表时在合并排序中所做的操作。唯一的区别是我们有 $n$ 个列表，我们需要跟踪自行车的可用性。

下面的幻灯片演示了该算法：

<![image.png](https://pic.leetcode.cn/1692673582-lfOMZB-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673587-BWZvKj-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673589-jNDPDm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673592-dcglUE-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673595-MYMtRN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673598-uEAzmG-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673601-pRJzDK-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673610-PHGOvM-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673613-lLvJWF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673616-NgFPsx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673619-GWKpyJ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673622-bDoBDn-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673626-WNOWrC-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692673629-pUDtKp-image.png){:width=400}>

**算法**

**注意：** 由于 Java 中没有任何标准的 Tuple 库，所以我们有不同于 Java 的 C++ 和 Python 实现。因此，我们已经分别讨论了 C++/Python 和 Java 的算法。

**Java**

1.  迭代 workers 并且对于每一个 worker：
    -   找出每辆自行车的距离。将单车和距离信息按定义的类型 `WorkerBikePair` (`{distance, bike index}`)存储在 `currWorkerPairs` 列表中。
    -   使用自定义比较器 `WorkerBikePairComparator` 排序列表 `currWorkerPairs` 
    -   将与工人对应的上述列表存储为 `workerToBikeList[worker] = currWorkerPairs`
    -   在 `closestBikeIndex` 列表中，将该工人最接近的自行车下标设置为 `0`，即 `closestBikeIndex[worker]=0`。
    -   调用 `addClosestBikeToPq` 函数，在这个函数中我们要：
        -   给工人取一辆最近的自行车。最近的自行车下标出现在 `closestBikeIndex[worker]`。因此，最近的自行车对可以通过 `workerToBikeList[worker][closestBikeIndex[worker]]` 进行访问
        -   将上述 `WorkerBikePair` 插入优先队列 `pq`。
        -   递增 `closestBikeIndex[worker]` 的值。该值现在指向该工人的下一个最近的自行车。
2.  当优先级队列不为空时：
    -   从 `pq` 弹出顶部元素
    -   如果自行车可用，则将其分配给 `workerStatus` 列表中的工人，并在 `bikeStatus` 中标记为不可用。
    -   如果自行车不可用，则调用当前工人的 `addClosestBikeToPq`。
3.  返回 `workerStatus`。

**C++/Python**

1.  迭代 workers 并且对于每一个 worker：
    -   找出每辆自行车的距离。把自行车和距离信息存为元组 `{distance, worker index, bike index}` 在元组列表 `currWorkerPairs` 中。
    -   按降序对列表 `currWorkerPairs` 进行排序。我们以降序进行排序的原因是，具有最小值的`(worker, bike)`对(按距离的顺序，然后是 worker index，然后是 bike index)将出现在排序列表的末尾。因此，为员工获得下一个最近的自行车只需弹出排序列表中的最后一个元素。
    -   将与工人对应的上述列表存储为 `workerToBikeList[worker] = currWorkerPairs`
    -   为工人获取与最近的自行车对应的元组。最近的自行车出现在 `currWorkerPairs.back()`.
    -   将上述元组插入到优先队列 `pq` 中。
    -   弹出 `currWorkerPairs` 中的最后一个元素，以获得与该工人最近的下一个自行车。
2.  当优先级队列不为空时：
    -   从 `pq` 弹出顶部元素。
    -   如果自行车可用，则将其分配给 `workerStatus` 列表中的工人，并在 `bikeStatus` 中标记为不可用。
    -   如果自行车不可用，则将当前工人的下一个最近的自行车插入到 `pq` 中，并弹出当前工人排序列表中的最后一个元素。
3.  返回 `workerStatus`.

**实现**

```C++ [slu3]
class Solution {
public:
    // 返回曼哈顿距离的函数
    int distance(vector<int>& worker_loc, vector<int>& bike_loc) {
        return abs(worker_loc[0] - bike_loc[0]) + abs(worker_loc[1] - bike_loc[1]);
    }
    
    vector<int> assignBikes(vector<vector<int>>& workers, vector<vector<int>>& bikes) {
        // 对于与工人对应的每辆自行车三元组列表 (distance, worker, bike) 
        vector<vector<tuple<int, int, int>>> workerToBikeList;
        
        priority_queue<tuple<int, int, int>, vector<tuple<int, int, int>>, 
                       greater<tuple<int, int, int>>> pq;
        
        for (int worker = 0; worker < workers.size(); worker++) {
            // 添加所有自行车及其与当前工人的距离
            vector<tuple<int, int, int>> currWorkerPairs;
            for (int bike = 0; bike < bikes.size(); bike++) {
                int dist = distance(workers[worker], bikes[bike]);
                currWorkerPairs.push_back({dist, worker, bike});
            }
            
            // 以降序对当前工人的 workerToBikeList 进行排序。
            sort(currWorkerPairs.begin(), currWorkerPairs.end(), greater<tuple<int, int, int>>());

            // 对于每个员工，将他们最近的自行车添加到优先队列中
            pq.push(currWorkerPairs.back());
            // 倒数第二的自行车现在是这个工人最接近的自行车
            currWorkerPairs.pop_back();
            
            // 将当前工人的其余选项存储在 workerToBikeList 中
            workerToBikeList.push_back(currWorkerPairs);
        }
        
        // 把所有值初始化为 false 用来表示没有车被取走
        vector<int> bikeStatus(bikes.size(), false);
        // 将所有索引初始化为 -1，表示没有工人拥有自行车
        vector<int> workerStatus(workers.size(), -1);
        
        while (!pq.empty()) {
            // 把距离最小的对弹出
            auto[dist, worker, bike] = pq.top();
            pq.pop();
            bike = bike;
            worker = worker;
            
            if (!bikeStatus[bike]) {
                // 如果这辆自行车是空闲的，把它分配给工人
                bikeStatus[bike] = true;
                workerStatus[worker] = bike;
            } else {
                // 否则，为当前工人添加下一个最近的自行车
                pq.push(workerToBikeList[worker].back());
                workerToBikeList[worker].pop_back();
            }
        }
        
        return workerStatus;       
    }
};
```

```Java [slu3]
class Solution {
    // 对于和工人关联的每辆自行车 (distance, bike index) 对的列表
    List<List<Pair<Integer, Integer>>> workerToBikeList = new ArrayList<>();
    // 储存最近的 bike index，对应 worker index
    int closestBikeIndex[] = new int[1001];
    
    // 储存 (worker, bike, distance) 的类
    class WorkerBikePair {
        int workerIndex;
        int bikeIndex;
        int distance;   
        
        // 初始化成员变量的构造函数
        WorkerBikePair(int workerIndex, int bikeIndex, int distance) {
            this.workerIndex = workerIndex;
            this.bikeIndex = bikeIndex;
            this.distance = distance;
        }
    }
    
    // 用于比较优先队列中的 WorkerBikePair 的自定义比较器
    Comparator<WorkerBikePair> WorkerBikePairComparator 
        = new Comparator<WorkerBikePair>() {
        @Override
        public int compare(WorkerBikePair a, WorkerBikePair b) {
            if (a.distance != b.distance) {
                // 优先选择距离较短的那个
                return a.distance - b.distance;
            } else if (a.workerIndex != b.workerIndex) {
                // 优先根据 worker index
                return a.workerIndex - b.workerIndex;
            } else {
                // 优先根据 bike index
                return a.bikeIndex - b.bikeIndex;
            }
        }
    };

    // 返回曼哈顿距离的函数
    int findDistance(int[] worker, int[] bike) {
        return Math.abs(worker[0] - bike[0]) + Math.abs(worker[1] - bike[1]);
    }
    
    // 将离工人最近的自行车加入优先队列
    // 并且更新最近的自行车下标
    void addClosestBikeToPq(PriorityQueue<WorkerBikePair> pq, int worker) {
        Pair<Integer, Integer> closestBike = workerToBikeList.get(worker)
            .get(closestBikeIndex[worker]);
        closestBikeIndex[worker]++;
        
        WorkerBikePair workerBikePair 
            = new WorkerBikePair(worker, closestBike.getValue(), closestBike.getKey());
        pq.add(workerBikePair);
    }
    
    public int[] assignBikes(int[][] workers, int[][] bikes) {
        PriorityQueue<WorkerBikePair> pq = new PriorityQueue<>(WorkerBikePairComparator);
        
        // 添加所有自行车及其与工人的距离
        for (int worker = 0; worker < workers.length; worker++) {
            List<Pair<Integer, Integer>> bikeList = new ArrayList<>();
            for (int bike = 0; bike < bikes.length; bike++) {
                int distance = findDistance(workers[worker], bikes[bike]);
                bikeList.add(new Pair(distance, bike));
            }
            Collections.sort(bikeList, Comparator.comparing(Pair::getKey));
            
            // 将当前员工的所有自行车选项存储在 workerToBikeList 中
            workerToBikeList.add(bikeList);
            
             // 第一辆自行车是每个工人最接近的自行车
            closestBikeIndex[worker] = 0;
            
            // 对于每个工人，将他们最近的自行车添加到优先级队列中
            addClosestBikeToPq(pq, worker);    
        }
        
        // 把所有值初始化为 false 用来表示没有车被取走
        boolean bikeStatus[] = new boolean[bikes.length];
        
        // 将所有索引初始化为 -1，表示没有工人拥有自行车
        int workerStatus[] = new int[workers.length];
        Arrays.fill(workerStatus, -1);
        
        // 直到给所有工人分配一辆自行车
        while (!pq.isEmpty()) {
            // 弹出距离最小的对
            WorkerBikePair workerBikePair = pq.remove();
            
            int worker = workerBikePair.workerIndex;
            int bike = workerBikePair.bikeIndex;
            
            if (workerStatus[worker] == -1 && !bikeStatus[bike]) {
                // 如果工人和自行车都是空闲的，就把它们分配给对方
                bikeStatus[bike] = true;
                workerStatus[worker] = bike;
                
            } else {
                // 为当前员工添加下一个最近的自行车
                addClosestBikeToPq(pq, worker);
            }
        }
    
        return workerStatus;
    }
}
```

```Python3 [slu3]
class Solution:
    def assignBikes(self, workers: List[List[int]], bikes: List[List[int]]) -> List[int]:
        
        def find_distance(worker_loc, bike_loc):
            return abs(worker_loc[0] - bike_loc[0]) + abs(worker_loc[1] - bike_loc[1])
        
        # 对于每一个工人-自行车组合的三元组列表 (distance, worker index, bike index)
        worker_to_bike_list = []
        pq = []
        
        for worker, worker_loc in enumerate(workers):
            curr_worker_pairs = []
            for bike, bike_loc in enumerate(bikes):
                distance = find_distance(worker_loc, bike_loc)
                curr_worker_pairs.append((distance, worker, bike))
            
            # 按相反顺序对当前工人的 worker_to_bike_list 进行排序
            curr_worker_pairs.sort(reverse=True)
            # 将此工人最近的自行车添加到优先队列
            heapq.heappush(pq, curr_worker_pairs.pop())
            # 把当前工人其余的选项存储到 worker_to_bike_list
            worker_to_bike_list.append(curr_worker_pairs)
            
        # 将所有值初始化为 false，以表示没有取走自行车
        bike_status = [False] * len(bikes)
        # 将所有值初始化为 -1，以表示没有工人拥有自行车
        worker_status = [-1] * len(workers)
        
        while pq:
            # 弹出距离最小的工人自行车对
            distance, worker, bike = heapq.heappop(pq)
            
            if not bike_status[bike]:
                # 如果自行车是空闲的，就把自行车分配给工人
                bike_status[bike] = True
                worker_status[worker] = bike
            else:
                # 否则，将当前工人的下一个最近自行车添加到优先队列
                next_closest_bike = worker_to_bike_list[worker].pop()
                heapq.heappush(pq, next_closest_bike)
        
        return worker_status
```

**复杂度分析**

这里，$N$ 是工人的数量，$M$ 是自行车的数量

-   时间复杂度：$O(NM \log ⁡M)$
    
    我们迭代 $N$ 个工人并且对于每一个工人：
    
    -   对 $M$ 辆自行车的列表 `currWorkerPairs` 进行排序需要 $O(M \log M)$。
    -   把最近的自行车加入到 `pq`。插入 `pq` 需要 $O(\log N)$。
    
    因此，此时的时间复杂度为 $O(NM \log M)$。
    
    在最坏的情况下，while 循环中来自 `pq` 的 pop 操作总数可能是 $O(N^2)$。这是因为，对于第 `i` 个工人来说，他的第一辆 `i-1` 最近的自行车可能已经被以前的工人取走了。因此，第一个工人将得到他的第一个最近的自行车，第二个工人得到第二个最近的自行车，以此类推。这样，`pq` 中的 pop 操作次数将等于 `1 + 2 + 3 + 4 ...... N = (N * (N - 1)) / 2`。
    
    在每次 while 循环操作中，我们都会弹出并推入优先队列，该队列占用 $O(\log N)$ 时间。因此，这里的时间复杂度为 $O(N^2 \log⁡ N)$。
    
    因此，总的时间复杂度为 $O(NM \log ⁡M + N^2 \log ⁡N)$。由于我们知道，$M \geq N$，其复杂度可以写为 $O(NM \log ⁡M)$。
    
-   空间复杂度：$O(NM)$
    
    -   `workerToBikeList` 存储 $N$ 个中每个工人的 $M$ 辆自行车列表，因此它需要 $O(NM)$。
    -   `bikeStatus` 占用 $O(M)$ 空间。
    -   `workerStatus` 占用 $O(N)$ 空间。
    -   `pq` 将存储最多 $N$ 个元素。
    
    因此，总空间复杂度为 $O(NM)$。
    
      
    

___