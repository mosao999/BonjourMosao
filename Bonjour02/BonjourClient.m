//
//  BonjourClient.m
//  Bonjour02
//
//  Created by もさお on 12/11/05.
//  Copyright (c) 2012年 もさお. All rights reserved.
//

#import "BonjourClient.h"

#pragma mark ---
#pragma mark Bonjour Implementation

@implementation BonjourClient

@synthesize status = _status;
@synthesize receiveString = _receiveString;

-(id)init
{
    // 自動的に初期化
    _protocol = @"_test._tcp";
    _domain = @"local";
    return self;
}

-(id)initWithProtcol:(NSString *)protocol
          domain:(NSString *)domain
{
    // 任意の値で初期化
    _protocol = protocol;
    _domain = domain;
    return self;
}

-(void)searchNetService
{
    // サービス検索
    _status = @"Seach Service";
    NSLog(@"%@",_status);
    
    browser = [[NSNetServiceBrowser alloc] init];
    [browser setDelegate:self];
    [browser searchForServicesOfType:_protocol inDomain:_domain];

    _status = @"Seaching Service";
    NSLog(@"%@",_status);
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    // サービスを発見したら自動的に呼ばれる
    _status = @"Find Service";
    NSLog(@"%@",_status);
    
    service = [[NSNetService alloc] initWithDomain:[aNetService domain]
                                              type:[aNetService type]
                                              name:[aNetService name]];
    if(service)
    {
        [service setDelegate:self];
        [service resolveWithTimeout:5.0f];
    }
    else
    {
        _status = @"Connect Failed";
        NSLog(@"%@",_status);
    }
}

-(void)netServiceDidResolveAddress:(NSNetService *)sender
{
    iStream = nil;
    oStream = nil;
    
    if(![sender getInputStream:&iStream
                  outputStream:&oStream])
    {
        _status = @"Cannot Get Streams";
        NSLog(@"%@",_status);
        return;
    }
    
    if (iStream) {
        [iStream setDelegate:self];
        [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [iStream open];
    }
    
    if(oStream)
    {
        _status = @"Get Streams";
        NSLog(@"%@",_status);
        [oStream open];
        [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    }
    
    _status = @"Waiting...";
    NSLog(@"%@",_status);
}

-(void)sendData:(NSString *)sendString
{
    _status = @"Now Send Data";
    NSLog(@"%@",_status);
    
    if(oStream){
        NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding];
        [oStream write:[data bytes] maxLength:[data length]];
    }
    
    _status = @"Finish Send Data";
    NSLog(@"%@",_status);
}

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{    
    uint8_t buf[256];
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
            _status = @"Now Read Data";
            NSLog(@"%@",_status);
            
            memset(buf, 0, sizeof(buf));
            [iStream read:buf maxLength:256];
            NSData *data = [NSData dataWithBytes:buf length:256];
            _receiveString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            _status = @"Finish Read Data";
            NSLog(@"%@",_status);
            
            break;
    }
}

@end
