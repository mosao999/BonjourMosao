//
//  ViewController.m
//  Bonjour02
//
//  Created by もさお on 12/11/05.
//  Copyright (c) 2012年 もさお. All rights reserved.
//

#import "BonjourServer.h"

#pragma mark ---
#pragma mark Bonjour Implementation

@implementation BonjourServer

@synthesize receiveString = _receiveString;
@synthesize status = _status;

-(id)init
{
    // 初期化
    _domain = @"local";
    _protocol = @"_test._tcp";
    _name = @"mosao";
    _port = 7777;
    
    return self;
}

-(id)initWithDomain:(NSString *)domain
        protocol:(NSString *)protocol
        name:(NSString *)name
        portNumber:(int)port
{
    // 指定して初期化
    _domain = domain;
    _protocol = protocol;
    _name = name;
    _port = port;
    
    return self;
}

-(void)publishNetService
{
    // サービス発行
    service = [[NSNetService alloc] initWithDomain:_domain type:_protocol name:_name port:_port];
    if(service){
        [service setDelegate:self];
        [service publish];
        _status = @"NSNetServiece Success";
        NSLog(@"%@",_status);
        return;
    }else{
        _status = @"NSNetServiece Failed";
        NSLog(@"%@",_status);
        return;
    }
}

-(void)netServiceDidPublish:(NSNetService *)sender
{
    // サービスを発行したら自動的に呼ばれる
    // ソケット(IPアドレス+ポート番号)の作成
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_len = sizeof(addr);
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    addr.sin_port = htons(_port);
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if(bind(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0)
    {
        close(sock);
        _status = @"Bind Faild";
        NSLog(@"%@",_status);
        return;
    }
    if(listen(sock, 1))
    {
        close(sock);
        _status = @"Connect Faild";
        NSLog(@"%@",_status);
        return;
    }
    
    _status = @"Socket OK";
    NSLog(@"%@",_status);
    
    // ソケットを開く(=アクセスの許可)
    NSFileHandle *socketHandle = [[NSFileHandle alloc] initWithFileDescriptor:sock closeOnDealloc:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(acceptConnect:)
                                                 name:NSFileHandleConnectionAcceptedNotification
                                               object:socketHandle];
    [socketHandle acceptConnectionInBackgroundAndNotify];
    
    _status = @"Waiting...";
    NSLog(@"%@",_status);
}

-(void)acceptConnect:(NSNotification *)aNotification
{
    _status = @"Now Receive";
    NSLog(@"%@",_status);
    
    _readHandle = [[aNotification userInfo] objectForKey:NSFileHandleNotificationFileHandleItem];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveData:)
                                                 name:NSFileHandleDataAvailableNotification
                                               object:_readHandle];
    [_readHandle waitForDataInBackgroundAndNotify];
}

-(void)receiveData:(NSNotification *)aNotification
{
    _status = @"Now Read Data";
    NSLog(@"%@",_status);
    
    NSData *data = [_readHandle availableData];
    _receiveString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    _status = @"Finish Read Data";
    NSLog(@"%@",_status);
    
    [_readHandle waitForDataInBackgroundAndNotify];
}

-(void)sendData:(NSString *)sendString{
    _status = @"Now Send Data";
    NSLog(@"%@",_status);
    
    NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding];
    [_readHandle writeData:data];
    
    _status = @"Finish Send Data";
    NSLog(@"%@",_status);
    
    [_readHandle waitForDataInBackgroundAndNotify];
}

@end
