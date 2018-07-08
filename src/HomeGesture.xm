/**
 * Home Gesture implementation
 * Credit: VitaTaf for his Home Gesture
 */
#include "includes/common.h"

@interface SBHomeGesturePanGestureRecognizer
-(void)reset;
-(void)touchesEnded:(id)arg1 withEvent:(id)arg2;
@end

%group HomeGesture

// global variable
long _dismissalSlidingMode = 0;

// Enable home gestures
%hook BSPlatform
- (NSInteger)homeButtonType {
    return 2;
}
%end

// Hide home bar
%hook MTLumaDodgePillView
- (id)initWithFrame:(struct CGRect)arg1 {
    return NULL;
}
%end

// Workaround for status bar transition bug
%hook CCUIOverlayStatusBarPresentationProvider
- (void)_addHeaderContentTransformAnimationToBatch:(id)arg1 transitionState:(id)arg2 {
    return;
}
%end

// Prevent status bar from flashing when invoking control center
%hook CCUIModularControlCenterOverlayViewController
- (void)setOverlayStatusBarHidden:(bool)arg1 {
    return;
}
%end

// Prevent status bar from displaying in fullscreen when invoking control center
%hook CCUIStatusBarStyleSnapshot
- (bool)isHidden {
    return YES;
}
%end

// Hide home bar in cover sheet
%hook SBDashboardHomeAffordanceView
- (void)_createStaticHomeAffordance {
    return;
}
%end

// Workaround for TouchID respring bug
%hook SBCoverSheetSlidingViewController
- (void)_finishTransitionToPresented:(_Bool)arg1 animated:(_Bool)arg2 withCompletion:(id)arg3 {
    if ((_dismissalSlidingMode != 1) && (arg1 == 0)) {
        return;
    } else {
        %orig;
    }
}
- (long long)dismissalSlidingMode {
    _dismissalSlidingMode = %orig;
    return %orig;
}
%end

%hook SBHomeGesturePanGestureRecognizer
    void resetTouch(SBHomeGesturePanGestureRecognizer *self, NSSet *touches, id event) {
        // stop touching the screen
        [self touchesEnded: touches withEvent: event];
        [self reset];
    }

    - (void)touchesBegan:(NSSet *)touches withEvent:(id)event {
        UITouch *touch = [touches anyObject];

        // do not do home gesture for 1/3 left of the screen if dock is enabled
        if (!isSpringBoardAtFront && 
            prefs.enableDock && 
            [touch locationInView:touch.view].x <= touch.view.bounds.size.width / 2
        ) {
            resetTouch(self, touches, event);
            return;
        }

        // do not enable home gesture when using keyboard
        if (prefs.noKeyboard && isKeyboardVisible) {
            resetTouch(self, touches, event);
            return;
        }

        return %orig;
    }
%end

%end    // end %group HomeGesture

%ctor {
    if (prefs.enableHomeGesture) {
        %init(HomeGesture);
    }
}
