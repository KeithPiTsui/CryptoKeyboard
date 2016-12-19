//
//  AppHelper.h
//  iStick
//
//  Created by Ke SpringOx on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppHelper : NSObject

+ (AppHelper *)shareHelper;

+(BOOL)getiDeviceTotalSpace:(int64_t*)totalSpaceSize andFreeSpace:(int64_t*)freeSpaceSize;

@end
