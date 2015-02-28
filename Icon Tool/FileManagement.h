//
//  FileManagement.h
//  Icon Tool
//
//  Created by Tyler Wright on 10/26/14.
//  Copyright (c) 2014 Wright Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagement : NSObject{
    
}
+ (void)checkAppStorageFolder;
+ (NSString *)getAppFolderPath;
+ (NSString *)getUsersFolder;
+ (BOOL)checkIfExists:(NSString *)path;
@end
