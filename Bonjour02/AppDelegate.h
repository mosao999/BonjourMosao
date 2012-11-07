//
//  AppDelegate.h
//  Bonjour02
//
//  Created by もさお on 12/11/05.
//  Copyright (c) 2012年 もさお. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    // ビューコントローラ
    MyViewController*           _myVC;
    
    // ナビゲーションコントローラ
    UINavigationController*     _navi;
}


@property (strong, nonatomic) UIWindow *window;

@end
