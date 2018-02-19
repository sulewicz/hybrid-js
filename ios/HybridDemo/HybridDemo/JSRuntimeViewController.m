#import "JSRuntimeViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSRuntimeViewController ()

- (IBAction)onRunJSClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) JSContext *jsContext;
@end

@implementation JSRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jsContext = [[JSContext alloc] init];
    
    [self.scrollView addSubview:self.contentView];
    
    __weak JSRuntimeViewController *weakSelf = self;
    self.jsContext[@"createLabel"] = ^(NSString *label) {
        UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, weakSelf.contentView.subviews.count * 20, weakSelf.contentView.frame.size.width, 20)];
        view.text = label;
        [weakSelf.contentView addSubview:view];
        weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.contentView.frame.size.width, weakSelf.contentView.subviews.count * 20);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onRunJSClicked:(id)sender {
    [self.jsContext evaluateScript:[NSString stringWithFormat:@"createLabel(\"Label %lu\");", (unsigned long)self.contentView.subviews.count]];
}

@end
