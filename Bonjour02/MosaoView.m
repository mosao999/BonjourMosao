//
//  ButtonView.m
//  Bonjour02
//
//  Created by もさお on 12/11/06.
//  Copyright (c) 2012年 もさお. All rights reserved.
//

#import "MosaoView.h"

@implementation MosaoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _serverMode = 0;    // サーバーモード初期値
        _clientMode = 0;    // クライアントモード初期値
        
        self.backgroundColor = [UIColor clearColor];
        
        // サーバーボタン設定
        serverButtonText = @"サーバー起動";       // ボタン文字
        serverButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [serverButton setTitle:serverButtonText forState:UIControlStateNormal];
        serverButton.frame = CGRectMake(20,10,130,40);
        [serverButton addTarget:self
                         action:@selector(severRun)
               forControlEvents:UIControlEventTouchDown];
        [self addSubview:serverButton];
        

        // クライアントボタン設定
        clientButtonText = @"クライアント起動";    // ボタン文字
        clientButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [clientButton setTitle:clientButtonText forState:UIControlStateNormal];
        clientButton.frame = CGRectMake(170,10,130,40);
        [clientButton addTarget:self
                         action:@selector(clientRun)
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clientButton];
        
        // お、おっきい…(照)見出しの設定
        labelText = @"選べ！";
        label = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, 200, 50)];
        label.text = labelText;
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont fontWithName:@"AppleGothic" size:20];
        [self addSubview:label];
        
        // 送信データ(受信データ)の閲覧ラベル
        resultText = @"＼( 'ω')／";
        resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 320, 170)];
        resultLabel.text = resultText;
        resultLabel.textAlignment = UITextAlignmentCenter;
        resultLabel.textColor = [UIColor blueColor];
        resultLabel.font = [UIFont fontWithName:@"AppleGothic" size:40];
        [self addSubview:resultLabel];
        
        // ログのラベル設定
        status = @"Bonjour!!";
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 380, 300, 30)];
        statusLabel.text = status;
        statusLabel.font = [UIFont fontWithName:@"AppleGothic" size:16];
        [self addSubview:statusLabel];
        
        // バックグラウンドで状態を監視するためのタイマー設定
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                  target:self
                                               selector:@selector(lookStatus:)
                                                userInfo:nil
                                                 repeats:YES];

    }
    return self;
}

- (void)severRun{
    // サーバー起動を選択したときに呼ばれる
    if(_serverMode == 0 && _clientMode == 0){
        _serverMode = 1;
        status = @"Run as Server";
        NSLog(@"%@",status);
        [statusLabel setText:status];
        
        labelText = @"サーバー起動なう";
        [label setText:labelText];
        
        serverButtonText = @"( ˘⊖˘)＜";
        [serverButton setTitle:serverButtonText forState:UIControlStateNormal];
        serverButton.userInteractionEnabled = NO;
        
        clientButtonText = @"心に…余裕が…。";
        [clientButton setTitle:clientButtonText forState:UIControlStateNormal];
        clientButton.userInteractionEnabled = NO;
        
        resultText = @"( ˘⊖˘) ……。";
        [resultLabel setText:resultText];
        
        server = [[BonjourServer alloc] init];
        [server publishNetService];
    }
}

- (void)clientRun{
    //クライアント起動を選択した時に呼ばれる
    if(_serverMode == 0 && _clientMode == 0){
        _clientMode = 1;
        status = @"Run as Client";
        NSLog(@"%@",status);
        [statusLabel setText:status];
        
        labelText = @"クライアント起動なう";
        [label setText:labelText];
        
        serverButtonText = @"(☝ ՞ਊ ՞)☝ ＜";
        [serverButton setTitle:serverButtonText forState:UIControlStateNormal];
        serverButton.userInteractionEnabled = NO;
        
        clientButtonText = @"ちょいちょいww";
        [clientButton setTitle:clientButtonText forState:UIControlStateNormal];
        clientButton.userInteractionEnabled = NO;
        
        resultText = @"(☝ ՞ਊ ՞)☝ ……。";
        [resultLabel setText:resultText];
        
        client = [[BonjourClient alloc] init];
        [client searchNetService];
    }
}

- (void)lookStatus:(NSTimer*)timer{
    // 常にバックグラウンドで監視するメソッド
    if(_serverMode == 1)
    {
        status = server.status;
        [statusLabel setText:status];
        if (status == @"Now Receive" || status == @"Now Read Data") {
            resultText = @"( ﾟ⊖ﾟ)！";
            [resultLabel setText:resultText];
        }
        if (status == @"Finish Read Data") {
            resultText = server.receiveString;
            resultLabel.textColor = [UIColor redColor];
            [resultLabel setText:resultText];
            clientButton.userInteractionEnabled = YES;
            clientButton.backgroundColor = [UIColor redColor];
            [clientButton addTarget:self
                             action:@selector(sendDataAsServer)
                   forControlEvents:UIControlEventTouchUpInside];
        }
        if (status == @"Finish Send Data") {
            clientButton.backgroundColor = [UIColor whiteColor];
            resultLabel.textColor = [UIColor greenColor];
            resultText = @"＼ ( ˘⊖˘)／";
            [resultLabel setText:resultText];
        }
    }
    else if (_clientMode == 1)
    {
        status = client.status;
        [statusLabel setText:status];
        if (status == @"Waiting...") {
            clientButton.userInteractionEnabled = YES;
            clientButton.backgroundColor = [UIColor redColor];
            [clientButton addTarget:self
                             action:@selector(sendDataAsClient)
                   forControlEvents:UIControlEventTouchUpInside];
        }
        if (status == @"Finish Send Data") {
            clientButton.backgroundColor = [UIColor whiteColor];
            resultLabel.textColor = [UIColor greenColor];
            resultText = @"＼ (☝ ՞ਊ ՞)☝ ／";
            [resultLabel setText:resultText];
        }
        if (status == @"Finish Read Data") {
            resultText = client.receiveString;
            resultLabel.textColor = [UIColor redColor];
            [resultLabel setText:resultText];
            clientButton.userInteractionEnabled = YES;
            clientButton.backgroundColor = [UIColor redColor];
            [clientButton addTarget:self
                             action:@selector(sendDataAsClient)
                   forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else
    {
        status = @"Bonjour!!";
        [statusLabel setText:status];
        
    }
}

- (void)sendDataAsServer{
    [server sendData:clientButtonText];
    clientButton.userInteractionEnabled = NO;
}

- (void)sendDataAsClient{
    // データ送るよメソッド
    [client sendData:clientButtonText];
    clientButton.userInteractionEnabled = NO;
}

- (void)buttonDidPush:(id)sender{
    // ボタンテストメソッド
	NSLog(@"buttonPush");
}

@end
