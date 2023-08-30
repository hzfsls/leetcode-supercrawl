[TOC]  

 ## 解决方案

---

 #### 方法 1：深度优先搜索 **[Time Limit Exceeded]**

 **算法**
 由于杀死一个进程会导致杀死所有的子进程，最简单的解决方案是遍历 $ppid$ 数组找出被杀死进程的所有子进程。对于每个被选择杀死的子进程，我们递归地调用  `killProcess` 函数，此时将这个子进程视为新的被杀死的父进程。在每次调用中，我们再次遍历 $ppid$ 数组考虑子进程的 id，并以相同的方式继续。此外，每个被选择杀死的进程是被添加到最后需要返回的列表 $l$ 中。

 ```Java [slu1]
public class Solution {

    public List < Integer > killProcess(List < Integer > pid, List < Integer > ppid, int kill) {
        List < Integer > l = new ArrayList < > ();
        if (kill == 0)
            return l;
        l.add(kill);
        for (int i = 0; i < ppid.size(); i++)
            if (ppid.get(i) == kill)
                l.addAll(killProcess(pid, ppid, pid.get(i)));
        return l;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：$O(n^n)$。最糟糕的情况下将会有 $O(n^n)$ 个函数调用。
 * 空间复杂度：$O(n)$。递归树的深度可以达到 $n$。

---

 #### 方法 2：模拟树

 **算法**
 我们可以将给出的进程关系看作一棵树。我们可以构造这棵树，使得每个节点存储关于其自身值以及其所有直接子节点的信息。因此，树构造完成后，我们可以直接开始杀死所需的节点，并递归杀死每个遇到的节点的子节点，而不是在每个节点上遍历整个 $ppid$ 数组，如同在前一个方法中所做的那样。
 为了实现这个，我们使用了一个名为 $Node$ 的类来表示树的节点。每个节点代表一个进程。因此，每个节点存储它自己的值（$Node.val$）和所有直接子节点的列表（$Node.children$）。我们遍历整个 $pid$ 数组并为所有的节点创建节点。然后，我们遍历 $ppid$ 数组，将它们作为父节点，并同时在他们的 $Node.children$ 列表中添加所有直接子节点。这样，我们将给出的进程结构转换成了树形结构。
 现在我们已经得到了树形结构，我们可以将要被杀掉的节点添加到返回列表 $l$ 中。现在，我们可以直接从树中获取这个节点的所有直接子节点，并将其直接子节点添加到返回列表中。对于添加到返回列表的每个节点，我们重复同样的获取子节点的递归过程。

 ```Java [slu2]
 public class Solution {
    class Node {
        int val;
        List < Node > children = new ArrayList < > ();
    }
    public List < Integer > killProcess(List < Integer > pid, List < Integer > ppid, int kill) {
        HashMap < Integer, Node > map = new HashMap < > ();
        for (int id: pid) {
            Node node = new Node();
            node.val = id;
            map.put(id, node);
        }
        for (int i = 0; i < ppid.size(); i++) {
            if (ppid.get(i) > 0) {
                Node par = map.get(ppid.get(i));
                par.children.add(map.get(pid.get(i)));
            }
        }
        List < Integer > l = new ArrayList < > ();
        l.add(kill);
        getAllChildren(map.get(kill), l);
        return l;
    }
    public void getAllChildren(Node pn, List < Integer > l) {
        for (Node n: pn.children) {
            l.add(n.val);
            getAllChildren(n, l);
        }
    }
}
 ```

 **复杂度分析**

 * 时间复杂度 : $O(n)$。我们需要遍历一次大小为 $n$ 的 $ppid$ 和 $pid$ 数组。`getAllChildren` 函数也最多需要 $n$ 次，因为没有节点可以是两个节点的子节点。
 * 空间复杂度 : $O(n)$。使用了大小为 $n$ 的 $map$。

---

 #### 方法 3：哈希表 + 深度优先搜索

 **算法**
 我们可以直接使用一个在其内部存储特定进程值和其直接子节点列表的数据结构。对于此，当前的实现中，我们使用一个哈希表 $map$,其形式为 ${父节点: [所有直接子节点的列表]}$。
 因此，通过遍历 $ppid$ 数组一次，并同时将相应的 $pid$ 值添加到子列表中，我们可以得到一个更好的存储父子关系的结构。
 同上一个方法一样，现在我们可以将要被杀掉的进程添加到返回列表中，并通过从先前创建的结构中获取子节点的信息，以递归方式将其子节点添加到返回列表中。

<![image.png](https://pic.leetcode-cn.com/a7a481b58060408563b862b9731d209aa7e8d344ccf108ccf5398f59625a9f9f-image.png),![image.png](https://pic.leetcode-cn.com/b526bb427636fb5600f49388d5d52eba11303c2a42eeae08c3a4ee5ff317d820-image.png),![image.png](https://pic.leetcode-cn.com/e0bda251a8a96a392e7bf60fdb5208808ce96fef47eb373487a5adeef2c3e18e-image.png),![image.png](https://pic.leetcode-cn.com/42609ed2da11073cd64f89e4739b65353003a4503942d659e8becae0f2ed2192-image.png),![image.png](https://pic.leetcode-cn.com/70c7a9ba12051ec7cefc144cbf8bd54ff4f1f209191ec22657ea75e55d55f4f3-image.png),![image.png](https://pic.leetcode-cn.com/1a703cd4a4a259003767ab60ecac21f465023107fef73355de07f246962c5e18-image.png),![image.png](https://pic.leetcode-cn.com/44a976fbde0f010671f53bd8c441d119524eeab1b6c4cdbdb590d3cc7b37c0ce-image.png),![image.png](https://pic.leetcode-cn.com/8ae6d6c7edf21e0f451a2d24c8b51465f69f4dcbcd1ee2e992d6769012e1228f-image.png)>

 ```Java [slu3]
 public class Solution {
    public List < Integer > killProcess(List < Integer > pid, List < Integer > ppid, int kill) {
        HashMap < Integer, List < Integer >> map = new HashMap < > ();
        for (int i = 0; i < ppid.size(); i++) {
            if (ppid.get(i) > 0) {
                List < Integer > l = map.getOrDefault(ppid.get(i), new ArrayList < Integer > ());
                l.add(pid.get(i));
                map.put(ppid.get(i), l);
            }
        }
        List < Integer > l = new ArrayList < > ();
        l.add(kill);
        getAllChildren(map, l, kill);
        return l;
    }
    public void getAllChildren(HashMap < Integer, List < Integer >> map, List < Integer > l, int kill) {
        if (map.containsKey(kill))
            for (int id: map.get(kill)) {
                l.add(id);
                getAllChildren(map, l, id);
            }
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：$O(n)$。我们需要遍历一次大小为 $n$ 的 $ppid$ 数组。`getAllChildren` 函数也最多需要 $n$ 时间，因为没有节点可以是两个节点的子节点。
 * 空间复杂度：$O(n)$。使用了大小为 $n$ 的 $map$。

---

 #### 方法 4：哈希表 + 广度优先搜索

 **算法**
 一旦得到形如 $进程: [其所有直接子节点的列表]$ 的数据结构，我们也可以使用广度优先搜索来获取特定节点的所有子节点（直接+间接）。得到数据结构的过程与上一个方法相同。
 为了获取要杀掉的特定父进程的所有子进程，我们可以使用广度优先搜索。为此，我们将要被杀掉的节点添加到 $queue$ 中。然后，我们从 $queue$ 的前端移除一个元素并将其添加到返回列表中。然后，对于从 $queue$ 前端移除的每个元素，我们将其所有的直接子节点（从先前创建的数据结构中获取）添加到 $queue$ 的末端。我们持续这样做直到 $queue$ 变为空。

<![image.png](https://pic.leetcode-cn.com/b6997b6bf2606777951ab7f28287010df8139ebcc2bc768dbb1b6d7081cef19a-image.png),![image.png](https://pic.leetcode-cn.com/e7d3ba32c42515125762330c61caa1f959911dbd89ed9c8636e0757f7854b886-image.png),![image.png](https://pic.leetcode-cn.com/0962db4edec1d58090437830544cfd1fec33ce2535e62af8a045ef786e1fb116-image.png),![image.png](https://pic.leetcode-cn.com/a0958760dd5545369fe8a9f3a7e8ccac4b94c01936edc882918f11dff194ac9a-image.png),![image.png](https://pic.leetcode-cn.com/63a86af07d08e93c1ffad821659623d1d2746f575d86bd85d3bf0c0570623ec0-image.png),![image.png](https://pic.leetcode-cn.com/51e26b6f86ffcc832d1c7fddd04f544975ea7ad892e8b26e1ab2e6567c18f335-image.png),![image.png](https://pic.leetcode-cn.com/64e3c32619d1a9eb7c0a77ba5b4e1e8179bc9e0eb71733799ef8e988358ba6ef-image.png),![image.png](https://pic.leetcode-cn.com/d79135ccadfc4695b0518e4ff11ff076a6afac31fc0eb7c0ffef69a85d1c848b-image.png),![image.png](https://pic.leetcode-cn.com/4e4f7245777e81824384b10cc42f88ec7f4fecf51fd24c187bd7844b4a845521-image.png)>

 ```Java [slu4]
 public class Solution {

    public List < Integer > killProcess(List < Integer > pid, List < Integer > ppid, int kill) {
        HashMap < Integer, List < Integer >> map = new HashMap < > ();
        for (int i = 0; i < ppid.size(); i++) {
            if (ppid.get(i) > 0) {
                List < Integer > l = map.getOrDefault(ppid.get(i), new ArrayList < Integer > ());
                l.add(pid.get(i));
                map.put(ppid.get(i), l);
            }
        }
        Queue < Integer > queue = new LinkedList < > ();
        List < Integer > l = new ArrayList < > ();
        queue.add(kill);
        while (!queue.isEmpty()) {
            int r = queue.remove();
            l.add(r);
            if (map.containsKey(r))
                for (int id: map.get(r))
                    queue.add(id);
        }
        return l;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：$O(n)$。我们需要遍历一次大小为 $n$ 的 $ppid$ 数组。另外，最多需要进行 $n$ 次 $queue$ 的添加/移除操作。
 * 空间复杂度：$O(n)$。使用了一个大小为 $n$ 的哈希表 $map$。