//
//  ButtonView.h
//  Bonjour02
//
//  Created by もさお on 12/11/06.
//  Copyright (c) 2012年 もさお. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonjourServer.h"
#import "BonjourClient.h"

@interface MosaoView : UIView
{
    int     _serverMode;    // サーバーモードの認識
    int     _clientMode;    // クライアントモードの認識
    
    UILabel     *label;         // どっちで起動しているか表示するラベル
    NSString    *labelText;     // labelのテキスト
    
    UIButton    *serverButton;      // サーバー起動ボタン
    NSString    *serverButtonText;  // サーバー起動ボタンのテキスト
    
    UIButton    *clientButton;      // クライアント起動ボタン
    NSString    *clientButtonText;  // クライアント起動ボタンのテキスト
    
    UILabel     *resultLabel;   // くだらないでっかい文字のラベル(結果とかの表示)
    NSString    *resultText;    // resultLabelのテキスト
    
    NSTimer     *timer;         // バックグラウンドで監視するためのタイマー
    UILabel     *statusLabel;   // ログ
    NSString    *status;        // ログのテキスト
    
    BonjourServer   *server;    // BonjourServerクラスのオブジェクト
    BonjourClient   *client;    // BonjourClientクラスのオブジェクト
}

@end
