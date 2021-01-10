//
//  AppDelegate.m
//  QuickTerm
//
//  Created by Sam Mearns on 1/9/21.
//

#import "AppDelegate.h"
#include "QuickTermWindowController.h"
#include "ViewController.h"

#define MAIN_APP_IDENTIFIER "com.samjakob.QuickTerm"

@implementation AppDelegate {
    QuickTermWindowController* mainWindowController;
}

CGEventRef cgKeyboardCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void* context) {
    AppDelegate* appDelegate = (__bridge AppDelegate*)(context);
    CGEventFlags eventFlags = CGEventSourceFlagsState(kCGEventSourceStateHIDSystemState);
    
    if (type == kCGEventKeyDown) {
        UniChar input[1];
        UniCharCount inputLength;
        
        CGEventKeyboardGetUnicodeString(event, 1, &inputLength, input);
        
        // Return //
        if (appDelegate->mainWindowController != NULL && appDelegate->mainWindowController.window.isVisible && input[0] == 13) {
            ViewController* controller = (ViewController*) [appDelegate->mainWindowController.window contentViewController];
            [controller submit];
            return NULL;
        }
        
        if ((kCGEventFlagMaskCommand & eventFlags)) {
            
            // Command + A //
            if (appDelegate->mainWindowController != NULL && appDelegate->mainWindowController.window.isVisible && input[0] == 97) {
                ViewController* controller = (ViewController*) [appDelegate->mainWindowController.window contentViewController];
                [controller selectAllText];
                return NULL;
            }
            
            // Command + Shift + Space //
            if ((kCGEventFlagMaskShift & eventFlags) && input[0] == 32) {
                BOOL wasNewlyInstantiated = false;
                
                if (appDelegate->mainWindowController == NULL) {
                    NSStoryboard* storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:NULL];
                    appDelegate->mainWindowController = [storyboard instantiateInitialController];
                    wasNewlyInstantiated = true;
                }
                
                [appDelegate toggleActive:wasNewlyInstantiated];
                return NULL;
            }
        }
    }
    
    return event;
}


- (void) toggleActive:(BOOL)wasNewlyInstantiated {
    if (wasNewlyInstantiated || !self->mainWindowController.window.isVisible) {
        [self->mainWindowController showWindow:self];
        
        // TODO: Consider making this work with mouse cursor pos instead?
        
        CGPoint startupPoint;
        
        startupPoint.x = [NSScreen mainScreen].frame.origin.x + ([NSScreen mainScreen].frame.size.width / 2);
        startupPoint.y = [NSScreen mainScreen].frame.origin.y + ([NSScreen mainScreen].frame.size.height / 2);
        
        startupPoint.x -= 340;
        startupPoint.y -= 30;
        
        startupPoint.y += 120;
        
        [self->mainWindowController.window setFrame:NSMakeRect(startupPoint.x, startupPoint.y, 680, 60) display:true];
        
        [[NSApp mainWindow] makeKeyWindow];
        [self->mainWindowController.window makeKeyAndOrderFront:self];
        [[NSApplication sharedApplication] activateIgnoringOtherApps:true];
    } else {
        [self->mainWindowController close];
    }
}

- (BOOL)checkAccessibility:(BOOL)withPrompt {
    if (withPrompt) {
        NSDictionary *options = @{(__bridge id) kAXTrustedCheckOptionPrompt: @(YES)};
        return AXIsProcessTrustedWithOptions((CFDictionaryRef) options);
    } else {
        return AXIsProcessTrusted();
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    BOOL foundOneInstance = false;
    BOOL alreadyRunning = false;
    
    for (NSRunningApplication* runningApplication in [[NSWorkspace sharedWorkspace] runningApplications]) {
        if ([runningApplication.bundleIdentifier isEqual:@MAIN_APP_IDENTIFIER]) {
            if (!foundOneInstance) {
                foundOneInstance = true;
                continue;
            }
            
            alreadyRunning = true;
            break;
        }
    }
    
    if (alreadyRunning) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"QuickTerm has already started..."];
        [alert setInformativeText:@"QuickTerm has already been started and it cannot be started again.\n\nUse Command + Shift + Space to open it."];
        [alert addButtonWithTitle:@"OK"];
        
        NSLog(@"QuickTerm is already running.");
        
        [alert runModal];
        [NSApp terminate:NULL];
        return;
    }
    
    if (![self checkAccessibility:FALSE]) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Permissions Required"];
        [alert setInformativeText:@"You must grant Accessibility permission to QuickTerm in System Preferences for it to be able to register the global keyboard shortcut.\n\nYou will need to restart QuickTerm afterwards."];
        [alert addButtonWithTitle:@"OK"];
        
        [alert runModal];
        
        NSString* prefPage = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility";
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:prefPage]];
        
        [NSApp terminate:NULL];
    }
    
    if (![self checkAccessibility:FALSE]) {
        NSError* error = [NSError errorWithDomain:@"com.samjakob.QuickTerm" code:1000 userInfo:@{
            NSLocalizedFailureReasonErrorKey: @"The necessary permission has not been granted.",
            NSLocalizedRecoverySuggestionErrorKey: @"Enable the necessary permission in System Preferences and re-launch the application. (Privacy -> Accessibility)",
            NSLocalizedDescriptionKey: @"Failed to register global keyboard shortcut."
        }];
        
        NSLog(@"%@", error);
        [[NSAlert alertWithError:error] runModal];
        
        [NSApp terminate:NULL];
        return;
    }
    
    NSLog(@"Registering key handler...");
    CFMachPortRef tap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap, 0, kCGEventFlagMaskShift | CGEventMaskBit(kCGEventKeyDown) | kCGEventFlagMaskCommand, cgKeyboardCallback, (__bridge void*)(self));
    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(tap, true);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
