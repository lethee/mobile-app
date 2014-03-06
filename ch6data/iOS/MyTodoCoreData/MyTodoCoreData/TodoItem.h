//
//  TodoItem.h
//  MyTodoCoreData
//
//  Created by mage on 12. 12. 30..
//  Copyright (c) 2012년 weaveus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TodoItem : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createDate;

@end
