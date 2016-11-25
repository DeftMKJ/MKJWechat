//
//  NSString+CP.m
//  iCloudPlaySupport
//
//  Created by mac on 13-7-29.
//  Copyright (c) 2013年 XunLei. All rights reserved.
//

#import "NSString+CP.h"
#import "NSArray+CP.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CP)

+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}


+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isEmptyString:(NSString*)aString
{
	return (aString == nil)||([aString isEqualToString:@""]);
}

// 将秒数时间转为00:00:00的形式
+ (NSString *)formatTimeBySecond:(NSInteger)second
{
    int diff = second;
    
    int iHour = diff / (60.0f * 60.0f);;
    
    diff = diff % (60 * 60);
    
    int iMinute = diff / 60.0f;
    
    int iSecond = diff % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", iHour, iMinute, iSecond];
}



- (NSInteger)versionNumberValue
{
    const char * ver_str = [self UTF8String];
    const char* flag = ver_str;
    
    int result = 0;
    int i = 4;
    int tem = 0;
    
    while (i--) {
        tem = atoi(flag);
        result = result | tem;
        if (i == 0) {
            break;
        }
        result = result<<8;
        do {
            flag++;
        } while (tem /= 10);
        flag++;
    }
    return result;
}

- (NSString *)md5Encode
{
    
    NSString *toEncode = self;
	const char *cStr = [toEncode UTF8String];
    unsigned char result[16] = {0};
    
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    
    return [NSString stringWithFormat:
            
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
            
			];
}
- (NSString *)md516Encode
{
    
    NSString *toEncode = self;
	const char *cStr = [toEncode UTF8String];
    unsigned char result[16] = {0};
    
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    
    return [NSString stringWithFormat:
            
			@"%02x%02x%02x%02x%02x%02x%02x%02x",
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11]];
}

+ (NSString*)stringWithDateIntervalFromBase:(unsigned long long)interval//单位是秒
{
    unsigned long long time = [[NSDate date]timeIntervalSince1970]-interval;
    if (time == 0)
    {
        return @"";
    }
    if(time<60)//不足一分钟
    {
        return [NSString stringWithFormat:@"%zd秒", time];
    }
    if (time < 60*60)//不足一个小时
    {
        return [NSString stringWithFormat:@"%zd分", time/60];
    }
    else if(time < 24*60*60)//不足一天
    {
        NSInteger hours = (int)time/3600;
        return [NSString stringWithFormat:@"%zd小时", hours];
    }
    else if(time <30*24*60*60)//超过一天,不足一个月
    {
        NSInteger days = (int)time/86400;
        return [NSString stringWithFormat:@"%zd天", days];
    }
    else if(time<365*30*24*60*60)//超过一个月，不足一年
    {
        NSInteger months = (int)time/(24*30*3600);
        return [NSString stringWithFormat:@"%zd月", months];
    }
    else //超过一年。
    {
        NSInteger years = (int)time/(365*24*30*3600);
        return [NSString stringWithFormat:@"%zd年", years];
    }
}

+ (NSString*)stringWithDateInterval:(unsigned long long)interval//单位是秒
{
    if (interval/60 < 60)//不足一个小时,60分钟以内
    {
        return [NSString stringWithFormat:@"%zd分", interval/60];
    }
    else if(interval/3600 < 24)//不足一天
    {
        NSInteger hours = (int)interval/3600;
        NSInteger minutes = (interval %3600)/60;
        if (minutes <1)
        {
            minutes = 1;
        }
        return [NSString stringWithFormat:@"%zd小时%zd分", hours,minutes];
    }
    else //超过一天
    {
        NSInteger days = (int)interval/86400;
        NSInteger hours = (interval %86400)/3600;
        if (hours <1)
        {
            hours = 1;
        }
        return [NSString stringWithFormat:@"%zd天%zd小时", days,hours];
    }
}
+ (NSString*)stringWithFileSize:(unsigned long long)size
{
    if (size == 0)
    {
        return @"无缓存";
    }
    else if (size < 1000)
    {
        return [NSString stringWithFormat:@"%lluB", size];
    }
    else if(size < 1024 * 1024)
    {
        return [NSString stringWithFormat:@"%.2fKB", size / 1024.0];
    }
    else if(size < 1024 * 1024 * 1024)
    {
        return [NSString stringWithFormat:@"%.2fMB", size / (1024.0 * 1024)];
    }
    else if(size < 1024 * 1024 * 1024 * 1024ull)
    {
        return [NSString stringWithFormat:@"%.2fGB", size / (1024.0 * 1024 * 1024)];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2fTB", size / (1024.0 * 1024 * 1024 * 1024)];
    }
    
}

