/**
 * Common header
 */
#import "includes/HomeDockXPreference.h"
#import "includes/KeyboardStateListener.h"

@interface FBApplicationInfo
@property (nonatomic,retain,readonly) NSURL *executableURL;
@end

@interface SBApplicationInfo : FBApplicationInfo
@end

@interface SBApplication
@property (nonatomic,readonly) NSString *bundleIdentifier;
@property (nonatomic,readonly) SBApplicationInfo *info;

-(BOOL)isClassic;
@end

@interface SpringBoard : UIApplication
- (SBApplication*)_accessibilityFrontMostApplication;
- (long long)activeInterfaceOrientation;
@end

#define isSpringBoardAtFront (![(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication].bundleIdentifier)
#define isKeyboardVisible ([KeyboardStateListener sharedInstance].visible)
#define prefs [HomeDockXPreference sharedInstance]
