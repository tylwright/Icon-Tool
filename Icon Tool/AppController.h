//
//  AppController.h
//  Icon Tool
//
//  Created by Tyler Wright on 10/22/14.
//  Copyright (c) 2014 Wright Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <appkit/appkit.h>

extern NSString *fullPath;

@interface AppController : NSObject{
    IBOutlet NSArrayController *arrayController;
    __weak IBOutlet NSImageView *currentIconWell;
}

@property (strong) NSMutableArray *items;
- (NSArray *)scanDir;
- (NSString *)tab;
@end
