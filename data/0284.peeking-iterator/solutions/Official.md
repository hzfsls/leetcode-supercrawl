## [284.顶端迭代器 中文官方题解](https://leetcode.cn/problems/peeking-iterator/solutions/100000/ding-duan-die-dai-qi-by-leetcode-solutio-8toa)
#### 方法一：迭代器

最直观的做法是使用一个列表存储迭代器中的每个元素，然后按顺序遍历列表中的元素模拟迭代器，但是该做法没有利用到迭代器的性质，更好的做法是利用迭代器的性质实现顶端迭代器的操作。

顶端迭代器需要实现以下三种操作：

- $\texttt{next}$：返回迭代器的下一个元素，并将指针向后移动一位；

- $\texttt{hasNext}$：判断迭代器中是否还有剩余的元素；

- $\texttt{peek}$：返回迭代器的下一个元素，不改变指针。

每种编程语言自带的迭代器可能支持上述一种或多种操作，但是不一定支持上述全部操作。如果编程语言自带的迭代器本身就支持上述操作，可以直接使用，否则需要自定义实现。

$\texttt{Java}$ 的 $\texttt{Iterator}$ 接口和 $\texttt{JavaScript}$ 中自定义的 $\texttt{Iterator}$ 接口支持 $\texttt{next}$ 和 $\texttt{hasNext}$ 操作，但是不支持 $\texttt{peek}$ 操作。为了在顶端迭代器中支持 $\texttt{peek}$ 操作，需要使用 $\textit{nextElement}$ 存储迭代器的下一个元素，各项操作的实现如下：

- $\texttt{next}$：首先用 $\textit{ret}$ 存储 $\textit{nextElement}$ 表示返回值，然后将 $\textit{nextElement}$ 向后移动一位，最后返回 $\textit{ret}$；

- $\texttt{hasNext}$：由于 $\textit{nextElement}$ 为迭代器的下一个元素，因此当 $\textit{nextElement}$ 不为空时返回 $\text{true}$，否则返回 $\text{false}$；

- $\texttt{peek}$：由于 $\texttt{peek}$ 操作不改变指针，因此返回 $\textit{nextElement}$。

