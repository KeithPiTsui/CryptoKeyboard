//
//  Cipher.h
//  Cryptogram
//
//  Created by Pi on 02/10/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CipherType) {
    CipherTypeRaw,
    CipherTypeCaesar
};

@interface Cipher : NSObject

@property(nonatomic, strong) NSString* registeredID;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* keyDescription;
@property(nonatomic, strong) NSString* cipherDescription;
@property(nonatomic, strong) NSString* keyValidateRegex;
@property(nonatomic, strong) NSString* cipherIconName;

@property(nonatomic, assign, readonly) CipherType type;
@property(nonatomic, strong, readonly) NSNumber* typeNumber;

- (NSString*) encryptMessage: (NSString*) message
                     withKey: (NSString*) key
             andMayHaveError: (NSError**) error;

- (NSString*) decryptMessage: (NSString*) message
              withKey: (NSString*) key
             andMayHaveError: (NSError**) error;

- (BOOL) validateKey: (NSString*) key
     andMayHaveError: (NSError**) error;

@end
