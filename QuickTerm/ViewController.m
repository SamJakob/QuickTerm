//
//  ViewController.m
//  QuickTerm
//
//  Created by Sam Mearns on 1/9/21.
//

#import "ViewController.h"

@implementation ViewController

- (void) viewWillAppear {
    [self.view.window makeFirstResponder:self.searchField];
}

/*
- (void)viewWillDisappear {
    self.searchField.stringValue = @"";
}
 */

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    NSVisualEffectView* view = (NSVisualEffectView*) self.view;
    view.state = NSVisualEffectStateActive;
    view.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    view.wantsLayer = true;
    view.layer.cornerRadius = 15;
    view.material = NSVisualEffectMaterialHUDWindow;

    // Setup additional components.
    [self.leadingIcon setSymbolConfiguration:[NSImageSymbolConfiguration configurationWithPointSize:22 weight:NSFontWeightMedium]];
    [self setupSearchField];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void) setupSearchField {
    self.searchField.focusRingType = NSFocusRingTypeNone;
    self.searchField.editable = true;
    self.searchField.bezeled = false;
    self.searchField.selectable = true;
}

- (void) submit {
    NSString* command = self.searchField.stringValue;
    
    NSWorkspaceOpenConfiguration* commandOpenConfig = [NSWorkspaceOpenConfiguration configuration];
    commandOpenConfig.activates = true;
    commandOpenConfig.addsToRecentItems = true;
    commandOpenConfig.createsNewApplicationInstance = true;
    
    commandOpenConfig.promptsUserIfNeeded = true;
    
    commandOpenConfig.arguments = @[command];
    
    [[NSWorkspace sharedWorkspace] openApplicationAtURL:[NSURL fileURLWithPath:@"/System/Applications/Utilities/Terminal.app" isDirectory: true] configuration:commandOpenConfig completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
        if (error != NULL) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:@"Failed to execute command."];
                [alert setInformativeText:[NSString stringWithFormat:@"QuickTerm failed to execute the following command:\n\n%@", command]];
                [alert addButtonWithTitle:@"OK"];
                
                NSLog(@"Failed to execute command: %@", command);
                
                [alert runModal];
            });
        }
    }];
    
    [self.view.window close];
}

- (void) selectAllText {
    [self.searchField selectText:nil];
}

@end
