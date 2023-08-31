## [1166.设计文件系统 中文官方题解](https://leetcode.cn/problems/design-file-system/solutions/100000/she-ji-wen-jian-xi-tong-by-leetcode-solution)
[TOC]

## 解决方案

---

#### 方法 1：用哈希表来存储路径

 **前言**

 这种方法可以说是基于模拟的方式来解决这个问题。我们称之为基于模拟的方法是因为它不使用任何花哨的数据结构来存储路径，基本上，我们只是按照问题要求的方式执行两个函数。我们只需要一个键值数据结构，再加上一些附加的处理来验证是否将一条路径添加进来。自然而然，一个 `HashMap` 或者一个 `dictionary` 似乎是一个不错的数据结构。

 我们来看一个示例，通过这个例子我们可以看到当我们不断添加更多的路径到 HashMap 中时，HashMap 会变成什么样子。下面的示例展示了在添加了以下的路径后，文件系统的状态：`/a`，`/a/b`，`/a/b/c`和`/a/b/e`。

 ![image.png](https://pic.leetcode.cn/1692079378-nJMfKE-image.png){:width=600}

 *图1.包含文件系统中各种路径及其键的 HashMap.*

 检索对应于一个路径的值相对比较简单，因为该路径本身在 HashMap 中表示一个键。然而，对于添加一个新的路径，我们可以简单地获取 `parent path`（例如，`/a/b` 是 `/a/b/c` 的父路径，对 `/a/b/e` 同样处理）,然后检查父路径是否存在于字典中作为一个键。

 **算法**

 1. 初始化一个名为 `paths` 的字典或 `HashMap`，这个字典的键和值分别是我们 `create` 函数的输入 `path` 和对应的 `value`。
 2. 对于我们的 `create` 函数，我们需要完成以下三个步骤：
    1. 第一步是我们需要对路径进行基本的验证，判断它是否有效。这里我们检查路径是否为空，或者是否为 `"/"`，或者路径是否已经存在于我们的字典中。如果满足这些条件之一，我们就直接返回`false`。  
    2. 第二步是获取给定 `path` 的父路径，并检查它是否存在于字典中。如果父路径不存在，那么我们就直接返回 `false`。否则，我们继续进行下一步。
    > 注意，仅需检查父路径是否存在就足够了，因为父路径的存在就确保了祖父路径（以及其他祖先，由此推理）也一定存在于字典中。
    3. 最后，我们将提供的 `path` 和 `value` 插入到字典中，然后返回 `true`。
 3. 对于 `get` 函数，如果 `path` 不存在于字典中，则我们简单地返回 `-1` 作为默认值。否则，我们返回实际的值。

 ```Java [slu1]
 class FileSystem {

    HashMap<String, Integer> paths;
    
    public FileSystem() {
        this.paths = new HashMap<String, Integer>();
    }
    
    public boolean createPath(String path, int value) {
        
        // 第 1 步：基本路径验证
        if (path.isEmpty() || (path.length() == 1 && path.equals("/")) || this.paths.containsKey(path)) {
            return false;
        }
        
        int delimIndex = path.lastIndexOf("/");
        String parent = path.substring(0, delimIndex);
        
        // 第 2 步：如果父对象不存在。请注意，“/”是有效的父级。
        if (parent.length() > 1 && !this.paths.containsKey(parent)) {
            return false;
        }
        
        // 第 3 步：添加这条新的路径并返回 true
        this.paths.put(path, value);
        return true;
    }
    
    public int get(String path) {
        return this.paths.getOrDefault(path, -1);
    }
}
 ```

 ```Python3 [slu1]
 class FileSystem:

    def __init__(self):
        self.paths = defaultdict()

    def createPath(self, path: str, value: int) -> bool:
        
        # 第 1 步：基本路径验证
        if path == "/" or len(path) == 0 or path in self.paths:
            return False
        
        # 第 2 步：如果父对象不存在。请注意，“/”是有效的父级。
        parent = path[:path.rfind('/')]
        if len(parent) > 1 and parent not in self.paths:
            return False
        
        # 第 3 步：添加这条新的路径并返回 true
        self.paths[path] = value
        return True

    def get(self, path: str) -> int:
        return self.paths.get(path, -1)
 ```

 **复杂度分析**

 * 时间复杂度: $\mathcal{O}(M)$，其中 $M$ 是 `path` 的长度。所有的时间实际上都是被寻找 `parent` 路径的操作消耗掉的。我们先花费 $\mathcal{O}(M)$ 的时间找到路径的最后一个 `"/"`，然后再花费 $\mathcal{O}(M)$ 的时间得到父字符串。在 HashMap/dictionary 中进行搜索和添加的操作需要一个平摊的 $\mathcal{O}(1)$ 的时间。
 * 空间复杂度: $\mathcal{O}(K)$，其中 $K$ 代表我们添加的唯一路径的数量。

---

 #### 方法 2：基于字典树的方法

 **前言**

 对于此问题，我们还可以使用另一种数据结构，那就是 `Trie` 数据结构。我们在前面的问题中看到的问题是，对于长度为 `M` 的路径，我们需要添加所有的祖先(共有 $\frac{M \times (M - 1)}{2}$ 个)，这最终会占用 HashMap 的大量空间，因为这些祖先每一个都会在字典中占据一个键。

 > 我们可以在这里使用 Trie，因为各个字符串的公共前缀可以用 Trie 中的一个公共分支来表示，这样可以节省大量的空间。另外，沿着分支的子路径也可以容易地表示，而不需要克隆 Trie 分支。例如，/a/b/c/d/e 的所有祖先，即 /a/b/c/d/e 的所有祖先，可以在表示路径/a/b/c/d/e 的单个分支上标记，这对于这个问题可以节省大量的空间。

 以下是我们在添加了以下路径后，Trie 的样子：`/a`，`/a/b`，`/a/b/c`，`/a/b/e` 和 `/a/e`。

 ![image.png](https://pic.leetcode.cn/1692079627-sKeKIe-image.png){:width=600}

 *图 2. Trie 的表示方式显示出我们添加到文件系统中的各种路径。*

 **算法**
 1. 用于表示 Trie 的基本数据结构是一个字典。字典和其他潜在的标志/数据值可以作为一个自定义的 `TreeNode` 数据结构的一部分。对于这个问题，我们将有一个 `TrieNode` 数据结构，其中包含三个内容
    1. 表示路径名的字符串。
    2. 对应于此路径的值。  
    3. 一个字典，表示到其他 `TrieNode` 的出路。  
 2. 我们的 Trie 的根将是一个包含空字符串的 `TrieNode`。  
 3. *Create()* ~  
    1. 首先，我们将给定的路径使用 `/` 作为分隔符，分割成各个组。所以对于路径 `/a/b/c`， 我们将会有四个组，即``，`a`，`b` 和 `c`。     
        ![image.png](https://pic.leetcode.cn/1692079729-IoWOUY-image.png){:width=600}
        *图 3.让我们考虑一个 Trie 的例子。*    
    2. 初始化一个名为 `curr` 的 `TrieNode`，它将等于 Trie 的根节点。注意我们总是从根节点开始，然后根据各个路径组件进行操作。    

        ![image.png](https://pic.leetcode.cn/1692079972-MZzQVh-image.png){:width=600}

        *图 4.初始化 "curr" 节点。*    
    3. 我们将迭代这些组件中的所有组件，对于其中的每一个组件，我们要执行以下操作。  
       1. 检查该组件是否存在于 `curr` 的字典中。如果不是，除非它是路径的最后一个组件，在那种情况下，我们可以将它加到当前的字典中，否则我们返回 `false`。  
       2. 如果当前组件存在于 `curr` 节点中，我们可以获得另一个 `TrieNode` 值，并更新 `curr` 以使它等于该节点。  
       3. 最后，我们将处理路径的最后一个组件。如果它也存在于 trie 中，那么我们将返回 `false`，这是符合问题的要求的。否则，我们将它添加到 trie 中，通过创建一个新的节点，路径为 `path`，值为 `value`，即输入参数。   

            ![image.png](https://pic.leetcode.cn/1692080074-cINPGl-image.png){:width=600}

            *图 5.向Trie中添加最后一个组件。* 
4. *Get()* ~  
   1. 要检查路径是否存在于 trie 中，我们需要验证所有的组件，以及正确的连接是否存在于 trie 中。
   2. 使用 `/` 作为分隔符，将给定的路径分割成各个组件。
   3. 初始化一个名为 `curr` 的 `TrieNode`，它将等于 Trie 的根节点。
   4. 我们将迭代这些组件中的所有组件，对于其中的每一个组件，我们要执行以下操作：
      1. 检查该组件是否存在于 `curr` 的字典中。
      2. 如果当前组件存在于 `curr` 节点中，我们可以获取另一个 `TrieNode` 的值，并更新 `curr` 以使其等于该节点。
      3. 如果它不存在，我们返回 `false`。
   5. 返回 `true`。  

 ```Java [slu2]
 class FileSystem {

    // TrieNode 数据结构
    class TrieNode {
        
        String name;
        int val = -1;
        Map<String, TrieNode> map = new HashMap<>();
        
        TrieNode (String name) {
            this.name = name;
        }
    }
    
    TrieNode root;
    
    // 根节点包含空字符串
    public FileSystem() {
        this.root = new TrieNode("");
    }
    
    public boolean createPath(String path, int value) {
        
        // 获取所有部分
        String[] components = path.split("/");
        
        // "curr" 从根节点开始
        TrieNode cur = root;
        
        // 迭代所有部分
        for (int i = 1; i < components.length; i++) {
            
            String currentComponent = components[i];
            
            // 对于每个部分，我们检查它是否存在于当前节点的dictionary中。
            if (cur.map.containsKey(currentComponent) == false) {
                
                // If it doesn't and it is the last node, add it to the Trie.
                if (i == components.length - 1) {
                    cur.map.put(currentComponent, new TrieNode(currentComponent));
                } else {
                    return false;
                }    
            }
            
            cur = cur.map.get(currentComponent);
        }
        
        // Value not equal to -1 means the path already exists in the trie. 
        if (cur.val != -1) {
            return false;
        }
        
        cur.val = value;
        return true;
    }
    
    public int get(String path) {
        
        // 获取所有部分
        String[] components = path.split("/");
        
        // "curr" 从根节点开始
        TrieNode cur = root;
        
        // 迭代所有部分
        for (int i = 1; i < components.length; i++) {
            
            String currentComponent = components[i];
            
            // 对于每个部分，我们检查它是否存在于当前节点的dictionary中。
            if (cur.map.containsKey(currentComponent) == false) {
                return -1;   
            }
            
            cur = cur.map.get(currentComponent);
        }
        
        return cur.val;
    }
}
 ```

 ```Python3 [slu2]
 
# TrieNode 数据结构
class TrieNode(object):
    def __init__(self, name):
        self.map = defaultdict(TrieNode)
        self.name = name
        self.value = -1

class FileSystem:

    def __init__(self):
        
        # 根节点包含空字符串
        self.root = TrieNode("")

    def createPath(self, path: str, value: int) -> bool:
        
        # 获取所有部分
        components = path.split("/")
        
        # "curr" 从根节点开始
        cur = self.root
        
        # 迭代所有部分
        for i in range(1, len(components)):
            name = components[i]
            
            # 对于每个部分，我们检查它是否存在于当前节点的dictionary中。
            if name not in cur.map:
                
                # If it doesn't and it is the last node, add it to the Trie.
                if i == len(components) - 1:
                    cur.map[name] = TrieNode(name)
                else:
                    return False
            cur = cur.map[name]
        
        # Value not equal to -1 means the path already exists in the trie. 
        if cur.value!=-1:
            return False
        
        cur.value = value
        return True

    def get(self, path: str) -> int:
        
        # 获取所有部分
        cur = self.root
        
        # "curr" 从根节点开始
        components = path.split("/")
        
        # 迭代所有部分
        for i in range(1, len(components)):
            
            # 对于每个部分，我们检查它是否存在于当前节点的dictionary中。
            name = components[i]
            if name not in cur.map:
                return -1
            cur = cur.map[name]
        return cur.value
 ```

 **复杂度分析**

 在我们进行复杂度分析之前，让我们看一下为什么可能更喜欢使用 Trie 的方法。Trie 方法的主要优点是我们能够节省空间。所有共享公共前缀的路径可以用树中的一个公共分支来表示。然而，缺点是 `get` 操作不再是 $O(1)$ 的。

 * 时间复杂度:  
   - `create` ~ 为 trie 添加一个包含 $T$ 个组件的路径需要 $O(T)$ 的时间。
   - `get` ~ 在 trie 中寻找一个包含$T$个组件的路径需要 $O(T)$ 的时间。
 * 空间复杂度:  
   - `create` ~ 让我们看一下最坏情况下的空间复杂度。在最坏的情况下，没有任何的路径会有任何的公共前缀。在这里，我们不是在考虑一个更大路径的祖先。在这种情况下，每一个唯一的路径都会最终在 trie 中占据一个不同的分支。另外，对于一个包含 $T$ 个组件的路径，在 trie 中将会有 $T$ 个节点。
   - `get` ~ $O(1)$。

---