//
//  AppDelegate.h
//  QuickTerm
//
//  Created by Sam Mearns on 1/9/21.
//

#import <Cocoa/Cocoa.h>

CGEventRef cgKeyboardCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void* context);

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (void) toggleActive:(BOOL)wasNewlyInstantiated;
- (BOOL)checkAccessibility:(BOOL)withPrompt;

@end

