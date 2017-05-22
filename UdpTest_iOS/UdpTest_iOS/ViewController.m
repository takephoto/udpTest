//
//  ViewController.m
//  UdpTest_iOS
//
//  Created by 杨洋 on 2017/5/22.
//  Copyright © 2017年 杨洋. All rights reserved.
//

#import "ViewController.h"
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>
#import <Masonry.h>

@interface ViewController () <GCDAsyncUdpSocketDelegate>
{
    UITextView *_sendTextView ;
    UITextView *_reponseTextView ;
    UITextView *_logTextView ;
    
    GCDAsyncUdpSocket *_udpSocket ;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView] ;
    
    if(!_udpSocket){
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()] ;
    }
    
    NSError *error ;
    if(![_udpSocket bindToPort:0 error:&error]){
        _logTextView.text = [NSString stringWithFormat:@"%@\n%@",_logTextView.text,@"绑定端错失败"] ;
        NSLog(@"error = %@",error) ;
    }
    
    if(![_udpSocket beginReceiving:&error]){
        _logTextView.text = [NSString stringWithFormat:@"%@\n%@",_logTextView.text,@"启动接受数据服务失败"] ;
        NSLog(@"error = %@",error) ;
    }
}

- (void) initView
{

    UILabel *label = [[UILabel alloc] init] ;
    label.text = @"发送" ;
    [self.view addSubview:label] ;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(5) ;
        make.top.equalTo(@74) ;
    }] ;
    
    // 发送数据输入框
    UITextView *sendTextView = [[UITextView alloc] init] ;
    sendTextView.layer.borderColor = [UIColor greenColor].CGColor ;
    sendTextView.layer.borderWidth = 1 ;
    
    [self.view addSubview:sendTextView] ;
    
    [sendTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(5) ;
        make.left.mas_equalTo(self.view.mas_left).offset(5) ;
        make.right.mas_equalTo(self.view.mas_right).offset(-90);
        make.height.equalTo(@100) ;
    }] ;
    
    _sendTextView = sendTextView ;
    
    // 发送按钮
    UIButton *sendButton = [[UIButton alloc] init] ;
    sendButton.backgroundColor = [UIColor blueColor] ;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal] ;
    [sendButton addTarget:self action:@selector(sendText:) forControlEvents:UIControlEventTouchUpInside] ;
    [self.view addSubview:sendButton] ;
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sendTextView) ;
        make.height.equalTo(@100) ;
        make.right.mas_equalTo(self.view.mas_right).offset(-5) ;
        make.width.equalTo(@80) ;
    }] ;
    
    
    UILabel *responseLabel = [[UILabel alloc] init] ;
    responseLabel.text = @"接收" ;
    [self.view addSubview:responseLabel] ;
    
    [responseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(5) ;
        make.top.mas_equalTo(sendTextView.mas_bottom).offset(5) ;
    }] ;
    
    // 接受数据文本框
    UITextView *reponseTextView = [[UITextView alloc] init] ;
    reponseTextView.layer.borderWidth = 1 ;
    reponseTextView.layer.borderColor = [UIColor redColor].CGColor ;
    [self.view addSubview:reponseTextView] ;
    
    [reponseTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(responseLabel.mas_bottom).offset(5) ;
        make.left.mas_equalTo(self.view.mas_left).offset(5) ;
        make.right.mas_equalTo(self.view.mas_right).offset(-5) ;
        make.height.equalTo(@100) ;
    }] ;
    
    _reponseTextView = reponseTextView ;
    
    UILabel *logLabel = [[UILabel alloc] init] ;
    logLabel.text = @"日志" ;
    [self.view addSubview:logLabel] ;
    
    [logLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(5) ;
        make.top.mas_equalTo(reponseTextView.mas_bottom).offset(5) ;
    }] ;
    
    //  日志文本框
    UITextView *logTextView = [[UITextView alloc] init] ;
    logTextView.layer.borderColor = [UIColor grayColor].CGColor ;
    logTextView.layer.borderWidth = 1 ;
    [self.view addSubview:logTextView] ;
    
    [logTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logLabel.mas_bottom).offset(5) ;
        make.left.mas_equalTo(self.view.mas_left).offset(5) ;
        make.right.mas_equalTo(self.view.mas_right).offset(-5) ;
        make.height.equalTo(@100) ;
    }] ;
    
    _logTextView = logTextView ;
}

- (void) sendText:(id) sender
{
    if(_sendTextView.text.length == 0){
         _logTextView.text = [NSString stringWithFormat:@"%@\n%@",_logTextView.text,@"发送内容为空"] ;
        return ;
    }
    
    if(_udpSocket){
        [_udpSocket sendData:[_sendTextView.text dataUsingEncoding:NSUTF8StringEncoding] toHost:@"114.115.153.117" port:8888 withTimeout:-1 tag:1] ;
    }
}


#pragma mark - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    _logTextView.text = [NSString stringWithFormat:@"%@\n%@",_logTextView.text,@"连接成功"] ;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error
{
    _logTextView.text = [NSString stringWithFormat:@"%@\n%@",_logTextView.text,@"连接失败"] ;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    _logTextView.text = [NSString stringWithFormat:@"%@\n%@",_logTextView.text,@"数据已发送"] ;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error
{
    _logTextView.text = [NSString stringWithFormat:@"%@\n%@",_logTextView.text,@"数据发送失败"] ;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext
{
    
    _reponseTextView.text = [NSString stringWithFormat:@"%@\n%@",_reponseTextView.text,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]] ;
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error
{
    _logTextView.text = [NSString stringWithFormat:@"%@\n%@",_logTextView.text,@"关闭"] ;
}

@end
