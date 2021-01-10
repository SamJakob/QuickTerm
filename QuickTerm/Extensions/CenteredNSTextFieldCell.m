//
//  CenteredNSTextFieldCell.m
//  QuickTerm
//
//  Created by Sam Mearns on 1/10/21.
//

#import "CenteredNSTextFieldCell.h"

@implementation CenteredNSTextFieldCell

- (NSRect)titleRectForBounds:(NSRect)frame {
    
    CGFloat stringHeight = self.font.capHeight + 8;
    NSRect titleRect = [super titleRectForBounds:frame];
    titleRect.origin.y = frame.origin.y + (frame.size.height - stringHeight) / 2.0;
    return titleRect;
    
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    [super drawInteriorWithFrame:[self titleRectForBounds:cellFrame] inView:controlView];
}

- (void)selectWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate start:(NSInteger)selStart length:(NSInteger)selLength {
    [super selectWithFrame:[self titleRectForBounds:rect] inView:controlView editor:textObj delegate:delegate start:selStart length:selLength];
}

@end
