## [1603.设计停车系统 中文官方题解](https://leetcode.cn/problems/design-parking-system/solutions/100000/she-ji-ting-che-xi-tong-by-leetcode-solu-p52h)
#### 方法一：模拟

**思路与算法**

为每种车维护一个计数器，初始值为车位的数目。此后，每来一辆车，就将对应类型的计数器减 $1$。当计数器为 $0$ 时，说明车位已满。

**代码**

```C++ [sol1-C++]
class ParkingSystem {
public:
    int b, m, s;
    ParkingSystem(int big, int medium, int small): b(big), m(medium), s(small) {}
    
    bool addCar(int carType) {
        if (carType == 1) {
            if (b > 0) {
                b--;
                return true;
            }
        } else if (carType == 2) {
            if (m > 0) {
                m--;
                return true;
            }
        } else if (carType == 3) {
            if (s > 0) {
                s--;
                return true;
            }
        }
        return false;
    }
};
```

```Java [sol1-Java]
class ParkingSystem {
    int big, medium, small;

    public ParkingSystem(int big, int medium, int small) {
        this.big = big;
        this.medium = medium;
        this.small = small;
    }
    
    public boolean addCar(int carType) {
        if (carType == 1) {
            if (big > 0) {
                big--;
                return true;
            }
        } else if (carType == 2) {
            if (medium > 0) {
                medium--;
                return true;
            }
        } else if (carType == 3) {
            if (small > 0) {
                small--;
                return true;
            }
        }
        return false;
    }
}
```

```JavaScript [sol1-JavaScript]
var ParkingSystem = function(big, medium, small) {
    this.big = big;
    this.medium = medium;
    this.small = small;
};

ParkingSystem.prototype.addCar = function(carType) {
    if (carType === 1) {
        if (this.big > 0) {
            this.big--;
            return true;
        }
    } else if (carType === 2) {
        if (this.medium > 0) {
            this.medium--;
            return true;
        }
    } else if (carType === 3) {
        if (this.small > 0) {
            this.small--;
            return true;
        }
    }
    return false;
};
```

```go [sol1-Golang]
type ParkingSystem struct {
    left [4]int
}

func Constructor(big, medium, small int) ParkingSystem {
    return ParkingSystem{[4]int{0, big, medium, small}}
}

func (s *ParkingSystem) AddCar(carType int) bool {
    if s.left[carType] > 0 {
        s.left[carType]--
        return true
    }
    return false
}
```

```C [sol1-C]
typedef struct {
    int b, m, s;
} ParkingSystem;

ParkingSystem* parkingSystemCreate(int big, int medium, int small) {
    ParkingSystem* ret = malloc(sizeof(ParkingSystem));
    ret->b = big;
    ret->m = medium;
    ret->s = small;
    return ret;
}

bool parkingSystemAddCar(ParkingSystem* obj, int carType) {
    if (carType == 1) {
        if (obj->b > 0) {
            obj->b--;
            return true;
        }
    } else if (carType == 2) {
        if (obj->m > 0) {
            obj->m--;
            return true;
        }
    } else if (carType == 3) {
        if (obj->s > 0) {
            obj->s--;
            return true;
        }
    }
    return false;
}

void parkingSystemFree(ParkingSystem* obj) {
    free(obj);
}
```

**时间复杂度**

- 时间复杂度：单次操作为 $O(1)$。

- 空间复杂度：$O(1)$。