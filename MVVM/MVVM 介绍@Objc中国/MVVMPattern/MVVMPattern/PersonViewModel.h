//
//  PersonViewModel.h
//  MVVMPattern
//
//  Created by Qilin Hu on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Person;

/// MARK: MVVM 模式
/// 将表示逻辑从 Controller 移出放到 View Model 对象中
/// 🤔 这可以理解为「适配器模式」吗？Model 数据无法直接显示到 View 上，因此通过中间层 ViewModel 转换之后再显示
@interface PersonViewModel : NSObject

@property (nonatomic, readonly, strong) Person *person;
@property (nonatomic, readonly, copy) NSString *nameText;
@property (nonatomic, readonly, copy) NSString *birthdateText;

- (instancetype)initWithPerson:(Person *)person;

@end

NS_ASSUME_NONNULL_END
