//
//  ViewController.h
//  Bonjour02
//
//  Created by もさお on 12/11/05.
//  Copyright (c) 2012年 もさお. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>

@interface BonjourServer : NSObject <NSNetServiceBrowserDelegate,NSStreamDelegate>
{
    NSNetService    *service;   //ネットワークサービスを提供
    
    NSString    *_domain;   // ドメイン名
    NSString    *_protocol; // プロトコル
    NSString    *_name;     // サービス名
    int         _port;      // ポート番号
    
    NSFileHandle*   _readHandle;        // ソケット開くときに使用
    
    NSString        *_receiveString;    // 送られてきた文字列
    
    NSString    *_status;   // 状態
}

@property (nonatomic,readonly) NSString *receiveString,*status;

// 自動初期化
-(id)init;

// 手動で初期化
-(id)initWithDomain:(NSString *)domain
        protocol:(NSString *)protcol
        name:(NSString *)name
        portNumber:(int)port;

// サービス開始
-(void)publishNetService;
-(void)netServiceDidPublish:(NSNetService *)sender;
-(void)acceptConnect:(NSNotification *)aNotification;
-(void)receiveData:(NSNotification *)aNotification;

-(void)sendData:(NSString *)sendString;

@end
