/**
 * Common header
 */
#import "includes/HomeDockXPreference.h"
#import "includes/KeyboardStateListener.h"

#import <SpringBoard/SpringBoard.h>

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

#define isSpringBoardAtFront (![(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication].bundleIdentifier)
#define isKeyboardVisible ([KeyboardStateListener sharedInstance].visible)
#define prefs [HomeDockXPreference sharedInstance]
