//
//  AppDelegate.m
//  Icon Tool
//
//  Created by Tyler Wright on 10/21/14.
//  Copyright (c) 2014 Wright Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "AppController.h"
#import "FileManagement.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSButton *restoreOriginalIcon;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    // Make sure appsupport folder exists.  If not, create it.
    [FileManagement checkAppStorageFolder];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end