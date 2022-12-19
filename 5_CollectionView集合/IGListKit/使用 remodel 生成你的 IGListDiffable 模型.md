# Generating your IGListDiffable models using remodel

With the `IGListDiffable` plugin for [remodel by facebook](https://github.com/facebook/remodel), you can automatically generate models conforming to the `IGListDiffable`.

This will automatically implement `hash`, `isEqual:` and `description`, as well as `diffIdentifier` and `isEqualToDiffableObject:` for you. Remodel is also capable to generate additional code, like conforming to `NSCoding` or additional Builder classes for your model object. It will make creating and updating models much easier, faster and safer.

In `/remodel-plugin`, you can find the source files to build the `IGListDiffable` plugin locally.



使用 facebook 的 [remodel](https://github.com/facebook/remodel) 的 IGListDiffable 插件，你可以自动生成符合 IGListDiffable 的模型。

> Remodel 是一个工具，通过生成支持 coding、值比较和不变性的 Objective-C 模型，帮助 iOS 和 OS X 开发者避免编写重复的代码。

这将自动为你实现 `hash`、`isEqual:` 和 `description`，以及 `diffIdentifier` 和`isEqualToDiffableObject:` 方法。Remodel 也能够生成额外的代码，比如符合 `NSCoding` 或为你的模型对象生成额外的 Builder 类。它将使创建和更新模型更容易、更快、更安全。

在/remodel-plugin中，你可以找到源文件来在本地构建IGListDiffable插件。

## Installation

### 1. Remodel installation

Please follow the [installation instructions](https://github.com/facebook/remodel) in the main remodel repository.

tl;dr: Either clone the original repository, or use an npm installation. In the latter case you can run `which remodel-gen` to find out the path of your installation.

### 2. Plugin installation

Copy the following files & folders within `/remodel-plugin` into your local remodel checkout:

- `/src/plugins/iglistdiffable.ts` - the actual plugin
- `/src/__tests__/plugins/iglistdiffable-test.ts` - unit tests
- `/features/iglistdiffable.feature` - integration tests

And then register the new plugin with the system:

- Edit `/remodel/src/value-object-default-config.ts` and add `iglistdiffable` to the list of basePlugins:

```
// value-object-default-config.ts
basePlugins: List.of(
    'assert-nullability',
    'assume-nonnull',
    'builder',
    'coding',
    'copying',
    'description',
    'equality',
    'fetch-status',
    'immutable-properties',
    'init-new-unavailable',
    'use-cpp',
    'iglistdiffable'
  )
```

### 3. Build plugin:

Once you copied them over and registered the plugin, you have to compile the typescript files into javascript. Do do so run this command from the remodel directory:

- `./bin/build`

### 4. Run tests (optional)

To run the unit/integration tests, you can run the following commands:

- `./bin/runUnitTests`
- `./bin/runAcceptanceTests`

This is especially useful if you plan to change/extend the plugin in any way.

### 5. Use the plugin

Now you are ready to generate your `IGListDiffable` conforming models! To generate a model, create a new `.value` file. Here's an example:

```
# PersonModel.value
PersonModel includes(IGListDiffable) {
  NSString *firstName
  NSString *lastName
  %diffIdentifier
  NSString *uniqueId
}
```

To generate your Objective-C models, run the generation tool like this:

`./bin/generate path/to/your/PersonModel.value`

This will generate the following Objective-C files in the same directory:

```
// PersonModel.h
@interface PersonModel : NSObject <IGListDiffable, NSCopying>

@property (nonatomic, readonly, copy) NSString *firstName;
@property (nonatomic, readonly, copy) NSString *lastName;
@property (nonatomic, readonly, copy) NSString *uniqueId;

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName uniqueId:(NSString *)uniqueId;

@end
```

and

```
// PersonModel.m
@implementation PersonModel

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName uniqueId:(NSString *)uniqueId
{
  if ((self = [super init])) {
    _firstName = [firstName copy];
    _lastName = [lastName copy];
    _uniqueId = [uniqueId copy];
  }

  return self;
}

- (id<NSObject>)diffIdentifier
{
  return _uniqueId;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object
{
  return [self isEqual:object];
}

- (BOOL)isEqual:(PersonModel *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_firstName == object->_firstName ? YES : [_firstName isEqual:object->_firstName]) &&
    (_lastName == object->_lastName ? YES : [_lastName isEqual:object->_lastName]) &&
    (_uniqueId == object->_uniqueId ? YES : [_uniqueId isEqual:object->_uniqueId]);
}

- (id)copyWithZone:(nullable NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t firstName: %@; \n\t lastName: %@; \n\t uniqueId: %@; \n", [super description], _firstName, _lastName, _uniqueId];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_firstName hash], [_lastName hash], [_uniqueId hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 3; ++ii) {
    unsigned long long base = (((unsigned long long)result) << 32 | subhashes[ii]);
    base = (~base) + (base << 18);
    base ^= (base >> 31);
    base *=  21;
    base ^= (base >> 11);
    base += (base << 6);
    base ^= (base >> 22);
    result = base;
  }
  return result;
}

@end
```

## Documentation

Please see the main remodel repository for [additional documentation](https://github.com/facebook/remodel)
