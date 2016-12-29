//
//  ViewController.m
//  WebViewBridgeDemo
//
//  Created by huangyibiao on 16/3/9.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"
#import "WXApi.h"

@interface ViewController () <UIWebViewDelegate,WXApiDelegate>

@property WebViewJavascriptBridge *bridge;

@property (nonatomic , strong) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:webView];
  
//  NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
//  NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    
//    
//  NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    //http://1.iosappp.applinzi.com/iosApp/test.html
    
    NSURL *url = [NSURL URLWithString:@"http://1.iosappp.applinzi.com/iosApp/test.html"];
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
//  [webView loadHTMLString:appHtml baseURL:baseURL];

  // 开启日志
    [WebViewJavascriptBridge enableLogging];
  
  // 给哪个webview建立JS与OjbC的沟通桥梁
  self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
  [self.bridge setWebViewDelegate:self];
  [self renderButtons:webView];
  
  // JS主动调用OjbC的方法
  // 这是JS会调用getUserIdFromObjC方法，这是OC注册给JS调用的
  // JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
  // OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
  [self.bridge registerHandler:@"getUserIdFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
    NSLog(@"js call getUserIdFromObjC, data from js is %@", data);
    if (responseCallback) {
      // 反馈给JS
      responseCallback(@{@"userId": @"123456"});
    }
  }];
  
  [self.bridge registerHandler:@"getBlogNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
    NSLog(@"js call getBlogNameFromObjC, data from js is %@", data);
    if (responseCallback) {
      // 反馈给JS
      responseCallback(@{@"blogName": @"李辉是大傻逼，张翱翔也是大傻逼"});
        
        //微信登录
        
        [self WinChatLanch];
        
    }
  }];
  
  [self.bridge callHandler:@"getUserInfos" data:@{@"name": @"槑"} responseCallback:^(id responseData) {
    NSLog(@"from js: %@", responseData);
  }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(UIWebView*)webView {
  UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
  
  UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [callbackButton setTitle:@"提交" forState:UIControlStateNormal];
  [callbackButton addTarget:self action:@selector(onOpenBlogArticle:) forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:callbackButton aboveSubview:webView];
  callbackButton.frame = CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width / 2, 35);
  callbackButton.titleLabel.font = font;
  
  UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [reloadButton setTitle:@"刷新" forState:UIControlStateNormal];
  [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:reloadButton aboveSubview:webView];
  reloadButton.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 150, self.view.frame.size.width / 2, 35);
  reloadButton.titleLabel.font = font;
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 40)];
    
    [self.textField setBackgroundColor:[UIColor grayColor]];
    
    [self.view insertSubview:self.textField aboveSubview:webView];
}

- (void)onOpenBlogArticle:(id)sender {
    // 调用打开本demo的
    //无参数
//    [self.bridge callHandler:self.textField.text data:nil];
    
    //有参数
    [self.bridge callHandler:@"getUserInfos" data:@{@"提交内容:": self.textField.text} responseCallback:^(id responseData) {
        
        NSLog(@"from js: %@", responseData);
        
    }];

}

-(void) WinChatLanch{
    
    NSLog(@"微信登录");
    
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    
    req.scope = @"snsapi_userinfo" ;
    
    req.state = @"123" ;
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];

}


@end
