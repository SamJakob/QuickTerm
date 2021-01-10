//
//  DraggableNSImageView.m
//  QuickTerm
//
//  Created by Sam Mearns on 1/10/21.
//

#import "DraggableNSImageView.h"

@implementation DraggableNSImageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)mouseDownCanMoveWindow {
    return TRUE;
}

@end
