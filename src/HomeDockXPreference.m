/**
 * HomeDockXPreference
 */
#import "includes/HomeDockXPreference.h"

static HomeDockXPreference *sharedInstance = NULL;

@implementation HomeDockXPreference {
    NSDictionary *_prefsDict;
}

+ (HomeDockXPreference *)sharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[HomeDockXPreference alloc] init];
    }

    return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        NSDictionary *prefs = NULL;

        CFStringRef appID = CFSTR("pw.ssnull.homedockx");
        CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

        if (keyList) {
            prefs = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
            CFRelease(keyList);
        }

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

        _prefsDict = prefs;
    }
    
    return self;
}

- (BOOL)isBlacklisted:(NSString*)bundleIdentifier {
    if (!_prefsDict) {
        return NO;
    }

    NSString *value = [_prefsDict objectForKey:[@"blacklisted-" stringByAppendingString:bundleIdentifier]];
	
    if (!value) {
		return NO;
    }
	
	return YES;
}

@end

