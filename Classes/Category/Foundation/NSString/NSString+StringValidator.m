//
//  NSString+StringValidator.m
//  Example
//
//  Created by B.Dog on 16/5/20.
//  Copyright © 2016年 JKSoft. All rights reserved.
//

#import "NSString+StringValidator.h"

@implementation NSString (StringValidator)

+ (BOOL)isNilOrEmpty:(NSString*)input {
    return [input isKindOfClass:[NSNull class]] || !input || [input isEmpty];
}

- (BOOL)isEmpty {
    // 移除空格
    NSString* text = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return (!text.length);
}

- (BOOL)isEmail {
    NSString* regex = @"[a-zA-Z0-9.\\-_]{2,32}@[a-zA-Z0-9.\\-_]{2,32}\\.[A-Za-z]{2,4}";
    NSPredicate* regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

/**
 *  宽泛
 */
- (BOOL)isPhoneNumber {
    NSString* regex = @"^[1][0-9]{10}$";
    NSPredicate* regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regExPredicate evaluateWithObject:self];
}

/**
 *  国内手机号 比较精确
 *  中国移动 139，138，137，136，135，134，147，188，187，184，183，182，1705，178，159，158，157，152，151，150，1391，1390
 *  中国联通 186，185，176，145，156，155，132，131，130，1860，1709
 *  中国电信 189，181，180，177，153，133，1890，1330，1700
 */
