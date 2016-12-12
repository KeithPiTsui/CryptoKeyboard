//
//  CipherManager.h
//  Cryptogram
//
//  Created by Pi on 02/10/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cipher.h"

@interface CipherManager : NSObject

@property(nonatomic, strong, readonly) NSDictionary<NSNumber*, Cipher*>* registeredCiphers;

+ (instancetype) sharedInstance;

- (NSString*) encryptMessage: (NSString*) message
              withCipherType: (CipherType) cipherType
                      andKey: (NSString*) key
             andMayHaveError: (NSError**) error;

- (NSString*) decryptMessage: (NSString*) message 
              withCipherType: (CipherType) cipherType
                      andKey: (NSString*) key
             andMayHaveError: (NSError**) error;

- (BOOL) validateKey: (NSString*) key
        ofCipherType: (CipherType) type
     andMayHaveError: (NSError**) error;

@end
