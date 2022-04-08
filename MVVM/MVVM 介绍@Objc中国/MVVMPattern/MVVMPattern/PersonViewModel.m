//
//  PersonViewModel.m
//  MVVMPattern
//
//  Created by Qilin Hu on 2020/12/15.
//

#import "PersonViewModel.h"
#import "Person.h"

@interface PersonViewModel ()

@property (nonatomic, readwrite, strong) Person *person;
@property (nonatomic, readwrite, copy) NSString *nameText;
@property (nonatomic, readwrite, copy) NSString *birthdateText;

@end

@implementation PersonViewModel

- (instancetype)initWithPerson:(Person *)person {
    self = [super init];
    if (self) {
        _person = person;
        
        if (person.salutation.length > 0) {
            _nameText = [NSString stringWithFormat:@"%@ %@ %@", self.person.salutation, self.person.firstName, self.person.lastName];
        } else {
            _nameText = [NSString stringWithFormat:@"%@ %@", self.person.firstName, self.person.lastName];
        }
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
        _birthdateText = [dateFormat stringFromDate:self.person.birthday];
    }
    return self;
}

@end
