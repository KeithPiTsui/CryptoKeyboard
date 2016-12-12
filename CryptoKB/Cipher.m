//
//  Cipher.m
//  Cryptogram
//
//  Created by Pi on 02/10/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

#import "Cipher.h"

@implementation Cipher

- (NSString*) name {
    NSString* cipherName = NSStringFromClass([self class]);
    if (_name != nil ) {
        cipherName = _name;
    }
    return cipherName;
}

- (CipherType) type {
    return CipherTypeRaw;
}

- (NSNumber*) typeNumber {
    return [NSNumber numberWithUnsignedInteger: self.type];
}

- (NSString*) encryptMessage: (NSString*) message
                     withKey: (NSString*) key
             andMayHaveError: (NSError**) error{
    return [NSString stringWithFormat:@"Message:%@\n Key:%@", message, key];
}

- (NSString*) decryptMessage: (NSString*) message
                     withKey: (NSString*) key
             andMayHaveError: (NSError**) error{
    return [NSString stringWithFormat:@"Message:%@\n Key:%@", message, key];
}

- (BOOL) validateKey: (NSString*) key
     andMayHaveError:(NSError **)error{
    return YES;
}

@end
