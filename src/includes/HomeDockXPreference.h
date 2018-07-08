/**
 * HomeDockXPreference
 */
@interface HomeDockXPreference : NSObject

@property(nonatomic) BOOL enableHomeGesture;
@property(nonatomic) BOOL enableDock;
@property(nonatomic) BOOL enableMedusa;

// home gesture
@property(nonatomic) BOOL noKeyboard;

// dock
@property(nonatomic) BOOL enableInAppDock;
@property(nonatomic) BOOL enableHomeButtonDismiss;
@property(nonatomic) BOOL enableDockSuggestion;
@property(nonatomic) BOOL showRecentApp;
@property(nonatomic) int  maxSuggestion;

// constructor
- (id)init;
- (BOOL)isBlacklisted:(NSString*)bundleIdentifier;

+ (HomeDockXPreference *)sharedInstance;

@end