之前的 LootLogger 应用程序利用 **Codable** APIs 和 **PropertyListEncoder** 对数据进行序列化，以便将数据持久化到文件系统中。这种存档模式的最大缺点是其要么全有要么全无的特性：要访问存档中的任何内容，必须反序列化整个文件，要保存任何更新，必须序列化整个文件。

另一方面，Core Data 可以获取存储对象的子集。如果你只更改一个对象，那么你可以只更新该对象。当有大量模型对象在文件系统和 RAM 之间穿梭时，这种增量的增删查改（Create、Delete、Request、Update）操作可以从根本上提高应用程序的性能。



## Object Graphs（对象图）

Core Data 是一个框架，让你表达你的模型对象是什么以及它们之间的关系。这种模型对象的集合通常被称为对象图（object graph），因为对象可以被认为是节点，而关系是数学图中的顶点。Core Data 控制着这些对象的生命周期，确保关系保持最新。当你保存和加载这些对象时，Core Data 确保所有的东西都是一致的。

通常，你会让 Core Data 把你的对象图保存到一个 SQLite 数据库中。习惯于其他 SQL 技术的开发者可能期望把 Core Data 当作一个对象关系映射系统，但这种思维方式会导致混乱。与 ORM 不同，Core Data 完全控制了存储，而存储恰好是一个关系型数据库。你不必描述像数据库模式和外键这样的东西——Core Data 会替你做这些。你只需告诉 Core Data 需要存储什么，并让它解决如何在文件系统上表示。

Core Data 给你提供了在关系数据库中获取和存储数据的能力，而（让你）不需要知道底层存储机制的细节。本章将让你在为 Photorama 应用程序添加持久性时了解 Core Data。



## Entities （实体）

关系型数据库有一个叫做表（table）的东西。一个表代表一种类型。你可以有一个 person 表，一个信用卡购买表，或者一个房地产列表的表。每个表都有一些列来保存有关该类型的信息。一个代表 person 的表可能有姓名、出生日期和身高的列。表中的每一行都代表该类型的一个例子--例如，一个人。
这种组织方式可以很好地转化为 Swift。每个表都像一个 Swift 类型。每一列都是该类型的一个属性。每一行都是该类型的一个实例。因此，Core Data 的工作是将数据在这两种表现形式之间转换（下图）。

![](https://tva1.sinaimg.cn/large/008i3skNgy1gx8sku9l82j31a60dq76c.jpg)



Core Data 使用不同的术语来描述这些概念。一个 table/type 被称为 entity（实体），而 columns/properties 被称为 attributes（属性）。在你的应用程序中，Core Data model 文件是对每个实体及其属性的描述。在 Photorama 中，你将在 model 文件中描述一个 **Photo** 实体，并赋予其属性，如标题、远程 URL 和拍摄日期。



默认情况下，Core Data 实体的所有属性都是可选的。Core Data 使用术语 “optional” 来表示与 Swift optionals 稍有不同的意思。在 Core Data 中，非可选属性在保存时必须有一个值; （而默认的可选属性）在保存之前不需要有一个值。由于此契约，Core Data 实体属性始终由 Swift 可选属性表示。

这意味着，虽然 photoID 是 Core Data 模型编辑器中的 `String` 类型，但它在代码层面是用 `String?` 来表示的。这就是当前错误产生的原因。



## Core Data 堆栈

### NSManagedObjectModel

在本章的前面，您使用了模型文件。模型文件是您为应用程序定义实体及其属性的地方。模型文件表示为 **NSManagedObjectModel** 的实例。

### NSPersistentStoreCoordinator

Core Data 可以以多种格式保存数据:

| 数据格式  | 描述                                                       |
| --------- | ---------------------------------------------------------- |
| SQLite    | 使用SQLite数据库将数据保存到磁盘。这是最常用的存储类型。   |
| Automic   | 数据以二进制格式保存到磁盘。                               |
| XML       | 数据使用 XML 格式保存到磁盘。这种存储类型在 iOS 上不可用。 |
| In-Memory | 数据不会保存到磁盘，而是存储在内存中。                     |

对象图和持久化存储之间的映射是使用 **NSPersistentStoreCollaborator** 的实例来完成的。持久存储协调器需要知道两件事：“我的实体是什么？”以及，“我要将数据保存到哪里并从哪里加载数据？”要回答这些问题，您需要使用**NSManagedObjectModel** 实例化 **NSPersistentStoreCollaborator**。然后向协调器添加一个持久化存储，表示上面的一种持久化格式。创建协调器后，将向协调器添加特定的存储区。这个存储至少需要知道它的类型以及它应该将数据保存在哪里。

### NSManagedObjectContext

与实体交互的门户是 NSManagedObjectContext。托管对象上下文与特定的持久存储协调器相关联。正如我们在本章前面所说的，您可以将托管对象上下文视为智能便签簿。当您请求上下文获取一些实体时，上下文将与其持久存储协调器一起将实体和对象图的临时副本带到内存中。除非您要求上下文保存其更改，否则持久化数据将保持不变。

