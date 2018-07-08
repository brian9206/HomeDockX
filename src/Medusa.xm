/**
 * Medusa
 */
#import "includes/common.h"

%group Medusa

// global variable
NSMutableDictionary *capableApps = [NSMutableDictionary new];

// Enable medusa
%hook SBPlatformController
- (long long)medusaCapabilities {
	return 1;
}
%end

%hook SBMainWorkspace
- (BOOL)isMedusaEnabled {
	return YES;
}
%end

%hook SBApplication
- (BOOL)isMedusaCapable {
    if (!self.bundleIdentifier || [self isClassic]) {
        return NO;
    }

    // check the cached list first
    NSString *capable = [capableApps objectForKey:self.bundleIdentifier];

    if (capable) {
        return [capable intValue] == 1;
    }

    // check blacklisted app
    if ([prefs isBlacklisted:self.bundleIdentifier]) {
        return %orig;
    }

    // bundle ID is not exists in the cache.
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[self.info.executableURL.path stringByDeletingLastPathComponent] stringByAppendingString:@"/Info.plist"]];
	
    if (infoDict == NULL) {
		return %orig;
	}

    // disable landscape only app to prevent orientation bug
    NSArray *orientations = [infoDict valueForKeyPath:@"UISupportedInterfaceOrientations"];

	if (orientations != NULL && [orientations indexOfObject:@"UIInterfaceOrientationPortrait"] == NSNotFound) {
        [capableApps setObject:[NSNumber numberWithInt:0] forKey:self.bundleIdentifier];    
		return NO;
	}

    [capableApps setObject:[NSNumber numberWithInt:1] forKey:self.bundleIdentifier];    
	return YES;
}
%end

%end    // end %group Medusa

%ctor {
    if (prefs.enableMedusa) {
        %init(Medusa);
    }
}
