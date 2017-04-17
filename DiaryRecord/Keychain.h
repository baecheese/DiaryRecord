//
//  Keychain.h
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 14..
//  Copyright © 2017년 baecheese. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject

- (BOOL)saveWithKey:(NSString *)key andData:(NSData *)data;
- (NSData *)loadWithKey:(NSString *)key;
- (BOOL)deleteWithKey:(NSString *)key;
- (BOOL)clear;

@end
