> 原文：[Swift Actors: A practical example, part 1](https://trycombine.com/posts/swift-actors/)



> SE-0306 引入了 actor，这是一个概念上与类十分相似但在并行环境下可以安全使用的新类型。之所以能实现并行环境的安全使用，是因为 Swift 确保 actor 中的可变状态在任意时刻都只能被一个线程访问，这个机制可以在编译器层面消除多种严重的 Bug。