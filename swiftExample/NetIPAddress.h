//
//  NetIPAddress.h
//  swiftExample
//
//  Created by 魏凌云 on 2024/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetIPAddress : NSObject

+ (NSString *)getLocalIPAddress:(BOOL)preferIPv4;

@end

NS_ASSUME_NONNULL_END