$\texttt{C\#}$ 的 $\texttt{IEnumerator}$ 接口包含属性 $\textit{Current}$ 和方法 $\textit{MoveNext}$（该方法的返回值类型是 $\texttt{bool}$，表示是否成功移动到下一个元素），三种操作都需要自定义实现，需要使用 $\textit{flag}$ 存储迭代器是否还有剩余的元素。

- $\texttt{next}$：首先用 $\textit{ret}$ 存储 $\textit{iterator}.\textit{Current}$ 表示返回值，然后对 $\textit{iterator}$ 调用 $\textit{MoveNext}$ 方法使其向后移动一位并将该方法的结果赋值给 $\textit{flag}$，最后返回 $\textit{ret}$；

- $\texttt{hasNext}$：返回 $\text{flag}$；

- $\texttt{peek}$：由于 $\texttt{peek}$ 操作不改变指针，因此返回 $\textit{iterator}.\textit{Current}$。

$\texttt{C++}$ 中 $\texttt{PeekingIterator}$ 继承父类 $\texttt{Iterator}$，$\texttt{Iterator}$ 已经实现方法 $\texttt{next}$ 和 $\texttt{hasNext}$，在此我们在 $\texttt{PeekingIterator}$ 中主要实现 $\texttt{peek}$ 方法即可。我们使用 $\textit{flag}$ 标记迭代器是否还有剩余元素，使用 $\textit{nextElement}$ 存储迭代器的下一个元素。

- $\texttt{next}$：首先用 $\textit{ret}$ 存储 $\textit{nextElement}$ 表示返回值，$\textit{flag}$ 保存 $\texttt{Iterator}$ 调用 $\texttt{hasNext}$方法的返回结果，然后将 $\textit{nextElement}$ 向后移动一位，最后返回 $\textit{ret}$；

- $\texttt{hasNext}$：返回 $\text{flag}$；

- $\texttt{peek}$：由于 $\texttt{peek}$ 操作不改变指针，因此返回 $\textit{nextElement}$。

```Java [sol1-Java]
class PeekingIterator implements Iterator<Integer> {
    private Iterator<Integer> iterator;
    private Integer nextElement;

    public PeekingIterator(Iterator<Integer> iterator) {
        this.iterator = iterator;
        nextElement = iterator.next();
    }
    
    public Integer peek() {
        return nextElement;
    }
    
    @Override
    public Integer next() {
        Integer ret = nextElement;
        nextElement = iterator.hasNext() ? iterator.next() : null;
        return ret;
    }
    
    @Override
    public boolean hasNext() {
        return nextElement != null;
    }
}
```

```C# [sol1-C#]
class PeekingIterator {
    private IEnumerator<int> iterator;
    private bool flag;

    public PeekingIterator(IEnumerator<int> iterator) {
        this.iterator = iterator;
        flag = true;
    }
    
    public int Peek() {
        return iterator.Current;
    }
    
    public int Next() {
        int ret = iterator.Current;
        flag = iterator.MoveNext();
        return ret;
    }
    
    public bool HasNext() {
        return flag;
    }
}
```

```JavaScript [sol1-JavaScript]
var PeekingIterator = function(iterator) {
    this.iterator = iterator;
    this.nextElement = this.iterator.next();
};

PeekingIterator.prototype.peek = function() {
    return this.nextElement;
    
};

PeekingIterator.prototype.next = function() {
    const ret = this.nextElement;
    this.nextElement = this.iterator.hasNext() ? this.iterator.next() : null;
    return ret;
};

PeekingIterator.prototype.hasNext = function() {
    return this.nextElement != null;
};
```

```C++ [sol1-C++]
class PeekingIterator : public Iterator {
public:
    PeekingIterator(const vector<int>& nums) : Iterator(nums) {
        flag = Iterator::hasNext();
        if (flag) {
            nextElement = Iterator::next();
        }
    }
    
    int peek() {
        return nextElement;
    }
    
    int next() {
        int ret = nextElement;
        flag = Iterator::hasNext();
        if (flag) {
            nextElement = Iterator::next();
        }
        return ret;
    }
    
    bool hasNext() const {
        return flag;
    }
private:
    int nextElement;
    bool flag;
};
```

```go [sol1-Golang]
type PeekingIterator struct {
    iter     *Iterator
    _hasNext bool
    _next    int
}

func Constructor(iter *Iterator) *PeekingIterator {
    return &PeekingIterator{iter, iter.hasNext(), iter.next()}
}

func (it *PeekingIterator) hasNext() bool {
    return it._hasNext
}

func (it *PeekingIterator) next() int {
    ret := it._next
    it._hasNext = it.iter.hasNext()
    if it._hasNext {
        it._next = it.iter.next()
    }
    return ret
}

func (it *PeekingIterator) peek() int {
    return it._next
}
```

```Python [sol1-Python3]
class PeekingIterator:
    def __init__(self, iterator):
        self.iterator = iterator
        self._next = iterator.next()
        self._hasNext = iterator.hasNext()

    def peek(self):
        return self._next

    def next(self):
        ret = self._next
        self._hasNext = self.iterator.hasNext()
        self._next = self.iterator.next() if self._hasNext else 0
        return ret

    def hasNext(self):
        return self._hasNext
```

**复杂度分析**

- 时间复杂度：每一项操作的时间复杂度都是 $O(1)$。

- 空间复杂度：$O(1)$。

#### 进阶问题

进阶问题要求拓展顶端迭代器的设计，使其适用于所有类型，不局限于整数。

对于动态类型语言如 $\texttt{JavaScript}$ 和 $\texttt{Python}$，不需要拓展上述设计。

对于静态类型语言如 $\texttt{Java}$、$\texttt{C\#}$ 和 $\texttt{C++}$，可以通过使用泛型的方式拓展设计，在 $\texttt{PeekingIterator}$ 类中定义泛型，使用时可以用任意类型。

```Java [sol2-Java]
class PeekingIterator<E> implements Iterator<E> {
    private Iterator<E> iterator;
    private E nextElement;

    public PeekingIterator(Iterator<E> iterator) {
        this.iterator = iterator;
        nextElement = iterator.next();
    }
    
    public E peek() {
        return nextElement;
    }
    
    @Override
    public E next() {
        E ret = nextElement;
        nextElement = iterator.hasNext() ? iterator.next() : null;
        return ret;
    }
    
    @Override
    public boolean hasNext() {
        return nextElement != null;
    }
}
```

```C# [sol2-C#]
class PeekingIterator<T> {
    private IEnumerator<T> iterator;
    private bool flag;

    public PeekingIterator(IEnumerator<T> iterator) {
        this.iterator = iterator;
        flag = true;
    }
    
    public T Peek() {
        return iterator.Current;
    }
    
    public T Next() {
        T ret = iterator.Current;
        flag = iterator.MoveNext();
        return ret;
    }
    
    public bool HasNext() {
        return flag;
    }
}
```

```C++ [sol2-C++]
template <class T>
class PeekingIterator : public Iterator<T> {
public:
    PeekingIterator(const vector<T>& nums) : Iterator<T>(nums) {
        flag = Iterator<T>::hasNext();
        if (flag) {
            nextElement = Iterator<T>::next();
        }
    }
    
    T peek() {
        return nextElement;
    }

    T next() {
        T ret = nextElement;
        flag = Iterator<T>::hasNext();
        if (flag) {
            nextElement = Iterator<T>::next();
        }
        return ret;
    }
    
    bool hasNext() const {
        return flag;
    }
private:
    T nextElement;
    bool flag;
};
```