- (BOOL)containChineseWord
{
    for (NSInteger index = 0; index < self.length; index++)
    {
        unichar indexChar = [self characterAtIndex:index];
        if (indexChar > 0xE0)
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containNumeralWord
{
    for (NSInteger index = 0; index < self.length; index++)
    {
        unichar indexChar = [self characterAtIndex:index];
        if (indexChar >= '0' && indexChar <= '9')
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containCapitalWord
{
    for (NSInteger index = 0; index < self.length; index++)
    {
        unichar indexChar = [self characterAtIndex:index];
        if (indexChar >= 'A' && indexChar <= 'Z')
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)includeString:(NSString *)string
{

    NSRange range = [self rangeOfString:string];
    if (range.location!=NSNotFound)
    {
        return YES;
    }else{
    
        return NO;
    }
}

- (BOOL)containBlankSpace
{
    for (NSInteger index = 0; index < self.length; index++)
    {
        unichar indexChar = [self characterAtIndex:index];
        if (indexChar == ' ')
        {
            return YES;
        }
    }
    return NO;
    
}

//自己的判断。
- (BOOL)isLegalUrLString
{
    
    NSArray * arStr = [self componentsSeparatedByString:@"."];
    //至少包含一个"."
    if (arStr.count < 2)
    {
        NSLog(@"URL应该至少包含一个 . ");
        return NO;
    }
    
    //第一个"."之前不能为空
    NSString * firstStr = [arStr objAtIndex:0];
    if ([NSString isEmptyString:firstStr])
    {
        NSLog(@"URL的第一个.之前不应该为空 ");
        return NO;
    }
    
    
    //最后一个"."之后不能为空
    NSString * lastStr = [arStr lastObject];
    if ([NSString isEmptyString:lastStr])
    {
        NSLog(@"URL的最后一个.之后不应该为空 ");
        return NO;
    }
    return YES;
}

//如果只输入www.baidu.com，该方法也会认为不合法。
//如果确认url的协议，则使用此方法。
- (BOOL)isLegalURL
{
    NSURL *candidateURL = [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // WARNING > "test" is an URL according to RFCs, being just a path
    
    NSLog(@"URL string : %@, scheme : %@, host : %@", self, candidateURL.scheme, candidateURL.host);
    
    // RFC定义的合法URL
    BOOL legalInRFC = candidateURL && candidateURL.scheme && candidateURL.host;
    
    // 额外条件
    if (legalInRFC && [self rangeOfString:@"."].length > 0) {
        return YES;
    }
    
    return NO;
}

// 从一片内存数据中得到一个十六进制字符串
+ (NSString*)hexStringFromBytes:(const void*)data withLength:(NSUInteger)length
{
    // 查表
    const unsigned char t[16] = "0123456789ABCDEF";
    unsigned char* dataChar = (unsigned char*)data;
    // 多一位用来存放0
    NSUInteger dstLen = 2*length + 1;
    unsigned char* dstString = (unsigned char*)malloc(dstLen);
    memset(dstString, 0, dstLen);
    int j = 0;
    for (int i = 0; i < length; i++)
    {
        dstString[j++] = t[dataChar[i]>>4];
        dstString[j++] = t[dataChar[i]&0x0F];
    }
    dstString[j] = '\0';
    NSString* strRtn =[ NSString stringWithUTF8String:(const char*)dstString];
    if (dstString)
    {
        free(dstString);
        dstString = NULL;
    }
    return strRtn;
}

- (NSData*)hexStringToDataBytes
{
    NSMutableData* data = [NSMutableData data];
    int idx = 0;
    for (idx = 0; idx < self.length; idx+=2)
    {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
        
    }
    return data;
}


- (NSString *)filterWebString:(NSArray *)webStrings
{
    NSLog(@"%s, %@", __func__, self);
    
    if (self == nil) {
        return nil;
    }
    
    if (webStrings == nil) {
        return self;
    }
    
    NSString *resultString = self;
    int i = 0;
    for (i = webStrings.count - 1; i >= 0; i--)
    {
        id element = [webStrings objAtIndex:i];
        if ([element isKindOfClass:[NSString class]]) {
            resultString = [resultString stringByReplacingOccurrencesOfString:element withString:@""];
        }
        else
        {
            continue;
        }
    }
    while (1) {
        //去掉开头的点
        if ([resultString hasPrefix:@"."]) {
            resultString = [resultString substringFromIndex:1];
        }
        else
        {
            break;
        }
    }

    if ([resultString hasPrefix:@"-"]) {
        resultString = [resultString substringFromIndex:1];
    }
    NSLog(@"after filter:%@", resultString);
    return resultString;
}

//清除非法字符串
- (NSString *)clearIllegalCharacter
{
    if (self == nil) {
        return nil;
    }
    
    NSString *resultString = self;
    
    resultString = [resultString stringByReplacingOccurrencesOfString:@"<" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@">" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"/" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"\\" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"|" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@":" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"\"" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"*" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"?" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"\t" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"\r" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"\n" withString:@"□"];
    
    return resultString;
}

- (NSString*) base64Encode
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    
    int length = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    if (lentext < 1)
        return @"";
    
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [[self dataUsingEncoding:NSUTF8StringEncoding]bytes];
    
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        ixtext += 3;
        charsonline += 4;
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

- (NSString *) base64Decode
{

    return [[NSString alloc]initWithData:[self base64Decode2] encoding:NSUTF8StringEncoding];
}
- (NSData*)base64Decode2
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (self == nil) {
        return nil;
    }
    
    ixtext = 0;
    tempcstring = (const unsigned char *)[self UTF8String];
    lentext = [self length];
    theData = [NSMutableData dataWithCapacity: lentext];
    ixinbuf = 0;
    
    while (true) {
        if (ixtext >= lentext){
            break;
        }
        ch = tempcstring [ixtext++];
        flignore = false;
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true;
        }
        
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                } else {
                    ctcharsinbuf = 2;
                }
                ixinbuf = 3;
                flbreak = true;
            }
            inbuf [ixinbuf++] = ch;
            if (ixinbuf == 4) {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            if (flbreak) {
                break;
            }
        }
    }
    
    return theData;
}




- (NSString *) encodeString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(__bridge CFStringRef)self,NULL, CFSTR("\\!*';:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
	return result;
}

-(NSString*) decodeString {
    NSString* decodeString = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (decodeString == nil)
    {
        decodeString = @"";
    }
    return decodeString;
}


// 确保上报的字段合法（中文字符加%Encode，字段长度255截取）
- (NSString *)legalReportFieldString
{
    if (self == nil) {
        return nil;
    }
    
    NSString *resultString = self;

    resultString = [[self decodeString]encodeString];
    if ( nil == resultString) {
        resultString = self;
    }
    
    
    if ([resultString lengthOfBytesUsingEncoding:NSUTF8StringEncoding] >= 255) {
        resultString = [resultString substringToIndex:254];
    }
    
    return resultString;
}

// 从字符串中计算出urlhash
- (int64_t)urlHashFromString
{
    NSString* strNoPercentUrl = [self decodeString];
    return mmhash_64([strNoPercentUrl UTF8String], [strNoPercentUrl lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
}
#define FNV_32_PRIME 0x01000193ULL
uint64_t mmhash_64(const void *key, size_t len) {
    const uint64_t m = 0xc6a4a7935bd1e995ULL;
    const uint64_t r = 47;
    uint64_t h = FNV_32_PRIME ^ (len * m);
    
    
    const uint64_t * tmp_data = malloc(len);
    memset((void*)tmp_data, 0, len);
    memcpy((void*)tmp_data, key, len);
    
    const uint64_t * data = (const uint64_t *)tmp_data;
    const uint64_t * end = data + (len/sizeof(uint64_t));
    
    
    uint64_t k ;
    while (data != end) {
        
        k = *data++;
        
        k *= m;
        k ^= k >> r;
        k *= m;
        h ^= k;
        h *= m;
    };
    
    const unsigned char * data2 = (const unsigned char*)data;
    switch (len & 7) {
        case 7: h ^= (uint64_t)(data2[6]) << 48;
        case 6: h ^= (uint64_t)(data2[5]) << 40;
        case 5: h ^= (uint64_t)(data2[4]) << 32;
        case 4: h ^= (uint64_t)(data2[3]) << 24;
        case 3: h ^= (uint64_t)(data2[2]) << 16;
        case 2: h ^= (uint64_t)(data2[1]) << 8;
        case 1: h ^= (uint64_t)(data2[0]);
            h *= m;
    }
    h ^= h >> r;
    h *= m;
    h ^= h >> r;
    
    free((void*)tmp_data);
    return h;
}

// 获取系统时间戳
+ (NSString *)timeStampAtNow
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%lld", (long long)interval];
    
    return timeStamp;
}

//去掉前后空格和换行符
- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
//获取Label长度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}

+(NSString *)internalFromCreatTime:(NSString *)creatTimeString formatString:(NSString *)formatString
{
    //创建对应的格式
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:formatString?formatString:@"yyyy-MM-dd HH:mm:ss"];
    //生成对应的格式日期对象
    NSDate *currentDate=[dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate new]]];
    
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:creatTimeString.floatValue];
//    1465206909.000000
    //计算日期间隔
    NSTimeInterval timeInterval= [currentDate timeIntervalSinceDate:nd];
    
    float days = timeInterval / (3600.0*24);
    float hours=timeInterval /3600.0;
    float minutes = timeInterval / 60;
    
    if (days >7)
    {
        return [dateFormatter stringFromDate:nd];
    }
    else if (days>=1)
    {
        return [NSString stringWithFormat:@"%d天前",(int)days];
    }
    else if (hours>=1)
    {
        return  [NSString stringWithFormat:@"%d小时前",(int)hours];
    }
    else if (minutes >= 1)
    {
        return  [NSString stringWithFormat:@"%d分钟前",(int)minutes];
    }
    else
    {
        return @"刚刚";
    }
}

