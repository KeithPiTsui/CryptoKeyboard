//
//  SettingHelper.m
//  CryptoKeyboard
//
//  Created by Pi on 19/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

#import "SettingHelper.h"
#import <UIKit/UIKit.h>

@implementation SettingHelper
+ (void) gotoSetting {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Keyboard/KEYBOARDS"]];
}
@end
