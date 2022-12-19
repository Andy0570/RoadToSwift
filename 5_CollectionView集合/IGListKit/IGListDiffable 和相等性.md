# IGListDiffable 和相等性

本指南解释了 `IGListDiffable` 协议以及如何编写好 `-isEquity:` 方法。

## 背景

[`IGListDiffable` ](https://instagram.github.io/IGListKit/Protocols/IGListDiffable.html) Delegate 要求客户端实现两个方法，`-diffIdentifier` 和 `-isEqualToDiffableObject:`。方法 `-isEqualToDiffableObject:` 应该执行与 `-isEquity:` 相同类型的检查，但不会影响性能特征，就像在 `NSDictionary` 和 `NSSet` 这样的 Objective-C 容器中一样。

为什么这两种方法都需要差异？使用这两个方法的意义在于一致性和等价性，其中 diff identifier 唯一标识数据（常见的场景是数据库中的主键）。当比较两个唯一标识符相同的对象的值（驱动重新加载）时，Equality 这会儿就起作用了。

See also: [#509](https://github.com/Instagram/IGListKit/issues/509)

## `IGListDiffable` 的最低要求

使用 diffable 模型的最快方法是使用对象本身作为标识符，并使用父类的 `-[NSObject isEqual:]` 实现相等性判断：

```objc
- (id<NSObject>)diffIdentifier {
  return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
  return [self isEqual:object];
}
```

## 编写更好的等价判断方法

尽管 `IGListKit` 使用了方法 `-isEqualToDiffableObject:`，但编写一个好的相等性检查的概念也适用于一般情况。下面是编写好的 `-isEqual:` 和 `-hash` 函数的基本知识。注意这都是Objective-C，但也适用于Swift。

* 如果你重写了 `-isEqual:` 方法，那么你必须同时重写 `-hash` 方法。请看 [Mike Ash 的这篇文章](https://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html)，了解详情。
* 总是先比较指针。如果检查同一个实例，这可以节省很多浪费的 `objc_msgSend(...)` 调用和值比较。
* 当比较对象的值时，总是在 `-isEqual:` 之前检查 `nil`。例如，`[nil isEqual:nil]` 反其道而行之地返回 `NO`。而不是执行 `left == right || [left isEqual:right]`。
* 总是先比较最便宜的值。例如，如果 `intVal` 值不同，做 `[self.array isEqual:other.array] && self.intVal == other.intVal` 是非常浪费的。使用懒人评估!

举个例子，如果我有一个具有以下接口的用户模型：

```objc
@interface User : NSObject

@property NSInteger identifier;
@property NSString *name;
@property NSArray *posts;

@end
```

你可以按如下方式实现其相等方法：

```objc
@implementation User

- (NSUInteger)hash {
  return self.identifier;
}

- (BOOL)isEqual:(id)object {
  // 先比较指针
  if (self == object) { 
      return YES;
  }
  
  if (![object isKindOfClass:[User class]]) {
      return NO;
  }

  User *right = object;
  return self.identifier == right.identifier 
      && (self.name == right.name || [self.name isEqual:right.name])
      && (self.posts == right.posts || [self.posts isEqualToArray:right.posts]);
}

@end
```

## 同时使用 `IGListDiffable` 和 `-isEqual:`

一旦你实现了 `-isEqual:` 和 `-hash` 方法，使你的对象普遍适用于 Objective-C 容器和`IGListKit` 就很容易了：

```objc
@interface User <IGListDiffable>

// properties...

@end

@implementation User

- (id<NSObject>)diffIdentifier {
    return @(self.identifier);
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return [self isEqual:object];
}

@end
```
