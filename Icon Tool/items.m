//
//  items.m
//  Icon Tool
//
//  Created by Tyler Wright on 10/22/14.
//  Copyright (c) 2014 Wright Labs. All rights reserved.
//

#import "items.h"

@implementation items

@synthesize itemName = _itemName;
@synthesize icon = _icon;
@synthesize fullPath = _fullPath;

- (id)init{
    self = [super init];
    if(self){
        _itemName = @"Null";
        _icon = nil;
        _fullPath = @"Null";
    }
    return self;
}

@end