- (BOOL)isMobileTelephone {
    //手机号以13， 15，18， 14，17开头，八个 \d 数字字符
    NSString *phoneRegex = @"[1][34578][0-9]{9}";
    //@"^((14[0-9])|(17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

// 中国移动
- (BOOL)isChinaMobilePhoneNumber {
    NSString *regex = @"^1(3[456789]|4[7]|5[012789]|7[8]|8[23478])[0-9]{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

// 中国联通
- (BOOL)isChinaUnicomPhoneNumber {
    NSString *regex = @"^1(3[012]|4[5]|5[56]|7[6]|8[56])[0-9]{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

// 中国电信
- (BOOL)isChinaTelecomPhoneNumber {
    NSString *regex = @"^1(33|53|77|8[019])[0-9]{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isChineseName {
    NSString* regex = @"[\\u4E00-\\u9FA5]{2,5}(?:·[\\u4E00-\\u9FA5]{2,5})*";
    NSPredicate* regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isIdentityCardNumber {
    NSString* regex = @"\\d{17}[\\d|xX]|\\d{15}";
    NSPredicate* regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isIntegerAppearance {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAllowsFloats:NO];
    if ([formatter numberFromString:self]) {
        return YES;
    }
    return NO;
}

- (BOOL)isNumericAppearance {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    // setAllowsFloats defaut is YES
    if ([formatter numberFromString:self]) {
        return YES;
    }
    return NO;
}

- (BOOL)isFloatAppearance {
    BOOL isNumeric = [self isNumericAppearance];
    return isNumeric ? ![self isIntegerAppearance] : NO;
}

- (BOOL)isValidateVerifyCodeWithLimits:(int)limits {
    if (self.length != limits) {
        return NO;
    }
    NSString *regex = [NSString stringWithFormat:@"^\\d{%d}", limits];
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [bankCardPredicate evaluateWithObject:self];
}

- (BOOL)isValidateStringNumbersLettersMinLength:(int)minLength maxLength:(int)maxLength {
    if (self.length < minLength ||
        self.length > maxLength) {
        return NO;
    }
    NSString *passWordRegex = [NSString stringWithFormat:@"^[a-zA-Z0-9]{%d,%d}+$", minLength, maxLength];
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:self];
}

- (BOOL)isValidateCarNo {
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:self];
}

- (BOOL)isHttpURL {
    NSString* regex = @"^((https|http|file|ftp|rtsp|mms)?:\\/\\/)[^\\s]+";
    NSPredicate* regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:[self lowercaseString]];
}

- (BOOL)isOverMinLength:(NSUInteger)length {
    return (self.length >= length);
}

- (BOOL)isUnderMaxLength:(NSUInteger)length {
    return (self.length <= length);
}

- (BOOL)isOverMinLength:(NSUInteger)min underMaxLength:(NSUInteger)max {
    return ([self isOverMinLength:min] && [self isUnderMaxLength:max]);
}

- (BOOL)isMatchRegex:(NSString*)regex {
    NSPredicate* regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isChinese {
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

// 表情
- (BOOL)stringContainsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     returnValue = YES;
                     
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue =YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (NSError*)validateIPv4Address {
    NSArray* split = [self componentsSeparatedByString:@"."];
    if (split.count != 4) {
        return [NSError errorWithDomain:@""
                                   code:0
                               userInfo:@{ NSLocalizedDescriptionKey :
                                               @"Exactly 4 octets must be provided."}];
    }
    
    for (NSString* octet_string in split) {
        int octet = [octet_string intValue];
        if (octet < 0 || octet > 255) {
            return [NSError errorWithDomain:@""
                                       code:0
                                   userInfo:@{ NSLocalizedDescriptionKey :
                                                @"Octets must be in the range of 0 to 255."}];
        }
    }
    
    int fourth_octet = [[split objectAtIndex:3] intValue];
    if (fourth_octet == 0 || fourth_octet == 255) {
        return [NSError errorWithDomain:@""
                                   code:0
                               userInfo:@{
                                          NSLocalizedDescriptionKey :
                                              @"Fourth octet cannot be 0 or 255."}];
    }
    
    return nil;
}

- (NSError*)validateIPv6Address {
    NSString* address = [self copy];
    NSArray* first_split = [self componentsSeparatedByString:@":"];
    
    // First, expand the address to its full notation
    // (Replace :: with :0000: * missing hextets
    if ([address containsString:@"::"]) {
        if (first_split.count >= 8) {
            return [NSError errorWithDomain:@""
                                       code:0
                                   userInfo:@{
                                              NSLocalizedDescriptionKey :
                                                  @"No more than 8 hextets can be provided."}];
        }
        else {
            unsigned long omitted_octets = 8 - first_split.count;
            NSString* replacement_octets = @":0000";
            for (int i = 0; i < omitted_octets; i++) {
                replacement_octets = [replacement_octets stringByAppendingString:@":0000"];
            }
            replacement_octets = [replacement_octets stringByAppendingString:@":"];
            
            address = [address stringByReplacingOccurrencesOfString:@"::" withString:replacement_octets];
        }
    }
    
    NSArray* split = [address componentsSeparatedByString:@":"];
    if (split.count > 8) {
        return [NSError errorWithDomain:@""
                                   code:0
                               userInfo:@{
                                          NSLocalizedDescriptionKey :
                                            @"No more than 8 hextets can be provided."}];
    }
    else if (split.count != 8) {
        return [NSError errorWithDomain:@""
                                   code:0
                               userInfo:@{
                                          NSLocalizedDescriptionKey :
                                              @"Address is too short. Use '::' to omit 0000."}];
    }
    
    for (NSString* hextet_string in split) {
        NSPredicate* validHex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9A-Fa-f]{0,4}"];
        if ([validHex evaluateWithObject:hextet_string]) {
        }
        else {
            return [NSError errorWithDomain:@""
                                       code:0
                                   userInfo:@{
                                              NSLocalizedDescriptionKey :
                                                  @"Invalid hexedecimal value."}];
        }
    }
    
    return nil;
}

- (NSError*)validateTTL {
    long long ttl = [self longLongValue];
    if (ttl < 0 || ttl > 2147483647) {
        return [NSError errorWithDomain:@""
                                   code:0
                               userInfo:@{
                                          NSLocalizedDescriptionKey :
                                              @"TTL must be between 0 and 2147483647."}];
    }
    return nil;
}



@end
