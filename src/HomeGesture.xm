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
BOOL _isDashboardActive = 0;
int applicationDidFinishLaunching;
bool originalButton;
long _homeButtonType = 1;

// Enable home gestures
%hook BSPlatform
- (NSInteger)homeButtonType {
    _homeButtonType = %orig;

	if (originalButton) {
		originalButton = NO;
		return %orig;
	} 
    else {
		return 2;
	}
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

- (struct CGRect)headerViewFrame {
	struct CGRect orig = %orig;
	orig.size.height = 45;
	return (CGRect){orig.origin, orig.size};
}

- (struct CGRect)_presentedViewFrame {
	struct CGRect orig = %orig;
	orig.origin.y = 45;
	return (CGRect){orig.origin, orig.size};
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
        if (!_isDashboardActive) {
            UITouch *touch = [touches anyObject];

            // do not do home gesture for 1/2 left of the screen if dock is enabled
            if (!isSpringBoardAtFront && 
                prefs.enableDock
            ) {
                BOOL reset = NO;

                switch ([(SpringBoard*)[UIApplication sharedApplication] activeInterfaceOrientation]) {
                    case 1: // UIInterfaceOrientationPortrait
                        reset = [touch locationInView:touch.view].x < touch.view.bounds.size.width / 2;
                        break;

                    case 2: // UIInterfaceOrientationPortraitUpsideDown
                        reset = [touch locationInView:touch.view].x > touch.view.bounds.size.width / 2;
                        break;

                    case 3: // UIInterfaceOrientationLandscapeRight
                    case 4: // UIInterfaceOrientationLandscapeLeft
                        reset = YES;
                }

                if (reset) {
                    resetTouch(self, touches, event);
                    return;
                }
            }

            // do not enable home gesture when using keyboard
            if (prefs.noKeyboard && isKeyboardVisible) {
                resetTouch(self, touches, event);
                return;
            }
        }

        return %orig;
    }
%end

// Listen for dashboard active state change
%hook SBDashBoardViewController
- (void)viewDidLoad {
	originalButton = YES;
	%orig;
}

- (void)viewWillAppear:(_Bool)arg1 {
    %orig;
    _isDashboardActive = YES;
}

- (void)viewWillDisappear:(_Bool)arg1 {
    %orig;
    _isDashboardActive = NO;
 }
%end

// Workaround for crash when launching app and invoking control center simultaneously
%hook SBSceneHandle
- (id)scene {
	@try {
		return %orig;
	}
	@catch (NSException *e) {
		return nil;
	}
}
%end 

// Restore screenshot shortcut
%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
	applicationDidFinishLaunching = 2;
	%orig;
}
%end

%hook SBPressGestureRecognizer
- (void)setAllowedPressTypes:(NSArray *)arg1 {
	NSArray * lockHome = @[@104, @101];
	NSArray * lockVol = @[@104, @102, @103];
	if ([arg1 isEqual:lockVol] && applicationDidFinishLaunching == 2) {
		%orig(lockHome);
		applicationDidFinishLaunching--;
		return;
	}
	%orig;
}
%end

%hook SBClickGestureRecognizer
- (void)addShortcutWithPressTypes:(id)arg1 {
	if (applicationDidFinishLaunching == 1) {
		applicationDidFinishLaunching--;
		return;
	}
	%orig;
}
%end

%hook SBHomeHardwareButton
- (id)initWitHomeButtonType:(long long)arg1 {
	return %orig(_homeButtonType);
}

- (id)initWithScreenshotGestureRecognizer:(id)arg1 homeButtonType:(long long)arg2 buttonActions:(id)arg3 gestureRecognizerConfiguration:(id)arg4 {
	return %orig(arg1, _homeButtonType, arg3, arg4);
}
- (id)initWithScreenshotGestureRecognizer:(id)arg1 homeButtonType:(long long)arg2 {
	return %orig(arg1, _homeButtonType);
}
%end

 // Restore button to invoke Siri
%hook SBLockHardwareButtonActions
- (id)initWithHomeButtonType:(long long)arg1 proximitySensorManager:(id)arg2 {
	return %orig(_homeButtonType, arg2);
}
%end

// Force close app without long-pressing card
%hook SBAppSwitcherSettings
- (long long)effectiveKillAffordanceStyle {
	return 2;
}
%end

// Enable simutaneous scrolling and dismissing
%hook SBFluidSwitcherViewController
- (double)_killGestureHysteresis {
	double orig = %orig;
	return orig == 30 ? 10 : orig;
}

%end

%end    // end %group HomeGesture

%ctor {
    if (prefs.enableHomeGesture) {
        %init(HomeGesture);
    }
}