+ (NSString *)couponDeadlineTimeConvertBeginTS:(long long)beginTS endTD:(long long)endTS
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *beginND = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)beginTS];
    NSDate *endND = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)endTS];
    NSString *beginStr = [dateFormatter stringFromDate:beginND];
    NSString *endStr = [dateFormatter stringFromDate:endND];
    return [NSString stringWithFormat:@"%@-%@",beginStr,endStr];
}
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
//- (NSString *)rsaDecryptWithValueE:(NSString *)strE valueD:(NSString *)strD valueN:(NSString *)strN
//{
//
//
//    if ([NSString isEmptyString:strE]
//        ||[NSString isEmptyString:strD]
//        ||[NSString isEmptyString:strN])
//    {
//        return nil;
//    }
//    
//    char* out_str = decrypt_msg([strE UTF8String], [strD UTF8String], [strN UTF8String], [self UTF8String]);
//    NSString* strOut = [NSString stringWithCString:out_str encoding:NSUTF8StringEncoding];
//    free(out_str);
//    return strOut;
//}

/**
 *  RSA加密算法
 *  (N,e)是公钥，(N,d)是私钥
 *
 *  @param strE e值
 *  @param strN N值
 *
 *  @return 返回加密之后的字符串
 */
//- (NSString *)rsaEncryptWithValueE:(NSString *)strE valueN:(NSString *)strN
//{
//    
//    if ([NSString isEmptyString:strE]
//        ||[NSString isEmptyString:strN])
//    {
//        return nil;
//    }
//    
//    char * out_str = encrypt_msg([strE UTF8String], [strN UTF8String], [self UTF8String]);
//    
//    NSString* strOut = [NSString stringWithCString:out_str encoding:NSUTF8StringEncoding];
//    free(out_str);
//    return strOut;
//    
//}
//
//
//- (NSString*)rsaDecrypt
//{
//    char* out_str = decrypt_msg("010001", "AEE620CD695EE20057CAE3727C6EE1E4B36102321D527512323321C7B68F449741E9489733272C660A2227BB067D2D3FBED265AB8A1C268B1C2A4B7CDF042F80A0946A4AFF961EF2A8B675D62758B130116A5C0B63BB46203AD57229FE0C6DC60116CE3D5EB9254A0C93C99C5A461D6FBE3AF7DDE5E07FE883BFD7D3550A23D1", "CD32A610370D0C9718C7DD86508E193436CD0244E3423E2A4E4CD3D0D0F031BEBB9B849821DE8648BB9B1C9A4525C303E2F8FFE61D6702080AA8356A0F3853796823FD6783229B65D673CCBF8F5EF05B12ACF167A8D4A1D8218F8F21DC265CC5D056FCB8C381E820AA4707239377DCA4127DA12AAB0E80D282AD0D70D87F3429", [self UTF8String]);
//    NSString* strOut = [NSString stringWithCString:out_str encoding:NSUTF8StringEncoding];
//    free(out_str);
//    return strOut;
//}

//
//- (NSString*)rsaEncrypt
//{
//    char * out_str = encrypt_msg("010001", "BED0670FBCCACD6B6631DB8EAE8AD0EBD0B34C0724DCF6C0DA00A71F3C373C62C15FBE64A9FFD2E8B14A7C7E38FB8BC2534946CA400DE2B845952CB5776737EAC5D8CC425F88D1B9D7A13F9C8E7669DDAAEAE7CAC3972FE6CFC9698A007766A016EADA707755337EBC9FE6A0F5C30B8DA8D1E1B19EDF2BECA36E57B6ACC6EE3F", [self UTF8String]);
//    
//    NSString* strOut = [NSString stringWithCString:out_str encoding:NSUTF8StringEncoding];
//    free(out_str);
//    return strOut;
//}
@end
