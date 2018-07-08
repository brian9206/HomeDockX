/**
 * HomeDockXPreference
 */
#import "includes/HomeDockXPreference.h"

static HomeDockXPreference *sharedInstance;

@implementation HomeDockXPreference

+ (HomeDockXPreference *)sharedInstance {
    return sharedInstance;
}

+ (void)load {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    sharedInstance = [[self alloc] init];
    [pool release];
}

- (id) init {
    if ((self = [super init])) {
        NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/pw.ssnull.homedockx.plist"];
        self.enableHomeGesture = [[prefs objectForKey:@"enableHomeGesture"] boolValue];
        self.enableDock = [[prefs objectForKey:@"enableDock"] boolValue];
        self.noKeyboard = [[prefs objectForKey:@"noKeyboard"] boolValue];
        self.enableInAppDock = [[prefs objectForKey:@"enableInAppDock"] boolValue];
        self.enableHomeButtonDismiss = [[prefs objectForKey:@"enableHomeButtonDismiss"] boolValue];
        self.enableDockSuggestion = [[prefs objectForKey:@"enableDockSuggestion"] boolValue];
        self.showRecentApp = [[prefs objectForKey:@"showRecentApp"] boolValue];
        self.maxSuggestion = [[prefs objectForKey:@"maxSuggestion"] intValue];

        if (self.maxSuggestion <= 0) {
            self.maxSuggestion = 2;
        }
    }
    
    return self;
}

@end
