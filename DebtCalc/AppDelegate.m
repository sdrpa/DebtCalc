
#import "AppDelegate.h"
#import "WindowController.h"

@interface AppDelegate () {
   WindowController *_windowController;
}
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
   _windowController = [[WindowController alloc] initWithWindowNibName:@"Window"];
   [_windowController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
   [_windowController saveData];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
   return YES;
}

@end
