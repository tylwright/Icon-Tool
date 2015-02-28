//
//  AppController.m
//  Icon Tool
//
//  Created by Tyler Wright on 10/22/14.
//  Copyright (c) 2014 Wright Labs. All rights reserved.
//

#import "AppController.h"
#import "items.h"
#import "AppDelegate.h"
#import "FileManagement.h"

@interface AppController ()
@property (weak) IBOutlet NSButton *submitFeedback;
@property (weak) IBOutlet NSImageView *originalIconWell;
@property (weak) IBOutlet NSImageCell *currentIconWellCell;
@property (weak) IBOutlet NSImageView *currentIconWell;
@property (weak) IBOutlet NSButtonCell *loadItem;
@property (weak) IBOutlet NSButton *restoreButton;
@end

@implementation AppController

@synthesize items = _items;

- (IBAction)submitFeedback:(id)sender{
    NSLog(@"feedback");
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://goo.gl/forms/oQuP8IaGJO"]];
}

//
// Method
// Arguments:
// ----------dir(string) = Where to scan for items
// Returns:
// --------items(array) = Items inside dir
// Purpose: Find items in a folder
//
- (NSArray *)scanDir:(NSString *)dir {
    NSArray *items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:NULL];
    //for(NSObject *item in items){
        //NSLog(@"%@", item);
    //}
    return items;
}

- (void)awakeFromNib{
    
    [self.currentIconWell addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:@"image"];
    
    [self scan];
}

- (void)scan{
    _items = nil;
    [[arrayController mutableArrayValueForKey:@"content"] removeAllObjects];
    NSLog(@"Scanning");
    NSArray *files;
    files = [self scanDir:@"/Applications/"];

    for(NSObject *file in files){
        NSString *fullPath;
        fullPath = [NSString stringWithFormat:@"/Applications/%@", file];
        if([[NSFileManager defaultManager] isWritableFileAtPath:fullPath] == YES){
        NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:fullPath];
        //NSLog(@"%@", fullPath);
        items *item = [[items alloc] init];
        item.itemName = (@"%@", file);
        item.icon = icon;
        item.fullPath = fullPath;
        _items = [[NSMutableArray alloc] init];
        if(![item.itemName hasPrefix:@"."]){
            [arrayController addObject:item];
        }}
    }
}

- (IBAction)loadItem:(id)sender{
    fullPath = [sender title];
    NSLog(@"Clicked item: %@", fullPath);
    //Set current icon well to what user clicked on
    [self setCurrentIconImage:fullPath];
    [self getOriginalIconImage:fullPath];
}

//
// Method
// Arguments:
// ----------fullPath(string) = Get original icon at this path
// Returns: None
// Purpose: Check to see if an original icon exists
//
- (void)getOriginalIconImage:(NSString *)fullPath{
    NSString *appFolderPath = [FileManagement getAppFolderPath];
    NSString *path = [NSString stringWithFormat:@"%@Backups%@.tiff", appFolderPath, fullPath];
    if([FileManagement checkIfExists:path]){
        [self setOriginalIconImage:path];
    }else{
        NSLog(@"Original icon does not exist.");
    }
}

- (IBAction)restoreButton:(id)sender{
    NSString *path = [(NSButton *)sender alternateTitle];
    NSLog(@"Restore button clicked");
    NSString *appFolderPath = [FileManagement getAppFolderPath];
    NSString *realPath = [NSString stringWithFormat:@"%@Backups", appFolderPath];
    NSString *pathToItem = [path stringByReplacingOccurrencesOfString:realPath withString:@""];
    pathToItem = [pathToItem stringByReplacingOccurrencesOfString:@".tiff" withString:@""];
    [self revertCurrentToOriginal:path:pathToItem];
    [self setCurrentIconImage:pathToItem];
}

- (void)revertCurrentToOriginal:(NSString *)iconPath:(NSString *)pathToItem{
    NSString *originalIconPath = iconPath;
    NSImage *originalIcon = [[NSImage alloc]initWithContentsOfFile:originalIconPath];
    [[NSWorkspace sharedWorkspace] setIcon:originalIcon forFile:pathToItem options:0];
    NSLog(@"Reverted icon to original %@ / %@", iconPath, pathToItem);
    [self scan];
}

//
// Method
// Arguments:
// ----------fullPath(string) = Set original image well to icon at this path
// Returns: None
// Purpose: Set image well to icon
//
- (void)setOriginalIconImage:(NSString *)fullPath{
    NSImage *icon = [[NSImage alloc]initWithContentsOfFile:fullPath];
    [_originalIconWell setImage:icon];
    [_restoreButton setAlternateTitle:fullPath];
    NSLog(@"originalIconWell set %@", fullPath);
}

//
// Method
// Arguments:
// ----------fullPath(string) = Set current image well to icon at this path
// Returns: None
// Purpose: Set image well to icon
//
- (void)setCurrentIconImage:(NSString *)fullPath{
    NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:fullPath];
    [_currentIconWellCell setImage:icon];
    NSLog(@"currentIconWell set");
    [self backupOriginalIcon:fullPath:icon];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(NSString *)context{
    NSImage *newIcon = self.currentIconWell.image;
    //NSString *newIconPath = self.currentIconWell;
    NSLog(@"CURRENT ICON CHANGED %@", fullPath);
    [[NSWorkspace sharedWorkspace] setIcon:newIcon forFile:fullPath options:0];
    [self scan];
}

//
// Method
// Arguments:
// ----------path(string) = Get path of icon in image well
// ----------icon(image) = Get icon
// Returns: None
// Purpose: Backup the original icon
//
- (void)backupOriginalIcon:(NSString *)path:(NSImage *)icon{
    NSString *appStoragePath = [FileManagement getAppFolderPath];
    appStoragePath = [NSString stringWithFormat:@"%@Backups", appStoragePath];
    NSString *iconFilename = [NSString stringWithFormat:@"%@%@.tiff", appStoragePath, path];
    //Check to see if original icon exists
    if(![FileManagement checkIfExists:iconFilename]){
        NSData *tiffData = [icon TIFFRepresentation];
        [tiffData writeToFile:iconFilename atomically:YES];
        NSLog(@"Original icon backed up - %@", iconFilename);
    }else{
        NSLog(@"Original icon has already been backed up - skipping %@", iconFilename);
    }
}

@end