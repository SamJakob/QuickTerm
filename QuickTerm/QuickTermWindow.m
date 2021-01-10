//
//  QuickTermWindow.m
//  QuickTerm
//
//  Created by Sam Mearns on 1/10/21.
//

#import "QuickTermWindow.h"

@implementation QuickTermWindow

- (BOOL)isFloatingPanel {
    return true;
}

- (BOOL)canBecomeKeyWindow {
    return true;
}

- (void)cancelOperation:(id)sender {
    [self close];
}

@end
