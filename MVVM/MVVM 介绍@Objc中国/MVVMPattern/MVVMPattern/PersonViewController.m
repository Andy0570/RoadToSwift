//
//  PersonViewController.m
//  MVVMPattern
//
//  Created by Qilin Hu on 2020/12/15.
//

#import "PersonViewController.h"
#import "Person.h"
#import "PersonViewModel.h"

@interface PersonViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;

@property (nonatomic, strong) Person *model;
@property (nonatomic, strong) PersonViewModel *viewModel;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[Person alloc] initWithSalutation:@"老李" firstName:@"李" lastName:@"云龙" birthday:[NSDate now]];
    self.viewModel = [[PersonViewModel alloc] initWithPerson:self.model];

    [self configureModelWithMVVMPattern];
}

/**
 MARK: MVC 模式
 
 Model 呈现数据
 View 呈现用户界面
 View Controller 调节 View 和 Model 之间的交互
 */
- (void)configureModelWithMVCPattern {
    if (self.model.salutation.length > 0) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.model.salutation, self.model.firstName, self.model.lastName];
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.model.firstName, self.model.lastName];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    self.birthdayLabel.text = [dateFormat stringFromDate:self.model.birthday];
}

/**
 MARK: MVVM 模式
 
 将表示逻辑从 Controller 移出放到 View Model 对象中
 */
- (void)configureModelWithMVVMPattern {
    self.nameLabel.text = self.viewModel.nameText;
    self.birthdayLabel.text = self.viewModel.birthdateText;
}

@end
