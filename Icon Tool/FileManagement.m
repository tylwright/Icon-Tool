//
//  FileManagement.m
//  Icon Tool
//
//  Created by Tyler Wright on 10/26/14.
//  Copyright (c) 2014 Wright Labs. All rights reserved.
//

#import "FileManagement.h"

@implementation FileManagement

//
// Method
// Arguments: None
// Returns: None
// Purpose: Make sure that "/Users/{current user}/Documents/Icon Tool/" exists
//
+ (void)checkAppStorageFolder{
    // Get app folder
    NSString *appStoragePath = [FileManagement getAppFolderPath];
    // Get users home folder
    NSString *usersFolder = [FileManagement getUsersFolder];
    NSLog(@"Checking to see if Icon Tool's folder exists...");
    // Check to see if the app folder exists
    if([FileManagement checkIfExists:appStoragePath]){
        NSLog(@"...The folder does exist!");
        [FileManagement checkForAppStorageSubFolders:usersFolder];
    }else{
        NSLog(@"...The folder does not exist.  I will create it.");
        [FileManagement createAppStorageFolder:usersFolder];
    }
}

//
// Method
// Arguments:
// ----------path(string) = path of file that needs to be found
// Returns:
// ----------fileExists(bool) = [0] if path doesn't exist OR [1] if path does exist
// Purpose: Check to see if the given file or path exists
//
+ (BOOL)checkIfExists:(NSString *)path{
    BOOL *fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil];
    return fileExists;
}


//
// Method
// Arguments:
// ----------usersFolder(string) = path of users folder
// Returns: None
// Purpose: Creates all of the app's storage folders
//
+ (void)createAppStorageFolder:(NSString *)usersFolder{
    NSLog(@"Creating the application storage folders...");
    // Get app storage path
    NSString *appStoragePath = [FileManagement getAppFolderPath];
    // Set app storage / Backups folder
    NSString *appStoragePathBackups = [NSString stringWithFormat:@"%@/Icon Tool/Backups", usersFolder];
    // Set app storage / Backups / Applications folder
    NSString *appStoragePathBackupsApps = [NSString stringWithFormat:@"%@/Icon Tool/Backups/Applications/", usersFolder];
    // Set app storage / Backups / Users folder
    NSString *appStoragePathBackupsUser = [NSString stringWithFormat:@"%@/Icon Tool/Backups/Users", usersFolder];
    [FileManagement createAppStorageFolders:appStoragePath];
    [FileManagement createAppStorageFolders:appStoragePathBackups];
    [FileManagement createAppStorageFolders:appStoragePathBackupsApps];
    [FileManagement createAppStorageFolders:appStoragePathBackupsUser];
    NSLog(@"-----App Storage Directory: OK");
}

//
// Method
// Arguments:
// ----------path(string) = path where new app folder is to be created
// Returns: None
// Purpose: Creates app folder at given path
//
+ (void)createAppStorageFolders:(NSString *)path{
    if([self createFolder:path]){
        NSLog(@"Created %@", path);
    }else{
        NSLog(@"Could not create %@", path);
    }
}

//
// Method
// Arguments:
// ----------path(string) = path where new folder is to be created
// Returns: None
// Purpose: Creates folder at given path
//
+ (BOOL)createFolder:(NSString *)path{
    NSLog(@"Creating folder at: %@", path);
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

//
// Method
// Arguments:
// ----------usersFolder(string) = path of users folder
// Returns: None
// Purpose: Checks to see if files inside of the app storage folder exist
//
+ (void)checkForAppStorageSubFolders:(NSString *)usersFolder{
    NSString *appStoragePathBackups = [NSString stringWithFormat:@"%@/Icon Tool/Backups", usersFolder];
    NSString *appStoragePathBackupsApps = [NSString stringWithFormat:@"%@/Icon Tool/Backups/Applications/", usersFolder];
    NSString *appStoragePathBackupsUser = [NSString stringWithFormat:@"%@/Icon Tool/Backups/Users", usersFolder];
    if([FileManagement checkIfExists:appStoragePathBackups]){
        NSLog(@"...Backups folder exists!");
        if([FileManagement checkIfExists:appStoragePathBackupsApps]){
            NSLog(@"...Backups/Applications folder exists!");
            if([FileManagement checkIfExists:appStoragePathBackupsUser]){
               NSLog(@"...Backups/Users folder exists!");
                NSLog(@"-----App Storage Directory: OK");
            }else{
                [FileManagement createAppStorageFolders:appStoragePathBackupsUser];
                NSLog(@"-----App Storage Directory: OK");
            }
        }else{
            [FileManagement createAppStorageFolders:appStoragePathBackupsApps];
            if([FileManagement checkIfExists:appStoragePathBackupsUser]){
                NSLog(@"...Backups/Users folder exists!");
                NSLog(@"-----App Storage Directory: OK");
            }else{
                [FileManagement createAppStorageFolders:appStoragePathBackupsUser];
                NSLog(@"-----App Storage Directory: OK");
            }
        }
    }else{
        NSLog(@"...Backups folder does not exist!");
        [FileManagement createAppStorageFolders:appStoragePathBackups];
        [FileManagement createAppStorageFolders:appStoragePathBackupsApps];
        [FileManagement createAppStorageFolders:appStoragePathBackupsUser];
        NSLog(@"-----App Storage Directory: OK");
    }
}

// Method
// Arguments: None
// Returns:
// --------appStoragePath(string) = Path of /Users/{current user}/Icon Tool/
// Purpose: Need to know where this folder is located based on the current user
//
+ (NSString *)getAppFolderPath{
    NSString *usersFolder = [self getUsersFolder];
    NSString *appStoragePath = [NSString stringWithFormat:@"%@/Icon Tool/", usersFolder];
    return appStoragePath;
}

// Method
// Arguments: None
// Returns:
// --------usersFolder(string) = Path of /Users/{current user}/
// Purpose: Need to know where this folder is located based on the current user
//
+ (NSString *)getUsersFolder{
    NSString *usersFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return usersFolder;
}

@end