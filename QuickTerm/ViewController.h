//
//  ViewController.h
//  QuickTerm
//
//  Created by Sam Mearns on 1/9/21.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (strong) IBOutlet NSImageView *leadingIcon;
@property (strong) IBOutlet NSTextField *searchField;

- (void) setupSearchField;

- (void) submit;
- (void) selectAllText;

@end

