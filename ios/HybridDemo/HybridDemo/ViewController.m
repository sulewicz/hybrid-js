#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()

- (IBAction)onWebViewDemoClicked:(id)sender;
- (IBAction)onJSRuntimeDemoClicked:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onWebViewDemoClicked:(id)sender {
    [self performSegueWithIdentifier:@"webViewController" sender:nil];
}

- (IBAction)onJSRuntimeDemoClicked:(id)sender {
    [self performSegueWithIdentifier:@"runtimeViewController" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[WebViewController class]]) {
        WebViewController *target = (WebViewController *)segue.destinationViewController;
        target.targetUrl = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"html"];
    }
}

@end
