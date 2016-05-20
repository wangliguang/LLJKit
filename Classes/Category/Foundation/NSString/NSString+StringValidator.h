//
//  NSString+StringValidator.h
//  Example
//
//  Created by B.Dog on 16/5/20.
//  Copyright © 2016年 JKSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringValidator)

+ (BOOL)isNilOrEmpty:(NSString*)input;
- (BOOL)isEmpty;

- (BOOL)isEmail;

// 国内手机号 简单匹配
- (BOOL)isPhoneNumber;
// 国内手机号 比较精确
- (BOOL)isMobileTelephone;
// 中国移动 不包括虚拟运营商专属号段
- (BOOL)isChinaMobilePhoneNumber;
// 中国联通 不包括虚拟运营商专属号段
- (BOOL)isChinaUnicomPhoneNumber;
// 中国电信 不包括虚拟运营商专属号段
- (BOOL)isChinaTelecomPhoneNumber;

// 身份证号
- (BOOL)isIdentityCardNumber;

// 整形字符串
- (BOOL)isIntegerAppearance;
// 浮点数字符串
- (BOOL)isFloatAppearance;
// 数字字符串
- (BOOL)isNumericAppearance;

// 验证码 
- (BOOL)isValidateVerifyCodeWithLimits:(int)limits;
// 用户名 密码
- (BOOL)isValidateStringNumbersLettersMinLength:(int)minLength maxLength:(int)maxLength;
// 车牌号验证
- (BOOL)isValidateCarNo;

- (BOOL)isHttpURL;

- (BOOL)isOverMinLength:(NSUInteger)length;
- (BOOL)isUnderMaxLength:(NSUInteger)length;
- (BOOL)isOverMinLength:(NSUInteger)min underMaxLength:(NSUInteger)max;
// 正则
- (BOOL)isMatchRegex:(NSString*)regex;

// 判断是否为汉字
-(BOOL)isChinese;
// 表情
- (BOOL)stringContainsEmoji;

#pragma mark - 有疑义
// 中文名？2-5位么？
- (BOOL)isChineseName;
// 这些都是什么鬼？路由地址？
- (NSError*)validateIPv4Address;
- (NSError*)validateIPv6Address;
- (NSError*)validateTTL;
@end
