/**
 * HomeDockXPreference
 */
@interface HomeDockXPreference : NSObject

@property(nonatomic) BOOL enableHomeGesture;
@property(nonatomic) BOOL enableDock;

// home gesture
@property(nonatomic) BOOL noKeyboard;

// dock
@property(nonatomic) BOOL enableInAppDock;
@property(nonatomic) BOOL enableHomeButtonDismiss;
@property(nonatomic) BOOL enableDockSuggestion;
@property(nonatomic) BOOL showRecentApp;
@property(nonatomic) int  maxSuggestion;

// constructor
- (id) init;

+ (HomeDockXPreference *)sharedInstance;

@end