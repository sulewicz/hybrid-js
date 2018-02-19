#import "WebViewController.h"
#import <WebKit/WebKit.h>

static NSString * const kWebViewScheme = @"webview://";
static NSString * const kAlertScheme = @"alert://";

@interface WebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic) WKWebView *webView;

- (void)onBackPressed:(UIBarButtonItem *)sender;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackPressed:)];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:webConfiguration];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    if (self.targetUrl) {
        if (self.targetUrl.fileURL) {
            [self.webView loadFileURL:self.targetUrl allowingReadAccessToURL:self.targetUrl];
        } else {
            NSURLRequest *request = [NSURLRequest requestWithURL:self.targetUrl];
            [self.webView loadRequest:request];
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([url hasPrefix:kWebViewScheme]) {
        NSURL *bundleUrl = [[NSBundle mainBundle] bundleURL];
        NSURL *targetUrl = [bundleUrl URLByAppendingPathComponent:[[url substringFromIndex:kWebViewScheme.length] stringByRemovingPercentEncoding] isDirectory:NO];
        WebViewController *webViewController = [[WebViewController alloc] init];
        webViewController.targetUrl = targetUrl;
        [self.navigationController pushViewController:webViewController animated:NO];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([url hasPrefix:kAlertScheme]) {
        NSString *message = [[url substringFromIndex:kAlertScheme.length] stringByRemovingPercentEncoding];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBackPressed:(UIBarButtonItem *)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
