//
//  Person.m
//  MVVMPattern
//
//  Created by Qilin Hu on 2020/12/15.
//

#import "Person.h"

@interface Person ()

@property (nonatomic, readwrite, copy) NSString *salutation;
@property (nonatomic, readwrite, copy) NSString *firstName;
@property (nonatomic, readwrite, copy) NSString *lastName;
@property (nonatomic, readwrite, strong) NSDate *birthday;

@end

@implementation Person

- (instancetype)initWithSalutation:(NSString *)salutation
                         firstName:(NSString *)firstName
                          lastName:(NSString *)lastName
                          birthday:(NSDate *)birthday {
    if (self = [super init]) {
        self.salutation = salutation;
        self.firstName = firstName;
        self.lastName = lastName;
        self.birthday = birthday;
    }
    return self;
}

@end
