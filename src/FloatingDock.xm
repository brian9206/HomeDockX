/**
 * iPad Floating Dock implementation
 * Credit: KpwnZ for his FloatingDockXI
 */
#import "includes/KeyboardStateListener.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBApplication.h>

@interface SBGrabberTongue : NSObject
-(UIGestureRecognizer *)edgePullGestureRecognizer;
@end

@interface SBFloatingDockRootViewController : UIViewController
@property (nonatomic,retain) SBGrabberTongue *grabberTongue;
@end

@interface SBFloatingDockController : NSObject
@property (nonatomic, retain) SBFloatingDockRootViewController *viewController;
-(void)_dismissFloatingDockIfPresentedAnimated:(BOOL)arg1 completionHandler:(/*^block*/id)arg2;
-(BOOL)isFloatingDockPresented;
@end

// global variable
SBFloatingDockController *dock = NULL;

 // Enable floating dock
%hook SBFloatingDockController
-(id)initWithIconController:(id)arg1 applicationController:(id)arg2 recentsController:(id)arg3 recentsDataStore:(id)arg4 transitionCoordinator:(id)arg5 appSuggestionManager:(id)arg6 analyticsClient:(id)arg7 {
    dock = self;
    return %orig;
}

+ (BOOL)isFloatingDockSupported {
    return YES;
}

- (BOOL)_systemGestureManagerAllowsFloatingDockGesture {
    // no swipe up dock if we are using keyboard
    if ([KeyboardStateListener sharedInstance].visible) {
        return NO;
    }

    // get all the information that we need
    UIGestureRecognizer *edgePullGestureRecognizer = [[self.viewController grabberTongue] edgePullGestureRecognizer];
    CGPoint location = [edgePullGestureRecognizer locationInView:edgePullGestureRecognizer.view];

    // swipe up only for 1/3 left of the screen
    if (location.x > edgePullGestureRecognizer.view.bounds.size.width / 2) {
        return NO;
    }

    return YES;
}
%end

// Enable floating dock recent app / suggestion
%hook SBFloatingDockSuggestionsModel
-(id)initWithMaximumNumberOfSuggestions:(unsigned long long)maxSuggestion iconController:(id)arg2 recentsController:(id)arg3 recentsDataStore:(id)arg4 recentsDefaults:(id)arg5 floatingDockDefaults:(id)arg6 appSuggestionManager:(id)arg7 analyticsClient:(id)arg8 {
    maxSuggestion = 2;
    return %orig;
}

- (BOOL)_shouldProcessAppSuggestion:(id)arg1 {
    return NO;
}

- (BOOL)recentsEnabled {
    return YES;
}
%end

// Dismiss floating dock by pressing home button
%hook SBHomeHardwareButton
-(void)singlePressUp:(id)arg1 {
    SBApplication *currentApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];

    // must not be springboard and dock must be swiped up
    if (currentApp.bundleIdentifier && dock && [dock isFloatingDockPresented]) {
        [dock _dismissFloatingDockIfPresentedAnimated:YES completionHandler:NULL];
        return;
    }

    %orig;
}
%end
