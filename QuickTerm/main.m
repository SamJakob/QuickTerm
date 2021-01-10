//
//  main.m
//  QuickTerm
//
//  Created by Sam Mearns on 1/9/21.
//

#import <Cocoa/Cocoa.h>

#include "AppDelegate.h"

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        AppDelegate *appDelegate = [[AppDelegate alloc] init];
        
        NSApplication* application = [NSApplication sharedApplication];
        [application setDelegate:appDelegate];
        [NSApp run];
    }
    
    return 0;
    
}
