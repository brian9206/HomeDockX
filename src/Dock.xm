/**
 * iPad Floating Dock implementation
 * Credit: KpwnZ for his FloatingDockXI
 */
#include "includes/common.h"

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

%group Dock

// global variable
SBFloatingDockController *dock = NULL;

 // Enable floating dock
%hook SBFloatingDockController
- (id)initWithIconController:(id)arg1 applicationController:(id)arg2 recentsController:(id)arg3 recentsDataStore:(id)arg4 transitionCoordinator:(id)arg5 appSuggestionManager:(id)arg6 analyticsClient:(id)arg7 {
    dock = self;
    return %orig;
}

+ (BOOL)isFloatingDockSupported {
    return YES;
}

- (BOOL)_systemGestureManagerAllowsFloatingDockGesture {
    if (prefs.enableHomeGesture) {
        // get all the information that we need
        UIGestureRecognizer *edgePullGestureRecognizer = [[self.viewController grabberTongue] edgePullGestureRecognizer];
        CGPoint location = [edgePullGestureRecognizer locationInView:edgePullGestureRecognizer.view];

        bool stop = NO;

        switch ([(SpringBoard*)[UIApplication sharedApplication] activeInterfaceOrientation]) {
            case 1: // UIInterfaceOrientationPortrait
                stop = location.x > edgePullGestureRecognizer.view.bounds.size.width / 2;
                break;

            case 2: // UIInterfaceOrientationPortraitUpsideDown
                stop = location.x < edgePullGestureRecognizer.view.bounds.size.width / 2;
                break;
        }

        if (stop) {
            return NO;
        }
    }

    return prefs.enableInAppDock;
}
%end

// Enable floating dock recent app / suggestion
%hook SBFloatingDockSuggestionsModel
- (id)initWithMaximumNumberOfSuggestions:(unsigned long long)maxSuggestion iconController:(id)arg2 recentsController:(id)arg3 recentsDataStore:(id)arg4 recentsDefaults:(id)arg5 floatingDockDefaults:(id)arg6 appSuggestionManager:(id)arg7 analyticsClient:(id)arg8 {
    maxSuggestion = prefs.maxSuggestion;
    return %orig;
}

- (BOOL)_shouldProcessAppSuggestion:(id)arg1 {
    return prefs.enableDockSuggestion;
}

- (BOOL)recentsEnabled {
    return prefs.showRecentApp;
}
%end

// Dismiss floating dock by pressing home button
%hook SBHomeHardwareButton
- (void)singlePressUp:(id)arg1 {
    if (prefs.enableHomeButtonDismiss) {
        // must not be springboard and dock must be swiped up
        if (!isSpringBoardAtFront && dock && [dock isFloatingDockPresented]) {
            [dock _dismissFloatingDockIfPresentedAnimated:YES completionHandler:NULL];
            return;
        }
    }

    %orig;
}
%end

// Disable home screen rotation because of layout bug
%hook SpringBoard
- (BOOL)homeScreenSupportsRotation {
    return NO;
}

- (BOOL)homeScreenRotationStyle {
    return 0;
}
%end

%end    // %group Dock

%ctor {
    if (prefs.enableDock) {
        %init(Dock);
    }
}
