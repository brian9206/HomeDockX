/**
 * Common header
 */
#import "includes/HomeDockXPreference.h"
#import "includes/KeyboardStateListener.h"

#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBApplication.h>

#define isSpringBoardAtFront (![(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication].bundleIdentifier)
#define isKeyboardVisible ([KeyboardStateListener sharedInstance].visible)
#define prefs [HomeDockXPreference sharedInstance]
