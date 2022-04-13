//
//  Person.h
//  MVVMPattern
//
//  Created by Qilin Hu on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, readonly, copy) NSString *salutation;
@property (nonatomic, readonly, copy) NSString *firstName;
@property (nonatomic, readonly, copy) NSString *lastName;
@property (nonatomic, readonly, strong) NSDate *birthday;

- (instancetype)initWithSalutation:(NSString *)salutation
                         firstName:(NSString *)firstName
                          lastName:(NSString *)lastName
                          birthday:(NSDate *)birthday;

@end

NS_ASSUME_NONNULL_END
