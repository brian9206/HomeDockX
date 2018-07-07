/**
 * GestureDock
 * Credits:
 *   VitaTaf - Home Gesture
 *   KpwnZ - FloatingDockXI
 */
long _dismissalSlidingMode = 0;

@interface SBGrabberTongue : NSObject
	-(UIGestureRecognizer *)edgePullGestureRecognizer;
@end

@interface SBFloatingDockRootViewController : UIViewController
	@property (nonatomic,retain) SBGrabberTongue * grabberTongue;
	-(UIGestureRecognizer *)screenEdgePanGestureRecognizer;
	-(void)_beginPresentationTransition;
	-(void)setPresentationProgress:(double)arg1 animated:(BOOL)arg111 interactive:(BOOL)arg2 withCompletion:(/*^block*/id)arg3 ;
	-(void)searchGesture:(id)arg1 completedShowing:(BOOL)arg2 ;
@end

@interface SBFloatingDockController : NSObject
	@property (nonatomic, retain) SBFloatingDockRootViewController *viewController;
@end

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

// Enable floating dock
%hook SBFloatingDockController
	+ (BOOL)isFloatingDockSupported {
		return YES;
	}

	- (BOOL)_systemGestureManagerAllowsFloatingDockGesture {
	if([[[self.viewController grabberTongue] edgePullGestureRecognizer] locationInView:((UIGestureRecognizer *)[[self.viewController grabberTongue] edgePullGestureRecognizer]).view].x < 180) {
		return YES;
	}
		return NO;
	}

%end

// Enable floating dock recent app / suggestion
%hook SBFloatingDockSuggestionsModel
	- (BOOL)_shouldProcessAppSuggestion:(id)arg1 {
		return NO;
	}

	- (BOOL)recentsEnabled {
		return YES;
	}
%end

// Set floating dock icons number
%hook SBFloatingDockIconListView
	+ (NSUInteger)maxIcons {
		return 6;
	}
	+ (NSUInteger)iconColumnsForInterfaceOrientation:(NSInteger)arg1 {
		return 6;
	}
	+ (NSUInteger)maxVisibleIconRowsInterfaceOrientation:(NSInteger)arg1 {
		return 6;
	}
%end

%hook SBDockIconListView
	+ (NSUInteger)maxIcons {
		return 6;
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