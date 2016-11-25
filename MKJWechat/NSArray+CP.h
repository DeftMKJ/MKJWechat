//
//  NSArray+CP.h
//  cloudspaceSupport
//
//  Created by muzihuowei on 13-5-14.
//  Copyright (c) 2013年 muzihuowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CP)

/**
 *  该数组是否为空：nil或count == 0
 *
 *  @param array 待判定数组
 *
 *  @return 是否为空
 */
+ (BOOL)isEmpty:(NSArray *)array;
- (id)objAtIndex:(NSUInteger)index;
- (BOOL)containValue:(id)object;
/**
 *  找到某个元素的在列表中的索引  通过比较器比较
 *
 *  @param obj   目的元素
 *  @param cmptr 比较器
 *
 *  @return 元素的索引, 找不到返回NSNotFound
 */
- (NSUInteger)indexOfObject:(id)obj usingComparator:(NSComparator)cmptr;
@end

@interface NSMutableArray (CP)

/**
 *  保证去重下  把一个array中的元素拷贝到另一个array中
 *
 *  @param otheArray 被拷贝的array
 *  @param cmptr     比较元素相同的比较器
 */
- (void)addObjectsFromArray:(NSArray*)otheArray withComparator:(NSComparator)cmptr;


@end