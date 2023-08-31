## [588.设计内存文件系统 中文官方题解](https://leetcode.cn/problems/design-in-memory-file-system/solutions/100000/she-ji-nei-cun-wen-jian-xi-tong-by-leetc-0wia)

[TOC] 

 ## 解决方案 

---
 #### 方法 1：使用单独的目录和文件列表

 我们开始讨论所使用的目录结构。根目录作为目录结构的基础。每个目录包含两个哈希映射，分别是 $dirs$ 和 $files$。$dirs$ 包含 $[(subdirectory_1\_name: subdirectory_{1\_structure}), (subdirectory_2\_name: subdirectory_{2\_structure})...]$ 这样的数据。$files$ 包含 $[(file_1: file_{1\_contents}), (file_2: file_{2\_contents})...]$ 这样的数据。下图显示了这样的目录结构，有一个样例只显示了前两层。

 ![image.png](https://pic.leetcode.cn/1691997305-HerxTB-image.png){:width=600}

 现在，我们来讨论如何实现各种需要的命令。 

 1. `ls`：在这种情况下，我们从初始化 $t$,一个临时目录指针，到根目录开始。我们根据`/`来切分输入的目录路径，并在一个 $d$ 数组中获取单独的目录名的级别。然后，我们基于找到的各个目录来遍历树状目录结构，我们不断更新 $t$ 目录指针以指向新级别的目录(子目录)，因为我们不断深入目录结构。最后，我们将根据输入在文件名或者最后级别的目录处停止。如果输入路径的最后一个级别恰好是一个文件名，我们只需要返回文件名。因此，我们直接返回 $d$ 数组中的最后一项。如果最后级别的条目恰好是一个目录，我们可以从 $dirs$ 哈希映射的键列表中获得其子目录列表。同样，我们可以从相应的 $files$ 哈希映射的键中获得最后目录的文件列表。我们将获取的这两个列表加起来，排序它们并返回排序后的列表。
 2. `mkdir`：对此命令的回应，就像 `ls` 的情况一样，我们开始进入目录结构，一级一级的进行。每当我们到达一个状态，即路径上面的 `mkdir` 所提到的目录不存在时，我们在最后一个有效目录的 $dirs$ 结构中新建一个条目，并将其子目录列表初始化为空列表。我们继续这样做，直到我们到达最后级别的目录。
 3. `addContentToFile`：对此命令的回应，跟 `ls` 的情况一样，我们开始进入目录结构，一级一级的进行。当我们到达文件名所在的级别时，我们检查文件名是否已经存在于 $files$ 键中。如果存在，我们将当前内容添加到文件的内容中(在相应文件的值部分)。如果不存在，我们在当前目录的 $files$ 中创建一个新条目，并用当前内容初始化其内容。
 4. `readContentFromFile`：与前面的情况一样，我们通过一级一级的遍历目录结构到达最后一个目录级别。然后，在最后一个目录中，我们在相应的 $files$ 的键中搜索文件名条目，并返回其对应的值作为文件的内容。

```Java [slu1]
public class FileSystem {
    class Dir {
        HashMap < String, Dir > dirs = new HashMap < > ();
        HashMap < String, String > files = new HashMap < > ();
    }
    Dir root;
    public FileSystem() {
        root = new Dir();
    }
    public List < String > ls(String path) {
        Dir t = root;
        List < String > files = new ArrayList < > ();
        if (!path.equals(""/"")) {
            String[] d = path.split(""/"");
            for (int i = 1; i < d.length - 1; i++) {
                t = t.dirs.get(d[i]);
            }
            if (t.files.containsKey(d[d.length - 1])) {
                files.add(d[d.length - 1]);
                return files;
            } else {
                t = t.dirs.get(d[d.length - 1]);
            }
        }
        files.addAll(new ArrayList < > (t.dirs.keySet()));
        files.addAll(new ArrayList < > (t.files.keySet()));
        Collections.sort(files);
        return files;
    }

    public void mkdir(String path) {
        Dir t = root;
        String[] d = path.split(""/"");
        for (int i = 1; i < d.length; i++) {
            if (!t.dirs.containsKey(d[i]))
                t.dirs.put(d[i], new Dir());
            t = t.dirs.get(d[i]);
        }
    }

    public void addContentToFile(String filePath, String content) {
        Dir t = root;
        String[] d = filePath.split(""/"");
        for (int i = 1; i < d.length - 1; i++) {
            t = t.dirs.get(d[i]);
        }
        t.files.put(d[d.length - 1], t.files.getOrDefault(d[d.length - 1], """") + content);
    }

    public String readContentFromFile(String filePath) {
        Dir t = root;
        String[] d = filePath.split(""/"");
        for (int i = 1; i < d.length - 1; i++) {
            t = t.dirs.get(d[i]);
        }
        return t.files.get(d[d.length - 1]);
    }
}

/**
 * 你的文件系统对象将被实例化并按如下方式调用：
 * FileSystem obj = new FileSystem();
 * List<String> param_1 = obj.ls(path);
 * obj.mkdir(path);
 * obj.addContentToFile(filePath,content);
 * String param_4 = obj.readContentFromFile(filePath);
 */
```

 **性能分析**

 * 执行 `ls` 命令的时间复杂度是 $O\big(m+n+klog(k)\big)$。 这里，$m$ 指的是输入字符串的长度。我们需要扫描输入字符串一次，分割它并确定各个级别。$n$ 指的是 `ls` 给出的输入中最后目录级别的深度。我们需要这个因素，因为我们需要进入树结构的 $n$ 级别以到达最后一级。$k$ 指的是在当前输入中，最后一级目录中的条目数量(文件+子目录)。我们需要以 $klog(k)$ 的因素对这些名字进行排序。
 * 执行 `mkdir` 命令的时间复杂度是 $O(m+n)$。这里，$m$ 指的是输入字符串的长度。我们需要扫描输入字符串一次，分割它并确定各个级别。$n$ 指的是 `mkdir` 输入中最后目录级别的深度。我们需要这个因素，因为我们需要进入树结构的 $n$ 级别以达到最后一级。
 * `addContentToFile` 和 `readContentFromFile` 的时间复杂度都是 $O(m+n)$。这里，$m$ 指的是输入字符串的长度。我们需要扫描输入字符串一次，分割它并确定各个级别。$n$ 指的是当前输入中文件名的深度。这个因素在此是因为我们需要进入树结构的 $n$ 级别，以达到需要添加/读取文件内容的级别。
 * 维护这种目录结构的优点是它可以轻松地扩展到包括更多的命令。例如，`rmdir` 可以删除给定输入目录路径的目录。我们只需要到达指定的目录级别，然后从相应的 $dirs$ 键中删除对应的目录条目。
 * 重命名文件/目录也非常简单，因为我们只需要创建一个具有新名称的临时目录结构/文件的副本，然后删除最后的条目。
 * 将一个具有层级结构的子目录从一个目录移动到另一个目录也非常简单，因为我们只需要获取对应的子目录类的地址，并在新目录结构的新位置上分配相同的地址。
 * 在任何路径上只提取目录或文件列表在这种情况下很容易，因为我们为 $dirs$ 和 $files$ 保持了分开的条目。

---

 #### 方法 2：使用统一的目录和文件列表

 这种设计与第一种设计的不同之处在于，当前的目录数据结构包含一个统一的 `files` 哈希映射，它包含当前目录中所有文件和子目录的列表。除此之外，我们还包含了一个 `isfile` 条目，当它为 True 时，表示当前的 `files` 条目实际上对应一个文件，否则它表示一个目录。此外，因为我们以相同的方式考虑目录和文件的条目，我们需要一个 `content` 条目，它包含当前文件的内容(如果 `isfile` 条目在当前情况下为 True)。对于对应目录的条目，`content` 字段保持空。
 下图显示了与上述情况相同的示例的目录结构，对于层次结构的前两级。

 ![image.png](https://pic.leetcode.cn/1691997634-gYiLEK-image.png){:width=400}

 所有命令的实现与最后一种设计保持相同，只不过我们需要在相同的 `files` 哈希映射中为文件和目录做出条目，这对应于 `addContentToFile` 和 `mkdir`。此外，对于 `ls`，我们不需要为文件和目录分别提取条目，因为它们在当前情况下是统一的，并且可以一次性获得。

 ```Java [slu2]
 public class FileSystem {
    class File {
        boolean isfile = false;
        HashMap < String, File > files = new HashMap < > ();
        String content = """";
    }
    File root;
    public FileSystem() {
        root = new File();
    }

    public List < String > ls(String path) {
        File t = root;
        List < String > files = new ArrayList < > ();
        if (!path.equals(""/"")) {
            String[] d = path.split(""/"");
            for (int i = 1; i < d.length; i++) {
                t = t.files.get(d[i]);
            }
            if (t.isfile) {
                files.add(d[d.length - 1]);
                return files;
            }
        }
        List < String > res_files = new ArrayList < > (t.files.keySet());
        Collections.sort(res_files);
        return res_files;
    }

    public void mkdir(String path) {
        File t = root;
        String[] d = path.split(""/"");
        for (int i = 1; i < d.length; i++) {
            if (!t.files.containsKey(d[i]))
                t.files.put(d[i], new File());
            t = t.files.get(d[i]);
        }
    }

    public void addContentToFile(String filePath, String content) {
        File t = root;
        String[] d = filePath.split(""/"");
        for (int i = 1; i < d.length - 1; i++) {
            t = t.files.get(d[i]);
        }
        if (!t.files.containsKey(d[d.length - 1]))
            t.files.put(d[d.length - 1], new File());
        t = t.files.get(d[d.length - 1]);
        t.isfile = true;
        t.content = t.content + content;
    }

    public String readContentFromFile(String filePath) {
        File t = root;
        String[] d = filePath.split(""/"");
        for (int i = 1; i < d.length - 1; i++) {
            t = t.files.get(d[i]);
        }
        return t.files.get(d[d.length - 1]).content;
    }
}

/**
 * 你的文件系统对象将被实例化并按如下方式调用：
 * FileSystem obj = new FileSystem();
 * List<String> param_1 = obj.ls(path);
 * obj.mkdir(path);
 * obj.addContentToFile(filePath,content);
 * String param_4 = obj.readContentFromFile(filePath);
 */
 ```

 **性能分析** 

 * 执行 `ls` 命令的时间复杂度是 $O\big(m+n+klog(k)\big)$。这里，$m$ 指的是输入字符串的长度。我们需要扫描输入字符串一次，分割它并确定各个级别。$n$ 指的是 `ls` 给出的输入中最后目录级别的深度。我们需要这个因素，因为我们需要进入树结构的 $n$ 级别以达到最后一级。$k$ 指的是在当前输入中，最后一级目录中的条目数量（文件+子目录）。我们需要以 $k log(k)$ 的因素对这些名字进行排序。
  
 * 执行 `mkdir` 命令的时间复杂度是 $O(m+n)$。这里，$m$ 指的是输入字符串的长度。我们需要扫描输入字符串一次，分割它并确定各个级别。$n$ 指的是 `mkdir` 输入中最后目录级别的深度。我们需要这个因素，因为我们需要进入树结构的 $n$ 级别以到达最后一级。
 * `addContentToFile` 和 `readContentFromFile` 的时间复杂度都是 $O(m+n)$。这里，$m$ 指的是输入字符串的长度。我们需要扫描输入字符串一次，分割它并确定各个级别。$n$ 指的是当前输入中的文件名的深度。在这种情况下，我们需要这个因素，因为我们需要进入树结构的 $n$ 级别以达到需要添加/读取的文件内容的级别。
 * 维护这种目录结构的优势在于，它可以轻松地扩展到包括更多的命令。例如，`rmdir` 可以根据给定的输入目录路径删除一个目录。我们只需要达到目标目录级别，然后从对应的 `dirs` 键中删除对应的目录条目。
 * 重命名文件/目录也非常简单，因为我们只需要创建一个具有新名字的目录结构/文件的临时副本，然后删除最后的条目。
 * 将一个具有层次结构的子目录从一个目录移动到另一个目录也非常简单，因为我们只需要获取对应的子目录类的地址，并在新目录结构的新位置上分配相同的地址。
 * 如果目录的数量非常大，我们会为 `isfile` 和 `content` 浪费冗余的空间，这在第一种设计中是不需要的。
 * 如果我们希望在给定的路径上仅列出目录（而不是文件），那么当前设计可能会出现问题。在这种情况下，我们需要遍历当前目录的所有内容，检查每个条目是否是文件或目录，然后提取所需的数据。