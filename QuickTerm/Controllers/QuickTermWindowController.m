//
//  WindowController.m
//  QuickTerm
//
//  Created by Sam Mearns on 1/9/21.
//

#import "QuickTermWindowController.h"

@interface QuickTermWindowController ()

@end

@implementation QuickTermWindowController

#define AUTOSAVE_NAME "QuickTermWindow"

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.titlebarAppearsTransparent = true;
    self.window.titleVisibility = NSWindowTitleHidden;
    
    self.window.movableByWindowBackground = true;
    self.window.opaque = false;
    self.window.backgroundColor = NSColor.clearColor;
    self.window.styleMask = NSWindowStyleMaskBorderless | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskTitled;
    self.window.showsToolbarButton = false;
    
    self.window.level = NSFloatingWindowLevel;
    [[NSApplication sharedApplication] activateIgnoringOtherApps:true];
    [self.window makeKeyAndOrderFront:self];
    [self setWindowFrameAutosaveName:@AUTOSAVE_NAME];
    
    [self.window invalidateShadow];
}

- (void)windowDidResignKey:(NSNotification *)notification {
    [self close];
}

- (void)windowDidResignMain:(NSNotification *)notification {
    [NSApp hide:self];
}

@end
