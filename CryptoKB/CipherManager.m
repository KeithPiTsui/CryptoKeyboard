//
//  CipherManager.m
//  Cryptogram
//
//  Created by Pi on 02/10/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

#import "CipherManager.h"

@interface CipherManager()
@property(nonatomic, strong) NSMutableDictionary<NSNumber*, Cipher*>* ciphers;
@end

@implementation CipherManager
+ (instancetype) sharedInstance {
    static CipherManager* anInstance = nil;
    @synchronized (self) {
        if (anInstance == nil) {
            anInstance = [[CipherManager alloc] init];
        }
    }
    return anInstance;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self.ciphers = [NSMutableDictionary<NSNumber*, Cipher*> dictionary];
        [self loadCiphers];
    }
    return self;
}

- (void) loadCiphers {
    NSBundle* resourceBundle = [NSBundle mainBundle];
    if( resourceBundle != nil ) {
        NSString* filePath = [resourceBundle pathForResource:@"CipherRegistionList" ofType:@"json"];
        NSData* jsonData =[NSData dataWithContentsOfFile: filePath];
        NSError* err;
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData: jsonData
                                                                 options: NSJSONReadingAllowFragments
                                                                   error: &err];
        for (NSString* cipherID in jsonDict.allKeys) {
            NSDictionary<NSString*, NSString*>* cipherInfo = jsonDict[cipherID];
            Cipher* aCipher = [self cipherWithCipherInfo: cipherInfo];
            if (aCipher != nil) {
                self.ciphers[aCipher.typeNumber] = aCipher;
            }
        }
    }
}

- (Cipher*) cipherWithCipherInfo: (NSDictionary<NSString*, NSString*>*) cipherInfo {
    Cipher* retCipher = nil;
    NSString* cipherName = cipherInfo[@"CipherName"];
    NSString* cipherDescription = cipherInfo[@"CipherDescription"];
    NSString* cipherKeyDescription = cipherInfo[@"CipherKeyDescription"];
    NSString* cipherClassName = cipherInfo[@"CipherClassName"];
    NSString* cipherKeyRegex = cipherInfo[@"CipherKeyValidateRegex"];
    NSString* cipherIconName = cipherInfo[@"CipherIconName"];
    
    Class cipherClass = NSClassFromString(cipherClassName);
    if (cipherClass != nil) {
        retCipher = [cipherClass new];
        retCipher.name = cipherName;
        retCipher.cipherDescription = cipherDescription;
        retCipher.keyDescription = cipherKeyDescription;
        retCipher.keyValidateRegex = cipherKeyRegex;
        retCipher.cipherIconName = cipherIconName;
    }
    return retCipher;
}

- (Cipher*) cipherWithCipherClassName: (NSString*) name {
    Cipher* retCipher = nil;
    Class cipherClass = NSClassFromString(name);
    if (cipherClass != nil) {
        retCipher = [cipherClass new];
    }
    return retCipher;
}

- (NSString*) encryptMessage: (NSString*) message
              withCipherType: (CipherType) cipherType
                      andKey: (NSString*) key
             andMayHaveError: (NSError**) error{
    NSString* encryptedMessage = nil;
    NSNumber* cipherTypeNumber = [NSNumber numberWithUnsignedInteger: cipherType];
    if (cipherTypeNumber != nil) {
        Cipher* cipher = self.ciphers[cipherTypeNumber];
        if (cipher != nil) {
            encryptedMessage = [cipher encryptMessage: message withKey: key andMayHaveError:error];
        }
    }
    return encryptedMessage;
}

- (NSString*) decryptMessage: (NSString*) message
              withCipherType: (CipherType) cipherType
                      andKey: (NSString*) key
             andMayHaveError: (NSError**) error{
    NSString* decryptedMessage = nil;
    NSNumber* cipherTypeNumber = [NSNumber numberWithUnsignedInteger: cipherType];
    if (cipherTypeNumber != nil) {
        Cipher* cipher = self.ciphers[cipherTypeNumber];
        if (cipher != nil) {
            decryptedMessage = [cipher decryptMessage: message withKey: key andMayHaveError:error];
        }
    }
    return decryptedMessage;
}

- (BOOL) validateKey: (NSString*) key
        ofCipherType: (CipherType) type
     andMayHaveError:(NSError **)error{
    BOOL retCode = NO;
    NSNumber* cipherTypeNumber = [NSNumber numberWithUnsignedInteger: type];
    if (cipherTypeNumber != nil) {
        Cipher* cipher = self.ciphers[cipherTypeNumber];
        if (cipher != nil) {
            retCode = [cipher validateKey: key andMayHaveError:error];
        }
    }
    return retCode;
}

- (NSDictionary*) registeredCiphers {
    return [NSDictionary dictionaryWithDictionary:self.ciphers];
}

@end























