//
//  Keychain.m
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 14..
//  Copyright © 2017년 baecheese. All rights reserved.
//

#import "Keychain.h"

@implementation Keychain

- (BOOL)saveWithKey:(NSString *)key andData:(NSData *)data
{
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount : key,
                            (__bridge id)kSecValueData : data};
    SecItemDelete((__bridge CFDictionaryRef)(query));
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)(query), nil);
    
    return status == noErr;
}

/** key: "password" */
- (NSData *)loadWithKey:(NSString *)key
{
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge NSString *)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount : key,
                            (__bridge id)kSecReturnData : @YES,
                            (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne};
    
    CFTypeRef dataTypeRef = nil;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)(query), &dataTypeRef);
    
    if (status == noErr)
    {
        return ( __bridge_transfer NSData *)dataTypeRef;
    }
    
    return nil;
}

- (BOOL)deleteWithKey:(NSString *)key
{
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount : key};
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)(query));
    
    return status == noErr;
}

- (BOOL)clear
{
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword};
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)(query));
    
    return status == noErr;
}

@end
