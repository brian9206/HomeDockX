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
    sharedInstance = [[self alloc] init];
}

- (id) init {
    if ((self = [super init])) {
        NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/pw.ssnull.homedockx.plist"];
        
        if (prefs) {
            self.enableHomeGesture = [[prefs objectForKey:@"enableHomeGesture"] boolValue];
            self.enableDock = [[prefs objectForKey:@"enableDock"] boolValue];
            self.enableMedusa = [[prefs objectForKey:@"enableMedusa"] boolValue];

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
    }
    
    return self;
}

@end
