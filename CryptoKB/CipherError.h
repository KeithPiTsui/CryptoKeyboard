//
//  CipherError.h
//  Cryptogram
//
//  Created by Pi on 02/10/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const CipherErrorDomain;

typedef NS_ENUM(NSInteger, CipherErrorCode) {
    CipherErrorCodeNoError,
    CipherErrorCodeKeyMalformed
};

@interface CipherError : NSObject

@end
