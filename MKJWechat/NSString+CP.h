//
//  NSString+CP.h
//  iCloudPlaySupport
//
//  Created by mac on 13-7-29.
//  Copyright (c) 2013年 XunLei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CP)

+ (BOOL)isValidateMobile:(NSString *)mobile;

+ (BOOL)isValidateEmail:(NSString *)email;

+ (NSString *)formatTimeBySecond:(NSInteger)second;

+ (BOOL)isEmptyString:(NSString*)aString;

- (NSInteger)versionNumberValue;

- (NSString *)md5Encode;
- (NSString *)md516Encode;
+ (NSString*)stringWithDateIntervalFromBase:(unsigned long long)interval;
+ (NSString*)stringWithDateInterval:(unsigned long long)interval;
+ (NSString*)stringWithFileSize:(unsigned long long)size;

- (BOOL)containChineseWord;

- (BOOL)containCapitalWord;

- (BOOL)containNumeralWord;

- (BOOL)containBlankSpace;

- (BOOL)includeString:(NSString *)string;

- (BOOL)isLegalUrLString;

//如果只输入www.baidu.com，该方法也会认为不合法。
//如果确认url的协议，则使用此方法。
- (BOOL)isLegalURL;

// 从一片内存数据中得到一个十六进制字符串
+ (NSString*)hexStringFromBytes:(const void*)data withLength:(NSUInteger)length;
- (NSData*)hexStringToDataBytes;
 

//用于过滤字符串中的网络字符，webStrings为网络字符列表，每一个元素都是NSString类型
- (NSString *)filterWebString:(NSArray *)webStrings;

//清除非法字符串
- (NSString *)clearIllegalCharacter;

- (NSString*) base64Encode;
- (NSString *) base64Decode;

// 这个才是base64的正确使用方式  同时在NSData的扩展里头有encode方法

- (NSData*)base64Decode2;


- (NSString *)encodeString;
- (NSString *)decodeString;

// 确保上报的字段合法（中文字符加%Encode，字段长度255截取）
- (NSString *)legalReportFieldString;

// 从字符串中计算出urlhash
- (int64_t)urlHashFromString;

// 获取系统时间戳
+ (NSString *)timeStampAtNow;

//去掉前后空格和换行符
- (NSString *)trim;
//新版获取字符串宽度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

// 新增一个方法获取Data时间戳
+(NSString *)internalFromCreatTime:(NSString *)creatTimeString formatString:(NSString *)formatString;
// 新增一个方法拼接优惠券的时间
+ (NSString *)couponDeadlineTimeConvertBeginTS:(long long)beginTS endTD:(long long)endTS;

//- (NSString*)rsaDecrypt;
//- (NSString*)rsaEncrypt;

/**
 *  RSA解密算法
 *  (N,e)是公钥，(N,d)是私钥
 *
 *  @param strE e值
 *  @param strD d值
 *  @param strN N值
 *
 *  @return 返回解密之后的字符串
 */
//- (NSString *)rsaDecryptWithValueE:(NSString *)strE valueD:(NSString *)strD valueN:(NSString *)strN;

/**
 *  RSA加密算法
 *  (N,e)是公钥，(N,d)是私钥
 *
 *  @param strE e值
 *  @param strN N值
 *
 *  @return 返回加密之后的字符串
 */
//- (NSString *)rsaEncryptWithValueE:(NSString *)strE valueN:(NSString *)strN;

@end
