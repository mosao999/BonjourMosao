//
//  BonjourClient.h
//  Bonjour02
//
//  Created by もさお on 12/11/05.
//  Copyright (c) 2012年 もさお. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BonjourClient : NSObject <NSStreamDelegate,NSNetServiceBrowserDelegate>
{
    NSNetServiceBrowser*    browser;    // サービスときに使うオブジェクト
    NSNetService            *service;   // ネットワークサービスを提供
    
    NSInputStream           *iStream;   // 入力データ
    NSOutputStream          *oStream;   // 出力データ
    
    NSString    *_protocol;     // プロトコル
    NSString    *_domain;       // ドメイン名
    
    NSString    *_receiveString;
    NSString    *_status;       // 動作状態
}

@property (nonatomic,readonly) NSString *receiveString,*status;

// 自動初期化
-(id)init;

// 手動初期化
-(id)initWithProtcol:(NSString *)protcol
              domain:(NSString *)domain;

-(void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
          didFindService:(NSNetService *)aNetService
              moreComing:(BOOL)moreComing;

-(void)netServiceDidResolveAddress:(NSNetService *)sender;

// 検索開始
-(void)searchNetService;

// データ送るぞ
-(void)sendData:(NSString *)sendString;

@end
