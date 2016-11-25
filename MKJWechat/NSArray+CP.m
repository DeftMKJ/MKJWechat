//
//  NSArray+CP.m
//  cloudspaceSupport
//
//  Created by muzihuowei on 13-5-14.
//  Copyright (c) 2013年 muzihuowei. All rights reserved.
//

#import "NSArray+CP.h"

@implementation NSArray (CP)

/**
 *  该数组是否为空：nil或count == 0
 *
 *  @param array 待判定数组
 *
 *  @return 是否为空
 */
+ (BOOL)isEmpty:(NSArray *)array
{
    return (array == nil || [array count] == 0);
}

- (id)objAtIndex:(NSUInteger)index
{
    if (self.count == 0)
    {
        assert(FALSE);
        return nil;
    }

    if (index < self.count)
    {
        return [self objectAtIndex:index];
    }else{
    
        assert(FALSE);
        return nil;
    }
}
- (BOOL)containValue:(id)object
{
    BOOL contain = NO;
    for (NSObject *obj in self) {
        if ([obj isEqual:object]) {
            contain = YES;
            break;
        }
    }
    return contain;
}



- (NSUInteger)indexOfObject:(id)obj usingComparator:(NSComparator)cmptr
{
    int index = 0;
    for (id iObj in self) {
        if(cmptr(obj, iObj) == NSOrderedSame)
        {
            return index;
        }
        index++;
    }
    return NSNotFound;
}

@end


@implementation NSMutableArray (CP)

/**
 *  保证去重下  把一个array中的元素拷贝到另一个array中
 *
 *  @param otheArray 被拷贝的array
 *  @param cmptr     比较元素相同的比较器
 */
- (void)addObjectsFromArray:(NSArray*)otheArray withComparator:(NSComparator)cmptr
{
    for (id item in otheArray)
    {
        if ([self indexOfObject:item usingComparator:cmptr] == NSNotFound)
        {
            [self addObject:item];
        }
    }
}


@end

