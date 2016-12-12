//
//  CaesarCipher.m
//  Cryptogram
//
//  Created by Pi on 02/10/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

#import "CaesarCipher.h"

@interface CaesarCipher()
@property(nonatomic, strong) NSString* letters;
@end

@implementation CaesarCipher

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self.letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    }
    return self;
}

- (CipherType) type {
    return CipherTypeCaesar;
}

- (NSString*) encryptMessage: (NSString*) message
                     withKey: (NSString*) key
             andMayHaveError: (NSError**) error{
    
    NSInteger keyNum = [key integerValue];
    if (keyNum == 0) {
        return message;
    }
    
    NSMutableString* transformedMessage = [NSMutableString string];
    for (NSUInteger i = 0; i < message.length; i ++) {
        NSString* subStr = [message substringWithRange: NSMakeRange(i, 1)];
        NSRange range = [self.letters rangeOfString:subStr];
        if (range.location != NSNotFound) {
            NSUInteger newLocation = (range.location + keyNum) % self.letters.length;
            subStr = [self.letters substringWithRange: NSMakeRange(newLocation, 1)];
        }
        [transformedMessage appendString: subStr];
    }
    
    return transformedMessage;
}

- (NSString*) decryptMessage: (NSString*) message
                     withKey: (NSString*) key
             andMayHaveError: (NSError**) error{
    
    NSInteger keyNum = [key integerValue];
    if (keyNum == 0) {
        return message;
    }
    
    NSMutableString* transformedMessage = [NSMutableString string];
    for (NSUInteger i = 0; i < message.length; i ++) {
        NSString* subStr = [message substringWithRange: NSMakeRange(i, 1)];
        NSRange range = [self.letters rangeOfString:subStr];
        if (range.location != NSNotFound) {
            NSInteger newLocation = range.location - keyNum;
            NSInteger remain = labs(newLocation);
            if (remain > self.letters.length) {
                remain %= self.letters.length;
            }
            
            if (newLocation < 0) {
                newLocation = self.letters.length - remain;
            } else {
                newLocation = remain;
            }
            
            subStr = [self.letters substringWithRange: NSMakeRange(newLocation, 1)];
        }
        [transformedMessage appendString: subStr];
    }
    
    return transformedMessage;
    
}

- (BOOL) validateKey: (NSString*) key
     andMayHaveError:(NSError **)error{
    return [key integerValue] == 0;
}

@end
